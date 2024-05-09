1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   function Ownable() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 contract I2Presale is Ownable {
48     using SafeMath for uint256;
49 
50     address public beneficiary;
51     uint public fundingGoal;
52     uint public amountRaised;
53     uint public deadline;
54     uint public price;
55     uint public usd = 1000;
56     uint public bonus;
57     token public tokenReward;
58     mapping(address => uint256) public balanceOf;
59     bool fundingGoalReached = false;
60     bool crowdsaleClosed = false;
61 
62     event GoalReached(address recipient, uint totalAmountRaised);
63     event FundTransfer(address backer, uint amount, bool isContribution);
64 
65     /**
66      * Constrctor function
67      *
68      * Setup the owner
69      */
70     function I2Presale (
71         address ifSuccessfulSendTo,
72         uint fundingGoalInEthers,
73         uint durationInMinutes,
74         // how many token units a buyer gets per dollar
75         uint tokensPerDollar, // $0.1 = 10
76         // how many token units a buyer gets per wei
77         // uint etherCostOfEachToken,
78         uint bonusInPercent,
79         address addressOfTokenUsedAsReward
80     ) public {
81         beneficiary = ifSuccessfulSendTo;
82         // mean set 100-1000 ETH
83         fundingGoal = fundingGoalInEthers.mul(1 ether); 
84         deadline = now.add(durationInMinutes.mul(1 minutes));
85         price = 10**18;
86         price = price.div(tokensPerDollar).div(usd); 
87         // price = etherCostOfEachToken * 1 ether;
88         // price = etherCostOfEachToken.mul(1 ether).div(1000).mul(usd);
89         bonus = bonusInPercent;
90 
91         tokenReward = token(addressOfTokenUsedAsReward);
92     }
93 
94     /**
95     * Change Crowdsale bonus rate
96     */
97     function changeBonus (uint _bonus) public onlyOwner {
98         bonus = _bonus;
99     }
100     
101     /**
102     * Set USD/ETH rate in USD (1000)
103     */
104     function setUSDPrice (uint _usd) public onlyOwner {
105         usd = _usd;
106     }
107     
108     /**
109     * Finish Crowdsale in some reason like Goals Reached or etc
110     */
111     function finshCrowdsale () public onlyOwner {
112         deadline = now;
113         crowdsaleClosed = true;
114     }
115 
116     /**
117      * Fallback function
118      *
119      * The function without name is the default function that is called whenever anyone sends funds to a contract
120      */
121     function () public payable {
122         require(beneficiary != address(0));
123         require(!crowdsaleClosed);
124         require(msg.value != 0);
125         
126         uint amount = msg.value;
127         balanceOf[msg.sender] += amount;
128         amountRaised += amount;
129         // bonus in percent 
130         // msg.value.add(msg.value.mul(bonus).div(100));
131         uint tokensToSend = amount.div(price).mul(10**18);
132         uint tokenToSendWithBonus = tokensToSend.add(tokensToSend.mul(bonus).div(100));
133         tokenReward.transfer(msg.sender, tokenToSendWithBonus);
134         FundTransfer(msg.sender, amount, true);
135     }
136 
137     modifier afterDeadline() { if (now >= deadline) _; }
138 
139     /**
140      * Check if goal was reached
141      *
142      * Checks if the goal or time limit has been reached and ends the campaign
143      */
144     function checkGoalReached() public afterDeadline {
145         if (amountRaised >= fundingGoal){
146             fundingGoalReached = true;
147             GoalReached(beneficiary, amountRaised);
148         }
149         crowdsaleClosed = true;
150     }
151 
152 
153     /**
154      * Withdraw the funds
155      *
156      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
157      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
158      * the amount they contributed.
159      */
160     function safeWithdrawal() public afterDeadline {
161         if (!fundingGoalReached) {
162             uint amount = balanceOf[msg.sender];
163             balanceOf[msg.sender] = 0;
164             if (amount > 0) {
165                 if (msg.sender.send(amount)) {
166                     FundTransfer(msg.sender, amount, false);
167                 } else {
168                     balanceOf[msg.sender] = amount;
169                 }
170             }
171         }
172 
173         if (fundingGoalReached && beneficiary == msg.sender) {
174             if (beneficiary.send(amountRaised)) {
175                 FundTransfer(beneficiary, amountRaised, false);
176             } else {
177                 //If we fail to send the funds to beneficiary, unlock funders balance
178                 fundingGoalReached = false;
179             }
180         }
181     }
182 }
183 
184 /**
185  * @title SafeMath
186  * @dev Math operations with safety checks that throw on error
187  */
188 library SafeMath {
189 
190   /**
191   * @dev Multiplies two numbers, throws on overflow.
192   */
193   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194     if (a == 0) {
195       return 0;
196     }
197     uint256 c = a * b;
198     assert(c / a == b);
199     return c;
200   }
201 
202   /**
203   * @dev Integer division of two numbers, truncating the quotient.
204   */
205   function div(uint256 a, uint256 b) internal pure returns (uint256) {
206     // assert(b > 0); // Solidity automatically throws when dividing by 0
207     uint256 c = a / b;
208     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209     return c;
210   }
211 
212   /**
213   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
214   */
215   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
216     assert(b <= a);
217     return a - b;
218   }
219 
220   /**
221   * @dev Adds two numbers, throws on overflow.
222   */
223   function add(uint256 a, uint256 b) internal pure returns (uint256) {
224     uint256 c = a + b;
225     assert(c >= a);
226     return c;
227   }
228 }