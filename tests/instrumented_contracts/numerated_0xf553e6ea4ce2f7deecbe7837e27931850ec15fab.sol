1 /*
2     Utilities & Common Modifiers
3 */
4 contract Utils {
5     /**
6         constructor
7     */
8     function Utils() public {
9     }
10 
11     // verifies that an amount is greater than zero
12     modifier greaterThanZero(uint256 _amount) {
13         require(_amount > 0);
14         _;
15     }
16 
17     // validates an address - currently only checks that it isn't null
18     modifier validAddress(address _address) {
19         require(_address != address(0));
20         _;
21     }
22 
23     // verifies that the address is different than this contract address
24     modifier notThis(address _address) {
25         require(_address != address(this));
26         _;
27     }
28 
29     // Overflow protected math functions
30 
31     /**
32         @dev returns the sum of _x and _y, asserts if the calculation overflows
33 
34         @param _x   value 1
35         @param _y   value 2
36 
37         @return sum
38     */
39     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
40         uint256 z = _x + _y;
41         assert(z >= _x);
42         return z;
43     }
44 
45     /**
46         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
47 
48         @param _x   minuend
49         @param _y   subtrahend
50 
51         @return difference
52     */
53     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
54         assert(_x >= _y);
55         return _x - _y;
56     }
57 
58     /**
59         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
60 
61         @param _x   factor 1
62         @param _y   factor 2
63 
64         @return product
65     */
66     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
67         uint256 z = _x * _y;
68         assert(_x == 0 || z / _x == _y);
69         return z;
70     }
71 }
72 
73 
74 /*
75     Owned contract interface
76 */
77 contract IOwned {
78     // this function isn't abstract since the compiler emits automatically generated getter functions as external
79     function owner() public view returns (address) {}
80 
81     function transferOwnership(address _newOwner) public;
82     function acceptOwnership() public;
83 }
84 
85 
86 
87 /*
88     Token Holder interface
89 */
90 contract ITokenHolder is IOwned {
91     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
92 }
93 
94 
95 /*
96     Provides support and utilities for contract ownership
97 */
98 contract Owned is IOwned {
99     address public owner;
100     address public newOwner;
101 
102     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
103 
104     /**
105         @dev constructor
106     */
107     function Owned() public {
108         owner = msg.sender;
109     }
110 
111     // allows execution by the owner only
112     modifier ownerOnly {
113         assert(msg.sender == owner);
114         _;
115     }
116 
117     /**
118         @dev allows transferring the contract ownership
119         the new owner still needs to accept the transfer
120         can only be called by the contract owner
121 
122         @param _newOwner    new contract owner
123     */
124     function transferOwnership(address _newOwner) public ownerOnly {
125         require(_newOwner != owner);
126         newOwner = _newOwner;
127     }
128 
129     /**
130         @dev used by a new owner to accept an ownership transfer
131     */
132     function acceptOwnership() public {
133         require(msg.sender == newOwner);
134         emit OwnerUpdate(owner, newOwner);
135         owner = newOwner;
136         newOwner = address(0);
137     }
138 }
139 
140 
141 
142 /*
143     We consider every contract to be a 'token holder' since it's currently not possible
144     for a contract to deny receiving tokens.
145 
146     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
147     the owner to send tokens that were sent to the contract by mistake back to their sender.
148 */
149 contract TokenHolder is ITokenHolder, Owned, Utils {
150     /**
151         @dev constructor
152     */
153     function TokenHolder() public {
154     }
155 
156     /**
157         @dev withdraws tokens held by the contract and sends them to an account
158         can only be called by the owner
159 
160         @param _token   ERC20 token contract address
161         @param _to      account to receive the new amount
162         @param _amount  amount to withdraw
163     */
164     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
165         public
166         ownerOnly
167         validAddress(_token)
168         validAddress(_to)
169         notThis(_to)
170     {
171         assert(_token.transfer(_to, _amount));
172     }
173 }
174 
175 
176 /*
177     ERC20 Standard Token interface
178 */
179 contract IERC20Token {
180     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
181     function name() public view returns (string) {}
182     function symbol() public view returns (string) {}
183     function decimals() public view returns (uint8) {}
184     function totalSupply() public view returns (uint256) {}
185     function balanceOf(address _owner) public view returns (uint256) { _owner; }
186     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
187 
188     function transfer(address _to, uint256 _value) public returns (bool success);
189     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
190     function approve(address _spender, uint256 _value) public returns (bool success);
191 }
192 
193 
194 
195 /**
196     ERC20 Standard Token implementation
197 */
198 contract ERC20Token is IERC20Token, Utils {
199     string public standard = 'Token 0.1';
200     string public name = '';
201     string public symbol = '';
202     uint8 public decimals = 0;
203     uint256 public totalSupply = 0;
204     mapping (address => uint256) public balanceOf;
205     mapping (address => mapping (address => uint256)) public allowance;
206 
207     event Transfer(address indexed _from, address indexed _to, uint256 _value);
208     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
209 
210     /**
211         @dev constructor
212 
213         @param _name        token name
214         @param _symbol      token symbol
215         @param _decimals    decimal points, for display purposes
216     */
217     function ERC20Token(string _name, string _symbol, uint8 _decimals) public {
218         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
219 
220         name = _name;
221         symbol = _symbol;
222         decimals = _decimals;
223     }
224 
225     /**
226         @dev send coins
227         throws on any error rather then return a false flag to minimize user errors
228 
229         @param _to      target address
230         @param _value   transfer amount
231 
232         @return true if the transfer was successful, false if it wasn't
233     */
234     function transfer(address _to, uint256 _value)
235         public
236         validAddress(_to)
237         returns (bool success)
238     {
239         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
240         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
241         emit Transfer(msg.sender, _to, _value);
242         return true;
243     }
244 
245     /**
246         @dev an account/contract attempts to get the coins
247         throws on any error rather then return a false flag to minimize user errors
248 
249         @param _from    source address
250         @param _to      target address
251         @param _value   transfer amount
252 
253         @return true if the transfer was successful, false if it wasn't
254     */
255     function transferFrom(address _from, address _to, uint256 _value)
256         public
257         validAddress(_from)
258         validAddress(_to)
259         returns (bool success)
260     {
261         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
262         balanceOf[_from] = safeSub(balanceOf[_from], _value);
263         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
264         emit Transfer(_from, _to, _value);
265         return true;
266     }
267 
268     /**
269         @dev allow another account/contract to spend some tokens on your behalf
270         throws on any error rather then return a false flag to minimize user errors
271 
272         also, to minimize the risk of the approve/transferFrom attack vector
273         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
274         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
275 
276         @param _spender approved address
277         @param _value   allowance amount
278 
279         @return true if the approval was successful, false if it wasn't
280     */
281     function approve(address _spender, uint256 _value)
282         public
283         validAddress(_spender)
284         returns (bool success)
285     {
286         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
287         require(_value == 0 || allowance[msg.sender][_spender] == 0);
288 
289         allowance[msg.sender][_spender] = _value;
290         emit Approval(msg.sender, _spender, _value);
291         return true;
292     }
293 }
294 
295 
296 
297 /*
298     Smart Token interface
299 */
300 contract ISmartToken is IOwned, IERC20Token {
301     function disableTransfers(bool _disable) public;
302     function issue(address _to, uint256 _amount) public;
303     function destroy(address _from, uint256 _amount) public;
304 }
305 
306 
307 /*
308     Smart Token v0.3
309 
310     'Owned' is specified here for readability reasons
311 */
312 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
313     string public version = '0.3';
314 
315     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
316 
317     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
318     event NewSmartToken(address _token);
319     // triggered when the total supply is increased
320     event Issuance(uint256 _amount);
321     // triggered when the total supply is decreased
322     event Destruction(uint256 _amount);
323 
324     /**
325         @dev constructor
326 
327         @param _name       token name
328         @param _symbol     token short symbol, minimum 1 character
329         @param _decimals   for display purposes only
330     */
331     function SmartToken(string _name, string _symbol, uint8 _decimals)
332         public
333         ERC20Token(_name, _symbol, _decimals)
334     {
335         emit NewSmartToken(address(this));
336     }
337 
338     // allows execution only when transfers aren't disabled
339     modifier transfersAllowed {
340         assert(transfersEnabled);
341         _;
342     }
343 
344     /**
345         @dev disables/enables transfers
346         can only be called by the contract owner
347 
348         @param _disable    true to disable transfers, false to enable them
349     */
350     function disableTransfers(bool _disable) public ownerOnly {
351         transfersEnabled = !_disable;
352     }
353 
354     /**
355         @dev increases the token supply and sends the new tokens to an account
356         can only be called by the contract owner
357 
358         @param _to         account to receive the new amount
359         @param _amount     amount to increase the supply by
360     */
361     function issue(address _to, uint256 _amount)
362         public
363         ownerOnly
364         validAddress(_to)
365         notThis(_to)
366     {
367         totalSupply = safeAdd(totalSupply, _amount);
368         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
369 
370         emit Issuance(_amount);
371         emit Transfer(this, _to, _amount);
372     }
373 
374     /**
375         @dev removes tokens from an account and decreases the token supply
376         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
377 
378         @param _from       account to remove the amount from
379         @param _amount     amount to decrease the supply by
380     */
381     function destroy(address _from, uint256 _amount) public {
382         require(msg.sender == _from || msg.sender == owner); // validate input
383 
384         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
385         totalSupply = safeSub(totalSupply, _amount);
386 
387         emit Transfer(_from, this, _amount);
388         emit Destruction(_amount);
389     }
390 
391     // ERC20 standard method overrides with some extra functionality
392 
393     /**
394         @dev send coins
395         throws on any error rather then return a false flag to minimize user errors
396         in addition to the standard checks, the function throws if transfers are disabled
397 
398         @param _to      target address
399         @param _value   transfer amount
400 
401         @return true if the transfer was successful, false if it wasn't
402     */
403     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
404         assert(super.transfer(_to, _value));
405         return true;
406     }
407 
408     /**
409         @dev an account/contract attempts to get the coins
410         throws on any error rather then return a false flag to minimize user errors
411         in addition to the standard checks, the function throws if transfers are disabled
412 
413         @param _from    source address
414         @param _to      target address
415         @param _value   transfer amount
416 
417         @return true if the transfer was successful, false if it wasn't
418     */
419     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
420         assert(super.transferFrom(_from, _to, _value));
421         return true;
422     }
423 }