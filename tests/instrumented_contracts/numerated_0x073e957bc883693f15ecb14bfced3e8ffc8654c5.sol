1 contract Escrow {
2     address buyer;
3     address seller;
4     address arbitrator;
5 
6     function Escrow() payable {
7        seller = 0x5ed8cee6b63b1c6afce3ad7c92f4fd7e1b8fad9f;
8        buyer = msg.sender;
9        arbitrator = 0xabad6ec946eff02b22e4050b3209da87380b3cbd;
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