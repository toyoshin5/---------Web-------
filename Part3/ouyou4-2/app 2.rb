# coding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'time'
require 'open-uri'
enable :sessions # セッションを有効にする
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'Bookmarks.db'
)
class Passwd < ActiveRecord::Base
end 
class Url < ActiveRecord::Base
end

#ブックマークのクラス
class BookMark
    attr_accessor :id,:url,:title
    def initialize(id,url)
        @id = id
        @url = url
        @title = get_title(url)
    end
    #URLからWebページのタイトルを取得する
    def get_title(url)
        URI.open(url) do |f|
            f.each_line do |line|
                if line =~ /<title>(.*)<\/title>/
                    return $1
                end
            end
        end
    end
end

get '/login' do
    #ログインに失敗したらエラーメッセージを表示
    if session[:error]
        @error = session[:error]
        session[:error] = nil
    end
    erb :index
end

post '/login' do
    user = params[:user]
    password = params[:password]
    #パスワードをハッシュ化
    password = Digest::SHA256.hexdigest(password)
    #ユーザidとパスワードが一致したらresにユーザidを入れる
    @res = Passwd.where(:user => user, :password => password).first
    if @res 
        session[:user_id] = @res['id'].to_i  #@res['id'].to_iは@res['id']と取得されるデータが文字列なので整数に変換してsession[:user_id]に代入している。これでsessionに現在ログインしているuserが保持される。
        redirect '/'
    else
        session[:error] = "ユーザ名またはパスワードが違います"
        redirect '/login' #@resがnilだと /loginにリダイレクト
    end
end

#メイン画面
get '/' do
    #セッションにuser_idがあるかどうかでログインしているかどうかを判断している
    if session[:user_id].nil?
        redirect '/login'
    else
        now_user_id = session[:user_id]
        @now_user_name = Passwd.where(:id => now_user_id).first.user
        urls = Url.where(:user_id => now_user_id)
        #投稿一覧を初期化
        @bookMarks = []
        #メッセージとユーザ名取得して投稿一覧に逆順で代入
        urls.reverse_each do |url|
            @bookMarks.push(BookMark.new(url.id,url.url))
        end
        erb :weblist
    end
end


post '/post' do
    user_id = session[:user_id]
    redirect '/' if params[:url].empty?
    #メッセージを保存
    Url.create(:user_id => user_id, :url => params[:url])
    redirect '/'
end

post '/delete' do
    #削除するメッセージのidを取得
    delete_id = params[:delete_id]
    #削除
    Url.delete(delete_id)
    redirect '/'
end

post '/logout' do
    session[:user_id] = nil
    redirect '/login'
end


#id,user_id,url,