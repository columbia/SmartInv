1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       revert();
51     }
52   }
53 }
54 contract ZTRToken{
55     function transfer(address _to, uint val);
56 }
57 
58 contract ZTRTokenSale
59 {
60     using SafeMath for uint;
61     mapping (address => uint) public balanceOf;
62     mapping (address => uint) public ethBalance;
63     address public owner;
64     address ZTRTokenContract;
65     uint public fundingGoal;
66     uint public fundingMax;
67     uint public amountRaised;
68     uint public start;
69     uint public duration;
70     uint public deadline;
71     uint public unlockTime;
72     uint public ZTR_ETH_initial_price;
73     uint public ZTR_ETH_extra_price;
74     uint public remaining;
75     
76     modifier admin { if (msg.sender == owner) _; }
77     modifier afterUnlock { if(now>unlockTime) _;}
78     modifier afterDeadline { if(now>deadline) _;}
79     
80     function ZTRTokenSale()
81     {
82         owner = msg.sender;
83         ZTRTokenContract = 0x107bc486966eCdDAdb136463764a8Eb73337c4DF;
84         fundingGoal = 5000 ether;//funds will be returned if this goal is not met
85         fundingMax = 30000 ether;//The max amount that can be raised
86         start = 1517702401;//beginning of the token sale
87         duration = 3 weeks;//duration of the token sale
88         deadline = start + duration;//end of the token sale
89         unlockTime = deadline + 16 weeks;//unlock for selfdestruct
90         ZTR_ETH_initial_price = 45000;//initial ztr price
91         ZTR_ETH_extra_price = 23000;//ztr price after funding goal has been met
92         remaining = 800000000000000000000000000;//counter for remaining tokens
93     }
94     function () payable public//order processing and crediting to escrow
95     {
96         require(now>start);
97         require(now<deadline);
98         require(amountRaised + msg.value < fundingMax);//funding hard cap has not been reached
99         uint purchase = msg.value;
100         ethBalance[msg.sender] = ethBalance[msg.sender].add(purchase);//track the amount of eth contributed for refunds
101         if(amountRaised < fundingGoal)//funding goal has not been met yet
102         {
103             purchase = purchase.mul(ZTR_ETH_initial_price);
104             amountRaised = amountRaised.add(msg.value);
105             balanceOf[msg.sender] = balanceOf[msg.sender].add(purchase);
106             remaining.sub(purchase);
107         }
108         else//funding goal has been met, selling extra tokens
109         {
110             purchase = purchase.mul(ZTR_ETH_extra_price);
111             amountRaised = amountRaised.add(msg.value);
112             balanceOf[msg.sender] = balanceOf[msg.sender].add(purchase);
113             remaining.sub(purchase);
114         }
115     }
116     
117     function withdrawBeneficiary() public admin afterDeadline//withdrawl for the ZTrust Foundation
118     {
119         ZTRToken t = ZTRToken(ZTRTokenContract);
120         t.transfer(msg.sender, remaining);
121         require(amountRaised >= fundingGoal);//allow admin withdrawl if funding goal is reached and the sale is over
122         owner.transfer(amountRaised);
123     }
124     
125     function withdraw() afterDeadline//ETH/ZTR withdrawl for sale participants
126     {
127         if(amountRaised < fundingGoal)//funding goal was not met, withdraw ETH deposit
128         {
129             uint ethVal = ethBalance[msg.sender];
130             ethBalance[msg.sender] = 0;
131             msg.sender.transfer(ethVal);
132         }
133         else//funding goal was met, withdraw ZTR tokens
134         {
135             uint tokenVal = balanceOf[msg.sender];
136             balanceOf[msg.sender] = 0;
137             ZTRToken t = ZTRToken(ZTRTokenContract);
138             t.transfer(msg.sender, tokenVal);
139         }
140     }
141     
142     function setDeadline(uint ti) public admin//setter
143     {
144         deadline = ti;
145     }
146     
147     function setStart(uint ti) public admin//setter
148     {
149         start = ti;
150     }
151     
152     function suicide() public afterUnlock //contract can be destroyed 4 months after the sale ends to save state
153     {
154         selfdestruct(owner);
155     }
156 }