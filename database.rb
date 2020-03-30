require "sqlite3"

class DBSQ
    def initialize()
        @db = SQLite3::Database.new "spider.db"
        @db.execute "CREATE TABLE IF NOT EXISTS `users` (`id` INTEGER PRIMARY KEY, `login` TEXT NOT NULL)"
    end

    def Create(user)
        puts user
        begin
            @db.execute "INSERT OR REPLACE INTO `users` (`id`, `login`) VALUES (?, ?)", [user.id, user.login]
        rescue Exception => e
            puts e.inspect
        end
    end

    def List()
        result = []
        content = @db.query("SELECT `login` FROM `users` ORDER BY random() limit 100")
        while true
            con = content.next
            if con
                result.append(con[0])
            else
                break
            end
        end
        return result
    end
end
