defmodule Blog.Schema do
  use Absinthe.Schema
  import_types Blog.Schema.Types
 
  query do
    field :posts, list_of(:post) do
      resolve &Blog.PostResolver.all/2
    end
  end
end