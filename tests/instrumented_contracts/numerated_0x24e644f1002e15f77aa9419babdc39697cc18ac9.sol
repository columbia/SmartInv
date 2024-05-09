1 pragma solidity ^0.4.14;
2 
3 /** 
4     Owned contract interface
5 */
6 contract IOwned {
7     // this function isn't abstract since the compiler emits automatically generated getter functions as external
8     function owner() public constant { owner; }
9 
10     function transferOwnership(address _newOwner) public;
11     function acceptOwnership() public;
12 }
13 
14 /**
15     ERC20 Standard Token interface
16 */
17 contract IERC20Token {
18     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
19     function name() public constant returns (string) {}
20     function symbol() public constant returns (string) {}
21     function decimals() public constant returns (uint8) {}
22     function totalSupply() public constant returns (uint256) {}
23     function balanceOf(address _owner) public constant returns (uint256) { _owner; }
24     function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }
25 
26     function transfer(address _to, uint256 _value) public returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28     function approve(address _spender, uint256 _value) public returns (bool success);
29 }
30 
31 
32 /**
33     Token interface
34 */
35 contract IToken is IOwned, IERC20Token {
36     function disableTransfers(bool _disable) public;
37     function issue(address _to, uint256 _amount) public;
38     function destroy(address _from, uint256 _amount) public;
39 }
40 
41 
42 /*
43     Provides support and utilities for contract ownership
44 */
45 contract Owned is IOwned {
46     address public owner;
47     address public newOwner;
48 
49     event OwnerUpdate(address _prevOwner, address _newOwner);
50 
51     /**
52         @dev constructor
53     */
54     function Owned() {
55         owner = msg.sender;
56     }
57 
58     // allows execution by the owner only
59     modifier ownerOnly {
60         assert(msg.sender == owner);
61         _;
62     }
63 
64     /**
65         @dev allows transferring the contract ownership
66         the new owner still needs to accept the transfer
67         can only be called by the contract owner
68 
69         @param _newOwner    new contract owner
70     */
71     function transferOwnership(address _newOwner) public ownerOnly {
72         require(_newOwner != owner);
73         newOwner = _newOwner;
74     }
75 
76     /**
77         @dev used by a new owner to accept an ownership transfer
78     */
79     function acceptOwnership() public {
80         require(msg.sender == newOwner);
81         OwnerUpdate(owner, newOwner);
82         owner = newOwner;
83         newOwner = 0x0;
84     }
85 }
86 
87 /*
88     Utilities & Common Modifiers
89 */
90 contract Utils {
91     /**
92         constructor
93     */
94     function Utils() {
95     }
96 
97     // verifies that an amount is greater than zero
98     modifier greaterThanZero(uint256 _amount) {
99         require(_amount > 0);
100         _;
101     }
102 
103     // validates an address - currently only checks that it isn't null
104     modifier validAddress(address _address) {
105         require(_address != 0x0);
106         _;
107     }
108 
109     // verifies that the address is different than this contract address
110     modifier notThis(address _address) {
111         require(_address != address(this));
112         _;
113     }
114 
115     // Overflow protected math functions
116 
117     /**
118         @dev returns the sum of _x and _y, asserts if the calculation overflows
119 
120         @param _x   value 1
121         @param _y   value 2
122 
123         @return sum
124     */
125     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
126         uint256 z = _x + _y;
127         assert(z >= _x);
128         return z;
129     }
130 
131     /**
132         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
133 
134         @param _x   minuend
135         @param _y   subtrahend
136 
137         @return difference
138     */
139     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
140         assert(_x >= _y);
141         return _x - _y;
142     }
143 
144     /**
145         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
146 
147         @param _x   factor 1
148         @param _y   factor 2
149 
150         @return product
151     */
152     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
153         uint256 z = _x * _y;
154         assert(_x == 0 || z / _x == _y);
155         return z;
156     }
157 }
158 
159 
160 /**
161     ERC20 Standard Token implementation
162 */
163 contract ERC20Token is IERC20Token, Utils {
164     string public standard = "Token 0.1";
165     string public name = "";
166     string public symbol = "";
167     uint8 public decimals = 0;
168     uint256 public totalSupply = 0;
169     mapping (address => uint256) public balanceOf;
170     mapping (address => mapping (address => uint256)) public allowance;
171 
172     event Transfer(address indexed _from, address indexed _to, uint256 _value);
173     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
174 
175     /**
176         @dev constructor
177 
178         @param _name        token name
179         @param _symbol      token symbol
180         @param _decimals    decimal points, for display purposes
181     */
182     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
183         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
184 
185         name = _name;
186         symbol = _symbol;
187         decimals = _decimals;
188     }
189 
190     /**
191         @dev send coins
192         throws on any error rather then return a false flag to minimize user errors
193 
194         @param _to      target address
195         @param _value   transfer amount
196 
197         @return true if the transfer was successful, false if it wasn't
198     */
199     function transfer(address _to, uint256 _value)
200         public
201         validAddress(_to)
202         returns (bool success)
203     {
204         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
205         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
206         Transfer(msg.sender, _to, _value);
207         return true;
208     }
209 
210     /**
211         @dev an account/contract attempts to get the coins
212         throws on any error rather then return a false flag to minimize user errors
213 
214         @param _from    source address
215         @param _to      target address
216         @param _value   transfer amount
217 
218         @return true if the transfer was successful, false if it wasn't
219     */
220     function transferFrom(address _from, address _to, uint256 _value)
221         public
222         validAddress(_from)
223         validAddress(_to)
224         returns (bool success)
225     {
226         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
227         balanceOf[_from] = safeSub(balanceOf[_from], _value);
228         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
229         Transfer(_from, _to, _value);
230         return true;
231     }
232 
233     /**
234         @dev allow another account/contract to spend some tokens on your behalf
235         throws on any error rather then return a false flag to minimize user errors
236 
237         also, to minimize the risk of the approve/transferFrom attack vector
238         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
239         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
240 
241         @param _spender approved address
242         @param _value   allowance amount
243 
244         @return true if the approval was successful, false if it wasn't
245     */
246     function approve(address _spender, uint256 _value)
247         public
248         validAddress(_spender)
249         returns (bool success)
250     {
251         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
252         require(_value == 0 || allowance[msg.sender][_spender] == 0);
253 
254         allowance[msg.sender][_spender] = _value;
255         Approval(msg.sender, _spender, _value);
256         return true;
257     }
258 }
259 
260 
261 /**
262     Phantom AI Token Receipt v0.1
263 
264     ** This is temporary token util the end of crowdsale **
265 
266     'Owned' is specified here for readability reasons
267 */
268 contract PAIReceipt is IToken, Owned, ERC20Token {
269     string public version = "0.1";
270 
271     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
272 
273     // triggered when a pai token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
274     event NewPAIReceipt(address _token);
275     // triggered when the total supply is increased
276     event Issuance(uint256 _amount);
277     // triggered when the total supply is decreased
278     event Destruction(uint256 _amount);
279 
280     /**
281         @dev constructor
282     */
283     function PAIReceipt()
284         ERC20Token("Phantom AI Token Receipt", "PAIR", 18)
285     {
286         NewPAIReceipt(address(this));
287     }
288 
289     // allows execution only when transfers aren't disabled
290     modifier transfersAllowed {
291         assert(transfersEnabled);
292         _;
293     }
294 
295     /**
296         @dev disables/enables transfers
297         can only be called by the contract owner
298 
299         @param _disable    true to disable transfers, false to enable them
300     */
301     function disableTransfers(bool _disable) public ownerOnly {
302         transfersEnabled = !_disable;
303     }
304 
305     /**
306         @dev increases the token supply and sends the new tokens to an account
307         can only be called by the contract owner
308 
309         @param _to         account to receive the new amount
310         @param _amount     amount to increase the supply by
311     */
312     function issue(address _to, uint256 _amount)
313         public
314         ownerOnly
315         validAddress(_to)
316         notThis(_to)
317     {
318         totalSupply = safeAdd(totalSupply, _amount);
319         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
320 
321         Issuance(_amount);
322         Transfer(this, _to, _amount);
323     }
324 
325     /**
326         @dev removes tokens from an account and decreases the token supply
327         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
328 
329         @param _from       account to remove the amount from
330         @param _amount     amount to decrease the supply by
331     */
332     function destroy(address _from, uint256 _amount) public {
333         require(msg.sender == _from || msg.sender == owner); // validate input
334 
335         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
336         totalSupply = safeSub(totalSupply, _amount);
337 
338         Transfer(_from, this, _amount);
339         Destruction(_amount);
340     }
341 
342     // ERC20 standard method overrides with some extra functionality
343 
344     /**
345         @dev send coins
346         throws on any error rather then return a false flag to minimize user errors
347         in addition to the standard checks, the function throws if transfers are disabled
348 
349         @param _to      target address
350         @param _value   transfer amount
351 
352         @return true if the transfer was successful, false if it wasn't
353     */
354     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
355         assert(super.transfer(_to, _value));
356         return true;
357     }
358 
359     /**
360         @dev an account/contract attempts to get the coins
361         throws on any error rather then return a false flag to minimize user errors
362         in addition to the standard checks, the function throws if transfers are disabled
363 
364         @param _from    source address
365         @param _to      target address
366         @param _value   transfer amount
367 
368         @return true if the transfer was successful, false if it wasn't
369     */
370     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
371         assert(super.transferFrom(_from, _to, _value));
372         return true;
373     }
374 }