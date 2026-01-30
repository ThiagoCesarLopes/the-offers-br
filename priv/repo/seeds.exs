# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Theoffersbr.Repo.insert!(%Theoffersbr.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Theoffersbr.{Repo, Catalog, Accounts}
alias Theoffersbr.Catalog.{Category, Store, Offer}
alias Theoffersbr.Accounts.{Profile, ProfileType, UserRole}

IO.puts("🌱 Iniciando seed do banco de dados...")

# Criar tipos de profile se não existirem
profile_types = [
  %{name: "Admin", description: "Administrador do sistema"},
  %{name: "Associado", description: "Afiliado/Associate"},
  %{name: "Cliente", description: "Cliente final"}
]

Enum.each(profile_types, fn attrs ->
  case Repo.get_by(ProfileType, name: attrs.name) do
    nil ->
      Repo.insert!(%ProfileType{} |> ProfileType.changeset(attrs))
      IO.puts("✅ Tipo de perfil criado: #{attrs.name}")
    _ ->
      nil
  end
end)

# Criar usuário admin com email thiago2012cesar@gmail.com
case Repo.get_by(Profile, email: "thiago2012cesar@gmail.com") do
  nil ->
    admin_profile = Repo.insert!(%Profile{
      display_name: "Thiago Cesar",
      email: "thiago2012cesar@gmail.com",
      avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=thiago",
      password_hash: Bcrypt.hash_pwd_salt("Tlopes#13"),
      is_active: true,
      created_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now()
    })

    # Associar perfil admin
    admin_type = Repo.get_by!(ProfileType, name: "Admin")
    Repo.insert!(%UserRole{
      profile_id: admin_profile.id,
      profile_type_id: admin_type.id,
      is_active: true,
      created_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now()
    })

    IO.puts("✅ Usuário admin criado: thiago2012cesar@gmail.com / Tlopes#13")

  _ ->
    IO.puts("⚠️ Usuário admin já existe")
end

# Criar categorias de produtos
categories = [
  %{name: "Eletrônicos", icon: "📱", is_active: true},
  %{name: "Casa e Jardim", icon: "🏠", is_active: true},
  %{name: "Moda e Acessórios", icon: "👕", is_active: true},
  %{name: "Esportes e Lazer", icon: "⚽", is_active: true},
  %{name: "Livros e Mídia", icon: "📚", is_active: true},
  %{name: "Beleza e Higiene", icon: "💄", is_active: true},
  %{name: "Brinquedos", icon: "🧸", is_active: true},
  %{name: "Alimentos e Bebidas", icon: "🍔", is_active: true}
]

Enum.each(categories, fn attrs ->
  case Repo.get_by(Category, name: attrs.name) do
    nil ->
      Repo.insert!(%Category{} |> Category.changeset(attrs))
      IO.puts("✅ Categoria criada: #{attrs.name}")
    _ ->
      nil
  end
end)

# Criar lojas de afiliados
stores = [
  %{name: "Amazon", store_type: :amazon, is_active: true, logo_url: "https://m.media-amazon.com/images/G/32/gno/sprites/nav-sprite-global-1.5x._CB469383346_.png"},
  %{name: "Shopee", store_type: :shopee, is_active: true, logo_url: "https://cf.shopee.com.br/file/shopee-logo"},
  %{name: "Mercado Livre", store_type: :mercado_livre, is_active: true, logo_url: "https://http2.mlstatic.com/frontend-assets/ui-navigation/5.24.17/mercado-libre-logo_x2.png"},
  %{name: "Magazine Luiza", store_type: :magazine_luiza, is_active: true, logo_url: "https://images.magazineluiza.com.br/images/OPS/ML.png"}
]

Enum.each(stores, fn attrs ->
  case Repo.get_by(Store, name: attrs.name) do
    nil ->
      Repo.insert!(%Store{} |> Store.changeset(attrs))
      IO.puts("✅ Loja criada: #{attrs.name}")
    _ ->
      nil
  end
end)

