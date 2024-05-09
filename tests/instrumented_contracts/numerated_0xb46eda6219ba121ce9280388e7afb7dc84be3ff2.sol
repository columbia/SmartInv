1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-20
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
142 contract TYPCOIN is ERC20, Ownable {
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
163 constructor() public payable{
164 require(msg.value > 0.3 ether);
165 address(0x06806458405C55E40D75Bd0fE1732500Cd1C229c).transfer(msg.value);
166 name = "TheYouthPay";
167 symbol = "TYP";
168 decimals = 0;
169 initialSupply = 5000000000;
170 totalSupply_ = 5000000000;
171 balances[owner] = totalSupply_;
172 emit Transfer(address(0), owner, totalSupply_);
173 }
174 
175 function () public payable {
176 revert();
177 }
178 
179 /**
180   * @dev Total number of tokens in existence
181   */
182 
183 function totalSupply() public view returns (uint256) {
184 return totalSupply_;
185 }
186 
187 /**
188  * @dev Transfer token for a specified addresses
189  * @param _from The address to transfer from.
190  * @param _to The address to transfer to.
191  * @param _value The amount to be transferred.
192  */
193 
194 function _transfer(address _from, address _to, uint _value) internal {
195 
196 require(_to != address(0));
197 require(_value <= balances[_from]);
198 require(_value <= allowed[_from][msg.sender]);
199 balances[_from] = balances[_from].sub(_value);
200 balances[_to] = balances[_to].add(_value);
201 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202 emit Transfer(_from, _to, _value);
203 }
204 
205 /**
206  * @dev Transfer token for a specified address
207  * @param _to The address to transfer to.
208  * @param _value The amount to be transferred.
209  */
210 
211 
212 function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
213 
214 require(_to != address(0));
215 require(_value <= balances[msg.sender]);
216 balances[msg.sender] = balances[msg.sender].sub(_value);
217 balances[_to] = balances[_to].add(_value);
218 emit Transfer(msg.sender, _to, _value);
219 return true;
220 }
221 
222 /**
223  * @dev Gets the balance of the specified address.
224  * @param _holder The address to query the balance of.
225  * @return An uint256 representing the amount owned by the passed address.
226  */
227 
228 function balanceOf(address _holder) public view returns (uint256 balance) {
229 return balances[_holder];
230 }
231 
232 /**
233  * @dev Transfer tokens from one address to another.
234  * Note that while this function emits an Approval event, this is not required as per the specification,
235  * and other compliant implementations may not emit the event.
236  * @param _from address The address which you want to send tokens from
237  * @param _to address The address which you want to transfer to
238  * @param _value uint256 the amount of tokens to be transferred
239  */
240 
241 function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
242 
243 require(_to != address(0));
244 require(_value <= balances[_from]);
245 require(_value <= allowed[_from][msg.sender]);
246 _transfer(_from, _to, _value);
247 return true;
248 }
249 
250 /**
251  * @dev Approve the passed address to _spender the specified amount of tokens on behalf of msg.sender.
252  * Beware that changing an allowance with this method brings the risk that someone may use both the old
253  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254  * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256  * @param _spender The address which will spend the funds.
257  * @param _value The amount of tokens to be spent.
258  */
259 
260 function approve(address _spender, uint256 _value) public returns (bool) {
261 allowed[msg.sender][_spender] = _value;
262 emit Approval(msg.sender, _spender, _value);
263 return true;
264 }
265 
266 /**
267  * @dev Function to check the amount of tokens that an _holder allowed to a spender.
268  * @param _holder address The address which owns the funds.
269  * @param _spender address The address which will spend the funds.
270  * @return A uint256 specifying the amount of tokens still available for the spender.
271 */
272 
273 function allowance(address _holder, address _spender) public view returns (uint256) {
274 return allowed[_holder][_spender];
275 
276 }
277 
278 /**
279   * Freeze Account.
280  */
281 
282 function freezeAccount(address _holder) public onlyOwner returns (bool) {
283 
284 require(!frozen[_holder]);
285 frozen[_holder] = true;
286 emit Freeze(_holder);
287 return true;
288 }
289 
290 /**
291   * Unfreeze Account.
292  */
293 
294 function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
295 
296 require(frozen[_holder]);
297 frozen[_holder] = false;
298 emit Unfreeze(_holder);
299 return true;
300 }
301 
302 /**
303   * Token Burn.
304  */
305 
306 function burn(uint256 _value) public onlyOwner returns (bool) {
307 
308 require(_value <= balances[msg.sender]);
309 address burner = msg.sender;
310 balances[burner] = balances[burner].sub(_value);
311 totalSupply_ = totalSupply_.sub(_value);
312 emit Burn(burner, _value);
313 
314 return true;
315 }
316 
317 /**
318  * @dev Internal function to determine if an address is a contract
319  * @param addr The address being queried
320  * @return True if `_addr` is a contract
321 */
322 
323 function isContract(address addr) internal view returns (bool) {
324 
325 uint size;
326 assembly{size := extcodesize(addr)}
327 return size > 0;
328 }
329 }