# coding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
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
    attr_accessor :user, :msg, :date
    def initialize(user, msg, date)
        @user = user
        @msg = msg
        @date = date
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
        user_id = session[:user_id]
        @user = Passwd.where(:id => user_id).first.user
        messages = Message.all
        #投稿一覧を初期化
        @posts = []
        #メッセージとユーザ名取得して投稿一覧に代入
        messages.each do |message|
            user = Passwd.where(:id => message.user_id).first.user
            @posts << Posts.new(user, message.msg, message.date)
        end
        erb :bulletinboard
    end
end

post '/post' do
    user_id = session[:user_id]
    redirect '/' if params[:msg].empty?
    #メッセージを保存
    Message.create(:user_id => user_id, :msg => params[:msg], :date => Time.now)

    redirect '/'
end

post '/logout' do
    session[:user_id] = nil
    redirect '/login'
end

# post '/lab_search' do
#     if !Lab.where(:lab_name => params[:lab_name]).empty?
#         lab = Lab.where(:lab_name => params[:lab_name]).first
#         @lab_members = LabMember.where(:lab_id => lab.id)
#         erb :lab_search
#     else
#         redirect '/'
#     end
# end
# post '/member_search' do
#     if !LabMember.where(:member_name => params[:member_name]).empty?
#         member = LabMember.where(:member_name => params[:member_name]).first
#         @lab_members = LabMember.where(:lab_id => member.lab_id).where.not(:member_name => params[:member_name])
#         erb :member_search
#     else
#         redirect '/'
#     end
# end

# get '/seiseki' do
#     @title = 'Seiseki View'
#     @students = LabMember.all
#     erb :lab_search
# end
