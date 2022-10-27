# coding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'time'
enable :sessions # セッションを有効にする
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'bulletinBoard.db'
)
class Passwd < ActiveRecord::Base
end 
class Message < ActiveRecord::Base
end

#投稿のクラス
class Posts 
    attr_accessor :id,:user_id,:user_name, :msg, :date ,:date_relative
    def initialize(id,user_id,user_name, msg, date)
        @id = id
        @user_id = user_id
        @user_name = user_name
        @msg = msg
        @date = date
        @date_relative = relative_time(date)
    end
    def relative_time(date)
        date = Time.parse(date)
        diff = Time.now - date
        if diff < 60
            return "#{diff.to_i}秒前"
        elsif diff < 3600
            return "#{(diff/60).to_i}分前"
        elsif diff < 86400
            return "#{(diff/3600).to_i}時間前"
        elsif diff < 604800
            return "#{(diff/86400).to_i}日前"
        else
            return date.strftime("%Y/%m/%d %H:%M")
        end
    end
end

get '/login' do
    erb :index
end

post '/login' do
    user = params[:user]
    password = params[:password]
    #ユーザidとパスワードが一致したらresにユーザidを入れる
    @res = Passwd.where(:user => user, :password => password).first
    redirect '/login' if @res.nil?#@resがnilだと /loginにリダイレクト
    session[:user_id] = @res['id'].to_i  #@res['id'].to_iは@res['id']と取得されるデータが文字列なので整数に変換してsession[:user_id]に代入している。これでsessionに現在ログインしているuserが保持される。
    redirect '/'
end

#メイン画面
get '/' do
    #セッションにuser_idがあるかどうかでログインしているかどうかを判断している
    if session[:user_id].nil?
        redirect '/login'
    else
        @now_user_id = session[:user_id]
        @now_user_name = Passwd.where(:id => @now_user_id).first.user
        messages = Message.all
        #投稿一覧を初期化
        @posts = []
        #メッセージとユーザ名取得して投稿一覧に代入
        messages.each do |message|
            user = Passwd.where(:id => message.user_id).first.user
            @posts << Posts.new(message.id,message.user_id,user, message.msg, message.date)
        end
        erb :bulletinboard
    end
end


post '/post' do
    user_id = session[:user_id]
    redirect '/' if params[:message].empty?
    #メッセージを保存
    Message.create(:user_id => user_id, :msg => params[:message], :date => Time.now)

    redirect '/'
end

post '/delete' do
    #削除するメッセージのidを取得
    delete_id = params[:delete_id]
    #削除
    Message.delete(delete_id)

    redirect '/'
end

post '/logout' do
    session[:user_id] = nil
    redirect '/login'
end

