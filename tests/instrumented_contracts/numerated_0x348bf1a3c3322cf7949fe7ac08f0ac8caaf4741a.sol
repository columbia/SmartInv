1 pragma solidity ^0.4.25;
2 
3 contract Escrow {
4     uint256 public balance;
5     address public buyer;
6     address public seller;
7     address public escrow;
8     uint private start;
9     bool buyerOk;
10     bool sellerOk;
11 
12 function Escrow(address buyer_address, address seller_address) public {
13         // this is the constructor function that runs ONCE upon initialization
14         buyer = buyer_address;
15         seller = seller_address;
16         escrow = seller;
17         start = now; //now is an alias for block.timestamp, not really "now"
18     }
19     
20     function accept() public {
21         if (msg.sender == buyer){
22             buyerOk = true;
23         } else if (msg.sender == seller){
24             sellerOk = true;
25         }
26         if (buyerOk && sellerOk){
27             payBalance();
28         } else if (buyerOk && !sellerOk && now > start + 7 days) {
29             // Freeze 7 days before release to buyer. The customer has to remember to call this method after freeze period.
30             selfdestruct(buyer);
31         }
32     }
33     
34     function payBalance() private {
35         // we are sending ourselves (contract creator) a fee
36         //escrow.transfer(this.balance / 100);
37         // send seller the balance
38         if (seller.send(balance)) {
39             balance = 0;
40         } else {
41             throw;
42         }
43     }
44     
45     function deposit() public payable {
46         if (msg.sender == buyer) {
47             balance += msg.value;
48         }
49     }
50     
51     function cancel() public {
52         if (msg.sender == buyer){
53             buyerOk = false;
54         } else if (msg.sender == seller){
55             sellerOk = false;
56         }
57         // if both buyer and seller would like to cancel, money is returned to buyer 
58         if (!buyerOk && !sellerOk){
59             selfdestruct(buyer);
60         }
61     }
62     
63     function kill() public {
64         if (msg.sender == escrow) {
65             selfdestruct(buyer);
66         }
67     }
68 }