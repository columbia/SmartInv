1 pragma solidity ^0.4.24;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) external;
5 }
6 
7 contract TBECrowdsale {
8     
9     Token public tokenReward;
10     uint256 public price;
11     address public creator;
12     address public owner = 0x700635ad386228dEBCfBb5705d2207F529af8323;
13     uint256 public startDate;
14     uint256 public endDate;
15     
16 
17     mapping (address => bool) public tokenAddress;
18     mapping (address => uint256) public balanceOfEther;
19     mapping (address => uint256) public balanceOf;
20 
21     modifier isCreator() {
22         require(msg.sender == creator);
23         _;
24     }
25 
26     event FundTransfer(address backer, uint amount, bool isContribution);
27 
28     function TBECrowdsale() public {
29         creator = msg.sender;
30         price = 100;
31         startDate = now;
32         endDate = startDate + 3 days;
33         tokenReward = Token(0xf18b97b312EF48C5d2b5C21c739d499B7c65Cf96);
34     }
35 
36 
37 
38     function setOwner(address _owner) isCreator public {
39         owner = _owner;      
40     }
41 
42     function setStartDate(uint256 _startDate) isCreator public {
43         startDate = _startDate;      
44     }
45 
46     function setEndtDate(uint256 _endDate) isCreator public {
47         endDate = _endDate;      
48     }
49     
50    function setPrice(uint256 _price) isCreator public {
51         price = _price;      
52     }
53     
54     function setToken(address _token) isCreator public {
55         tokenReward = Token(_token);      
56     }
57 
58     function sendToken(address _to, uint256 _value) isCreator public {
59         tokenReward.transfer(_to, _value);      
60     }
61 
62     
63     function () payable public {
64         require(now > startDate);
65         require(now < endDate);
66         
67         
68         uint256 amount = price;
69 
70        
71         balanceOfEther[msg.sender] += msg.value / 1 ether;
72         tokenReward.transfer(msg.sender, amount);
73         FundTransfer(msg.sender, amount, true);
74         owner.transfer(msg.value);
75     }
76 }