1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Crowdsale
35  * @dev Crowdsale is a base contract for managing a token crowdsale.
36  * Crowdsales have a start and end timestamps, where investors can make
37  * token purchases and the crowdsale will assign them tokens based
38  * on a token per ETH rate. Funds collected are forwarded to a wallet
39  * as they arrive.
40  */
41 contract token { function transfer(address receiver, uint amount){  } }
42 contract WaterCrowdsale {
43   using SafeMath for uint256;
44 
45   // uint256 durationInMinutes;
46   // address where funds are collected
47   address public wallet;
48   // token address
49   address addressOfTokenUsedAsReward;
50 
51   token tokenReward;
52 
53 
54 
55   // start and end timestamps where investments are allowed (both inclusive)
56   uint256 public startTimeInMinutes;
57   uint256 public endTimeinMinutes;
58   uint public fundingGoal;
59   uint public minimumFundingGoal;
60   uint256 public price;
61   // amount of raised money in wei
62   uint256 public weiRaised;
63   uint256 public firstWeekBonusInWeek;
64   uint256 public secondWeekBonusInWeek;
65   uint256 public thirdWeekBonusInWeek;
66  
67   
68   mapping(address => uint256) public balanceOf;
69   bool fundingGoalReached = false;
70   bool crowdsaleClosed = false;
71   /**
72    * event for token purchase logging
73    * @param purchaser who paid for the tokens
74    * @param beneficiary who got the tokens
75    * @param value weis paid for purchase
76    * @param amount amount of tokens purchased
77    */
78   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
79   event FundTransfer(address backer, uint amount, bool isContribution);
80   event GoalReached(address recipient, uint totalAmountRaised);
81   
82   modifier isMinimum() {
83          if(msg.value < 500000000000000000) throw;
84         _;
85     }
86     
87   modifier afterDeadline() { 
88       if (now <= endTimeinMinutes) throw;
89       _;
90   }    
91 
92   function WaterCrowdsale(uint256 _startTimeInMinutes, 
93   uint256 _endTimeInMinutes, 
94   address _beneficiary, 
95   address _addressTokenUsedAsReward,
96   uint256 _tokenConvertioninEther,
97   uint256 _fundingGoalInEther,
98   uint256 _minimumFundingGoalInEther,
99   uint256 _firstWeekBonusInWeek,
100   uint256 _secondWeekBonusInWeek,
101   uint256 _thirdWeekBonusInWeek ) {
102     wallet = _beneficiary;
103     // durationInMinutes = _durationInMinutes;
104     addressOfTokenUsedAsReward = _addressTokenUsedAsReward;
105     price = _tokenConvertioninEther;
106     fundingGoal = _fundingGoalInEther * 1 ether;
107     minimumFundingGoal = _minimumFundingGoalInEther * 1 ether;
108     tokenReward = token(addressOfTokenUsedAsReward);
109     //startTime = now + 28250 * 1 minutes;
110     startTimeInMinutes = now + _startTimeInMinutes * 1 minutes;
111     firstWeekBonusInWeek = startTimeInMinutes + _firstWeekBonusInWeek*7*24*60* 1 minutes;
112     secondWeekBonusInWeek = startTimeInMinutes + _secondWeekBonusInWeek*7*24*60* 1 minutes;
113     thirdWeekBonusInWeek = startTimeInMinutes + _thirdWeekBonusInWeek*7*24*60* 1 minutes;
114 
115     endTimeinMinutes = startTimeInMinutes + _endTimeInMinutes * 1 minutes;
116     
117     //endTime = startTime + 64*24*60 * 1 minutes;
118   }
119 
120   // fallback function can be used to buy tokens
121   function () payable isMinimum{
122     buyTokens(msg.sender);
123   }
124 
125   // low level token purchase function
126   function buyTokens(address beneficiary) payable {
127     require(beneficiary != 0x0);
128     require(validPurchase());
129 
130     uint256 weiAmount = msg.value;
131 
132     // calculate token amount to be sent
133     uint256 tokens = (weiAmount) * price;
134     
135     if(now < firstWeekBonusInWeek){
136       tokens += (tokens * 20) / 100;
137     }else if(now < secondWeekBonusInWeek){
138       tokens += (tokens * 10) / 100;
139     }else if(now < thirdWeekBonusInWeek){
140       tokens += (tokens * 5) / 100;
141     }
142     // update state
143     balanceOf[msg.sender] += weiAmount;
144     weiRaised = weiRaised.add(weiAmount);
145     tokenReward.transfer(beneficiary, tokens);
146     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
147   }
148   
149   
150   //withdrawal or refund for investor and beneficiary
151   function safeWithdrawal() afterDeadline {
152         if (weiRaised < fundingGoal && weiRaised < minimumFundingGoal) {
153             uint amount = balanceOf[msg.sender];
154             balanceOf[msg.sender] = 0;
155             if (amount > 0) {
156                 if (msg.sender.send(amount)) {
157                     FundTransfer(msg.sender, amount, false);
158                     /*tokenReward.burnFrom(msg.sender, price * amount);*/
159                 } else {
160                     balanceOf[msg.sender] = amount;
161                 }
162             }
163         }
164 
165         if ((weiRaised >= fundingGoal || weiRaised >= minimumFundingGoal) && wallet == msg.sender) {
166             if (wallet.send(weiRaised)) {
167                 FundTransfer(wallet, weiRaised, false);
168                 GoalReached(wallet, weiRaised);
169             } else {
170                 //If we fail to send the funds to beneficiary, unlock funders balance
171                 fundingGoalReached = false;
172             }
173         }
174     }
175 
176 
177   // @return true if the transaction can buy tokens
178   function validPurchase() internal constant returns (bool) {
179     bool withinPeriod = now >= startTimeInMinutes && now <= endTimeinMinutes;
180     bool nonZeroPurchase = msg.value != 0;
181     return withinPeriod && nonZeroPurchase;
182   }
183 
184   // @return true if crowdsale event has ended
185   function hasEnded() public constant returns (bool) {
186     return now > endTimeinMinutes;
187   }
188  
189 }