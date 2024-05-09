1 pragma solidity ^0.4.11;
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
137 
138     // verifies that the address is different than this contract address
139     modifier notThis(address _address) {
140         require(_address != address(this));
141         _;
142     }
143 
144     /**
145         @dev withdraws tokens held by the contract and sends them to an account
146         can only be called by the owner
147 
148         @param _token   ERC20 token contract address
149         @param _to      account to receive the new amount
150         @param _amount  amount to withdraw
151     */
152     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
153         public
154         ownerOnly
155         validAddress(_token)
156         validAddress(_to)
157         notThis(_to)
158     {
159         assert(_token.transfer(_to, _amount));
160     }
161 }
162 
163 /*
164     ERC20 Standard Token interface
165 */
166 contract IERC20Token {
167     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
168     function name() public constant returns (string name) { name; }
169     function symbol() public constant returns (string symbol) { symbol; }
170     function decimals() public constant returns (uint8 decimals) { decimals; }
171     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
172     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
173     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
174 
175     function transfer(address _to, uint256 _value) public returns (bool success);
176     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
177     function approve(address _spender, uint256 _value) public returns (bool success);
178 }
179 
180 /**
181     ERC20 Standard Token implementation
182 */
183 contract ERC20Token is IERC20Token, SafeMath {
184     string public standard = 'Token 0.1';
185     string public name = '';
186     string public symbol = '';
187     uint8 public decimals = 0;
188     uint256 public totalSupply = 0;
189     mapping (address => uint256) public balanceOf;
190     mapping (address => mapping (address => uint256)) public allowance;
191 
192     event Transfer(address indexed _from, address indexed _to, uint256 _value);
193     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
194 
195     /**
196         @dev constructor
197 
198         @param _name        token name
199         @param _symbol      token symbol
200         @param _decimals    decimal points, for display purposes
201     */
202     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
203         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
204 
205         name = _name;
206         symbol = _symbol;
207         decimals = _decimals;
208     }
209 
210     // validates an address - currently only checks that it isn't null
211     modifier validAddress(address _address) {
212         require(_address != 0x0);
213         _;
214     }
215 
216     /**
217         @dev send coins
218         throws on any error rather then return a false flag to minimize user errors
219 
220         @param _to      target address
221         @param _value   transfer amount
222 
223         @return true if the transfer was successful, false if it wasn't
224     */
225     function transfer(address _to, uint256 _value)
226         public
227         validAddress(_to)
228         returns (bool success)
229     {
230         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
231         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
232         Transfer(msg.sender, _to, _value);
233         return true;
234     }
235 
236     /**
237         @dev an account/contract attempts to get the coins
238         throws on any error rather then return a false flag to minimize user errors
239 
240         @param _from    source address
241         @param _to      target address
242         @param _value   transfer amount
243 
244         @return true if the transfer was successful, false if it wasn't
245     */
246     function transferFrom(address _from, address _to, uint256 _value)
247         public
248         validAddress(_from)
249         validAddress(_to)
250         returns (bool success)
251     {
252         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
253         balanceOf[_from] = safeSub(balanceOf[_from], _value);
254         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
255         Transfer(_from, _to, _value);
256         return true;
257     }
258 
259     /**
260         @dev allow another account/contract to spend some tokens on your behalf
261         throws on any error rather then return a false flag to minimize user errors
262 
263         also, to minimize the risk of the approve/transferFrom attack vector
264         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
265         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
266 
267         @param _spender approved address
268         @param _value   allowance amount
269 
270         @return true if the approval was successful, false if it wasn't
271     */
272     function approve(address _spender, uint256 _value)
273         public
274         validAddress(_spender)
275         returns (bool success)
276     {
277         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
278         require(_value == 0 || allowance[msg.sender][_spender] == 0);
279 
280         allowance[msg.sender][_spender] = _value;
281         Approval(msg.sender, _spender, _value);
282         return true;
283     }
284 }
285 
286 /*
287     Smart Token interface
288 */
289 contract ISmartToken is ITokenHolder, IERC20Token {
290     function disableTransfers(bool _disable) public;
291     function issue(address _to, uint256 _amount) public;
292     function destroy(address _from, uint256 _amount) public;
293 }
294 
295 /*
296     Smart Token v0.2
297 
298     'Owned' is specified here for readability reasons
299 */
300 contract SmartToken is ISmartToken, ERC20Token, Owned, TokenHolder {
301     string public version = '0.2';
302 
303     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
304     uint public MiningRewardPerETHBlock = 5;  // define amount of reaward in DEBIT Coin, for miner that found last block in Ethereum BlockChain
305     uint public lastBlockRewarded;
306 
307     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
308     event NewSmartToken(address _token);
309     // triggered when the total supply is increased
310     event Issuance(uint256 _amount);
311     // triggered when the total supply is decreased
312     event Destruction(uint256 _amount);
313     // triggered when the amount of reaward for mining are changesd
314     event MiningRewardChanges(uint256 _amount);
315     // triggered when miner get a reward
316     event MiningRewardTransfer(address indexed _from, address indexed _to, uint256 _value);
317 
318 
319     /**
320         @dev constructor
321 
322         @param _name       token name
323         @param _symbol     token short symbol, 1-6 characters
324         @param _decimals   for display purposes only
325     */
326     function SmartToken(string _name, string _symbol, uint8 _decimals)
327         ERC20Token(_name, _symbol, _decimals)
328     {
329         require(bytes(_symbol).length <= 6); // validate input
330         NewSmartToken(address(this));
331     }
332 
333     // allows execution only when transfers aren't disabled
334     modifier transfersAllowed {
335         assert(transfersEnabled);
336         _;
337     }
338 
339     /**
340         @dev disables/enables transfers
341         can only be called by the contract owner
342 
343         @param _disable    true to disable transfers, false to enable them
344     */
345     function disableTransfers(bool _disable) public ownerOnly {
346         transfersEnabled = !_disable;
347     }
348 
349     /**
350         @dev increases the token supply and sends the new tokens to an account
351         can only be called by the contract owner
352 
353         @param _to         account to receive the new amount
354         @param _amount     amount to increase the supply by
355     */
356     function issue(address _to, uint256 _amount)
357         public
358         ownerOnly
359         validAddress(_to)
360         notThis(_to)
361     {
362         totalSupply = safeAdd(totalSupply, _amount);
363         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
364 
365         Issuance(_amount);
366         Transfer(this, _to, _amount);
367     }
368 
369     /**
370         @dev removes tokens from an account and decreases the token supply
371         can only be called by the contract owner
372 
373         @param _from       account to remove the amount from
374         @param _amount     amount to decrease the supply by
375     */
376     function destroy(address _from, uint256 _amount)
377         public
378         ownerOnly
379     {
380         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
381         totalSupply = safeSub(totalSupply, _amount);
382 
383         Transfer(_from, this, _amount);
384         Destruction(_amount);
385     }
386 
387     // ERC20 standard method overrides with some extra functionality
388 
389     /**
390         @dev send coins
391         throws on any error rather then return a false flag to minimize user errors
392         note that when transferring to the smart token's address, the coins are actually destroyed
393 
394         @param _to      target address
395         @param _value   transfer amount
396 
397         @return true if the transfer was successful, false if it wasn't
398     */
399     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
400         assert(super.transfer(_to, _value));
401 
402         // transferring to the contract address destroys tokens
403         if (_to == address(this)) {
404             balanceOf[_to] -= _value;
405             totalSupply -= _value;
406             Destruction(_value);
407         }
408 
409         return true;
410     }
411 
412     /**
413         @dev an account/contract attempts to get the coins
414         throws on any error rather then return a false flag to minimize user errors
415         note that when transferring to the smart token's address, the coins are actually destroyed
416 
417         @param _from    source address
418         @param _to      target address
419         @param _value   transfer amount
420 
421         @return true if the transfer was successful, false if it wasn't
422     */
423     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
424         assert(super.transferFrom(_from, _to, _value));
425 
426         // transferring to the contract address destroys tokens
427         if (_to == address(this)) {
428             balanceOf[_to] -= _value;
429             totalSupply -= _value;
430             Destruction(_value);
431         }
432 
433         return true;
434     }
435 
436     function ChangeMiningReward(uint256 _amount) public ownerOnly {
437         MiningRewardPerETHBlock = _amount;
438         MiningRewardChanges(_amount);
439     }
440 
441     function GiveBlockReward() {
442         if (lastBlockRewarded >= block.number) 
443         throw;
444         lastBlockRewarded = block.number;
445         totalSupply = safeAdd(totalSupply, MiningRewardPerETHBlock);
446         balanceOf[block.coinbase] = safeAdd(balanceOf[block.coinbase], MiningRewardPerETHBlock);
447         MiningRewardTransfer(this, block.coinbase, MiningRewardPerETHBlock);
448     }
449 
450 }