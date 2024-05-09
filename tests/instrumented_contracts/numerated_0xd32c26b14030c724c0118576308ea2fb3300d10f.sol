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
41     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
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
55     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
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
68     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
69         uint256 z = _x * _y;
70         assert(_x == 0 || z / _x == _y);
71         return z;
72     }
73 }
74 
75 
76 /*
77     Owned contract interface
78 */
79 contract IOwned {
80     // this function isn't abstract since the compiler emits automatically generated getter functions as external
81     function owner() public constant returns (address owner) { owner; }
82 
83     function transferOwnership(address _newOwner) public;
84     function acceptOwnership() public;
85 }
86 
87 
88 /*
89     Provides support and utilities for contract ownership
90 */
91 contract Owned is IOwned {
92     address public owner;
93     address public newOwner;
94 
95     event OwnerUpdate(address _prevOwner, address _newOwner);
96 
97     /**
98         @dev constructor
99     */
100     function Owned() {
101         owner = msg.sender;
102     }
103 
104     // allows execution by the owner only
105     modifier ownerOnly {
106         assert(msg.sender == owner);
107         _;
108     }
109 
110     /**
111         @dev allows transferring the contract ownership
112         the new owner still needs to accept the transfer
113         can only be called by the contract owner
114 
115         @param _newOwner    new contract owner
116     */
117     function transferOwnership(address _newOwner) public ownerOnly {
118         require(_newOwner != owner);
119         newOwner = _newOwner;
120     }
121 
122     /**
123         @dev used by a new owner to accept an ownership transfer
124     */
125     function acceptOwnership() public {
126         require(msg.sender == newOwner);
127         OwnerUpdate(owner, newOwner);
128         owner = newOwner;
129         newOwner = 0x0;
130     }
131 }
132 
133 
134 /*
135     ERC20 Standard Token interface
136 */
137 contract IERC20Token {
138     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
139     function name() public constant returns (string name) { name; }
140     function symbol() public constant returns (string symbol) { symbol; }
141     function decimals() public constant returns (uint8 decimals) { decimals; }
142     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
143     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
144     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
145 
146     function transfer(address _to, uint256 _value) public returns (bool success);
147     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
148     function approve(address _spender, uint256 _value) public returns (bool success);
149 }
150 
151 
152 /*
153     Token Holder interface
154 */
155 contract ITokenHolder is IOwned {
156     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
157 }
158 
159 
160 /*
161     Smart Token interface
162 */
163 contract ISmartToken is ITokenHolder, IERC20Token {
164     function disableTransfers(bool _disable) public;
165     function issue(address _to, uint256 _amount) public;
166     function destroy(address _from, uint256 _amount) public;
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
203 
204 /**
205     ERC20 Standard Token implementation
206 */
207 contract ERC20Token is IERC20Token, Utils {
208     string public standard = 'Token 0.1';
209     string public name = '';
210     string public symbol = '';
211     uint8 public decimals = 0;
212     uint256 public totalSupply = 0;
213     mapping (address => uint256) public balanceOf;
214     mapping (address => mapping (address => uint256)) public allowance;
215 
216     event Transfer(address indexed _from, address indexed _to, uint256 _value);
217     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
218 
219     /**
220         @dev constructor
221 
222         @param _name        token name
223         @param _symbol      token symbol
224         @param _decimals    decimal points, for display purposes
225     */
226     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
227         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
228 
229         name = _name;
230         symbol = _symbol;
231         decimals = _decimals;
232     }
233 
234     /**
235         @dev send coins
236         throws on any error rather then return a false flag to minimize user errors
237 
238         @param _to      target address
239         @param _value   transfer amount
240 
241         @return true if the transfer was successful, false if it wasn't
242     */
243     function transfer(address _to, uint256 _value)
244         public
245         validAddress(_to)
246         returns (bool success)
247     {
248         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
249         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
250         Transfer(msg.sender, _to, _value);
251         return true;
252     }
253 
254     /**
255         @dev an account/contract attempts to get the coins
256         throws on any error rather then return a false flag to minimize user errors
257 
258         @param _from    source address
259         @param _to      target address
260         @param _value   transfer amount
261 
262         @return true if the transfer was successful, false if it wasn't
263     */
264     function transferFrom(address _from, address _to, uint256 _value)
265         public
266         validAddress(_from)
267         validAddress(_to)
268         returns (bool success)
269     {
270         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
271         balanceOf[_from] = safeSub(balanceOf[_from], _value);
272         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
273         Transfer(_from, _to, _value);
274         return true;
275     }
276 
277     /**
278         @dev allow another account/contract to spend some tokens on your behalf
279         throws on any error rather then return a false flag to minimize user errors
280 
281         also, to minimize the risk of the approve/transferFrom attack vector
282         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
283         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
284 
285         @param _spender approved address
286         @param _value   allowance amount
287 
288         @return true if the approval was successful, false if it wasn't
289     */
290     function approve(address _spender, uint256 _value)
291         public
292         validAddress(_spender)
293         returns (bool success)
294     {
295         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
296         require(_value == 0 || allowance[msg.sender][_spender] == 0);
297 
298         allowance[msg.sender][_spender] = _value;
299         Approval(msg.sender, _spender, _value);
300         return true;
301     }
302 }
303 
304 
305 /*
306     Smart Token v0.3
307 
308     'Owned' is specified here for readability reasons
309 */
310 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
311     string public version = '0.3';
312 
313     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
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
325         @param _name       token name
326         @param _symbol     token short symbol, minimum 1 character
327         @param _decimals   for display purposes only
328     */
329     function SmartToken(string _name, string _symbol, uint8 _decimals)
330         ERC20Token(_name, _symbol, _decimals)
331     {
332         NewSmartToken(address(this));
333     }
334 
335     // allows execution only when transfers aren't disabled
336     modifier transfersAllowed {
337         assert(transfersEnabled);
338         _;
339     }
340 
341     /**
342         @dev disables/enables transfers
343         can only be called by the contract owner
344 
345         @param _disable    true to disable transfers, false to enable them
346     */
347     function disableTransfers(bool _disable) public ownerOnly {
348         transfersEnabled = !_disable;
349     }
350 
351     /**
352         @dev increases the token supply and sends the new tokens to an account
353         can only be called by the contract owner
354 
355         @param _to         account to receive the new amount
356         @param _amount     amount to increase the supply by
357     */
358     function issue(address _to, uint256 _amount)
359         public
360         ownerOnly
361         validAddress(_to)
362         notThis(_to)
363     {
364         totalSupply = safeAdd(totalSupply, _amount);
365         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
366 
367         Issuance(_amount);
368         Transfer(this, _to, _amount);
369     }
370 
371     /**
372         @dev removes tokens from an account and decreases the token supply
373         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
374 
375         @param _from       account to remove the amount from
376         @param _amount     amount to decrease the supply by
377     */
378     function destroy(address _from, uint256 _amount) public {
379         require(msg.sender == _from || msg.sender == owner); // validate input
380 
381         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
382         totalSupply = safeSub(totalSupply, _amount);
383 
384         Transfer(_from, this, _amount);
385         Destruction(_amount);
386     }
387 
388     // ERC20 standard method overrides with some extra functionality
389 
390     /**
391         @dev send coins
392         throws on any error rather then return a false flag to minimize user errors
393         in addition to the standard checks, the function throws if transfers are disabled
394 
395         @param _to      target address
396         @param _value   transfer amount
397 
398         @return true if the transfer was successful, false if it wasn't
399     */
400     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
401         assert(super.transfer(_to, _value));
402         return true;
403     }
404 
405     /**
406         @dev an account/contract attempts to get the coins
407         throws on any error rather then return a false flag to minimize user errors
408         in addition to the standard checks, the function throws if transfers are disabled
409 
410         @param _from    source address
411         @param _to      target address
412         @param _value   transfer amount
413 
414         @return true if the transfer was successful, false if it wasn't
415     */
416     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
417         assert(super.transferFrom(_from, _to, _value));
418         return true;
419     }
420 }