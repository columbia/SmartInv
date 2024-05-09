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
33 /*
34     Provides support and utilities for contract ownership
35 */
36 contract Owned is IOwned {
37     address public owner;
38     address public newOwner;
39 
40     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
41 
42     /**
43         @dev constructor
44     */
45     constructor () public {
46         owner = msg.sender;
47     }
48 
49     // allows execution by the owner only
50     modifier ownerOnly {
51         assert(msg.sender == owner);
52         _;
53     }
54 
55     /**
56         @dev allows transferring the contract ownership
57         the new owner still needs to accept the transfer
58         can only be called by the contract owner
59 
60         @param _newOwner    new contract owner
61     */
62     function transferOwnership(address _newOwner) public ownerOnly {
63         require(_newOwner != owner);
64         newOwner = _newOwner;
65     }
66 
67     /**
68         @dev used by a new owner to accept an ownership transfer
69     */
70     function acceptOwnership() public {
71         require(msg.sender == newOwner);
72         emit OwnerUpdate(owner, newOwner);
73         owner = newOwner;
74         newOwner = address(0);
75     }
76 }
77 
78 /*
79     Utilities & Common Modifiers
80 */
81 contract Utils {
82 
83     // verifies that an amount is greater than zero
84     modifier greaterThanZero(uint256 _amount) {
85         require(_amount > 0);
86         _;
87     }
88 
89     // validates an address - currently only checks that it isn't null
90     modifier validAddress(address _address) {
91         require(_address != address(0));
92         _;
93     }
94 
95     // verifies that the address is different than this contract address
96     modifier notThis(address _address) {
97         require(_address != address(this));
98         _;
99     }
100 
101     // Overflow protected math functions
102 
103     /**
104         @dev returns the sum of _x and _y, asserts if the calculation overflows
105 
106         @param _x   value 1
107         @param _y   value 2
108 
109         @return sum
110     */
111     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
112         uint256 z = _x + _y;
113         assert(z >= _x);
114         return z;
115     }
116 
117     /**
118         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
119 
120         @param _x   minuend
121         @param _y   subtrahend
122 
123         @return difference
124     */
125     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
126         assert(_x >= _y);
127         return _x - _y;
128     }
129 
130     /**
131         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
132 
133         @param _x   factor 1
134         @param _y   factor 2
135 
136         @return product
137     */
138     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
139         uint256 z = _x * _y;
140         assert(_x == 0 || z / _x == _y);
141         return z;
142     }
143 }
144 
145 
146 
147 /**
148     ERC20 Standard Token implementation
149 */
150 contract ERC20Token is IERC20Token, Utils {
151     string public standard = "Token 0.1";
152     string public name = "";
153     string public symbol = "";
154     uint8 public decimals = 0;
155     uint256 public totalSupply = 0;
156     mapping (address => uint256) public balanceOf;
157     mapping (address => mapping (address => uint256)) public allowance;
158 
159     event Transfer(address indexed _from, address indexed _to, uint256 _value);
160     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
161 
162     /**
163         @dev constructor
164 
165         @param _name        token name
166         @param _symbol      token symbol
167         @param _decimals    decimal points, for display purposes
168     */
169     constructor(string _name, string _symbol, uint8 _decimals) public {
170         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
171 
172         name = _name;
173         symbol = _symbol;
174         decimals = _decimals;
175     }
176 
177     /**
178         @dev send coins
179         throws on any error rather then return a false flag to minimize user errors
180 
181         @param _to      target address
182         @param _value   transfer amount
183 
184         @return true if the transfer was successful, false if it wasn't
185     */
186     function transfer(address _to, uint256 _value)
187         public
188         validAddress(_to)
189         returns (bool success)
190     {
191         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
192         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
193         emit Transfer(msg.sender, _to, _value);
194         return true;
195     }
196 
197     /**
198         @dev an account/contract attempts to get the coins
199         throws on any error rather then return a false flag to minimize user errors
200 
201         @param _from    source address
202         @param _to      target address
203         @param _value   transfer amount
204 
205         @return true if the transfer was successful, false if it wasn't
206     */
207     function transferFrom(address _from, address _to, uint256 _value)
208         public
209         validAddress(_from)
210         validAddress(_to)
211         returns (bool success)
212     {
213         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
214         balanceOf[_from] = safeSub(balanceOf[_from], _value);
215         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
216         emit Transfer(_from, _to, _value);
217         return true;
218     }
219 
220     /**
221         @dev allow another account/contract to spend some tokens on your behalf
222         throws on any error rather then return a false flag to minimize user errors
223 
224         also, to minimize the risk of the approve/transferFrom attack vector
225         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
226         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
227 
228         @param _spender approved address
229         @param _value   allowance amount
230 
231         @return true if the approval was successful, false if it wasn't
232     */
233     function approve(address _spender, uint256 _value)
234         public
235         validAddress(_spender)
236         returns (bool success)
237     {
238         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
239         require(_value == 0 || allowance[msg.sender][_spender] == 0);
240 
241         allowance[msg.sender][_spender] = _value;
242         emit Approval(msg.sender, _spender, _value);
243         return true;
244     }
245 }
246 
247 
248 
249 
250 
251 
252 
253 
254 
255 /*
256     Token Holder interface
257 */
258 contract ITokenHolder is IOwned {
259     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
260 }
261 
262 
263 /*
264     We consider every contract to be a 'token holder' since it's currently not possible
265     for a contract to deny receiving tokens.
266 
267     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
268     the owner to send tokens that were sent to the contract by mistake back to their sender.
269 */
270 contract TokenHolder is ITokenHolder, Owned, Utils {
271 
272     /**
273         @dev withdraws tokens held by the contract and sends them to an account
274         can only be called by the owner
275 
276         @param _token   ERC20 token contract address
277         @param _to      account to receive the new amount
278         @param _amount  amount to withdraw
279     */
280     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
281         public
282         ownerOnly
283         validAddress(_token)
284         validAddress(_to)
285         notThis(_to)
286     {
287         assert(_token.transfer(_to, _amount));
288     }
289 }
290 
291 
292 
293 
294 
295 
296 
297 
298 
299 
300 /*
301     Smart Token interface
302 */
303 contract ISmartToken is IOwned, IERC20Token {
304     function disableTransfers(bool _disable) public;
305     function issue(address _to, uint256 _amount) public;
306     function destroy(address _from, uint256 _amount) public;
307 }
308 
309 
310 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
311     string public version = "0.3";
312     bool public transfersEnabled = true;
313     event NewSmartToken(address _token);
314     event Issuance(uint256 _amount);
315     event Destruction(uint256 _amount);
316 
317     constructor(string _name, string _symbol, uint8 _decimals)
318         public
319         ERC20Token(_name, _symbol, _decimals)
320     {
321         emit NewSmartToken(address(this));
322     }
323 
324     modifier transfersAllowed {
325         assert(transfersEnabled);
326         _;
327     }
328 
329     function disableTransfers(bool _disable) public ownerOnly {
330         transfersEnabled = !_disable;
331     }
332 
333     function issue(address _to, uint256 _amount)
334         public
335         ownerOnly
336         validAddress(_to)
337         notThis(_to)
338     {
339         totalSupply = safeAdd(totalSupply, _amount);
340         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
341 
342         emit Issuance(_amount);
343         emit Transfer(this, _to, _amount);
344     }
345 
346     function destroy(address _from, uint256 _amount) public {
347         require(msg.sender == _from || msg.sender == owner);
348 
349         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
350         totalSupply = safeSub(totalSupply, _amount);
351 
352         emit Transfer(_from, this, _amount);
353         emit Destruction(_amount);
354     }
355 
356     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
357         assert(super.transfer(_to, _value));
358         return true;
359     }
360 
361     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
362         assert(super.transferFrom(_from, _to, _value));
363         return true;
364     }
365 }