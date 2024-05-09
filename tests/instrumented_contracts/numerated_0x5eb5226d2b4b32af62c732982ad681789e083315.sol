1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 library SafeBonus {
33     using SafeMath for uint256;
34 
35     function addBonus(uint256 value, uint256 percentages) internal pure returns (uint256) {
36         return value.add(value.mul(percentages).div(100));
37     }
38 }
39 
40 contract Ownable {
41     address public owner;
42 
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47     /**
48      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49      * account.
50      */
51     function Ownable() public {
52         owner = msg.sender;
53     }
54 
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64 
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function transferOwnership(address newOwner) public onlyOwner {
70         require(newOwner != address(0));
71         OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73     }
74 }
75 
76 interface token {
77     function transfer(address receiver, uint amount) public;
78 }
79 
80 contract VesaPreICO is Ownable {
81     using SafeMath for uint256;
82     using SafeBonus for uint256;
83 
84     address public beneficiary;
85     uint8 public constant durationInDays = 31;
86     uint public constant fundingGoal = 140 ether;
87     uint public constant fundingGoalHardCap = 1400 ether;
88     uint public amountRaised;
89     uint public start;
90     uint public deadline;
91     uint public constant bonusPrice = 1857142857000000;
92     uint public constant bonusPriceDeltaPerHour = 28571428570000;
93     uint public constant bonusPeriodDurationInHours = 10;
94     uint public constant price = 2142857142857140;
95     uint public constant minSum = 142857142900000000;
96     token public tokenReward;
97     mapping(address => uint256) public balanceOf;
98     bool public fundingGoalReached = false;
99     bool public crowdsaleClosed = false;
100 
101     event GoalReached(address recipient, uint totalAmountRaised);
102     event FundTransfer(address backer, uint amount, bool isContribution);
103 
104     /**
105      * Constrctor function
106      *
107      * Setup the owner
108      */
109     function VesaPreICO() public {
110         beneficiary = 0x94e1F1Fa284061184B583a61633CaC75e03cFdBC;
111         start = now;
112         deadline = start + durationInDays * 1 days;
113         tokenReward = token(0xb1c74c1D82824428e484072069041deD079eD921);
114     }
115 
116     function isAfterDeadline() internal view returns (bool) { return now >= deadline; } 
117 
118     function isSoftCapAchieved() internal view returns (bool) { return amountRaised >= fundingGoal; } 
119 
120     function isHardCapAchieved() internal view returns (bool) { return amountRaised >= fundingGoalHardCap; }
121 
122     function isCompanyCanBeFinished() internal view returns (bool) { return isAfterDeadline() || isHardCapAchieved(); }
123 
124     modifier afterDeadline() { if (isAfterDeadline()) _; }
125 
126     modifier companyCanBeFinished() { if (isCompanyCanBeFinished()) _; }
127 
128     function getPrice() public view returns (uint) {
129         require(!crowdsaleClosed);
130 
131         if ( now >= (start + bonusPeriodDurationInHours.mul(1 hours))) {
132             return price;
133         } else {
134             uint hoursLeft = now.sub(start).div(1 hours);
135             return bonusPrice.add(bonusPriceDeltaPerHour.mul(hoursLeft));
136         }
137     }
138 
139     function getBonus(uint amount) public view returns (uint) {
140         require(!crowdsaleClosed);
141 
142         if (amount < 2857142857000000000) { return 0; }                                       // < 2.857142857
143         if (amount >= 2857142857000000000 && amount < 7142857143000000000) { return 6; }      // 2.857142857-7,142857143 ETH
144         if (amount >= 7142857143000000000 && amount < 14285714290000000000) { return 8; }     // 7,142857143-14,28571429 ETH
145         if (amount >= 14285714290000000000 && amount < 25000000000000000000) { return 10; }   // 14,28571429-25 ETH
146         if (amount >= 25000000000000000000 && amount < 85000000000000000000) { return 15; }   // 25-85 ETH
147         if (amount >= 85000000000000000000 && amount < 285000000000000000000) { return 17; }  // 85-285 ETH
148         if (amount >= 285000000000000000000) { return 20; }                                   // >285 ETH
149     }
150 
151     /**
152      * Fallback function
153      *
154      * The function without name is the default function that is called whenever anyone sends funds to a contract
155      */
156     function () public payable {
157         require(!crowdsaleClosed);
158         require(msg.value > minSum);
159         uint amount = msg.value;
160         balanceOf[msg.sender].add(amount);
161         amountRaised = amountRaised.add(amount);
162 
163         uint currentPrice = getPrice();
164         uint currentBonus = getBonus(amount);
165 
166         uint tokensToTransfer = amount.mul(10 ** 18).div(currentPrice);
167         uint tokensToTransferWithBonuses = tokensToTransfer.addBonus(currentBonus);
168 
169         tokenReward.transfer(msg.sender, tokensToTransferWithBonuses);
170         FundTransfer(msg.sender, amount, true);
171     }
172 
173     /**
174      * Check if goal was reached
175      *
176      * Checks if the goal or time limit has been reached and ends the campaign
177      */
178     function checkGoalReached() public companyCanBeFinished {
179         if (amountRaised >= fundingGoal){
180             fundingGoalReached = true;
181             GoalReached(beneficiary, amountRaised);
182         }
183         crowdsaleClosed = true;
184     }
185 
186     /**
187      * Withdraw the funds
188      *
189      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
190      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
191      * the amount they contributed.
192      */
193     function safeWithdrawal() public companyCanBeFinished {
194         if (!fundingGoalReached) {
195             uint amount = balanceOf[msg.sender];
196             balanceOf[msg.sender] = 0;
197             if (amount > 0) {
198                 if (msg.sender.send(amount)) {
199                     FundTransfer(msg.sender, amount, false);
200                 } else {
201                     balanceOf[msg.sender] = amount;
202                 }
203             }
204         }
205 
206         if (fundingGoalReached && beneficiary == msg.sender) {
207             if (beneficiary.send(amountRaised)) {
208                 FundTransfer(beneficiary, amountRaised, false);
209             } else {
210                 //If we fail to send the funds to beneficiary, unlock funders balance
211                 fundingGoalReached = false;
212             }
213         }
214     }
215 
216     function tokensWithdrawal(address receiver, uint amount) public onlyOwner {
217         tokenReward.transfer(receiver, amount);
218     }
219 
220 }