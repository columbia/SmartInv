1 pragma solidity ^0.4.11;
2 
3 /*
4     Overflow protected math functions
5 */
6 contract SafeMath {
7     /**
8         constructor
9     */
10     function SafeMath() {
11     }
12 
13     /**
14         @dev returns the sum of _x and _y, asserts if the calculation overflows
15 
16         @param _x   value 1
17         @param _y   value 2
18 
19         @return sum
20     */
21     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
22         uint256 z = _x + _y;
23         assert(z >= _x);
24         return z;
25     }
26 
27     /**
28         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
29 
30         @param _x   minuend
31         @param _y   subtrahend
32 
33         @return difference
34     */
35     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
36         assert(_x >= _y);
37         return _x - _y;
38     }
39 
40     /**
41         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
42 
43         @param _x   factor 1
44         @param _y   factor 2
45 
46         @return product
47     */
48     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
49         uint256 z = _x * _y;
50         assert(_x == 0 || z / _x == _y);
51         return z;
52     }
53 }
54 
55 /*
56     Owned contract interface
57 */
58 contract IOwned {
59     // this function isn't abstract since the compiler emits automatically generated getter functions as external
60     function owner() public constant returns (address owner) { owner; }
61 
62     function transferOwnership(address _newOwner) public;
63     function acceptOwnership() public;
64 }
65 
66 /*
67     Provides support and utilities for contract ownership
68 */
69 contract Owned is IOwned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnerUpdate(address _prevOwner, address _newOwner);
74 
75     /**
76         @dev constructor
77     */
78     function Owned() {
79         owner = msg.sender;
80     }
81 
82     // allows execution by the owner only
83     modifier ownerOnly {
84         assert(msg.sender == owner);
85         _;
86     }
87 
88     /**
89         @dev allows transferring the contract ownership
90         the new owner still need to accept the transfer
91         can only be called by the contract owner
92 
93         @param _newOwner    new contract owner
94     */
95     function transferOwnership(address _newOwner) public ownerOnly {
96         require(_newOwner != owner);
97         newOwner = _newOwner;
98     }
99 
100     /**
101         @dev used by a new owner to accept an ownership transfer
102     */
103     function acceptOwnership() public {
104         require(msg.sender == newOwner);
105         OwnerUpdate(owner, newOwner);
106         owner = newOwner;
107         newOwner = 0x0;
108     }
109 }
110 
111 /*
112     ERC20 Standard Token interface
113 */
114 contract IERC20Token {
115     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
116     function name() public constant returns (string name) { name; }
117     function symbol() public constant returns (string symbol) { symbol; }
118     function decimals() public constant returns (uint8 decimals) { decimals; }
119     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
120     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
121     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
122 
123     function transfer(address _to, uint256 _value) public returns (bool success);
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
125     function approve(address _spender, uint256 _value) public returns (bool success);
126 }
127 
128 /**
129     ERC20 Standard Token implementation
130 */
131 contract ERC20Token is IERC20Token, SafeMath {
132     string public standard = 'Token 0.1';
133     string public name = '';
134     string public symbol = '';
135     uint8 public decimals = 0;
136     uint256 public totalSupply = 0;
137     mapping (address => uint256) public balanceOf;
138     mapping (address => mapping (address => uint256)) public allowance;
139 
140     event Transfer(address indexed _from, address indexed _to, uint256 _value);
141     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
142 
143     /**
144         @dev constructor
145 
146         @param _name        token name
147         @param _symbol      token symbol
148         @param _decimals    decimal points, for display purposes
149     */
150     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
151         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
152 
153         name = _name;
154         symbol = _symbol;
155         decimals = _decimals;
156     }
157 
158     // validates an address - currently only checks that it isn't null
159     modifier validAddress(address _address) {
160         require(_address != 0x0);
161         _;
162     }
163 
164     /**
165         @dev send coins
166         throws on any error rather then return a false flag to minimize user errors
167 
168         @param _to      target address
169         @param _value   transfer amount
170 
171         @return true if the transfer was successful, false if it wasn't
172     */
173     function transfer(address _to, uint256 _value)
174         public
175         validAddress(_to)
176         returns (bool success)
177     {
178         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
179         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
180         Transfer(msg.sender, _to, _value);
181         return true;
182     }
183 
184     /**
185         @dev an account/contract attempts to get the coins
186         throws on any error rather then return a false flag to minimize user errors
187 
188         @param _from    source address
189         @param _to      target address
190         @param _value   transfer amount
191 
192         @return true if the transfer was successful, false if it wasn't
193     */
194     function transferFrom(address _from, address _to, uint256 _value)
195         public
196         validAddress(_from)
197         validAddress(_to)
198         returns (bool success)
199     {
200         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
201         balanceOf[_from] = safeSub(balanceOf[_from], _value);
202         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
203         Transfer(_from, _to, _value);
204         return true;
205     }
206 
207     /**
208         @dev allow another account/contract to spend some tokens on your behalf
209         throws on any error rather then return a false flag to minimize user errors
210 
211         also, to minimize the risk of the approve/transferFrom attack vector
212         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
213         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
214 
215         @param _spender approved address
216         @param _value   allowance amount
217 
218         @return true if the approval was successful, false if it wasn't
219     */
220     function approve(address _spender, uint256 _value)
221         public
222         validAddress(_spender)
223         returns (bool success)
224     {
225         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
226         require(_value == 0 || allowance[msg.sender][_spender] == 0);
227 
228         allowance[msg.sender][_spender] = _value;
229         Approval(msg.sender, _spender, _value);
230         return true;
231     }
232 }
233 
234 /*
235     Token Holder interface
236 */
237 contract ITokenHolder is IOwned {
238     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
239 }
240 
241 /*
242     We consider every contract to be a 'token holder' since it's currently not possible
243     for a contract to deny receiving tokens.
244 
245     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
246     the owner to send tokens that were sent to the contract by mistake back to their sender.
247 */
248 contract TokenHolder is ITokenHolder, Owned {
249     /**
250         @dev constructor
251     */
252     function TokenHolder() {
253     }
254 
255     // validates an address - currently only checks that it isn't null
256     modifier validAddress(address _address) {
257         require(_address != 0x0);
258         _;
259     }
260 
261     // verifies that the address is different than this contract address
262     modifier notThis(address _address) {
263         require(_address != address(this));
264         _;
265     }
266 
267     /**
268         @dev withdraws tokens held by the contract and sends them to an account
269         can only be called by the owner
270 
271         @param _token   ERC20 token contract address
272         @param _to      account to receive the new amount
273         @param _amount  amount to withdraw
274     */
275     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
276         public
277         ownerOnly
278         validAddress(_token)
279         validAddress(_to)
280         notThis(_to)
281     {
282         assert(_token.transfer(_to, _amount));
283     }
284 }
285 
286 /*
287     Ether Token interface
288 */
289 contract IEtherToken is ITokenHolder, IERC20Token {
290     function deposit() public payable;
291     function withdraw(uint256 _amount) public;
292 }
293 
294 /**
295     Ether tokenization contract
296 
297     'Owned' is specified here for readability reasons
298 */
299 contract EtherToken is IEtherToken, ERC20Token, Owned, TokenHolder {
300     // triggered when the total supply is increased
301     event Issuance(uint256 _amount);
302     // triggered when the total supply is decreased
303     event Destruction(uint256 _amount);
304 
305     /**
306         @dev constructor
307     */
308     function EtherToken()
309         ERC20Token('Ether Token', 'ETH', 18) {
310     }
311 
312     /**
313         @dev deposit ether in the account
314     */
315     function deposit()
316         public
317         payable
318     {
319         balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], msg.value); // add the value to the account balance
320         totalSupply = safeAdd(totalSupply, msg.value); // increase the total supply
321 
322         Issuance(msg.value);
323         Transfer(this, msg.sender, msg.value);
324     }
325 
326     /**
327         @dev withdraw ether from the account
328 
329         @param _amount  amount of ether to withdraw
330     */
331     function withdraw(uint256 _amount) public {
332         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _amount); // deduct the amount from the account balance
333         totalSupply = safeSub(totalSupply, _amount); // decrease the total supply
334         assert(msg.sender.send(_amount)); // send the amount
335 
336         Transfer(msg.sender, this, _amount);
337         Destruction(_amount);
338     }
339 
340     // ERC20 standard method overrides with some extra protection
341 
342     /**
343         @dev send coins
344         throws on any error rather then return a false flag to minimize user errors
345 
346         @param _to      target address
347         @param _value   transfer amount
348 
349         @return true if the transfer was successful, false if it wasn't
350     */
351     function transfer(address _to, uint256 _value)
352         public
353         returns (bool success)
354     {
355         require(_to != address(this));
356         assert(super.transfer(_to, _value));
357         return true;
358     }
359 
360     /**
361         @dev an account/contract attempts to get the coins
362         throws on any error rather then return a false flag to minimize user errors
363 
364         @param _from    source address
365         @param _to      target address
366         @param _value   transfer amount
367 
368         @return true if the transfer was successful, false if it wasn't
369     */
370     function transferFrom(address _from, address _to, uint256 _value)
371         public
372         returns (bool success)
373     {
374         require(_to != address(this));
375         assert(super.transferFrom(_from, _to, _value));
376         return true;
377     }
378 
379     /**
380         @dev deposit ether in the account
381     */
382     function() public payable {
383         deposit();
384     }
385 }