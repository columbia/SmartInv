1 pragma solidity ^0.4.21;
2 
3 // File: contracts\zeppelin-solidity\contracts\ownership\Ownable.sol
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
45 // File: contracts\zeppelin-solidity\contracts\lifecycle\Pausable.sol
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
91 // File: contracts\zeppelin-solidity\contracts\math\SafeMath.sol
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
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     if (a == 0) {
104       return 0;
105     }
106     uint256 c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
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
132   function add(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: contracts\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
140 
141 /**
142  * @title ERC20Basic
143  * @dev Simpler version of ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/179
145  */
146 contract ERC20Basic {
147   function totalSupply() public view returns (uint256);
148   function balanceOf(address who) public view returns (uint256);
149   function transfer(address to, uint256 value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 // File: contracts\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: contracts\PGF500Sale.sol
167 
168 contract PGF500Sale is Pausable {
169   using SafeMath for uint256;
170 
171   struct Period {
172     uint256 startTimestamp;
173     uint256 endTimestamp;
174     uint256 rate;
175   }
176 
177   Period[] private periods;
178   mapping(address => bool) public whitelistedAddresses;
179   mapping(address => uint256) public whitelistedRates;
180 
181   ERC20 public token;
182   address public wallet;
183   address public tokenWallet;
184   uint256 public weiRaised;
185 
186   /**
187    * @dev A purchase was made.
188    * @param _purchaser Who paid for the tokens.
189    * @param _value Total purchase price in weis.
190    * @param _amount Amount of tokens purchased.
191    */
192   event TokensPurchased(address indexed _purchaser, uint256 _value, uint256 _amount);
193 
194   uint256 constant public MINIMUM_AMOUNT = 0.05 ether;
195   uint256 constant public MAXIMUM_NON_WHITELIST_AMOUNT = 20 ether;
196 
197   /**
198    * @dev Constructor, takes initial parameters.
199    * @param _wallet Address where collected funds will be forwarded to.
200    * @param _token Address of the token being sold.
201    * @param _tokenWallet Address holding the tokens, which has approved allowance to this contract.
202    */
203   function PGF500Sale(address _wallet, ERC20 _token, address _tokenWallet) public {
204     require(_wallet != address(0));
205     require(_token != address(0));
206     require(_tokenWallet != address(0));
207 
208     wallet = _wallet;
209     token = _token;
210     tokenWallet = _tokenWallet;
211   }
212 
213   /**
214    * @dev Send weis, get tokens.
215    */
216   function () external payable {
217     // Preconditions.
218     require(msg.sender != address(0));
219     require(msg.value >= MINIMUM_AMOUNT);
220     require(isOpen());
221     if (msg.value > MAXIMUM_NON_WHITELIST_AMOUNT) {
222       require(isAddressInWhitelist(msg.sender));
223     }
224 
225     uint256 tokenAmount = getTokenAmount(msg.sender, msg.value);
226     weiRaised = weiRaised.add(msg.value);
227 
228     token.transferFrom(tokenWallet, msg.sender, tokenAmount);
229     emit TokensPurchased(msg.sender, msg.value, tokenAmount);
230 
231     wallet.transfer(msg.value);
232   }
233 
234   /**
235    * @dev Add a sale period with its default rate.
236    * @param _startTimestamp Beginning of this sale period.
237    * @param _endTimestamp End of this sale period.
238    * @param _rate Rate at which tokens are sold during this sale period.
239    */
240   function addPeriod(uint256 _startTimestamp, uint256 _endTimestamp, uint256 _rate) onlyOwner public {
241     require(_startTimestamp != 0);
242     require(_endTimestamp > _startTimestamp);
243     require(_rate != 0);
244     Period memory period = Period(_startTimestamp, _endTimestamp, _rate);
245     periods.push(period);
246   }
247 
248   /**
249    * @dev Emergency function to clear all sale periods (for example in case the sale is delayed).
250    */
251   function clearPeriods() onlyOwner public {
252     delete periods;
253   }
254 
255   /**
256    * @dev Add an address to the whitelist or update the rate of an already added address.
257    * This function cannot be used to reset a previously set custom rate. Remove the address and add it
258    * again if you need to do that.
259    * @param _address Address to whitelist
260    * @param _rate Optional custom rate reserved for that address (0 = use default rate)
261    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
262    */
263   function addAddressToWhitelist(address _address, uint256 _rate) onlyOwner public returns (bool success) {
264     require(_address != address(0));
265     success = false;
266     if (!whitelistedAddresses[_address]) {
267       whitelistedAddresses[_address] = true;
268       success = true;
269     }
270     if (_rate != 0) {
271       whitelistedRates[_address] = _rate;
272     }
273   }
274 
275   /**
276    * @dev Adds an array of addresses to the whitelist, all with the same optional custom rate.
277    * @param _addresses Addresses to add.
278    * @param _rate Optional custom rate reserved for all added addresses (0 = use default rate).
279    * @return true if at least one address was added to the whitelist,
280    * false if all addresses were already in the whitelist  
281    */
282   function addAddressesToWhitelist(address[] _addresses, uint256 _rate) onlyOwner public returns (bool success) {
283     success = false;
284     for (uint256 i = 0; i <_addresses.length; i++) {
285       if (addAddressToWhitelist(_addresses[i], _rate)) {
286         success = true;
287       }
288     }
289   }
290 
291   /**
292    * @dev Remove an address from the whitelist.
293    * @param _address Address to remove.
294    * @return true if the address was removed from the whitelist, 
295    * false if the address wasn't in the whitelist in the first place.
296    */
297   function removeAddressFromWhitelist(address _address) onlyOwner public returns (bool success) {
298     require(_address != address(0));
299     success = false;
300     if (whitelistedAddresses[_address]) {
301       whitelistedAddresses[_address] = false;
302       success = true;
303     }
304     if (whitelistedRates[_address] != 0) {
305       whitelistedRates[_address] = 0;
306     }
307   }
308 
309   /**
310    * @dev Remove addresses from the whitelist.
311    * @param _addresses addresses
312    * @return true if at least one address was removed from the whitelist, 
313    * false if all addresses weren't in the whitelist in the first place
314    */
315   function removeAddressesFromWhitelist(address[] _addresses) onlyOwner public returns (bool success) {
316     success = false;
317     for (uint256 i = 0; i < _addresses.length; i++) {
318       if (removeAddressFromWhitelist(_addresses[i])) {
319         success = true;
320       }
321     }
322   }
323 
324   /**
325    * @dev True if the specified address is whitelisted.
326    */
327   function isAddressInWhitelist(address _address) view public returns (bool) {
328     return whitelistedAddresses[_address];
329   }
330 
331   /**
332    * @dev True while the sale is open (i.e. accepting contributions). False otherwise.
333    */
334   function isOpen() view public returns (bool) {
335     return ((!paused) && (_getCurrentPeriod().rate != 0));
336   }
337 
338   /**
339    * @dev Current rate for the specified purchaser.
340    * @param _purchaser Purchaser address (may or may not be whitelisted).
341    * @return Custom rate for the purchaser, or current standard rate if no custom rate was whitelisted.
342    */
343   function getCurrentRate(address _purchaser) public view returns (uint256 rate) {
344     Period memory currentPeriod = _getCurrentPeriod();
345     require(currentPeriod.rate != 0);
346     rate = whitelistedRates[_purchaser];
347     if (rate == 0) {
348       rate = currentPeriod.rate;
349     }
350   }
351 
352   /**
353    * @dev Number of tokens that a specified address would get by sending right now
354    * the specified amount.
355    * @param _purchaser Purchaser address (may or may not be whitelisted).
356    * @param _weiAmount Value in wei to be converted into tokens.
357    * @return Number of tokens that can be purchased with the specified _weiAmount.
358    */
359   function getTokenAmount(address _purchaser, uint256 _weiAmount) public view returns (uint256) {
360     return _weiAmount.mul(getCurrentRate(_purchaser));
361   }
362 
363   /**
364    * @dev Checks the amount of tokens left in the allowance.
365    * @return Amount of tokens remaining for sale.
366    */
367   function remainingTokens() public view returns (uint256) {
368     return token.allowance(tokenWallet, this);
369   }
370 
371   /*
372    * Internal functions
373    */
374 
375   /**
376    * @dev Returns the current period, or null.
377    */
378   function _getCurrentPeriod() view internal returns (Period memory _period) {
379     _period = Period(0, 0, 0);
380     uint256 len = periods.length;
381     for (uint256 i = 0; i < len; i++) {
382       if ((periods[i].startTimestamp <= block.timestamp) && (periods[i].endTimestamp >= block.timestamp)) {
383         _period = periods[i];
384         break;
385       }
386     }
387   }
388 // Proprietary a6f18ae3a419c6634596bee10ba51328
389 }