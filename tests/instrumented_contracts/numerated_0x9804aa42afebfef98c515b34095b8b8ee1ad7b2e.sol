1 pragma solidity ^0.4.16;
2 
3 /*
4     Owned contract interface
5 */
6 contract IOwned {
7     // this function isn't abstract since the compiler emits automatically generated getter functions as external
8     function owner() public constant returns (address owner) { owner; }
9 
10     function transferOwnership(address _newOwner) public;
11     function acceptOwnership() public;
12 }
13 
14 /*
15     ERC20 Standard Token interface
16 */
17 contract IERC20Token {
18     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
19     function name() public constant returns (string name) { name; }
20     function symbol() public constant returns (string symbol) { symbol; }
21     function decimals() public constant returns (uint8 decimals) { decimals; }
22     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
23     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
24     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
25 
26     function transfer(address _to, uint256 _value) public returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28     function approve(address _spender, uint256 _value) public returns (bool success);
29 }
30 
31 /*
32     Token Holder interface
33 */
34 contract ITokenHolder is IOwned {
35     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
36 }
37 
38 /*
39     Smart Token interface
40 */
41 contract ISmartToken is ITokenHolder, IERC20Token {
42     function disableTransfers(bool _disable) public;
43     function issue(address _to, uint256 _amount) public;
44     function destroy(address _from, uint256 _amount) public;
45 }
46 
47 /*
48     Overflow protected math functions
49 */
50 contract SafeMath {
51     /**
52         constructor
53     */
54     function SafeMath() {
55     }
56 
57     /**
58         @dev returns the sum of _x and _y, asserts if the calculation overflows
59 
60         @param _x   value 1
61         @param _y   value 2
62 
63         @return sum
64     */
65     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
66         uint256 z = _x + _y;
67         assert(z >= _x);
68         return z;
69     }
70 
71     /**
72         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
73 
74         @param _x   minuend
75         @param _y   subtrahend
76 
77         @return difference
78     */
79     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
80         assert(_x >= _y);
81         return _x - _y;
82     }
83 
84     /**
85         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
86 
87         @param _x   factor 1
88         @param _y   factor 2
89 
90         @return product
91     */
92     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
93         uint256 z = _x * _y;
94         assert(_x == 0 || z / _x == _y);
95         return z;
96     }
97 }
98 
99 /**
100     ERC20 Standard Token implementation
101 */
102 contract ERC20Token is IERC20Token, SafeMath {
103     string public standard = 'Token 0.1';
104     string public name = '';
105     string public symbol = '';
106     uint8 public decimals = 0;
107     uint256 public totalSupply = 0;
108     uint256 public maxIssuingSupply = 100000000*10**18;
109     mapping (address => uint256) public balanceOf;
110     mapping (address => mapping (address => uint256)) public allowance;
111 
112     event Transfer(address indexed _from, address indexed _to, uint256 _value);
113     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
114 
115     /**
116         @dev constructor
117 
118         @param _name        token name
119         @param _symbol      token symbol
120         @param _decimals    decimal points, for display purposes
121     */
122     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
123         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
124 
125         name = _name;
126         symbol = _symbol;
127         decimals = _decimals;
128     }
129 
130     // validates an address - currently only checks that it isn't null
131     modifier validAddress(address _address) {
132         require(_address != 0x0);
133         _;
134     }
135 
136     /**
137         @dev send coins
138         throws on any error rather then return a false flag to minimize user errors
139 
140         @param _to      target address
141         @param _value   transfer amount
142 
143         @return true if the transfer was successful, false if it wasn't
144     */
145     function transfer(address _to, uint256 _value)
146         public
147         validAddress(_to)
148         returns (bool success)
149     {
150         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
151         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
152         Transfer(msg.sender, _to, _value);
153         return true;
154     }
155 
156     /**
157         @dev an account/contract attempts to get the coins
158         throws on any error rather then return a false flag to minimize user errors
159 
160         @param _from    source address
161         @param _to      target address
162         @param _value   transfer amount
163 
164         @return true if the transfer was successful, false if it wasn't
165     */
166     function transferFrom(address _from, address _to, uint256 _value)
167         public
168         validAddress(_from)
169         validAddress(_to)
170         returns (bool success)
171     {
172         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
173         balanceOf[_from] = safeSub(balanceOf[_from], _value);
174         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
175         Transfer(_from, _to, _value);
176         return true;
177     }
178 
179     /**
180         @dev allow another account/contract to spend some tokens on your behalf
181         throws on any error rather then return a false flag to minimize user errors
182 
183         also, to minimize the risk of the approve/transferFrom attack vector
184         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
185         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
186 
187         @param _spender approved address
188         @param _value   allowance amount
189 
190         @return true if the approval was successful, false if it wasn't
191     */
192     function approve(address _spender, uint256 _value)
193         public
194         validAddress(_spender)
195         returns (bool success)
196     {
197         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
198         require(_value == 0 || allowance[msg.sender][_spender] == 0);
199 
200         allowance[msg.sender][_spender] = _value;
201         Approval(msg.sender, _spender, _value);
202         return true;
203     }
204 }
205 
206 /*
207     Provides support and utilities for contract ownership
208 */
209 contract Owned is IOwned {
210     address public owner;
211     address public newOwner;
212 
213     event OwnerUpdate(address _prevOwner, address _newOwner);
214 
215     /**
216         @dev constructor
217     */
218     function Owned() {
219         owner = msg.sender;
220     }
221 
222     // allows execution by the owner only
223     modifier ownerOnly {
224         assert(msg.sender == owner);
225         _;
226     }
227 
228     /**
229         @dev allows transferring the contract ownership
230         the new owner still need to accept the transfer
231         can only be called by the contract owner
232 
233         @param _newOwner    new contract owner
234     */
235     function transferOwnership(address _newOwner) public ownerOnly {
236         require(_newOwner != owner);
237         newOwner = _newOwner;
238     }
239 
240     /**
241         @dev used by a new owner to accept an ownership transfer
242     */
243     function acceptOwnership() public {
244         require(msg.sender == newOwner);
245         OwnerUpdate(owner, newOwner);
246         owner = newOwner;
247         newOwner = 0x0;
248     }
249 }
250 
251 /*
252     We consider every contract to be a 'token holder' since it's currently not possible
253     for a contract to deny receiving tokens.
254 
255     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
256     the owner to send tokens that were sent to the contract by mistake back to their sender.
257 */
258 contract TokenHolder is ITokenHolder, Owned {
259     /**
260         @dev constructor
261     */
262     function TokenHolder() {
263     }
264 
265     // validates an address - currently only checks that it isn't null
266     modifier validAddress(address _address) {
267         require(_address != 0x0);
268         _;
269     }
270 
271     // verifies that the address is different than this contract address
272     modifier notThis(address _address) {
273         require(_address != address(this));
274         _;
275     }
276 
277     /**
278         @dev withdraws tokens held by the contract and sends them to an account
279         can only be called by the owner
280 
281         @param _token   ERC20 token contract address
282         @param _to      account to receive the new amount
283         @param _amount  amount to withdraw
284     */
285     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
286         public
287         ownerOnly
288         validAddress(_token)
289         validAddress(_to)
290         notThis(_to)
291     {
292         assert(_token.transfer(_to, _amount));
293     }
294 }
295 
296 /*
297     Smart Token v0.2
298 
299     'Owned' is specified here for readability reasons
300 */
301 contract SmartToken is ISmartToken, ERC20Token, Owned, TokenHolder {
302     string public version = '0.2';
303 
304     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
305 
306     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
307     event NewSmartToken(address _token);
308     // triggered when the total supply is increased
309     event Issuance(uint256 _amount);
310     // triggered when the total supply is decreased
311     event Destruction(uint256 _amount);
312 
313     /**
314         @dev constructor
315 
316         @param _name       token name
317         @param _symbol     token short symbol, 1-6 characters
318         @param _decimals   for display purposes only
319     */
320     function SmartToken(string _name, string _symbol, uint8 _decimals)
321         ERC20Token(_name, _symbol, _decimals)
322     {
323         require(bytes(_symbol).length <= 6); // validate input
324         NewSmartToken(address(this));
325     }
326 
327     // allows execution only when transfers aren't disabled
328     modifier transfersAllowed {
329         assert(transfersEnabled);
330         _;
331     }
332 
333     /**
334         @dev disables/enables transfers
335         can only be called by the contract owner
336 
337         @param _disable    true to disable transfers, false to enable them
338     */
339     function disableTransfers(bool _disable) public ownerOnly {
340         transfersEnabled = !_disable;
341     }
342 
343     /**
344         @dev increases the token supply and sends the new tokens to an account
345         can only be called by the contract owner
346 
347         @param _to         account to receive the new amount
348         @param _amount     amount to increase the supply by
349     */
350     function issue(address _to, uint256 _amount)
351         public
352         ownerOnly
353         validAddress(_to)
354         notThis(_to)
355     {
356         totalSupply = safeAdd(totalSupply, _amount);
357         //Token cant be generated max of 100 Milions
358         if (totalSupply > maxIssuingSupply) revert();
359         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
360 
361         Issuance(_amount);
362         Transfer(this, _to, _amount);
363     }
364 
365     /**
366         @dev removes tokens from an account and decreases the token supply
367         can only be called by the contract owner
368 
369         @param _from       account to remove the amount from
370         @param _amount     amount to decrease the supply by
371     */
372     function destroy(address _from, uint256 _amount)
373         public
374         ownerOnly
375     {
376         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
377         totalSupply = safeSub(totalSupply, _amount);
378 
379         Transfer(_from, this, _amount);
380         Destruction(_amount);
381     }
382 
383     // ERC20 standard method overrides with some extra functionality
384 
385     /**
386         @dev send coins
387         throws on any error rather then return a false flag to minimize user errors
388         note that when transferring to the smart token's address, the coins are actually destroyed
389 
390         @param _to      target address
391         @param _value   transfer amount
392 
393         @return true if the transfer was successful, false if it wasn't
394     */
395     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
396         assert(super.transfer(_to, _value));
397 
398         // transferring to the contract address destroys tokens
399         if (_to == address(this)) {
400             balanceOf[_to] -= _value;
401             totalSupply -= _value;
402             Destruction(_value);
403         }
404 
405         return true;
406     }
407 
408     /**
409         @dev an account/contract attempts to get the coins
410         throws on any error rather then return a false flag to minimize user errors
411         note that when transferring to the smart token's address, the coins are actually destroyed
412 
413         @param _from    source address
414         @param _to      target address
415         @param _value   transfer amount
416 
417         @return true if the transfer was successful, false if it wasn't
418     */
419     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
420         assert(super.transferFrom(_from, _to, _value));
421 
422         // transferring to the contract address destroys tokens
423         if (_to == address(this)) {
424             balanceOf[_to] -= _value;
425             totalSupply -= _value;
426             Destruction(_value);
427         }
428 
429         return true;
430     }
431 }
432 
433 /// @title Ownable
434 /// @dev The Ownable contract has an owner address, and provides basic authorization control functions, this simplifies
435 /// & the implementation of "user permissions".
436 contract Ownable {
437     address public owner;
438     address public newOwnerCandidate;
439 
440     event OwnershipRequested(address indexed _by, address indexed _to);
441     event OwnershipTransferred(address indexed _from, address indexed _to);
442 
443     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
444     function Ownable() {
445         owner = msg.sender;
446     }
447 
448     /// @dev Throws if called by any account other than the owner.
449     modifier onlyOwner() {
450         if (msg.sender != owner) {
451             throw;
452         }
453 
454         _;
455     }
456 
457     /// @dev Proposes to transfer control of the contract to a newOwnerCandidate.
458     /// @param _newOwnerCandidate address The address to transfer ownership to.
459     function transferOwnership(address _newOwnerCandidate) onlyOwner {
460         require(_newOwnerCandidate != address(0));
461 
462         newOwnerCandidate = _newOwnerCandidate;
463 
464         OwnershipRequested(msg.sender, newOwnerCandidate);
465     }
466 
467     /// @dev Accept ownership transfer. This me thod needs to be called by the perviously proposed owner.
468     function acceptOwnership() {
469         if (msg.sender == newOwnerCandidate) {
470             owner = newOwnerCandidate;
471             newOwnerCandidate = address(0);
472 
473             OwnershipTransferred(owner, newOwnerCandidate);
474         }
475     }
476 }
477 
478 /// @title Epm Smart Token
479 contract EpmSmartToken is SmartToken {
480     function EpmSmartToken() SmartToken('Epocum', 'EPM', 18) {
481         disableTransfers(false);
482     }
483 }