1 pragma solidity ^0.4.16;
2 
3 //SafeMath - Math operations with safety checks that throw on error
4     
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 interface token { 
32     function transfer(address receiver, uint amount); 
33 }
34 
35 contract ECT2Crowdsale2 {
36   
37   using SafeMath for uint256;
38 
39   address public wallet;
40   address addressOfTokenUsedAsReward;
41   token tokenReward;
42   uint256 public startTime;
43   uint256 public endTime;
44   uint public fundingGoal;
45   uint public minimumFundingGoal;
46   uint256 public price;
47   uint256 public weiRaised;
48   uint256 public stage1Bounty;
49   uint256 public stage2Bounty;
50   uint256 public stage3Bounty;
51   uint256 public stage4Bounty;
52  
53   mapping(address => uint256) public balanceOf;
54   bool fundingGoalReached = false;
55   bool crowdsaleClosed = false;
56  
57   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
58   event FundTransfer(address backer, uint amount, bool isContribution);
59   event GoalReached(address recipient, uint totalAmountRaised);
60   
61   modifier isMinimum() {
62          if(msg.value < 1000000000000000) return;
63         _;
64     }
65     
66   modifier afterDeadline() { 
67       if (now <= endTime) return;
68       _;
69   }    
70 
71   function ECT2Crowdsale2(
72   ) {
73     wallet = 0x55BeA1A0335A8Ea56572b8E66f17196290Ca6467;
74     addressOfTokenUsedAsReward = 0x3a799eD72BceF6fc98AeE750C5ACC352CDBA5f6c;
75     price = 100 * 1 finney;
76     fundingGoal = 50 * 1 finney;
77     minimumFundingGoal = 10 * 1 finney;
78     tokenReward = token(addressOfTokenUsedAsReward);
79     startTime = 1511355600; //13:00 UTC
80     stage1Bounty = 1511356800; //13:20 UTC 50%
81     stage2Bounty = 1511358000; //13:40 UTC 40%
82     stage3Bounty = 1511359200; //14:00 UTC 25%
83     stage4Bounty = 1511360100; //14:15UTC 10%
84     endTime = 1511361000; //14:30 UTC 0%
85   }
86 
87   // fallback function can be used to buy tokens
88   function () payable isMinimum{
89     buyTokens(msg.sender);
90   }
91 
92   // low level token purchase function
93   function buyTokens(address beneficiary) payable {
94     require(beneficiary != 0x0);
95     require(validPurchase());
96 
97     uint256 weiAmount = msg.value;
98 
99     // calculate token amount to be sent
100     uint256 tokens = (weiAmount) * price;
101     
102     if(now < stage1Bounty){
103       tokens += (tokens * 50) / 100;
104     }else if(now < stage2Bounty){
105       tokens += (tokens * 40) / 100;
106     }else if(now < stage3Bounty){
107       tokens += (tokens * 25) / 100;
108     }else if(now < stage4Bounty){
109       tokens += (tokens * 10) / 100;  
110     }
111     // update state
112     balanceOf[msg.sender] += weiAmount;
113     weiRaised = weiRaised.add(weiAmount);
114     tokenReward.transfer(beneficiary, tokens);
115     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
116   }
117   
118   
119   //withdrawal or refund for investor and beneficiary
120   function safeWithdrawal() afterDeadline {
121         if (weiRaised < fundingGoal && weiRaised < minimumFundingGoal) {
122             uint amount = balanceOf[msg.sender];
123             balanceOf[msg.sender] = 0;
124             if (amount > 0) {
125                 if (msg.sender.send(amount)) {
126                     FundTransfer(msg.sender, amount, false);
127                     /*tokenReward.burnFrom(msg.sender, price * amount);*/
128                 } else {
129                     balanceOf[msg.sender] = amount;
130                 }
131             }
132         }
133 
134         if ((weiRaised >= fundingGoal || weiRaised >= minimumFundingGoal) && wallet == msg.sender) {
135             if (wallet.send(weiRaised)) {
136                 FundTransfer(wallet, weiRaised, false);
137                 GoalReached(wallet, weiRaised);
138             } else {
139                 //If we fail to send the funds to beneficiary, unlock funders balance
140                 fundingGoalReached = false;
141             }
142         }
143     }
144     
145     // withdrawEth when minimum cap is reached
146   function withdrawEth() private{
147         require(this.balance != 0);
148         require(weiRaised >= minimumFundingGoal);
149 
150         pendingEthWithdrawal = this.balance;
151   }
152     uint pendingEthWithdrawal;
153 
154   // @return true if the transaction can buy tokens
155   function validPurchase() internal constant returns (bool) {
156     bool withinPeriod = now >= startTime && now <= endTime;
157     bool nonZeroPurchase = msg.value != 0;
158     return withinPeriod && nonZeroPurchase;
159   }
160 
161   // @return true if crowdsale event has ended
162   function hasEnded() public constant returns (bool) {
163     return now > endTime;
164   }
165  
166 }