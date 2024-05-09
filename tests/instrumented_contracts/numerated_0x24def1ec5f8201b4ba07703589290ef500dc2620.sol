1 pragma solidity ^0.4.18;
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
20 
21 /*
22     Owned contract interface
23 */
24 contract IOwned {
25     // this function isn't abstract since the compiler emits automatically generated getter functions as external
26     function owner() public view returns (address) {}
27 
28     function transferOwnership(address _newOwner) public;
29     function acceptOwnership() public;
30 }
31 
32 
33 
34 
35 /*
36     Utilities & Common Modifiers
37 */
38 contract Utils {
39 
40     // verifies that an amount is greater than zero
41     modifier greaterThanZero(uint256 _amount) {
42         require(_amount > 0);
43         _;
44     }
45 
46     // validates an address - currently only checks that it isn't null
47     modifier validAddress(address _address) {
48         require(_address != address(0));
49         _;
50     }
51 
52     // verifies that the address is different than this contract address
53     modifier notThis(address _address) {
54         require(_address != address(this));
55         _;
56     }
57 
58     // Overflow protected math functions
59 
60     /**
61         @dev returns the sum of _x and _y, asserts if the calculation overflows
62 
63         @param _x   value 1
64         @param _y   value 2
65 
66         @return sum
67     */
68     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
69         uint256 z = _x + _y;
70         assert(z >= _x);
71         return z;
72     }
73 
74     /**
75         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
76 
77         @param _x   minuend
78         @param _y   subtrahend
79 
80         @return difference
81     */
82     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
83         assert(_x >= _y);
84         return _x - _y;
85     }
86 
87     /**
88         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
89 
90         @param _x   factor 1
91         @param _y   factor 2
92 
93         @return product
94     */
95     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
96         uint256 z = _x * _y;
97         assert(_x == 0 || z / _x == _y);
98         return z;
99     }
100 }
101 
102 
103 
104 /**
105     ERC20 Standard Token implementation
106 */
107 contract ERC20Token is IERC20Token, Utils {
108     string public standard = "Token 0.1";
109     string public name = "";
110     string public symbol = "";
111     uint8 public decimals = 0;
112     uint256 public totalSupply = 0;
113     mapping (address => uint256) public balanceOf;
114     mapping (address => mapping (address => uint256)) public allowance;
115 
116     event Transfer(address indexed _from, address indexed _to, uint256 _value);
117     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
118 
119     /**
120         @dev constructor
121 
122         @param _name        token name
123         @param _symbol      token symbol
124         @param _decimals    decimal points, for display purposes
125     */
126     constructor(string _name, string _symbol, uint8 _decimals) public {
127         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
128 
129         name = _name;
130         symbol = _symbol;
131         decimals = _decimals;
132     }
133 
134     /**
135         @dev send coins
136         throws on any error rather then return a false flag to minimize user errors
137 
138         @param _to      target address
139         @param _value   transfer amount
140 
141         @return true if the transfer was successful, false if it wasn't
142     */
143     function transfer(address _to, uint256 _value)
144         public
145         validAddress(_to)
146         returns (bool success)
147     {
148         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
149         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
150         emit Transfer(msg.sender, _to, _value);
151         return true;
152     }
153 
154     /**
155         @dev an account/contract attempts to get the coins
156         throws on any error rather then return a false flag to minimize user errors
157 
158         @param _from    source address
159         @param _to      target address
160         @param _value   transfer amount
161 
162         @return true if the transfer was successful, false if it wasn't
163     */
164     function transferFrom(address _from, address _to, uint256 _value)
165         public
166         validAddress(_from)
167         validAddress(_to)
168         returns (bool success)
169     {
170         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
171         balanceOf[_from] = safeSub(balanceOf[_from], _value);
172         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
173         emit Transfer(_from, _to, _value);
174         return true;
175     }
176 
177     /**
178         @dev allow another account/contract to spend some tokens on your behalf
179         throws on any error rather then return a false flag to minimize user errors
180 
181         also, to minimize the risk of the approve/transferFrom attack vector
182         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
183         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
184 
185         @param _spender approved address
186         @param _value   allowance amount
187 
188         @return true if the approval was successful, false if it wasn't
189     */
190     function approve(address _spender, uint256 _value)
191         public
192         validAddress(_spender)
193         returns (bool success)
194     {
195         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
196         require(_value == 0 || allowance[msg.sender][_spender] == 0);
197 
198         allowance[msg.sender][_spender] = _value;
199         emit Approval(msg.sender, _spender, _value);
200         return true;
201     }
202 }
203 
204 
205 
206 
207 
208 
209 
210 
211 
212 /*
213     Token Holder interface
214 */
215 contract ITokenHolder is IOwned {
216     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
217 }
218 
219 
220 /*
221     Provides support and utilities for contract ownership
222 */
223 contract Owned is IOwned {
224     address public owner;
225     address public newOwner;
226 
227     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
228 
229     /**
230         @dev constructor
231     */
232     constructor () public {
233         owner = msg.sender;
234     }
235 
236     // allows execution by the owner only
237     modifier ownerOnly {
238         assert(msg.sender == owner);
239         _;
240     }
241 
242     /**
243         @dev allows transferring the contract ownership
244         the new owner still needs to accept the transfer
245         can only be called by the contract owner
246 
247         @param _newOwner    new contract owner
248     */
249     function transferOwnership(address _newOwner) public ownerOnly {
250         require(_newOwner != owner);
251         newOwner = _newOwner;
252     }
253 
254     function setOwner(address _newOwner) public ownerOnly {
255         emit OwnerUpdate(owner, _newOwner);
256         owner = _newOwner;
257     }
258 
259     /**
260         @dev used by a new owner to accept an ownership transfer
261     */
262     function acceptOwnership() public {
263         require(msg.sender == newOwner);
264         emit OwnerUpdate(owner, newOwner);
265         owner = newOwner;
266         newOwner = address(0);
267     }
268 }
269 
270 /*
271     We consider every contract to be a 'token holder' since it's currently not possible
272     for a contract to deny receiving tokens.
273 
274     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
275     the owner to send tokens that were sent to the contract by mistake back to their sender.
276 */
277 contract TokenHolder is ITokenHolder, Owned, Utils {
278 
279     /**
280         @dev withdraws tokens held by the contract and sends them to an account
281         can only be called by the owner
282 
283         @param _token   ERC20 token contract address
284         @param _to      account to receive the new amount
285         @param _amount  amount to withdraw
286     */
287     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
288         public
289         ownerOnly
290         validAddress(_token)
291         validAddress(_to)
292         notThis(_to)
293     {
294         assert(_token.transfer(_to, _amount));
295     }
296 }
297 
298 
299 
300 
301 
302 
303 
304 
305 
306 /*
307     Smart Token interface
308 */
309 contract ISmartToken is IOwned, IERC20Token {
310     function disableTransfers(bool _disable) public;
311     function issue(address _to, uint256 _amount) public;
312     function destroy(address _from, uint256 _amount) public;
313 }
314 
315 
316 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
317     string public version = "";
318     bool public transfersEnabled = true;
319     event NewSmartToken(address _token);
320     event Issuance(uint256 _amount);
321     event Destruction(uint256 _amount);
322 
323     constructor(string _name, string _symbol, uint8 _decimals)
324         public
325         ERC20Token(_name, _symbol, _decimals)
326     {
327         emit NewSmartToken(address(this));
328     }
329 
330     modifier transfersAllowed {
331         assert(transfersEnabled);
332         _;
333     }
334 
335     function disableTransfers(bool _disable) public ownerOnly {
336         transfersEnabled = !_disable;
337     }
338 
339     function issue(address _to, uint256 _amount)
340         public
341         ownerOnly
342         validAddress(_to)
343         notThis(_to)
344     {
345         totalSupply = safeAdd(totalSupply, _amount);
346         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
347 
348         emit Issuance(_amount);
349         emit Transfer(this, _to, _amount);
350     }
351 
352     function destroy(address _from, uint256 _amount) public {
353         require(msg.sender == _from || msg.sender == owner);
354 
355         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
356         totalSupply = safeSub(totalSupply, _amount);
357 
358         emit Transfer(_from, this, _amount);
359         emit Destruction(_amount);
360     }
361 
362     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
363         assert(super.transfer(_to, _value));
364         return true;
365     }
366 
367     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
368         assert(super.transferFrom(_from, _to, _value));
369         return true;
370     }
371 }
372 
373 
374 contract TokenFactory {
375 
376     address public lastTokenCreated;
377 
378     function newToken(string _name, string _symbol, uint _initialSupply) public {
379         SmartToken smartToken = new SmartToken(_name, _symbol, 18);
380         smartToken.issue(msg.sender, _initialSupply);
381         smartToken.setOwner(msg.sender);
382         lastTokenCreated = address(smartToken);
383     }
384 }