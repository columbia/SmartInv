1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         assert(c >= a);
7         return c;
8     }
9 }
10 
11 interface Token {
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13 }
14 
15 contract FutureWorksExtended {
16 
17     using SafeMath for uint256;
18 
19     mapping (address => uint256) public balanceOf;
20     
21     Token public tokenReward;
22     address public creator;
23     address public owner = 0xb1Af3544a2cb2b2B12346D2F2Ca3Cd03251d890a;
24 
25     uint256 public price;
26     uint256 public startDate;
27     uint256 public endDate;
28     uint256 public claimDate;
29 
30 
31     event FundTransfer(address backer, uint amount, bool isContribution);
32 
33     function FutureWorksExtended() public {
34         creator = msg.sender;
35         startDate = 1518390000;     // 12/02/2018
36         endDate = 1518908400;       // 18/02/2018
37         claimDate = 1522537200;     // 31/03/2018
38         price = 49554;
39         tokenReward = Token(0x5AB468e962637E4EEcd6660F61b5b4a609E66E13);
40     }
41 
42     function setOwner(address _owner) public {
43         require(msg.sender == creator);
44         owner = _owner;      
45     }
46 
47     function setCreator(address _creator) public {
48         require(msg.sender == creator);
49         creator = _creator;      
50     }
51 
52     function setStartDate(uint256 _startDate) public {
53         require(msg.sender == creator);
54         startDate = _startDate;      
55     }
56 
57     function setEndtDate(uint256 _endDate) public {
58         require(msg.sender == creator);
59         endDate = _endDate;      
60     }
61 
62     function setClaimDate(uint256 _claimDate) public {
63         require(msg.sender == creator);
64         claimDate = _claimDate;      
65     }
66     
67     function setPrice(uint256 _price) public {
68         require(msg.sender == creator);
69         price = _price;      
70     }
71 
72     function setToken(address _token) public {
73         require(msg.sender == creator);
74         tokenReward = Token(_token);      
75     }
76 
77     function claim() public {
78         require (now > claimDate);
79         require (balanceOf[msg.sender] > 0);
80         tokenReward.transferFrom(owner, msg.sender, balanceOf[msg.sender]);
81         FundTransfer(msg.sender, balanceOf[msg.sender], true);
82     }
83     
84     function kill() public {
85         require(msg.sender == creator);
86         selfdestruct(owner);
87     }
88 
89     function () payable public {
90         require(msg.value > 0);
91         require(now > startDate);
92         require(now < endDate);
93 	    uint amount = msg.value * price;
94         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
95         owner.transfer(msg.value);
96     }
97 }