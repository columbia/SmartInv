1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract SCAMTokenICO {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0xCe2493aA04FE2c146EEe00Fc6B39e39d9504272f;
12 
13     uint256 public price;
14     uint256 public startDate;
15     uint256 public endDate;
16 
17     event FundTransfer(address backer, uint amount, bool isContribution);
18 
19     function SCAMTokenICO() public {
20         creator = msg.sender;
21         startDate = 1517184000;     // 29/01/2018
22         endDate = 57522;       // 20/03/2018
23         price = 10000;
24         tokenReward = Token(0x419fab1b55b94e96425674a700b7c44c1d240c35);
25     }
26 
27     function setOwner(address _owner) public {
28         require(msg.sender == creator);
29         owner = _owner;      
30     }
31 
32     function setCreator(address _creator) public {
33         require(msg.sender == creator);
34         creator = _creator;      
35     }
36 
37     function setStartDate(uint256 _startDate) public {
38         require(msg.sender == creator);
39         startDate = _startDate;      
40     }
41 
42     function setEndtDate(uint256 _endDate) public {
43         require(msg.sender == creator);
44         endDate = _endDate;      
45     }
46     
47     function setPrice(uint256 _price) public {
48         require(msg.sender == creator);
49         price = _price;      
50     }
51 
52     function setToken(address _token) public {
53         require(msg.sender == creator);
54         tokenReward = Token(_token);      
55     }
56     
57     function kill() public {
58         require(msg.sender == creator);
59         selfdestruct(owner);
60     }
61 
62     function () payable public {
63         require(msg.value > 0);
64         require(now > startDate);
65         require(now < endDate);
66 	    uint amount = msg.value * price;
67         tokenReward.transferFrom(owner, msg.sender, amount);
68         FundTransfer(msg.sender, amount, true);
69         owner.transfer(msg.value);
70     }
71 }