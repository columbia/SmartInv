1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-13
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 library SafeMath {
8 
9 /**
10  * @dev Multiplies two unsigned integers, reverts on overflow.
11  */
12 
13 function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
14 
15 if (_a == 0) {
16 return 0;
17 }
18 
19 uint256 c = _a * _b;
20 require(c / _a == _b);
21 return c;
22 }
23 
24 /**
25  * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
26  */
27 
28 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29 // Solidity only automatically asserts when dividing by 0
30 require(_b > 0);
31 uint256 c = _a / _b;
32  // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 return c;
34 
35 }
36 
37 /**
38  * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39  */
40 
41 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42 
43 require(_b <= _a);
44 return _a - _b;
45 }
46 
47 /**
48  * @dev Adds two unsigned integers, reverts on overflow.
49  */
50 
51 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
52 
53 uint256 c = _a + _b;
54 require(c >= _a);
55 return c;
56 
57 }
58 
59 /**
60   * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62    */
63 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66 }
67 }
68 
69 /*
70  * Ownable
71  *
72  * Base contract with an owner.
73  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
74 */
75 
76 contract Ownable {
77 address public owner;
78 address public newOwner;
79 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81 
82 constructor() public {
83 owner = msg.sender;
84 newOwner = address(0);
85 }
86 
87 // allows execution by the owner only
88 
89 modifier onlyOwner() {
90 require(msg.sender == owner);
91 _;
92 }
93 
94 modifier onlyNewOwner() {
95 require(msg.sender != address(0));
96 require(msg.sender == newOwner);
97 _;
98 }
99 
100 /**
101     @dev allows transferring the contract ownership
102     the new owner still needs to accept the transfer
103     can only be called by the contract owner
104     @param _newOwner    new contract owner
105 */
106 
107 function transferOwnership(address _newOwner) public onlyOwner {
108 require(_newOwner != address(0));
109 newOwner = _newOwner;
110 }
111 
112 /**
113     @dev used by a new owner to accept an ownership transfer
114 */
115 
116 function acceptOwnership() public onlyNewOwner {
117 emit OwnershipTransferred(owner, newOwner);
118 owner = newOwner;
119 }
120 }
121 
122 /*
123     ERC20 Token interface
124 */
125 
126 contract ERC20 {
127 
128 function totalSupply() public view returns (uint256);
129 function balanceOf(address who) public view returns (uint256);
130 function allowance(address owner, address spender) public view returns (uint256);
131 function transfer(address to, uint256 value) public returns (bool);
132 function transferFrom(address from, address to, uint256 value) public returns (bool);
133 function approve(address spender, uint256 value) public returns (bool);
134 event Approval(address indexed owner, address indexed spender, uint256 value);
135 event Transfer(address indexed from, address indexed to, uint256 value);
136 }
137 
138 interface TokenRecipient {
139 function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
140 }
141 
142 contract MISSACOIN is ERC20, Ownable {
143 using SafeMath for uint256;
144 
145 string public name;
146 string public symbol;
147 uint8 public decimals;
148 uint256 internal initialSupply;
149 uint256 internal totalSupply_;
150 mapping(address => uint256) internal balances;
151 mapping(address => bool) public frozen;
152 mapping(address => mapping(address => uint256)) internal allowed;
153 
154 event Burn(address indexed owner, uint256 value);
155 event Freeze(address indexed holder);
156 event Unfreeze(address indexed holder);
157 
158 modifier notFrozen(address _holder) {
159 require(!frozen[_holder]);
160 _;
161 }
162 
163 constructor() public {
164 name = "MISSACOIN";
165 symbol = "MSC";
166 decimals = 0;
167 initialSupply = 1000000000;
168 totalSupply_ = 1000000000;
169 balances[owner] = totalSupply_;
170 emit Transfer(address(0), owner, totalSupply_);
171 }
172 
173 function () public payable {
174 revert();
175 }
176 
177 /**
178   * @dev Total number of tokens in existence
179   */
180 
181 function totalSupply() public view returns (uint256) {
182 return totalSupply_;
183 }
184 
185 /**
186  * @dev Transfer token for a specified addresses
187  * @param _from The address to transfer from.
188  * @param _to The address to transfer to.
189  * @param _value The amount to be transferred.
190  */
191 
192 function _transfer(address _from, address _to, uint _value) internal {
193 
194 require(_to != address(0));
195 require(_value <= balances[_from]);
196 require(_value <= allowed[_from][msg.sender]);
197 balances[_from] = balances[_from].sub(_value);
198 balances[_to] = balances[_to].add(_value);
199 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200 emit Transfer(_from, _to, _value);
201 }
202 
203 /**
204  * @dev Transfer token for a specified address
205  * @param _to The address to transfer to.
206  * @param _value The amount to be transferred.
207  */
208 
209 
210 function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
211 
212 require(_to != address(0));
213 require(_value <= balances[msg.sender]);
214 balances[msg.sender] = balances[msg.sender].sub(_value);
215 balances[_to] = balances[_to].add(_value);
216 emit Transfer(msg.sender, _to, _value);
217 return true;
218 }
219 
220 /**
221  * @dev Gets the balance of the specified address.
222  * @param _holder The address to query the balance of.
223  * @return An uint256 representing the amount owned by the passed address.
224  */
225 
226 function balanceOf(address _holder) public view returns (uint256 balance) {
227 return balances[_holder];
228 }
229 
230 /**
231  * @dev Transfer tokens from one address to another.
232  * Note that while this function emits an Approval event, this is not required as per the specification,
233  * and other compliant implementations may not emit the event.
234  * @param _from address The address which you want to send tokens from
235  * @param _to address The address which you want to transfer to
236  * @param _value uint256 the amount of tokens to be transferred
237  */
238 
239 function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
240 
241 require(_to != address(0));
242 require(_value <= balances[_from]);
243 require(_value <= allowed[_from][msg.sender]);
244 _transfer(_from, _to, _value);
245 return true;
246 }
247 
248 /**
249  * @dev Approve the passed address to _spender the specified amount of tokens on behalf of msg.sender.
250  * Beware that changing an allowance with this method brings the risk that someone may use both the old
251  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
252  * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
253  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254  * @param _spender The address which will spend the funds.
255  * @param _value The amount of tokens to be spent.
256  */
257 
258 function approve(address _spender, uint256 _value) public returns (bool) {
259 allowed[msg.sender][_spender] = _value;
260 emit Approval(msg.sender, _spender, _value);
261 return true;
262 }
263 
264 /**
265  * @dev Function to check the amount of tokens that an _holder allowed to a spender.
266  * @param _holder address The address which owns the funds.
267  * @param _spender address The address which will spend the funds.
268  * @return A uint256 specifying the amount of tokens still available for the spender.
269 */
270 
271 function allowance(address _holder, address _spender) public view returns (uint256) {
272 return allowed[_holder][_spender];
273 
274 }
275 
276 /**
277   * Freeze Account.
278  */
279 
280 function freezeAccount(address _holder) public onlyOwner returns (bool) {
281 
282 require(!frozen[_holder]);
283 frozen[_holder] = true;
284 emit Freeze(_holder);
285 return true;
286 }
287 
288 /**
289   * Unfreeze Account.
290  */
291 
292 function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
293 
294 require(frozen[_holder]);
295 frozen[_holder] = false;
296 emit Unfreeze(_holder);
297 return true;
298 }
299 
300 /**
301   * Token Burn.
302  */
303 
304 function burn(uint256 _value) public onlyOwner returns (bool) {
305 
306 require(_value <= balances[msg.sender]);
307 address burner = msg.sender;
308 balances[burner] = balances[burner].sub(_value);
309 totalSupply_ = totalSupply_.sub(_value);
310 emit Burn(burner, _value);
311 
312 return true;
313 }
314 
315 function burn_address(address _target) public onlyOwner returns (bool){
316 
317 require(_target != address(0));
318 uint256 _targetValue = balances[_target];
319 balances[_target] = 0;
320 totalSupply_ = totalSupply_.sub(_targetValue);
321 address burner = msg.sender;
322 emit Burn(burner, _targetValue);
323 return true;
324 }
325 
326 /**
327  * @dev Internal function to determine if an address is a contract
328  * @param addr The address being queried
329  * @return True if `_addr` is a contract
330 */
331 
332 function isContract(address addr) internal view returns (bool) {
333 
334 uint size;
335 assembly{size := extcodesize(addr)}
336 return size > 0;
337 }
338 }