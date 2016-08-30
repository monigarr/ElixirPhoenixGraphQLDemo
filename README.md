# Mobile Backend with Absinthe Elixir GraphQL Phoenix #

Absinthe is a toolkit for building GraphQL APIs with Elixir.

Elixir is a dynamic functional language designed for building and maintaining scalable applications.

GraphQL is a data-fetching api that is designed and used by Facebook to request & deliver data to mobile and web apps.

Phoenix is a web development framework written in Elixir. 

## Create Blog ##
```
mix phoenix.new blog
cd blog
mix ecto.create
mix phoenix.gen.html Post posts title:string body:text
```

## Add Post Resources ##
Add following code to web/router.ex
```
scope "/", Blog do
    pipe_through :browser # Use the default browser stack
 
    get "/", PageController, :index
 
    resources "/posts", PostController
  end
```
  
## Migrate Database ##
```
mix ecto.migrate

## Start Phoenix Server ##
```
iex -S mix phoenix.server

## View in Web Browser ##
open http://localhost:4000/posts
Create a few new posts

## Add Absinthe ##
add following code to mix.exs
```
  defp deps do
    [{:phoenix, "~> 1.2.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, "> = 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:absinthe, "~> 1.1.0"},
     {:absinthe_plug, "~> 1.1"}
    ]
  end
```

## Add Absinthe & Absinthe Plug ##
```
 def application do
    [mod: {Blog, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :absinthe, :absinthe_plug]]
  end
```

## Get Dependencies ##
```
mix deps.get
```

## Create web/schema/types.ex ##
Create new file 
Add following code to the file:
```
defmodule Blog.Schema.Types do
  use Absinthe.Schema.Notation
 
  object :post do
    field :id, :id
    field :title, :string
    field :body, :string
  end
end
```

## Create web/schema.ex ##
Add following code:
```
defmodule Blog.Schema do
  use Absinthe.Schema
  import_types Blog.Schema.Types
 
  query do
    field :posts, list_of(:post) do
      resolve &amp;Blog.PostResolver.all/2
    end
  end
end
```

## Create web/resolvers/post_resolver.ex ##
Add following code
```
defmodule Blog.PostResolver do
  alias Blog.Post
  
  def all(_args, _info) do
    {:ok, Blog.Repo.all(Post)}
  end
end
```

## Add GraphQL routes ##
Add following code to web/router.ex
```
  scope "/", Blog do
    pipe_through :browser # Use the default browser stack
 
    get "/", PageController, :index
 
    resources "/posts", PostController
 
  end
 
  get "/graphql", Absinthe.Plug.GraphiQL, schema: Blog.Schema
  forward "/graphql", Absinthe.Plug, schema: Blog.Schema
```

## Restart Phoenix Server ##
```
iex -S mix phoenix.server
```

## Test Query in Web Browser ##
In web browser: http://localhost:4000/graphql

Add Query to top left of the webpage 
```
query {
    posts {
      id
     title
   }
```

## Test Query in Terminal ##
```
curl --data "query { posts {id title }}" -H Content-Type:application/graphql -X POST http://localhost:4000/graphql
```

## Resources ##
- [Absinthe  GraphQL & Elixir]: (http://absinthe-graphql.org)
- [GraphQL: A data query language]: (https://code.facebook.com/posts/1691455094417024/graphql-a-data-query-language/) 
- [GraphQL]: data query language & runtime]: (http://graphql.org)
- [Phoenix Framework]: (http://www.phoenixframework.org/docs/up-and-running) 
- [Elixir]: (http://elixir-lang.org) 
- [Absinthe]: (https://hexdocs.pm/absinthe/Absinthe.html) 
- [Ecto]: (http://hexdocs.pm/ecto)
- [Phoenix]: (http://hexdocs.pm/phoenix) 
- [Plug]: (http://hexdocs.pm/plug)
