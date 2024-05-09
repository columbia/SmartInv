1 pragma solidity ^0.4.18;
2 
3 /*
4     Utilities & Common Modifiers
5 */
6 contract Utils {
7     /**
8         constructor
9     */
10     constructor() public {
11     }
12 
13     // verifies that an amount is greater than zero
14     modifier greaterThanZero(uint256 _amount) {
15         require(_amount > 0);
16         _;
17     }
18 
19     // verifies a is greater than b
20     modifier greaterThan(uint256 _a, uint256 _b) {
21         require(_a >= _b);
22         _;
23     }
24 
25     // validates an address - currently only checks that it isn't null
26     modifier validAddress(address _address) {
27         require(_address != address(0));
28         _;
29     }
30 
31     // verifies that the address is different than this contract address
32     modifier notThis(address _address) {
33         require(_address != address(this));
34         _;
35     }
36 
37     // Overflow protected math functions
38 
39     /**
40         @dev returns the sum of _x and _y, asserts if the calculation overflows
41 
42         @param _x   value 1
43         @param _y   value 2
44 
45         @return sum
46     */
47     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
48         uint256 z = _x + _y;
49         assert(z >= _x);
50         return z;
51     }
52 
53     /**
54         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
55 
56         @param _x   minuend
57         @param _y   subtrahend
58 
59         @return difference
60     */
61     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
62         assert(_x >= _y);
63         return _x - _y;
64     }
65 
66     /**
67         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
68 
69         @param _x   factor 1
70         @param _y   factor 2
71 
72         @return product
73     */
74     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
75         uint256 z = _x * _y;
76         assert(_x == 0 || z / _x == _y);
77         return z;
78     }
79 }
80 
81 /*
82     Owned contract interface
83 */
84 contract IOwned {
85     // this function isn't abstract since the compiler emits automatically generated getter functions as external
86     function owner() public pure returns (address) {}
87 
88     function transferOwnership(address _newOwner) public;
89     function acceptOwnership() public;
90 }
91 
92 /*
93     Provides support and utilities for contract ownership
94 */
95 contract Owned is IOwned {
96     address public owner;
97     address public newOwner;
98 
99     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
100 
101     /**
102         @dev constructor
103     */
104     function Owned() public {
105         owner = msg.sender;
106     }
107 
108     // allows execution by the owner only
109     modifier ownerOnly {
110         assert(msg.sender == owner);
111         _;
112     }
113 
114     /**
115         @dev allows transferring the contract ownership
116         the new owner still needs to accept the transfer
117         can only be called by the contract owner
118 
119         @param _newOwner    new contract owner
120     */
121     function transferOwnership(address _newOwner) public ownerOnly {
122         require(_newOwner != owner);
123         newOwner = _newOwner;
124     }
125 
126     /**
127         @dev used by a new owner to accept an ownership transfer
128     */
129     function acceptOwnership() public {
130         require(msg.sender == newOwner);
131         emit OwnerUpdate(owner, newOwner);
132         owner = newOwner;
133         newOwner = address(0);
134     }
135 }
136 
137 /*
138     Token Holder interface
139 */
140 contract ITokenHolder is IOwned {
141     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
142 }
143 
144 /*
145     We consider every contract to be a 'token holder' since it's currently not possible
146     for a contract to deny receiving tokens.
147 
148     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
149     the owner to send tokens that were sent to the contract by mistake back to their sender.
150 */
151 contract TokenHolder is ITokenHolder, Owned, Utils {
152     /**
153         @dev constructor
154     */
155     function TokenHolder() public {
156     }
157 
158     /**
159         @dev withdraws tokens held by the contract and sends them to an account
160         can only be called by the owner
161 
162         @param _token   ERC20 token contract address
163         @param _to      account to receive the new amount
164         @param _amount  amount to withdraw
165     */
166     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
167         public
168         ownerOnly
169         validAddress(_token)
170         validAddress(_to)
171         notThis(_to)
172     {
173         assert(_token.transfer(_to, _amount));
174     }
175 }
176 
177 /*
178     ERC20 Standard Token interface
179 */
180 contract IERC20Token {
181     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
182     function name() public pure returns (string) {}
183     function symbol() public pure returns (string) {}
184     function decimals() public pure returns (uint8) {}
185     function totalSupply() public pure returns (uint256) {}
186     function balanceOf(address _owner) public pure returns (uint256) { _owner; }
187     function allowance(address _owner, address _spender) public pure returns (uint256) { _owner; _spender; }
188 
189     function transfer(address _to, uint256 _value) public returns (bool success);
190     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
191     function approve(address _spender, uint256 _value) public returns (bool success);
192 }
193 
194 /**
195     ERC20 Standard Token implementation
196 */
197 contract ERC20Token is IERC20Token, Utils {
198     string public standard = 'Token 0.1';
199     string public name = '';
200     string public symbol = '';
201     uint8 public decimals = 0;
202     uint256 public totalSupply = 0;
203     mapping (address => uint256) public balanceOf;
204     mapping (address => mapping (address => uint256)) public allowance;
205 
206     event Transfer(address indexed _from, address indexed _to, uint256 _value);
207     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
208 
209     /**
210         @dev constructor
211 
212         @param _name        token name
213         @param _symbol      token symbol
214         @param _decimals    decimal points, for display purposes
215     */
216     function ERC20Token(string _name, string _symbol, uint8 _decimals) public {
217         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
218 
219         name = _name;
220         symbol = _symbol;
221         decimals = _decimals;
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
240         emit Transfer(msg.sender, _to, _value);
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
257         validAddress(_to)
258         returns (bool success)
259     {
260         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
261         balanceOf[_from] = safeSub(balanceOf[_from], _value);
262         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
263         emit Transfer(_from, _to, _value);
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
289         emit Approval(msg.sender, _spender, _value);
290         return true;
291     }
292 }
293 
294 /*
295     Smart Token interface
296 */
297 contract ISmartToken is IOwned, IERC20Token {
298     function disableTransfers(bool _disable) public;
299     function issue(address _to, uint256 _amount) public;
300     function destroy(address _from, uint256 _amount) public;
301 }
302 
303 /*
304     Smart Token v0.3
305 
306     'Owned' is specified here for readability reasons
307 */
308 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
309     string public version = '0.3';
310     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
311 
312     mapping (address => bool) isFrozen;
313     uint256 public constant MAX_SUPPLY = 10000000000000000000000000000; // ten billion
314 
315     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
316     event NewSmartToken(address _token);
317     // triggered when the total supply is increased
318     event Issuance(uint256 _amount);
319     // triggered when the total supply is decreased
320     event Destruction(uint256 _amount);
321 
322     /**
323         @dev constructor
324 
325         @param _name       token namez
326         @param _symbol     token short symbol, minimum 1 character
327     */
328     function SmartToken(string _name, string _symbol)
329         public
330         ERC20Token(_name, _symbol, 18)
331     {
332         emit NewSmartToken(address(this));
333     }
334 
335     // allows execution only when transfers aren't disabled
336     modifier transfersAllowed {
337         assert(transfersEnabled);
338         _;
339     }
340 
341     // check if the address is frozen
342     modifier notFrozen(address _address) {
343         assert(isFrozen[_address] == false);
344         _;
345     }
346 
347     // check if the address is frozen
348     modifier notReachCap(uint256 _amount) {
349         assert(safeAdd(totalSupply, _amount) <= MAX_SUPPLY);
350         _;
351     }
352 
353     /**
354         @dev disables/enables transfers
355         can only be called by the contract owner
356 
357         @param _disable    true to disable transfers, false to enable them
358     */
359     function disableTransfers(bool _disable) public ownerOnly {
360         transfersEnabled = !_disable;
361     }
362 
363     /**
364         @dev freeze/unfreeze account
365         can only be called by the contract owner
366 
367         @param _address    user address to freeze
368         @param _freezeOrNot true means freeze, false means unfreeze
369     */
370     function freeze(address _address, bool _freezeOrNot) public ownerOnly {
371         isFrozen[_address] = _freezeOrNot;
372     }
373 
374     /**
375         @dev increases the token supply and sends the new tokens to an account
376         can only be called by the contract owner
377 
378         @param _to         account to receive the new amount
379         @param _amount     amount to increase the supply by
380     */
381     function issue(address _to, uint256 _amount)
382         public
383         ownerOnly
384         validAddress(_to)
385         notThis(_to)
386         notReachCap(_amount)
387     {
388         totalSupply = safeAdd(totalSupply, _amount);
389         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
390 
391         emit Issuance(_amount);
392         emit Transfer(this, _to, _amount);
393     }
394 
395     /**
396         @dev removes tokens from an account and decreases the token supply
397         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
398 
399         @param _from       account to remove the amount from
400         @param _amount     amount to decrease the supply by
401     */
402     function destroy(address _from, uint256 _amount) public {
403         require(msg.sender == _from || msg.sender == owner);
404         // validate input
405 
406         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
407         totalSupply = safeSub(totalSupply, _amount);
408 
409         emit Transfer(_from, this, _amount);
410         emit Destruction(_amount);
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
425     function transfer(address _to, uint256 _value)
426         public
427         transfersAllowed
428         notFrozen(msg.sender)
429         returns (bool success)
430     {
431         assert(super.transfer(_to, _value));
432         return true;
433     }
434 
435     /**
436         @dev an account/contract attempts to get the coins
437         throws on any error rather then return a false flag to minimize user errors
438         in addition to the standard checks, the function throws if transfers are disabled
439 
440         @param _from    source address
441         @param _to      target address
442         @param _value   transfer amount
443 
444         @return true if the transfer was successful, false if it wasn't
445     */
446     function transferFrom(address _from, address _to, uint256 _value)
447         public
448         transfersAllowed
449         notFrozen(_from)
450         returns (bool success)
451     {
452         assert(super.transferFrom(_from, _to, _value));
453         return true;
454     }
455 }