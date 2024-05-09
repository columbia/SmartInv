1 pragma solidity ^0.4.11;
2 
3 /*
4     Utilities & Common Modifiers
5 */
6 contract Utils {
7     /**
8         constructor
9     */
10     function Utils() {
11     }
12 
13     // verifies that an amount is greater than zero
14     modifier greaterThanZero(uint256 _amount) {
15         require(_amount > 0);
16         _;
17     }
18 
19     // validates an address - currently only checks that it isn't null
20     modifier validAddress(address _address) {
21         require(_address != 0x0);
22         _;
23     }
24 
25     // verifies that the address is different than this contract address
26     modifier notThis(address _address) {
27         require(_address != address(this));
28         _;
29     }
30 
31     // Overflow protected math functions
32 
33     /**
34         @dev returns the sum of _x and _y, asserts if the calculation overflows
35 
36         @param _x   value 1
37         @param _y   value 2
38 
39         @return sum
40     */
41     function safeAdd(uint256 _x, uint256 _y) internal constant returns (uint256) {
42         uint256 z = _x + _y;
43         assert(z >= _x);
44         return z;
45     }
46 
47     /**
48         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
49 
50         @param _x   minuend
51         @param _y   subtrahend
52 
53         @return difference
54     */
55     function safeSub(uint256 _x, uint256 _y) internal constant returns (uint256) {
56         assert(_x >= _y);
57         return _x - _y;
58     }
59 
60     /**
61         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
62 
63         @param _x   factor 1
64         @param _y   factor 2
65 
66         @return product
67     */
68     function safeMul(uint256 _x, uint256 _y) internal constant returns (uint256) {
69         uint256 z = _x * _y;
70         assert(_x == 0 || z / _x == _y);
71         return z;
72     }
73 }
74 
75 /*
76     Owned contract interface
77 */
78 contract IOwned {
79     // this function isn't abstract since the compiler emits automatically generated getter functions as external
80     function owner() public constant returns (address) {}
81 
82     function transferOwnership(address _newOwner) public;
83     function acceptOwnership() public;
84 }
85 
86 /*
87     Provides support and utilities for contract ownership
88 */
89 contract Owned is IOwned {
90     address public owner;
91     address public newOwner;
92 
93     event OwnerUpdate(address _prevOwner, address _newOwner);
94 
95     /**
96         @dev constructor
97     */
98     function Owned() {
99         owner = msg.sender;
100     }
101 
102     // allows execution by the owner only
103     modifier ownerOnly {
104         assert(msg.sender == owner);
105         _;
106     }
107 
108     /**
109         @dev allows transferring the contract ownership
110         the new owner still needs to accept the transfer
111         can only be called by the contract owner
112 
113         @param _newOwner    new contract owner
114     */
115     function transferOwnership(address _newOwner) public ownerOnly {
116         require(_newOwner != owner);
117         newOwner = _newOwner;
118     }
119 
120     /**
121         @dev used by a new owner to accept an ownership transfer
122     */
123     function acceptOwnership() public {
124         require(msg.sender == newOwner);
125         OwnerUpdate(owner, newOwner);
126         owner = newOwner;
127         newOwner = 0x0;
128     }
129 }
130 
131 /*
132     ERC20 Standard Token interface
133 */
134 contract IERC20Token {
135     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
136     function name() public constant returns (string) {}
137     function symbol() public constant returns (string) {}
138     function decimals() public constant returns (uint8) {}
139     function totalSupply() public constant returns (uint256) {}
140     function balanceOf(address _owner) public constant returns (uint256) { _owner; }
141     function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }
142 
143     function transfer(address _to, uint256 _value) public returns (bool success);
144     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
145     function approve(address _spender, uint256 _value) public returns (bool success);
146 }
147 
148 /**
149     ERC20 Standard Token implementation
150 */
151 contract ERC20Token is IERC20Token, Utils {
152     string public standard = 'Token 0.1';
153     string public name = '';
154     string public symbol = '';
155     uint8 public decimals = 0;
156     uint256 public totalSupply = 0;
157     mapping (address => uint256) public balanceOf;
158     mapping (address => mapping (address => uint256)) public allowance;
159 
160     event Transfer(address indexed _from, address indexed _to, uint256 _value);
161     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
162 
163     /**
164         @dev constructor
165 
166         @param _name        token name
167         @param _symbol      token symbol
168         @param _decimals    decimal points, for display purposes
169     */
170     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
171         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
172 
173         name = _name;
174         symbol = _symbol;
175         decimals = _decimals;
176     }
177 
178     /**
179         @dev send coins
180         throws on any error rather then return a false flag to minimize user errors
181 
182         @param _to      target address
183         @param _value   transfer amount
184 
185         @return true if the transfer was successful, false if it wasn't
186     */
187     function transfer(address _to, uint256 _value)
188         public
189         validAddress(_to)
190         returns (bool success)
191     {
192         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
193         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
194         Transfer(msg.sender, _to, _value);
195         return true;
196     }
197 
198     /**
199         @dev an account/contract attempts to get the coins
200         throws on any error rather then return a false flag to minimize user errors
201 
202         @param _from    source address
203         @param _to      target address
204         @param _value   transfer amount
205 
206         @return true if the transfer was successful, false if it wasn't
207     */
208     function transferFrom(address _from, address _to, uint256 _value)
209         public
210         validAddress(_from)
211         validAddress(_to)
212         returns (bool success)
213     {
214         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
215         balanceOf[_from] = safeSub(balanceOf[_from], _value);
216         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
217         Transfer(_from, _to, _value);
218         return true;
219     }
220 
221     /**
222         @dev allow another account/contract to spend some tokens on your behalf
223         throws on any error rather then return a false flag to minimize user errors
224 
225         also, to minimize the risk of the approve/transferFrom attack vector
226         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
227         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
228 
229         @param _spender approved address
230         @param _value   allowance amount
231 
232         @return true if the approval was successful, false if it wasn't
233     */
234     function approve(address _spender, uint256 _value)
235         public
236         validAddress(_spender)
237         returns (bool success)
238     {
239         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
240         require(_value == 0 || allowance[msg.sender][_spender] == 0);
241 
242         allowance[msg.sender][_spender] = _value;
243         Approval(msg.sender, _spender, _value);
244         return true;
245     }
246 }
247 
248 /*
249     Token Holder interface
250 */
251 contract ITokenHolder is IOwned {
252     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
253 }
254 
255 /*
256     We consider every contract to be a 'token holder' since it's currently not possible
257     for a contract to deny receiving tokens.
258 
259     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
260     the owner to send tokens that were sent to the contract by mistake back to their sender.
261 */
262 contract TokenHolder is ITokenHolder, Owned, Utils {
263     /**
264         @dev constructor
265     */
266     function TokenHolder() {
267     }
268 
269     /**
270         @dev withdraws tokens held by the contract and sends them to an account
271         can only be called by the owner
272 
273         @param _token   ERC20 token contract address
274         @param _to      account to receive the new amount
275         @param _amount  amount to withdraw
276     */
277     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
278         public
279         ownerOnly
280         validAddress(_token)
281         validAddress(_to)
282         notThis(_to)
283     {
284         assert(_token.transfer(_to, _amount));
285     }
286 }
287 
288 /*
289     Smart Token interface
290 */
291 contract ISmartToken is IOwned, IERC20Token {
292     function disableTransfers(bool _disable) public;
293     function issue(address _to, uint256 _amount) public;
294     function destroy(address _from, uint256 _amount) public;
295 }
296 
297 /*
298     Smart Token v0.3
299 
300     'Owned' is specified here for readability reasons
301 */
302 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
303     string public version = '0.3';
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
318         @param _symbol     token short symbol, minimum 1 character
319         @param _decimals   for display purposes only
320     */
321     function SmartToken(string _name, string _symbol, uint8 _decimals)
322         ERC20Token(_name, _symbol, _decimals)
323     {
324         NewSmartToken(address(this));
325     }
326 
327     // allows execution only when transfers aren't disabled
328     modifier transfersAllowed {
329         assert(transfersEnabled);
330         _;
331     }
332 
333     /**
334         @dev disables/enables transfers
335         can only be called by the contract owner
336 
337         @param _disable    true to disable transfers, false to enable them
338     */
339     function disableTransfers(bool _disable) public ownerOnly {
340         transfersEnabled = !_disable;
341     }
342 
343     /**
344         @dev increases the token supply and sends the new tokens to an account
345         can only be called by the contract owner
346 
347         @param _to         account to receive the new amount
348         @param _amount     amount to increase the supply by
349     */
350     function issue(address _to, uint256 _amount)
351         public
352         ownerOnly
353         validAddress(_to)
354         notThis(_to)
355     {
356         totalSupply = safeAdd(totalSupply, _amount);
357         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
358 
359         Issuance(_amount);
360         Transfer(this, _to, _amount);
361     }
362 
363     /**
364         @dev removes tokens from an account and decreases the token supply
365         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
366 
367         @param _from       account to remove the amount from
368         @param _amount     amount to decrease the supply by
369     */
370     function destroy(address _from, uint256 _amount) public {
371         require(msg.sender == _from || msg.sender == owner); // validate input
372 
373         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
374         totalSupply = safeSub(totalSupply, _amount);
375 
376         Transfer(_from, this, _amount);
377         Destruction(_amount);
378     }
379 
380     // ERC20 standard method overrides with some extra functionality
381 
382     /**
383         @dev send coins
384         throws on any error rather then return a false flag to minimize user errors
385         in addition to the standard checks, the function throws if transfers are disabled
386 
387         @param _to      target address
388         @param _value   transfer amount
389 
390         @return true if the transfer was successful, false if it wasn't
391     */
392     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
393         assert(super.transfer(_to, _value));
394         return true;
395     }
396 
397     /**
398         @dev an account/contract attempts to get the coins
399         throws on any error rather then return a false flag to minimize user errors
400         in addition to the standard checks, the function throws if transfers are disabled
401 
402         @param _from    source address
403         @param _to      target address
404         @param _value   transfer amount
405 
406         @return true if the transfer was successful, false if it wasn't
407     */
408     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
409         assert(super.transferFrom(_from, _to, _value));
410         return true;
411     }
412 }