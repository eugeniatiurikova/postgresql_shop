PGDMP         (                {            shop #   14.7 (Ubuntu 14.7-0ubuntu0.22.04.1)    15.1 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    73885    shop    DATABASE     p   CREATE DATABASE shop WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'ru_RU.UTF-8';
    DROP DATABASE shop;
                postgres    false            �           0    0    DATABASE shop    ACL     '   GRANT ALL ON DATABASE shop TO gb_user;
                   postgres    false    3544                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            �           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    4            �            1255    131446     customer_cart_total_sum(integer)    FUNCTION       CREATE FUNCTION public.customer_cart_total_sum(input_user_id integer, OUT total bigint) RETURNS bigint
    LANGUAGE sql
    AS $$
SELECT DISTINCT SUM(product_count * price) OVER()
	FROM cart
		JOIN products
		ON product_id = products.id
WHERE user_id = input_user_id;
$$;
 W   DROP FUNCTION public.customer_cart_total_sum(input_user_id integer, OUT total bigint);
       public          gb_user    false    4            �            1255    122880    customer_with_more_orders()    FUNCTION     a  CREATE FUNCTION public.customer_with_more_orders(OUT user_id bigint, OUT orders_total bigint) RETURNS record
    LANGUAGE sql
    AS $$
SELECT DISTINCT
	user_id, 
	COUNT(user_id) OVER (PARTITION BY orders.user_id) AS orders_by_user
	FROM orders
	JOIN ordered_products
		ON orders.id = ordered_products.order_id
ORDER BY orders_by_user DESC LIMIT 1;
$$;
 ]   DROP FUNCTION public.customer_with_more_orders(OUT user_id bigint, OUT orders_total bigint);
       public          gb_user    false    4            �            1259    131286    brands    TABLE       CREATE TABLE public.brands (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    logo_url character varying(250),
    description character varying(250),
    site_url character varying(250),
    added_at timestamp without time zone NOT NULL
);
    DROP TABLE public.brands;
       public         heap    gb_user    false    4            �            1259    131285    brands_id_seq    SEQUENCE     �   CREATE SEQUENCE public.brands_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.brands_id_seq;
       public          gb_user    false    239    4            �           0    0    brands_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.brands_id_seq OWNED BY public.brands.id;
          public          gb_user    false    238            �            1259    90166    cart    TABLE     �   CREATE TABLE public.cart (
    id integer NOT NULL,
    user_id integer NOT NULL,
    product_id integer NOT NULL,
    product_count integer NOT NULL,
    discount_id integer,
    added_at timestamp without time zone
);
    DROP TABLE public.cart;
       public         heap    gb_user    false    4            �            1259    90165    cart_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.cart_id_seq;
       public          gb_user    false    226    4            �           0    0    cart_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.cart_id_seq OWNED BY public.cart.id;
          public          gb_user    false    225            �            1259    90173    products    TABLE       CREATE TABLE public.products (
    id integer NOT NULL,
    rubric_id integer NOT NULL,
    name character varying(120) NOT NULL,
    description character varying(120),
    main_photo_id integer NOT NULL,
    brand_id integer NOT NULL,
    size character varying(10) NOT NULL,
    color character varying(50) NOT NULL,
    season character varying(50) NOT NULL,
    price double precision NOT NULL,
    count_available integer,
    product_discount integer,
    updated_at timestamp without time zone,
    type_id integer NOT NULL
);
    DROP TABLE public.products;
       public         heap    gb_user    false    4            �            1259    131440    cart_with_sums    VIEW     �  CREATE VIEW public.cart_with_sums AS
 SELECT cart.user_id,
    cart.product_id,
    cart.product_count,
    products.price,
    ((cart.product_count)::double precision * products.price) AS total,
    sum(((cart.product_count)::double precision * products.price)) OVER (PARTITION BY cart.user_id) AS grand_total
   FROM (public.cart
     JOIN public.products ON ((cart.product_id = products.id)));
 !   DROP VIEW public.cart_with_sums;
       public          gb_user    false    226    226    226    228    228    4            �            1259    90141 	   discounts    TABLE     �   CREATE TABLE public.discounts (
    id integer NOT NULL,
    discount character varying(120) NOT NULL,
    percent integer NOT NULL
);
    DROP TABLE public.discounts;
       public         heap    gb_user    false    4            �            1259    90140    discounts_id_seq    SEQUENCE     �   CREATE SEQUENCE public.discounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.discounts_id_seq;
       public          gb_user    false    4    222            �           0    0    discounts_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.discounts_id_seq OWNED BY public.discounts.id;
          public          gb_user    false    221            �            1259    90216    ordered_products    TABLE     �   CREATE TABLE public.ordered_products (
    product_id integer NOT NULL,
    count integer NOT NULL,
    order_id integer NOT NULL
);
 $   DROP TABLE public.ordered_products;
       public         heap    gb_user    false    4            �            1259    90200    orders    TABLE     �   CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    status integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);
    DROP TABLE public.orders;
       public         heap    gb_user    false    4            �            1259    90199    orders_id_seq    SEQUENCE     �   CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.orders_id_seq;
       public          gb_user    false    230    4            �           0    0    orders_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;
          public          gb_user    false    229            �            1259    90207    orders_statuses    TABLE     l   CREATE TABLE public.orders_statuses (
    id integer NOT NULL,
    status character varying(50) NOT NULL
);
 #   DROP TABLE public.orders_statuses;
       public         heap    gb_user    false    4            �            1259    90206    orders_statuses_id_seq    SEQUENCE     �   CREATE SEQUENCE public.orders_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.orders_statuses_id_seq;
       public          gb_user    false    4    232            �           0    0    orders_statuses_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.orders_statuses_id_seq OWNED BY public.orders_statuses.id;
          public          gb_user    false    231            �            1259    90132 	   passwords    TABLE     �   CREATE TABLE public.passwords (
    id integer NOT NULL,
    user_id integer NOT NULL,
    password_token character varying(120) NOT NULL,
    expires_at timestamp without time zone
);
    DROP TABLE public.passwords;
       public         heap    gb_user    false    4            �            1259    90131    passwords_id_seq    SEQUENCE     �   CREATE SEQUENCE public.passwords_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.passwords_id_seq;
       public          gb_user    false    4    220            �           0    0    passwords_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.passwords_id_seq OWNED BY public.passwords.id;
          public          gb_user    false    219            �            1259    90150    payment_methods    TABLE     �   CREATE TABLE public.payment_methods (
    id integer NOT NULL,
    discount_id integer,
    method character varying(120) NOT NULL
);
 #   DROP TABLE public.payment_methods;
       public         heap    gb_user    false    4            �            1259    90149    payment_methods_id_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_methods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.payment_methods_id_seq;
       public          gb_user    false    224    4            �           0    0    payment_methods_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.payment_methods_id_seq OWNED BY public.payment_methods.id;
          public          gb_user    false    223            �            1259    131393    payments_users    TABLE     f   CREATE TABLE public.payments_users (
    user_id integer NOT NULL,
    payment_id integer NOT NULL
);
 "   DROP TABLE public.payments_users;
       public         heap    gb_user    false    4            �            1259    131252    product_photos    TABLE     �   CREATE TABLE public.product_photos (
    id integer NOT NULL,
    url character varying(250) NOT NULL,
    product_id integer NOT NULL,
    uploaded_at timestamp without time zone NOT NULL,
    size integer NOT NULL
);
 "   DROP TABLE public.product_photos;
       public         heap    gb_user    false    4            �            1259    131251    product_photos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_photos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.product_photos_id_seq;
       public          gb_user    false    4    237            �           0    0    product_photos_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.product_photos_id_seq OWNED BY public.product_photos.id;
          public          gb_user    false    236            �            1259    90172    products_id_seq    SEQUENCE     �   CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.products_id_seq;
       public          gb_user    false    228    4            �           0    0    products_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;
          public          gb_user    false    227            �            1259    106497    products_types    TABLE     i   CREATE TABLE public.products_types (
    id integer NOT NULL,
    type character varying(50) NOT NULL
);
 "   DROP TABLE public.products_types;
       public         heap    gb_user    false    4            �            1259    106496    products_types_id_seq    SEQUENCE     �   CREATE SEQUENCE public.products_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.products_types_id_seq;
       public          gb_user    false    235    4            �           0    0    products_types_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.products_types_id_seq OWNED BY public.products_types.id;
          public          gb_user    false    234            �            1259    90114    rubrics    TABLE     {   CREATE TABLE public.rubrics (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    parent_id integer[]
);
    DROP TABLE public.rubrics;
       public         heap    gb_user    false    4            �            1259    90113    rubrics_id_seq    SEQUENCE     �   CREATE SEQUENCE public.rubrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.rubrics_id_seq;
       public          gb_user    false    216    4            �           0    0    rubrics_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.rubrics_id_seq OWNED BY public.rubrics.id;
          public          gb_user    false    215            �            1259    90121    users    TABLE     h  CREATE TABLE public.users (
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(120) NOT NULL,
    phone character varying(15),
    active_payment_id integer,
    delivery_address text,
    personal_discount_id integer,
    created_at timestamp without time zone
);
    DROP TABLE public.users;
       public         heap    gb_user    false    4            �            1259    90120    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          gb_user    false    4    218            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          gb_user    false    217            �            1259    131416    users_with_no_active_payment    VIEW     �   CREATE VIEW public.users_with_no_active_payment AS
 SELECT users.id,
    users.active_payment_id
   FROM (public.users
     LEFT JOIN public.payments_users ON ((users.id = payments_users.user_id)))
  WHERE (users.active_payment_id IS NULL);
 /   DROP VIEW public.users_with_no_active_payment;
       public          gb_user    false    240    218    218    4            �            1259    131408    users_with_no_payment    VIEW     �   CREATE VIEW public.users_with_no_payment AS
 SELECT users.id
   FROM (public.users
     LEFT JOIN public.payments_users ON ((users.id = payments_users.user_id)))
  WHERE (users.active_payment_id IS NULL);
 (   DROP VIEW public.users_with_no_payment;
       public          gb_user    false    240    218    218    4            �           2604    131289 	   brands id    DEFAULT     f   ALTER TABLE ONLY public.brands ALTER COLUMN id SET DEFAULT nextval('public.brands_id_seq'::regclass);
 8   ALTER TABLE public.brands ALTER COLUMN id DROP DEFAULT;
       public          gb_user    false    238    239    239            �           2604    90169    cart id    DEFAULT     b   ALTER TABLE ONLY public.cart ALTER COLUMN id SET DEFAULT nextval('public.cart_id_seq'::regclass);
 6   ALTER TABLE public.cart ALTER COLUMN id DROP DEFAULT;
       public          gb_user    false    225    226    226            �           2604    90144    discounts id    DEFAULT     l   ALTER TABLE ONLY public.discounts ALTER COLUMN id SET DEFAULT nextval('public.discounts_id_seq'::regclass);
 ;   ALTER TABLE public.discounts ALTER COLUMN id DROP DEFAULT;
       public          gb_user    false    221    222    222            �           2604    90203 	   orders id    DEFAULT     f   ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);
 8   ALTER TABLE public.orders ALTER COLUMN id DROP DEFAULT;
       public          gb_user    false    230    229    230            �           2604    90210    orders_statuses id    DEFAULT     x   ALTER TABLE ONLY public.orders_statuses ALTER COLUMN id SET DEFAULT nextval('public.orders_statuses_id_seq'::regclass);
 A   ALTER TABLE public.orders_statuses ALTER COLUMN id DROP DEFAULT;
       public          gb_user    false    232    231    232            �           2604    90135    passwords id    DEFAULT     l   ALTER TABLE ONLY public.passwords ALTER COLUMN id SET DEFAULT nextval('public.passwords_id_seq'::regclass);
 ;   ALTER TABLE public.passwords ALTER COLUMN id DROP DEFAULT;
       public          gb_user    false    219    220    220            �           2604    90153    payment_methods id    DEFAULT     x   ALTER TABLE ONLY public.payment_methods ALTER COLUMN id SET DEFAULT nextval('public.payment_methods_id_seq'::regclass);
 A   ALTER TABLE public.payment_methods ALTER COLUMN id DROP DEFAULT;
       public          gb_user    false    224    223    224            �           2604    131255    product_photos id    DEFAULT     v   ALTER TABLE ONLY public.product_photos ALTER COLUMN id SET DEFAULT nextval('public.product_photos_id_seq'::regclass);
 @   ALTER TABLE public.product_photos ALTER COLUMN id DROP DEFAULT;
       public          gb_user    false    237    236    237            �           2604    90176    products id    DEFAULT     j   ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);
 :   ALTER TABLE public.products ALTER COLUMN id DROP DEFAULT;
       public          gb_user    false    228    227    228            �           2604    106500    products_types id    DEFAULT     v   ALTER TABLE ONLY public.products_types ALTER COLUMN id SET DEFAULT nextval('public.products_types_id_seq'::regclass);
 @   ALTER TABLE public.products_types ALTER COLUMN id DROP DEFAULT;
       public          gb_user    false    235    234    235            �           2604    90117 
   rubrics id    DEFAULT     h   ALTER TABLE ONLY public.rubrics ALTER COLUMN id SET DEFAULT nextval('public.rubrics_id_seq'::regclass);
 9   ALTER TABLE public.rubrics ALTER COLUMN id DROP DEFAULT;
       public          gb_user    false    215    216    216            �           2604    90124    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          gb_user    false    218    217    218            �          0    131286    brands 
   TABLE DATA           U   COPY public.brands (id, name, logo_url, description, site_url, added_at) FROM stdin;
    public          gb_user    false    239   .�       �          0    90166    cart 
   TABLE DATA           ]   COPY public.cart (id, user_id, product_id, product_count, discount_id, added_at) FROM stdin;
    public          gb_user    false    226   ��       �          0    90141 	   discounts 
   TABLE DATA           :   COPY public.discounts (id, discount, percent) FROM stdin;
    public          gb_user    false    222   r�       �          0    90216    ordered_products 
   TABLE DATA           G   COPY public.ordered_products (product_id, count, order_id) FROM stdin;
    public          gb_user    false    233   �       �          0    90200    orders 
   TABLE DATA           A   COPY public.orders (id, user_id, status, created_at) FROM stdin;
    public          gb_user    false    230   V�       �          0    90207    orders_statuses 
   TABLE DATA           5   COPY public.orders_statuses (id, status) FROM stdin;
    public          gb_user    false    232   ��       �          0    90132 	   passwords 
   TABLE DATA           L   COPY public.passwords (id, user_id, password_token, expires_at) FROM stdin;
    public          gb_user    false    220   T�       �          0    90150    payment_methods 
   TABLE DATA           B   COPY public.payment_methods (id, discount_id, method) FROM stdin;
    public          gb_user    false    224   ��       �          0    131393    payments_users 
   TABLE DATA           =   COPY public.payments_users (user_id, payment_id) FROM stdin;
    public          gb_user    false    240   ��       �          0    131252    product_photos 
   TABLE DATA           P   COPY public.product_photos (id, url, product_id, uploaded_at, size) FROM stdin;
    public          gb_user    false    237   T�       �          0    90173    products 
   TABLE DATA           �   COPY public.products (id, rubric_id, name, description, main_photo_id, brand_id, size, color, season, price, count_available, product_discount, updated_at, type_id) FROM stdin;
    public          gb_user    false    228   ��       �          0    106497    products_types 
   TABLE DATA           2   COPY public.products_types (id, type) FROM stdin;
    public          gb_user    false    235   �      �          0    90114    rubrics 
   TABLE DATA           6   COPY public.rubrics (id, name, parent_id) FROM stdin;
    public          gb_user    false    216         �          0    90121    users 
   TABLE DATA           �   COPY public.users (id, first_name, last_name, email, phone, active_payment_id, delivery_address, personal_discount_id, created_at) FROM stdin;
    public          gb_user    false    218   �!      �           0    0    brands_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.brands_id_seq', 50, true);
          public          gb_user    false    238            �           0    0    cart_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.cart_id_seq', 100, true);
          public          gb_user    false    225            �           0    0    discounts_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.discounts_id_seq', 12, true);
          public          gb_user    false    221            �           0    0    orders_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.orders_id_seq', 70, true);
          public          gb_user    false    229            �           0    0    orders_statuses_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.orders_statuses_id_seq', 12, true);
          public          gb_user    false    231            �           0    0    passwords_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.passwords_id_seq', 50, true);
          public          gb_user    false    219            �           0    0    payment_methods_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.payment_methods_id_seq', 16, true);
          public          gb_user    false    223            �           0    0    product_photos_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.product_photos_id_seq', 500, true);
          public          gb_user    false    236            �           0    0    products_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.products_id_seq', 340, true);
          public          gb_user    false    227            �           0    0    products_types_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.products_types_id_seq', 7, true);
          public          gb_user    false    234            �           0    0    rubrics_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.rubrics_id_seq', 99, true);
          public          gb_user    false    215            �           0    0    users_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.users_id_seq', 100, true);
          public          gb_user    false    217                       2606    131295    brands brands_name_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_name_key UNIQUE (name);
 @   ALTER TABLE ONLY public.brands DROP CONSTRAINT brands_name_key;
       public            gb_user    false    239                       2606    131293    brands brands_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.brands DROP CONSTRAINT brands_pkey;
       public            gb_user    false    239                       2606    90171    cart cart_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_pkey;
       public            gb_user    false    226            �           2606    90148     discounts discounts_discount_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_discount_key UNIQUE (discount);
 J   ALTER TABLE ONLY public.discounts DROP CONSTRAINT discounts_discount_key;
       public            gb_user    false    222            �           2606    90146    discounts discounts_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.discounts DROP CONSTRAINT discounts_pkey;
       public            gb_user    false    222                       2606    90220 &   ordered_products ordered_products_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.ordered_products
    ADD CONSTRAINT ordered_products_pkey PRIMARY KEY (order_id, product_id);
 P   ALTER TABLE ONLY public.ordered_products DROP CONSTRAINT ordered_products_pkey;
       public            gb_user    false    233    233                       2606    90205    orders orders_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            gb_user    false    230                       2606    90212 $   orders_statuses orders_statuses_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.orders_statuses
    ADD CONSTRAINT orders_statuses_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.orders_statuses DROP CONSTRAINT orders_statuses_pkey;
       public            gb_user    false    232            	           2606    90214 *   orders_statuses orders_statuses_status_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.orders_statuses
    ADD CONSTRAINT orders_statuses_status_key UNIQUE (status);
 T   ALTER TABLE ONLY public.orders_statuses DROP CONSTRAINT orders_statuses_status_key;
       public            gb_user    false    232            �           2606    90139 &   passwords passwords_password_token_key 
   CONSTRAINT     k   ALTER TABLE ONLY public.passwords
    ADD CONSTRAINT passwords_password_token_key UNIQUE (password_token);
 P   ALTER TABLE ONLY public.passwords DROP CONSTRAINT passwords_password_token_key;
       public            gb_user    false    220            �           2606    90137    passwords passwords_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.passwords
    ADD CONSTRAINT passwords_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.passwords DROP CONSTRAINT passwords_pkey;
       public            gb_user    false    220            �           2606    90157 *   payment_methods payment_methods_method_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_method_key UNIQUE (method);
 T   ALTER TABLE ONLY public.payment_methods DROP CONSTRAINT payment_methods_method_key;
       public            gb_user    false    224            �           2606    90155 $   payment_methods payment_methods_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.payment_methods DROP CONSTRAINT payment_methods_pkey;
       public            gb_user    false    224                       2606    131397 "   payments_users payments_users_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.payments_users
    ADD CONSTRAINT payments_users_pkey PRIMARY KEY (user_id, payment_id);
 L   ALTER TABLE ONLY public.payments_users DROP CONSTRAINT payments_users_pkey;
       public            gb_user    false    240    240                       2606    131257 "   product_photos product_photos_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.product_photos
    ADD CONSTRAINT product_photos_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.product_photos DROP CONSTRAINT product_photos_pkey;
       public            gb_user    false    237                       2606    131259 %   product_photos product_photos_url_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.product_photos
    ADD CONSTRAINT product_photos_url_key UNIQUE (url);
 O   ALTER TABLE ONLY public.product_photos DROP CONSTRAINT product_photos_url_key;
       public            gb_user    false    237                       2606    90178    products products_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public            gb_user    false    228                       2606    106502 "   products_types products_types_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.products_types
    ADD CONSTRAINT products_types_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.products_types DROP CONSTRAINT products_types_pkey;
       public            gb_user    false    235            �           2606    90119    rubrics rubrics_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.rubrics
    ADD CONSTRAINT rubrics_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.rubrics DROP CONSTRAINT rubrics_pkey;
       public            gb_user    false    216            �           2606    90130    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public            gb_user    false    218            �           2606    90128    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            gb_user    false    218                       2606    131221    cart cart_discounts_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_discounts_fk FOREIGN KEY (discount_id) REFERENCES public.discounts(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_discounts_fk;
       public          gb_user    false    3323    222    226                       2606    131216    cart cart_products_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_products_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_products_fk;
       public          gb_user    false    226    228    3331                       2606    131211    cart cart_users_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_users_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 <   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_users_fk;
       public          gb_user    false    226    3315    218            &           2606    131379 -   ordered_products order_id_ordered_products_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordered_products
    ADD CONSTRAINT order_id_ordered_products_fk FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE RESTRICT;
 W   ALTER TABLE ONLY public.ordered_products DROP CONSTRAINT order_id_ordered_products_fk;
       public          gb_user    false    230    3333    233            '           2606    131374 $   ordered_products order_product_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordered_products
    ADD CONSTRAINT order_product_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;
 N   ALTER TABLE ONLY public.ordered_products DROP CONSTRAINT order_product_id_fk;
       public          gb_user    false    233    3331    228            $           2606    131369    orders order_status_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT order_status_fk FOREIGN KEY (status) REFERENCES public.orders_statuses(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.orders DROP CONSTRAINT order_status_fk;
       public          gb_user    false    230    232    3335            %           2606    131364    orders order_user_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT order_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 A   ALTER TABLE ONLY public.orders DROP CONSTRAINT order_user_id_fk;
       public          gb_user    false    230    218    3315                       2606    131141 %   passwords passwords_tokens_user_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.passwords
    ADD CONSTRAINT passwords_tokens_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE RESTRICT;
 O   ALTER TABLE ONLY public.passwords DROP CONSTRAINT passwords_tokens_user_id_fk;
       public          gb_user    false    3315    218    220                       2606    131146 ,   payment_methods payment_methods_discounts_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_discounts_fk FOREIGN KEY (discount_id) REFERENCES public.discounts(id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public.payment_methods DROP CONSTRAINT payment_methods_discounts_fk;
       public          gb_user    false    222    3323    224            )           2606    131403 "   payments_users payments_methods_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.payments_users
    ADD CONSTRAINT payments_methods_fk FOREIGN KEY (payment_id) REFERENCES public.payment_methods(id) ON DELETE CASCADE;
 L   ALTER TABLE ONLY public.payments_users DROP CONSTRAINT payments_methods_fk;
       public          gb_user    false    240    3327    224            *           2606    131398     payments_users payments_users_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.payments_users
    ADD CONSTRAINT payments_users_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.payments_users DROP CONSTRAINT payments_users_fk;
       public          gb_user    false    218    3315    240            (           2606    131359 !   product_photos photos_products_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_photos
    ADD CONSTRAINT photos_products_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.product_photos DROP CONSTRAINT photos_products_fk;
       public          gb_user    false    3331    228    237                       2606    131333    products products_brands_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_brands_fk FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.products DROP CONSTRAINT products_brands_fk;
       public          gb_user    false    228    3349    239                        2606    131338    products products_discounts_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_discounts_fk FOREIGN KEY (product_discount) REFERENCES public.discounts(id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.products DROP CONSTRAINT products_discounts_fk;
       public          gb_user    false    228    222    3323            !           2606    131328     products products_main_photos_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_main_photos_fk FOREIGN KEY (main_photo_id) REFERENCES public.product_photos(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.products DROP CONSTRAINT products_main_photos_fk;
       public          gb_user    false    3343    228    237            "           2606    131323    products products_rubrics_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_rubrics_fk FOREIGN KEY (rubric_id) REFERENCES public.rubrics(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.products DROP CONSTRAINT products_rubrics_fk;
       public          gb_user    false    216    228    3311            #           2606    131343    products products_types_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_types_fk FOREIGN KEY (type_id) REFERENCES public.products_types(id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.products DROP CONSTRAINT products_types_fk;
       public          gb_user    false    3341    228    235                       2606    131116    users users_active_payments_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_active_payments_fk FOREIGN KEY (active_payment_id) REFERENCES public.payment_methods(id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.users DROP CONSTRAINT users_active_payments_fk;
       public          gb_user    false    224    3327    218                       2606    131111    users users_discounts_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_discounts_fk FOREIGN KEY (personal_discount_id) REFERENCES public.discounts(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_discounts_fk;
       public          gb_user    false    222    218    3323            �   �  x��Yێ��}&����������p�@v�����Ң8���%��8_�S���k'v��-ix��>�ԩ�8�e��A���8^��ǋ��Y�v[v[��qЧ��SeUW�>�J�y#yUU�u[����T+{!�R�j��\ٿ�j���uw��QB�=e�Ħ�k5l9����K]!��j�$Q�>D��8/�H�0	ڪta_U;V}5�|�P��j/��E=�QP8���F������������(ڊ"i�V|ֲي﫺��P�U��(���'%F�=*�1��V�C#�j��,]t��K��eb�'ZN��_$�]�DE�i �jtw��*G���ny���P��B���o�%P�z؊�p�ڳ�q��ߊ�jdY4���j6�zU��%�܈^��n�˶5�Rce⋎_Vdi��,�~�ż9����y��P(�Q]���Zq����Fj\�8��q&��R�e-wx_)b
��KE��y�K����Q��.}���G�7lY+	�,)�oG%qR'dP7��l<>5��[�5n�-畁D�*a_��j	<�h�D|(���p4���	�'�����c)���A-�]Ģn� 5�ڪF�j�8c�cl��`P�5�w⬕���B�Jn��򨇪��Ȳ���":v���*��a5������! V�v#^�.�	����꺖[�M/C2�(}2�㐤�s!��-A?vg�	���L���QR�ix��f{G� (f0��W�B�dMF���B��e׾I#��x��;�#�v~aP�W9�5��h�f� ��&�Yй�I�� PG�p$	Y�G�1���pҵ�)���3T���*��2��5��̉].n�kKU�z(��­����3�d�q7�#1��|ɀ_+�����U�\zl�B ��d/�c��l�DM�O~��|�Y��,p�j���G�Q'�a�?��j�M�5B�;���S��5d���f�u��T��Y�{U���GF��Cи�c���3Ӊ����ئ��������J�R(�jA_&
Vc
]Uz'��DI�	��0F�T���B8BS��O���]�r=���w���9U|��u�#��ɬ��k c����f�,�H��E��4��W����S����Eўv��7$�����,�-�]%ya$l��)����4��fa��j���q�J��h$gɱHa���;��*�\�(���%�"Em,��0�Ն�X�����)��2s��� �!l�)�k֎lm�[����˹.Qid�#^z�Y���]���2����t��lF N�fa�,�o+"�c���4ĕnh�I�J�otR��G\���L����<Yπ�C|$S��`�>0�J�U^�������ũ�)lK}���#�H�d��M�R�:����2vrF�Ғ<|d?�{d�̀�s�#�LR�{����:��"Q��)���v�z"��Vhēʹuޔ�(�	䎍�N�u�帧{�D�*/"`"�c���"z�N]�i拹T��`�7ew��.l�5<gD���^d�i`��q��mw0�͜,q�"oa���8���D7�k��`t/��������5�~Y��f�����1�+~&q H]�dO�2����fP� ^Mz8+�ؾ̪w��)oEgz7�V��$",�G�w����m_�e�!��#6:)�Q�l��9�ܬ]v���Wbd��B�FX�ܠ���=
\e�n�h/28������c�L�o�.�1�����&Y��vއF5��mj�:g)7�QL*�䐢J� �w(�)�3[a��@uc����[V�RaA�E^d	LG���k�`֚�2��Ȳ��K���bA��u651nՐřl���״��M�W=J��Y
ֳ�{?�CT �.L�����r�b��l�_τ!D��Y��JuU�u����ߤ`�'3И4cI�u�޼W7�c��]7/(f�aK��eq��{����-�c�n�f*��R��V�����lM�	�I\��ڏ���y�r*�9�pc�1�����ꎾz�%d�rjG�4
Lxow=�x+�X�7�+���Ϊ5%��03���̐<)Z�6\࿑��y���V�|3��$3�ȽH���aq�����:��np1��WG!�@?(�^��t��Σ6n�D#���X�_����3P�,�"�&�#����^s���u��6o�0����qUV�m�L��?���偌8j�>L����n�wS���V�]�Dl�#��yߌ����L7�1��٢�l���}�k`�ZP�눷�N��3?,��%-b,>uW璮���g�q33B���:?�e?h0������$�|��i$��-'�������La�?T�Յ��x��>�������/�ge��l���8��]�����,��,�v%�|�g�1���ǹ�x��r2�(gp]i�;"ĭQsF�
����������x���­����]y�W_u��nznV��>h���A�_�} ?ꇶ�������ԛlx�c6��x6��2�x�`b>o�R�>�M9�6���d.���z�4�F»�ID�F�Bp@!���}���,�������#��'0����L/�'�s���I<i
g��1��yo�2�C����t���iu3:��.'�0������&-�ƬBl�߸_1��D:k �������s�A���Qw���Ł;R]q��i�Ug��||me�Q�ć�����dÀ�?���}�n�2v"Ni���,	������ �X�Y��+,K��r\e��f�<�d���-��wǮl2i�����N�f�z�E)w�y	��,�SO�W�m����0��Y6?�_������ÏlVx�f7��=\����w3%�Z4��=)t��w����;��:'O�6��,nT~���wcP��V����g�˖��ޘ6�j֬��<�т�G1�!1�s�&���Yy#pdgQ�h̑��n�?�!�t�ȹ㫋�����.�5�Ⳣ�kP���n���A�,]�2E�ת��A�G�9�x�1�s�p�P��i��&v��T�oL����O?�d�#f��;l�[����M˕����� '�F��X��T�/A�Nmx��.�[G/����a�&:Z�L}�����Fe&���J�Z�QU����t�
��W���`�%�׳�����h�mN��$̣��ʿ��[f�lt�wCN[��7� ��0���O:Qރ���OvҘ�Ft+y�c�� �d�Y      �   e  x�]Wۍ9���H9����r��q�f�hX,kŖ(�R��4��T����o���K�2�|wkK���Ϲ���K��ݽ��t��ύ�/����ڣi������e�$pz냷��=�p��įq.�>�����|`�ڑ�������#�+��v���'C\�
�	����L� �u�t@��Q"�5
 @�쪄QE�0Z�h���R�X;<(iη����"��"�(u�3 ���k4�v��Q|�z��]�I�S�\��%��n�͐ĎO3�Y�/��_�}D!?4�	v�9�5 �n�8�=���W�\a]a{�^����J>�c�j+i����T�a�����Y p���qd̾��X���nL���K�9^� ��p�mh��L� �w��^_,p����&�g[J�`8����!��ˌH�,�5!��:��Ob�6�vIt4�G۳�)!���rg�����*�E 㣂���;�\mJ�k0O`�GB�l�
V��BD�m��*��{1J�'\(�v�"E�eA��l )�Q���G����eF� *1!��7�l�� ζ$�������O=���I�L��������/p5m�jz�))�!�=���^�r�D)G�5hy��h:�3�$�OB?�� X[z���6�&��LX+hx�f�)Z�4� +H���Gz�O�JDI�E��&����=!�=	�N|SB�Zѓ�EpXi�N�
f@��R3�.*�0j �>��Bpz� �j���$�6X؋f���$�HK�:�����#���GR��y~rT����F2o�e�*B�BV�Ǽ�0�I-��$-#⋅�y[(0� �>5�w���xn��T^�����@�c{FIcpvlp�@L4��}�5��u���Ԍ�E�<4F����?,g����s��(������ I����u��
 |����ߑ�ux&A(����R��R�M������
�� 1��;e�����',-��e(ގ�D��`���ȑh�Jv�WiHF�}�r� ��j?Ҡ9E�8ށ5�͊7��S��$.VXA3�94��&nг�SG+O����c ��LK���=Ed��A�E$���1��vc����I�9�� `�|�u���+���;�?�juG�d���g�9�N=�P��b	vq^"(�i���$�=�(K�L�+�XD\�ȟ���P'���Fn�+���^\^sɑ���Q��Uh3�vRK!2�^�$5-Y�~�-9d�&	����{��a�T��U �1s��&����F�u?i�;���pZ�u�Ak�X��]0N�m�4�34�@��R�\��î���|��
4NlL�����!��)����]�6�      �   �   x�u�1�0���>�O�\J�LU��%j,	�(q�ޞ�����{C�V�/�JqR������ӳ
�ssS��c7��J|Q�m��8t�G8�ڜ���<��~�� w��uH�
�$�:&f��	_�C�<�6�      �   >  x�5VI�e!_SG@P�����J�oti�����3~�[_���)���w�氢)_���9��3jX^Xf�ϊ�{���	�İs��ΰu>�9�Ǉg�csɝ�K����ax�r��V���ڽ��Aƒ��`������K��Y��x"�mm�s�K���)�B�!�D�������Lt�H���ZxI�����n��;��=��@��.[�t]؀��0�f"���~86�`�H������WQae��1�q�8��S4�����Ú��|��
���g��;�}�` A�ں�*5�(��Bg���� ��K��/�8�\��i₇�`��6T/S=v��+��ͦ����f�2����%�K6���P�sa�-�9�ǬY���_�!a{���Z�/F� �jfx2�Z����.���T|VcH��ح�LN�N���(���vo�yC����I\b�-N�����U�z�M+��T�tZ�@_,�|�]��Y�S�"�^��Ԥ �aL��6�к21Ϯ�C���9>�G�"6�B��ā,a!�k��%A4c����:c?�Jg{�&�򮁅�mOw
�L�#��*؊��nTعI1���� S����a�IA�TC���VK�BIի��5���l
$2�T�ڡj ��d3��s��֓L���3Ě 7�V�y4K��eA���i&��Td��zS��~cc�V��S��4n,A$��Hk�{�,󕭔��� >�ܮ/�s2��LkvZ�o��eA�j���%9�1A{��k�)�m�L��C'�WO�#7�����&�a�����U����"���W*@���|U�U��N6��ͤZ��j����4M��6��r��ÒPy�yKZqZ>�<�J�: v�'�]�a��Yh�S�hFm�ZZ��n�9�+:�e��B#c6
ʛ�۔*I#0G�0� M:�&��\�Tٺ�CVhs�g�8�������N��괼o$�=��J�����4�I8^t�iE�Zo�gS�w����V�U+(o�ݟ�9�'��V��͒\�4�Q��W})螠N��d�z|���x���o��Go�      �   R  x�UUɱ�6;�U�g�M[-鿎 ���3�G$@ ��ҊU���]�u���bŢ���B��^��2/�e��D��}i��f����]�Usi[�%Kf�Q2[�JbX}�����c�v�e��lc�v�\i˻�2GQe-^Ֆ9�L����W��j��A���m��Xn|�v��Jh�fsi�Q���m3PWQ`��g��K��D[�(}�s��r%uMО��[�Pb,Ci�哇[��ۮa-��E���8H��7��o/J��%T �Y���v4υm����󐏍K�$o����;� ��>����$?EOlS�~AG�'H@Z8̳��0�.�a�X��Ot��:�6�y�#|_*�R_�WZ���*��ϟ`a`(0MM��S���2]������5�l�'���"��ڎ�f
L��4�[7���!�y�F�N� ��=����ӣ>K��ޮH B!�@�~>vep7�¡�ȅw
�1�I��vO�+���CpF�D-m<,�N^�5<�]�17�~K����ħR&�Uaj�A
�Ln&��G��PJs$<5��^%M�������+U�-.�8�Qc�|,��3/��P	@��	ӳ�Ƚ���E��{q�D<�Y�v���fM�ɏ|۱';_I/�뗦�I���V�	������(I���/�4�"��嵯2�O�i0�O	/sp�9x.N��=P�in<��+�n���oH�<�'2�< =�J����k�X��� �Ɖ~"�u�2g�k:6I���H�Q���+(��|n�'���*��ݿ��?���~?���g��d즸����'�	�Y��Kh�̠�;�ba���T8���#"��U�      �   �   x�M�=� ��>'�J�?��Ku��T�$��}��U7��{zn���Q䒞�j���'Q�xZ���GN��p ��h��wҶ	���޼�'&7G��3��B�	�7r�2G��\�THu�����:�� �>�7      �   �  x�MV�m3�}�T�t!���M�T��_�=r�� ���<I�z��W��kxi���;��us�K.���Xn֛��$%�V�f�́7�z�S�������Z[�5g*�Ы�]��%I)�2Y$���mזi��m]c�^ǔ���3ŋ���]��Sg�3���%K+{�+�*���>k�??��%K��t��O��]��Vme|�ٲ�k��ؔ����7��i��6t���3�SD����R��f�cp{���U�(������6�b-���ΣO�SG��*x���4�lў�����~��P��x/{���}]߯+F����"��⠚#X��<�؀~7��m��<f�m7�MqQ9l�JR�|.x��uZ_�yt�s}�]nՋ(yM:�ţe�O˼�����Bӌ�r���۫4L}�����(��e@�# �UF�Q�y�j����A�����$I��KdH^:fZx8���|�l���a��܌�5�'���Y���Szɕ6�2u�2^Z?�IoY
K�n�E�P�ͼa�ͤ�ou��-qk�PZ17�	�`�'����3�>z��l)���n��mvQ=N��&�]���n;�Ѭoҧv���{�E�R/���C�[��  d�@:�k>x�A�U{{��h ���j�1�t��}0C���I�y�V�W��w��!:Od��� ` ֺ���|j��?6�ũ�r1�FɆ#M�6�(��O�	�d��Y��I()�w�[�o�B��l�9s�`{¢@Dt1�iE���	���<]��k	��:�A~o�m�����tD�c`8T��\�)4=n��2͚��V��a�Z��S�T�P]��R�c��XP��t��i�Z�h��$^�꘽����{�n!P_��ov8J� ����9�z���;�͟����	�������l+�M��cr����ǯ~�;�GrK�����<����y�#| ߣ�Vh��g1�z��[rI�\�ˣ��m ���9� ��[���q�8T?!�Q׼�������3���5��?���hYEx�V���<�؁+F^�@^4CT����&�yNG6©rs��?>���
��4���Zx�?Ջ�#�#��{��Nv,H5�Z�������/��8 ���UAֵ��;mlql��[ލ����u��ߜ�o\4�d�v��;f�����������o�����D�1�����k�/qw<�o�o�a���˙1O��&�ԑh,�S"�����*B�����y�k.�Ţ(G3�.?�`��; �@�S+š�?�AuG3q�JZw�bB�#Ur��7lW� ��& >i#q7��:,�6��v��7�Z��l�������s��nZ�B���wUي.Q�3̫����8��g�:��]n|�����Z�݇52��	=[F�<�ˑ��ЪH�~�G����Lm ri�_P��g��[�ʅ F�Tx��y6�aq<�2�g �py������$�-��7�DVN,9�W����lZ`U�7븜�����1I�'�Wl�,kcWk��|�v��e~xGX��-LmϬO��u!R ���+\���u�<@��^gvC �rx�3=t�Z�Sh,.����+����K�w��?�\@A�Bm{�g]��AP�@�v�m�C�qXM4_+����%|��+Zz�K����]����s�      �   �   x��;�0k�)|P�SBDI��*��Y��k$|{�t��Ӽ����
n�(�� ϰWӠF,#:84�9���qeOl��/1����e�s�;��ΌA��p���K��|�)�][Qנ�������k;%G�>ô�?w�/'      �   �  x�-��1C��br�g����.�b86!c����dkE}{���db��
>L�.s0;�X�ʬ�l��z}���S��:)��%����K�n:�g���|iT �K��)�RF���c���[W�4!�罊��YS��N�`�w�Aɺn�vS.�&
w�L�ђz�u�U�K3J�U#���O)������b[�����j�]���K\o�~�h		�d�^�H�2(ۼ�r|֏��1w�[��(�Nڥ��=�l��j{�R��чB�Urm(��'œA��ۘ�FqMZHf�8Hц��7��lFB{JM����oT�H�fz�i��ܵ�<���4 ��4���X��CQr�{�9E0��)���_����f�ܣW0��~*��4�b��H:H*X�� "%u6�X30�����N,hK8(����?�ֆX      �      x��]˒�F�\��Z�NV�'��?2���n��V�����_$��,����C�
$�	�^~}{��z���������?}y���//?�>ܿ|�����ϻ����>��ц�܂�y{�%]����=?������o��}�������`�ͤ����Տ˿=��������k�`�
~!�˗`�5�wx�|�7_�������!l��?z���[�7�/��k�?�������Ͽ�ϼ���ϻ��׷������b��K��i���o��Ϳ���۝�d߯2]�`�v��ʥs�㪿����卯��}�|�G~��ׇ�;{qi>5-�37�o�\���2���ӷ��z�ӷ��o`���`�-����u<��������/���?՟�����]M/�קK���K�קgO��~��������o���ߞ�=��%�}M���W���:����j�ފ���.a<}��ۛ�d���պymA����.��l>��XHs	�~������������*~�������#�O��`i#,���K��j��M�c�$Sh�؞�������D'�ƽ	ɕm�R����.�|��z�����t�������[��;��ԛ������]����ݜv���goMw�����Z��ϟ��M�m{����I08ot3�-�r�49:��i�����,r6!]�-W��������qN?}��ۼu�C����8d�n��j����$&~t�]��@是n�=� ��j���b3=���F�N��oO<�n� n��,���+�.Fwu���z����=�O�/��5�{�GՔ��㐙��.�\��9���_�H��aٗ+ҺO+�>��H3����{���X(�y���j:��G"�ЕG��B��Ge\������r��G樍��Do�w��K��}�����t����BK�w/��E&XS�zs��8��֖ G#�KM7�rWo�M�?��7��Z��:ڥr)�^~���ׯO��Ir<��BN�<�7��i�y|}x�d��v��Xf��;�U$��kG��4v����󹦫)Z�Z����������̂(��"yA��@�!@/��ul���L9\���m���?{��Hi�����c�dGK7MMɸ=�d�@�ql(�[�#zs�3��n�W�����@t0�R��`�w����r�J>,e��y���J�ۅn��n;�w�V�S[:�d��]���'m��EL����'ؐ\����ԝ�r�]���Ɠ�甯!��O�^��\ ��-a 
�tq\����@+�a�q�6.a���i�;O�>qq	�/���Zf���� �?߅`�uO��]��%�RQ�(J�Ӆ�������H����F>7�����h`�@.opO�$d|%�k�P�=6����l���i��ZJ�cvZ�Zn�9?��&F��	N�n}��E4d� 1S�95��~��^���:�ZJ�d���T�h5=�nM$T�ukB�,�#�qy´S�!IZ�+Aiل��.�C���u��� &Q!�@�#����pnPqQ�2��;�AFJObY-����^b�' ����E�X�q��I�)�V�����&�~�a���=.6�9C�휇k��)�bF�R�Kg�
��ǔ�I<���k�i��5I(2 �/�)���b��ݭ�V���$��H�������������QQ�!�F�63z�Б�"t`A�k�4ײEi���^���������DG/A'�D����đ�f\�V.p�C�!_�
	�M������{HqҒ�([�c��ݻ^y���2�L�9]�Y�юa++4�k����HW��c��<n��<����-[=���V�<!��:Bc�}" Xq�r)�,�Pr���wR���d�!�?	�^sX��8k-����Lŀ�N6���s�P�GRF9��6�A% ���fqy�bJ�b/�\K�#/����h���}m$�jX&S���4���0Mİ]S�C���Ϋ�u�~��8a#�(	rV�O��
�,�?k�/��K��Z��m� Nn�Tֻ���(���E$Atu.!�H�yVv��J��ptx$\�u@2;B�Մk��wz9��9G�9rd��z-q�F���g�+�.�[���p�%���S��������@���)�5P��e�u�IZ��(�*��7��adk��0�h�2ŵ2���� Y=6�p10t�fm4;ך����I�G{���k������-;t��K��Z���3�#�C`GC��x�IAk7<l��r����k��ir�#����A;���uvQ��qy�t�u�3@U���2����l���}[��R��Z%���Vۺ<"D����[m]Y9�`�r%�x��p�D��P���D����t��
N��ʆF��t�t����ک��lO�[���a��J����ǵfm|��n҄b�~��,�d
x
U'�������Ňr�Y@K��wH�$W�l�+E��㋠��y�Q;��ʧ�?0�p_�s�Cj\�c��+�.�'g?���|��y���躲��K�wf:~8S �=�#k�����2�
0�KZ|ںJ˞3;�/%��]P08��[��ur��֖y,Zap��ཽO���Z�ђ2}U^E�q��2��
�Z��K�`�3��}��(�^QN�i�+d���(pn�ړt���vs�t�	�����р�3�E�/��X�s	@ <cT�Uik�*x��9 �n��@B&W��}��g�<q 0����8� ׯR�k&�h�o��ٕ:#+5D@��D�b�c��l�HT��	`ZJX���+G�2B�q��� ,��"46a�h~.*�8&�cP�f�b~�b��*���c,�b=e�֥u@�0�6�ǎ G��p[p���!��F�A�`♈c���LY�b��8�:�wt�\=Ɓ������`�eh�GV��:�ud�*v���̓�@o��7@�}~p��:x�$^\ߑk�$��!$8b�NFYhA �G��<�	����6���M�r�n�[�� �=c	J���!X���̭hFx&r�����p�{�"��3gV/'�ת��Sȑa�(��a��b���QA�iR����d
�
�k|;��$�b� �K%�U�"�^��	�@�C�(��������Q(P&�O��XŁ�����U�s��J���u����mʉ6�iy����zPʇ���4R�%t���J��
*���C� ��,�B�h�)�uYa<�e�C�3j�=����@aFޓ�d;�R��v/�"o���k�?�'E�d�d���ѓ�H�G���j3�(�˱�s*�E�8�o���qs�]W�Lg/N߷*?p��.�_P�#�,YBT$�����M��C���G�^����4'��sU� �@���p�݌��LP�q��Z�6Ell=~�m�c*�rp �T�=x�����c�W�f͎��R��Ҡ58�	�xf*	kG�?q��6셶k��7�>Ɂ������	jq#�͜E����)�b6��p��W�B�Y&ۑ���]H��e&��<2�r��n�KK��1O��M����%4�!�
�S�r%`VC�5�%��D�F$�9�t��U�1����n�È8���D��2<�%`�C�:�X�}�`�c���a��-�?RYz.<ǟQ?�����ȕN���^��}Ax���J�E��ɟ��+��17e�>���X)F�4J��}�7\	���K��PV�^۸���+��|�ۛ�_�K�M��`�ǡ�q[/�����3���"7��y�k��g����.��'���͕SUk���AS��Q��X���Y�?�8�"o�y.�B~�bБ8�[�$}>`Y��-ԥ'U��z��2����Y~�+;�0O	=FC�.�O�:Da�%�q/��
�=MR	�@R�S�ݐQ@!t�@Z�.q8��N�="�B?a�5 �d'cb,�f�P�\�eP˙pY����mhю�z$Tvm�a=P0�uL�X&����X�td!C�R�S�7��rU�*BD�7�FEp=��Q�&B���H�4�i��q���:��������e�ِ��g�va�X9��*r���i��    �����Y�0��Au��q�dU��ch����lบ#Y�p"��T�Ide�C|���τ�'�1HfmY�@v�ظ��~h*�X��X�o"1r5��|��f�_hjH��fN���΋bA6sq���+A��JI�+�x�L�+_M�6�zuf	�l��!����r�A��3�Z�>��؝��Ov��&�2�����$���*�J�c3}�~�iR��gK��E�+Μ�
9N��=,�A���e�9��Q$wu� ����#�&�z�F��3��3ˣ~����w��V�-�-�'@ϋ���9�Z~=["K��)��]�����:�M��'����%j������ЗC+��Y2�[��Io70:�������h#�pIP:���(ASV�������!�s�j!��|uv)��copf�Xr�+wv���C9��M�B��8V�Dfu�i�X���LdY���Bl���8q���&�{F���VS}�b��?k������";�gu"*ϦWn\Z�`N�ƙ��Y:��<�8�L��B�1q��bʤ���_��t9��F��6q������d����o�2J⎯�T�(G���:TdɐodJ��Xu7Mo%��JNwa Bd2�]*�[�p��D��x�R�f$��3�$�ra:�Z��,P"p�!�J�m�<tڸ���3E%�������������m�:�GJO�m)v��P� ;�73'	�̬! ����� ��Q�˖���4f�y��>0c��_ɜf�=s��n���I�R�?���Q涰���#L�/����{i?H{p��H/���JxÌ�¾eI<z�}By���H�����ް�eoՕh�(JDq�{;����E&~��M�o�-��D`��,VE�ky��mQ!�37F4U�N�"ۮ'�ӭ��j��W:�a����]�R�k2�y��tE���5���m���
[kE�V�9e�I؊7:�ȡ�P#���P��������q�.$�7�m�0N3,&�ϩ�5��?�����	pQO�l�慍r�F�D�T���eӉ�V��El�ي��%	�ur���Gj��
C�@�Ǝ.�uT�T$vS�-XdO�E?��k&�ķ��Ji [h����.�.�R!� ���,�R�����%ђ��)k!f�/MJ�Tb�FN�V
@����}u_u$��q���vwI���#�=���` B��7�%�N g+��9r֒����{SKsF:Z��
�h�r�g��RAht˝?��7�pi��iM�C~�tg;Ќ�o��o�Xgl�@������iZ��uWl����ѓ�*d$����n[��p>2��n��6Ua�l�|v�%cS|�2���V��g���$8m��q*��X�|J,�*��4w,��.��,k? C�V�{p�=_P;��%�:��ۂ졝�J{lY������O�;t��wϻ��U��E�^������>9�V��%���w�_��5�5��d3�l&���<�R��5�-����<6wl�B�k�hX��-��X��&_�n�B,�S� �WZ?]���(���zOf�UB�n5u�N?���*���@c��t'c�R*N�&�� Mg�W���Y�hHNh�ˉ�j$澭�Tp�d����WCN$�dʑ��c֔qig����RW��l��'��]	g?%|QV�\��{�++�T������)j����\Yڙ�'	���ȷ�%���I��h��i6���M��F#��f˄�er��c�xt=����t���Ѐo�i���TV�CqF~�V��[}e����*@�iC3p���6Hu���Д](Z�N���"6Q�]�,&��`xX������'y�ѿ�b�u��C����zƦ��r�z�l0zD����"��@&X���)Xٗgtl�*��i��NZ<dN����8��>�Z�j�*�ʔpIRo�l�����x3]ݒ�nBpU46l!�S���7kE��f��N�t��[%oޜ�L��YR�ʭ���L�0�AT�I�n�0_�p;�ϬH����C�?��[ӹa,��q�x��M�(j,�t &�B�kW� H�j���B��m�tr�R��B���k� K���?*�� �iSa8�<����D�YX��ĵ�b�^x�����h��94�:��k�'=
[ÿ��j��W�:{���y���pMRfl|9��
됽�K���>�� �b�#)�{{&�&�n��z&�)ݢC�ُ=�o�hL���^���x�H�p�T�qQ]9�'H��8a9��X%�~@%z X�v�������V��M�_D�ٜ%Z�Ʉ��.�ਾ�b��4�@���b��ny��X3��u���@Ҝ�g�mǨ3�de�sw�b�Ъ�h��(��qR����������W�ܪk�)ӯ�+zGiQ�[ko��n:"t>݉{<}��0ih���"���A2�JEU�YqxCqt`d��aX��֢`c���#F)Vck�j*@v��C��݉޹g˳��RV�3�C�@����T�H3��6+�ʒ�Q4ƑE�$y#�{����������Jd�X-����Edl�AAe�u������,#H���W�	D�[��ԯ��e����F��\���{�2�l� �W���[.�Ha��D�hS:{p�ӎ4@Ļs�_�,�?���&���h�u<#�{�7���QĨ�)�$�-�s%�V���[}�Q�:ԅ1�,���X�re��f:.N=�fi��]�Rn��m�b��:T���|��G��D�	ixNZv1���獜�*�%m�%�i>��R������!H�E�OR�"59�Ĭ{�p�J� '	���<W�}"��^K��鹇�=ַ1k>�v�nx-7v��`ҍ��y��v�dV@/�`ٰ�B��M��qi��U�7�i6,���7c�R����J������<�u�۞�w�[�.&�dZT�(��k0�6�3�Q<�NB\��?�-I�^�gir�����n����VpI���:Y1�v<��=��/��}S+Y� �����c�9��Ɯ�����3L<��Q�+zw3� �1������ģ�KntUe�n��e��J�ǲmR��Wb:>�,�am�W��R$����ӑ���6¢���[Sl����{��6$��٨!y~'>�r�vh�<�%<�:�4/�"�PYөK�x:8�}���W�¿A����c���ܩ�s���U�+w��4����C��RTq�g�"ݲ<q�g��aǦ����ܯ[�<�>�y�qހ�QY#>�e�+�q��8Ҍ��G��i�i��c�氚e�Zgv����J��N�}��_�9:B��'���V�f;%(��k���F^��l�챌�E�
l2t��������gv\�̰گ(Y����fLӏqm��'����=z�>Ѻ���\��b{�����("�FDsr���=�lT�x���ۀ��1�LO�e�DQ�L��	)�%OU���c����OZ���������
K�԰-��#d\~"�׀-j4,����gi��ZLuZ����8f{�{�~�V3�ec+S�Θ���C�Ar"�iY�Ѕ������%�&�خ��j�L�:6HH�m��Ϸq	�B����7o���\9fi�D�W&^-����aߧ#.̕�}�E��䋦�}b9�$�nO�Wuu�GRs� ����KϳA0N��q��!�+���S ���0rPʬ�y�M�'��4�����t��O��W��Q�:P��ԫ���s�	M�F��dd���#�)s��@��lK�+���]c�l}&yh5��X߽��q<�����AM�ګ@a��ވN�K��.���W$����w61?ƴs��;���nܚ[#�#���t����uc��^<���u�v�4��6�����.�s��Ȥ	�G�a0�a����mSm)U���u�j��j�ʯ��]w,��~>��Y�|�cspv���[�lv����}����dhE�?<�dw�+I��vMbg��]`�@>^?7�-�����5�v�G���k&��<�9��R���� "  ��A�z���;v0�6�ә�D\��=s��n�@�Ů�j�f[yA�f|�s�*^��r,[�xLcT<��nU�ۈ�Di�:�y2�3,��9���g:\�_� n!�e<]�Lsw���n
�C�-~`I	��G��L�`ڜy!Avg�Qs� ��;s�w^dv8Km������1`���:�Gg�P�.�	~�pМ񁀓�1h�
T�\v�H�e�A>ݡ������C{O�L_Y-���V�4JG��������J3A�����y|EJ�Xmfy�i@�a�<H�,8(Em�Ǩ*l'�+�H�3w+)��b����1��y�����պ�t�'8N7�������_k]�x���L���a $>0�"5�jQ(ߤkS�W�:Y� �IՂ?ѽ/B��[��<,¸t�r����gs<kI�3�O����yxi-lJA�S�=�%���~�M�v���g[���i���W9� �|�v��r�e�R�U邅�MЃ��A��2��C44�- A!��V�>��F�6-�7e�ǵ?6�'(�h�/j�nZ �}�A}��� )O6O9A�
����ǎ��ž9���dpD���{�#�x��ƾ�t0��c9�Ӫ�%^|N�0`W+��Oh o�����JqP}��@��`U������%�iW�4������V4�g�B<N�[�Yjs�\6��"!�Y���Y��}ԫ�0�Z��JW�f�m���l��'Lg-���q��"dZ"ʰ�9���;��B<�m
H����z2;�5�2�k2l�ٷ�ks�v���r�8���'N@�F����>*�%/����Vƶ�^�T�n[+�bd`Pc�v����a�:�xL�%;\*�wl(�y��6�7LR��*��}Ȱ�v5��E`ؐ�E�EO�z��؞����\HˉG���u|g������*8�ͬV~mXg��� -h7)E��Z��/�22��I��vD��BJ�0��V)���)�ȇDP�n������ۜԞ�e�(@:n�	y�P��JP����<k�<�i���9�v��xJs�T��r`6�(���N?Ƽ��8�U{do���x��E6"D���F���s�c�\x^Z���,�^#��d����3jN1/��q����I�U���_�ό���Ǡ�u��w>�G��X��|�PRr`��n;���
[��#hn�ۖ�L��#,��&Ɩ
��hAߗ�g�I*��J�L\Nf����R� �69���� ��������A��2^&�+k
N���ܙ�g�}�((dQ6���ʌ�������2�=�����/�s�J���0z��Ҟ��}�U��g9�R��4zϙ8�8�w��[�5:�����@�RR
�����p�'p�,C�;�놿�+jW~�Ɯ1�iϓ��C]Op9�<��yУ�\ń���A���P���&���X�y�f�����fW ت�U�qx�#T1/����N����h�gNJ�T�c&r��Q�|-6���Yڨ}�_`�����;��_�����Df�'�7��5��k_�R�mk���PZ��t�^�Z~��      �      x��}�n$Y��3����]m�[��( �ЃF5�a^<$�H��-ɣP���C����].�H cQH��B���6z�{����g�}��vO_��m��ݷ���{}z����a��q���k��{�����˟ow���w/����u������������v�}�z�m_^��-�1�'g�y{G��=�n��Mv"}���ƹ_������7��H���@��n����>?�'l���~����w�������������w����u��y���o_�����/�l����_��v�����펿�n��q��{�����7l�������\�ud���F�/��|3D��8��~qCg��o�K�H���V���~��}��{�<o�i��?7_y弭O�_w�����Q��?e��M�x���o�6��|���u���ς���?���Sؒ���x5Oϛ�o۲��Lԏ��l��;goB�1F� ^�n������s��'�������v�|����&K���Ea�//|i�7_|��|�^w��.|��Yxͼzq��L���8�&�Oa0e��g:cn��"{<ߔ�S�w_���Y�o�w�c���=�̧������IV��_���-�=����}�<�n�r8�k�'�������nw��UwX�<?�i�)�4����ロ�c�Ņ˞n��|"	����\��5=n�yK����U�{�9�v'��^����z}��k��xĳ����n��]����hu�^���t��r��J�P���m�y��Ó���R�Jis�O����7��G^��._���5�����X��w[�=_vl���p4���J����2��0����v�W�n,L^5�rOG�#���v_�7�w�E?v?��ط�>��|��;$���x揶�LϷ�����VC(�e+��Mſ�H�����#�d]^��]�<��?�*�ޑ�	ɗ��m�m||z��`w_(/�a�ψw�/ϛ�T�=_ �R>o�Qcʯp^�˟�ݝ\�v~��/o�7�p���{��6;�b��N7Χ��G�m���|�Hy9ry�����Fo�O��d�_"k�Н܆�l�������m\��ʚ�S�ߘ	Wk�;�<��,��.`��}������(/����~_��i���yW����:��E���w��
�ח���v�p�y#'�|wi�s��蛻�|g".��xd�a?B�Xp[�+�����Oߞ7?v|��^ww���vw���_�e�ްք����kИ\?^�Bkz��kO����_�f�������ۉ����-�������]Fz����y��ե�_��+5��+�ұ��m�UH��K)����0�pc/)9�����7���,��V���+�F���#��'C� �����Ylk^������6	��s��I!��v�H�=Ø������Bg�?L7�?��i^�b�>�V�N�}Я�V����پ����E�e�,�/hC.?������v�b��_6�ڲ�lY,.���o<V�N� <-���^���zO9a��׍Q�ws��>=�؈7���}&�`k��'ؑ���e�Ֆ
D��?��;��{�mQw���-aL���@�-�v�������~S��ĖH�<?s���a�.�g\ůڲ�������������v�\VYQj�!�8�ܼ�a�>�_w*��zX=����)��6�17|E}�V&������J�����+�?���$�/����k�1��K\�W�Z^v��!�s�χ�\�v��=��#d,���7�.ž�m�x���U�5T����>a��j�;�n[���<%�[��?w�Xad,7�i��c�����{R������V�i���_�E�{�|��t:�a{F	����+�{監J�@���+��c�E��nw��$�_^�+�9oCYI/+	��n"">W��?���bro������~&�|bwU�hɑ88�'�ގ��8\�p�?W�W�!v%��&N�H%@��noyw^2�ͦ/���P���w2�ip����#6����&L/�6ٜ�/�a���q�i��^r(%;\^��r601�?���������u�� �3��� rr� �≳�F�?V|��w;ܸȁ�?�	j����l��J4=�w�O~�tHxA�tr�� �ŴK=#.>�b�,f+�4�2 �GңH�r�oQ� b�4fO��`���=C�n�����-��N������������zxz��m`2��j	��N=�ܼU��h9B�5N��� ���"�)�t�_y��w�j\t?a���+�QL)��,;z���՘	���C�1�v=
2Ju�@����y��ɞ�$ۋgr]��� ��5����a��1�����;~C�zX:���W.N�Ur�s�&�z�=c�7}Չ���>���Ĩ��Q�9K����	��������s+�q��E�I �S@xWm�֊;��7��@�X�{7'[��~�.��c�(&�E[�߁�ƭ{a�ȫ`U���C��0{1���T�s��g\�B~K�ކ>��#ʻmlaJ:��v�&i����K�rԧ�%�Z<;��m��`c�Ͱ{a���#�=(b7��O:<��^f�����N��h4�I��xSkJ�_��7���Kb�IkN���{�����G���Ҋk)�z��ds!ϐ�$�
Xώ���4V�D��^�G:L�R���Q���J>^�<�z������C1p�����QL�(��ڱq��Tn}��a�0��R3ߟ��;��n�u:�W+d��Q-��~��d�4[��R�eyd��������d��y�Sl���	9��9�N(� �/$k�O�hvԒj�Q�w��'�"A�㯡��6�G"�ϕ�n4��Ž����<��%����:���o�O9����k��a�/�;~��j���3+[6\��N����u*K���S�u9�>���N������4����!���_MGe��{ NG���Gd�F�#��|n
�M���98t�$Q�x���;ra�Ǝi�\���ܿp����˶	r5�� q�>o�����i~��v��@S�E�Lo���	>��fǏ���hB�>$�B�Yދ�Xx7jB��K��՟��9[Ĉ��9���I��[�?
�ظ�&8����yi�t!�"�}M�/��z�-����rc�����n����is���K˖r����@���t��A��3G��c��;Z�	yIF��b�9�B2w�64�ǝ�'�ن�r��f�4N�˥R��fYJ�6����?��[�>������
�>)w	��c�ݔ��O�0��|��%�˱����w�(��{��o�(Ż[��TT7r�)�.�A���cP�
��ۼV@φb�D�M�YaeI8u��4-C ����o6sbkKG�}>ӄO�(l�!W��ˋH�}��6b*}�1;�/P<���!���|����P
Q�d��a��]q���	inē�[L+��Qn��`MUN2����`��?�o�\K*6���G�S����5~2��6���ED����ρ��x��|�_�|�a���)�Ҡ�M]�0D*{X�:��Q���9_"f@N�J�^�(��R��9W�M��}����t��W׺rS��r��Mc�ɁQ}Zi�a䨭�B�C$�Q ��@��`z��������I|\���$�FS�C&Џ-�3̐2X�9��%�)�7$��5C�j�D�����t���\M`�c���>4c���L�8��7�g���B�[���I�#��ߟ^�'r,#Ţ�n���j�6����F~��5�iH�i���&�wF6��(�/dX��h��r�
g �۞��x�M���4�d;B9%}�5�u�1X��	��V%��h��݈r�,�Q]�5˥?�RK$i�]J����[C�mR#Rd���2(#��2�Ϭ�i�w�bn��W�'��ꬤW���#+�"[z�����/�c��MU?J����x��&b �m=yD������O�<'l�Wŉ��\�b�a�]@��C���M���C���:����ŊGd�س���uN�    �4qC7�A�3᬴\�p5P��:��"}��ؑA�0Fߢ�I8w ��E��Je]�k���I��;�Ol\����acY����E��SlIJ"ao$����w��}���wS�*-�?I���Z%Ոt2T
OJ�b���ږ��$��#l1{/^�*1�ff�s,�����5���$���PJ)��X# ��Q��t��\SJV�u��b��&��| >���(��D}<=�Ӗ�(�is��e�+1�QbSɘ.�����& ����_���J��l��(���5�\'D.@+�P5<���
K\�^��]�{"OUҥS }nlShr;#752�Mt�����|G9�,J���+ۙ{dkC4M�ꥆi�r%��dCq���g�*7RT oШ�	\���b�X(�L�p�ٓ�x縍|������yl�⣋&&@&L�ۙ��ø:'�o�XL��'�f��V���}���"|
K,+�-�`ܸt�)�K˛��В��.:av���WB�B��[�� ;�g��R4]��Qr��-�&�٣��J3�1s�x0�h�fh�;r'��h�
�#K�u,�;8���1<e�,� �:�!� hZKx�l43�^�_7�����Y�x?�A���?��B:J�tAc��&}��[��	�S!l'���떰��6�� �|Cv��ї��M͢ c>�2��rfO}��Ц�9N�rjɝ���ah��F� ��Y;�SOo�;�gvM��z (�|?M�:����5d��/�~w}���ʖ��qȱ�>���xɒnS��85Mi)EZ�Th`�4���W���9X���8.��\B�|j/ʉJF=����(��
�����K�e�𡋆�m�{Ϧ��ҷ)�^�p�'rWQ����*����f�D���G����̀��o8�:Cs�<�Y���{ht�ǈ"�`�s6�w�?��ӺJ��QP�a�F�<�f��+�G|��?�K�޻�_R<��N��c6�;��`���PV`}(*6qi�#�(뛈��
(��l.��"����	$�a愦D�����o��|��rm����'��N���ZP�'c �o[��Ň��8@�;N~K�f\a\�����û:E���&�I��ZA�;��<U�%t�7�(>Ιv�
�I�J�$3�tx�)���(?���f�c{��BJ"�FV�)�Cg���2j����AX��'���lF���7��Ħ�~{5�}s1u��^��s�U��M�Q������ѵ6tG(&��(��D6�cM�є@��Nx���r�J��W�S{�V^�%W���7�Ϝ������Y�wt��O,�oR4��PZ@�{��\UTkT���L`��6/��hVo��?˒RXfv2N�Ŧ�����!e�%��t��x����`�d�]h�����&��y�-ʴ���WiBd(�y��E�@��7���r�ZΩ�~Vڋ�A�mJҖB6�))V`>�N���:���dh4�o-NDLK��C��M��G�T�&+����5�	�|�3�;��%�\Z\��:�ov�[	/&/{����k����Kv�i�%��'�P-?TZ�4�L�vT^�4!/�[4R��"e��t��Ĭٯ%x�a��d^�ʐ���uFt���uk��Hl$����c��m�@���J�\�p�󵻄O����f��?2�s����7ZM� �%xjИC�Pq��)LC��J�ٌ.mG$>�i�&m|�#�j�
��_�J��3�"W�����Yk5N�_��u5���!0��%58�]״Rǔj��8��yiUoa�5�7f��~�Fչ_q	�P��M*�A�}ߤ���_0����/��eɍ
��Z�6����׽�T��f<�`P1޶h���Ƣ7�ө�
]��rpjf���V�!/AF�1Nh�ua�Z�am�]���8����ZCL�(���N�O�^ !	�k@L�&+<`"7�rg`d	��qʔ9r~yM�����A;T�V��"^��F:���M�B��� ��	�J+s���&�U�R���#���B@�����~�}�]�X'Z�&�<�芿��)�4ϴ���w��y�A*�n$�� 2����9�4���dNc��	�n^�r8�����m@J^A��l�M���-w-�`L絛T�|�'�!@�d�/[�
��Ç_��~sD�؈�B�oD�H�5~%��%�IZ��P�[R�R���Tɶ�<p��k�p��$.r�[����d��7��Z�Y2z9PW��� Q��6�:�C�Ro��$�i��7h�h>�Y"�.��Pu��2T����'�-�4��A%6��Il��=�*���~x�ݕ�v�J�x, ��~�G:ӉYG�}8zptF:�\_*��I\)�����fV�Oɨ��H�_�ۉ5:�~�[�PǷ�JF��0��V
V~��h��Na](9�Iƨ����^$ VS
xS�]"�2G�}��/���4� ��.}�i�Cv)eב�Y%�es��O�,�(����|�cMv1|�B�^:a��� ����=n.��R���*?I��d�����Btdc��<�k���`�ZZ�#T���)������*�3߆���Qῃ���nj����D�^��t�$ʻ�<-v��K)�t����T��^�B�ݖm�_?�� <�BI��0B��%�;�%i���&�C
R�AxxF�L`]�N?so!��ba?��ʌ�q��|@<�b<Z_(��![�JJg����P��P�}�瘤UwH�&���Ĵb����OjqD���P<Xғw3�= ���(��J�A�L�����U�v2Ka�>�_ge�{"��d�;�qI_a��i�-Z�
Q�?Zg'Zi�."���h���\�VL<�����5X;e��#g�U_KC�<��Ln߬�x�I	Y��M�R��ޕ��s��V��u��?��"yFW�Ns�r�G"�}�a'&<��=���5q����5��:>֤퓗�R�o3��L��l����Rx��mDa�0b���͓���N��ۤq���<�V�|�ѐ}��Hܣ�b��)&�@�mZ�u�Ȧ��BL۔&6�e �������t���-��!�ghU/ )IT4(uԔ��v���P� ���m{'��@�	�8cJ
�ˊ�E3¿�]�+��Ie7�Z6��)/��5}y�kDnl��t�q�9(
^j8�JR���»Y[���BN�k8;�x��sS(�o�hf�cH�!b�P�)�U����'�a��RL�Ru�}E��0��̜Ԏ�8�dꥀ]�&%��&��O>�s=Eu$���� y��6؂��*�?��WG�4 ��n�X�.'G�ޡ�`��Ҧ���$Į��T�")�J�<r
A�4�k�'ہߗ�4��S�&6S�Z�v�+4�[Z�sл�Qw�t�WF\����š)1H-��I�0\!P[�����4����X�cU�s�x/ i��*?��@��1�f��6@��Χ�4̀ü�="�Fۘ'�,6��!��4��-���T��ժأ����9#6���6xN��ܠOk*H�x�v��y����2��'�L�gR�.zQ3�B�� #߶4i�B�PJ� ȓ��̣HS�RגwO�+�1��2#9	�j�W:�4�g�H?Q���l^՚6�Jo��uN$V��aY�����.f���Z*���؄}������g��H+���c/4��HE��=���w �c����Ia��g�z@}�7]�-��q��7�Ӂ�)�h�0C[�A���~z����A�XL����V˭^U�V�)�Dwy3g
�zz%�f?'I��-C1M���Ք*��7���4��N�XM/m��(*�5�^E�	f�#Lȸ�(�\�D\�k��������	:.5���Q�~���
�V�M���"m N�sͲ�,��d�����[��T�Њ�,&�;��.��e����v
#�
�:��"js�]��� /{����� �$����sJ�Gu%Z%���."��6`ą��Yܗd,�A�
�F�#��VαZ�	��X�     �d0 ֣�hZ�(��1!!��NNM�g�rD�9��g#��u��U鿐 ��u1��Z9I�9+�b@�嬆8�XN�H-�� ZMפ7�|ɩ�.$(��5H�Zn����An��t-n�U���h��f4�(Y�.�i=��.MK�-%����}CNT5�E�z<G*����Q�c� g�7��dؤA�5��70J�^�"��)��Y�'���b�e�s����!��&E�u$w�ھ}Y$2<��<`S�!�u��T6��hW�]Nmws�(�H���#��m[�LU�gt#�Ru�]'����pZ��G���n��kۦ7�KB��i􎈓�CrBOn�)��q��`^{)��%�H�ߚ'B�
�ӌ�~=��=}��-e4Y=+�'IR��d(9"�X,jz�3#i��6Ym�n:��v�����O���7@w<P-�����v�>����c_��[��R[K��2���jy�wE�YwÀ�tS��E����xH�	��6b�)(�L-�7):���4�E:K]�d������]g!�U=R�~h;��D$��HERb�ֆJQ�4��fV~����U�a24���T��:
���vj�ho�PG$U����Q�v5[a]�t����-���о�YB�Id�M:����ڳE��F��GJ�����V{�Zs7aҢ/;������q8� v�MJx��h	�D43fb����^ �"�G;v��5�uGt��q���m�Hx�m2�'\t����es��l���D.)`H�0/��5��S� `��O�]��i�U�Х7-R�ҏ`���Ч��N
W�`k��[M���r�o��]�[��t���� ˷�PS�Z��v����U�yDӘ87I�����D����}�4���u�����@*MeR�
	�^7@Zt?0�D�X
K�~V�~����-[�o���B� Yl�e��Y`�.���#s mO
���0�I�	�(��TC��+o+�HM:�S�@y��5p2���*B��aK�?1�0�=0����0�6T��E�Gpp*�VRT���l��1�E����@E�MP�i�:9я0��Wl]����S�R�m�r��äEP�_�2��Y�e�����(����&R&�G8I�z
T�K�z7Ku����m4~�wԐ{mE{A��F��!��"=9$�Dw�F G�{J�il����(�Rr���e4��zgk�h0���(�e��ާU�>�"�+���;ƺ�J�\3�3�A#ģ�3i�H}ю#_��P\])Ɵ2��gd|j��J��<�̈́l-@:�����a���<��$�e���z�.mL�z��bi����Rt�~�y�z�ږL���t��JA�р`���8��'�^݂2��k���	J�P'�@�<����0��{�,	LO�9=���z�������{ ���:�D�,0s"�JG���8���],����y���vKn��%�+M)��9�Z�̉��_q�[�p8J�\У׷�Lm�^	�V�s�Z3�(7���H��#�6?A�0�c���k͒[�K�`ν�B�$�L�k�'��]��N���ɏ��t��U"Q$��#Z�j^9y@jE�y�wt(�z3���F�M�hV���GP#��S���_�m�HDX�i�o��qX�F
���ހ�1V�:�2�9!yR���4S������%<`jǙyZ4�OQ���𤗢�G�
�^;ѕ8�H���r�ʇh;���Ft�@J���6���2�� �����f��O�iHK獠G�����
fG���v/�4�%J�<q_�|RnN�I��F��1%�
n��9��oh���U�ib�#һ�Cd�3a��{	S޷�%��.��h�!��I��Ҹ�6��濽�(!�~^�#~�3����1	I�¨=F ��lk��n�cP�k�8�����-J�T���3�g�2��A뢇{�lΗz[���`�W`��t:V�������쾺�ڋR�����HE�^�dꌸL����a��iN����y�;/=kۖ�L��-_n���x|��1"�݌�+cE��+���)���5kpM�F�j�b��5S�
w��Az�)�Нc�s���'�v0�\$�7�%�ZIj�a��C��t�����7�04�7(^�	&j+��w��|.J�^ڦ�0Kn�����(�{fB>TѦ��KpGm4>6�=q+��0A��6�C|���T���Y�8���H��1�1�&_?$gi����U I�U���>��j��������-3c��+q�����}(�����f8;�Ԩ��� � N9�5. �{���Uhm3���[? e���jz`5��49��4�4��Gd�ái�
c͗k�L�9z��$ٞ4P�z6�b��f=z>/"`����*]h5\r:\�� Y���x����g�%����y�WJJBUe��ɣ��Y�B�{�!�9V�;Z��3}�V{?�"���,O�)/��PK-|%']�2�p6u���ʟ�Rh�)_fw�c��6	p��n�r��[O�n�{.����,
[�:�#C�%�j2��A�Go*�4VRZ-<�d���Y��R=]Z��MB��5��s�H���yH���b�@�	+3�iF�?�T�:��0k0�[��E�����(���M4B�1���*gI���@�$�b�0�cl�*V�+���^�'�Z�eIuAZ��8 hd
���'q��AO�
�7�!��2�;m$'Jc|�e�����I�AbZ xi=ԧ�󟔹-Cn��'��g�DFof=�F�:��8��wJؒ�C|��?$��6(@k���GQ��6�
E� �d:� ��&Տu�t¯H��,/7�a�I9�2�=���h��&,Fc�3-cI��R���+u��&a/
>�C��D�ѹ_����ʚ��T�妪/>�*��Q
^��n�Y�\��k�[���Ǽȋ��Db��~�,���6E`�ѡ5�7�
Fl��a�us`�_����=Sې�K<#���b�m;�����|��Z�a#���RT�j;Ճ�2^�T;ډю݇Eۡ��U��Р�}h:�`����O:���'*�`.a�	�dso⧡����՟����@1�`��^�|�Y�٨��]���Rz���<��ʨ~��O�-q*�U�*O���6���a��`�E9k�g�:�F$��Nz�W�T��ZE�+��٩o�SϚ�fi�f�'2Q�u�/�`z:2#��a����h�;�Na�X��<j$�r��s_g��Ky�rCY��j~<��H��m`����,�p��{Z�㢟�"��q����L�c8�X���[���.���n�U�֭4��F�9�)�w�(���H4�!������ӕ"����@&��� a�f����삃���=�OғF&U��FSK����Y�V�9T������<�����R)�N�Ds֫D�R�,i�C��z�k��DS�n��ǒ���b�i�)���,S��5�����W2�s�m��b����9�)�v"������}����YA̮���X��t?VЦO;T��_g��ݵ>p��#X����G�a#}P`�D�A�0�ʕ=�����@2W�zY�� �M��i�=��xal4�la�1�����)�:���r�N���v�*�k�pW��H �ھ���qI��[qk��~�����WPl����8�#<	� �x<�8��1�t�9��ܞ�Ӹ��г��1�.�D�+���o��L"F��O*����Fۭ4�%j;5�8��糱[ICM�� ��J~����|�HK��3E; S�C�44�b�4�ѹ����Ê}�TD���|��~�e��H�#ReXo@��QQ����-d左٦ �BIH���E�� G[GN'!_+$y�N���歘Z:Z��Y�\S9+`��[��Q>���И�S�.�+��V"��e:���F�V I�}�a�a�:�7��
'� x)߲T�5�Ye�6xT�U$O3:`Ʀ��j���x�,�ޤ�K��g.�ƙn�82�����lG   �A�QZL��jj�.Wr,���u�����Z�ξ`���Z�%��
�\�	b%�����"����V�AWz��w�t��j��;%#���	�^j�g����G铱+#�fꎳ�Vl��@��#Ḏ�B>N����T*��S�\�d�d��:V���#�5�5eq��Ĩ�+�N�}h���`�
T280���_I047t�b�GD�%v��0�bjF�(��S �#z�'��X�'0��T�:9[`�i!� >�XX�t��k��5*㸧�I�w7�Ⲓ����(��|+������z�h6�4K1��i����s h��xB�O���?�B�V�xa?G���t@Q(!�8�w�� �t��"��F��8]`���0w?!�j��L�/�=���c���La�:�*2}O�?�ry�#R�B2?h1(�����m�k)�x�'�F�f,�Ԏs�/�=p}�p�/�c7x�S��% ��)_��rǹ`��yDv��?�Z�H�6a>�rԡ�^���?��IG�t�G�Lps�e�順e�0BM֦&�g�j?��h�����qAȄ�����h?��А��(�w��_�o�o�y� �D?��k\�n&�<�c��^���d�تީC�8U7�������
_�(��ܛ���`I��s��I"[+�E���L�Nࢶ�tj�Y���Ck���ڝ�V�C��1��������,:
�Jfv��
3(1�a��b�@����rB��с��=F��(3�DNR��(B�Z},0h�碽�f�"��4�`�s�&�K��:z�ÞV�p�7��g�`��$�kxi�a�ފ�s�	y�0\B'�_�p��|�Ned���D�j�5C;N�����}�������_1�,��<����͝RdU�I��@�����l��9�E�ftՂ���g��Q���da~@H�G:v锏{�(�%֟��;���_(em�����D�ߍ�(y��X��[
.�u���Ee����؅i6��ȸ��=�R&�;�B�jXݲ\_�ߪ��܅���&y�G�QY;p� b�ɷ��С)�Q?�!����.&C`�eVYf�8�F�HrqH�QK��z�!`K�����|7�gL�<�A��U�h�'B�fl�N����p�E���U^ÿLZ[��5�\�3Ⱦ�����
�6��<�I�D�x�MBt��4���(��N���!P2�_�qۄ����k� ^�P�����\�=�LjV�d0#�&�6�W���`O�%�S����v��m�x��	C@{�a;K�J�k��j<��bz0k0��</�F�	��9��җ'��F�9`2����Ts��탓�^�b�4QenZ�|�,G26Z��6���t��R��0hK=��I�i�_��	�m� ��Y!['�c�L$��d�X"<�Z���l�쎧��h�T'��li�e���9
���<w)�c�|/ȀS|"�Q��7-��2�VU�P��(?��(/�P@�^e��u�4�in������,b�f#�Ѻ����A�<����ruu����t�      �   6   x�3�t�/R�M��2���Alc0;=�(����Nʯ,�2�0�2S��b���� PH      �   �  x��V�nG�O�@�|��.}��`�vDIS�R�&i�#�Ua`1vy��7�9��~;Ώ
˂;g��9�̙�����
?�S?k��:��v�rܝ�r+����{�������	>Wn	�LC��{��L�d�
FL�q��⿅-���n�vX�=l���o�_��/����)@$L}�ʪIi�}tKw�,)�JL�e��+���v6F��ߔ���B�����Ww��K`Vn��B�������a�YiH��3w��X�g��	j������
�C��{UV�_��]@n�=��T��o0��2.�����@�[D���,".w@l�h���nT�9�:�K��e�1h�Ŗe�1��r��XI,��ܰ��̀<�5�!h�n�Of��0�^%�%ņ��L(���Yh�ٞLMi!����R}sd,�'d�Y�Í���j����h�P����W�0��t+��L��ӭ&��r�&��v�J�! �wzt��a�-ǖ9��yq�g��Y�Cq���#FT�
�!���,�f�x��׽�:B��h����¶qђ0O �䓸��lm����'�Z�����WT|Pyu8-����D� ���J`{����O�j$��0�N� Q�!�����k~�e�M��*Ԛ\}�`����L�,$đA=���pQ�@�k{��'B�'�	F$��Q�.d�}��ɲ1��1�`CG�d���������Lˈ����-��6ı����k��xR��I�?�L	��1;����7�����b[#�ʸK���}]�F�>I~y�rB]ڻ�'��O��0K�on� ���Kb�L�1��'�D}^;+(�y�\�J#a% y�R����L)���n3�p[������܏�F3�E��z��<fR�VDR�aA��ґ��DvF}a^'I15�۰zh���zzSaR�X����v���ت��zp�u'�Zf� f�y7V����J6V�;ͮS>�tP7_��wf�U(�^�]�t!4zP0zo�8�]�SR{L�Ã�V�ܦ�	SH	����K��D��)ݎ�k*���j�c��Nzno�1F�85\jH�G��ˈ$}<��KJ��c}�3U�2	za# ��Zc�2�sU�*�,[Oڂy�D�|Û�{1�>���L���zZ^=ܐ�P�Tl�̺� �T�n��Ǐ?���� ;��+      �      x�uZ�r�8�}��U��bw�Oqn�d�$�NwjN�DB$v(�Ë3�A]H��+��SA`��.҆}�.�ס�b�궋�۶�ֱX�{�W�4+���ze�b7��p���}��7��L�B�x�.�����eڳ�a���}iŮg}5a��������Ε+iʕ��1����ZyQ��m����=ֈ��˔v%d^�kU^�.�%��!v�[�?{�cW�E�XWËj]��氜V��+a8�t)W��2�m��U~�9m��X�\�X�̬`��}۰��u��1ž�c?T�tf���Y�@��5���ȼ]q�l�j���j��~(�;�tpZ]�Y��ï'��n����몮zl�i�];��>T5*4�dNڕ��c�/��"��;��]��j�������V�9j��I�M��8fl�v�A�j� �u�Oa׶��þ��L�}�ҭ�S8�ױ	=���8���6�X�_K�Y�^v�:��c���N�T�_W	>���r%S��2�G��%���N���u8���4aǾv�jZF(R�¾�zh��:o�ZI�|\�eU)�q�ƿY���:s%{����lCl�ذM�Z_��P���	��P
X��I�����[�Ӣ*n%y����ךg���]�[U�U��lӢ9'H��OV
 VJ1~��p�*�����}A=tZJc7Tn���$������.���!6����r'�ʕ�z�|��hA�$́"
5=ܣy��(�0�a�B]?�Wc�T�v�,��1m7d�	�SQ�� ��K
<1�L�y�4m���^�ڰ9�G�L�) �4��{����
j��f�I�ѐ� ������*��m�V�aYS��en3�^���8��ڱ�0N���i;��r��*d��	jy��:�\� �!����@�"����`I���NY<��MjT�}sɖ�[%A�/�ǰn��>F�|�xQ�2���eͽ'�؁1G&3�4A�o �D��P)����d I������5c]S�j�v7#��t:�8	L����C?���I[$Q�H��9�?���:�l�{��������)I&A[;-K���^�?�,������qh�~��!"��P��C�m�w"�?G��\^A
l��$j����7��9qM��������6l_M�(�u��
	N�94�9��8=�d�)����U@� F�9��m��c�lQ�Y}��k��˕�b��rx�� o��Vq�����W�9����������+���E�=$r�v�*��r�z4�������H`aT��:��7j���l�0l�C�x�چ��T�ش��Ӕ�"�J%$پ�j�m�j��h��a�����vۅ�j�"r��U�㖓��F�F��DU�� �ik9wT497��z���Vo "=;Jqj���@2�#��;n�R��+�|�/{_�ZqRH[�&�пk�>������U�rssq�Pp���}��خ�_���_������a��4@5�}
O�ۻ�Md��c؏��:u:Jښ�(���/���oP��8:/9�Bp4#y��uh~B�w�K�v�A[K��0g�R��t�g�IҐ�[µ�#%� �D�>���g\W�-P7��Փ�CQ~+8�CQ�ZQ��f�����&�D=�e�uበV�'Pd�.ꘪ�7q!�ڹ��R���(ѠR��<K�!�οD�@��Ca��$`����.Dx��:(A�r���Hs}s�M(��:�Eb(ᅈ!g�Z&�Y�kr��L��XjQ�����3
�����!�(���0�6vk�MϾ�!&�%71]��m��Wk�v��a��߇Wrbz��Kaˠ�Mþ�����O��%���P��qc�$�%��Q}��	I�!
@�7P�fK��lnRї�~�ZO!z��j楘��$��d�8�l�Fg�P�8�]Kd�_��W
��Z�N�核`}�-Yxef�j!0�W����X�"�Wt���$�NkH.h���Ԃ �Ԅ]k�&[��O��]��*�Ȕ�N���p�5���ª�H������2(�4vx�I�:�?c�0ۈ���yG)!_ʝ6��!�]"�'
�P%3p�x��pb�K!4�U&��$[x�ݴI�<�靝:��K�j��q(��YW��Y�]��,�cRSJS�=�������<"qw}~K� �}��������P���a9�]9㞸�D��J�(�-܃� Ռ��X6�C�X*0�	���;9Y���j��OHȋM�bn	� ��W5��ֻ �&V���|t��K��ɸ[N�!O#��K�Vͅے)���D�vW=�؃H���(�,�J�M+Szl�'n`��~�nR�<)+�ѷ [�����1@�e�� �x��ʔpT��&h=O�Z��m&%{O��	'�'��h #�0DhQ;<�P��7�~7'R�!$׃���}�a�B�n�?Y�'�Cz^�Q�qD�"M<�I��{IX�Mh*���� �w������_��P�Ŷ���J'�H�85=Sj�F���PrQ�!i��T<�3Y���҇���Ѕ��9�㓡����d�=��*�߯#ب�����v���"�ƪ*���3�>���Ω��k����®�L�2n��^�_f&}�6���<� ��K���h��� 
`ɃC���,�DU
�Z0[R��@lO���ƃ�(Rz�\�pK�>��^���M3'$E�J���l ȓ�*t���n��H�Ҭw�X�����Z�4PƖӣ�G�����U��ɹ�D(��B3Ł�G��?�_	_��j/���u�R��pY�*7�Ϝ�K�A9��h�f�V��%S�V9��Lv"�C�2���/#�H�f�hFl�h��%�Ń�_���,�+���Kqy
�8}c�a�g�B�0�2�����4��6E��<��-������ 5M���i��̐:RJx�=i�aq��}Sm� QX2�IxIK9�#yie���"�����4�V��o��ퟡg45��D�C�/��*.�����7MiFZ��&�����a}���8#�b�qB/M,y��	N�T�^�&K���n�At�(���}HcE$���̒�}�	��3�-jKs,��ެ�����\��9�.��e�<�ܯC�^���(�e�D5� 78Ibe�1�c�ϯ.��"h�����dכ�b�P��+��.n3 'T��R��4��.��RO��-I�.��S&��ݖ�NN���ی��G�Uζ�铞 ^Ez����	ڙ6��A/�H�l2�;�[4f�TU���,�c�o=LH+Ҁn1C��@� �~���۴{յ}�~o\fve!^�K��+i���Q�����$��b(�E�wO4Y~v�K�U�o��)�H=��:�i��ah-e��&�i�m�x������NG#��4*�p��������E2�i*G�X��m����X7��wau�)�Kp��R�i�|��2�����4�D��`�n����!~��~!����a����KJ�(�Ͱ'jA"r]B�Mşj�v�4T�w˾H	�FK���~�W�og�߻iP\D��̴@4��u��m�/�%�}�$��g�0i��+��	�cSM�ҍ�V�cՌ=�\��f��Ӣ����.�C�#�6�Z)�rT��.���l�'2����'��U��f��j:�G�}�C�KR%]�8�Di2��̿��������.G�"se4{߇*��o]ܶ���\�Q�8I�8H�g`��{>ə�0FfƲoO0�ΐ�@�������x `xe������\`E�?��!]�8�{�x�`��pö��q�M�N�y�ӥ/�t[-gWd�r��פΌG�ڤ{�!	 Q����p�E�7�vs�"�c溴)R�/Y޸Ζ�?4�ع@�h��O)������E�LZ[k���9xċ;�����`����p�]����6`����8�?j�(˜�EF�..�KwC*]<�̋S�$�z�͡c��![�,.yi�������KS��
[R���.�w��� 4W�ginQ<tվZ�Mm J  ��B�a��pP��<���+����Q�O��[2���)��@�SENz2<�S +υ��iU�e�Cr:�6���&у�*�q��b\�o[��i�^���{15F'h��t����yO�k�iS�{��"	�t�n�$L��ں��!��ͮ���T�0�Tޭ|�T���f	a�B<q�4�4�r�W�ف����d[����6�|]�<��6�bvR�<Mץ�Tk9��fpo��is���&Am=��]��mrW�<^JM����s��jC���i�%�M���/���5ݨO����+IE�.VE���2Ǡ~:��(���:�G�x��M�Ȥ.�B�%��/1f!�
rhK �+��1��CI#LҸ�H��F���?Oǆ$6t�{:�T%��,h�DJ�N��C��(S��t} �D��ֻ:��uX��$3��ı���ƥn�ӜN
�E*䑃��-7]'��`�
v��"K+ݯw� ��ɫT�s0הذNiR�@��q�W3���h|��
ߋE^��!��á@�Ly��#�tEWr�8�7��v����̨���NCg��{ƛ��\5gCy����R���w�;��oM�=8Di3o؇t_��mB��?�Q����)G<�}�FIIDAw^"d}�U(�'Ua�V��[��
$��^�.�坉Mf��d�<����+�e^!'��R��j�lӥ�q��š�.��{O߰:*ԤA�kO�*�bơNW�0��YB��#P��BG^su���;���֔�i(T�x����}�Nw��UY��С47��7���*�y(�|J�Y���V�{��>�Dw__���kW�rx��E�e�����     