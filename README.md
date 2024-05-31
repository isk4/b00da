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
### ``GET /markets``

Permite obtener un listado de mercados disponibles.

Ejemplo:

```
{
    "markets": [
        "BTC-CLP",
        "BTC-COP",
        "ETH-CLP",
        ...
    ]
}
```

### ``GET /spread/<market_id>``

Permite consultar el spread de un mercado en particular.

Ejemplo:

```
{
    "markets": [
        "BTC-CLP",
        "BTC-COP",
        "ETH-CLP",
        ...
    ]
}
```

### ``GET /spreads``

Obtiene los spreads de todos los mercados disponibles.

Ejemplo:

```
{
    "markets": [
        "BTC-CLP",
        "BTC-COP",
        "ETH-CLP",
        ...
    ]
}
```

### ``POST /spread_alert``

Guarda un spread de alerta para posteriormente ser comparado con el spread actual del mercado.

Ejemplo:

```
{
    "markets": [
        "BTC-CLP",
        "BTC-COP",
        "ETH-CLP",
        ...
    ]
}
```

### ``GET /spread_alert/<market_id>``

Entrega información sobre la comparación del spread actual del mercado versus un spread de alerta guardado.

Ejemplo:

```
{
    "markets": [
        "BTC-CLP",
        "BTC-COP",
        "ETH-CLP",
        ...
    ]
}
```
<!-- GET | /markets | Permite obtener un listado de mercados disponibles | tu
GET | /spread/<market_id> | Permite consultar el spread de un mercado en particular | tu
GET | /spreads | Obtiene los spreads de todos los mercados disponibles | tu
POST | /spread_alert | Guarda un spread de alerta para posteriormente ser comparado con el spread actual del mercado | tu
GET | /spread_alert/<market_id> | Entrega información sobre la comparación del spread actual del mercado versus un spread de alerta guardado | tu -->