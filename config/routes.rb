Rails.application.routes.draw do
  resources :data, only: [:index, :new] do
    collection {post :'import'}
  end
  root 'data#new'
  match 'data/show' => 'data#show', :via => :get
  match 'data/show_dispersion' => 'data#show_dispersion', :via => :get
  match 'data/show_average' => 'data#show_average', :via => :get
  match 'data/show_wilcoxon' => 'data#show_wilcoxon', :via => :get
  match 'data/show_unfiformity_average' => 'data#show_unfiformity_average', :via => :get
  match 'data/show_unfiformity_wilcoxon' => 'data#show_unfiformity_wilcoxon', :via => :get
end
