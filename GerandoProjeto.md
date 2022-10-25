
# Como gerar o projeto Rails

## Tratando erros de permissão de usuário

O Docker cria os arquivos com uma permissão diferente de seu sistema, execute este comando sempre que retornar o erro `permission denied` repetindo novamente o último comando

```
sudo chown -R $USER:$USER .
```
Depois que gerar o banco, o Dockerfile deve criar um grupo para não ocorrer novamente erros assim


## Gerar o projeto
Responda sim, para substituir o  `README.md` e `Gemfile`

```
docker compose run web rails new .
```


```
No gemfile, atualize a gema do Webpacker (Transpilador para Javascript) manualmente para 5. 
(A 7 perdeu a compatibilidade)

gem 'webpacker', '~> 5.0'
```

Repita o Build do Projeto, para gerar uma imagem com as gemas instaladas
```
docker compose build web
docker compose run web rails webpacker:install
```

## Executando o projeto
```
docker compose up web
```

## Acessando o container
```
docker compose run web bash
```

## Criando o primeiro CRUD
```
rails generate scaffold post title:string content:text
rails db:migrate
```

## Adicionando Bootstrap
https://getbootstrap.com/
```
<!-- CSS only -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">

<!-- JavaScript Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
```

> Provaremos substituindo os helper link_to para button_to

> Adicione um container no application html
```ruby
    <div class="container">
      <%= yield %>
    </div>
```
> Adicione as classes nos botões

> Explique a partial _form e aplique o boostrap


```ruby
  <div class="mb-3">
    <%= form.label :title, class: 'form-label' %>
    <%= form.text_field :title, class: 'form-control' %>
  </div>

  <div class="mb-3">
    <%= form.label :content, class: 'form-label' %>
    <%= form.text_field :content, class: 'form-control' %>
  </div>

  <div class="actions">
    <%= form.submit 'Submit', class:"btn btn-success" %>
  </div>
```


## BUG Post sem titulo

```ruby
validates_presence_of :title
```

## Adicionando pacote yarn  action_text

```
rails action_text:install
rails db:migrate
```

```ruby
# atualizar model
has_rich_text :content
# atualizar forms
<%= form.rich_text_area :content, class: 'form-control' %>
```

## Scafold para gerar comentários
```
docker compose run web bash
rails g resource comment post:references content:text
rails db:migrate
```

mostre os comentários e indique que um post possa ter muitos comentários
```
has_many :comments
```

> mostre o rails console
```
x = Comment.create
x.save
```

> Configura a rota
```ruby
resources :posts do
  resources :comments
end
```

> crie a controller comment
```ruby
class CommentsController < ApplicationController
    before_action :set_post

    def create
        @post.comments.create! params.required(:comment).permit(:content)
        redirect_to @post
    end

    private
    def set_post
        @post = Post.find(params[:post_id])
    end
end

```

>Crie a visualização na tela
> show.html
```ruby
<%= render "posts/comments", post: @post %>
```

> Cole as três partials
> _comment.html.erb
```ruby
<div>
    <%= raw(comment.content) %>
</div>
```
> _new.html.erb
```ruby
<%= form_with model: [ post, Comment.new ] do |form| %>
    Comentários:<br>
    <%= form.rich_text_area :content, size: "20x5" %>
    <%= form.submit %>
<% end %>
```
 
> _comments.html.erb
```ruby
<h2>Comentários</h2>
<%= render post.comments %>
<%= render "comments/new", post: post %>
```