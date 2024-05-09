1 pragma solidity ^0.4.24;
2 
3 /*
4     ERC20 Standard Token interface
5 */
6 contract IERC20Token {
7     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
8     function name() public view returns (string) {}
9     function symbol() public view returns (string) {}
10     function decimals() public view returns (uint8) {}
11     function totalSupply() public view returns (uint256) {}
12     function balanceOf(address _owner) public view returns (uint256) { _owner; }
13     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
14 
15     function transfer(address _to, uint256 _value) public returns (bool success);
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17     function approve(address _spender, uint256 _value) public returns (bool success);
18 }
19 
20 /*
21     Utilities & Common Modifiers
22 */
23 contract Utils {
24     /**
25         constructor
26     */
27     constructor() public {
28     }
29 
30     // verifies that an amount is greater than zero
31     modifier greaterThanZero(uint256 _amount) {
32         require(_amount > 0);
33         _;
34     }
35 
36     // validates an address - currently only checks that it isn't null
37     modifier validAddress(address _address) {
38         require(_address != address(0));
39         _;
40     }
41 
42     // verifies that the address is different than this contract address
43     modifier notThis(address _address) {
44         require(_address != address(this));
45         _;
46     }
47 
48     // Overflow protected math functions
49 
50     /**
51         @dev returns the sum of _x and _y, asserts if the calculation overflows
52 
53         @param _x   value 1
54         @param _y   value 2
55 
56         @return sum
57     */
58     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
59         uint256 z = _x + _y;
60         assert(z >= _x);
61         return z;
62     }
63 
64     /**
65         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
66 
67         @param _x   minuend
68         @param _y   subtrahend
69 
70         @return difference
71     */
72     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
73         assert(_x >= _y);
74         return _x - _y;
75     }
76 
77     /**
78         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
79 
80         @param _x   factor 1
81         @param _y   factor 2
82 
83         @return product
84     */
85     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
86         uint256 z = _x * _y;
87         assert(_x == 0 || z / _x == _y);
88         return z;
89     }
90 }
91 
92 
93 /**
94     ERC20 Standard Token implementation
95 */
96 contract ERC20Token is IERC20Token, Utils {
97     string public standard = "Token 0.1";
98     string public name = "";
99     string public symbol = "";
100     uint8 public decimals = 0;
101     uint256 public totalSupply = 0;
102     mapping (address => uint256) public balanceOf;
103     mapping (address => mapping (address => uint256)) public allowance;
104 
105     event Transfer(address indexed _from, address indexed _to, uint256 _value);
106     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
107 
108     /**
109         @dev constructor
110 
111         @param _name        token name
112         @param _symbol      token symbol
113         @param _decimals    decimal points, for display purposes
114     */
115     constructor(string _name, string _symbol, uint8 _decimals) public {
116         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
117 
118         name = _name;
119         symbol = _symbol;
120         decimals = _decimals;
121     }
122 
123     /**
124         @dev send coins
125         throws on any error rather then return a false flag to minimize user errors
126 
127         @param _to      target address
128         @param _value   transfer amount
129 
130         @return true if the transfer was successful, false if it wasn't
131     */
132     function transfer(address _to, uint256 _value)
133         public
134         validAddress(_to)
135         returns (bool success)
136     {
137         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
138         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
139         emit Transfer(msg.sender, _to, _value);
140         return true;
141     }
142 
143     /**
144         @dev an account/contract attempts to get the coins
145         throws on any error rather then return a false flag to minimize user errors
146 
147         @param _from    source address
148         @param _to      target address
149         @param _value   transfer amount
150 
151         @return true if the transfer was successful, false if it wasn't
152     */
153     function transferFrom(address _from, address _to, uint256 _value)
154         public
155         validAddress(_from)
156         validAddress(_to)
157         returns (bool success)
158     {
159         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
160         balanceOf[_from] = safeSub(balanceOf[_from], _value);
161         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
162         emit Transfer(_from, _to, _value);
163         return true;
164     }
165 
166     /**
167         @dev allow another account/contract to spend some tokens on your behalf
168         throws on any error rather then return a false flag to minimize user errors
169 
170         also, to minimize the risk of the approve/transferFrom attack vector
171         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
172         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
173 
174         @param _spender approved address
175         @param _value   allowance amount
176 
177         @return true if the approval was successful, false if it wasn't
178     */
179     function approve(address _spender, uint256 _value)
180         public
181         validAddress(_spender)
182         returns (bool success)
183     {
184         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
185         require(_value == 0 || allowance[msg.sender][_spender] == 0);
186 
187         allowance[msg.sender][_spender] = _value;
188         emit Approval(msg.sender, _spender, _value);
189         return true;
190     }
191 }
192 
193 /*
194     Owned contract interface
195 */
196 contract IOwned {
197     // this function isn't abstract since the compiler emits automatically generated getter functions as external
198     function owner() public view returns (address) {}
199 
200     function transferOwnership(address _newOwner) public;
201     function acceptOwnership() public;
202 }
203 
204 /*
205     Provides support and utilities for contract ownership
206 */
207 contract Owned is IOwned {
208     address public owner;
209     address public newOwner;
210 
211     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
212 
213     /**
214         @dev constructor
215     */
216     constructor() public {
217         owner = msg.sender;
218     }
219 
220     // allows execution by the owner only
221     modifier ownerOnly {
222         assert(msg.sender == owner);
223         _;
224     }
225 
226     /**
227         @dev allows transferring the contract ownership
228         the new owner still needs to accept the transfer
229         can only be called by the contract owner
230 
231         @param _newOwner    new contract owner
232     */
233     function transferOwnership(address _newOwner) public ownerOnly {
234         require(_newOwner != owner);
235         newOwner = _newOwner;
236     }
237 
238     /**
239         @dev used by a new owner to accept an ownership transfer
240     */
241     function acceptOwnership() public {
242         require(msg.sender == newOwner);
243         emit OwnerUpdate(owner, newOwner);
244         owner = newOwner;
245         newOwner = address(0);
246     }
247 }
248 
249 
250 /*
251     Smart Token interface
252 */
253 contract ISmartToken is IOwned, IERC20Token {
254     function disableTransfers(bool _disable) public;
255     function issue(address _to, uint256 _amount) public;
256     function destroy(address _from, uint256 _amount) public;
257 }
258 
259 
260 /*
261     Token Holder interface
262 */
263 contract ITokenHolder is IOwned {
264     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
265 }
266 /*
267     We consider every contract to be a 'token holder' since it's currently not possible
268     for a contract to deny receiving tokens.
269 
270     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
271     the owner to send tokens that were sent to the contract by mistake back to their sender.
272 */
273 contract TokenHolder is ITokenHolder, Owned, Utils {
274     /**
275         @dev constructor
276     */
277     constructor() public {
278     }
279 
280     /**
281         @dev withdraws tokens held by the contract and sends them to an account
282         can only be called by the owner
283 
284         @param _token   ERC20 token contract address
285         @param _to      account to receive the new amount
286         @param _amount  amount to withdraw
287     */
288     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
289         public
290         ownerOnly
291         validAddress(_token)
292         validAddress(_to)
293         notThis(_to)
294     {
295         assert(_token.transfer(_to, _amount));
296     }
297 }
298 
299 /*
300     Smart Token v0.3
301 
302     'Owned' is specified here for readability reasons
303 */
304 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
305     string public version = "0.3";
306 
307     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
308 
309     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
310     event NewSmartToken(address _token);
311     // triggered when the total supply is increased
312     event Issuance(uint256 _amount);
313     // triggered when the total supply is decreased
314     event Destruction(uint256 _amount);
315 
316     /**
317         @dev constructor
318 
319         @param _name       token name
320         @param _symbol     token short symbol, minimum 1 character
321         @param _decimals   for display purposes only
322     */
323     constructor(string _name, string _symbol, uint8 _decimals)
324         public
325         ERC20Token(_name, _symbol, _decimals)
326     {
327         emit NewSmartToken(address(this));
328     }
329 
330     // allows execution only when transfers aren't disabled
331     modifier transfersAllowed {
332         assert(transfersEnabled);
333         _;
334     }
335 
336     /**
337         @dev disables/enables transfers
338         can only be called by the contract owner
339 
340         @param _disable    true to disable transfers, false to enable them
341     */
342     function disableTransfers(bool _disable) public ownerOnly {
343         transfersEnabled = !_disable;
344     }
345 
346     /**
347         @dev increases the token supply and sends the new tokens to an account
348         can only be called by the contract owner
349 
350         @param _to         account to receive the new amount
351         @param _amount     amount to increase the supply by
352     */
353     function issue(address _to, uint256 _amount)
354         public
355         ownerOnly
356         validAddress(_to)
357         notThis(_to)
358     {
359         totalSupply = safeAdd(totalSupply, _amount);
360         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
361 
362         emit Issuance(_amount);
363         emit Transfer(this, _to, _amount);
364     }
365 
366     /**
367         @dev removes tokens from an account and decreases the token supply
368         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
369 
370         @param _from       account to remove the amount from
371         @param _amount     amount to decrease the supply by
372     */
373     function destroy(address _from, uint256 _amount) public {
374         require(msg.sender == _from || msg.sender == owner); // validate input
375 
376         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
377         totalSupply = safeSub(totalSupply, _amount);
378 
379         emit Transfer(_from, this, _amount);
380         emit Destruction(_amount);
381     }
382 
383     // ERC20 standard method overrides with some extra functionality
384 
385     /**
386         @dev send coins
387         throws on any error rather then return a false flag to minimize user errors
388         in addition to the standard checks, the function throws if transfers are disabled
389 
390         @param _to      target address
391         @param _value   transfer amount
392 
393         @return true if the transfer was successful, false if it wasn't
394     */
395     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
396         assert(super.transfer(_to, _value));
397         return true;
398     }
399 
400     /**
401         @dev an account/contract attempts to get the coins
402         throws on any error rather then return a false flag to minimize user errors
403         in addition to the standard checks, the function throws if transfers are disabled
404 
405         @param _from    source address
406         @param _to      target address
407         @param _value   transfer amount
408 
409         @return true if the transfer was successful, false if it wasn't
410     */
411     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
412         assert(super.transferFrom(_from, _to, _value));
413         return true;
414     }
415 }
416 
417 
418 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
419 
420 
421 contract WhirlToken is SmartToken {
422 
423     string public name = "Whirl";
424     string public symbol = "WRL";
425     uint8 public  decimals = 18;
426 
427     uint256 public constant INITIAL_SUPPLY = 60000000000 * (10 ** uint256(decimals));
428 
429     mapping (address => bool) public frozenAccount;
430 
431     /* This generates a public event on the blockchain that will notify clients */
432     event FrozenFunds(address target, bool frozen);
433 
434     /**
435    * @dev Constructor that gives msg.sender all of existing tokens.
436    */
437     constructor() 
438         public 
439         SmartToken(name, symbol, decimals)
440     {
441         issue(msg.sender, INITIAL_SUPPLY);
442     }
443 
444     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
445     /// @param target Address to be frozen
446     /// @param freeze either to freeze it or not
447     function freezeAccount(address target, bool freeze) public ownerOnly  {
448         frozenAccount[target] = freeze;
449         emit FrozenFunds(target, freeze);
450     }
451 
452     /* This unnamed function is called whenever someone tries to send ether to it */
453     function() public {
454         revert();
455 	// Prevents accidental sending of ether
456     }
457 }