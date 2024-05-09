1 pragma solidity ^0.4.11;
2 
3 /*
4     Owned contract interface
5 */
6 contract IOwned {
7     // this function isn't abstract since the compiler emits automatically generated getter functions as external
8     function owner() public constant returns (address) {}
9 
10     function transferOwnership(address _newOwner) public;
11     function acceptOwnership() public;
12 }
13 
14 /*
15     Token Holder interface
16 */
17 contract ITokenHolder is IOwned {
18     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
19 }
20 
21 
22 /*
23     ERC20 Standard Token interface
24 */
25 contract IERC20Token {
26     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
27     function name() public constant returns (string) {}
28     function symbol() public constant returns (string) {}
29     function decimals() public constant returns (uint8) {}
30     function totalSupply() public constant returns (uint256) {}
31     function balanceOf(address _owner) public constant returns (uint256) { _owner; }
32     function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }
33 
34     function transfer(address _to, uint256 _value) public returns (bool success);
35     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
36     function approve(address _spender, uint256 _value) public returns (bool success);
37 }
38 
39 
40 /*
41     Smart Token interface
42 */
43 contract ISmartToken is IOwned, IERC20Token {
44     function disableTransfers(bool _disable) public;
45     function issue(address _to, uint256 _amount) public;
46     function destroy(address _from, uint256 _amount) public;
47 }
48 
49 
50 
51 /*
52     Utilities & Common Modifiers
53 */
54 contract Utils {
55     /**
56         constructor
57     */
58     function Utils() {
59     }
60 
61     // verifies that an amount is greater than zero
62     modifier greaterThanZero(uint256 _amount) {
63         require(_amount > 0);
64         _;
65     }
66 
67     // validates an address - currently only checks that it isn't null
68     modifier validAddress(address _address) {
69         require(_address != 0x0);
70         _;
71     }
72 
73     // verifies that the address is different than this contract address
74     modifier notThis(address _address) {
75         require(_address != address(this));
76         _;
77     }
78 
79     // Overflow protected math functions
80 
81     /**
82         @dev returns the sum of _x and _y, asserts if the calculation overflows
83 
84         @param _x   value 1
85         @param _y   value 2
86 
87         @return sum
88     */
89     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
90         uint256 z = _x + _y;
91         assert(z >= _x);
92         return z;
93     }
94 
95     /**
96         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
97 
98         @param _x   minuend
99         @param _y   subtrahend
100 
101         @return difference
102     */
103     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
104         assert(_x >= _y);
105         return _x - _y;
106     }
107 
108     /**
109         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
110 
111         @param _x   factor 1
112         @param _y   factor 2
113 
114         @return product
115     */
116     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
117         uint256 z = _x * _y;
118         assert(_x == 0 || z / _x == _y);
119         return z;
120     }
121 }
122 
123 
124 /*
125     Provides support and utilities for contract ownership
126 */
127 contract Owned is IOwned {
128     address public owner;
129     address public newOwner;
130 
131     event OwnerUpdate(address _prevOwner, address _newOwner);
132 
133     /**
134         @dev constructor
135     */
136     function Owned() {
137         owner = msg.sender;
138     }
139 
140     // allows execution by the owner only
141     modifier ownerOnly {
142         assert(msg.sender == owner);
143         _;
144     }
145 
146     /**
147         @dev allows transferring the contract ownership
148         the new owner still needs to accept the transfer
149         can only be called by the contract owner
150 
151         @param _newOwner    new contract owner
152     */
153     function transferOwnership(address _newOwner) public ownerOnly {
154         require(_newOwner != owner);
155         newOwner = _newOwner;
156     }
157 
158     /**
159         @dev used by a new owner to accept an ownership transfer
160     */
161     function acceptOwnership() public {
162         require(msg.sender == newOwner);
163         OwnerUpdate(owner, newOwner);
164         owner = newOwner;
165         newOwner = 0x0;
166     }
167 }
168 
169 
170 /*
171     We consider every contract to be a 'token holder' since it's currently not possible
172     for a contract to deny receiving tokens.
173 
174     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
175     the owner to send tokens that were sent to the contract by mistake back to their sender.
176 */
177 contract TokenHolder is ITokenHolder, Owned, Utils {
178     /**
179         @dev constructor
180     */
181     function TokenHolder() {
182     }
183 
184     /**
185         @dev withdraws tokens held by the contract and sends them to an account
186         can only be called by the owner
187 
188         @param _token   ERC20 token contract address
189         @param _to      account to receive the new amount
190         @param _amount  amount to withdraw
191     */
192     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
193         public
194         ownerOnly
195         validAddress(_token)
196         validAddress(_to)
197         notThis(_to)
198     {
199         assert(_token.transfer(_to, _amount));
200     }
201 }
202 
203 /**
204     ERC20 Standard Token implementation
205 */
206 contract ERC20Token is IERC20Token, Utils {
207     string public standard = 'Token 0.1';
208     string public name = '';
209     string public symbol = '';
210     uint8 public decimals = 0;
211     uint256 public totalSupply = 0;
212     mapping (address => uint256) public balanceOf;
213     mapping (address => mapping (address => uint256)) public allowance;
214 
215     event Transfer(address indexed _from, address indexed _to, uint256 _value);
216     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
217 
218     /**
219         @dev constructor
220 
221         @param _name        token name
222         @param _symbol      token symbol
223         @param _decimals    decimal points, for display purposes
224     */
225     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
226         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
227 
228         name = _name;
229         symbol = _symbol;
230         decimals = _decimals;
231     }
232 
233     /**
234         @dev send coins
235         throws on any error rather then return a false flag to minimize user errors
236 
237         @param _to      target address
238         @param _value   transfer amount
239 
240         @return true if the transfer was successful, false if it wasn't
241     */
242     function transfer(address _to, uint256 _value)
243         public
244         validAddress(_to)
245         returns (bool success)
246     {
247         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
248         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
249         Transfer(msg.sender, _to, _value);
250         return true;
251     }
252 
253     /**
254         @dev an account/contract attempts to get the coins
255         throws on any error rather then return a false flag to minimize user errors
256 
257         @param _from    source address
258         @param _to      target address
259         @param _value   transfer amount
260 
261         @return true if the transfer was successful, false if it wasn't
262     */
263     function transferFrom(address _from, address _to, uint256 _value)
264         public
265         validAddress(_from)
266         validAddress(_to)
267         returns (bool success)
268     {
269         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
270         balanceOf[_from] = safeSub(balanceOf[_from], _value);
271         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
272         Transfer(_from, _to, _value);
273         return true;
274     }
275 
276     /**
277         @dev allow another account/contract to spend some tokens on your behalf
278         throws on any error rather then return a false flag to minimize user errors
279 
280         also, to minimize the risk of the approve/transferFrom attack vector
281         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
282         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
283 
284         @param _spender approved address
285         @param _value   allowance amount
286 
287         @return true if the approval was successful, false if it wasn't
288     */
289     function approve(address _spender, uint256 _value)
290         public
291         validAddress(_spender)
292         returns (bool success)
293     {
294         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
295         require(_value == 0 || allowance[msg.sender][_spender] == 0);
296 
297         allowance[msg.sender][_spender] = _value;
298         Approval(msg.sender, _spender, _value);
299         return true;
300     }
301 }
302 
303 
304 /*
305     Smart Token v0.3
306 
307     'Owned' is specified here for readability reasons
308 */
309 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
310     string public version = '0.3';
311 
312     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
313 
314     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
315     event NewSmartToken(address _token);
316     // triggered when the total supply is increased
317     event Issuance(uint256 _amount);
318     // triggered when the total supply is decreased
319     event Destruction(uint256 _amount);
320 
321     /**
322         @dev constructor
323 
324         @param _name       token name
325         @param _symbol     token short symbol, minimum 1 character
326         @param _decimals   for display purposes only
327     */
328     function SmartToken(string _name, string _symbol, uint8 _decimals)
329         ERC20Token(_name, _symbol, _decimals)
330     {
331         NewSmartToken(address(this));
332     }
333 
334     // allows execution only when transfers aren't disabled
335     modifier transfersAllowed {
336         assert(transfersEnabled);
337         _;
338     }
339 
340     /**
341         @dev disables/enables transfers
342         can only be called by the contract owner
343 
344         @param _disable    true to disable transfers, false to enable them
345     */
346     function disableTransfers(bool _disable) public ownerOnly {
347         transfersEnabled = !_disable;
348     }
349 
350     /**
351         @dev increases the token supply and sends the new tokens to an account
352         can only be called by the contract owner
353 
354         @param _to         account to receive the new amount
355         @param _amount     amount to increase the supply by
356     */
357     function issue(address _to, uint256 _amount)
358         public
359         ownerOnly
360         validAddress(_to)
361         notThis(_to)
362     {
363         totalSupply = safeAdd(totalSupply, _amount);
364         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
365 
366         Issuance(_amount);
367         Transfer(this, _to, _amount);
368     }
369 
370     /**
371         @dev removes tokens from an account and decreases the token supply
372         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
373 
374         @param _from       account to remove the amount from
375         @param _amount     amount to decrease the supply by
376     */
377     function destroy(address _from, uint256 _amount) public {
378         require(msg.sender == _from || msg.sender == owner); // validate input
379 
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
392         in addition to the standard checks, the function throws if transfers are disabled
393 
394         @param _to      target address
395         @param _value   transfer amount
396 
397         @return true if the transfer was successful, false if it wasn't
398     */
399     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
400         assert(super.transfer(_to, _value));
401         return true;
402     }
403 
404     /**
405         @dev an account/contract attempts to get the coins
406         throws on any error rather then return a false flag to minimize user errors
407         in addition to the standard checks, the function throws if transfers are disabled
408 
409         @param _from    source address
410         @param _to      target address
411         @param _value   transfer amount
412 
413         @return true if the transfer was successful, false if it wasn't
414     */
415     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
416         assert(super.transferFrom(_from, _to, _value));
417         return true;
418     }
419 }