# Criar ofertas de exemplo
offers_data = [
  %{
    title: "iPhone 15 Pro Max 256GB",
    description: "Smartphone com câmera avançada e tela OLED",
    image_url: "https://via.placeholder.com/300x300?text=iPhone+15+Pro",
    original_price: Decimal.new("7999.99"),
    current_price: Decimal.new("6999.99"),
    discount: 12,
    affiliate_link: "https://amazon.com/ref/iphone15",
    commission_percentage: Decimal.new("3.5"),
    is_hot: true,
    is_active: true,
    store_name: "Amazon",
    category_name: "Eletrônicos",
    delivery_days: 3,
    store_rating: Decimal.new("4.8")
  },
  %{
    title: "Smart TV 55\" 4K Ultra HD",
    description: "Television LED 4K com sistema Android integrado",
    image_url: "https://via.placeholder.com/300x300?text=Smart+TV",
    original_price: Decimal.new("2499.99"),
    current_price: Decimal.new("1899.99"),
    discount: 24,
    affiliate_link: "https://shopee.com.br/ref/tv",
    commission_percentage: Decimal.new("5.0"),
    is_hot: true,
    is_active: true,
    store_name: "Shopee",
    category_name: "Eletrônicos",
    delivery_days: 5,
    store_rating: Decimal.new("4.6")
  },
  %{
    title: "Fone de Ouvido Bluetooth Premium",
    description: "Fone wireless com cancelamento de ruído ativo",
    image_url: "https://via.placeholder.com/300x300?text=Fone+Bluetooth",
    original_price: Decimal.new("899.99"),
    current_price: Decimal.new("599.99"),
    discount: 33,
    affiliate_link: "https://amazon.com/ref/fone",
    commission_percentage: Decimal.new("4.0"),
    is_hot: true,
    is_active: true,
    store_name: "Amazon",
    category_name: "Eletrônicos",
    delivery_days: 2,
    store_rating: Decimal.new("4.7")
  },
  %{
    title: "Notebook Dell Inspiron 15",
    description: "Laptop com processador Intel i7 e 16GB RAM",
    image_url: "https://via.placeholder.com/300x300?text=Notebook+Dell",
    original_price: Decimal.new("4499.99"),
    current_price: Decimal.new("3799.99"),
    discount: 15,
    affiliate_link: "https://mercadolivre.com.br/ref/notebook",
    commission_percentage: Decimal.new("6.0"),
    is_hot: true,
    is_active: true,
    store_name: "Mercado Livre",
    category_name: "Eletrônicos",
    delivery_days: 7,
    store_rating: Decimal.new("4.5")
  },
  %{
    title: "Cadeira Gamer Ergonômica",
    description: "Cadeira com suporte lombar ajustável",
    image_url: "https://via.placeholder.com/300x300?text=Cadeira+Gamer",
    original_price: Decimal.new("1299.99"),
    current_price: Decimal.new("899.99"),
    discount: 31,
    affiliate_link: "https://shopee.com.br/ref/cadeira",
    commission_percentage: Decimal.new("7.0"),
    is_active: true,
    store_name: "Shopee",
    category_name: "Casa e Jardim",
    delivery_days: 10,
    store_rating: Decimal.new("4.4")
  },
  %{
    title: "Mesa Gamer com Iluminação RGB",
    description: "Mesa com LED RGB integrado 120x60cm",
    image_url: "https://via.placeholder.com/300x300?text=Mesa+Gamer",
    original_price: Decimal.new("799.99"),
    current_price: Decimal.new("549.99"),
    discount: 31,
    affiliate_link: "https://amazon.com/ref/mesa",
    commission_percentage: Decimal.new("5.5"),
    is_active: true,
    store_name: "Amazon",
    category_name: "Casa e Jardim",
    delivery_days: 8,
    store_rating: Decimal.new("4.5")
  },
  %{
    title: "Camiseta Premium 100% Algodão",
    description: "Camiseta básica de alta qualidade",
    image_url: "https://via.placeholder.com/300x300?text=Camiseta",
    original_price: Decimal.new("149.99"),
    current_price: Decimal.new("79.99"),
    discount: 47,
    affiliate_link: "https://shopee.com.br/ref/camiseta",
    commission_percentage: Decimal.new("8.0"),
    is_active: true,
    store_name: "Shopee",
    category_name: "Moda e Acessórios",
    delivery_days: 4,
    store_rating: Decimal.new("4.6")
  },
  %{
    title: "Livro Clean Code",
    description: "A Handbook of Agile Software Craftsmanship",
    image_url: "https://via.placeholder.com/300x300?text=Clean+Code",
    original_price: Decimal.new("89.99"),
    current_price: Decimal.new("59.99"),
    discount: 33,
    affiliate_link: "https://amazon.com/ref/cleancode",
    commission_percentage: Decimal.new("4.5"),
    is_active: true,
    store_name: "Amazon",
    category_name: "Livros e Mídia",
    delivery_days: 3,
    store_rating: Decimal.new("4.7")
  }
]

Enum.each(offers_data, fn offer_attrs ->
  category = Repo.get_by!(Category, name: offer_attrs.category_name)
  store = Repo.get_by!(Store, name: offer_attrs.store_name)

  case Repo.get_by(Offer, title: offer_attrs.title) do
    nil ->
      offer_attrs_db = Map.merge(offer_attrs, %{
        category_id: category.id,
        store_id: store.id,
        created_at: DateTime.utc_now(),
        updated_at: DateTime.utc_now()
      })

      Repo.insert!(%Offer{} |> Offer.changeset(offer_attrs_db))
      IO.puts("✅ Oferta criada: #{offer_attrs.title}")

    _ ->
      nil
  end
end)

IO.puts("\n✅ Seed concluído com sucesso!")
IO.puts("📧 Email: thiago2012cesar@gmail.com")
IO.puts("🔑 Senha: Tlopes#13")
