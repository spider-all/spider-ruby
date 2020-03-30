require "json"
require "net/https"
require "uri"

require_relative "constants"
require_relative "database"
require_relative "table"

class Request
    def initialize(db, token)
        @db = db
        @token = token
    end
    def request(url, type)
        begin
            uri = URI.parse(url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            request = Net::HTTP::Get.new(uri.request_uri)
            request["User-Agent"] = USERAGENT
            request['Authorization'] = "Bearer #{@token}"
            request["Accept"] = "application/json"
            request["Host"] = HOST
            request["Time-Zone"] = TIMEZONE
            res = http.request(request)
        rescue StandardError => e
            puts "error request: #{e.inspect}"
            return
        end
        if res.code != "200"
            puts "response code: #{res.code}"
            return
        end
        data = JSON.parse res.body
        if type == RequestType::TypeUserinfo
            user = User.new(id: data.fetch("id", 0), login: data.fetch("login", ""))
            @db.Create(user)
        elsif RequestType::TypeFollowing || RequestType::TypeFollowers
            for d in data
                user = User.new(id: d.fetch("id", 0), login: d.fetch("login", ""))
                @db.Create(user)
            end
            link = self.headerLink(res["link"])
            if link != ""
                sleep 3
                self.request(link, type)
            end
        end
    end

    def headerLink(headers)
        if !headers
            return ""
        end
        for str in headers.split(", ")
            s = str.split("; ")
            if s[1] == 'rel="next"'
                return s[0][1..-2]
            end
        end
        return ""
    end
end
