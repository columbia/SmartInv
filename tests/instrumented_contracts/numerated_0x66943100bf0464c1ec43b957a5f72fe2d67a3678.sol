1 contract Escrow {
2     
3     address seller;
4     address buyer;
5     address arbiter;
6     
7     function Escrow() {
8         buyer = msg.sender;
9         seller = 0x1db3439a222c519ab44bb1144fc28167b4fa6ee6;
10         arbiter = 0xd8da6bf26964af9d7eed9e03e53415d37aa96045;
11     }
12     
13     function finalize() {
14         if (msg.sender != buyer && msg.sender != arbiter) throw;
15         seller.send(this.balance);
16     }
17     
18     function refund() {
19         if (msg.sender != seller && msg.sender != arbiter) throw;
20         buyer.send(this.balance);        
21     }
22 }