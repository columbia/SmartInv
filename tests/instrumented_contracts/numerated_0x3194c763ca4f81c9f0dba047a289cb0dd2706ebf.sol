1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract IBITCrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0xeD70A28EfCc0584aDC899E8613aC69693C9d2E3E;
12 
13     uint256 public price;
14     uint256 public maxToSell;
15     uint256 public startDate;
16     uint256 public endDate;
17 
18     event FundTransfer(address backer, uint amount, bool isContribution);
19 
20     modifier isCreator() {
21         require(msg.sender == creator);
22         _;
23     }
24 
25     function IBITCrowdsale() public {
26         creator = msg.sender;
27         startDate = 1519257600;
28         endDate = 1522969200;
29         price = 4219;
30         maxToSell = 750000;
31         tokenReward = Token(0x3F9Ad22A9C2a52bda2a0811d1080Fc9cD23c6c46);
32     }
33 
34     function setOwner(address _owner) public isCreator {
35         owner = _owner;      
36     }
37 
38     function setCreator(address _creator) public isCreator {
39         creator = _creator;      
40     }
41 
42     function setStartDate(uint256 _startDate) public isCreator {
43         startDate = _startDate;      
44     }
45 
46     function setEndtDate(uint256 _endDate) public isCreator {
47         endDate = _endDate;      
48     }
49     
50     function setMaxToSell(uint256 _maxToSell) public isCreator {
51         maxToSell = _maxToSell;
52     }
53 
54     function setPrice(uint256 _price) public isCreator {
55         price = _price;
56     }
57 
58     function setToken(address _token) public isCreator {
59         tokenReward = Token(_token);      
60     }
61     
62     function kill() public isCreator {
63         selfdestruct(owner);
64     }
65 
66     function () payable public {
67         require(msg.value > 0);
68         require(now > startDate);
69         require(now < endDate);
70 	    uint amount = msg.value * price;
71         tokenReward.transferFrom(owner, msg.sender, amount);
72         FundTransfer(msg.sender, amount, true);
73         owner.transfer(msg.value);
74     }
75 }