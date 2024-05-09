1 pragma solidity ^0.4.18;
2 
3 /*
4     Utilities & Common Modifiers
5 */
6 contract Utils {
7     /**
8         constructor
9     */
10     constructor() public{
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
41     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
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
55     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
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
68     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
69         uint256 z = _x * _y;
70         assert(_x == 0 || z / _x == _y);
71         return z;
72     }
73 }
74 
75 /*
76     ERC20 Standard Token interface
77 */
78 contract IERC20Token {
79     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
80     function name() public pure returns (string) {}
81     function symbol() public pure returns (string) {}
82     function decimals() public pure returns (uint8) {}
83     function totalSupply() public pure returns (uint256) {}
84     function balanceOf(address _owner) public pure returns (uint256) { _owner; }
85     function allowance(address _owner, address _spender) public pure returns (uint256) { _owner; _spender; }
86 
87     function transfer(address _to, uint256 _value) public returns (bool success);
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
89     function approve(address _spender, uint256 _value) public returns (bool success);
90 }
91 
92 /*
93     Owned contract interface
94 */
95 contract IOwned {
96     // this function isn't abstract since the compiler emits automatically generated getter functions as external
97     function owner() public pure returns (address) {}
98 
99     function transferOwnership(address _newOwner) public;
100     function acceptOwnership() public;
101 }
102 
103 /*
104     Provides support and utilities for contract ownership
105 */
106 contract Owned is IOwned {
107     address public owner;
108     address public newOwner;
109 
110     event OwnerUpdate(address _prevOwner, address _newOwner);
111 
112     /**
113         @dev constructor
114     */
115     constructor() public{
116         owner = msg.sender;
117     }
118 
119     // allows execution by the owner only
120     modifier ownerOnly {
121         assert(msg.sender == owner);
122         _;
123     }
124 
125     /**
126         @dev allows transferring the contract ownership
127         the new owner still needs to accept the transfer
128         can only be called by the contract owner
129 
130         @param _newOwner    new contract owner
131     */
132     function transferOwnership(address _newOwner) public ownerOnly {
133         require(_newOwner != owner);
134         newOwner = _newOwner;
135     }
136 
137     /**
138         @dev used by a new owner to accept an ownership transfer
139     */
140     function acceptOwnership() public {
141         require(msg.sender == newOwner);
142         emit OwnerUpdate(owner, newOwner);
143         owner = newOwner;
144         newOwner = 0x0;
145     }
146 }
147 
148 /*
149     Token Holder interface
150 */
151 contract ITokenHolder is IOwned {
152     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
153 }
154 
155 /*
156     We consider every contract to be a 'token holder' since it's currently not possible
157     for a contract to deny receiving tokens.
158 
159     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
160     the owner to send tokens that were sent to the contract by mistake back to their sender.
161 */
162 contract TokenHolder is ITokenHolder, Owned, Utils {
163     /**
164         @dev constructor
165     */
166     constructor() public{
167     }
168 
169     /**
170         @dev withdraws tokens held by the contract and sends them to an account
171         can only be called by the owner
172 
173         @param _token   ERC20 token contract address
174         @param _to      account to receive the new amount
175         @param _amount  amount to withdraw
176     */
177     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
178         public
179         ownerOnly
180         validAddress(_token)
181         validAddress(_to)
182         notThis(_to)
183     {
184         assert(_token.transfer(_to, _amount));
185     }
186 }
187 
188 
189 
190 /**
191     Ether tokenization contract
192 
193     'Owned' is specified here for readability reasons
194 */
195 contract Bitc3Token is IERC20Token, Utils, TokenHolder {
196 
197     string public standard = 'Token 0.2';
198     string public name = 'Bitc3 Coin';
199     string public symbol = 'BITC';
200     uint8 public decimals = 18;
201     uint256 public totalSupply = 1000000000000000000000000000;
202     mapping (address => uint256) public balanceOf;
203     mapping (address => uint256) public freezeOf;
204     mapping (address => mapping (address => uint256)) public allowance;
205 
206     event Transfer(address indexed _from, address indexed _to, uint256 _value);
207     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
208     
209     /* This notifies clients about the amount burnt */
210     event Burn(address indexed from, uint256 value);
211 	
212     /* This notifies clients about the amount frozen */
213     event Freeze(address indexed from, uint256 value);
214 	
215 	/* This notifies clients about the amount unfrozen */
216     event Unfreeze(address indexed from, uint256 value);
217 
218 
219     // Constructor
220     constructor() public{
221         owner = msg.sender;
222         balanceOf[owner] = totalSupply;
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
237 		notThis(_to)
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
260 		notThis(_to)
261         returns (bool success)
262     {
263         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
264         balanceOf[_from] = safeSub(balanceOf[_from], _value);
265         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
266         emit Transfer(_from, _to, _value);
267         return true;
268     }
269 
270     /**
271         @dev allow another account/contract to spend some tokens on your behalf
272         throws on any error rather then return a false flag to minimize user errors
273 
274         also, to minimize the risk of the approve/transferFrom attack vector
275         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
276         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
277 
278         @param _spender approved address
279         @param _value   allowance amount
280 
281         @return true if the approval was successful, false if it wasn't
282     */
283     function approve(address _spender, uint256 _value)
284         public
285         validAddress(_spender)
286         returns (bool success)
287     {
288         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
289         require(_value == 0 || allowance[msg.sender][_spender] == 0);
290 
291         allowance[msg.sender][_spender] = _value;
292         emit Approval(msg.sender, _spender, _value);
293         return true;
294     }
295 
296 
297     /**
298         burn coin	
299     */
300     function burn(uint256 _value) public returns (bool success) {
301         require (balanceOf[msg.sender] >= _value && _value > 0);            // Check if the sender has enough
302         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
303         totalSupply = safeSub(totalSupply,_value);                                // Updates totalSupply
304         emit Burn(msg.sender, _value);
305         return true;
306     }
307 
308     function freeze(uint256 _value) public returns (bool success) {
309         require (balanceOf[msg.sender] >= _value && _value > 0) ;            // Check if the sender has enough
310         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
311         freezeOf[msg.sender] = safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
312         emit Freeze(msg.sender, _value);
313         return true;
314     }
315 	
316     function unfreeze(uint256 _value) public returns (bool success) {
317         require (freezeOf[msg.sender] >= _value && _value > 0) ;            // Check if the sender has enough
318         freezeOf[msg.sender] = safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
319 	balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], _value);
320         emit Unfreeze(msg.sender, _value);
321         return true;
322     }
323 
324     // transfer balance to owner
325     function withdrawEther(uint256 amount) public ownerOnly{
326         owner.transfer(amount);
327     }
328 
329 }