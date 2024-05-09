1 pragma solidity ^0.4.24;
2 
3 // File: contracts/token/interfaces/IERC20Token.sol
4 
5 /*
6     ERC20 Standard Token interface
7 */
8 contract IERC20Token {
9     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
10     function name() public view returns (string) {}
11     function symbol() public view returns (string) {}
12     function decimals() public view returns (uint8) {}
13     function totalSupply() public view returns (uint256) {}
14     function balanceOf(address _owner) public view returns (uint256) { _owner; }
15     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
16 
17     function transfer(address _to, uint256 _value) public returns (bool success);
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
19     function approve(address _spender, uint256 _value) public returns (bool success);
20 }
21 
22 // File: contracts/utility/Utils.sol
23 
24 /*
25     Utilities & Common Modifiers
26 */
27 contract Utils {
28     /**
29         constructor
30     */
31     constructor() public {
32     }
33 
34     // verifies that an amount is greater than zero
35     modifier greaterThanZero(uint256 _amount) {
36         require(_amount > 0);
37         _;
38     }
39 
40     // validates an address - currently only checks that it isn't null
41     modifier validAddress(address _address) {
42         require(_address != address(0));
43         _;
44     }
45 
46     // verifies that the address is different than this contract address
47     modifier notThis(address _address) {
48         require(_address != address(this));
49         _;
50     }
51 
52     // Overflow protected math functions
53 
54     /**
55         @dev returns the sum of _x and _y, asserts if the calculation overflows
56 
57         @param _x   value 1
58         @param _y   value 2
59 
60         @return sum
61     */
62     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
63         uint256 z = _x + _y;
64         assert(z >= _x);
65         return z;
66     }
67 
68     /**
69         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
70 
71         @param _x   minuend
72         @param _y   subtrahend
73 
74         @return difference
75     */
76     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
77         assert(_x >= _y);
78         return _x - _y;
79     }
80 
81     /**
82         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
83 
84         @param _x   factor 1
85         @param _y   factor 2
86 
87         @return product
88     */
89     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
90         uint256 z = _x * _y;
91         assert(_x == 0 || z / _x == _y);
92         return z;
93     }
94 }
95 
96 // File: contracts/token/ERC20Token.sol
97 
98 /**
99     ERC20 Standard Token implementation
100 */
101 contract ERC20Token is IERC20Token, Utils {
102     string public standard = 'Token 0.1';
103     string public name = '';
104     string public symbol = '';
105     uint8 public decimals = 0;
106     uint256 public totalSupply = 0;
107     mapping (address => uint256) public balanceOf;
108     mapping (address => mapping (address => uint256)) public allowance;
109 
110     event Transfer(address indexed _from, address indexed _to, uint256 _value);
111     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
112 
113     /**
114         @dev constructor
115 
116         @param _name        token name
117         @param _symbol      token symbol
118         @param _decimals    decimal points, for display purposes
119     */
120     constructor(string _name, string _symbol, uint8 _decimals) public {
121         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
122 
123         name = _name;
124         symbol = _symbol;
125         decimals = _decimals;
126     }
127 
128     /**
129         @dev send coins
130         throws on any error rather then return a false flag to minimize user errors
131 
132         @param _to      target address
133         @param _value   transfer amount
134 
135         @return true if the transfer was successful, false if it wasn't
136     */
137     function transfer(address _to, uint256 _value)
138         public
139         validAddress(_to)
140         returns (bool success)
141     {
142         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
143         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
144         emit Transfer(msg.sender, _to, _value);
145         return true;
146     }
147 
148     /**
149         @dev an account/contract attempts to get the coins
150         throws on any error rather then return a false flag to minimize user errors
151 
152         @param _from    source address
153         @param _to      target address
154         @param _value   transfer amount
155 
156         @return true if the transfer was successful, false if it wasn't
157     */
158     function transferFrom(address _from, address _to, uint256 _value)
159         public
160         validAddress(_from)
161         validAddress(_to)
162         returns (bool success)
163     {
164         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
165         balanceOf[_from] = safeSub(balanceOf[_from], _value);
166         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
167         emit Transfer(_from, _to, _value);
168         return true;
169     }
170 
171     /**
172         @dev allow another account/contract to spend some tokens on your behalf
173         throws on any error rather then return a false flag to minimize user errors
174 
175         also, to minimize the risk of the approve/transferFrom attack vector
176         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
177         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
178 
179         @param _spender approved address
180         @param _value   allowance amount
181 
182         @return true if the approval was successful, false if it wasn't
183     */
184     function approve(address _spender, uint256 _value)
185         public
186         validAddress(_spender)
187         returns (bool success)
188     {
189         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
190         require(_value == 0 || allowance[msg.sender][_spender] == 0);
191 
192         allowance[msg.sender][_spender] = _value;
193         emit Approval(msg.sender, _spender, _value);
194         return true;
195     }
196 }
197 
198 // File: contracts/utility/interfaces/IOwned.sol
199 
200 /*
201     Owned contract interface
202 */
203 contract IOwned {
204     // this function isn't abstract since the compiler emits automatically generated getter functions as external
205     function owner() public view returns (address) {}
206 
207     function transferOwnership(address _newOwner) public;
208     function acceptOwnership() public;
209 }
210 
211 // File: contracts/token/interfaces/ISmartToken.sol
212 
213 /*
214     Smart Token interface
215 */
216 contract ISmartToken is IOwned, IERC20Token {
217     function disableTransfers(bool _disable) public;
218     function issue(address _to, uint256 _amount) public;
219     function destroy(address _from, uint256 _amount) public;
220 }
221 
222 // File: contracts/utility/Owned.sol
223 
224 /*
225     Provides support and utilities for contract ownership
226 */
227 contract Owned is IOwned {
228     address public owner;
229     address public newOwner;
230 
231     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
232 
233     /**
234         @dev constructor
235     */
236     constructor() public {
237         owner = msg.sender;
238     }
239 
240     // allows execution by the owner only
241     modifier ownerOnly {
242         require(msg.sender == owner);
243         _;
244     }
245 
246     /**
247         @dev allows transferring the contract ownership
248         the new owner still needs to accept the transfer
249         can only be called by the contract owner
250 
251         @param _newOwner    new contract owner
252     */
253     function transferOwnership(address _newOwner) public ownerOnly {
254         require(_newOwner != owner);
255         newOwner = _newOwner;
256     }
257 
258     /**
259         @dev used by a new owner to accept an ownership transfer
260     */
261     function acceptOwnership() public {
262         require(msg.sender == newOwner);
263         emit OwnerUpdate(owner, newOwner);
264         owner = newOwner;
265         newOwner = address(0);
266     }
267 }
268 
269 // File: contracts/utility/interfaces/ITokenHolder.sol
270 
271 /*
272     Token Holder interface
273 */
274 contract ITokenHolder is IOwned {
275     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
276 }
277 
278 // File: contracts/utility/TokenHolder.sol
279 
280 /*
281     We consider every contract to be a 'token holder' since it's currently not possible
282     for a contract to deny receiving tokens.
283 
284     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
285     the owner to send tokens that were sent to the contract by mistake back to their sender.
286 */
287 contract TokenHolder is ITokenHolder, Owned, Utils {
288     /**
289         @dev constructor
290     */
291     constructor() public {
292     }
293 
294     /**
295         @dev withdraws tokens held by the contract and sends them to an account
296         can only be called by the owner
297 
298         @param _token   ERC20 token contract address
299         @param _to      account to receive the new amount
300         @param _amount  amount to withdraw
301     */
302     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
303         public
304         ownerOnly
305         validAddress(_token)
306         validAddress(_to)
307         notThis(_to)
308     {
309         assert(_token.transfer(_to, _amount));
310     }
311 }
312 
313 // File: contracts/token/SmartToken.sol
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