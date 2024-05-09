1 pragma solidity ^0.4.21;
2 
3 contract Money {
4     
5     address public creator;
6     address public buyer;
7     
8     function Money(address _buyer) public payable {
9         creator = msg.sender;
10         buyer = _buyer;
11     }
12     
13     function ChangeBuyer(address _buyer) public {
14          require(msg.sender==creator);
15          buyer = _buyer;
16     }
17     
18     // 0x92d282c1
19     function Send() public {
20         require(msg.sender==buyer);
21         buyer.transfer(this.balance);
22     }
23     
24     function Refund() public {
25         require(msg.sender==creator);
26         creator.transfer(this.balance);
27     }
28     
29     function() payable {
30         
31     }
32     
33     function Delete() {
34         require(msg.sender==creator);
35         selfdestruct(creator);
36     }
37     
38 }