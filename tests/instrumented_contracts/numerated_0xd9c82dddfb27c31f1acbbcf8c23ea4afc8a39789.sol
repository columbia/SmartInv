1 pragma solidity ^0.4.19;
2 
3 /* 
4  * IGNITE RATINGS "SOFT CAP" CROWDSALE CONTRACT. COPYRIGHT 2018 TRUSTIC HOLDING INC. Author - Damon Barnard (damon@igniteratings.com)
5  * CONTRACT INITIATES A LIMITED SUPPLY SOFT CAP PERIOD FOR THE FIRST 24 HOURS, OR UNTIL TOTAL SOFT CAP TOKEN SUPPLY IS REACHED, WHICHEVER IS SOONER.
6  */
7 
8 interface token {
9     function transfer(address receiver, uint amount) public;
10 }
11 
12 /*
13  * Contract permits Ignite to reclaim unsold IGNT to pass to the main crowdsale contract
14  */
15 contract withdrawToken {
16     function transfer(address _to, uint _value) external returns (bool success);
17     function balanceOf(address _owner) external constant returns (uint balance);
18 }
19 
20 /*
21  * SafeMath - math operations with safety checks that throw on error
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
53  * Crowdsale contract constructor
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
64     uint256 public softCap; /* NUMBER OF TOKENS AVAILABLE DURING THE SOFT CAP PERIOD */
65     uint256 public softCapLimit; /* MAXIMUM AMOUNT OF ETH TO BE RAISED DURING SOFT CAP PERIOD */
66     uint256 public discountPrice; /* SOFT CAP PERIOD TOKEN PRICE */
67     uint256 public fullPrice; /* STANDARD TOKEN PRICE */
68     uint256 public startTime; /* CROWDSALE START TIME */
69     token public tokenReward; /* IGNT */
70     mapping(address => uint256) public contributionByAddress;
71 
72     event FundTransfer(address backer, uint amount, bool isContribution);
73 
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function Crowdsale(
80         uint saleStartTime,
81         address ownerAddress,
82         address operationsAddress,
83         address indexAddress,
84         address rewardTokenAddress
85 
86     ) public {
87         startTime = saleStartTime; /* SETS START TIME */
88         owner = ownerAddress; /* SETS OWNER */
89         operations = operationsAddress; /* SETS OPERATIONS MULTISIG WALLET */
90         index = indexAddress; /* SETS IGNITE INDEX WALLET */
91         softCap = 750000000000000000000000; /* SETS NUMBER OF TOKENS AVAILABLE AT DISCOUNT PRICE DURING SOFT CAP PERIOD */
92         softCapLimit = 4500 ether; /* SETS FUNDING TARGET FOR SOFT CAP PERIOD */
93         discountPrice = 0.006 ether; /* SETS DISCOUNTED SOFT CAP TOKEN PRICE */
94         fullPrice = 0.00667 ether; /* SETS STANDARD TOKEN PRICE */
95         tokenReward = token(rewardTokenAddress); /* SETS IGNT AS CONTRACT REWARD */
96     }
97 
98     /*
99      * Fallback function for ETH contributions
100      */
101     function () public payable {
102         uint256 amount = msg.value;
103         require(now > startTime);
104 
105         if(now < startTime.add(24 hours) && amountRaised < softCapLimit) { /* CHECKS IF SOFT CAP PERIOD STILL IN EFFECT */
106             require(amount.add(contributionByAddress[msg.sender]) > 1 ether && amount.add(contributionByAddress[msg.sender]) <= 5 ether); /* SOFT CAP MINIMUM CONTRIBUTION IS 1 ETH, MAXIMUM CONTRIBUTION IS 5 ETH PER CONTRIBUTOR */
107             require(amount.mul(10**18).div(discountPrice) <= softCap.sub(tokensSold)); /* REQUIRES SUFFICIENT DISCOUNT TOKENS REMAINING TO COMPLETE PURCHASE */
108             contributionByAddress[msg.sender] = contributionByAddress[msg.sender].add(amount);
109             amountRaised = amountRaised.add(amount);
110             amountRaisedPhase = amountRaisedPhase.add(amount);
111             tokensSold = tokensSold.add(amount.mul(10**18).div(discountPrice));
112             tokenReward.transfer(msg.sender, amount.mul(10**18).div(discountPrice));
113             FundTransfer(msg.sender, amount, true);
114 
115         }
116 
117         else { /* IMPOSES DEFAULT CROWDSALE TERMS IF SOFT CAP PERIOD NO LONGER IN EFFECT */
118             require(amount <= 1000 ether);
119             contributionByAddress[msg.sender] = contributionByAddress[msg.sender].add(amount);
120             amountRaised = amountRaised.add(amount);
121             amountRaisedPhase = amountRaisedPhase.add(amount);
122             tokensSold = tokensSold.add(amount.mul(10**18).div(fullPrice));
123             tokenReward.transfer(msg.sender, amount.mul(10**18).div(fullPrice));
124             FundTransfer(msg.sender, amount, true);
125         }
126 
127     }
128 
129     /*
130      * ALLOW IGNITE TO RECLAIM UNSOLD IGNT
131      */
132     function withdrawTokens(address tokenContract) external onlyOwner {
133         withdrawToken tc = withdrawToken(tokenContract);
134 
135         tc.transfer(owner, tc.balanceOf(this));
136     }
137     
138     /*
139      * ALLOW IGNITE TO WITHDRAW CROWDSALE PROCEEDS TO OPERATIONS AND INDEX WALLETS
140      */
141     function withdrawEther() external onlyOwner {
142         uint256 total = this.balance;
143         uint256 operationsSplit = 40;
144         uint256 indexSplit = 60;
145         operations.transfer(total * operationsSplit / 100);
146         index.transfer(total * indexSplit / 100);
147     }
148 }