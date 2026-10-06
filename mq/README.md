# IBM MQ

Queue manager used in the lab: `QM_IPN_LAB`.

All queue depths should be `0` before a final demo.

`Open input count = 1` on active request/log queues is expected while ACE consumers are running.

An open handle by itself is not a failure; the important final-baseline check is `Current queue depth = 0`.

The backout test deliberately uses an invalid Bank B account and should move the failed message to `BANKB.PAYMENT.BACKOUT` after the threshold.
