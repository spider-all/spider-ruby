require_relative "database"
require_relative "http"

if __FILE__ == $0
    puts "spider is running..."

    config = JSON.load File.open "config.json"
    db = DBSQ.new()
    req = Request.new(db, config.fetch("token", ""))
    req.request("https://#{HOST}/users/#{config.fetch("entry", "")}", RequestType::TypeUserinfo)

    while true
        users = db.List()
        for user in users
            req.request("https://#{HOST}/users/#{user}/following", RequestType::TypeFollowing)
            req.request("https://#{HOST}/users/#{user}/followers", RequestType::TypeFollowers)
            sleep 5
        end
    end
end
