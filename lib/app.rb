require_relative 'app/models/idea'
require_relative 'app/models/idea_store'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  get '/' do
    haml :index, locals: {ideas: IdeaStore.all.sort, idea: Idea.new(params)}
  end

  get '/existing' do
    haml :existing, locals: {ideas: IdeaStore.all.sort, idea: Idea.new(params)}
  end

  post '/' do
    IdeaStore.create(params[:idea])
    redirect '/existing'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/existing'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    haml :edit, locals: {ideas: IdeaStore.all.sort, idea: Idea.new(params)}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/existing'
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/existing'
  end

  helpers do
    def format_rank(idea)
      "Rank: #{idea.rank}"
    end
  end
end
