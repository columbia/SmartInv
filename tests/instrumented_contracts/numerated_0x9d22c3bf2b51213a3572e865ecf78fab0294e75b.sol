1 pragma solidity ^0.4.13;
2 
3 contract Utils {
4     /**
5         constructor
6     */
7     function Utils() {
8     }
9 
10     // verifies that an amount is greater than zero
11     modifier greaterThanZero(uint256 _amount) {
12         require(_amount > 0);
13         _;
14     }
15 
16     // validates an address - currently only checks that it isn't null
17     modifier validAddress(address _address) {
18         require(_address != 0x0);
19         _;
20     }
21 
22     // verifies that the address is different than this contract address
23     modifier notThis(address _address) {
24         require(_address != address(this));
25         _;
26     }
27 
28     // Overflow protected math functions
29 
30     /**
31         @dev returns the sum of _x and _y, asserts if the calculation overflows
32 
33         @param _x   value 1
34         @param _y   value 2
35 
36         @return sum
37     */
38     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
39         uint256 z = _x + _y;
40         assert(z >= _x);
41         return z;
42     }
43 
44     /**
45         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
46 
47         @param _x   minuend
48         @param _y   subtrahend
49 
50         @return difference
51     */
52     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
53         assert(_x >= _y);
54         return _x - _y;
55     }
56 
57     /**
58         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
59 
60         @param _x   factor 1
61         @param _y   factor 2
62 
63         @return product
64     */
65     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
66         uint256 z = _x * _y;
67         assert(_x == 0 || z / _x == _y);
68         return z;
69     }
70 }
71 
72 contract IERC20Token {
73     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
74     function name() public constant returns (string name) { name; }
75     function symbol() public constant returns (string symbol) { symbol; }
76     function decimals() public constant returns (uint8 decimals) { decimals; }
77     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
78     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
79     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
80 
81     function transfer(address _to, uint256 _value) public returns (bool success);
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
83     function approve(address _spender, uint256 _value) public returns (bool success);
84 }
85 
86 contract ERC20Token is IERC20Token, Utils {
87     string public standard = 'Token 0.1';
88     string public name = '';
89     string public symbol = '';
90     uint8 public decimals = 0;
91     uint256 public totalSupply = 0;
92     mapping (address => uint256) public balanceOf;
93     mapping (address => mapping (address => uint256)) public allowance;
94 
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 
98     /**
99         @dev constructor
100 
101         @param _name        token name
102         @param _symbol      token symbol
103         @param _decimals    decimal points, for display purposes
104     */
105     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
106         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
107 
108         name = _name;
109         symbol = _symbol;
110         decimals = _decimals;
111     }
112 
113     /**
114         @dev send coins
115         throws on any error rather then return a false flag to minimize user errors
116 
117         @param _to      target address
118         @param _value   transfer amount
119 
120         @return true if the transfer was successful, false if it wasn't
121     */
122     function transfer(address _to, uint256 _value)
123         public
124         validAddress(_to)
125         returns (bool success)
126     {
127         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
128         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
129         Transfer(msg.sender, _to, _value);
130         return true;
131     }
132 
133     /**
134         @dev an account/contract attempts to get the coins
135         throws on any error rather then return a false flag to minimize user errors
136 
137         @param _from    source address
138         @param _to      target address
139         @param _value   transfer amount
140 
141         @return true if the transfer was successful, false if it wasn't
142     */
143     function transferFrom(address _from, address _to, uint256 _value)
144         public
145         validAddress(_from)
146         validAddress(_to)
147         returns (bool success)
148     {
149         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
150         balanceOf[_from] = safeSub(balanceOf[_from], _value);
151         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
152         Transfer(_from, _to, _value);
153         return true;
154     }
155 
156     /**
157         @dev allow another account/contract to spend some tokens on your behalf
158         throws on any error rather then return a false flag to minimize user errors
159 
160         also, to minimize the risk of the approve/transferFrom attack vector
161         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
162         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
163 
164         @param _spender approved address
165         @param _value   allowance amount
166 
167         @return true if the approval was successful, false if it wasn't
168     */
169     function approve(address _spender, uint256 _value)
170         public
171         validAddress(_spender)
172         returns (bool success)
173     {
174         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
175         require(_value == 0 || allowance[msg.sender][_spender] == 0);
176 
177         allowance[msg.sender][_spender] = _value;
178         Approval(msg.sender, _spender, _value);
179         return true;
180     }
181 }
182 
183 contract IOwned {
184     // this function isn't abstract since the compiler emits automatically generated getter functions as external
185     function owner() public constant returns (address owner) { owner; }
186 
187     function transferOwnership(address _newOwner) public;
188     function acceptOwnership() public;
189 }
190 
191 contract Owned is IOwned {
192     address public owner;
193     address public newOwner;
194 
195     event OwnerUpdate(address _prevOwner, address _newOwner);
196 
197     /**
198         @dev constructor
199     */
200     function Owned() {
201         owner = msg.sender;
202     }
203 
204     // allows execution by the owner only
205     modifier ownerOnly {
206         assert(msg.sender == owner);
207         _;
208     }
209 
210     /**
211         @dev allows transferring the contract ownership
212         the new owner still needs to accept the transfer
213         can only be called by the contract owner
214 
215         @param _newOwner    new contract owner
216     */
217     function transferOwnership(address _newOwner) public ownerOnly {
218         require(_newOwner != owner);
219         newOwner = _newOwner;
220     }
221 
222     /**
223         @dev used by a new owner to accept an ownership transfer
224     */
225     function acceptOwnership() public {
226         require(msg.sender == newOwner);
227         OwnerUpdate(owner, newOwner);
228         owner = newOwner;
229         newOwner = 0x0;
230     }
231 }
232 
233 contract ITokenHolder is IOwned {
234     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
235 }
236 
237 contract TokenHolder is ITokenHolder, Owned, Utils {
238     /**
239         @dev constructor
240     */
241     function TokenHolder() {
242     }
243 
244     /**
245         @dev withdraws tokens held by the contract and sends them to an account
246         can only be called by the owner
247 
248         @param _token   ERC20 token contract address
249         @param _to      account to receive the new amount
250         @param _amount  amount to withdraw
251     */
252     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
253         public
254         ownerOnly
255         validAddress(_token)
256         validAddress(_to)
257         notThis(_to)
258     {
259         assert(_token.transfer(_to, _amount));
260     }
261 }
262 
263 contract ISmartToken is ITokenHolder, IERC20Token {
264     function disableTransfers(bool _disable) public;
265     function issue(address _to, uint256 _amount) public;
266     function destroy(address _from, uint256 _amount) public;
267 }
268 
269 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
270     string public version = '0.3';
271 
272     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
273 
274     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
275     event NewSmartToken(address _token);
276     // triggered when the total supply is increased
277     event Issuance(uint256 _amount);
278     // triggered when the total supply is decreased
279     event Destruction(uint256 _amount);
280 
281     /**
282         @dev constructor
283 
284         @param _name       token name
285         @param _symbol     token short symbol, minimum 1 character
286         @param _decimals   for display purposes only
287     */
288     function SmartToken(string _name, string _symbol, uint8 _decimals)
289         ERC20Token(_name, _symbol, _decimals)
290     {
291         NewSmartToken(address(this));
292     }
293 
294     // allows execution only when transfers aren't disabled
295     modifier transfersAllowed {
296         assert(transfersEnabled);
297         _;
298     }
299 
300     /**
301         @dev disables/enables transfers
302         can only be called by the contract owner
303 
304         @param _disable    true to disable transfers, false to enable them
305     */
306     function disableTransfers(bool _disable) public ownerOnly {
307         transfersEnabled = !_disable;
308     }
309 
310     /**
311         @dev increases the token supply and sends the new tokens to an account
312         can only be called by the contract owner
313 
314         @param _to         account to receive the new amount
315         @param _amount     amount to increase the supply by
316     */
317     function issue(address _to, uint256 _amount)
318         public
319         ownerOnly
320         validAddress(_to)
321         notThis(_to)
322     {
323         totalSupply = safeAdd(totalSupply, _amount);
324         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
325 
326         Issuance(_amount);
327         Transfer(this, _to, _amount);
328     }
329 
330     /**
331         @dev removes tokens from an account and decreases the token supply
332         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
333 
334         @param _from       account to remove the amount from
335         @param _amount     amount to decrease the supply by
336     */
337     function destroy(address _from, uint256 _amount) public {
338         require(msg.sender == _from || msg.sender == owner); // validate input
339 
340         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
341         totalSupply = safeSub(totalSupply, _amount);
342 
343         Transfer(_from, this, _amount);
344         Destruction(_amount);
345     }
346 
347     // ERC20 standard method overrides with some extra functionality
348 
349     /**
350         @dev send coins
351         throws on any error rather then return a false flag to minimize user errors
352         in addition to the standard checks, the function throws if transfers are disabled
353 
354         @param _to      target address
355         @param _value   transfer amount
356 
357         @return true if the transfer was successful, false if it wasn't
358     */
359     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
360         assert(super.transfer(_to, _value));
361         return true;
362     }
363 
364     /**
365         @dev an account/contract attempts to get the coins
366         throws on any error rather then return a false flag to minimize user errors
367         in addition to the standard checks, the function throws if transfers are disabled
368 
369         @param _from    source address
370         @param _to      target address
371         @param _value   transfer amount
372 
373         @return true if the transfer was successful, false if it wasn't
374     */
375     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
376         assert(super.transferFrom(_from, _to, _value));
377         return true;
378     }
379 }
380 
381 contract KickcityToken is SmartToken {
382     function KickcityToken() SmartToken("KickCity Token", "KCY", 18) { 
383         disableTransfers(true);
384      }
385 }