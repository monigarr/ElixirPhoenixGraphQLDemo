defmodule Blog.PostResolver do
  alias Blog.Post
  
  def all(_args, _info) do
    {:ok, Blog.Repo.all(Post)}
  end
end