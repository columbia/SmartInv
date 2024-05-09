1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev Modifier to make a function callable only when the contract is not paused.
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is paused.
66    */
67   modifier whenPaused() {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused public {
76     paused = true;
77     Pause();
78   }
79 
80   /**
81    * @dev called by the owner to unpause, returns to normal state
82    */
83   function unpause() onlyOwner whenPaused public {
84     paused = false;
85     Unpause();
86   }
87 }
88 
89 
90 /**
91  * @title SafeMath
92  * @dev Math operations with safety checks that throw on error
93  */
94 library SafeMath {
95 
96   /**
97   * @dev Multiplies two numbers, throws on overflow.
98   */
99   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100     if (a == 0) {
101       return 0;
102     }
103     uint256 c = a * b;
104     assert(c / a == b);
105     return c;
106   }
107 
108   /**
109   * @dev Integer division of two numbers, truncating the quotient.
110   */
111   function div(uint256 a, uint256 b) internal pure returns (uint256) {
112     // assert(b > 0); // Solidity automatically throws when dividing by 0
113     uint256 c = a / b;
114     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115     return c;
116   }
117 
118   /**
119   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
120   */
121   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122     assert(b <= a);
123     return a - b;
124   }
125 
126   /**
127   * @dev Adds two numbers, throws on overflow.
128   */
129   function add(uint256 a, uint256 b) internal pure returns (uint256) {
130     uint256 c = a + b;
131     assert(c >= a);
132     return c;
133   }
134 }
135 
136 
137 /**
138  * @title Whitelist
139  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
140  * @dev This simplifies the implementation of "user permissions".
141  */
142 contract Whitelist is Ownable {
143   mapping(address => bool) public whitelist;
144 
145   event WhitelistedAddressAdded(address addr);
146   event WhitelistedAddressRemoved(address addr);
147 
148   /**
149    * @dev Throws if called by any account that's not whitelisted.
150    */
151   modifier onlyWhitelisted() {
152     require(whitelist[msg.sender]);
153     _;
154   }
155 
156   /**
157    * @dev add an address to the whitelist
158    * @param addr address
159    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
160    */
161   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
162     if (!whitelist[addr]) {
163       whitelist[addr] = true;
164       WhitelistedAddressAdded(addr);
165       success = true;
166     }
167   }
168 
169   /**
170    * @dev add addresses to the whitelist
171    * @param addrs addresses
172    * @return true if at least one address was added to the whitelist,
173    * false if all addresses were already in the whitelist
174    */
175   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
176     for (uint256 i = 0; i < addrs.length; i++) {
177       if (addAddressToWhitelist(addrs[i])) {
178         success = true;
179       }
180     }
181   }
182 
183   /**
184    * @dev remove an address from the whitelist
185    * @param addr address
186    * @return true if the address was removed from the whitelist,
187    * false if the address wasn't in the whitelist in the first place
188    */
189   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
190     if (whitelist[addr]) {
191       whitelist[addr] = false;
192       WhitelistedAddressRemoved(addr);
193       success = true;
194     }
195   }
196 
197   /**
198    * @dev remove addresses from the whitelist
199    * @param addrs addresses
200    * @return true if at least one address was removed from the whitelist,
201    * false if all addresses weren't in the whitelist in the first place
202    */
203   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
204     for (uint256 i = 0; i < addrs.length; i++) {
205       if (removeAddressFromWhitelist(addrs[i])) {
206         success = true;
207       }
208     }
209   }
210 
211 }
212 
213 
214 /**
215  * @title ERC20Basic
216  * @dev Simpler version of ERC20 interface
217  * @dev see https://github.com/ethereum/EIPs/issues/179
218  */
219 contract ERC20Basic {
220   function totalSupply() public view returns (uint256);
221   function balanceOf(address who) public view returns (uint256);
222   function transfer(address to, uint256 value) public returns (bool);
223   event Transfer(address indexed from, address indexed to, uint256 value);
224 }
225 
226 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
227 
228 /**
229  * @title ERC20 interface
230  * @dev see https://github.com/ethereum/EIPs/issues/20
231  */
232 contract ERC20 is ERC20Basic {
233   function allowance(address owner, address spender) public view returns (uint256);
234   function transferFrom(address from, address to, uint256 value) public returns (bool);
235   function approve(address spender, uint256 value) public returns (bool);
236   event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
240 
241 /**
242  * @title SafeERC20
243  * @dev Wrappers around ERC20 operations that throw on failure.
244  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
245  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
246  */
247 library SafeERC20 {
248   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
249     assert(token.transfer(to, value));
250   }
251 
252   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
253     assert(token.transferFrom(from, to, value));
254   }
255 
256   function safeApprove(ERC20 token, address spender, uint256 value) internal {
257     assert(token.approve(spender, value));
258   }
259 }
260 
261 
262 contract PresaleFirst is Whitelist, Pausable {
263     using SafeMath for uint256;
264     using SafeERC20 for ERC20;
265 
266     uint256 public constant maxcap = 1500 ether;
267     uint256 public constant exceed = 300 ether;
268     uint256 public constant minimum = 0.5 ether;
269     uint256 public constant rate = 11500;
270 
271     uint256 public startNumber;
272     uint256 public endNumber;
273     uint256 public weiRaised;
274     address public wallet;
275     ERC20 public token;
276 
277     function PresaleFirst (
278         uint256 _startNumber,
279         uint256 _endNumber,
280         address _wallet,
281         address _token
282         ) public {
283         require(_wallet != address(0));
284         require(_token != address(0));
285 
286         startNumber = _startNumber;
287         endNumber = _endNumber;
288         wallet = _wallet;
289         token = ERC20(_token);
290         weiRaised = 0;
291     }
292 
293 //////////////////
294 //  collect eth
295 //////////////////
296 
297     mapping (address => uint256) public buyers;
298     address[] private keys;
299 
300     function getKeyLength() external constant returns (uint256) {
301         return keys.length;
302     }
303 
304     function () external payable {
305         collect(msg.sender);
306     }
307 
308     function collect(address _buyer) public payable onlyWhitelisted whenNotPaused {
309         require(_buyer != address(0));
310         require(weiRaised <= maxcap);
311         require(preValidation());
312         require(buyers[_buyer] < exceed);
313 
314         // get exist amount
315         if(buyers[_buyer] == 0) {
316             keys.push(_buyer);
317         }
318 
319         uint256 purchase = getPurchaseAmount(_buyer);
320         uint256 refund = (msg.value).sub(purchase);
321 
322         // refund
323         _buyer.transfer(refund);
324 
325         // buy
326         uint256 tokenAmount = purchase.mul(rate);
327         weiRaised = weiRaised.add(purchase);
328 
329         // wallet
330         buyers[_buyer] = buyers[_buyer].add(purchase);
331         emit BuyTokens(_buyer, purchase, tokenAmount);
332     }
333 
334 //////////////////
335 //  validation functions for collect
336 //////////////////
337 
338     function preValidation() private constant returns (bool) {
339         // check minimum
340         bool a = msg.value >= minimum;
341 
342         // sale duration
343         bool b = block.number >= startNumber && block.number <= endNumber;
344 
345         return a && b;
346     }
347 
348     function getPurchaseAmount(address _buyer) private constant returns (uint256) {
349         return checkOverMaxcap(checkOverExceed(_buyer));
350     }
351 
352     // 1. check over exceed
353     function checkOverExceed(address _buyer) private constant returns (uint256) {
354         if(msg.value >= exceed) {
355             return exceed;
356         } else if(msg.value.add(buyers[_buyer]) >= exceed) {
357             return exceed.sub(buyers[_buyer]);
358         } else {
359             return msg.value;
360         }
361     }
362 
363     // 2. check sale hardcap
364     function checkOverMaxcap(uint256 amount) private constant returns (uint256) {
365         if((amount + weiRaised) >= maxcap) {
366             return (maxcap.sub(weiRaised));
367         } else {
368             return amount;
369         }
370     }
371 
372 //////////////////
373 //  finalize
374 //////////////////
375 
376     bool finalized = false;
377 
378     function finalize() public onlyOwner {
379         require(!finalized);
380         require(weiRaised >= maxcap || block.number >= endNumber);
381 
382         // dev team
383         withdrawEther();
384         withdrawToken();
385 
386         finalized = true;
387     }
388 
389 //////////////////
390 //  release
391 //////////////////
392 
393     function release(address addr) public onlyOwner {
394         require(!finalized);
395 
396         token.safeTransfer(addr, buyers[addr].mul(rate));
397         emit Release(addr, buyers[addr].mul(rate));
398 
399         buyers[addr] = 0;
400     }
401 
402     function releaseMany(uint256 start, uint256 end) external onlyOwner {
403         for(uint256 i = start; i < end; i++) {
404             release(keys[i]);
405         }
406     }
407 
408 //////////////////
409 //  refund
410 //////////////////
411 
412     function refund(address addr) public onlyOwner {
413         require(!finalized);
414 
415         addr.transfer(buyers[addr]);
416         emit Refund(addr, buyers[addr]);
417 
418         buyers[addr] = 0;
419     }
420 
421     function refundMany(uint256 start, uint256 end) external onlyOwner {
422         for(uint256 i = start; i < end; i++) {
423             refund(keys[i]);
424         }
425     }
426 
427 //////////////////
428 //  withdraw
429 //////////////////
430 
431     function withdrawToken() public onlyOwner {
432         token.safeTransfer(wallet, token.balanceOf(this));
433         emit Withdraw(wallet, token.balanceOf(this));
434     }
435 
436     function withdrawEther() public onlyOwner {
437         wallet.transfer(address(this).balance);
438         emit Withdraw(wallet, address(this).balance);
439     }
440 
441 //////////////////
442 //  events
443 //////////////////
444 
445     event Release(address indexed _to, uint256 _amount);
446     event Withdraw(address indexed _from, uint256 _amount);
447     event Refund(address indexed _to, uint256 _amount);
448     event BuyTokens(address indexed buyer, uint256 price, uint256 tokens);
449 }