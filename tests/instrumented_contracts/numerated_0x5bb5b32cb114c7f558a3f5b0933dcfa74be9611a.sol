1 pragma solidity ^0.4.13;
2 
3 contract Utils {
4     /**
5         constructor
6     */
7     function Utils() {
8     }
9 
10     // verifies that an amount is greater than zero
11     modifier greaterThanZero(uint256 _amount) {
12         require(_amount > 0);
13         _;
14     }
15 
16     // validates an address - currently only checks that it isn't null
17     modifier validAddress(address _address) {
18         require(_address != 0x0);
19         _;
20     }
21 
22     // verifies that the address is different than this contract address
23     modifier notThis(address _address) {
24         require(_address != address(this));
25         _;
26     }
27 
28     // Overflow protected math functions
29 
30     /**
31         @dev returns the sum of _x and _y, asserts if the calculation overflows
32 
33         @param _x   value 1
34         @param _y   value 2
35 
36         @return sum
37     */
38     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
39         uint256 z = _x + _y;
40         assert(z >= _x);
41         return z;
42     }
43 
44     /**
45         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
46 
47         @param _x   minuend
48         @param _y   subtrahend
49 
50         @return difference
51     */
52     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
53         assert(_x >= _y);
54         return _x - _y;
55     }
56 
57     /**
58         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
59 
60         @param _x   factor 1
61         @param _y   factor 2
62 
63         @return product
64     */
65     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
66         uint256 z = _x * _y;
67         assert(_x == 0 || z / _x == _y);
68         return z;
69     }
70 }
71 
72 contract IERC20Token {
73     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
74     function name() public constant returns (string name) { name; }
75     function symbol() public constant returns (string symbol) { symbol; }
76     function decimals() public constant returns (uint8 decimals) { decimals; }
77     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
78     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
79     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
80 
81     function transfer(address _to, uint256 _value) public returns (bool success);
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
83     function approve(address _spender, uint256 _value) public returns (bool success);
84 }
85 
86 contract ERC20Token is IERC20Token, Utils {
87     string public standard = 'Token 0.1';
88     string public name = '';
89     string public symbol = '';
90     uint8 public decimals = 0;
91     uint256 public totalSupply = 0;
92     mapping (address => uint256) public balanceOf;
93     mapping (address => mapping (address => uint256)) public allowance;
94 
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 
98     /**
99         @dev constructor
100 
101         @param _name        token name
102         @param _symbol      token symbol
103         @param _decimals    decimal points, for display purposes
104     */
105     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
106         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
107 
108         name = _name;
109         symbol = _symbol;
110         decimals = _decimals;
111     }
112 
113     /**
114         @dev send coins
115         throws on any error rather then return a false flag to minimize user errors
116 
117         @param _to      target address
118         @param _value   transfer amount
119 
120         @return true if the transfer was successful, false if it wasn't
121     */
122     function transfer(address _to, uint256 _value)
123         public
124         validAddress(_to)
125         returns (bool success)
126     {
127         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
128         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
129         Transfer(msg.sender, _to, _value);
130         return true;
131     }
132 
133     /**
134         @dev an account/contract attempts to get the coins
135         throws on any error rather then return a false flag to minimize user errors
136 
137         @param _from    source address
138         @param _to      target address
139         @param _value   transfer amount
140 
141         @return true if the transfer was successful, false if it wasn't
142     */
143     function transferFrom(address _from, address _to, uint256 _value)
144         public
145         validAddress(_from)
146         validAddress(_to)
147         returns (bool success)
148     {
149         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
150         balanceOf[_from] = safeSub(balanceOf[_from], _value);
151         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
152         Transfer(_from, _to, _value);
153         return true;
154     }
155 
156     /**
157         @dev allow another account/contract to spend some tokens on your behalf
158         throws on any error rather then return a false flag to minimize user errors
159 
160         also, to minimize the risk of the approve/transferFrom attack vector
161         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
162         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
163 
164         @param _spender approved address
165         @param _value   allowance amount
166 
167         @return true if the approval was successful, false if it wasn't
168     */
169     function approve(address _spender, uint256 _value)
170         public
171         validAddress(_spender)
172         returns (bool success)
173     {
174         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
175         require(_value == 0 || allowance[msg.sender][_spender] == 0);
176 
177         allowance[msg.sender][_spender] = _value;
178         Approval(msg.sender, _spender, _value);
179         return true;
180     }
181 }
182 
183 contract IOwned {
184     // this function isn't abstract since the compiler emits automatically generated getter functions as external
185     function owner() public constant returns (address owner) { owner; }
186 
187     function transferOwnership(address _newOwner) public;
188     function acceptOwnership() public;
189 }
190 
191 contract Owned is IOwned {
192     address public owner;
193     address public newOwner;
194 
195     event OwnerUpdate(address _prevOwner, address _newOwner);
196 
197     /**
198         @dev constructor
199     */
200     function Owned() {
201         owner = msg.sender;
202     }
203 
204     // allows execution by the owner only
205     modifier ownerOnly {
206         assert(msg.sender == owner);
207         _;
208     }
209 
210     /**
211         @dev allows transferring the contract ownership
212         the new owner still needs to accept the transfer
213         can only be called by the contract owner
214 
215         @param _newOwner    new contract owner
216     */
217     function transferOwnership(address _newOwner) public ownerOnly {
218         require(_newOwner != owner);
219         newOwner = _newOwner;
220     }
221 
222     /**
223         @dev used by a new owner to accept an ownership transfer
224     */
225     function acceptOwnership() public {
226         require(msg.sender == newOwner);
227         OwnerUpdate(owner, newOwner);
228         owner = newOwner;
229         newOwner = 0x0;
230     }
231 }
232 
233 contract ITokenHolder is IOwned {
234     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
235 }
236 
237 contract TokenHolder is ITokenHolder, Owned, Utils {
238     /**
239         @dev constructor
240     */
241     function TokenHolder() {
242     }
243 
244     /**
245         @dev withdraws tokens held by the contract and sends them to an account
246         can only be called by the owner
247 
248         @param _token   ERC20 token contract address
249         @param _to      account to receive the new amount
250         @param _amount  amount to withdraw
251     */
252     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
253         public
254         ownerOnly
255         validAddress(_token)
256         validAddress(_to)
257         notThis(_to)
258     {
259         assert(_token.transfer(_to, _amount));
260     }
261 }
262 
263 contract SmartTokenController is TokenHolder {
264     ISmartToken public token;   // smart token
265 
266     /**
267         @dev constructor
268     */
269     function SmartTokenController(ISmartToken _token)
270         validAddress(_token)
271     {
272         token = _token;
273     }
274 
275     // ensures that the controller is the token's owner
276     modifier active() {
277         assert(token.owner() == address(this));
278         _;
279     }
280 
281     // ensures that the controller is not the token's owner
282     modifier inactive() {
283         assert(token.owner() != address(this));
284         _;
285     }
286 
287     /**
288         @dev allows transferring the token ownership
289         the new owner still need to accept the transfer
290         can only be called by the contract owner
291 
292         @param _newOwner    new token owner
293     */
294     function transferTokenOwnership(address _newOwner) public ownerOnly {
295         token.transferOwnership(_newOwner);
296     }
297 
298     /**
299         @dev used by a new owner to accept a token ownership transfer
300         can only be called by the contract owner
301     */
302     function acceptTokenOwnership() public ownerOnly {
303         token.acceptOwnership();
304     }
305 
306     /**
307         @dev disables/enables token transfers
308         can only be called by the contract owner
309 
310         @param _disable    true to disable transfers, false to enable them
311     */
312     function disableTokenTransfers(bool _disable) public ownerOnly {
313         token.disableTransfers(_disable);
314     }
315 
316     /**
317         @dev withdraws tokens held by the token and sends them to an account
318         can only be called by the owner
319 
320         @param _token   ERC20 token contract address
321         @param _to      account to receive the new amount
322         @param _amount  amount to withdraw
323     */
324     function withdrawFromToken(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
325         token.withdrawTokens(_token, _to, _amount);
326     }
327 }
328 
329 contract ISmartToken is ITokenHolder, IERC20Token {
330     function disableTransfers(bool _disable) public;
331     function issue(address _to, uint256 _amount) public;
332     function destroy(address _from, uint256 _amount) public;
333 }
334 
335 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
336     string public version = '0.3';
337 
338     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
339 
340     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
341     event NewSmartToken(address _token);
342     // triggered when the total supply is increased
343     event Issuance(uint256 _amount);
344     // triggered when the total supply is decreased
345     event Destruction(uint256 _amount);
346 
347     /**
348         @dev constructor
349 
350         @param _name       token name
351         @param _symbol     token short symbol, minimum 1 character
352         @param _decimals   for display purposes only
353     */
354     function SmartToken(string _name, string _symbol, uint8 _decimals)
355         ERC20Token(_name, _symbol, _decimals)
356     {
357         NewSmartToken(address(this));
358     }
359 
360     // allows execution only when transfers aren't disabled
361     modifier transfersAllowed {
362         assert(transfersEnabled);
363         _;
364     }
365 
366     /**
367         @dev disables/enables transfers
368         can only be called by the contract owner
369 
370         @param _disable    true to disable transfers, false to enable them
371     */
372     function disableTransfers(bool _disable) public ownerOnly {
373         transfersEnabled = !_disable;
374     }
375 
376     /**
377         @dev increases the token supply and sends the new tokens to an account
378         can only be called by the contract owner
379 
380         @param _to         account to receive the new amount
381         @param _amount     amount to increase the supply by
382     */
383     function issue(address _to, uint256 _amount)
384         public
385         ownerOnly
386         validAddress(_to)
387         notThis(_to)
388     {
389         totalSupply = safeAdd(totalSupply, _amount);
390         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
391 
392         Issuance(_amount);
393         Transfer(this, _to, _amount);
394     }
395 
396     /**
397         @dev removes tokens from an account and decreases the token supply
398         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
399 
400         @param _from       account to remove the amount from
401         @param _amount     amount to decrease the supply by
402     */
403     function destroy(address _from, uint256 _amount) public {
404         require(msg.sender == _from || msg.sender == owner); // validate input
405 
406         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
407         totalSupply = safeSub(totalSupply, _amount);
408 
409         Transfer(_from, this, _amount);
410         Destruction(_amount);
411     }
412 
413     // ERC20 standard method overrides with some extra functionality
414 
415     /**
416         @dev send coins
417         throws on any error rather then return a false flag to minimize user errors
418         in addition to the standard checks, the function throws if transfers are disabled
419 
420         @param _to      target address
421         @param _value   transfer amount
422 
423         @return true if the transfer was successful, false if it wasn't
424     */
425     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
426         assert(super.transfer(_to, _value));
427         return true;
428     }
429 
430     /**
431         @dev an account/contract attempts to get the coins
432         throws on any error rather then return a false flag to minimize user errors
433         in addition to the standard checks, the function throws if transfers are disabled
434 
435         @param _from    source address
436         @param _to      target address
437         @param _value   transfer amount
438 
439         @return true if the transfer was successful, false if it wasn't
440     */
441     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
442         assert(super.transferFrom(_from, _to, _value));
443         return true;
444     }
445 }
446 
447 contract KickcityAbstractCrowdsale is Owned, SmartTokenController {
448   uint256 public etherHardCap = 14706 ether; // 14706 * 850 = 12500100 ~ 12.5m USD
449   uint256 public etherCollected = 0;
450 
451   uint256 public USD_IN_ETH = 850; // We use fixed rate 1ETH = 850USD
452 
453   function setUsdEthRate(uint256 newrate) ownerOnly {
454     USD_IN_ETH = newrate;
455     oneEtherInKicks = newrate * 10;
456   }
457 
458   function usdCollected() constant public returns(uint256) {
459     return safeMul(etherCollected, USD_IN_ETH) / 1 ether;
460   }
461 
462   function setHardCap(uint256 newCap) ownerOnly {
463      etherHardCap = newCap;
464   }
465 
466   uint256 public saleStartTime;
467   uint256 public saleEndTime;
468 
469   modifier duringSale() {
470     assert(now >= saleStartTime && now < saleEndTime);
471     _;
472   }
473 
474   uint256 private maxGasPrice = 0.06 szabo; // 60 Gwei
475 
476   modifier validGasPrice() {
477     assert(tx.gasprice <= maxGasPrice);
478     _;
479   }
480 
481   address public kickcityWallet;
482 
483   function KickcityAbstractCrowdsale(uint256 start, uint256 end, KickcityToken _token, address beneficiary) SmartTokenController(_token) {
484     assert(start < end);
485     assert(beneficiary != 0x0);
486     saleStartTime = start;
487     saleEndTime = end;
488     kickcityWallet = beneficiary;
489   }
490 
491   /**
492   KICK token have 18 decimals, so we can calculate ether/kicks rate directly
493   */
494   uint256 public oneEtherInKicks = 8500;
495   uint256 public minEtherContrib = 59 finney; // 0.059 ETH ~ 50.15$
496 
497   function calcKicks(uint256 etherVal) constant public returns (uint256 kicksVal);
498 
499   // triggered on each contribution
500   event Contribution(address indexed contributor, uint256 contributed, uint256 tokensReceived);
501 
502   function processContribution() private validGasPrice duringSale {
503     uint256 leftToCollect = safeSub(etherHardCap, etherCollected);
504     uint256 contribution = msg.value > leftToCollect ? leftToCollect : msg.value;
505     uint256 change = safeSub(msg.value, contribution);
506 
507     if (contribution > 0) {
508       uint256 kicks = calcKicks(contribution);
509 
510       // transfer tokens to Kikcity wallet
511       kickcityWallet.transfer(contribution);
512 
513       // Issue tokens to contributor
514       token.issue(msg.sender, kicks);
515       etherCollected = safeAdd(etherCollected, contribution);
516       Contribution(msg.sender, contribution, kicks);
517     }
518 
519     // Give change back if it is present
520     if (change > 0) {
521       msg.sender.transfer(change);
522     }
523   }
524 
525   function () payable {
526     if (msg.value > 0) {
527       processContribution();
528     }
529   }
530 }
531 
532 contract KickcityCrowdsale is KickcityAbstractCrowdsale {
533   function KickcityCrowdsale(uint256 start, uint256 end, KickcityToken _token, address beneficiary) KickcityAbstractCrowdsale(start, end, _token, beneficiary) { }
534 
535   function calcKicks(uint256 etherVal) constant public returns (uint256 kicksVal) {
536     assert(etherVal >= minEtherContrib);
537     uint256 value = safeMul(etherVal, oneEtherInKicks);
538     if (now <= saleStartTime + 1 days) {
539       // 15% bonus in first day
540       kicksVal = safeAdd(value, safeMul(value / 100, 15)); 
541     } else if (now <= saleStartTime + 10 days) {
542       // 10% bonus in 2-10 day
543       kicksVal = safeAdd(value, value / 10); 
544     } else if (now <= saleStartTime + 20 days) {
545       // 5% bonus in 11-20 day
546       kicksVal = safeAdd(value, value / 20);
547     } else {
548       kicksVal = value;
549     }
550   }
551 }
552 
553 contract KickcityToken is SmartToken {
554     function KickcityToken() SmartToken("KickCity Token", "KCY", 18) { 
555         disableTransfers(true);
556      }
557 }