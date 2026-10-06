# Mock IPN Server Setup

The IPN Gateway calls an HTTP mock endpoint to simulate the external payment network.

## Expected success response

```json
{
  "success": true,
  "networkStatus": "ACCEPTED",
  "message": "Payment accepted by Mock IPN"
}
```

A copy is available at:

```text
postman/mock-ipn-success-response.json
```

## Postman Mock Server

1. Import `postman/IPN_MOCK_PROJECT.postman_collection.json`.
2. Create a Postman Mock Server for the mock-IPN request/response.
3. Confirm the mock returns HTTP `200` with the success JSON above.
4. In ACE Toolkit, open:

```text
IPN_GATEWAY_APP → IPNGateway_Flow → CallMockIPN
```

5. Set the request URL to your mock-server endpoint.
6. Save and redeploy `IPN_GATEWAY_APP`.

The URL stored in the exported ACE source is the endpoint used during the original verified run and should be treated as an environment-specific value.
