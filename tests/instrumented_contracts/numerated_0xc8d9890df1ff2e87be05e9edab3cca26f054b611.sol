1 contract AmIOnTheFork {
2     function forked() constant returns(bool);
3 }
4 
5 contract SellETCSafely {
6     // fork oracle to use
7     AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);
8 
9     // recipient of the 1 % fee on the ETC side
10     address feeRecipient = 0x46a1e8814af10Ef6F1a8449dA0EC72a59B29EA54;
11 
12     function split(address ethDestination, address etcDestination) {
13         if (amIOnTheFork.forked()) {
14             // The following happens on the forked chain:
15             // 100 % is forwarded to the provided destination for ETH
16             ethDestination.call.value(msg.value)();
17         } else {
18             // The following happens on the classic chain:
19             // 1 % is forwarded to the fee recipient
20             // 99 % is forwarded to the provided destination for ETC
21             uint fee = msg.value / 100;
22             feeRecipient.send(fee);
23             etcDestination.call.value(msg.value - fee)();
24         }
25     }
26 
27     function () {
28         throw;  // do not accept value transfers
29     }
30 }