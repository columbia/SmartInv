1 contract Escrow {
2     address seller;
3     address buyer;
4     address arbitrator;
5     
6     function Escrow(address _seller, address _arbitrator) {
7         seller = _seller;
8         arbitrator = _arbitrator;
9         buyer = msg.sender;
10     }
11     
12     function finalize() {
13         if (msg.sender == buyer || msg.sender == arbitrator)
14             seller.send(this.balance);
15     }
16     
17     function refund() {
18         if (msg.sender == seller || msg.sender == arbitrator)
19             buyer.send(this.balance);
20     }
21 }