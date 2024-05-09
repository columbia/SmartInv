1 pragma solidity ^0.4.0;
2 contract Escrow {
3     address buyer;
4     address seller;
5     address arbiter;
6     
7     function Escrow() payable {
8         seller = 0x1db3439a222c519ab44bb1144fc28167b4fa6ee6;
9         arbiter = 0xd8da6bf26964af9d7eed9e03e53415d37aa96045;
10         buyer = msg.sender;
11     }
12     
13     function finalize() {
14         if (msg.sender == buyer || msg.sender == arbiter)
15             seller.send(msg.value);
16     }
17     
18     function refund() {
19         if (msg.sender == seller || msg.sender == arbiter)
20             buyer.send(msg.value);
21     }
22 }