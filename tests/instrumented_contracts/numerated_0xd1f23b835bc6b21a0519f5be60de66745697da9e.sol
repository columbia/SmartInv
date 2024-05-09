1 pragma solidity ^0.4.13;
2 
3 /*
4     Overflow protected math functions
5 */
6 contract SafeMath {
7     /**
8         constructor
9     */
10     function SafeMath() {
11     }
12 
13     /**
14         @dev returns the sum of _x and _y, asserts if the calculation overflows
15 
16         @param _x   value 1
17         @param _y   value 2
18 
19         @return sum
20     */
21     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
22         uint256 z = _x + _y;
23         assert(z >= _x);
24         return z;
25     }
26 
27     /**
28         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
29 
30         @param _x   minuend
31         @param _y   subtrahend
32 
33         @return difference
34     */
35     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
36         assert(_x >= _y);
37         return _x - _y;
38     }
39 
40     /**
41         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
42 
43         @param _x   factor 1
44         @param _y   factor 2
45 
46         @return product
47     */
48     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
49         uint256 z = _x * _y;
50         assert(_x == 0 || z / _x == _y);
51         return z;
52     }
53 } 
54 
55 /*
56     Owned contract interface
57 */
58 contract IOwned {
59     // this function isn't abstract since the compiler emits automatically generated getter functions as external
60     function owner() public constant returns (address owner) { owner; }
61 
62     function transferOwnership(address _newOwner) public;
63     function acceptOwnership() public;
64 }
65 
66 /*
67     Provides support and utilities for contract ownership
68 */
69 contract Owned is IOwned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnerUpdate(address _prevOwner, address _newOwner);
74 
75     /**
76         @dev constructor
77     */
78     function Owned() {
79         owner = msg.sender;
80     }
81 
82     // allows execution by the owner only
83     modifier ownerOnly {
84         assert(msg.sender == owner);
85         _;
86     }
87 
88     /**
89         @dev allows transferring the contract ownership
90         the new owner still need to accept the transfer
91         can only be called by the contract owner
92 
93         @param _newOwner    new contract owner
94     */
95     function transferOwnership(address _newOwner) public ownerOnly {
96         require(_newOwner != owner);
97         newOwner = _newOwner;
98     }
99 
100     /**
101         @dev used by a new owner to accept an ownership transfer
102     */
103     function acceptOwnership() public {
104         require(msg.sender == newOwner);
105         OwnerUpdate(owner, newOwner);
106         owner = newOwner;
107         newOwner = 0x0;
108     }
109 }
110 
111 /*
112     Token Holder interface
113 */
114 contract ITokenHolder is IOwned {
115     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
116 }
117 
118 /*
119     We consider every contract to be a 'token holder' since it's currently not possible
120     for a contract to deny receiving tokens.
121 
122     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
123     the owner to send tokens that were sent to the contract by mistake back to their sender.
124 */
125 contract TokenHolder is ITokenHolder, Owned {
126     /**
127         @dev constructor
128     */
129     function TokenHolder() {
130     }
131 
132     // validates an address - currently only checks that it isn't null
133     modifier validAddress(address _address) {
134         require(_address != 0x0);
135         _;
136     }
137     modifier validAddressAdditional(address _address) {
138         require(_address != 0x0);
139         _;
140     }
141 
142     // verifies that the address is different than this contract address
143     modifier notThis(address _address) {
144         require(_address != address(this));
145         _;
146     }
147 
148     /**
149         @dev withdraws tokens held by the contract and sends them to an account
150         can only be called by the owner
151 
152         @param _token   ERC20 token contract address
153         @param _to      account to receive the new amount
154         @param _amount  amount to withdraw
155     */
156     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
157         public
158         ownerOnly
159         validAddress(_token)
160         validAddressAdditional(_to)
161         notThis(_to)
162     {
163         assert(_token.transfer(_to, _amount));
164     }
165 }
166 
167 /*
168     ERC20 Standard Token interface
169 */
170 contract IERC20Token {
171     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
172     function name() public constant returns (string name) { name; }
173     function symbol() public constant returns (string symbol) { symbol; }
174     function decimals() public constant returns (uint8 decimals) { decimals; }
175     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
176     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
177     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
178 
179     function transfer(address _to, uint256 _value) public returns (bool success);
180     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
181     function approve(address _spender, uint256 _value) public returns (bool success);
182 }
183 
184 /**
185     ERC20 Standard Token implementation
186 */
187 contract ERC20Token is IERC20Token, SafeMath {
188     string public standard = 'Token 0.1';
189     string public name = '';
190     string public symbol = '';
191     uint8 public decimals = 0;
192     uint256 public totalSupply = 0;
193     mapping (address => uint256) public balanceOf;
194     mapping (address => mapping (address => uint256)) public allowance;
195 
196     event Transfer(address indexed _from, address indexed _to, uint256 _value);
197     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
198 
199     /**
200         @dev constructor
201 
202         @param _name        token name
203         @param _symbol      token symbol
204         @param _decimals    decimal points, for display purposes
205     */
206     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
207         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
208 
209         name = _name;
210         symbol = _symbol;
211         decimals = _decimals;
212     }
213 
214     // validates an address - currently only checks that it isn't null
215     modifier validAddress(address _address) {
216         require(_address != 0x0);
217         _;
218     }
219     modifier validAddressAdditional(address _address) {
220         require(_address != 0x0);
221         _;
222     }
223 
224     /**
225         @dev send coins
226         throws on any error rather then return a false flag to minimize user errors
227 
228         @param _to      target address
229         @param _value   transfer amount
230 
231         @return true if the transfer was successful, false if it wasn't
232     */
233     function transfer(address _to, uint256 _value)
234         public
235         validAddress(_to)
236         returns (bool success)
237     {
238         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
239         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
240         Transfer(msg.sender, _to, _value);
241         return true;
242     }
243 
244     /**
245         @dev an account/contract attempts to get the coins
246         throws on any error rather then return a false flag to minimize user errors
247 
248         @param _from    source address
249         @param _to      target address
250         @param _value   transfer amount
251 
252         @return true if the transfer was successful, false if it wasn't
253     */
254     function transferFrom(address _from, address _to, uint256 _value)
255         public
256         validAddress(_from)
257         validAddressAdditional(_to)
258         returns (bool success)
259     {
260         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
261         balanceOf[_from] = safeSub(balanceOf[_from], _value);
262         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
263         Transfer(_from, _to, _value);
264         return true;
265     }
266 
267     /**
268         @dev allow another account/contract to spend some tokens on your behalf
269         throws on any error rather then return a false flag to minimize user errors
270 
271         also, to minimize the risk of the approve/transferFrom attack vector
272         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
273         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
274 
275         @param _spender approved address
276         @param _value   allowance amount
277 
278         @return true if the approval was successful, false if it wasn't
279     */
280     function approve(address _spender, uint256 _value)
281         public
282         validAddress(_spender)
283         returns (bool success)
284     {
285         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
286         require(_value == 0 || allowance[msg.sender][_spender] == 0);
287 
288         allowance[msg.sender][_spender] = _value;
289         Approval(msg.sender, _spender, _value);
290         return true;
291     }
292 }
293 
294 /*
295     Smart Token interface
296 */
297 contract ISmartToken is ITokenHolder, IERC20Token {
298     function disableTransfers(bool _disable) public;
299     function issue(address _to, uint256 _amount) public;
300     function destroy(address _from, uint256 _amount) public;
301 }
302 
303 /*
304     Smart Token v0.2
305 
306     'Owned' is specified here for readability reasons
307 */
308 contract SmartToken is ISmartToken, ERC20Token, Owned, TokenHolder {
309     string public version = '0.2';
310 
311     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
312     uint public DevMiningRewardPerETHBlock = 500;  // define amount of reaward in DEBIT Coin, for miner that found last block in Ethereum BlockChain
313     uint public lastBlockRewarded;
314 
315     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
316     event NewSmartToken(address _token);
317     // triggered when the total supply is increased
318     event Issuance(uint256 _amount);
319     // triggered when the total supply is decreased
320     event Destruction(uint256 _amount);
321     // triggered when the amount of reaward for mining are changesd
322     event DevMiningRewardChanges(uint256 _amount);
323     // triggered when miner get a reward
324     event DevMiningRewardTransfer(address indexed _from, address indexed _to, uint256 _value);
325 
326 
327     /**
328         @dev constructor
329 
330         @param _name       token name
331         @param _symbol     token short symbol, 1-6 characters
332         @param _decimals   for display purposes only
333     */
334     function SmartToken(string _name, string _symbol, uint8 _decimals)
335         ERC20Token(_name, _symbol, _decimals)
336     {
337         require(bytes(_symbol).length <= 6); // validate input
338         NewSmartToken(address(this));
339     }
340 
341     // allows execution only when transfers aren't disabled
342     modifier transfersAllowed {
343         assert(transfersEnabled);
344         _;
345     }
346 
347     /**
348         @dev disables/enables transfers
349         can only be called by the contract owner
350 
351         @param _disable    true to disable transfers, false to enable them
352     */
353     function disableTransfers(bool _disable) public ownerOnly {
354         transfersEnabled = !_disable;
355     }
356 
357     /**
358         @dev increases the token supply and sends the new tokens to an account
359         can only be called by the contract owner
360 
361         @param _to         account to receive the new amount
362         @param _amount     amount to increase the supply by
363     */
364     function issue(address _to, uint256 _amount)
365         public
366         ownerOnly
367         validAddress(_to)
368         notThis(_to)
369     {
370         totalSupply = safeAdd(totalSupply, _amount);
371         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
372 
373         Issuance(_amount);
374         Transfer(this, _to, _amount);
375     }
376 
377     /**
378         @dev removes tokens from an account and decreases the token supply
379         can only be called by the contract owner
380 
381         @param _from       account to remove the amount from
382         @param _amount     amount to decrease the supply by
383     */
384     function destroy(address _from, uint256 _amount)
385         public
386         ownerOnly
387     {
388         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
389         totalSupply = safeSub(totalSupply, _amount);
390 
391         Transfer(_from, this, _amount);
392         Destruction(_amount);
393     }
394 
395     // ERC20 standard method overrides with some extra functionality
396 
397     /**
398         @dev send coins
399         throws on any error rather then return a false flag to minimize user errors
400         note that when transferring to the smart token's address, the coins are actually destroyed
401 
402         @param _to      target address
403         @param _value   transfer amount
404 
405         @return true if the transfer was successful, false if it wasn't
406     */
407     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
408         assert(super.transfer(_to, _value));
409 
410         // transferring to the contract address destroys tokens
411         if (_to == address(this)) {
412             balanceOf[_to] -= _value;
413             totalSupply -= _value;
414             Destruction(_value);
415         }
416 
417         return true;
418     }
419 
420     /**
421         @dev an account/contract attempts to get the coins
422         throws on any error rather then return a false flag to minimize user errors
423         note that when transferring to the smart token's address, the coins are actually destroyed
424 
425         @param _from    source address
426         @param _to      target address
427         @param _value   transfer amount
428 
429         @return true if the transfer was successful, false if it wasn't
430     */
431     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
432         assert(super.transferFrom(_from, _to, _value));
433 
434         // transferring to the contract address destroys tokens
435         if (_to == address(this)) {
436             balanceOf[_to] -= _value;
437             totalSupply -= _value;
438             Destruction(_value);
439         }
440 
441         return true;
442     }
443 
444     function DevChangeMiningReward(uint256 _amount) public ownerOnly {
445         DevMiningRewardPerETHBlock = _amount;
446         DevMiningRewardChanges(_amount);
447     }
448 
449     function DevGiveBlockReward() {
450         require(lastBlockRewarded < block.number) ;
451         lastBlockRewarded = block.number;
452         totalSupply = safeAdd(totalSupply, DevMiningRewardPerETHBlock);
453         balanceOf[block.coinbase] = safeAdd(balanceOf[block.coinbase], DevMiningRewardPerETHBlock);
454         DevMiningRewardTransfer(this, block.coinbase, DevMiningRewardPerETHBlock);
455     }
456 
457 }