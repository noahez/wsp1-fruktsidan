require 'debug'
require "awesome_print"

class App < Sinatra::Base
    register Sinatra::Reloader

    def db
      return @db if @db

      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true

      return @db
    end
  get '/fruits' do
    @fruits = db.execute('SELECT * FROM products')
   ap @fruits
  erb(:"fruits/index")


  # Ruby koden för vad som ska vara i HTTP response här
  end
  get '/fruits/:id' do | id |
    @fruit = db.execute('SELECT * FROM products WHERE id=?',id).first 
    ap @fruit
    erb(:"fruits/show")
  end

  post '/fruits/:id/delete' do | id |
    db.execute('DELETE FROM products WHERE id=?' , id)
    redirect("/fruits")
  end
    

end

