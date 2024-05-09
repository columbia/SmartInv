1 pragma solidity ^0.4.0;
2 
3 /**
4  * @title Ownable
5  * @dev Adds onlyOwner modifier. Subcontracts should implement checkOwner to check if caller is owner.
6  */
7 contract Ownable {
8     modifier onlyOwner() {
9         checkOwner();
10         _;
11     }
12 
13     function checkOwner() internal;
14 }
15 
16 /**
17  * @title OwnableImpl
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract OwnableImpl is Ownable {
22     address public owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     /**
27      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28      * account.
29      */
30     function OwnableImpl() public {
31         owner = msg.sender;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     function checkOwner() internal {
38         require(msg.sender == owner);
39     }
40 
41     /**
42      * @dev Allows the current owner to transfer control of the contract to a newOwner.
43      * @param newOwner The address to transfer ownership to.
44      */
45     function transferOwnership(address newOwner) onlyOwner public {
46         require(newOwner != address(0));
47         OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49     }
50 }
51 
52 /**
53  * @title Pausable
54  * @dev Base contract which allows children to implement an emergency stop mechanism.
55  */
56 contract Pausable is Ownable {
57     event Pause();
58     event Unpause();
59 
60     bool public paused = false;
61 
62 
63     /**
64      * @dev Modifier to make a function callable only when the contract is not paused.
65      */
66     modifier whenNotPaused() {
67         require(!paused);
68         _;
69     }
70 
71     /**
72      * @dev Modifier to make a function callable only when the contract is paused.
73      */
74     modifier whenPaused() {
75         require(paused);
76         _;
77     }
78 
79     /**
80      * @dev called by the owner to pause, triggers stopped state
81      */
82     function pause() onlyOwner whenNotPaused public {
83         paused = true;
84         Pause();
85     }
86 
87     /**
88      * @dev called by the owner to unpause, returns to normal state
89      */
90     function unpause() onlyOwner whenPaused public {
91         paused = false;
92         Unpause();
93     }
94 }
95 
96 /**
97  * @title Read-only ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/20
99  */
100 contract ReadOnlyToken {
101     uint256 public totalSupply;
102     function balanceOf(address who) public constant returns (uint256);
103     function allowance(address owner, address spender) public constant returns (uint256);
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract Token is ReadOnlyToken {
111   function transfer(address to, uint256 value) public returns (bool);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Transfer(address indexed from, address indexed to, uint256 value);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 contract MintableToken is Token {
119     event Mint(address indexed to, uint256 amount);
120 
121     function mint(address _to, uint256 _amount) public returns (bool);
122 }
123 
124 /**
125  * @title Sale contract for Daonomic platform should implement this
126  */
127 contract Sale {
128     /**
129      * @dev This event should be emitted when user buys something
130      */
131     event Purchase(address indexed buyer, address token, uint256 value, uint256 sold, uint256 bonus);
132     /**
133      * @dev Should be emitted if new payment method added
134      */
135     event RateAdd(address token);
136     /**
137      * @dev Should be emitted if payment method removed
138      */
139     event RateRemove(address token);
140 
141     /**
142      * @dev Calculate rate for specified payment method
143      */
144     function getRate(address token) constant public returns (uint256);
145     /**
146      * @dev Calculate current bonus in tokens
147      */
148     function getBonus(uint256 sold) constant public returns (uint256);
149 }
150 
151 /**
152  * @title SafeMath
153  * @dev Math operations with safety checks that throw on error
154  * @dev this version copied from zeppelin-solidity, constant changed to pure
155  */
156 library SafeMath {
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         if (a == 0) {
159             return 0;
160         }
161         uint256 c = a * b;
162         assert(c / a == b);
163         return c;
164     }
165 
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         // assert(b > 0); // Solidity automatically throws when dividing by 0
168         uint256 c = a / b;
169         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
170         return c;
171     }
172 
173     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174         assert(b <= a);
175         return a - b;
176     }
177 
178     function add(uint256 a, uint256 b) internal pure returns (uint256) {
179         uint256 c = a + b;
180         assert(c >= a);
181         return c;
182     }
183 }
184 
185 /**
186  * @title Token represents some external value (for example, BTC)
187  */
188 contract ExternalToken is Token {
189     event Mint(address indexed to, uint256 value, bytes data);
190     event Burn(address indexed burner, uint256 value, bytes data);
191 
192     function burn(uint256 _value, bytes _data) public;
193 }
194 
195 /**
196  * @dev This adapter helps to receive tokens. It has some subcontracts for different tokens:
197  *   ERC20ReceiveAdapter - for receiving simple ERC20 tokens
198  *   ERC223ReceiveAdapter - for receiving ERC223 tokens
199  *   ReceiveApprovalAdapter - for receiving ERC20 tokens when token notifies receiver with receiveApproval
200  *   EtherReceiveAdapter - for receiving ether (onReceive callback will be used). this is needed for handling ether like tokens
201  *   CompatReceiveApproval - implements all these adapters
202  */
203 contract ReceiveAdapter {
204 
205     /**
206      * @dev Receive tokens from someone. Owner of the tokens should approve first
207      */
208     function onReceive(address _token, address _from, uint256 _value, bytes _data) internal;
209 }
210 
211 /**
212  * @dev Helps to receive ERC20-complaint tokens. Owner should call token.approve first
213  */
214 contract ERC20ReceiveAdapter is ReceiveAdapter {
215     function receive(address _token, uint256 _value, bytes _data) public {
216         Token token = Token(_token);
217         token.transferFrom(msg.sender, this, _value);
218         onReceive(_token, msg.sender, _value, _data);
219     }
220 }
221 
222 /**
223  * @title ERC223 TokenReceiver interface
224  * @dev see https://github.com/ethereum/EIPs/issues/223
225  */
226 contract TokenReceiver {
227     function onTokenTransfer(address _from, uint256 _value, bytes _data) public;
228 }
229 
230 /**
231  * @dev Helps to receive ERC223-complaint tokens. ERC223 Token contract should notify receiver.
232  */
233 contract ERC223ReceiveAdapter is TokenReceiver, ReceiveAdapter {
234     function tokenFallback(address _from, uint256 _value, bytes _data) public {
235         onReceive(msg.sender, _from, _value, _data);
236     }
237 
238     function onTokenTransfer(address _from, uint256 _value, bytes _data) public {
239         onReceive(msg.sender, _from, _value, _data);
240     }
241 }
242 
243 contract EtherReceiver {
244 	function receiveWithData(bytes _data) payable public;
245 }
246 
247 contract EtherReceiveAdapter is EtherReceiver, ReceiveAdapter {
248     function () payable public {
249         receiveWithData("");
250     }
251 
252     function receiveWithData(bytes _data) payable public {
253         onReceive(address(0), msg.sender, msg.value, _data);
254     }
255 }
256 
257 /**
258  * @dev This ReceiveAdapter supports all possible tokens
259  */
260 contract CompatReceiveAdapter is ERC20ReceiveAdapter, ERC223ReceiveAdapter, EtherReceiveAdapter {
261 
262 }
263 
264 contract AbstractSale is Sale, CompatReceiveAdapter, Ownable {
265     using SafeMath for uint256;
266 
267     event Withdraw(address token, address to, uint256 value);
268     event Burn(address token, uint256 value, bytes data);
269 
270     function onReceive(address _token, address _from, uint256 _value, bytes _data) internal {
271         uint256 sold = getSold(_token, _value);
272         require(sold > 0);
273         uint256 bonus = getBonus(sold);
274         address buyer;
275         if (_data.length == 20) {
276             buyer = address(toBytes20(_data, 0));
277         } else {
278             require(_data.length == 0);
279             buyer = _from;
280         }
281         checkPurchaseValid(buyer, sold, bonus);
282         doPurchase(buyer, sold, bonus);
283         Purchase(buyer, _token, _value, sold, bonus);
284         onPurchase(buyer, _token, _value, sold, bonus);
285     }
286 
287     function getSold(address _token, uint256 _value) constant public returns (uint256) {
288         uint256 rate = getRate(_token);
289         require(rate > 0);
290         return _value.mul(rate).div(10**18);
291     }
292 
293     function getBonus(uint256 sold) constant public returns (uint256);
294 
295     function getRate(address _token) constant public returns (uint256);
296 
297     function doPurchase(address buyer, uint256 sold, uint256 bonus) internal;
298 
299     function checkPurchaseValid(address /*buyer*/, uint256 /*sold*/, uint256 /*bonus*/) internal {
300 
301     }
302 
303     function onPurchase(address /*buyer*/, address /*token*/, uint256 /*value*/, uint256 /*sold*/, uint256 /*bonus*/) internal {
304 
305     }
306 
307     function toBytes20(bytes b, uint256 _start) pure internal returns (bytes20 result) {
308         require(_start + 20 <= b.length);
309         assembly {
310             let from := add(_start, add(b, 0x20))
311             result := mload(from)
312         }
313     }
314 
315     function withdrawEth(address _to, uint256 _value) onlyOwner public {
316         withdraw(address(0), _to, _value);
317     }
318 
319     function withdraw(address _token, address _to, uint256 _value) onlyOwner public {
320         require(_to != address(0));
321         verifyCanWithdraw(_token, _to, _value);
322         if (_token == address(0)) {
323             _to.transfer(_value);
324         } else {
325             Token(_token).transfer(_to, _value);
326         }
327         Withdraw(_token, _to, _value);
328     }
329 
330     function verifyCanWithdraw(address token, address to, uint256 amount) internal;
331 
332     function burnWithData(address _token, uint256 _value, bytes _data) onlyOwner public {
333         ExternalToken(_token).burn(_value, _data);
334         Burn(_token, _value, _data);
335     }
336 }
337 
338 /**
339  * @title This sale mints token when user sends accepted payments
340  */
341 contract MintingSale is AbstractSale {
342     MintableToken public token;
343 
344     function MintingSale(address _token) public {
345         token = MintableToken(_token);
346     }
347 
348     function doPurchase(address buyer, uint256 sold, uint256 bonus) internal {
349         token.mint(buyer, sold.add(bonus));
350     }
351 
352     function verifyCanWithdraw(address, address, uint256) internal {
353 
354     }
355 }
356 
357 /**
358  * @title Secured
359  * @dev Adds only(role) modifier. Subcontracts should implement checkRole to check if caller is allowed to do action.
360  */
361 contract Secured {
362     modifier only(string role) {
363         require(msg.sender == getRole(role));
364         _;
365     }
366 
367     function getRole(string role) constant public returns (address);
368 }
369 
370 contract Whitelist is Secured {
371 	mapping(address => bool) whitelist;
372 	event WhitelistChange(address indexed addr, bool allow);
373 
374 	function isInWhitelist(address addr) constant public returns (bool) {
375 		return whitelist[addr];
376 	}
377 
378 	function setWhitelist(address addr, bool allow) only("operator") public {
379 		setWhitelistInternal(addr, allow);
380 	}
381 
382 	function setWhitelistInternal(address addr, bool allow) internal {
383 		whitelist[addr] = allow;
384 		WhitelistChange(addr, allow);
385 	}
386 }
387 
388 contract WhitelistSale is AbstractSale, Whitelist {
389 	function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
390 		super.checkPurchaseValid(buyer, sold, bonus);
391 		require(isInWhitelist(buyer));
392 	}
393 }
394 
395 contract SecuredImpl is Ownable, Secured {
396 	mapping(string => address) users;
397 	event RoleTransferred(address indexed previousUser, address indexed newUser, string role);
398 
399 	function getRole(string role) constant public returns (address) {
400 		return users[role];
401 	}
402 
403 	function transferRole(string role, address to) onlyOwner public {
404 		require(to != address(0));
405 		RoleTransferred(users[role], to, role);
406 		users[role] = to;
407 	}
408 }
409 
410 contract RatesChangingSale is AbstractSale {
411 	event RateChange(address token, uint256 rate);
412 	mapping (address => uint256) rates;
413 
414 	function getRate(address _token) constant public returns (uint256) {
415 		return rates[_token];
416 	}
417 
418 	function setRate(address _token, uint256 _rate) onlyOwner public {
419 		rates[_token] = _rate;
420 		RateChange(_token, _rate);
421 		if (_rate == 0) {
422 			RateRemove(_token);
423 		} else {
424 			RateAdd(_token);
425 		}
426 	}
427 }
428 
429 contract HcftSale is OwnableImpl, SecuredImpl, MintingSale, WhitelistSale, RatesChangingSale {
430 	address public btcToken;
431 
432 	function HcftSale(address _mintableToken, address _btcToken)
433 	MintingSale(_mintableToken) {
434 		btcToken = _btcToken;
435 		setRates(1000 * 10**18, 10000 * 10**28, 10**34);
436 	}
437 
438 	function getSold(address _token, uint256 _value) constant public returns (uint256) {
439 		return super.getSold(_token, _value).div(99).mul(98);
440 	}
441 
442 	function getBonus(uint256 /*bonus*/) constant public returns (uint256) {
443 		return 0;
444 	}
445 
446 	function setRates(uint256 ethRate, uint256 btcRate, uint256 usdRate) onlyOwner public {
447 		setRate(address(0), ethRate);
448 		setRate(btcToken, btcRate);
449 		setRate(address(1), usdRate);
450 	}
451 
452 	function transferTokenOwnership(address newOwner) onlyOwner public {
453 		OwnableImpl(token).transferOwnership(newOwner);
454 	}
455 
456 	function pauseToken() onlyOwner public {
457 		Pausable(token).pause();
458 	}
459 
460 	function unpauseToken() onlyOwner public {
461 		Pausable(token).unpause();
462 	}
463 
464 	function withdrawBtc(bytes _to, uint256 _value) onlyOwner public {
465 		burnWithData(btcToken, _value, _to);
466 	}
467 
468 	function transfer(address beneficiary, uint256 amount) onlyOwner public {
469 		emulatePurchase(beneficiary, address(10), 0, amount);
470 	}
471 
472 	function emulatePurchase(address beneficiary, address paymentMethod, uint256 value, uint256 amount) onlyOwner public {
473 		setWhitelistInternal(beneficiary, true);
474 		doPurchase(beneficiary, amount, 0);
475 		Purchase(beneficiary, paymentMethod, value, amount, 0);
476 		onPurchase(beneficiary, paymentMethod, value, amount, 0);
477 	}
478 }