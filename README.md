# Polymarket Open Actions

Specifications for enabling trading on Polymarket via Open Action Modules in Lens Protocol Publications.

## Table of Contents

- [Polymarket Brief](#polymarket-brief)
- [Exchange Deployments](#exchange-deployments)
- [Polymarket.com URLs](#polymarketcom-urls)
- [Gamma Markets API (GraphQL)](#gamma-markets-api-graphql)
- [Central Limit Order Book (CLOB) API](#central-limit-order-book-clob-api)
- [Open Action Modules](#open-action-modules)
- [Client Implementation](#client-implementation)
  - [Proxy Wallets](#proxy-wallets)
  - [Prices and Books](#prices-and-books)

## Polymarket Brief

Polymarket allows users to bet on the outcome of future events in a wide range of topics, like sports, politics, and pop culture. Polymarket's Order Book, also referred to as the "CLOB" (Central Limit Order Book) or "BLOB" (Binary Limit Order Book), is hybrid-decentralized wherein there is an operator that provides off-chain matching/ordering/execution services while settlement happens on-chain, non-custodially according to instructions provided by users in the form of signed order messages.

Underlying the exchange system is a custom Exchange contract that facilitates atomic swaps (settlement) between binary Outcome Tokens (both CTF ERC1155 assets and ERC20 PToken assets) and a collateral asset (ERC20) according to signed limit orders.

Orders are represented as signed typed structured data (EIP712). When orders are matched, one side is considered the maker and the other side is considered the taker. The Operator is responsible for matching, ordering, and submitting matched trades to the underlying blockchain network for execution. As such, order placement and canellation can happen immediately off-chain while only the settlement action must occur on-chain.

The docs for Polymarket can be found at https://docs.polymarket.com.

## Exchange Deployments
The Polymarket Exchange contract is deployed at the following addresses:

| Network | Address                                                                                                                              |
|---------|--------------------------------------------------------------------------------------------------------------------------------------|
| Mumbai  | [0x4bFb41d5B3570DeFd03C39a9A4D8dE6Bd8B8982E](https://mumbai.polygonscan.com/address/0x4bfb41d5b3570defd03c39a9a4d8de6bd8b8982e#code) |
| Polygon | [0x4bFb41d5B3570DeFd03C39a9A4D8dE6Bd8B8982E](https://polygonscan.com/address/0x4bfb41d5b3570defd03c39a9a4d8de6bd8b8982e#code)        |

## Polymarket.com URLs

Polymarket.com URLs are in the form of

https://polymarket.com/event/presidential-election-winner-2024/will-donald-trump-win-the-2024-us-presidential-election

or

https://polymarket.com/event/presidential-election-winner-2024

or

https://polymarket.com/market/will-donald-trump-win-the-2024-us-presidential-election

Here **presidential-election-winner-2024** is the `event.slug`, while **will-donald-trump-win-the-2024-us-presidential-election** is the `market.slug`.

Events: https://docs.polymarket.com/?typescript#events

Markets: https://docs.polymarket.com/?typescript#markets


## Gamma Markets API (GraphQL)

**NOTE**: The Gamma Markets API is currently being rebuilt and has been deprecated. The new API will be available soon. In the meantime similar REST queries can be made at https://strapi-matic.poly.market.

If the user is sharing a link with only the event slug, they should be presented a list of available markets (or shown a market directly if there's only one). Example query for an event slug:

```
https://strapi-matic.poly.market/events?slug=presidential-election-winner-2024
```

returns:

```json
[
  {
    "id": 903193,
    "ticker": "presidential-election-winner-2024",
    "slug": "presidential-election-winner-2024",
    "title": "Presidential Election Winner 2024",
    "subtitle": null,
    "description": "This is a market group on who will win the 2024 US Presidential Election (POTUS)",
    "resolution_source": "",
    "start_date": "2024-01-04T22:58:15.194Z",
    "creation_date": "2024-01-04T23:04:57.844Z",
    "end_date": "2024-11-05",
    "tags": [...],
    "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Seal_of_the_President_of_the_United_States.svg/2424px-Seal_of_the_President_of_the_United_States.svg.png",
    "icon": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Seal_of_the_President_of_the_United_States.svg/2424px-Seal_of_the_President_of_the_United_States.svg.png",
    "active": true,
    "closed": false,
    "archived": false,
    "new": false,
    "featured": false,
    "restricted": true,
    "liquidity": 15829913.04,
    "volume": 22141520.71,
    "open_interest": 0,
    "sort_by": "ascending",
    "category": null,
    "subcategory": null,
    "is_template": null,
    "review_status": "deployed",
    "template_variables": null,
    "published_at": "2024-01-04T17:33:51.448Z",
    "created_at": "2024-01-04T17:33:51.470Z",
    "updated_at": "2024-01-29T12:02:00.280Z",
    "comments_enabled": false,
    "competitive": 0,
    "volume_24hr": 793257.05,
    "featured_image": "",
    "parent_event": null,
    "disqus_thread": null,
    "creator": null,
    "edited_by": null,
    "enable_order_book": true,
    "last_updated_at_cron": "2024-01-29T12:01:46.249Z",
    "volume_amm": 0,
    "volume_clob": 22141520.71,
    "liquidity_amm": 0,
    "liquidity_clob": 15829913.04,
    "volume_24hr_amm": 0,
    "volume_24hr_clob": 793257.05,
    "end_time": null,
    "end_time_zone": null,
    "neg_risk": true,
    "neg_risk_market_id": "0xe3b1bc389210504ebcb9cffe4b0ed06ccac50561e0f24abb6379984cec030f00",
    "neg_risk_fee_bips": 0,
    "comment_count": 62,
    "image_optimized": {
      "id": 397687,
      "image_url_source": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Seal_of_the_President_of_the_United_States.svg/2424px-Seal_of_the_President_of_the_United_States.svg.png",
      "image_url_optimized": "https://polymarket-upload.s3.us-east-2.amazonaws.com/presidenti_29ab78ad2c3c75fb97e1ba00cfb6a8ea_256x256_qual_100.webp",
      "image_size_kb_source": 1149.416,
      "image_size_kb_optimized": 38.236,
      "image_optimized_complete": true,
      "image_optimized_last_updated": "2024-01-06T19:59:12.154Z",
      "size_factor": null,
      "reoptimize_image": false,
      "quality_factor": "100"
    },
    "featured_image_optimized": null,
    "icon_optimized": {
      "id": 397688,
      "image_url_source": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Seal_of_the_President_of_the_United_States.svg/2424px-Seal_of_the_President_of_the_United_States.svg.png",
      "image_url_optimized": "https://polymarket-upload.s3.us-east-2.amazonaws.com/presidenti_f8c9bd0b9e6f98a95628bd3c568d8a37_40x40_qual_100.webp",
      "image_size_kb_source": 1149.416,
      "image_size_kb_optimized": 3.222,
      "image_optimized_complete": true,
      "image_optimized_last_updated": "2024-01-06T19:59:13.509Z",
      "size_factor": null,
      "reoptimize_image": false,
      "quality_factor": "100"
    },
    "series": [],
    "collections": [],
    "markets": [
      {
        "id": 253591,
        "question": "Will Donald Trump win the 2024 US Presidential Election?",
        "conditionId": "0xdd22472e552920b8438158ea7238bfadfa4f736aa4cee91a6b86c39ead110917",
        "slug": "will-donald-trump-win-the-2024-us-presidential-election",
        "twitter_card_image": null,
        "resolution_source": "",
        "end_date": "November 5, 2024",
        "category": null,
        "amm_type": null,
        "liquidity": "1051236.7655",
        "sponsor_name": null,
        "sponsor_image": null,
        "start_date": "2024-01-04T22:58:15.194Z",
        "x_axis_value": null,
        "y_axis_value": null,
        "denomination_token": null,
        "fee": "20000000000000000",
        "image": "data:image/jpeg;base64,[...]",
        "icon": "data:image/jpeg;base64,[...]",
        "lower_bound": null,
        "upper_bound": null,
        "description": "This market will resolve to “Yes” if Donald J. Trump wins the 2024 US Presidential Election. Otherwise, this market will resolve to “No.”\n\nThe resolution source for this market is the Associated Press, Fox News, and NBC. This market will resolve once all three sources call the race for the same candidate. If all three sources haven’t called the race for the same candidate by the inauguration date (January 20, 2025) this market will resolve based on who is inaugurated.",
        "tags": [],
        "outcomes": [
          "Yes",
          "No"
        ],
        "outcomePrices": [
          "0.545",
          "0.455"
        ],
        "volume": "3384587.695823",
        "active": true,
        "market_type": "normal",
        "format_type": null,
        "lower_bound_date": null,
        "upper_bound_date": null,
        "closed": false,
        "marketMakerAddress": null,
        "created_at": "2024-01-04T17:33:51.332Z",
        "updated_at": "2024-01-29T12:01:19.043Z",
        "closed_time": null,
        "wide_format": false,
        "new": false,
        "sent_discord": null,
        "mailchimp_tag": null,
        "featured": false,
        "submitted_by": "0x91430CaD2d3975766499717fA0D66A78D814E5c5",
        "subcategory": null,
        "category_mailchimp_tag": null,
        "twitter_card_location": null,
        "twitter_card_last_refreshed": null,
        "twitter_card_last_validated": null,
        "archived": false,
        "resolved_by": "0x2F5e3684cb1F318ec51b00Edba38d79Ac2c0aA9d",
        "restricted": true,
        "market_group": null,
        "group_item_title": "Donald Trump",
        "group_item_threshold": "1",
        "questionID": "0xe3b1bc389210504ebcb9cffe4b0ed06ccac50561e0f24abb6379984cec030f00",
        "uma_end_date": null,
        "uma_end_time": null,
        "enable_order_book": true,
        "order_price_min_tick_size": 0.01,
        "order_min_size": 5,
        "uma_resolution_status": null,
        "curation_order": null,
        "volume_num": 3384587.7,
        "liquidity_num": 1051236.77,
        "end_date_iso": "2024-11-05",
        "start_date_iso": "2024-01-04",
        "uma_end_date_iso": null,
        "has_reviewed_dates": true,
        "request_time": null,
        "initial_liquidity": 1,
        "initial_liquidity_odds": 0.5,
        "game_start_time": null,
        "seconds_delay": 0,
        "clob_token_ids": [
          "21742633143463906290569050155826241533067272736897614950488156847949938836455",
          "48331043336612883890938759509493159234755048973500640148014422747788308965732"
        ],
        "competitive": 0.9979790923380155,
        "ticker": null,
        "event_title": null,
        "is_template": null,
        "template_variables": null,
        "review_status": "deployed",
        "ready_for_cron": null,
        "comments_enabled": false,
        "volume_24hr": 77467.45,
        "min_incentive_size": null,
        "max_incentive_spread": null,
        "last_updated_at_cron": "2024-01-29T12:00:05.699Z",
        "short_outcomes": null,
        "disqus_thread": null,
        "sent_discord_active": false,
        "sent_discord_closed": false,
        "sent_slack_active": false,
        "sent_slack_closed": false,
        "sent_twitter_active": false,
        "sent_twitter_closed": false,
        "uma_bond": "99750.0",
        "uma_reward": "500.0",
        "fpmmLive": true,
        "outcome_team_a": null,
        "outcome_team_b": null,
        "volume_24hr_amm": 0,
        "volume_24hr_clob": 77467.45,
        "volume_amm": 0,
        "volume_clob": 3384587.7,
        "liquidity_amm": 0,
        "liquidity_clob": 1051236.77,
        "end_time": null,
        "end_time_zone": null,
        "maker_base_fee": 0,
        "taker_base_fee": 0,
        "custom_liveness": 0,
        "accepting_orders": true,
        "notifications_enabled": true,
        "neg_risk": true,
        "neg_risk_market_id": "0xe3b1bc389210504ebcb9cffe4b0ed06ccac50561e0f24abb6379984cec030f00",
        "neg_risk_request_id": "0xc2d6714f691eacd6ec494c7d6e5eaaf7dfba8907dcaf55b2dd93e7b479da1605",
        "comment_count": 22,
        "use_cases": [],
        "seo": null,
        "image_optimized": null,
        "icon_optimized": null
      }
    ],
    "categories": [
      {
        "id": 5482,
        "label": "Elections",
        "parent_category": 5481,
        "slug": "elections",
        "published_at": "2022-06-30T14:05:17.603Z",
        "created_at": "2022-06-30T14:05:16.444Z",
        "updated_at": "2023-10-18T16:34:07.905Z"
      }
    ],
    "review_comments": [],
    "sub_events": [],
    "tags_relations": [
      {
        "id": 24,
        "label": "US election",
        "force_show": true,
        "published_at": "2023-11-02T21:04:03.712Z",
        "created_at": "2023-11-02T21:04:03.723Z",
        "updated_at": "2023-11-14T16:59:10.381Z",
        "force_hide": null
      }
    ]
  }
]
```

If the shared link contains a market slug, look up directly by slug:

```
https://strapi-matic.poly.market/markets?slug=will-donald-trump-win-the-2024-us-presidential-election
```

Returns something like (most fields omitted for brevity):

```json
[
  {
    "id": "253591",
    "active": true,
    "question": "Will Donald Trump win the 2024 US Presidential Election?",
    "conditionId": "0xdd22472e552920b8438158ea7238bfadfa4f736aa4cee91a6b86c39ead110917",
    "slug": "will-donald-trump-win-the-2024-us-presidential-election",
    "clob_token_ids": [
      "21742633143463906290569050155826241533067272736897614950488156847949938836455",
      "48331043336612883890938759509493159234755048973500640148014422747788308965732"
    ]
  }
]
```

### Notes
The `conditionId` is the main identifier used for Markets. The `clob_token_ids` field contains the ERC1155 Outcome Token IDs for the market. These are used to create "yes" or "no" orders.

## Central Limit Order Book (CLOB) API

The Polymarket CLOB API plays the role of "Operator" and matches open orders. The  `@polymarkey/clob-client` library can be used to place orders, as well as query Markets and open orders.

Here's an example of how to set up the CLOB client to place orders:

```js
const host = process.env.CLOB_API_URL ?? "https://clob.polymarket.com";
const chainId = process.env.CHAIN_ID ?? 137;
const provider = new providers.Web3Provider(window.ethereum);
const signer = provider.getSigner();

// Initialize the Level 1 CLOB client
const clobClient = new ClobClient(host, chainId, signer);

// Create the required API key for the Level 2 Client (if not already created)
// This creates a wallet signing prompt
const apiKeyCreds = await clobClient.createApiKey();

// Initialize the L2 CLOB Client
const l2ClobClient = new ClobClient(clobApiUrl, chain.id, signer, apiKeyCreds);
```

### Notes   
- A "Level 1" CLOB Client is created with a wallet. It's required for making orders and creating API Keys.
- For all other CLOB API calls, a "Level 2" CLOB Client is required.
- The Level 2 CLOB Client is initialized with an API Key, which can be created by signing a message with a L1 Client.

## Open Action Modules

The first Polymarket Open Action will enable buying shares on a market directly from a Lens publication. All that's needed for initialization of the Open Action module is the Condition ID of the market being shared.

The initialization calldata ABI is:

```json
[
    {
        "type": "bytes32",
        "name": "conditionId"
    }
]
```

The contract returns the ERC1155 Binary Outcome Token IDs for the market, which are used to create orders, in addition to the initial calldata.

Here's the ABI of the initializeResultData:

```json
[
    {
        "type": "bytes32",
        "name": "conditionId"
    },
    {
        "type": "uint256[]",
        "name": "clobTokenIds"
    }
]
```

Clients can use this to determine the market to display as part of the publication. To create an order, the process calldata ABI expects an instance of an `Order`:

```json
[
    {
        "type": "tuple",
        "name": "order"
    }
]
```

Here's the full signed `Order` struct:

```solidity
struct Order {
    /// @notice Unique salt to ensure entropy
    uint256 salt;
    /// @notice Maker of the order, i.e the source of funds for the order
    address maker;
    /// @notice Signer of the order
    address signer;
    /// @notice Address of the order taker. The zero address is used to indicate a public order
    address taker;
    /// @notice Token Id of the CTF ERC1155 asset to be bought or sold
    /// If BUY, this is the tokenId of the asset to be bought, i.e the makerAssetId
    /// If SELL, this is the tokenId of the asset to be sold, i.e the takerAssetId
    uint256 tokenId;
    /// @notice Maker amount, i.e the maximum amount of tokens to be sold
    uint256 makerAmount;
    /// @notice Taker amount, i.e the minimum amount of tokens to be received
    uint256 takerAmount;
    /// @notice Timestamp after which the order is expired
    uint256 expiration;
    /// @notice Nonce used for onchain cancellations
    uint256 nonce;
    /// @notice Fee rate, in basis points, charged to the order maker, charged on proceeds
    uint256 feeRateBps;
    /// @notice The side of the order: BUY or SELL
    Side side;
    /// @notice Signature type used by the Order: EOA, POLY_PROXY or POLY_GNOSIS_SAFE
    SignatureType signatureType;
    /// @notice The order signature
    bytes signature;
}
```

## Client Implementation

The [@polymarket/clob-client](https://www.npmjs.com/package/@polymarket/clob-client) library can be used to query a Market by Condition ID and place an Order.

```ts
// A Level 2 CLOB Client (with API credentials) is required to query markets (which includes placing "market" orders)
const clobClient = new ClobClient(host, chain, signer, creds);

// Get the Market by Condition ID
const market = await clobClient.getMarket(conditionId);

// A "YES" Binary Outcome Token ID
const tokenID = market.tokens.find(token => token.outcome === "Yes").token_id;

// Create a market buy order (no price specified) for $15 worth of shares
const order = await clobClient.createMarketBuyOrder({
  tokenId,
  amount: 15, // 15 USDC (collateral)
});

// Place the order as Fill or Kill (FOK)
const resp = await clobClient.postOrder(order, OrderType.FOK);
```

Note that you can alternatively use `clobClient.createOrder()` to create a limit order (specify the amount of shares to buy at a specific price). If no market price is available (`clobClient.getPrice()` returns "0") then orders must be placed as a limit order with the "midpoint" price (`clobClient.getMidpoint()`). Otherwise, the order will fail. Eg:

```ts
const midRes = await clobClient.getMidpoint(tokenID);
const price = Number.parseFloat(midRes.mid);
const order = await clobClient.createOrder({
  tokenID,
  size: 100, // 100 shares
  price,
  side: Side.BUY,
})
```

Or you can use the API directly to query the Market:
```
GET {clob-endpoint}/markets/{condition_id}
```

And place the order:

```
POST {clob-endpoint}/order
```

Request Payload Parameters

| Name      | Required | Type   | Description                      |
|-----------|----------|--------|----------------------------------|
| order     | yes      | Order  | signed order object              |
| owner     | yes      | string | api key of oder owner            |
| orderType | yes      | string | order type ("FOK", "GTC", "GTD") |

### Proxy Wallets

Each user has their own proxy wallet (and thus proxy wallet address) but the factories are available at the following deployed addresses on the Polygon network:

| Contract Address                           | Factory          |
|--------------------------------------------|------------------|
| 0xaacfeea03eb1561c4e67d661e40682bd20e3541b | Gnosis safe      |
| 0xaB45c5A4B0c941a2F231C04C3f49182e1A254052 | Polymarket proxy |

Gnosis safes are used for all MetaMask users, while Polymarket custom proxy contracts are used for all MagicLink users.

The [@polymarket/sdk](https://www.npmjs.com/package/@polymarket/sdk) library can be used to interact with the proxy wallets. Proxy addresses are calculated using the following code:
```ts
import { getProxyWalletAddress } from "@polymarket/sdk";

const proxyAddress = getProxyWalletAddress(
    '0xaacfeea03eb1561c4e67d661e40682bd20e3541b', // proxy wallet factory contract
    '0x...', // address which owns the proxy wallet we want to calculate
);
```


### Prices and Books

#### Spot Price

You can get the best available price 

With the `@polymarket/clob-client` library:

```ts
const price = await clobClient.getPrice(tokenId, Side.Buy);
```

or from the CLOB API using:

```
https://clob.polymarket.com/price?token_id=[TOKEN_ID]&side=buy
```

Which returns

```json
{
    "price": "0.48"
}
```

Or the midpoint:

```ts
// Get the midpoint price for a market (halfway between best bid or best ask)
const midpoint = await clobClient.getMidpoint(tokenId);
```

and 

```
https://clob.polymarket.com/midpoint?token_id=[TOKEN_ID]
```

#### Order Book

You can also retrieve the current order book and prices for a specific market. 

With the `@polymarket/clob-client` library:

```ts
const book = await clobClient.getOrderBook(tokenId);
```

or the API:

```
https://clob.polymarket.com/book?token_id=[TOKEN_ID]
```

Which returns

```json
{
    "market": "0xdd22472e552920b8438158ea7238bfadfa4f736aa4cee91a6b86c39ead110917",
    "asset_id": "21742633143463906290569050155826241533067272736897614950488156847949938836455",
    "bids": [
        {
            "price": "0.03",
            "size": "300"
        },
        {
            "price": "0.12",
            "size": "5000"
        },
        {
            "price": "0.16",
            "size": "15000"
        },
        {
            "price": "0.17",
            "size": "3583"
        },
        {
            "price": "0.45",
            "size": "20522"
        },
        {
            "price": "0.46",
            "size": "256530.05"
        },
        {
            "price": "0.47",
            "size": "299948.42"
        },
        {
            "price": "0.48",
            "size": "158512.24"
        }
    ],
    "asks": [
        {
            "price": "0.99",
            "size": "55000"
        },
        {
            "price": "0.97",
            "size": "300"
        },
        {
            "price": "0.58",
            "size": "5000"
        },
        {
            "price": "0.55",
            "size": "5000"
        },
        {
            "price": "0.53",
            "size": "1000"
        },
        {
            "price": "0.52",
            "size": "2000"
        },
        {
            "price": "0.51",
            "size": "261145.35"
        },
        {
            "price": "0.5",
            "size": "289848"
        },
        {
            "price": "0.49",
            "size": "167976.65"
        }
    ],
    "hash": "a06bacc555bfa7386279e6b9373be56f77ac0c81"
}
```