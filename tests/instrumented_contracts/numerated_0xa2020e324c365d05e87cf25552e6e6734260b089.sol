1 pragma solidity ^0.4.18;
2 
3 
4 /*
5     Utilities & Common Modifiers
6 */
7 contract Utils {
8     /**
9         constructor
10     */
11     function Utils() public {
12     }
13 
14     // verifies that an amount is greater than zero
15     modifier greaterThanZero(uint256 _amount) {
16         require(_amount > 0);
17         _;
18     }
19 
20     // validates an address - currently only checks that it isn't null
21     modifier validAddress(address _address) {
22         require(_address != address(0));
23         _;
24     }
25 
26     // verifies that the address is different than this contract address
27     modifier notThis(address _address) {
28         require(_address != address(this));
29         _;
30     }
31 
32     // Overflow protected math functions
33 
34     /**
35         @dev returns the sum of _x and _y, asserts if the calculation overflows
36 
37         @param _x   value 1
38         @param _y   value 2
39 
40         @return sum
41     */
42     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
43         uint256 z = _x + _y;
44         assert(z >= _x);
45         return z;
46     }
47 
48     /**
49         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
50 
51         @param _x   minuend
52         @param _y   subtrahend
53 
54         @return difference
55     */
56     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
57         assert(_x >= _y);
58         return _x - _y;
59     }
60 
61     /**
62         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
63 
64         @param _x   factor 1
65         @param _y   factor 2
66 
67         @return product
68     */
69     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
70         uint256 z = _x * _y;
71         assert(_x == 0 || z / _x == _y);
72         return z;
73     }
74 }
75 
76 
77 /*
78     ERC20 Standard Token interface
79 */
80 contract IERC20Token {
81     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
82     function name() public view returns (string) {}
83     function symbol() public view returns (string) {}
84     function decimals() public view returns (uint8) {}
85     function totalSupply() public view returns (uint256) {}
86     function balanceOf(address _owner) public view returns (uint256) { _owner; }
87     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
88 
89     function transfer(address _to, uint256 _value) public returns (bool success);
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
91     function approve(address _spender, uint256 _value) public returns (bool success);
92 }
93 
94 
95 /**
96     ERC20 Standard Token implementation
97 */
98 contract ERC20Token is IERC20Token, Utils {
99     string public standard = 'Token 0.1';
100     string public name = '';
101     string public symbol = '';
102     uint8 public decimals = 0;
103     uint256 public totalSupply = 0;
104     mapping (address => uint256) public balanceOf;
105     mapping (address => mapping (address => uint256)) public allowance;
106 
107     event Transfer(address indexed _from, address indexed _to, uint256 _value);
108     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
109 
110     /**
111         @dev constructor
112 
113         @param _name        token name
114         @param _symbol      token symbol
115         @param _decimals    decimal points, for display purposes
116     */
117     function ERC20Token(string _name, string _symbol, uint8 _decimals) public {
118         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
119 
120         name = _name;
121         symbol = _symbol;
122         decimals = _decimals;
123     }
124 
125     /**
126         @dev send coins
127         throws on any error rather then return a false flag to minimize user errors
128 
129         @param _to      target address
130         @param _value   transfer amount
131 
132         @return true if the transfer was successful, false if it wasn't
133     */
134     function transfer(address _to, uint256 _value)
135         public
136         validAddress(_to)
137         returns (bool success)
138     {
139         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
140         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
141         Transfer(msg.sender, _to, _value);
142         return true;
143     }
144 
145     /**
146         @dev an account/contract attempts to get the coins
147         throws on any error rather then return a false flag to minimize user errors
148 
149         @param _from    source address
150         @param _to      target address
151         @param _value   transfer amount
152 
153         @return true if the transfer was successful, false if it wasn't
154     */
155     function transferFrom(address _from, address _to, uint256 _value)
156         public
157         validAddress(_from)
158         validAddress(_to)
159         returns (bool success)
160     {
161         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
162         balanceOf[_from] = safeSub(balanceOf[_from], _value);
163         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
164         Transfer(_from, _to, _value);
165         return true;
166     }
167 
168     /**
169         @dev allow another account/contract to spend some tokens on your behalf
170         throws on any error rather then return a false flag to minimize user errors
171 
172         also, to minimize the risk of the approve/transferFrom attack vector
173         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
174         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
175 
176         @param _spender approved address
177         @param _value   allowance amount
178 
179         @return true if the approval was successful, false if it wasn't
180     */
181     function approve(address _spender, uint256 _value)
182         public
183         validAddress(_spender)
184         returns (bool success)
185     {
186         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
187         require(_value == 0 || allowance[msg.sender][_spender] == 0);
188 
189         allowance[msg.sender][_spender] = _value;
190         Approval(msg.sender, _spender, _value);
191         return true;
192     }
193 }
194 
195 
196 /*
197     Owned contract interface
198 */
199 contract IOwned {
200     // this function isn't abstract since the compiler emits automatically generated getter functions as external
201     function owner() public view returns (address) {}
202 
203     function transferOwnership(address _newOwner) public;
204     function acceptOwnership() public;
205 }
206 
207 
208 /*
209     Provides support and utilities for contract ownership
210 */
211 contract Owned is IOwned {
212     address public owner;
213     address public newOwner;
214 
215     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
216 
217     /**
218         @dev constructor
219     */
220     function Owned() public {
221         owner = msg.sender;
222     }
223 
224     // allows execution by the owner only
225     modifier ownerOnly {
226         assert(msg.sender == owner);
227         _;
228     }
229 
230     /**
231         @dev allows transferring the contract ownership
232         the new owner still needs to accept the transfer
233         can only be called by the contract owner
234 
235         @param _newOwner    new contract owner
236     */
237     function transferOwnership(address _newOwner) public ownerOnly {
238         require(_newOwner != owner);
239         newOwner = _newOwner;
240     }
241 
242     /**
243         @dev used by a new owner to accept an ownership transfer
244     */
245     function acceptOwnership() public {
246         require(msg.sender == newOwner);
247         OwnerUpdate(owner, newOwner);
248         owner = newOwner;
249         newOwner = address(0);
250     }
251 }
252 
253 
254 /*
255     Token Holder interface
256 */
257 contract ITokenHolder is IOwned {
258     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
259 }
260 
261 
262 /*
263     We consider every contract to be a 'token holder' since it's currently not possible
264     for a contract to deny receiving tokens.
265 
266     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
267     the owner to send tokens that were sent to the contract by mistake back to their sender.
268 */
269 contract TokenHolder is ITokenHolder, Owned, Utils {
270     /**
271         @dev constructor
272     */
273     function TokenHolder() public {
274     }
275 
276     /**
277         @dev withdraws tokens held by the contract and sends them to an account
278         can only be called by the owner
279 
280         @param _token   ERC20 token contract address
281         @param _to      account to receive the new amount
282         @param _amount  amount to withdraw
283     */
284     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
285         public
286         ownerOnly
287         validAddress(_token)
288         validAddress(_to)
289         notThis(_to)
290     {
291         assert(_token.transfer(_to, _amount));
292     }
293 }
294 
295 
296 /*
297     Smart Token interface
298 */
299 contract ISmartToken is IOwned, IERC20Token {
300     function disableTransfers(bool _disable) public;
301     function issue(address _to, uint256 _amount) public;
302     function destroy(address _from, uint256 _amount) public;
303 }
304 
305 
306 /*
307     Smart Token v0.3
308 
309     'Owned' is specified here for readability reasons
310 */
311 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
312     string public version = '0.3';
313 
314     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
315 
316     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
317     event NewSmartToken(address _token);
318     // triggered when the total supply is increased
319     event Issuance(uint256 _amount);
320     // triggered when the total supply is decreased
321     event Destruction(uint256 _amount);
322 
323     /**
324         @dev constructor
325 
326         @param _name       token name
327         @param _symbol     token short symbol, minimum 1 character
328         @param _decimals   for display purposes only
329     */
330     function SmartToken(string _name, string _symbol, uint8 _decimals)
331         public
332         ERC20Token(_name, _symbol, _decimals)
333     {
334         NewSmartToken(address(this));
335     }
336 
337     // allows execution only when transfers aren't disabled
338     modifier transfersAllowed {
339         assert(transfersEnabled);
340         _;
341     }
342 
343     /**
344         @dev disables/enables transfers
345         can only be called by the contract owner
346 
347         @param _disable    true to disable transfers, false to enable them
348     */
349     function disableTransfers(bool _disable) public ownerOnly {
350         transfersEnabled = !_disable;
351     }
352 
353     /**
354         @dev increases the token supply and sends the new tokens to an account
355         can only be called by the contract owner
356 
357         @param _to         account to receive the new amount
358         @param _amount     amount to increase the supply by
359     */
360     function issue(address _to, uint256 _amount)
361         public
362         ownerOnly
363         validAddress(_to)
364         notThis(_to)
365     {
366         totalSupply = safeAdd(totalSupply, _amount);
367         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
368 
369         Issuance(_amount);
370         Transfer(this, _to, _amount);
371     }
372 
373     /**
374         @dev removes tokens from an account and decreases the token supply
375         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
376 
377         @param _from       account to remove the amount from
378         @param _amount     amount to decrease the supply by
379     */
380     function destroy(address _from, uint256 _amount) public {
381         require(msg.sender == _from || msg.sender == owner); // validate input
382 
383         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
384         totalSupply = safeSub(totalSupply, _amount);
385 
386         Transfer(_from, this, _amount);
387         Destruction(_amount);
388     }
389 
390     // ERC20 standard method overrides with some extra functionality
391 
392     /**
393         @dev send coins
394         throws on any error rather then return a false flag to minimize user errors
395         in addition to the standard checks, the function throws if transfers are disabled
396 
397         @param _to      target address
398         @param _value   transfer amount
399 
400         @return true if the transfer was successful, false if it wasn't
401     */
402     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
403         assert(super.transfer(_to, _value));
404         return true;
405     }
406 
407     /**
408         @dev an account/contract attempts to get the coins
409         throws on any error rather then return a false flag to minimize user errors
410         in addition to the standard checks, the function throws if transfers are disabled
411 
412         @param _from    source address
413         @param _to      target address
414         @param _value   transfer amount
415 
416         @return true if the transfer was successful, false if it wasn't
417     */
418     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
419         assert(super.transferFrom(_from, _to, _value));
420         return true;
421     }
422 }