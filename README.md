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

```
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

```
{
    "spread": {
        "value": "464705.99",
        "market_id": "BTC-CLP"
    }
}
```
---

### `GET /spreads`

Obtiene los spreads de todos los mercados disponibles.

Ejemplo de respuesta:

```
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
---

### `POST /spread_alert`

Guarda un spread de alerta para posteriormente ser comparado con el spread actual del mercado.<br>Retorna un listado de alertas guardadas para el usuario.

Ejemplo de cuerpo para la petición:

```
{
    "alert": {
        "market_id": "USD-CLP",
        "spread": "20.5"
    }
}
```

Ejemplo de respuesta:

```
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

```
{
    "spread": {
        "market_id": "USDC-CLP",
        "comparison": "less",
        "difference": "-16.5",
        "current_spread": "4.0",
        "alert_spread": "20.5"
    }
}
```