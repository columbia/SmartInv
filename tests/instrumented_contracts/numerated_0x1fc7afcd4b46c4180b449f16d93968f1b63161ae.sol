1 pragma solidity ^0.4.24;
2 
3 // File: bancor-contracts/solidity/contracts/utility/interfaces/IOwned.sol
4 
5 /*
6     Owned contract interface
7 */
8 contract IOwned {
9     // this function isn't abstract since the compiler emits automatically generated getter functions as external
10     function owner() public view returns (address) {}
11 
12     function transferOwnership(address _newOwner) public;
13     function acceptOwnership() public;
14 }
15 
16 // File: bancor-contracts/solidity/contracts/utility/Owned.sol
17 
18 /*
19     Provides support and utilities for contract ownership
20 */
21 contract Owned is IOwned {
22     address public owner;
23     address public newOwner;
24 
25     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
26 
27     /**
28         @dev constructor
29     */
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     // allows execution by the owner only
35     modifier ownerOnly {
36         assert(msg.sender == owner);
37         _;
38     }
39 
40     /**
41         @dev allows transferring the contract ownership
42         the new owner still needs to accept the transfer
43         can only be called by the contract owner
44 
45         @param _newOwner    new contract owner
46     */
47     function transferOwnership(address _newOwner) public ownerOnly {
48         require(_newOwner != owner);
49         newOwner = _newOwner;
50     }
51 
52     /**
53         @dev used by a new owner to accept an ownership transfer
54     */
55     function acceptOwnership() public {
56         require(msg.sender == newOwner);
57         emit OwnerUpdate(owner, newOwner);
58         owner = newOwner;
59         newOwner = address(0);
60     }
61 }
62 
63 // File: bancor-contracts/solidity/contracts/token/interfaces/IERC20Token.sol
64 
65 /*
66     ERC20 Standard Token interface
67 */
68 contract IERC20Token {
69     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
70     function name() public view returns (string) {}
71     function symbol() public view returns (string) {}
72     function decimals() public view returns (uint8) {}
73     function totalSupply() public view returns (uint256) {}
74     function balanceOf(address _owner) public view returns (uint256) { _owner; }
75     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
76 
77     function transfer(address _to, uint256 _value) public returns (bool success);
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
79     function approve(address _spender, uint256 _value) public returns (bool success);
80 }
81 
82 // File: bancor-contracts/solidity/contracts/utility/Utils.sol
83 
84 /*
85     Utilities & Common Modifiers
86 */
87 contract Utils {
88     /**
89         constructor
90     */
91     constructor() public {
92     }
93 
94     // verifies that an amount is greater than zero
95     modifier greaterThanZero(uint256 _amount) {
96         require(_amount > 0);
97         _;
98     }
99 
100     // validates an address - currently only checks that it isn't null
101     modifier validAddress(address _address) {
102         require(_address != address(0));
103         _;
104     }
105 
106     // verifies that the address is different than this contract address
107     modifier notThis(address _address) {
108         require(_address != address(this));
109         _;
110     }
111 
112     // Overflow protected math functions
113 
114     /**
115         @dev returns the sum of _x and _y, asserts if the calculation overflows
116 
117         @param _x   value 1
118         @param _y   value 2
119 
120         @return sum
121     */
122     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
123         uint256 z = _x + _y;
124         assert(z >= _x);
125         return z;
126     }
127 
128     /**
129         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
130 
131         @param _x   minuend
132         @param _y   subtrahend
133 
134         @return difference
135     */
136     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
137         assert(_x >= _y);
138         return _x - _y;
139     }
140 
141     /**
142         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
143 
144         @param _x   factor 1
145         @param _y   factor 2
146 
147         @return product
148     */
149     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
150         uint256 z = _x * _y;
151         assert(_x == 0 || z / _x == _y);
152         return z;
153     }
154 }
155 
156 // File: bancor-contracts/solidity/contracts/utility/interfaces/ITokenHolder.sol
157 
158 /*
159     Token Holder interface
160 */
161 contract ITokenHolder is IOwned {
162     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
163 }
164 
165 // File: bancor-contracts/solidity/contracts/utility/TokenHolder.sol
166 
167 /*
168     We consider every contract to be a 'token holder' since it's currently not possible
169     for a contract to deny receiving tokens.
170 
171     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
172     the owner to send tokens that were sent to the contract by mistake back to their sender.
173 */
174 contract TokenHolder is ITokenHolder, Owned, Utils {
175     /**
176         @dev constructor
177     */
178     constructor() public {
179     }
180 
181     /**
182         @dev withdraws tokens held by the contract and sends them to an account
183         can only be called by the owner
184 
185         @param _token   ERC20 token contract address
186         @param _to      account to receive the new amount
187         @param _amount  amount to withdraw
188     */
189     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
190         public
191         ownerOnly
192         validAddress(_token)
193         validAddress(_to)
194         notThis(_to)
195     {
196         assert(_token.transfer(_to, _amount));
197     }
198 }
199 
200 // File: bancor-contracts/solidity/contracts/token/ERC20Token.sol
201 
202 /**
203     ERC20 Standard Token implementation
204 */
205 contract ERC20Token is IERC20Token, Utils {
206     string public standard = 'Token 0.1';
207     string public name = '';
208     string public symbol = '';
209     uint8 public decimals = 0;
210     uint256 public totalSupply = 0;
211     mapping (address => uint256) public balanceOf;
212     mapping (address => mapping (address => uint256)) public allowance;
213 
214     event Transfer(address indexed _from, address indexed _to, uint256 _value);
215     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
216 
217     /**
218         @dev constructor
219 
220         @param _name        token name
221         @param _symbol      token symbol
222         @param _decimals    decimal points, for display purposes
223     */
224     constructor(string _name, string _symbol, uint8 _decimals) public {
225         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
226 
227         name = _name;
228         symbol = _symbol;
229         decimals = _decimals;
230     }
231 
232     /**
233         @dev send coins
234         throws on any error rather then return a false flag to minimize user errors
235 
236         @param _to      target address
237         @param _value   transfer amount
238 
239         @return true if the transfer was successful, false if it wasn't
240     */
241     function transfer(address _to, uint256 _value)
242         public
243         validAddress(_to)
244         returns (bool success)
245     {
246         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
247         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
248         emit Transfer(msg.sender, _to, _value);
249         return true;
250     }
251 
252     /**
253         @dev an account/contract attempts to get the coins
254         throws on any error rather then return a false flag to minimize user errors
255 
256         @param _from    source address
257         @param _to      target address
258         @param _value   transfer amount
259 
260         @return true if the transfer was successful, false if it wasn't
261     */
262     function transferFrom(address _from, address _to, uint256 _value)
263         public
264         validAddress(_from)
265         validAddress(_to)
266         returns (bool success)
267     {
268         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
269         balanceOf[_from] = safeSub(balanceOf[_from], _value);
270         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
271         emit Transfer(_from, _to, _value);
272         return true;
273     }
274 
275     /**
276         @dev allow another account/contract to spend some tokens on your behalf
277         throws on any error rather then return a false flag to minimize user errors
278 
279         also, to minimize the risk of the approve/transferFrom attack vector
280         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
281         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
282 
283         @param _spender approved address
284         @param _value   allowance amount
285 
286         @return true if the approval was successful, false if it wasn't
287     */
288     function approve(address _spender, uint256 _value)
289         public
290         validAddress(_spender)
291         returns (bool success)
292     {
293         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
294         require(_value == 0 || allowance[msg.sender][_spender] == 0);
295 
296         allowance[msg.sender][_spender] = _value;
297         emit Approval(msg.sender, _spender, _value);
298         return true;
299     }
300 }
301 
302 // File: bancor-contracts/solidity/contracts/token/interfaces/ISmartToken.sol
303 
304 /*
305     Smart Token interface
306 */
307 contract ISmartToken is IOwned, IERC20Token {
308     function disableTransfers(bool _disable) public;
309     function issue(address _to, uint256 _amount) public;
310     function destroy(address _from, uint256 _amount) public;
311 }
312 
313 // File: bancor-contracts/solidity/contracts/token/SmartToken.sol
314 
315 /*
316     Smart Token v0.3
317 
318     'Owned' is specified here for readability reasons
319 */
320 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
321     string public version = '0.3';
322 
323     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
324 
325     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
326     event NewSmartToken(address _token);
327     // triggered when the total supply is increased
328     event Issuance(uint256 _amount);
329     // triggered when the total supply is decreased
330     event Destruction(uint256 _amount);
331 
332     /**
333         @dev constructor
334 
335         @param _name       token name
336         @param _symbol     token short symbol, minimum 1 character
337         @param _decimals   for display purposes only
338     */
339     constructor(string _name, string _symbol, uint8 _decimals)
340         public
341         ERC20Token(_name, _symbol, _decimals)
342     {
343         emit NewSmartToken(address(this));
344     }
345 
346     // allows execution only when transfers aren't disabled
347     modifier transfersAllowed {
348         assert(transfersEnabled);
349         _;
350     }
351 
352     /**
353         @dev disables/enables transfers
354         can only be called by the contract owner
355 
356         @param _disable    true to disable transfers, false to enable them
357     */
358     function disableTransfers(bool _disable) public ownerOnly {
359         transfersEnabled = !_disable;
360     }
361 
362     /**
363         @dev increases the token supply and sends the new tokens to an account
364         can only be called by the contract owner
365 
366         @param _to         account to receive the new amount
367         @param _amount     amount to increase the supply by
368     */
369     function issue(address _to, uint256 _amount)
370         public
371         ownerOnly
372         validAddress(_to)
373         notThis(_to)
374     {
375         totalSupply = safeAdd(totalSupply, _amount);
376         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
377 
378         emit Issuance(_amount);
379         emit Transfer(this, _to, _amount);
380     }
381 
382     /**
383         @dev removes tokens from an account and decreases the token supply
384         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
385 
386         @param _from       account to remove the amount from
387         @param _amount     amount to decrease the supply by
388     */
389     function destroy(address _from, uint256 _amount) public {
390         require(msg.sender == _from || msg.sender == owner); // validate input
391 
392         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
393         totalSupply = safeSub(totalSupply, _amount);
394 
395         emit Transfer(_from, this, _amount);
396         emit Destruction(_amount);
397     }
398 
399     // ERC20 standard method overrides with some extra functionality
400 
401     /**
402         @dev send coins
403         throws on any error rather then return a false flag to minimize user errors
404         in addition to the standard checks, the function throws if transfers are disabled
405 
406         @param _to      target address
407         @param _value   transfer amount
408 
409         @return true if the transfer was successful, false if it wasn't
410     */
411     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
412         assert(super.transfer(_to, _value));
413         return true;
414     }
415 
416     /**
417         @dev an account/contract attempts to get the coins
418         throws on any error rather then return a false flag to minimize user errors
419         in addition to the standard checks, the function throws if transfers are disabled
420 
421         @param _from    source address
422         @param _to      target address
423         @param _value   transfer amount
424 
425         @return true if the transfer was successful, false if it wasn't
426     */
427     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
428         assert(super.transferFrom(_from, _to, _value));
429         return true;
430     }
431 }
432 
433 // File: contracts/BAYToken.sol
434 
435 /**
436  * @title daicobay token
437  * @dev daicobay token is a Smart Token based on Bancor Protocol
438  */
439 contract BAYToken is SmartToken ( "daicobay token", "BAY", 18){
440   constructor() {
441     issue(msg.sender, 10**10 * 10**18);
442   }
443 }