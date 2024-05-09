1 pragma solidity ^0.4.11;
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
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner {
65     if (newOwner != address(0)) {
66       owner = newOwner;
67     }
68   }
69 
70 }
71 
72 
73 /**
74  * @title Contracts that should not own Contracts
75  * @author Remco Bloemen <remco@2π.com>
76  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
77  * of this contract to reclaim ownership of the contracts.
78  */
79 contract HasNoContracts is Ownable {
80 
81   /**
82    * @dev Reclaim ownership of Ownable contracts
83    * @param contractAddr The address of the Ownable to be reclaimed.
84    */
85   function reclaimContract(address contractAddr) external onlyOwner {
86     Ownable contractInst = Ownable(contractAddr);
87     contractInst.transferOwnership(owner);
88   }
89 }
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   uint256 public totalSupply;
98   function balanceOf(address who) constant returns (uint256);
99   function transfer(address to, uint256 value) returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 /**
104  * @title Contracts that should not own Tokens
105  * @author Remco Bloemen <remco@2π.com>
106  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
107  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
108  * owner to reclaim the tokens.
109  */
110 contract reclaimTokens is Ownable {
111 
112   /**
113    * @dev Reclaim all ERC20Basic compatible tokens
114    * @param tokenAddr address The address of the token contract
115    */
116   function reclaimToken(address tokenAddr) external onlyOwner {
117     ERC20Basic tokenInst = ERC20Basic(tokenAddr);
118     uint256 balance = tokenInst.balanceOf(this);
119     tokenInst.transfer(owner, balance);
120   }
121 }
122 
123 contract ExperimentalPreICO is reclaimTokens, HasNoContracts {
124   using SafeMath for uint256;
125 
126   address public beneficiary;
127   bool public fundingGoalReached = false;
128   bool public crowdsaleClosed = false;
129   ERC20Basic public rewardToken;
130   uint256 public fundingGoal;
131   uint256 public fundingCap;
132   uint256 public paymentMin;
133   uint256 public paymentMax;
134   uint256 public amountRaised;
135   uint256 public rate;
136 
137   mapping(address => uint256) public balanceOf;
138   mapping(address => bool) public whitelistedAddresses;
139   event GoalReached(address beneficiaryAddress, uint256 amount);
140   event FundTransfer(address backer, uint256 amount, bool isContribution);
141 
142   /**
143    * @dev data structure to hold information about campaign contributors
144    */
145   function ExperimentalPreICO(address _wallet,
146                               uint256 _goalInEthers,
147                               uint256 _capInEthers,
148                               uint256 _minPaymentInEthers,
149                               uint256 _maxPaymentInEthers,
150                               uint256 _rate,
151                               address _rewardToken) {
152     require(_goalInEthers > 0);
153     require(_capInEthers >= _goalInEthers);
154     require(_minPaymentInEthers > 0);
155     require(_maxPaymentInEthers > _minPaymentInEthers);
156     require(_rate > 0);
157     require(_wallet != 0x0);
158     beneficiary = _wallet;
159     fundingGoal = _goalInEthers.mul(1 ether);
160     fundingCap = _capInEthers.mul(1 ether);
161     paymentMin = _minPaymentInEthers.mul(1 ether);
162     paymentMax = _maxPaymentInEthers.mul(1 ether);
163     rate = _rate;
164     rewardToken = ERC20Basic(_rewardToken);
165   }
166 
167   /**
168    * @dev The default function that is called whenever anyone sends funds to the contract
169    */
170   function () external payable crowdsaleActive {
171     require(validPurchase());
172 
173     uint256 amount = msg.value;
174     balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
175     amountRaised = amountRaised.add(amount);
176     rewardToken.transfer(msg.sender, amount.mul(rate));
177     FundTransfer(msg.sender, amount, true);
178   }
179 
180   /**
181    * @dev Throws if called when crowdsale is still open.
182    */
183   modifier crowdsaleEnded() {
184     require(crowdsaleClosed == true);
185     _;
186   }
187 
188   /**
189    * @dev Throws if called when crowdsale has closed.
190    */
191   modifier crowdsaleActive() {
192     require(crowdsaleClosed == false);
193     _;
194   }
195 
196   /**
197    * @dev return true if the transaction can buy tokens
198    */
199   function validPurchase() internal returns (bool) {
200     bool whitelisted = whitelistedAddresses[msg.sender] == true;
201     bool validAmmount = msg.value >= paymentMin && msg.value <= paymentMax;
202     bool availableFunding = fundingCap >= amountRaised.add(msg.value);
203     return whitelisted && validAmmount && availableFunding;
204   }
205 
206   /**
207    * @dev checks if the goal has been reached
208    */
209   function checkGoal() external onlyOwner {
210     if (amountRaised >= fundingGoal){
211       fundingGoalReached = true;
212       GoalReached(beneficiary, amountRaised);
213     }
214   }
215 
216   /**
217    * @dev ends or resumes the crowdsale
218    */
219   function endCrowdsale() external onlyOwner {
220     crowdsaleClosed = true;
221   }
222 
223   /**
224    * @dev Allows backers to withdraw their funds in the crowdsale was unsuccessful,
225    * and allow the owner to send the amount raised to the beneficiary
226    */
227   function safeWithdrawal() external crowdsaleEnded {
228     if (!fundingGoalReached) {
229       uint256 amount = balanceOf[msg.sender];
230       balanceOf[msg.sender] = 0;
231       if (amount > 0) {
232         if (msg.sender.send(amount)) {
233           FundTransfer(msg.sender, amount, false);
234         } else {
235           balanceOf[msg.sender] = amount;
236         }
237       }
238     }
239 
240     if (fundingGoalReached && owner == msg.sender) {
241       if (beneficiary.send(amountRaised)) {
242         FundTransfer(beneficiary, amountRaised, false);
243       } else {
244         //If we fail to send the funds to beneficiary, unlock funders balance
245         fundingGoalReached = false;
246       }
247     }
248   }
249 
250   /**
251    * @dev Whitelists a list of addresses
252    */
253   function whitelistAddress (address[] addresses) external onlyOwner crowdsaleActive {
254     for (uint i = 0; i < addresses.length; i++) {
255       whitelistedAddresses[addresses[i]] = true;
256     }
257   }
258 
259 }