# Script for populating the database.
# Run with: mix run priv/repo/seeds.exs

alias TheOffersBr.{Repo, Accounts}
alias Theoffersbr.Catalog.{Category, Store, Offer}
alias Theoffersbr.Accounts.{Profile, ProfileType, UserRole}

IO.puts("🌱 Iniciando seed do banco de dados...")

# Criar tipos de profile
profile_type_admin = case Repo.get_by(ProfileType, name: "Admin") do
  nil ->
    Repo.insert!(%ProfileType{id: Ecto.UUID.generate(), name: "Admin"})
  existing ->
    existing
end

_profile_type_associado = case Repo.get_by(ProfileType, name: "Associado") do
  nil ->
    Repo.insert!(%ProfileType{id: Ecto.UUID.generate(), name: "Associado"})
  existing ->
    existing
end

_profile_type_cliente = case Repo.get_by(ProfileType, name: "Cliente") do
  nil ->
    Repo.insert!(%ProfileType{id: Ecto.UUID.generate(), name: "Cliente"})
  existing ->
    existing
end

# Criar usuário admin
unless Repo.get_by(Profile, email: "thiago2012cesar@gmail.com") do
  admin = Repo.insert!(%Profile{
    id: Ecto.UUID.generate(),
    display_name: "Thiago Cesar",
    email: "thiago2012cesar@gmail.com",
    avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=thiago",
    password_hash: "Tlopes#13",
    first_login: true,
    profile_type_id: profile_type_admin.id
  })

  Repo.insert!(%UserRole{
    user_id: admin.id,
    role: :admin
  })

  IO.puts("✅ Admin: thiago2012cesar@gmail.com / Tlopes#13")
end

# Criar categorias
categories_list = [
  {Ecto.UUID.generate(), "Eletrônicos", "📱"},
  {Ecto.UUID.generate(), "Casa e Jardim", "🏠"},
  {Ecto.UUID.generate(), "Moda e Acessórios", "👕"},
  {Ecto.UUID.generate(), "Esportes e Lazer", "⚽"},
  {Ecto.UUID.generate(), "Livros e Mídia", "📚"},
  {Ecto.UUID.generate(), "Beleza e Higiene", "💄"},
  {Ecto.UUID.generate(), "Brinquedos", "🧸"},
  {Ecto.UUID.generate(), "Alimentos e Bebidas", "🍔"}
]

Enum.each(categories_list, fn {id, name, icon} ->
  unless Repo.get_by(Category, name: name) do
    Repo.insert!(%Category{
      id: id,
      name: name,
      icon: icon,
      is_active: true
    })
    IO.puts("✅ Categoria: #{name}")
  end
end)

# Criar lojas
stores_list = [
  {Ecto.UUID.generate(), "Amazon", :amazon},
  {Ecto.UUID.generate(), "Shopee", :shopee},
  {Ecto.UUID.generate(), "Mercado Livre", :mercadolivre},
  {Ecto.UUID.generate(), "Magazine Luiza", :magalu}
]

Enum.each(stores_list, fn {id, name, store_type} ->
  unless Repo.get_by(Store, name: name) do
    Repo.insert!(%Store{
      id: id,
      name: name,
      store_type: store_type,
      is_active: true
    })
    IO.puts("✅ Loja: #{name}")
  end
end)

# Criar ofertas de exemplo
cat_eletronicos = Repo.get_by!(Category, name: "Eletrônicos")
cat_casa = Repo.get_by!(Category, name: "Casa e Jardim")
cat_moda = Repo.get_by!(Category, name: "Moda e Acessórios")
cat_livros = Repo.get_by!(Category, name: "Livros e Mídia")

store_amazon = Repo.get_by!(Store, name: "Amazon")
store_shopee = Repo.get_by!(Store, name: "Shopee")
store_ml = Repo.get_by!(Store, name: "Mercado Livre")

