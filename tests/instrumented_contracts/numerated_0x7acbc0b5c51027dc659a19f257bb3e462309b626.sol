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
53  * @title Read-only ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ReadOnlyToken {
57     uint256 public totalSupply;
58     function balanceOf(address who) public constant returns (uint256);
59     function allowance(address owner, address spender) public constant returns (uint256);
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract Token is ReadOnlyToken {
67   function transfer(address to, uint256 value) public returns (bool);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract MintableToken is Token {
75     event Mint(address indexed to, uint256 amount);
76 
77     function mint(address _to, uint256 _amount) public returns (bool);
78 }
79 
80 /**
81  * @title Sale contract for Daonomic platform should implement this
82  */
83 contract Sale {
84     /**
85      * @dev This event should be emitted when user buys something
86      */
87     event Purchase(address indexed buyer, address token, uint256 value, uint256 sold, uint256 bonus);
88     /**
89      * @dev Should be emitted if new payment method added
90      */
91     event RateAdd(address token);
92     /**
93      * @dev Should be emitted if payment method removed
94      */
95     event RateRemove(address token);
96 
97     /**
98      * @dev Calculate rate for specified payment method
99      */
100     function getRate(address token) constant public returns (uint256);
101     /**
102      * @dev Calculate current bonus in tokens
103      */
104     function getBonus(uint256 sold) constant public returns (uint256);
105 }
106 
107 /**
108  * @title SafeMath
109  * @dev Math operations with safety checks that throw on error
110  * @dev this version copied from zeppelin-solidity, constant changed to pure
111  */
112 library SafeMath {
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         if (a == 0) {
115             return 0;
116         }
117         uint256 c = a * b;
118         assert(c / a == b);
119         return c;
120     }
121 
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         // assert(b > 0); // Solidity automatically throws when dividing by 0
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126         return c;
127     }
128 
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         assert(b <= a);
131         return a - b;
132     }
133 
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         assert(c >= a);
137         return c;
138     }
139 }
140 
141 /**
142  * @title Token represents some external value (for example, BTC)
143  */
144 contract ExternalToken is Token {
145     event Mint(address indexed to, uint256 value, bytes data);
146     event Burn(address indexed burner, uint256 value, bytes data);
147 
148     function burn(uint256 _value, bytes _data) public;
149 }
150 
151 /**
152  * @dev This adapter helps to receive tokens. It has some subcontracts for different tokens:
153  *   ERC20ReceiveAdapter - for receiving simple ERC20 tokens
154  *   ERC223ReceiveAdapter - for receiving ERC223 tokens
155  *   ReceiveApprovalAdapter - for receiving ERC20 tokens when token notifies receiver with receiveApproval
156  *   EtherReceiveAdapter - for receiving ether (onReceive callback will be used). this is needed for handling ether like tokens
157  *   CompatReceiveApproval - implements all these adapters
158  */
159 contract ReceiveAdapter {
160 
161     /**
162      * @dev Receive tokens from someone. Owner of the tokens should approve first
163      */
164     function onReceive(address _token, address _from, uint256 _value, bytes _data) internal;
165 }
166 
167 /**
168  * @dev Helps to receive ERC20-complaint tokens. Owner should call token.approve first
169  */
170 contract ERC20ReceiveAdapter is ReceiveAdapter {
171     function receive(address _token, uint256 _value, bytes _data) public {
172         Token token = Token(_token);
173         token.transferFrom(msg.sender, this, _value);
174         onReceive(_token, msg.sender, _value, _data);
175     }
176 }
177 
178 /**
179  * @title ERC223 TokenReceiver interface
180  * @dev see https://github.com/ethereum/EIPs/issues/223
181  */
182 contract TokenReceiver {
183     function onTokenTransfer(address _from, uint256 _value, bytes _data) public;
184 }
185 
186 /**
187  * @dev Helps to receive ERC223-complaint tokens. ERC223 Token contract should notify receiver.
188  */
189 contract ERC223ReceiveAdapter is TokenReceiver, ReceiveAdapter {
190     function tokenFallback(address _from, uint256 _value, bytes _data) public {
191         onReceive(msg.sender, _from, _value, _data);
192     }
193 
194     function onTokenTransfer(address _from, uint256 _value, bytes _data) public {
195         onReceive(msg.sender, _from, _value, _data);
196     }
197 }
198 
199 contract EtherReceiver {
200 	function receiveWithData(bytes _data) payable public;
201 }
202 
203 contract EtherReceiveAdapter is EtherReceiver, ReceiveAdapter {
204     function () payable public {
205         receiveWithData("");
206     }
207 
208     function receiveWithData(bytes _data) payable public {
209         onReceive(address(0), msg.sender, msg.value, _data);
210     }
211 }
212 
213 /**
214  * @dev This ReceiveAdapter supports all possible tokens
215  */
216 contract CompatReceiveAdapter is ERC20ReceiveAdapter, ERC223ReceiveAdapter, EtherReceiveAdapter {
217 
218 }
219 
220 contract AbstractSale is Sale, CompatReceiveAdapter, Ownable {
221     using SafeMath for uint256;
222 
223     event Withdraw(address token, address to, uint256 value);
224     event Burn(address token, uint256 value, bytes data);
225 
226     function onReceive(address _token, address _from, uint256 _value, bytes _data) internal {
227         uint256 sold = getSold(_token, _value);
228         require(sold > 0);
229         uint256 bonus = getBonus(sold);
230         address buyer;
231         if (_data.length == 20) {
232             buyer = address(toBytes20(_data, 0));
233         } else {
234             require(_data.length == 0);
235             buyer = _from;
236         }
237         checkPurchaseValid(buyer, sold, bonus);
238         doPurchase(buyer, sold, bonus);
239         Purchase(buyer, _token, _value, sold, bonus);
240         onPurchase(buyer, _token, _value, sold, bonus);
241     }
242 
243     function getSold(address _token, uint256 _value) constant public returns (uint256) {
244         uint256 rate = getRate(_token);
245         require(rate > 0);
246         return _value.mul(rate).div(10**18);
247     }
248 
249     function getBonus(uint256 sold) constant public returns (uint256);
250 
251     function getRate(address _token) constant public returns (uint256);
252 
253     function doPurchase(address buyer, uint256 sold, uint256 bonus) internal;
254 
255     function checkPurchaseValid(address /*buyer*/, uint256 /*sold*/, uint256 /*bonus*/) internal {
256 
257     }
258 
259     function onPurchase(address /*buyer*/, address /*token*/, uint256 /*value*/, uint256 /*sold*/, uint256 /*bonus*/) internal {
260 
261     }
262 
263     function toBytes20(bytes b, uint256 _start) pure internal returns (bytes20 result) {
264         require(_start + 20 <= b.length);
265         assembly {
266             let from := add(_start, add(b, 0x20))
267             result := mload(from)
268         }
269     }
270 
271     function withdraw(address _token, address _to, uint256 _value) onlyOwner public {
272         require(_to != address(0));
273         verifyCanWithdraw(_token, _to, _value);
274         if (_token == address(0)) {
275             _to.transfer(_value);
276         } else {
277             Token(_token).transfer(_to, _value);
278         }
279         Withdraw(_token, _to, _value);
280     }
281 
282     function verifyCanWithdraw(address token, address to, uint256 amount) internal;
283 
284     function burnWithData(address _token, uint256 _value, bytes _data) onlyOwner public {
285         ExternalToken(_token).burn(_value, _data);
286         Burn(_token, _value, _data);
287     }
288 }
289 
290 /**
291  * @title This sale mints token when user sends accepted payments
292  */
293 contract MintingSale is AbstractSale {
294     MintableToken public token;
295 
296     function MintingSale(address _token) public {
297         token = MintableToken(_token);
298     }
299 
300     function doPurchase(address buyer, uint256 sold, uint256 bonus) internal {
301         token.mint(buyer, sold.add(bonus));
302     }
303 
304     function verifyCanWithdraw(address, address, uint256) internal {
305 
306     }
307 }
308 
309 contract CappedSale is AbstractSale {
310     uint256 public cap;
311     uint256 public initialCap;
312 
313     function CappedSale(uint256 _cap) public {
314         cap = _cap;
315         initialCap = _cap;
316     }
317 
318     function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
319         super.checkPurchaseValid(buyer, sold, bonus);
320         require(cap >= sold);
321     }
322 
323     function onPurchase(address buyer, address token, uint256 value, uint256 sold, uint256 bonus) internal {
324         super.onPurchase(buyer, token, value, sold, bonus);
325         cap = cap.sub(sold);
326     }
327 }
328 
329 contract Eticket4Sale is MintingSale, OwnableImpl, CappedSale {
330     address public btcToken;
331 
332     uint256 public start;
333     uint256 public end;
334 
335     uint256 public btcEthRate = 10 * 10**10;
336     uint256 public constant ethEt4Rate = 1000 * 10**18;
337 
338     function Eticket4Sale(address _mintableToken, address _btcToken, uint256 _start, uint256 _end, uint256 _cap) MintingSale(_mintableToken) CappedSale(_cap) {
339         btcToken = _btcToken;
340         start = _start;
341         end = _end;
342         RateAdd(address(0));
343         RateAdd(_btcToken);
344     }
345 
346     function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
347         super.checkPurchaseValid(buyer, sold, bonus);
348         require(now > start && now < end);
349     }
350 
351     function getRate(address _token) constant public returns (uint256) {
352         if (_token == btcToken) {
353             return btcEthRate * ethEt4Rate;
354         } else if (_token == address(0)) {
355             return ethEt4Rate;
356         } else {
357             return 0;
358         }
359     }
360 
361     event BtcEthRateChange(uint256 btcEthRate);
362 
363     function setBtcEthRate(uint256 _btcEthRate) onlyOwner public {
364         btcEthRate = _btcEthRate;
365         BtcEthRateChange(_btcEthRate);
366     }
367 
368     function withdrawEth(address _to, uint256 _value) onlyOwner public {
369         withdraw(address(0), _to, _value);
370     }
371 
372     function withdrawBtc(bytes _to, uint256 _value) onlyOwner public {
373         burnWithData(btcToken, _value, _to);
374     }
375 
376     function transferTokenOwnership(address newOwner) onlyOwner public {
377         OwnableImpl(token).transferOwnership(newOwner);
378     }
379 
380     function transferWithBonus(address beneficiary, uint256 amount) onlyOwner public {
381         uint256 bonus = getBonus(amount);
382         doPurchase(beneficiary, amount, bonus);
383         Purchase(beneficiary, address(1), 0, amount, bonus);
384         onPurchase(beneficiary, address(1), 0, amount, bonus);
385     }
386 
387     function transfer(address beneficiary, uint256 amount) onlyOwner public {
388         doPurchase(beneficiary, amount, 0);
389         Purchase(beneficiary, address(1), 0, amount, 0);
390         onPurchase(beneficiary, address(1), 0, amount, 0);
391     }
392 }
393 
394 contract PreSale is Eticket4Sale {
395 	function PreSale(address _mintableToken, address _btcToken, uint256 _start, uint256 _end, uint256 _cap) Eticket4Sale(_mintableToken, _btcToken, _start, _end, _cap) {
396 
397 	}
398 
399 	function getBonus(uint256 sold) constant public returns (uint256) {
400 		uint256 diffDays = (now - start) / 86400;
401 		if (diffDays < 2) {
402 			return sold.mul(40).div(100);
403 		} else {
404 			return getTimeBonus(sold, diffDays) + getAmountBonus(sold);
405 		}
406 	}
407 
408 	function getTimeBonus(uint256 sold, uint256 diffDays) internal returns (uint256) {
409 		uint256 interval = (diffDays - 2) / 5;
410 		if (interval == 0) {
411 			return sold.mul(15).div(100);
412 		} else if (interval == 1) {
413 			return sold.mul(12).div(100);
414 		} else if (interval == 2 || interval == 3) {
415 			return sold.mul(10).div(100);
416 		} else {
417 			return sold.mul(8).div(100);
418 		}
419 	}
420 
421 	function getAmountBonus(uint256 sold) internal returns (uint256) {
422 		if (sold > 20000 * 10**18) {
423 			return sold.mul(30).div(100);
424 		} else if (sold > 15000 * 10**18) {
425 			return sold.mul(25).div(100);
426 		} else if (sold > 10000 * 10**18) {
427 			return sold.mul(20).div(100);
428 		} else if (sold > 5000 * 10**18) {
429 			return sold.mul(15).div(100);
430 		} else if (sold > 1000 * 10**18) {
431 			return sold.mul(10).div(100);
432 		} else {
433 			return 0;
434 		}
435 	}
436 }