PGDMP                      }         $   playground_start_20250220_afe73fa65d 0   15.10 (Ubuntu 15.10-201-yandex.55221.561167750c)    17.4     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     >   SELECT pg_catalog.set_config('search_path', 'public', false);
                           false            �           1262    41730474 $   playground_start_20250220_afe73fa65d    DATABASE     �   CREATE DATABASE playground_start_20250220_afe73fa65d WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';
 4   DROP DATABASE playground_start_20250220_afe73fa65d;
                     playground_admin    false            �           0    0 -   DATABASE playground_start_20250220_afe73fa65d    ACL     .  REVOKE CONNECT,TEMPORARY ON DATABASE playground_start_20250220_afe73fa65d FROM PUBLIC;
GRANT TEMPORARY ON DATABASE playground_start_20250220_afe73fa65d TO PUBLIC;
GRANT CONNECT ON DATABASE playground_start_20250220_afe73fa65d TO monitor;
GRANT CONNECT ON DATABASE playground_start_20250220_afe73fa65d TO mdb_odyssey;
GRANT CONNECT ON DATABASE playground_start_20250220_afe73fa65d TO postgres;
GRANT CONNECT ON DATABASE playground_start_20250220_afe73fa65d TO admin;
GRANT ALL ON DATABASE playground_start_20250220_afe73fa65d TO de_start_20250220_afe73fa65d;
                        playground_admin    false    4331                        2615    53354953    cafe    SCHEMA        CREATE SCHEMA cafe;
    DROP SCHEMA cafe;
                     de_start_20250220_afe73fa65d    false            C           1247    53354955    restaurant_type    TYPE     m   CREATE TYPE cafe.restaurant_type AS ENUM (
    'coffee_shop',
    'restaurant',
    'bar',
    'pizzeria'
);
     DROP TYPE cafe.restaurant_type;
       cafe               de_start_20250220_afe73fa65d    false    29            Y           1259    53354981    managers    TABLE     �   CREATE TABLE cafe.managers (
    manager_uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    manager_name character varying NOT NULL,
    manager_phone character varying
);
    DROP TABLE cafe.managers;
       cafe         heap r       de_start_20250220_afe73fa65d    false    29            Z           1259    53354992    restaurant_manager_work_dates    TABLE     �   CREATE TABLE cafe.restaurant_manager_work_dates (
    restaurant_uuid uuid NOT NULL,
    manager_uuid uuid NOT NULL,
    start_date date,
    end_date date
);
 /   DROP TABLE cafe.restaurant_manager_work_dates;
       cafe         heap r       de_start_20250220_afe73fa65d    false    29            X           1259    53354963    restaurants    TABLE     �   CREATE TABLE cafe.restaurants (
    restaurant_uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    cafe_name character varying NOT NULL,
    type cafe.restaurant_type NOT NULL,
    menu jsonb
);
    DROP TABLE cafe.restaurants;
       cafe         heap r       de_start_20250220_afe73fa65d    false    29    1091            [           1259    53355007    sales    TABLE     s   CREATE TABLE cafe.sales (
    date date NOT NULL,
    restaurant_uuid uuid NOT NULL,
    avg_check numeric(6,2)
);
    DROP TABLE cafe.sales;
       cafe         heap r       de_start_20250220_afe73fa65d    false    29            ]           1259    53355036    top_3_restaurants    VIEW     �  CREATE VIEW cafe.top_3_restaurants AS
 WITH average_sales AS (
         SELECT r.cafe_name,
            r.type,
            round(avg(s.avg_check), 2) AS average_check
           FROM (cafe.restaurants r
             JOIN cafe.sales s ON ((r.restaurant_uuid = s.restaurant_uuid)))
          GROUP BY r.cafe_name, r.type
        ), ranked_sales AS (
         SELECT average_sales.cafe_name,
            average_sales.type,
            average_sales.average_check,
            row_number() OVER (PARTITION BY average_sales.type ORDER BY average_sales.average_check DESC) AS rank
           FROM average_sales
        )
 SELECT ranked_sales.cafe_name,
    ranked_sales.type,
    ranked_sales.average_check
   FROM ranked_sales
  WHERE (ranked_sales.rank <= 3);
 "   DROP VIEW cafe.top_3_restaurants;
       cafe       v       de_start_20250220_afe73fa65d    false    344    344    347    347    344    1091    29            ^           1259    53355043    yearly_average_check    MATERIALIZED VIEW       CREATE MATERIALIZED VIEW cafe.yearly_average_check AS
 WITH yearly_sales AS (
         SELECT EXTRACT(year FROM s.date) AS year,
            r.cafe_name,
            r.type,
            round(avg(s.avg_check), 2) AS average_check
           FROM (cafe.sales s
             JOIN cafe.restaurants r ON ((s.restaurant_uuid = r.restaurant_uuid)))
          WHERE (EXTRACT(year FROM s.date) <> (2023)::numeric)
          GROUP BY (EXTRACT(year FROM s.date)), r.cafe_name, r.type
        )
 SELECT yearly_sales.year,
    yearly_sales.cafe_name,
    yearly_sales.type,
    yearly_sales.average_check,
    lag(yearly_sales.average_check) OVER (PARTITION BY yearly_sales.cafe_name ORDER BY yearly_sales.year) AS previous_year_check,
        CASE
            WHEN (lag(yearly_sales.average_check) OVER (PARTITION BY yearly_sales.cafe_name ORDER BY yearly_sales.year) IS NULL) THEN NULL::numeric
            ELSE round((((yearly_sales.average_check - lag(yearly_sales.average_check) OVER (PARTITION BY yearly_sales.cafe_name ORDER BY yearly_sales.year)) / lag(yearly_sales.average_check) OVER (PARTITION BY yearly_sales.cafe_name ORDER BY yearly_sales.year)) * (100)::numeric), 2)
        END AS percentage_change
   FROM yearly_sales
  ORDER BY yearly_sales.cafe_name, yearly_sales.year
  WITH NO DATA;
 2   DROP MATERIALIZED VIEW cafe.yearly_average_check;
       cafe         heap m       de_start_20250220_afe73fa65d    false    344    344    344    347    347    347    1091    29            �          0    53354981    managers 
   TABLE DATA           K   COPY cafe.managers (manager_uuid, manager_name, manager_phone) FROM stdin;
    cafe               de_start_20250220_afe73fa65d    false    345   �)       �          0    53354992    restaurant_manager_work_dates 
   TABLE DATA           j   COPY cafe.restaurant_manager_work_dates (restaurant_uuid, manager_uuid, start_date, end_date) FROM stdin;
    cafe               de_start_20250220_afe73fa65d    false    346   W.       �          0    53354963    restaurants 
   TABLE DATA           K   COPY cafe.restaurants (restaurant_uuid, cafe_name, type, menu) FROM stdin;
    cafe               de_start_20250220_afe73fa65d    false    344   t.       �          0    53355007    sales 
   TABLE DATA           ?   COPY cafe.sales (date, restaurant_uuid, avg_check) FROM stdin;
    cafe               de_start_20250220_afe73fa65d    false    347   �.       D           2606    53354988    managers managers_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY cafe.managers
    ADD CONSTRAINT managers_pkey PRIMARY KEY (manager_uuid);
 >   ALTER TABLE ONLY cafe.managers DROP CONSTRAINT managers_pkey;
       cafe                 de_start_20250220_afe73fa65d    false    345            F           2606    53354996 @   restaurant_manager_work_dates restaurant_manager_work_dates_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY cafe.restaurant_manager_work_dates
    ADD CONSTRAINT restaurant_manager_work_dates_pkey PRIMARY KEY (restaurant_uuid, manager_uuid);
 h   ALTER TABLE ONLY cafe.restaurant_manager_work_dates DROP CONSTRAINT restaurant_manager_work_dates_pkey;
       cafe                 de_start_20250220_afe73fa65d    false    346    346            B           2606    53354970    restaurants restaurants_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY cafe.restaurants
    ADD CONSTRAINT restaurants_pkey PRIMARY KEY (restaurant_uuid);
 D   ALTER TABLE ONLY cafe.restaurants DROP CONSTRAINT restaurants_pkey;
       cafe                 de_start_20250220_afe73fa65d    false    344            H           2606    53355011    sales sales_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY cafe.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (date, restaurant_uuid);
 8   ALTER TABLE ONLY cafe.sales DROP CONSTRAINT sales_pkey;
       cafe                 de_start_20250220_afe73fa65d    false    347    347            I           2606    53355002 M   restaurant_manager_work_dates restaurant_manager_work_dates_manager_uuid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY cafe.restaurant_manager_work_dates
    ADD CONSTRAINT restaurant_manager_work_dates_manager_uuid_fkey FOREIGN KEY (manager_uuid) REFERENCES cafe.managers(manager_uuid);
 u   ALTER TABLE ONLY cafe.restaurant_manager_work_dates DROP CONSTRAINT restaurant_manager_work_dates_manager_uuid_fkey;
       cafe               de_start_20250220_afe73fa65d    false    346    345    4164            J           2606    53354997 P   restaurant_manager_work_dates restaurant_manager_work_dates_restaurant_uuid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY cafe.restaurant_manager_work_dates
    ADD CONSTRAINT restaurant_manager_work_dates_restaurant_uuid_fkey FOREIGN KEY (restaurant_uuid) REFERENCES cafe.restaurants(restaurant_uuid);
 x   ALTER TABLE ONLY cafe.restaurant_manager_work_dates DROP CONSTRAINT restaurant_manager_work_dates_restaurant_uuid_fkey;
       cafe               de_start_20250220_afe73fa65d    false    344    4162    346            K           2606    53355012     sales sales_restaurant_uuid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY cafe.sales
    ADD CONSTRAINT sales_restaurant_uuid_fkey FOREIGN KEY (restaurant_uuid) REFERENCES cafe.restaurants(restaurant_uuid);
 H   ALTER TABLE ONLY cafe.sales DROP CONSTRAINT sales_restaurant_uuid_fkey;
       cafe               de_start_20250220_afe73fa65d    false    344    4162    347            �           0    53355043    yearly_average_check    MATERIALIZED VIEW DATA     5   REFRESH MATERIALIZED VIEW cafe.yearly_average_check;
          cafe               de_start_20250220_afe73fa65d    false    350    4327            �   �  x�UUKn7\O��K����%�I�C�b;#vl	l#��d�E�� ��3��F)r>�!���^�U�+&et�^�1ɒ�9��&�<Tg��e^����vӶ튵?�U��<l;,�ڇ�����W��򴭱x���1%SN0�ד���*%�i[%�I�繄(B1��b�hk<�^��Wm����[T�uo�'������	V�qn�p&���r��{�Vz GaV��\CN�(.��v������7x>�owz1�q��OX8`����I)H)2|�!X��&+c ]gO>EUeQ��Z��j�ǩ��#���������G�����i���̛ '�	*e'�T,�$4ڲ>XoJ�v��Y:���W|l�ҽ��U�?�{Ά����9k�*���d��tT����P�*T��N|�go���]C�����1^��Ox��Ó5<{�4TJ�Vd��f.b♂2�4�E��*Z�ꪽD���l_�_�t��96�E��pG���'p�B*N��B	F!.r�iR�^u���tɇ)vC�''#z��-z0�W��$�L>d�s�H�D99*��h�M6�.��a��A�o����+�<]��9nO��ܝ� �i	�M��$�L䢙AaQ�`�1�d�O%�.P��b���I߽}3��9��e�b�x�iR��39�K��b\e����ZҪ��\�R�Y�0�_�=����x׍3g�cv0��L�y�	d�p�Fk��X�3:.�g�㪽<A���9��wj��Ƹ��3ж;��8���7b�U��!{H�` ��Ct�Έ��Se��A���4����QɃ3�艻:�i ៲��%��AF=�Q~����>��w8��}���>���1���"��9��x	��0��%�. ��wE 2e�Wz�G���s���0�]t���9#��^Os�޸�A�B�F��8�Z.��6H�7��(�i�t5*y>ba}T��hD��8���}3<`�h0�B[��g`�D>��f.��zY������\{{ȝ�{���ӝ|}/���[Üa&���yΩ��E�9�'8)#�Kj�� �sT0Fs�ǲ[a=��v\~���pB!)$y۳����k�Kw k�3���:��[�Ň]Y�o���?�������G
s3�b���==��H�&	uz���]3��ݷq����EN�������4��Z�r      �      x������ � �      �      x������ � �      �      x������ � �     