offers_list = [
  %{
    title: "iPhone 15 Pro Max 256GB",
    description: "Smartphone Apple com câmera avançada e chip A17 Pro",
    image_url: "https://images.unsplash.com/photo-1592286927505-2c6c083d28c0?w=400",
    original_price: Decimal.new("7999.99"),
    current_price: Decimal.new("6999.99"),
    discount: 12,
    store_type: :amazon,
    affiliate_link: "https://amazon.com.br/iphone15",
    is_hot: true,
    category_id: cat_eletronicos.id,
    store_id: store_amazon.id,
    delivery_days: 3,
    store_rating: Decimal.new("4.8"),
    installments: 12,
    commission_percentage: Decimal.new("3.5")
  },
  %{
    title: "Smart TV 55\" 4K Samsung",
    description: "TV LED 4K com HDR e Smart Tizen",
    image_url: "https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400",
    original_price: Decimal.new("2499.99"),
    current_price: Decimal.new("1899.99"),
    discount: 24,
    store_type: :shopee,
    affiliate_link: "https://shopee.com.br/tv-samsung",
    is_hot: true,
    category_id: cat_eletronicos.id,
    store_id: store_shopee.id,
    delivery_days: 5,
    store_rating: Decimal.new("4.6"),
    installments: 10,
    commission_percentage: Decimal.new("5.0")
  },
  %{
    title: "Fone Bluetooth Sony WH-1000XM5",
    description: "Cancelamento de ruído premium",
    image_url: "https://images.unsplash.com/photo-1545127398-14699f92334b?w=400",
    original_price: Decimal.new("1899.99"),
    current_price: Decimal.new("1299.99"),
    discount: 32,
    store_type: :amazon,
    affiliate_link: "https://amazon.com.br/sony-fone",
    is_hot: false,
    category_id: cat_eletronicos.id,
    store_id: store_amazon.id,
    delivery_days: 2,
    store_rating: Decimal.new("4.9"),
    installments: 12,
    commission_percentage: Decimal.new("4.0")
  },
  %{
    title: "Notebook Dell Inspiron i7",
    description: "16GB RAM, SSD 512GB, Tela 15.6\"",
    image_url: "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400",
    original_price: Decimal.new("4499.99"),
    current_price: Decimal.new("3299.99"),
    discount: 27,
    store_type: :mercadolivre,
    affiliate_link: "https://mercadolivre.com.br/notebook-dell",
    is_hot: true,
    category_id: cat_eletronicos.id,
    store_id: store_ml.id,
    delivery_days: 7,
    store_rating: Decimal.new("4.5"),
    installments: 12,
    commission_percentage: Decimal.new("6.0")
  },
  %{
    title: "Cadeira Gamer RGB",
    description: "Suporte lombar, reclinável até 180°",
    image_url: "https://images.unsplash.com/photo-1598550476439-6847785fcea6?w=400",
    original_price: Decimal.new("1299.99"),
    current_price: Decimal.new("799.99"),
    discount: 38,
    store_type: :shopee,
    affiliate_link: "https://shopee.com.br/cadeira-gamer",
    is_hot: false,
    category_id: cat_casa.id,
    store_id: store_shopee.id,
    delivery_days: 10,
    store_rating: Decimal.new("4.4"),
    installments: 10,
    commission_percentage: Decimal.new("7.0")
  },
  %{
    title: "Mesa Gamer com LED RGB",
    description: "120x60cm, suporte para monitor",
    image_url: "https://images.unsplash.com/photo-1595515106969-1ce29566ff1c?w=400",
    original_price: Decimal.new("899.99"),
    current_price: Decimal.new("549.99"),
    discount: 39,
    store_type: :amazon,
    affiliate_link: "https://amazon.com.br/mesa-gamer",
    is_hot: false,
    category_id: cat_casa.id,
    store_id: store_amazon.id,
    delivery_days: 8,
    store_rating: Decimal.new("4.5"),
    installments: 6,
    commission_percentage: Decimal.new("5.5")
  },
  %{
    title: "Camiseta Premium 100% Algodão",
    description: "Diversas cores disponíveis",
    image_url: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400",
    original_price: Decimal.new("129.99"),
    current_price: Decimal.new("59.99"),
    discount: 54,
    store_type: :shopee,
    affiliate_link: "https://shopee.com.br/camiseta",
    is_hot: false,
    category_id: cat_moda.id,
    store_id: store_shopee.id,
    delivery_days: 4,
    store_rating: Decimal.new("4.6"),
    installments: 3,
    commission_percentage: Decimal.new("8.0")
  },
  %{
    title: "Livro: Clean Code",
    description: "Robert C. Martin - Código Limpo",
    image_url: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400",
    original_price: Decimal.new("89.99"),
    current_price: Decimal.new("54.99"),
    discount: 39,
    store_type: :amazon,
    affiliate_link: "https://amazon.com.br/clean-code",
    is_hot: false,
    category_id: cat_livros.id,
    store_id: store_amazon.id,
    delivery_days: 3,
    store_rating: Decimal.new("4.9"),
    installments: 2,
    commission_percentage: Decimal.new("4.5")
  }
]

Enum.each(offers_list, fn attrs ->
  unless Repo.get_by(Offer, title: attrs.title) do
    %Offer{}
    |> Offer.changeset(Map.put(attrs, :id, Ecto.UUID.generate()))
    |> Repo.insert!()
    IO.puts("✅ Oferta: #{attrs.title}")
  end
end)

IO.puts("\n✅ Seed concluído!")
IO.puts("📧 Admin: thiago2012cesar@gmail.com")
IO.puts("🔑 Senha: Tlopes#13")
