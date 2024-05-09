1 contract Whitelist {
2     address public owner;
3     address public sale;
4 
5     mapping (address => uint) public accepted;
6 
7     function Whitelist() {
8         owner = msg.sender;
9     }
10 
11     // Amount in WEI i.e. amount = 1 means 1 WEI
12     function accept(address a, uint amount) {
13         assert (msg.sender == owner || msg.sender == sale);
14 
15         accepted[a] = amount;
16     }
17 
18     function setSale(address sale_) {
19         assert (msg.sender == owner);
20 
21         sale = sale_;
22     } 
23 }