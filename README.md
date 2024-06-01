# b00da REST API

Esta API se conecta con la [API de Buda](http://api.buda.com/), permitiendo:

* Calcular el spread de un mercado
* Obtener el spread de todos los mercados disponibles
* Guardar un spread de "alerta", el cual puede ser comparado mediante polling con el spread actual del mercado

Para correr el proyecto, primero clona el repositorio con:

    git clone https://github.com/isk4/b00da.git

Luego, dento de la carpeta del proyecto, arma la imagen de Docker:

    docker build -t b00da .

**¡Y listo!** Ahora sólo necesitas usar el siguiente comando para iniciar el servidor:

    docker run -p 3000:3000 --rm b00da

## Endpoints
### `GET /markets`

Permite obtener un listado de identificadores de mercados disponibles.

Ejemplo de respuesta:

```javascript
{
    "markets": [
        "BTC-CLP",
        "BTC-COP",
        "ETH-CLP",
        "ETH-BTC",
        "BTC-PEN",
        ...
    ]
}
```
---

### `GET /spread/<market_id>`

Permite consultar el spread de un mercado en particular, a través de su identificador:

Ejemplo de respuesta:

```javascript
{
    "spread": {
        "value": "464705.99",
        "market_id": "BTC-CLP"
    }
}
```
*Nota: si no existen órdenes de compra o venta para el mercado seleccionado, el spread será*  `null`

---

### `GET /spreads`

Obtiene los spreads de todos los mercados disponibles.

Ejemplo de respuesta:

```javascript
{
    "spreads": {
        "BTC-CLP": "391144.0",
        "BTC-COP": "4679396.99",
        "ETH-CLP": "23765.28",
        "ETH-BTC": "0.0014374",
        "BTC-PEN": "214.77",
        ...
    }
}
```
*Nota: si no existen órdenes de compra o venta para algún mercado, su spread será*  `null`

---

### `POST /spread_alert`

Guarda un spread de alerta para posteriormente ser comparado con el spread actual del mercado.<br>Retorna un listado de alertas guardadas para el usuario.

Ejemplo de cuerpo para la petición:

```javascript
{
    "alert": {
        "market_id": "USD-CLP",
        "spread": "20.5"
    }
}
```
*Nota: el valor del spread de alerta debe ser proporcionado como string o número entero.*

Ejemplo de respuesta:

```javascript
{
    "user_alerts": {
        "BTC-CLP": "4000.0",
        "ETH-BTC": "100.0",
        "USDC-CLP": "20.5"
    }
}
```
---

### `GET /spread_alert/<market_id>`

Entrega información sobre la comparación del spread actual del mercado contra un spread de alerta guardado, proporcionando un identificador de mercado.

Retorna un objeto que posee el identificador de mercado consultado, un string `comparison` indicando si el spread actual es menor ( `"less"` ), mayor ( `"greater"` ) o igual ( `"equal"` ) que el guardado, la diferencia entre ellos y sus valores respectivos.

Ejemplo de respuesta:

```javascript
{
    "spread_comp": {
        "market_id": "USDC-CLP",
        "comparison": "less",
        "difference": "-16.5",
        "current_spread": "4.0",
        "alert_spread": "20.5"
    }
}
```

## Errores

En caso de error, recibirás respuestas de este tipo, con su código de error HTTP asociado:

```javascript
{
    "message": "error",
    "code": "not_found"
}
```

Los principales códigos de error entregados y su significado son:
Código | Descripción
---|---
`not_found` | No se encuentran recursos asociados al identificador proporcionado
`service_unavailable` | Hay problemas con la conexión al servidor de Buda
`internal_server_error` | Ocurrió un error al intentar procesar los datos

## Supuestos

* La API es pública y no requiere llaves, por lo que se decidió reconocer a los usuarios por IP.
* Proyecto de pequeña escala o prototipo.
* Dado que no se requiere persistencia de datos, se trabajaron las alertas dentro de la caché de Rails (teniendo en cuenta de que, posiblemente, no sea la mejor opción).