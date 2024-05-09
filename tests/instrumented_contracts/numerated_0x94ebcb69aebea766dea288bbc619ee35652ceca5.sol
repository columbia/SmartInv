1 pragma solidity ^0.4.24;
2 /*
3     Utilities & Common Modifiers
4 */
5 contract Utils {
6     /**
7         constructor
8     */
9     function Utils() public {
10     }
11 
12     // verifies that an amount is greater than zero
13     modifier greaterThanZero(uint256 _amount) {
14         require(_amount > 0);
15         _;
16     }
17 
18     // validates an address - currently only checks that it isn't null
19     modifier validAddress(address _address) {
20         require(_address != address(0));
21         _;
22     }
23 
24     // verifies that the address is different than this contract address
25     modifier notThis(address _address) {
26         require(_address != address(this));
27         _;
28     }
29 
30     // Overflow protected math functions
31 
32     /**
33         @dev returns the sum of _x and _y, asserts if the calculation overflows
34 
35         @param _x   value 1
36         @param _y   value 2
37 
38         @return sum
39     */
40     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
41         uint256 z = _x + _y;
42         assert(z >= _x);
43         return z;
44     }
45 
46     /**
47         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
48 
49         @param _x   minuend
50         @param _y   subtrahend
51 
52         @return difference
53     */
54     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
55         assert(_x >= _y);
56         return _x - _y;
57     }
58 
59     /**
60         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
61 
62         @param _x   factor 1
63         @param _y   factor 2
64 
65         @return product
66     */
67     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
68         uint256 z = _x * _y;
69         assert(_x == 0 || z / _x == _y);
70         return z;
71     }
72 }
73 
74 
75 /*
76     Owned contract interface
77 */
78 contract IOwned {
79     // this function isn't abstract since the compiler emits automatically generated getter functions as external
80     function owner() public view returns (address) {}
81 
82     function transferOwnership(address _newOwner) public;
83     function acceptOwnership() public;
84 }
85 
86 
87 
88 /*
89     Token Holder interface
90 */
91 contract ITokenHolder is IOwned {
92     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
93 }
94 
95 
96 /*
97     Provides support and utilities for contract ownership
98 */
99 contract Owned is IOwned {
100     address public owner;
101     address public newOwner;
102 
103     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
104 
105     /**
106         @dev constructor
107     */
108     function Owned() public {
109         owner = msg.sender;
110     }
111 
112     // allows execution by the owner only
113     modifier ownerOnly {
114         assert(msg.sender == owner);
115         _;
116     }
117 
118     /**
119         @dev allows transferring the contract ownership
120         the new owner still needs to accept the transfer
121         can only be called by the contract owner
122 
123         @param _newOwner    new contract owner
124     */
125     function transferOwnership(address _newOwner) public ownerOnly {
126         require(_newOwner != owner);
127         newOwner = _newOwner;
128     }
129 
130     /**
131         @dev used by a new owner to accept an ownership transfer
132     */
133     function acceptOwnership() public {
134         require(msg.sender == newOwner);
135         emit OwnerUpdate(owner, newOwner);
136         owner = newOwner;
137         newOwner = address(0);
138     }
139 }
140 
141 
142 
143 /*
144     We consider every contract to be a 'token holder' since it's currently not possible
145     for a contract to deny receiving tokens.
146 
147     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
148     the owner to send tokens that were sent to the contract by mistake back to their sender.
149 */
150 contract TokenHolder is ITokenHolder, Owned, Utils {
151     /**
152         @dev constructor
153     */
154     function TokenHolder() public {
155     }
156 
157     /**
158         @dev withdraws tokens held by the contract and sends them to an account
159         can only be called by the owner
160 
161         @param _token   ERC20 token contract address
162         @param _to      account to receive the new amount
163         @param _amount  amount to withdraw
164     */
165     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
166         public
167         ownerOnly
168         validAddress(_token)
169         validAddress(_to)
170         notThis(_to)
171     {
172         assert(_token.transfer(_to, _amount));
173     }
174 }
175 
176 
177 /*
178     ERC20 Standard Token interface
179 */
180 contract IERC20Token {
181     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
182     function name() public view returns (string) {}
183     function symbol() public view returns (string) {}
184     function decimals() public view returns (uint8) {}
185     function totalSupply() public view returns (uint256) {}
186     function balanceOf(address _owner) public view returns (uint256) { _owner; }
187     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
188 
189     function transfer(address _to, uint256 _value) public returns (bool success);
190     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
191     function approve(address _spender, uint256 _value) public returns (bool success);
192 }
193 
194 
195 
196 /**
197     ERC20 Standard Token implementation
198 */
199 contract ERC20Token is IERC20Token, Utils {
200     string public standard = 'Token 0.1';
201     string public name = '';
202     string public symbol = '';
203     uint8 public decimals = 0;
204     uint256 public totalSupply = 0;
205     mapping (address => uint256) public balanceOf;
206     mapping (address => mapping (address => uint256)) public allowance;
207 
208     event Transfer(address indexed _from, address indexed _to, uint256 _value);
209     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
210 
211     /**
212         @dev constructor
213 
214         @param _name        token name
215         @param _symbol      token symbol
216         @param _decimals    decimal points, for display purposes
217     */
218     function ERC20Token(string _name, string _symbol, uint8 _decimals) public {
219         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
220 
221         name = _name;
222         symbol = _symbol;
223         decimals = _decimals;
224     }
225 
226     /**
227         @dev send coins
228         throws on any error rather then return a false flag to minimize user errors
229 
230         @param _to      target address
231         @param _value   transfer amount
232 
233         @return true if the transfer was successful, false if it wasn't
234     */
235     function transfer(address _to, uint256 _value)
236         public
237         validAddress(_to)
238         returns (bool success)
239     {
240         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
241         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
242         emit Transfer(msg.sender, _to, _value);
243         return true;
244     }
245 
246     /**
247         @dev an account/contract attempts to get the coins
248         throws on any error rather then return a false flag to minimize user errors
249 
250         @param _from    source address
251         @param _to      target address
252         @param _value   transfer amount
253 
254         @return true if the transfer was successful, false if it wasn't
255     */
256     function transferFrom(address _from, address _to, uint256 _value)
257         public
258         validAddress(_from)
259         validAddress(_to)
260         returns (bool success)
261     {
262         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
263         balanceOf[_from] = safeSub(balanceOf[_from], _value);
264         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
265         emit Transfer(_from, _to, _value);
266         return true;
267     }
268 
269     /**
270         @dev allow another account/contract to spend some tokens on your behalf
271         throws on any error rather then return a false flag to minimize user errors
272 
273         also, to minimize the risk of the approve/transferFrom attack vector
274         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
275         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
276 
277         @param _spender approved address
278         @param _value   allowance amount
279 
280         @return true if the approval was successful, false if it wasn't
281     */
282     function approve(address _spender, uint256 _value)
283         public
284         validAddress(_spender)
285         returns (bool success)
286     {
287         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
288         require(_value == 0 || allowance[msg.sender][_spender] == 0);
289 
290         allowance[msg.sender][_spender] = _value;
291         emit Approval(msg.sender, _spender, _value);
292         return true;
293     }
294 }
295 
296 
297 
298 /*
299     Smart Token interface
300 */
301 contract ISmartToken is IOwned, IERC20Token {
302     function disableTransfers(bool _disable) public;
303     function issue(address _to, uint256 _amount) public;
304     function destroy(address _from, uint256 _amount) public;
305 }
306 
307 
308 /*
309     Smart Token v0.3
310 
311     'Owned' is specified here for readability reasons
312 */
313 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
314     string public version = '0.3';
315 
316     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
317 
318     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
319     event NewSmartToken(address _token);
320     // triggered when the total supply is increased
321     event Issuance(uint256 _amount);
322     // triggered when the total supply is decreased
323     event Destruction(uint256 _amount);
324 
325     /**
326         @dev constructor
327 
328         @param _name       token name
329         @param _symbol     token short symbol, minimum 1 character
330         @param _decimals   for display purposes only
331     */
332     function SmartToken(string _name, string _symbol, uint8 _decimals)
333         public
334         ERC20Token(_name, _symbol, _decimals)
335     {
336         emit NewSmartToken(address(this));
337     }
338 
339     // allows execution only when transfers aren't disabled
340     modifier transfersAllowed {
341         assert(transfersEnabled);
342         _;
343     }
344 
345     /**
346         @dev disables/enables transfers
347         can only be called by the contract owner
348 
349         @param _disable    true to disable transfers, false to enable them
350     */
351     function disableTransfers(bool _disable) public ownerOnly {
352         transfersEnabled = !_disable;
353     }
354 
355     /**
356         @dev increases the token supply and sends the new tokens to an account
357         can only be called by the contract owner
358 
359         @param _to         account to receive the new amount
360         @param _amount     amount to increase the supply by
361     */
362     function issue(address _to, uint256 _amount)
363         public
364         ownerOnly
365         validAddress(_to)
366         notThis(_to)
367     {
368         totalSupply = safeAdd(totalSupply, _amount);
369         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
370 
371         emit Issuance(_amount);
372         emit Transfer(this, _to, _amount);
373     }
374 
375     /**
376         @dev removes tokens from an account and decreases the token supply
377         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
378 
379         @param _from       account to remove the amount from
380         @param _amount     amount to decrease the supply by
381     */
382     function destroy(address _from, uint256 _amount) public {
383         require(msg.sender == _from || msg.sender == owner); // validate input
384 
385         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
386         totalSupply = safeSub(totalSupply, _amount);
387 
388         emit Transfer(_from, this, _amount);
389         emit Destruction(_amount);
390     }
391 
392     // ERC20 standard method overrides with some extra functionality
393 
394     /**
395         @dev send coins
396         throws on any error rather then return a false flag to minimize user errors
397         in addition to the standard checks, the function throws if transfers are disabled
398 
399         @param _to      target address
400         @param _value   transfer amount
401 
402         @return true if the transfer was successful, false if it wasn't
403     */
404     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
405         assert(super.transfer(_to, _value));
406         return true;
407     }
408 
409     /**
410         @dev an account/contract attempts to get the coins
411         throws on any error rather then return a false flag to minimize user errors
412         in addition to the standard checks, the function throws if transfers are disabled
413 
414         @param _from    source address
415         @param _to      target address
416         @param _value   transfer amount
417 
418         @return true if the transfer was successful, false if it wasn't
419     */
420     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
421         assert(super.transferFrom(_from, _to, _value));
422         return true;
423     }
424 }