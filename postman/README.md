# Postman

A starter collection is included.

For a repository that exactly matches the local Postman workspace, export `IPN_MOCK_PROJECT` as Collection v2.1 and save it as:

```text
postman/IPN_MOCK_PROJECT.postman_collection.json
```

Final demo sequence:
1. New payment with a new idempotency key.
2. Replay the same request and verify `duplicate: true`.
3. Reuse the key with a different amount and verify `IDEMPOTENCY_CONFLICT`.
