1 pragma solidity ^0.4.18;
2 
3 /* 
4  * IGNITE RATINGS "PHASED DISCOUNT" CROWDSALE CONTRACT. COPYRIGHT 2018 TRUSTIC HOLDING INC. Author - Damon Barnard (damon@igniteratings.com)
5  * CONTRACT DEPLOYS A CROWDSALE WITH TIME-BASED REDUCING DISCOUNTS.
6  */
7 
8 interface token {
9     function transfer(address receiver, uint amount) public;
10 }
11 
12 /*
13  * CONTRACT PERMITS IGNITE TO RECLAIM UNSOLD IGNT
14  */
15 contract withdrawToken {
16     function transfer(address _to, uint _value) external returns (bool success);
17     function balanceOf(address _owner) external constant returns (uint balance);
18 }
19 
20 /*
21  * SAFEMATH - MATH OPERATIONS WITH SAFETY CHECKS THAT THROW ON ERROR
22  */
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 /*
53  * CROWDSALE CONTRACT CONSTRUCTOR
54  */
55 contract Crowdsale {
56     using SafeMath for uint256;
57 
58     address public owner; /* CONTRACT OWNER */
59     address public operations; /* OPERATIONS MULTISIG WALLET */
60     address public index; /* IGNITE INDEX WALLET */
61     uint256 public amountRaised; /* TOTAL ETH CONTRIBUTIONS*/
62     uint256 public amountRaisedPhase; /* ETH CONTRIBUTIONS SINCE LAST WITHDRAWAL EVENT */
63     uint256 public tokensSold; /* TOTAL TOKENS SOLD */
64     uint256 public phase1Price; /* PHASE 1 TOKEN PRICE */
65     uint256 public phase2Price; /* PHASE 2 TOKEN PRICE */
66     uint256 public phase3Price; /* PHASE 3 TOKEN PRICE */
67     uint256 public phase4Price; /* PHASE 4 TOKEN PRICE */
68     uint256 public phase5Price; /* PHASE 5 TOKEN PRICE */
69     uint256 public phase6Price; /* PHASE 6 TOKEN PRICE */
70     uint256 public startTime; /* CROWDSALE START TIME */
71     token public tokenReward; /* IGNT */
72     mapping(address => uint256) public contributionByAddress;
73 
74     event FundTransfer(address backer, uint amount, bool isContribution);
75 
76     modifier onlyOwner() {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     function Crowdsale(
82         uint saleStartTime,
83         address ownerAddress,
84         address operationsAddress,
85         address indexAddress,
86         address rewardTokenAddress
87 
88     ) public {
89         startTime = saleStartTime; /* SETS START TIME */
90         owner = ownerAddress; /* SETS OWNER */
91         operations = operationsAddress; /* SETS OPERATIONS MULTISIG WALLET */
92         index = indexAddress; /* SETS IGNITE INDEX WALLET */
93         phase1Price = 0.00600 ether; /* SETS PHASE 1 TOKEN PRICE */
94         phase2Price = 0.00613 ether; /* SETS PHASE 2 TOKEN PRICE */
95         phase3Price = 0.00627 ether; /* SETS PHASE 3 TOKEN PRICE */
96         phase4Price = 0.00640 ether; /* SETS PHASE 4 TOKEN PRICE */
97         phase5Price = 0.00653 ether; /* SETS PHASE 5 TOKEN PRICE */
98         phase6Price = 0.00667 ether; /* SETS PHASE 6 TOKEN PRICE */
99         tokenReward = token(rewardTokenAddress); /* SETS IGNT AS CONTRACT REWARD */
100     }
101 
102     /*
103      * FALLBACK FUNCTION FOR ETH CONTRIBUTIONS - SET OUT PER DISCOUNT PHASE FOR EASE OF UNDERSTANDING/TRANSPARENCY
104      */
105     function () public payable {
106         uint256 amount = msg.value;
107         require(now > startTime);
108         require(amount <= 1000 ether);
109 
110         if(now < startTime.add(7 days)) { /* SETS PAYMENT RULES FOR CROWDSALE PHASE 1 */
111             contributionByAddress[msg.sender] = contributionByAddress[msg.sender].add(amount);
112             amountRaised = amountRaised.add(amount);
113             amountRaisedPhase = amountRaisedPhase.add(amount);
114             tokensSold = tokensSold.add(amount.mul(10**18).div(phase1Price));
115             tokenReward.transfer(msg.sender, amount.mul(10**18).div(phase1Price));
116             FundTransfer(msg.sender, amount, true);
117         }
118 
119         else if(now > startTime.add(7 days) && now < startTime.add(14 days)) { /* SETS PAYMENT RULES FOR CROWDSALE PHASE 2 */
120             contributionByAddress[msg.sender] = contributionByAddress[msg.sender].add(amount);
121             amountRaised = amountRaised.add(amount);
122             amountRaisedPhase = amountRaisedPhase.add(amount);
123             tokensSold = tokensSold.add(amount.mul(10**18).div(phase2Price));
124             tokenReward.transfer(msg.sender, amount.mul(10**18).div(phase2Price));
125             FundTransfer(msg.sender, amount, true);
126         }
127 
128         else if(now > startTime.add(14 days) && now < startTime.add(21 days)) { /* SETS PAYMENT RULES FOR CROWDSALE PHASE 3 */
129             contributionByAddress[msg.sender] = contributionByAddress[msg.sender].add(amount);
130             amountRaised = amountRaised.add(amount);
131             amountRaisedPhase = amountRaisedPhase.add(amount);
132             tokensSold = tokensSold.add(amount.mul(10**18).div(phase3Price));
133             tokenReward.transfer(msg.sender, amount.mul(10**18).div(phase3Price));
134             FundTransfer(msg.sender, amount, true);
135         }
136 
137         else if(now > startTime.add(21 days) && now < startTime.add(28 days)) { /* SETS PAYMENT RULES FOR CROWDSALE PHASE 4 */
138             contributionByAddress[msg.sender] = contributionByAddress[msg.sender].add(amount);
139             amountRaised = amountRaised.add(amount);
140             amountRaisedPhase = amountRaisedPhase.add(amount);
141             tokensSold = tokensSold.add(amount.mul(10**18).div(phase4Price));
142             tokenReward.transfer(msg.sender, amount.mul(10**18).div(phase4Price));
143             FundTransfer(msg.sender, amount, true);
144         }
145 
146         else if(now > startTime.add(28 days) && now < startTime.add(35 days)) { /* SETS PAYMENT RULES FOR CROWDSALE PHASE 5 */
147             contributionByAddress[msg.sender] = contributionByAddress[msg.sender].add(amount);
148             amountRaised = amountRaised.add(amount);
149             amountRaisedPhase = amountRaisedPhase.add(amount);
150             tokensSold = tokensSold.add(amount.mul(10**18).div(phase5Price));
151             tokenReward.transfer(msg.sender, amount.mul(10**18).div(phase5Price));
152             FundTransfer(msg.sender, amount, true);
153         }
154 
155         else if(now > startTime.add(35 days)) { /* SETS PAYMENT RULES FOR CROWDSALE PHASE 6 */
156             contributionByAddress[msg.sender] = contributionByAddress[msg.sender].add(amount);
157             amountRaised = amountRaised.add(amount);
158             amountRaisedPhase = amountRaisedPhase.add(amount);
159             tokensSold = tokensSold.add(amount.mul(10**18).div(phase6Price));
160             tokenReward.transfer(msg.sender, amount.mul(10**18).div(phase6Price));
161             FundTransfer(msg.sender, amount, true);
162         }
163     }
164 
165     /*
166      * ALLOW IGNITE TO RECLAIM UNSOLD IGNT
167      */
168     function withdrawTokens(address tokenContract) external onlyOwner {
169         withdrawToken tc = withdrawToken(tokenContract);
170 
171         tc.transfer(owner, tc.balanceOf(this));
172     }
173     
174     /*
175      * ALLOW IGNITE TO WITHDRAW CROWDSALE PROCEEDS TO OPERATIONS AND INDEX WALLETS
176      */
177     function withdrawEther() external onlyOwner {
178         uint256 total = this.balance;
179         uint256 operationsSplit = 40;
180         uint256 indexSplit = 60;
181         operations.transfer(total * operationsSplit / 100);
182         index.transfer(total * indexSplit / 100);
183     }
184 }