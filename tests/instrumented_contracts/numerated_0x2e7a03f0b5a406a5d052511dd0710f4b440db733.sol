1 pragma solidity 0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     emit Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     emit Unpause();
88   }
89 }
90 
91 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
103     if (a == 0) {
104       return 0;
105     }
106     c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     // uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return a / b;
119   }
120 
121   /**
122   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
133     c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: contracts/CoiPreSale.sol
140 
141 /**
142  * @title CoiPreSale
143  * @dev This crowdsale contract filters investments made according to
144  *         - time
145  *         - amount invested (in Wei)
146  *      and forwards them to a predefined wallet in case all the filtering conditions are met.
147  */
148 contract CoiPreSale is Pausable {
149     using SafeMath for uint256;
150 
151     // start and end timestamps where investments are allowed (both inclusive)
152     uint256 public startTime;
153     uint256 public endTime;
154 
155     // address where funds are collected
156     address public wallet;
157 
158     // track the investments made from each address
159     mapping(address => uint256) public investments;
160 
161     // total amount of funds raised (in wei)
162     uint256 public weiRaised;
163 
164     uint256 public minWeiInvestment;
165     uint256 public maxWeiInvestment;
166 
167     /**
168      * @dev Event for token purchase logging
169      * @param purchaser who paid for the tokens
170      * @param beneficiary who got the tokens
171      * @param value weis paid for purchase
172      */
173     event Investment(address indexed purchaser,
174         address indexed beneficiary,
175         uint256 value,
176         bytes payload);
177 
178     /**
179      * @dev Constructor
180      * @param _startTime the time to begin the crowdsale in seconds since the epoch
181      * @param _endTime the time to begin the crowdsale in seconds since the epoch. Must be later than _startTime.
182      * @param _minWeiInvestment the minimum amount for one single investment (in Wei)
183      * @param _maxWeiInvestment the maximum amount for one single investment (in Wei)
184      * @param _wallet the address to which funds will be directed to
185      */
186     constructor(uint256 _startTime,
187         uint256 _endTime,
188         uint256 _minWeiInvestment,
189         uint256 _maxWeiInvestment,
190         address _wallet) public {
191         require(_endTime > _startTime);
192         require(_minWeiInvestment > 0);
193         require(_maxWeiInvestment > _minWeiInvestment);
194         require(_wallet != address(0));
195 
196         startTime = _startTime;
197         endTime = _endTime;
198 
199         minWeiInvestment = _minWeiInvestment;
200         maxWeiInvestment = _maxWeiInvestment;
201 
202         wallet = _wallet;
203     }
204 
205     /**
206      * @dev External payable function to receive funds and buy tokens.
207      */
208     function () external payable {
209         buyTokens(msg.sender);
210     }
211 
212     /**
213      * @dev Adapted Crowdsale#hasEnded
214      * @return true if crowdsale event has started
215      */
216     function hasStarted() external view returns (bool) {
217         return now >= startTime;
218     }
219 
220     /**
221      * @dev Adapted Crowdsale#hasEnded
222      * @return true if crowdsale event has ended
223      */
224     function hasEnded() external view returns (bool) {
225         return now > endTime;
226     }
227 
228     /**
229      * @dev Low level token purchase function
230      * @param beneficiary the wallet to which the investment should be credited
231      */
232     function buyTokens(address beneficiary) public whenNotPaused payable {
233         require(beneficiary != address(0));
234         require(validPurchase());
235 
236         uint256 weiAmount = msg.value;
237 
238         // track how much wei is raised in total
239         weiRaised = weiRaised.add(weiAmount);
240 
241         // track how much was transfered by the specific investor
242         investments[beneficiary] = investments[beneficiary].add(weiAmount);
243 
244         emit Investment(msg.sender, beneficiary, weiAmount, msg.data);
245 
246         forwardFunds();
247     }
248 
249     // send ether (wei) to the fund collection wallet
250     // override to create custom fund forwarding mechanisms
251     function forwardFunds() internal {
252         wallet.transfer(msg.value);
253     }
254 
255     // overriding Crowdsale#validPurchase to add extra cap logic
256     // @return true if investors can buy at the moment
257     function validPurchase() internal view returns (bool) {
258         if (msg.value < minWeiInvestment || msg.value > maxWeiInvestment) {
259             return false;
260         }
261         bool withinPeriod = (now >= startTime) && (now <= endTime);  // 1128581 1129653
262         return withinPeriod;
263     }
264 }