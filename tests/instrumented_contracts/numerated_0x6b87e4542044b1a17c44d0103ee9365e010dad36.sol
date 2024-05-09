1 pragma solidity 0.4.18;
2 
3 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
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
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
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
47 // File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
48 
49 /**
50  * @title Pausable
51  * @dev Base contract which allows children to implement an emergency stop mechanism.
52  */
53 contract Pausable is Ownable {
54   event Pause();
55   event Unpause();
56 
57   bool public paused = false;
58 
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is not paused.
62    */
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is paused.
70    */
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     Unpause();
90   }
91 }
92 
93 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101     if (a == 0) {
102       return 0;
103     }
104     uint256 c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   function add(uint256 a, uint256 b) internal pure returns (uint256) {
122     uint256 c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 // File: contracts/SvdPreSale.sol
129 
130 /**
131  * @title SvdPreSale
132  * @dev This crowdsale contract filters investments made according to
133  *         - time
134  *         - amount invested (in Wei)
135  *         - whitelist of addresses
136  *      and forwards them to a predefined wallet in case all the pre conditions are met.
137  */
138 contract SvdPreSale is Pausable {
139     using SafeMath for uint256;
140 
141     // start and end timestamps where investments are allowed (both inclusive)
142     uint256 public startTime;
143     uint256 public endTime;
144 
145     // address where funds are collected
146     address public wallet;
147 
148     // address allowed to add and remove addresses from whitelisting
149     address public whitelister;
150 
151     // track the investments made from each address
152     mapping(address => uint256) public investments;
153 
154     // total amount of funds raised (in wei)
155     uint256 public weiRaised;
156 
157     uint256 public minWeiWhitelistInvestment;
158 
159     uint256 public minWeiInvestment;
160     uint256 public maxWeiInvestment;
161 
162     mapping (address => bool) public investorWhitelist;
163 
164     /**
165      * @dev Event for token purchase logging
166      * @param purchaser who paid for the tokens
167      * @param beneficiary who got the tokens
168      * @param value weis paid for purchase
169      */
170     event Investment(address indexed purchaser,
171         address indexed beneficiary,
172         uint256 value);
173 
174     /**
175      * @dev Event for whitelisting / de-whitelisting an address
176      * @param investor the address that was whitelisted
177      * @param status the status value, true if it is whitelisted, false otherwise
178      */
179     event Whitelisted(address investor, bool status);
180 
181     /**
182      * @dev Constructor
183      * @param _startTime the time to begin the crowdsale in seconds since the epoch
184      * @param _endTime the time to begin the crowdsale in seconds since the epoch. Must be later than _startTime.
185      * @param _minWeiInvestment the minimum amount for one single investment (in Wei)
186      * @param _maxWeiInvestment the maximum amount for one single investment (in Wei)
187      * @param _minWeiWhitelistInvestment investments equal/greater than this must have the benificiary whitelisted
188      * @param _whitelister the address of the account allowed to add and remove from whitelist
189      * @param _wallet the address to which funds will be directed to
190      */
191     function SvdPreSale(uint256 _startTime,
192         uint256 _endTime,
193         uint256 _minWeiInvestment,
194         uint256 _maxWeiInvestment,
195         uint256 _minWeiWhitelistInvestment,
196         address _whitelister,
197         address _wallet) public {
198         /* require(_startTime >= now); */
199         require(_endTime > _startTime);
200         require(_minWeiInvestment > 0);
201         require(_maxWeiInvestment > _minWeiInvestment);
202         require(_wallet != address(0));
203 
204         startTime = _startTime;
205         endTime = _endTime;
206 
207         whitelister = _whitelister;
208 
209         minWeiInvestment = _minWeiInvestment;
210         maxWeiInvestment = _maxWeiInvestment;
211         minWeiWhitelistInvestment = _minWeiWhitelistInvestment;
212 
213         wallet = _wallet;
214     }
215 
216     /**
217      * @dev External payable function to receive funds and buy tokens.
218      */
219     function () external payable {
220         buyTokens(msg.sender);
221     }
222 
223     /**
224      * @dev Low level token purchase function
225      */
226     function buyTokens(address beneficiary) public whenNotPaused payable {
227         require(beneficiary != address(0));
228         require(validPurchase());
229 
230         uint256 weiAmount = msg.value;
231 
232         if (weiAmount >= minWeiWhitelistInvestment) {
233             require(investorWhitelist[beneficiary]);
234         }
235 
236         // track how much wei is raised in total
237         weiRaised = weiRaised.add(weiAmount);
238 
239         // track how much was transfered by the specific investor
240         investments[beneficiary] = investments[beneficiary].add(weiAmount);
241 
242         Investment(msg.sender, beneficiary, weiAmount);
243 
244         forwardFunds();
245     }
246 
247     /**
248      * @dev Adapted Crowdsale#hasEnded
249      * @return true if crowdsale event has started
250      */
251     function hasStarted() public view returns (bool) {
252         return now >= startTime;
253     }
254 
255     /**
256      * @dev Adapted Crowdsale#hasEnded
257      * @return true if crowdsale event has ended
258      */
259     function hasEnded() public view returns (bool) {
260         return now > endTime;
261     }
262 
263     /**
264      * @dev Allow addresses to do early participation.
265      * @param addr the address to be (de)whitelisted
266      * @param status the status value, true if it is whitelisted, false otherwise
267      */
268     function setInvestorWhitelist(address addr, bool status) public {
269         require(msg.sender == whitelister);
270         investorWhitelist[addr] = status;
271         Whitelisted(addr, status);
272     }
273 
274     // send ether (wei) to the fund collection wallet
275     // override to create custom fund forwarding mechanisms
276     function forwardFunds() internal {
277         wallet.transfer(msg.value);
278     }
279 
280     // overriding Crowdsale#validPurchase to add extra cap logic
281     // @return true if investors can buy at the moment
282     function validPurchase() internal view returns (bool) {
283         if (msg.value < minWeiInvestment || msg.value > maxWeiInvestment) {
284             return false;
285         }
286         bool withinPeriod = now >= startTime && now <= endTime;
287         bool nonZeroPurchase = msg.value != 0;
288         return withinPeriod && nonZeroPurchase;
289     }
290 
291 }