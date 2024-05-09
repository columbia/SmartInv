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
75 /*
76     Owned contract interface
77 */
78 contract IOwned {
79     // this function isn't abstract since the compiler emits automatically generated getter functions as external
80     function owner() public constant returns (address owner) { owner; }
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
132     Token Holder interface
133 */
134 contract ITokenHolder is IOwned {
135     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
136 }
137 
138 /*
139     We consider every contract to be a 'token holder' since it's currently not possible
140     for a contract to deny receiving tokens.
141 
142     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
143     the owner to send tokens that were sent to the contract by mistake back to their sender.
144 */
145 contract TokenHolder is ITokenHolder, Owned, Utils {
146     /**
147         @dev constructor
148     */
149     function TokenHolder() {
150     }
151 
152     /**
153         @dev withdraws tokens held by the contract and sends them to an account
154         can only be called by the owner
155 
156         @param _token   ERC20 token contract address
157         @param _to      account to receive the new amount
158         @param _amount  amount to withdraw
159     */
160     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
161         public
162         ownerOnly
163         validAddress(_token)
164         validAddress(_to)
165         notThis(_to)
166     {
167         assert(_token.transfer(_to, _amount));
168     }
169 }
170 
171 /*
172     ERC20 Standard Token interface
173 */
174 contract IERC20Token {
175     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
176     function name() public constant returns (string name) { name; }
177     function symbol() public constant returns (string symbol) { symbol; }
178     function decimals() public constant returns (uint8 decimals) { decimals; }
179     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
180     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
181     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
182 
183     function transfer(address _to, uint256 _value) public returns (bool success);
184     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
185     function approve(address _spender, uint256 _value) public returns (bool success);
186 }
187 
188 /**
189     ERC20 Standard Token implementation
190 */
191 contract ERC20Token is IERC20Token, Utils {
192     string public standard = 'Token 0.1';
193     string public name = '';
194     string public symbol = '';
195     uint8 public decimals = 0;
196     uint256 public totalSupply = 0;
197     mapping (address => uint256) public balanceOf;
198     mapping (address => mapping (address => uint256)) public allowance;
199 
200     event Transfer(address indexed _from, address indexed _to, uint256 _value);
201     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
202 
203     /**
204         @dev constructor
205 
206         @param _name        token name
207         @param _symbol      token symbol
208         @param _decimals    decimal points, for display purposes
209     */
210     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
211         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
212 
213         name = _name;
214         symbol = _symbol;
215         decimals = _decimals;
216     }
217 
218     /**
219         @dev send coins
220         throws on any error rather then return a false flag to minimize user errors
221 
222         @param _to      target address
223         @param _value   transfer amount
224 
225         @return true if the transfer was successful, false if it wasn't
226     */
227     function transfer(address _to, uint256 _value)
228         public
229         validAddress(_to)
230         returns (bool success)
231     {
232         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
233         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
234         Transfer(msg.sender, _to, _value);
235         return true;
236     }
237 
238     /**
239         @dev an account/contract attempts to get the coins
240         throws on any error rather then return a false flag to minimize user errors
241 
242         @param _from    source address
243         @param _to      target address
244         @param _value   transfer amount
245 
246         @return true if the transfer was successful, false if it wasn't
247     */
248     function transferFrom(address _from, address _to, uint256 _value)
249         public
250         validAddress(_from)
251         validAddress(_to)
252         returns (bool success)
253     {
254         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
255         balanceOf[_from] = safeSub(balanceOf[_from], _value);
256         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
257         Transfer(_from, _to, _value);
258         return true;
259     }
260 
261     /**
262         @dev allow another account/contract to spend some tokens on your behalf
263         throws on any error rather then return a false flag to minimize user errors
264 
265         also, to minimize the risk of the approve/transferFrom attack vector
266         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
267         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
268 
269         @param _spender approved address
270         @param _value   allowance amount
271 
272         @return true if the approval was successful, false if it wasn't
273     */
274     function approve(address _spender, uint256 _value)
275         public
276         validAddress(_spender)
277         returns (bool success)
278     {
279         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
280         require(_value == 0 || allowance[msg.sender][_spender] == 0);
281 
282         allowance[msg.sender][_spender] = _value;
283         Approval(msg.sender, _spender, _value);
284         return true;
285     }
286 }
287 
288 /*
289     Ether Token interface
290 */
291 contract IEtherToken is ITokenHolder, IERC20Token {
292     function deposit() public payable;
293     function withdraw(uint256 _amount) public;
294     function withdrawTo(address _to, uint256 _amount);
295 }
296 
297 /**
298     Ether tokenization contract
299 
300     'Owned' is specified here for readability reasons
301 */
302 contract EtherToken2 is IEtherToken, Owned, ERC20Token, TokenHolder {
303     // triggered when the total supply is increased
304     event Issuance(uint256 _amount);
305     // triggered when the total supply is decreased
306     event Destruction(uint256 _amount);
307 
308     /**
309         @dev constructor
310     */
311     function EtherToken2()
312         ERC20Token('Ether Token', 'ETH', 18) {
313     }
314 
315     /**
316         @dev deposit ether in the account
317     */
318     function deposit() public payable {
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
332         withdrawTo(msg.sender, _amount);
333     }
334 
335     /**
336         @dev withdraw ether from the account to a target account
337 
338         @param _to      account to receive the ether
339         @param _amount  amount of ether to withdraw
340     */
341     function withdrawTo(address _to, uint256 _amount)
342         public
343         notThis(_to)
344     {
345         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _amount); // deduct the amount from the account balance
346         totalSupply = safeSub(totalSupply, _amount); // decrease the total supply
347         _to.transfer(_amount); // send the amount to the target account
348 
349         Transfer(msg.sender, this, _amount);
350         Destruction(_amount);
351     }
352 
353     // ERC20 standard method overrides with some extra protection
354 
355     /**
356         @dev send coins
357         throws on any error rather then return a false flag to minimize user errors
358 
359         @param _to      target address
360         @param _value   transfer amount
361 
362         @return true if the transfer was successful, false if it wasn't
363     */
364     function transfer(address _to, uint256 _value)
365         public
366         notThis(_to)
367         returns (bool success)
368     {
369         assert(super.transfer(_to, _value));
370         return true;
371     }
372 
373     /**
374         @dev an account/contract attempts to get the coins
375         throws on any error rather then return a false flag to minimize user errors
376 
377         @param _from    source address
378         @param _to      target address
379         @param _value   transfer amount
380 
381         @return true if the transfer was successful, false if it wasn't
382     */
383     function transferFrom(address _from, address _to, uint256 _value)
384         public
385         notThis(_to)
386         returns (bool success)
387     {
388         assert(super.transferFrom(_from, _to, _value));
389         return true;
390     }
391 
392     /**
393         @dev deposit ether in the account
394     */
395     function() public payable {
396         deposit();
397     }
398 }