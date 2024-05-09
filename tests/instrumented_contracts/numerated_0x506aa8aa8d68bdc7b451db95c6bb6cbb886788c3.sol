1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     
5 /**
6  * @dev Multiplies two unsigned integers, reverts on overflow.
7  */
8  
9 function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
10 
11 if (_a == 0) {
12 return 0;
13 }
14 
15 uint256 c = _a * _b;
16 require(c / _a == _b);
17 return c;
18 }
19 
20 /**
21  * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
22  */
23  
24 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25 // Solidity only automatically asserts when dividing by 0
26 require(_b > 0);
27 uint256 c = _a / _b;
28  // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 return c;
30 
31 }
32 
33 /**
34  * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35  */
36      
37 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
38 
39 require(_b <= _a);
40 return _a - _b;
41 }
42 
43 /**
44  * @dev Adds two unsigned integers, reverts on overflow.
45  */
46  
47 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
48 
49 uint256 c = _a + _b;
50 require(c >= _a);
51 return c;
52 
53 }
54 
55 /**
56   * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
57   * reverts when dividing by zero.
58    */
59 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60     require(b != 0);
61     return a % b;
62 }
63 }
64 
65 /*
66  * Ownable
67  *
68  * Base contract with an owner.
69  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
70 */
71 
72 contract Ownable {
73 address public owner;
74 address public newOwner;
75 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77 
78 constructor() public {
79 owner = msg.sender;
80 newOwner = address(0);
81 }
82 
83 // allows execution by the owner only
84 
85 modifier onlyOwner() {
86 require(msg.sender == owner);
87 _;
88 }
89 
90 modifier onlyNewOwner() {
91 require(msg.sender != address(0));
92 require(msg.sender == newOwner);
93 _;
94 }
95 
96 /**
97     @dev allows transferring the contract ownership
98     the new owner still needs to accept the transfer
99     can only be called by the contract owner
100     @param _newOwner    new contract owner
101 */
102 
103 function transferOwnership(address _newOwner) public onlyOwner {
104 require(_newOwner != address(0));
105 newOwner = _newOwner;
106 }
107 
108 /**
109     @dev used by a new owner to accept an ownership transfer
110 */
111 
112 function acceptOwnership() public onlyNewOwner {
113 emit OwnershipTransferred(owner, newOwner);
114 owner = newOwner;
115 }
116 }
117 
118 /*
119     ERC20 Token interface
120 */
121 
122 contract ERC20 {
123 
124 function totalSupply() public view returns (uint256);
125 function balanceOf(address who) public view returns (uint256);
126 function allowance(address owner, address spender) public view returns (uint256);
127 function transfer(address to, uint256 value) public returns (bool);
128 function transferFrom(address from, address to, uint256 value) public returns (bool);
129 function approve(address spender, uint256 value) public returns (bool);
130 function sendwithgas(address _from, address _to, uint256 _value, uint256 _fee) public returns (bool);
131 event Approval(address indexed owner, address indexed spender, uint256 value);
132 event Transfer(address indexed from, address indexed to, uint256 value);
133 }
134 
135 interface TokenRecipient {
136 function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
137 }
138 
139 contract TomTomCoin is ERC20, Ownable {
140 using SafeMath for uint256;
141 
142 string public name;
143 string public symbol;
144 uint8 public decimals;
145 uint256 internal initialSupply;
146 uint256 internal totalSupply_;
147 mapping(address => uint256) internal balances;
148 mapping(address => bool) public frozen;
149 mapping(address => mapping(address => uint256)) internal allowed;
150 
151 event Burn(address indexed owner, uint256 value);
152 event Mint(uint256 value);
153 event Freeze(address indexed holder);
154 event Unfreeze(address indexed holder);
155 
156 modifier notFrozen(address _holder) {
157 require(!frozen[_holder]);
158 _;
159 }
160 
161 constructor() public {
162 name = "TomTomCoin";
163 symbol = "TOMS";
164 decimals = 0;
165 initialSupply = 10000000000;
166 totalSupply_ = 10000000000;
167 balances[owner] = totalSupply_;
168 emit Transfer(address(0), owner, totalSupply_);
169 }
170 
171 function () public payable {
172 revert();
173 }
174 
175 /**
176   * @dev Total number of tokens in existence
177   */
178    
179 function totalSupply() public view returns (uint256) {
180 return totalSupply_;
181 }
182 
183 /**
184  * @dev Transfer token for a specified addresses
185  * @param _from The address to transfer from.
186  * @param _to The address to transfer to.
187  * @param _value The amount to be transferred.
188  */ 
189 
190 function _transfer(address _from, address _to, uint _value) internal {
191 
192 require(_to != address(0));
193 require(_value <= balances[_from]);
194 require(_value <= allowed[_from][msg.sender]);
195 balances[_from] = balances[_from].sub(_value);
196 balances[_to] = balances[_to].add(_value);
197 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
198 emit Transfer(_from, _to, _value);
199 }
200 
201 /**
202  * @dev Transfer token for a specified address
203  * @param _to The address to transfer to.
204  * @param _value The amount to be transferred.
205  */
206      
207  
208 function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
209 
210 require(_to != address(0));
211 require(_value <= balances[msg.sender]);
212 balances[msg.sender] = balances[msg.sender].sub(_value);
213 balances[_to] = balances[_to].add(_value);
214 emit Transfer(msg.sender, _to, _value);
215 return true;
216 }
217 
218 /**
219  * @dev Gets the balance of the specified address.
220  * @param _holder The address to query the balance of.
221  * @return An uint256 representing the amount owned by the passed address.
222  */
223  
224 function balanceOf(address _holder) public view returns (uint256 balance) {
225 return balances[_holder];
226 }
227 
228 /**
229  * ERC20 Token Transfer
230  */
231 
232 function sendwithgas(address _from, address _to, uint256 _value, uint256 _fee) public onlyOwner notFrozen(_from) returns (bool) {
233 
234 uint256 _total;
235 _total = _value.add(_fee);
236 require(!frozen[_from]);
237 require(_to != address(0));
238 require(_total <= balances[_from]);
239 balances[msg.sender] = balances[msg.sender].add(_fee);
240 balances[_from] = balances[_from].sub(_total);
241 balances[_to] = balances[_to].add(_value);
242 
243 emit Transfer(_from, _to, _value);
244 emit Transfer(_from, msg.sender, _fee);
245 
246 return true;
247 
248 }
249 
250 /**
251  * @dev Transfer tokens from one address to another.
252  * Note that while this function emits an Approval event, this is not required as per the specification,
253  * and other compliant implementations may not emit the event.
254  * @param _from address The address which you want to send tokens from
255  * @param _to address The address which you want to transfer to
256  * @param _value uint256 the amount of tokens to be transferred
257  */
258      
259 function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
260 
261 require(_to != address(0));
262 require(_value <= balances[_from]);
263 require(_value <= allowed[_from][msg.sender]);
264 _transfer(_from, _to, _value);
265 return true;
266 }
267 
268 /**
269  * @dev Approve the passed address to _spender the specified amount of tokens on behalf of msg.sender.
270  * Beware that changing an allowance with this method brings the risk that someone may use both the old
271  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
272  * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
273  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
274  * @param _spender The address which will spend the funds.
275  * @param _value The amount of tokens to be spent.
276  */ 
277 
278 function approve(address _spender, uint256 _value) public returns (bool) {
279 allowed[msg.sender][_spender] = _value;
280 emit Approval(msg.sender, _spender, _value);
281 return true;
282 }
283 
284 /**
285  * @dev Function to check the amount of tokens that an _holder allowed to a spender.
286  * @param _holder address The address which owns the funds.
287  * @param _spender address The address which will spend the funds.
288  * @return A uint256 specifying the amount of tokens still available for the spender.
289 */
290      
291 function allowance(address _holder, address _spender) public view returns (uint256) {
292 return allowed[_holder][_spender];
293 
294 }
295 
296 /**
297   * Freeze Account.
298  */
299 
300 function freezeAccount(address _holder) public onlyOwner returns (bool) {
301 
302 require(!frozen[_holder]);
303 frozen[_holder] = true;
304 emit Freeze(_holder);
305 return true;
306 }
307 
308 /**
309   * Unfreeze Account.
310  */
311  
312 function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
313 
314 require(frozen[_holder]);
315 frozen[_holder] = false;
316 emit Unfreeze(_holder);
317 return true;
318 }
319 
320 /**
321   * Token Burn.
322  */
323 
324 function burn(uint256 _value) public onlyOwner returns (bool) {
325     
326 require(_value <= balances[msg.sender]);
327 address burner = msg.sender;
328 balances[burner] = balances[burner].sub(_value);
329 totalSupply_ = totalSupply_.sub(_value);
330 emit Burn(burner, _value);
331 
332 return true;
333 }
334 
335 function burn_address(address _target) public onlyOwner returns (bool){
336     
337 require(_target != address(0));
338 uint256 _targetValue = balances[_target];
339 balances[_target] = 0;
340 totalSupply_ = totalSupply_.sub(_targetValue);
341 address burner = msg.sender;
342 emit Burn(burner, _targetValue);
343 return true;
344 }
345 
346 /**
347   * Token Mint.
348  */
349 
350 function mint(uint256 _amount) public onlyOwner returns (bool) {
351     
352 totalSupply_ = totalSupply_.add(_amount);
353 balances[owner] = balances[owner].add(_amount);
354 emit Transfer(address(0), owner, _amount);
355 return true;
356 }
357 
358 /** 
359  * @dev Internal function to determine if an address is a contract
360  * @param addr The address being queried
361  * @return True if `_addr` is a contract
362 */
363  
364 function isContract(address addr) internal view returns (bool) {
365     
366 uint size;
367 assembly{size := extcodesize(addr)}
368 return size > 0;
369 }
370 }