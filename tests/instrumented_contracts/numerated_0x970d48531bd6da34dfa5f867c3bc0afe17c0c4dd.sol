1 pragma solidity ^0.4.11;
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
14 
15 /*
16     Provides support and utilities for contract ownership
17 */
18 contract Owned is IOwned {
19     address public owner;
20     address public newOwner;
21 
22     event OwnerUpdate(address _prevOwner, address _newOwner);
23 
24     /**
25         @dev constructor
26     */
27     function Owned() {
28         owner = msg.sender;
29     }
30 
31     // allows execution by the owner only
32     modifier ownerOnly {
33         assert(msg.sender == owner);
34         _;
35     }
36 
37     /**
38         @dev allows transferring the contract ownership
39         the new owner still need to accept the transfer
40         can only be called by the contract owner
41 
42         @param _newOwner    new contract owner
43     */
44     function transferOwnership(address _newOwner) public ownerOnly {
45         require(_newOwner != owner);
46         newOwner = _newOwner;
47     }
48 
49     /**
50         @dev used by a new owner to accept an ownership transfer
51     */
52     function acceptOwnership() public {
53         require(msg.sender == newOwner);
54         OwnerUpdate(owner, newOwner);
55         owner = newOwner;
56         newOwner = 0x0;
57     }
58 }
59 
60 /*
61     Token Holder interface
62 */
63 contract ITokenHolder is IOwned {
64     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
65 }
66 
67 
68 /*
69     Overflow protected math functions
70 */
71 contract SafeMath {
72     /**
73         constructor
74     */
75     function SafeMath() {
76     }
77 
78     /**
79         @dev returns the sum of _x and _y, asserts if the calculation overflows
80 
81         @param _x   value 1
82         @param _y   value 2
83 
84         @return sum
85     */
86     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
87         uint256 z = _x + _y;
88         assert(z >= _x);
89         return z;
90     }
91 
92     /**
93         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
94 
95         @param _x   minuend
96         @param _y   subtrahend
97 
98         @return difference
99     */
100     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
101         assert(_x >= _y);
102         return _x - _y;
103     }
104 
105     /**
106         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
107 
108         @param _x   factor 1
109         @param _y   factor 2
110 
111         @return product
112     */
113     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
114         uint256 z = _x * _y;
115         assert(_x == 0 || z / _x == _y);
116         return z;
117     }
118 } 
119 
120 /*
121     ERC20 Standard Token interface
122 */
123 contract IERC20Token {
124     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
125     function name() public constant returns (string name) { name; }
126     function symbol() public constant returns (string symbol) { symbol; }
127     function decimals() public constant returns (uint8 decimals) { decimals; }
128     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
129     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
130     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
131 
132     function transfer(address _to, uint256 _value) public returns (bool success);
133     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
134     function approve(address _spender, uint256 _value) public returns (bool success);
135 }
136 
137 /**
138     ERC20 Standard Token implementation
139 */
140 contract ERC20Token is IERC20Token, SafeMath {
141     string public standard = 'Token 0.1';
142     string public name = '';
143     string public symbol = '';
144     uint8 public decimals = 0;
145     uint256 public totalSupply = 0;
146     mapping (address => uint256) public balanceOf;
147     mapping (address => mapping (address => uint256)) public allowance;
148 
149     event Transfer(address indexed _from, address indexed _to, uint256 _value);
150     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
151 
152     /**
153         @dev constructor
154 
155         @param _name        token name
156         @param _symbol      token symbol
157         @param _decimals    decimal points, for display purposes
158     */
159     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
160         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
161 
162         name = _name;
163         symbol = _symbol;
164         decimals = _decimals;
165     }
166 
167     // validates an address - currently only checks that it isn't null
168     modifier validAddress(address _address) {
169         require(_address != 0x0);
170         _;
171     }
172 
173     /**
174         @dev send coins
175         throws on any error rather then return a false flag to minimize user errors
176 
177         @param _to      target address
178         @param _value   transfer amount
179 
180         @return true if the transfer was successful, false if it wasn't
181     */
182     function transfer(address _to, uint256 _value)
183         public
184         validAddress(_to)
185         returns (bool success)
186     {
187         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
188         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
189         Transfer(msg.sender, _to, _value);
190         return true;
191     }
192 
193     /**
194         @dev an account/contract attempts to get the coins
195         throws on any error rather then return a false flag to minimize user errors
196 
197         @param _from    source address
198         @param _to      target address
199         @param _value   transfer amount
200 
201         @return true if the transfer was successful, false if it wasn't
202     */
203     function transferFrom(address _from, address _to, uint256 _value)
204         public
205         validAddress(_from)
206         validAddress(_to)
207         returns (bool success)
208     {
209         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
210         balanceOf[_from] = safeSub(balanceOf[_from], _value);
211         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
212         Transfer(_from, _to, _value);
213         return true;
214     }
215 
216     /**
217         @dev allow another account/contract to spend some tokens on your behalf
218         throws on any error rather then return a false flag to minimize user errors
219 
220         also, to minimize the risk of the approve/transferFrom attack vector
221         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
222         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
223 
224         @param _spender approved address
225         @param _value   allowance amount
226 
227         @return true if the approval was successful, false if it wasn't
228     */
229     function approve(address _spender, uint256 _value)
230         public
231         validAddress(_spender)
232         returns (bool success)
233     {
234         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
235         require(_value == 0 || allowance[msg.sender][_spender] == 0);
236 
237         allowance[msg.sender][_spender] = _value;
238         Approval(msg.sender, _spender, _value);
239         return true;
240     }
241 }
242 
243 
244 
245 /*
246     We consider every contract to be a 'token holder' since it's currently not possible
247     for a contract to deny receiving tokens.
248 
249     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
250     the owner to send tokens that were sent to the contract by mistake back to their sender.
251 */
252 contract TokenHolder is ITokenHolder, Owned {
253     /**
254         @dev constructor
255     */
256     function TokenHolder() {
257     }
258 
259     // validates an address - currently only checks that it isn't null
260     modifier validAddress(address _address) {
261         require(_address != 0x0);
262         _;
263     }
264 
265     // verifies that the address is different than this contract address
266     modifier notThis(address _address) {
267         require(_address != address(this));
268         _;
269     }
270 
271     /**
272         @dev withdraws tokens held by the contract and sends them to an account
273         can only be called by the owner
274 
275         @param _token   ERC20 token contract address
276         @param _to      account to receive the new amount
277         @param _amount  amount to withdraw
278     */
279     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
280         public
281         ownerOnly
282         validAddress(_token)
283         validAddress(_to)
284         notThis(_to)
285     {
286         assert(_token.transfer(_to, _amount));
287     }
288 }
289 
290 
291 
292 /*
293     Smart Token interface
294 */
295 contract ISmartToken is ITokenHolder, IERC20Token {
296     function disableTransfers(bool _disable) public;
297     function issue(address _to, uint256 _amount) public;
298     function destroy(address _from, uint256 _amount) public;
299 }
300 
301 
302 /*
303     Smart Token v0.2
304 
305     'Owned' is specified here for readability reasons
306 */
307 contract SmartToken is ISmartToken, ERC20Token, Owned, TokenHolder {
308     string public version = '0.2';
309 
310     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
311 
312     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
313     event NewSmartToken(address _token);
314     // triggered when the total supply is increased
315     event Issuance(uint256 _amount);
316     // triggered when the total supply is decreased
317     event Destruction(uint256 _amount);
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
435 }