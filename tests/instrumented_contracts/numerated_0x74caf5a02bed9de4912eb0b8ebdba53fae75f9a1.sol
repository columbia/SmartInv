1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract ROIcrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0xc0c026e307B1B74f8d307181Db00CBe2A1B412e0;
12 
13     uint256 public price;
14     uint256 public tokenSold;
15 
16     event FundTransfer(address backer, uint amount, bool isContribution);
17 
18     function ROIcrowdsale() public {
19         creator = msg.sender;
20         price = 26000;
21         tokenReward = Token(0x15DE05E084E4C0805d907fcC2Dc5651023c57A48);
22     }
23 
24     function setOwner(address _owner) public {
25         require(msg.sender == creator);
26         owner = _owner;      
27     }
28 
29     function setCreator(address _creator) public {
30         require(msg.sender == creator);
31         creator = _creator;      
32     }
33 
34     function setPrice(uint256 _price) public {
35         require(msg.sender == creator);
36         price = _price;      
37     }
38     
39     function kill() public {
40         require(msg.sender == creator);
41         selfdestruct(owner);
42     }
43     
44     function () payable public {
45         require(msg.value > 0);
46         require(tokenSold < 138216001);
47         uint256 _price = price / 10;
48         if(tokenSold < 45136000) {
49             _price *= 4;
50             _price += price; 
51         }
52         if(tokenSold > 45135999 && tokenSold < 92456000) {
53             _price *= 3;
54             _price += price;
55         }
56         if(tokenSold > 92455999 && tokenSold < 138216000) {
57             _price += price; 
58         }
59         uint amount = msg.value * _price;
60         tokenSold += amount / 1 ether;
61         tokenReward.transferFrom(owner, msg.sender, amount);
62         FundTransfer(msg.sender, amount, true);
63         owner.transfer(msg.value);
64     }
65 }