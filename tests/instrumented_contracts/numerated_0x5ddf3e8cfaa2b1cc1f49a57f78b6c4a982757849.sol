1 pragma solidity 0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
23   */
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   /**
30   * @dev Adds two numbers, throws on overflow.
31   */
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract Moneda {
40   event Transfer(address indexed from, address indexed to, uint256 value);
41   function transferFrom(address from, address to, uint256 value) public returns (bool);
42   function burn() public;
43 }
44 
45 contract MonedaICO {
46     using SafeMath for uint256;
47     
48     struct DateRate {
49         uint256 date;
50         uint256 rate;
51     }
52 
53     // PreICO
54     uint256 constant public preICOLimit = 20000000e18; // Pre-ICO limit 5%, 20mil
55     DateRate public preICO = DateRate(1525132799, 6750); // Monday, April 30, 2018 11:59:59 PM --- 35% Bonus
56     uint256 public pre_tokensSold = 0;
57     
58     // ICO
59     DateRate public icoStarts = DateRate(1526342400, 5750); // Tuesday, May 15, 2018 12:00:00 AM --- 15% Bonus
60     DateRate public icoEndOfStageA = DateRate(1529020800, 5500); // Friday, June 15, 2018 12:00:00 AM --- 10% Bonus
61     DateRate public icoEndOfStageB = DateRate(1530316800, 5250); // Saturday, June 30, 2018 12:00:00 AM --- 5% Bonus
62     DateRate public icoEnds = DateRate(1531699199, 5000); // Sunday, July 15, 2018 11:59:59 PM --- 0% Bonus
63     uint256 constant public icoLimit = 250000000e18; // ICO limit 62.5%, 250mil
64     uint256 public tokensSold = 0;
65 
66     // If the funding goal is not reached, token holders may withdraw their funds
67     uint constant public fundingGoal = 10000000e18; // 10mil
68     // How much has been raised by crowdale (in ETH)
69     uint public amountRaised;
70     // The balances (in ETH) of all token holders
71     mapping(address => uint) public balances;
72     // Indicates if the crowdsale has been ended already
73     bool public crowdsaleEnded = false;
74     // Tokens will be transfered from this address
75     address public tokenOwner;
76     // The address of the token contract
77     Moneda public tokenReward;
78     // The wallet on which the funds will be stored
79     address public wallet;
80     // Notifying transfers and the success of the crowdsale
81     event GoalReached(address tokenOwner, uint amountRaised);
82     event FundTransfer(address backer, uint amount, bool isContribution, uint amountRaised);
83     
84     function MonedaICO(Moneda token, address walletAddr, address tokenOwnerAddr) public {
85         tokenReward = token;
86         wallet = walletAddr;
87         tokenOwner = tokenOwnerAddr;
88     }
89 
90     function () external payable {
91         require(msg.sender != wallet);
92         exchange(msg.sender);
93     }
94 
95     function exchange(address receiver) public payable {
96         uint256 amount = msg.value;
97         uint256 price = getRate();
98         uint256 numTokens = amount.mul(price);
99         
100         bool isPreICO = (now <= preICO.date);
101         bool isICO = (now >= icoStarts.date && now <= icoEnds.date);
102         
103         require(isPreICO || isICO);
104         require(numTokens > 500);
105         
106         if (isPreICO) {
107             require(!crowdsaleEnded && pre_tokensSold.add(numTokens) <= preICOLimit);
108             require(numTokens <= 5000000e18);
109         }
110         
111         if (isICO) {
112             require(!crowdsaleEnded && tokensSold.add(numTokens) <= icoLimit);
113         }
114 
115         wallet.transfer(amount);
116         balances[receiver] = balances[receiver].add(amount);
117         amountRaised = amountRaised.add(amount);
118 
119         if (isPreICO)
120             pre_tokensSold = pre_tokensSold.add(numTokens);
121         if (isICO)
122             tokensSold = tokensSold.add(numTokens);
123         
124         assert(tokenReward.transferFrom(tokenOwner, receiver, numTokens));
125         emit FundTransfer(receiver, amount, true, amountRaised);
126     }
127 
128     function getRate() public view returns (uint256) {
129         if (now <= preICO.date)
130             return preICO.rate;
131             
132         if (now < icoEndOfStageA.date)
133             return icoStarts.rate;
134             
135         if (now < icoEndOfStageB.date)
136             return icoEndOfStageA.rate;
137             
138         if (now < icoEnds.date)
139             return icoEndOfStageB.rate;
140         
141         return icoEnds.rate;
142     }
143     
144     // Checks if the goal or time limit has been reached and ends the campaign
145     function checkGoalReached() public {
146         require(now >= icoEnds.date);
147         if (pre_tokensSold.add(tokensSold) >= fundingGoal){
148             tokenReward.burn(); // Burn remaining tokens but the reserved ones
149             emit GoalReached(tokenOwner, amountRaised);
150         }
151         crowdsaleEnded = true;
152     }
153     
154     // Allows the funders to withdraw their funds if the goal has not been reached.
155     // Only works after funds have been returned from the wallet.
156     function safeWithdrawal() public {
157         require(now >= icoEnds.date);
158         uint amount = balances[msg.sender];
159         if (address(this).balance >= amount) {
160             balances[msg.sender] = 0;
161             if (amount > 0) {
162                 msg.sender.transfer(amount);
163                 emit FundTransfer(msg.sender, amount, false, amountRaised);
164             }
165         }
166     }
167 }