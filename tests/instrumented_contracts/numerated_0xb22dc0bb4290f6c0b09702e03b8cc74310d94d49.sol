1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         assert(c >= a);
7         return c;
8     }
9 }
10 interface Token {
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12 }
13 
14 contract SCAMTokenICO1 {
15     
16     Token public tokenReward;
17     address public creator;
18     address public owner = 0xCe2493aA04FE2c146EEe00Fc6B39e39d9504272f;
19 
20     uint256 public price;
21     uint256 public startDate;
22     uint256 public endDate;
23 
24     event FundTransfer(address backer, uint amount, bool isContribution);
25 
26     function SCAMTokenICO1() public {
27         creator = msg.sender;
28         startDate = 1518476400; // 13/02/2018
29         endDate = 1521500400;  // 20/03/2018
30         price = 10000;
31         tokenReward = Token(0x419FAb1B55B94e96425674A700b7c44c1D240c35);
32     }
33 
34     function setOwner(address _owner) public {
35         require(msg.sender == creator);
36         owner = _owner;      
37     }
38 
39     function setCreator(address _creator) public {
40         require(msg.sender == creator);
41         creator = _creator;      
42     }
43 
44     function setStartDate(uint256 _startDate) public {
45         require(msg.sender == creator);
46         startDate = _startDate;      
47     }
48 
49     function setEndtDate(uint256 _endDate) public {
50         require(msg.sender == creator);
51         endDate = _endDate;      
52     }
53     
54     function setPrice(uint256 _price) public {
55         require(msg.sender == creator);
56         price = _price;      
57     }
58 
59     function setToken(address _token) public {
60         require(msg.sender == creator);
61         tokenReward = Token(_token);      
62     }
63     
64     function kill() public {
65         require(msg.sender == creator);
66         selfdestruct(owner);
67     }
68 
69     function () payable public {
70         require(msg.value > 0);
71         require(now > startDate);
72         require(now < endDate);
73 	    uint amount = msg.value * price;
74         tokenReward.transferFrom(owner, msg.sender, amount);
75         FundTransfer(msg.sender, amount, true);
76         owner.transfer(msg.value);
77     }
78 }