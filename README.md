

# Shopping Cart Challenge
It's a solution for the online shop cart.
## Install

### Clone the repository

```shell
git clone https://github.com/luchiago/shopping-cart-challenge.git
cd shopping-cart-challenge
```

### Check your Ruby version

```shell
ruby -v
```

The ouput should start with something like `ruby 2.6.3`

If not, install the right ruby version using [asdf](https://github.com/asdf-vm/asdf) (it could take a while):

```shell
asdf install ruby 2.6.3
asdf local ruby 2.6.3
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler)

```shell
bundle install
```
### Check rails version
```shell
rails -v
```
The ouput should start with something like 
`rails 6.0.0`

### Initialize the database

```shell
rails db:create db:migrate
```

### Server

```shell
rails s
```
## Endpoints
### Update cart
----
  Returns json data with all products and cart costs after send products amount

* **URL**

  `/api/v1/cart`

* **Method:**

  `PATCH`
  
*  **Headers Params**
Must have a token to identify the user
	`{ Authorization : string }`
* **Data Params**
`{ cart : { apple : integer, banana : integer, orange: integer } }`
* **Success Response:**
  * **Code:** 200 <br />
   * **Content:** `{ apple : integer, banana : integer, orange: integer, subtotal : integer, shipping : integer, total : integer}`
    
### Get checkout
----
  Returns json data with all products and cart costs

* **URL**

  `/api/v1/cart`

* **Method:**

  `GET`
  
*  **Headers Params**
Must have a token to identify the user
	`{ Authorization : string }`

* **Success Response:**
  * **Code:** 200 <br />
    **Content:** `{ apple : integer, banana : integer, orange: integer, subtotal : integer, shipping : integer, total : integer}`
    
### Add a new coupon
----
  Returns json data with the new coupon id

* **URL**

  `/api/v1/cart`

* **Method:**

  `POST`
  
*  **Headers Params**
Must have a token to identify the user
	`{ Authorization : string }`
  * **Data Params**
`{ coupon : { name : string } }`

* **Success Response:**
  * **Code:** 200 <br />
  *  **Content:** `{id : integer, name : string, user_id : integer, created_at : string,updated_at : string}`
    
 * **Error Response:**
	  * **Code:** 400 <br />
	  *  **Content:** `{ message : "invalid" }`
    
 ### Delete a coupon
----
  Returns json data with all products and cart costs

* **URL**

  /api/v1/coupon/:id

* **Method:**

	 ` DELETE`
  
*  **Headers Params**
Must have a token to identify the user
	`{ Authorization : string }`
  
  * **URL Params**
  `id = integer`

* **Success Response:**
  * **Code:** 200 <br />
   *  **Content:** `{id : integer, name : string, user_id : integer, created_at : string,updated_at : string}`
    
* **Error Response:**
  * **Code:** 404 <br />
    **Content:** `{ message : "not found" }`
 
