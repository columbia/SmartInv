1 /*
2   8888888 .d8888b.   .d88888b.   .d8888b.  888                     888                 888      
3     888  d88P  Y88b d88P" "Y88b d88P  Y88b 888                     888                 888      
4     888  888    888 888     888 Y88b.      888                     888                 888      
5     888  888        888     888  "Y888b.   888888  8888b.  888d888 888888      .d8888b 88888b.  
6     888  888        888     888     "Y88b. 888        "88b 888P"   888        d88P"    888 "88b 
7     888  888    888 888     888       "888 888    .d888888 888     888        888      888  888 
8     888  Y88b  d88P Y88b. .d88P Y88b  d88P Y88b.  888  888 888     Y88b.  d8b Y88b.    888  888 
9   8888888 "Y8888P"   "Y88888P"   "Y8888P"   "Y888 "Y888888 888      "Y888 Y8P  "Y8888P 888  888 
10 
11   Rocket startup for your ICO
12 
13   The innovative platform to create your initial coin offering (ICO) simply, safely and professionally.
14   All the services your project needs: KYC, AI Audit, Smart contract wizard, Legal template,
15   Master Nodes management, on a single SaaS platform!
16 */
17 pragma solidity ^0.4.21;
18 
19 // File: contracts\zeppelin-solidity\contracts\ownership\Ownable.sol
20 
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27   address public owner;
28 
29 
30   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() public {
38     owner = msg.sender;
39   }
40 
41   /**
42    * @dev Throws if called by any account other than the owner.
43    */
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) public onlyOwner {
54     require(newOwner != address(0));
55     emit OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 
61 // File: contracts\zeppelin-solidity\contracts\lifecycle\Pausable.sol
62 
63 /**
64  * @title Pausable
65  * @dev Base contract which allows children to implement an emergency stop mechanism.
66  */
67 contract Pausable is Ownable {
68   event Pause();
69   event Unpause();
70 
71   bool public paused = false;
72 
73 
74   /**
75    * @dev Modifier to make a function callable only when the contract is not paused.
76    */
77   modifier whenNotPaused() {
78     require(!paused);
79     _;
80   }
81 
82   /**
83    * @dev Modifier to make a function callable only when the contract is paused.
84    */
85   modifier whenPaused() {
86     require(paused);
87     _;
88   }
89 
90   /**
91    * @dev called by the owner to pause, triggers stopped state
92    */
93   function pause() onlyOwner whenNotPaused public {
94     paused = true;
95     emit Pause();
96   }
97 
98   /**
99    * @dev called by the owner to unpause, returns to normal state
100    */
101   function unpause() onlyOwner whenPaused public {
102     paused = false;
103     emit Unpause();
104   }
105 }
106 
107 // File: contracts\zeppelin-solidity\contracts\math\SafeMath.sol
108 
109 /**
110  * @title SafeMath
111  * @dev Math operations with safety checks that throw on error
112  */
113 library SafeMath {
114 
115   /**
116   * @dev Multiplies two numbers, throws on overflow.
117   */
118   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119     if (a == 0) {
120       return 0;
121     }
122     uint256 c = a * b;
123     assert(c / a == b);
124     return c;
125   }
126 
127   /**
128   * @dev Integer division of two numbers, truncating the quotient.
129   */
130   function div(uint256 a, uint256 b) internal pure returns (uint256) {
131     // assert(b > 0); // Solidity automatically throws when dividing by 0
132     uint256 c = a / b;
133     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134     return c;
135   }
136 
137   /**
138   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
139   */
140   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141     assert(b <= a);
142     return a - b;
143   }
144 
145   /**
146   * @dev Adds two numbers, throws on overflow.
147   */
148   function add(uint256 a, uint256 b) internal pure returns (uint256) {
149     uint256 c = a + b;
150     assert(c >= a);
151     return c;
152   }
153 }
154 
155 // File: contracts\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
156 
157 /**
158  * @title ERC20Basic
159  * @dev Simpler version of ERC20 interface
160  * @dev see https://github.com/ethereum/EIPs/issues/179
161  */
162 contract ERC20Basic {
163   function totalSupply() public view returns (uint256);
164   function balanceOf(address who) public view returns (uint256);
165   function transfer(address to, uint256 value) public returns (bool);
166   event Transfer(address indexed from, address indexed to, uint256 value);
167 }
168 
169 // File: contracts\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
170 
171 /**
172  * @title ERC20 interface
173  * @dev see https://github.com/ethereum/EIPs/issues/20
174  */
175 contract ERC20 is ERC20Basic {
176   function allowance(address owner, address spender) public view returns (uint256);
177   function transferFrom(address from, address to, uint256 value) public returns (bool);
178   function approve(address spender, uint256 value) public returns (bool);
179   event Approval(address indexed owner, address indexed spender, uint256 value);
180 }
181 
182 // File: contracts\ICOStartSale.sol
183 
184 contract ICOStartSale is Pausable {
185   using SafeMath for uint256;
186 
187   struct Period {
188     uint256 startTimestamp;
189     uint256 endTimestamp;
190     uint256 rate;
191   }
192 
193   Period[] private periods;
194   mapping(address => bool) public whitelistedAddresses;
195   mapping(address => uint256) public whitelistedRates;
196 
197   ERC20 public token;
198   address public wallet;
199   address public tokenWallet;
200   uint256 public weiRaised;
201 
202   /**
203    * @dev A purchase was made.
204    * @param _purchaser Who paid for the tokens.
205    * @param _value Total purchase price in weis.
206    * @param _amount Amount of tokens purchased.
207    */
208   event TokensPurchased(address indexed _purchaser, uint256 _value, uint256 _amount);
209 
210   uint256 constant public MINIMUM_AMOUNT = 0.05 ether;
211   uint256 constant public MAXIMUM_NON_WHITELIST_AMOUNT = 5 ether;
212 
213   /**
214    * @dev Constructor, takes initial parameters.
215    * @param _wallet Address where collected funds will be forwarded to.
216    * @param _token Address of the token being sold.
217    * @param _tokenWallet Address holding the tokens, which has approved allowance to this contract.
218    */
219   function ICOStartSale(address _wallet, ERC20 _token, address _tokenWallet) public {
220     require(_wallet != address(0));
221     require(_token != address(0));
222     require(_tokenWallet != address(0));
223 
224     wallet = _wallet;
225     token = _token;
226     tokenWallet = _tokenWallet;
227   }
228 
229   /**
230    * @dev Send weis, get tokens.
231    */
232   function () external payable {
233     // Preconditions.
234     require(msg.sender != address(0));
235     require(msg.value >= MINIMUM_AMOUNT);
236     require(isOpen());
237     if (msg.value > MAXIMUM_NON_WHITELIST_AMOUNT) {
238       require(isAddressInWhitelist(msg.sender));
239     }
240 
241     uint256 tokenAmount = getTokenAmount(msg.sender, msg.value);
242     weiRaised = weiRaised.add(msg.value);
243 
244     token.transferFrom(tokenWallet, msg.sender, tokenAmount);
245     emit TokensPurchased(msg.sender, msg.value, tokenAmount);
246 
247     wallet.transfer(msg.value);
248   }
249 
250   /**
251    * @dev Add a sale period with its default rate.
252    * @param _startTimestamp Beginning of this sale period.
253    * @param _endTimestamp End of this sale period.
254    * @param _rate Rate at which tokens are sold during this sale period.
255    */
256   function addPeriod(uint256 _startTimestamp, uint256 _endTimestamp, uint256 _rate) onlyOwner public {
257     require(_startTimestamp != 0);
258     require(_endTimestamp > _startTimestamp);
259     require(_rate != 0);
260     Period memory period = Period(_startTimestamp, _endTimestamp, _rate);
261     periods.push(period);
262   }
263 
264   /**
265    * @dev Emergency function to clear all sale periods (for example in case the sale is delayed).
266    */
267   function clearPeriods() onlyOwner public {
268     delete periods;
269   }
270 
271   /**
272    * @dev Add an address to the whitelist or update the rate of an already added address.
273    * This function cannot be used to reset a previously set custom rate. Remove the address and add it
274    * again if you need to do that.
275    * @param _address Address to whitelist
276    * @param _rate Optional custom rate reserved for that address (0 = use default rate)
277    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
278    */
279   function addAddressToWhitelist(address _address, uint256 _rate) onlyOwner public returns (bool success) {
280     require(_address != address(0));
281     success = false;
282     if (!whitelistedAddresses[_address]) {
283       whitelistedAddresses[_address] = true;
284       success = true;
285     }
286     if (_rate != 0) {
287       whitelistedRates[_address] = _rate;
288     }
289   }
290 
291   /**
292    * @dev Adds an array of addresses to the whitelist, all with the same optional custom rate.
293    * @param _addresses Addresses to add.
294    * @param _rate Optional custom rate reserved for all added addresses (0 = use default rate).
295    * @return true if at least one address was added to the whitelist,
296    * false if all addresses were already in the whitelist  
297    */
298   function addAddressesToWhitelist(address[] _addresses, uint256 _rate) onlyOwner public returns (bool success) {
299     success = false;
300     for (uint256 i = 0; i <_addresses.length; i++) {
301       if (addAddressToWhitelist(_addresses[i], _rate)) {
302         success = true;
303       }
304     }
305   }
306 
307   /**
308    * @dev Remove an address from the whitelist.
309    * @param _address Address to remove.
310    * @return true if the address was removed from the whitelist, 
311    * false if the address wasn't in the whitelist in the first place.
312    */
313   function removeAddressFromWhitelist(address _address) onlyOwner public returns (bool success) {
314     require(_address != address(0));
315     success = false;
316     if (whitelistedAddresses[_address]) {
317       whitelistedAddresses[_address] = false;
318       success = true;
319     }
320     if (whitelistedRates[_address] != 0) {
321       whitelistedRates[_address] = 0;
322     }
323   }
324 
325   /**
326    * @dev Remove addresses from the whitelist.
327    * @param _addresses addresses
328    * @return true if at least one address was removed from the whitelist, 
329    * false if all addresses weren't in the whitelist in the first place
330    */
331   function removeAddressesFromWhitelist(address[] _addresses) onlyOwner public returns (bool success) {
332     success = false;
333     for (uint256 i = 0; i < _addresses.length; i++) {
334       if (removeAddressFromWhitelist(_addresses[i])) {
335         success = true;
336       }
337     }
338   }
339 
340   /**
341    * @dev True if the specified address is whitelisted.
342    */
343   function isAddressInWhitelist(address _address) view public returns (bool) {
344     return whitelistedAddresses[_address];
345   }
346 
347   /**
348    * @dev True while the sale is open (i.e. accepting contributions). False otherwise.
349    */
350   function isOpen() view public returns (bool) {
351     return ((!paused) && (_getCurrentPeriod().rate != 0));
352   }
353 
354   /**
355    * @dev Current rate for the specified purchaser.
356    * @param _purchaser Purchaser address (may or may not be whitelisted).
357    * @return Custom rate for the purchaser, or current standard rate if no custom rate was whitelisted.
358    */
359   function getCurrentRate(address _purchaser) public view returns (uint256 rate) {
360     Period memory currentPeriod = _getCurrentPeriod();
361     require(currentPeriod.rate != 0);
362     rate = whitelistedRates[_purchaser];
363     if (rate == 0) {
364       rate = currentPeriod.rate;
365     }
366   }
367 
368   /**
369    * @dev Number of tokens that a specified address would get by sending right now
370    * the specified amount.
371    * @param _purchaser Purchaser address (may or may not be whitelisted).
372    * @param _weiAmount Value in wei to be converted into tokens.
373    * @return Number of tokens that can be purchased with the specified _weiAmount.
374    */
375   function getTokenAmount(address _purchaser, uint256 _weiAmount) public view returns (uint256) {
376     return _weiAmount.mul(getCurrentRate(_purchaser));
377   }
378 
379   /**
380    * @dev Checks the amount of tokens left in the allowance.
381    * @return Amount of tokens remaining for sale.
382    */
383   function remainingTokens() public view returns (uint256) {
384     return token.allowance(tokenWallet, this);
385   }
386 
387   /*
388    * Internal functions
389    */
390 
391   /**
392    * @dev Returns the current period, or null.
393    */
394   function _getCurrentPeriod() view internal returns (Period memory _period) {
395     _period = Period(0, 0, 0);
396     uint256 len = periods.length;
397     for (uint256 i = 0; i < len; i++) {
398       if ((periods[i].startTimestamp <= block.timestamp) && (periods[i].endTimestamp >= block.timestamp)) {
399         _period = periods[i];
400         break;
401       }
402     }
403   }
404 
405 }