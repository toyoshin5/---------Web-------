# coding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'data.db'
)
class LabMember < ActiveRecord::Base
end
class Lab < ActiveRecord::Base
end 
get '/' do
    @title = 'Login Form' 
    @world = 'World!'
    erb :index
end
post '/lab_search' do
    if !Lab.where(:lab_name => params[:lab_name]).empty?
        lab = Lab.where(:lab_name => params[:lab_name]).first
        @lab_members = LabMember.where(:lab_id => lab.id)
        erb :lab_search
    else
        redirect '/'
    end
end
post '/member_search' do
    if !LabMember.where(:member_name => params[:member_name]).empty?
        member = LabMember.where(:member_name => params[:member_name]).first
        @lab_members = LabMember.where(:lab_id => member.lab_id).where.not(:member_name => params[:member_name])
        erb :member_search
    else
        redirect '/'
    end
end

