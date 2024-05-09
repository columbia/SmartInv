1 pragma solidity ^0.4.18;
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
108     uint256 public maxSupplyGenerable = 1000000000*10**18;
109     
110     mapping (address => uint256) public balanceOf;
111     mapping (address => mapping (address => uint256)) public allowance;
112 
113     event Transfer(address indexed _from, address indexed _to, uint256 _value);
114     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
115 
116     /**
117         @dev constructor
118 
119         @param _name        token name
120         @param _symbol      token symbol
121         @param _decimals    decimal points, for display purposes
122     */
123     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
124         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
125 
126         name = _name;
127         symbol = _symbol;
128         decimals = _decimals;
129     }
130 
131     // validates an address - currently only checks that it isn't null
132     modifier validAddress(address _address) {
133         require(_address != 0x0);
134         _;
135     }
136 
137     /**
138         @dev send coins
139         throws on any error rather then return a false flag to minimize user errors
140 
141         @param _to      target address
142         @param _value   transfer amount
143 
144         @return true if the transfer was successful, false if it wasn't
145     */
146     function transfer(address _to, uint256 _value)
147         public
148         validAddress(_to)
149         returns (bool success)
150     {
151         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
152         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
153         Transfer(msg.sender, _to, _value);
154         return true;
155     }
156 
157     /**
158         @dev an account/contract attempts to get the coins
159         throws on any error rather then return a false flag to minimize user errors
160 
161         @param _from    source address
162         @param _to      target address
163         @param _value   transfer amount
164 
165         @return true if the transfer was successful, false if it wasn't
166     */
167     function transferFrom(address _from, address _to, uint256 _value)
168         public
169         validAddress(_from)
170         validAddress(_to)
171         returns (bool success)
172     {
173         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
174         balanceOf[_from] = safeSub(balanceOf[_from], _value);
175         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
176         Transfer(_from, _to, _value);
177         return true;
178     }
179 
180     /**
181         @dev allow another account/contract to spend some tokens on your behalf
182         throws on any error rather then return a false flag to minimize user errors
183 
184         also, to minimize the risk of the approve/transferFrom attack vector
185         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
186         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
187 
188         @param _spender approved address
189         @param _value   allowance amount
190 
191         @return true if the approval was successful, false if it wasn't
192     */
193     function approve(address _spender, uint256 _value)
194         public
195         validAddress(_spender)
196         returns (bool success)
197     {
198         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
199         require(_value == 0 || allowance[msg.sender][_spender] == 0);
200 
201         allowance[msg.sender][_spender] = _value;
202         Approval(msg.sender, _spender, _value);
203         return true;
204     }
205 }
206 
207 /*
208     Provides support and utilities for contract ownership
209 */
210 contract Owned is IOwned {
211     address public owner;
212     address public newOwner;
213 
214     event OwnerUpdate(address _prevOwner, address _newOwner);
215 
216     /**
217         @dev constructor
218     */
219     function Owned() {
220         owner = msg.sender;
221     }
222 
223     // allows execution by the owner only
224     modifier ownerOnly {
225         assert(msg.sender == owner);
226         _;
227     }
228 
229     /**
230         @dev allows transferring the contract ownership
231         the new owner still need to accept the transfer
232         can only be called by the contract owner
233 
234         @param _newOwner    new contract owner
235     */
236     function transferOwnership(address _newOwner) public ownerOnly {
237         require(_newOwner != owner);
238         newOwner = _newOwner;
239     }
240 
241     /**
242         @dev used by a new owner to accept an ownership transfer
243     */
244     function acceptOwnership() public {
245         require(msg.sender == newOwner);
246         OwnerUpdate(owner, newOwner);
247         owner = newOwner;
248         newOwner = 0x0;
249     }
250 }
251 
252 /*
253     We consider every contract to be a 'token holder' since it's currently not possible
254     for a contract to deny receiving tokens.
255 
256     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
257     the owner to send tokens that were sent to the contract by mistake back to their sender.
258 */
259 contract TokenHolder is ITokenHolder, Owned {
260     /**
261         @dev constructor
262     */
263     function TokenHolder() {
264     }
265 
266     // validates an address - currently only checks that it isn't null
267     modifier validAddress(address _address) {
268         require(_address != 0x0);
269         _;
270     }
271 
272     // verifies that the address is different than this contract address
273     modifier notThis(address _address) {
274         require(_address != address(this));
275         _;
276     }
277 
278     /**
279         @dev withdraws tokens held by the contract and sends them to an account
280         can only be called by the owner
281 
282         @param _token   ERC20 token contract address
283         @param _to      account to receive the new amount
284         @param _amount  amount to withdraw
285     */
286     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
287         public
288         ownerOnly
289         validAddress(_token)
290         validAddress(_to)
291         notThis(_to)
292     {
293         assert(_token.transfer(_to, _amount));
294     }
295 }
296 
297 /*
298     Smart Token v0.2
299 
300     'Owned' is specified here for readability reasons
301 */
302 contract SmartToken is ISmartToken, ERC20Token, Owned, TokenHolder {
303     string public version = '0.2';
304 
305     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
306 
307     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
308     event NewSmartToken(address _token);
309     // triggered when the total supply is increased
310     event Issuance(uint256 _amount);
311     // triggered when the total supply is decreased
312     event Destruction(uint256 _amount);
313 
314     /**
315         @dev constructor
316 
317         @param _name       token name
318         @param _symbol     token short symbol, 1-6 characters
319         @param _decimals   for display purposes only
320     */
321     function SmartToken(string _name, string _symbol, uint8 _decimals)
322         ERC20Token(_name, _symbol, _decimals)
323     {
324         require(bytes(_symbol).length <= 6); // validate input
325         NewSmartToken(address(this));
326     }
327 
328     // allows execution only when transfers aren't disabled
329     modifier transfersAllowed {
330         assert(transfersEnabled);
331         _;
332     }
333     
334     /**
335         @dev disables/enables transfers
336         can only be called by the contract owner
337 
338         @param _disable    true to disable transfers, false to enable them
339     */
340     function disableTransfers(bool _disable) public ownerOnly {
341         transfersEnabled = !_disable;
342     }
343 
344     /**
345         @dev increases the token supply and sends the new tokens to an account
346         can only be called by the contract owner
347 
348         @param _to         account to receive the new amount
349         @param _amount     amount to increase the supply by
350     */
351     function issue(address _to, uint256 _amount)
352         public
353         ownerOnly
354         validAddress(_to)
355         notThis(_to)
356     {
357         totalSupply = safeAdd(totalSupply, _amount);
358         //Total supply can't be over 1 Billion
359         if (totalSupply > maxSupplyGenerable) revert();
360         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
361 
362         Issuance(_amount);
363         Transfer(this, _to, _amount);
364     }
365 
366     /**
367         @dev removes tokens from an account and decreases the token supply
368         can only be called by the contract owner
369 
370         @param _from       account to remove the amount from
371         @param _amount     amount to decrease the supply by
372     */
373     function destroy(address _from, uint256 _amount)
374         public
375         ownerOnly
376     {
377         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
378         totalSupply = safeSub(totalSupply, _amount);
379 
380         Transfer(_from, this, _amount);
381         Destruction(_amount);
382     }
383 
384     // ERC20 standard method overrides with some extra functionality
385 
386     /**
387         @dev send coins
388         throws on any error rather then return a false flag to minimize user errors
389         note that when transferring to the smart token's address, the coins are actually destroyed
390 
391         @param _to      target address
392         @param _value   transfer amount
393 
394         @return true if the transfer was successful, false if it wasn't
395     */
396     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
397         assert(super.transfer(_to, _value));
398 
399         // transferring to the contract address destroys tokens
400         if (_to == address(this)) {
401             balanceOf[_to] -= _value;
402             totalSupply -= _value;
403             Destruction(_value);
404         }
405 
406         return true;
407     }
408 
409     /**
410         @dev an account/contract attempts to get the coins
411         throws on any error rather then return a false flag to minimize user errors
412         note that when transferring to the smart token's address, the coins are actually destroyed
413 
414         @param _from    source address
415         @param _to      target address
416         @param _value   transfer amount
417 
418         @return true if the transfer was successful, false if it wasn't
419     */
420     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
421         assert(super.transferFrom(_from, _to, _value));
422 
423         // transferring to the contract address destroys tokens
424         if (_to == address(this)) {
425             balanceOf[_to] -= _value;
426             totalSupply -= _value;
427             Destruction(_value);
428         }
429 
430         return true;
431     }
432     
433 }
434 
435 /// @title $Epm Smart Token
436 contract SmartEPM is SmartToken {
437     function SmartEPM() SmartToken('Epocum', 'EPM', 18) {
438         disableTransfers(false);
439     }
440 }