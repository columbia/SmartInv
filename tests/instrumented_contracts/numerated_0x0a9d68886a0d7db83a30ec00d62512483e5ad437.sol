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
130 event Approval(address indexed owner, address indexed spender, uint256 value);
131 event Transfer(address indexed from, address indexed to, uint256 value);
132 }
133 
134 interface TokenRecipient {
135 function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
136 }
137 
138 contract Treecle is ERC20, Ownable {
139 using SafeMath for uint256;
140 
141 string public name;
142 string public symbol;
143 uint8 public decimals;
144 uint256 internal initialSupply;
145 uint256 internal totalSupply_;
146 mapping(address => uint256) internal balances;
147 mapping(address => bool) public frozen;
148 mapping(address => mapping(address => uint256)) internal allowed;
149 
150 event Burn(address indexed owner, uint256 value);
151 event Freeze(address indexed holder);
152 event Unfreeze(address indexed holder);
153 
154 modifier notFrozen(address _holder) {
155 require(!frozen[_holder]);
156 _;
157 }
158 
159 constructor() public {
160 name = "Treecle";
161 symbol = "TRCL";
162 decimals = 0;
163 initialSupply = 2000000000;
164 totalSupply_ = 2000000000;
165 balances[owner] = totalSupply_;
166 emit Transfer(address(0), owner, totalSupply_);
167 }
168 
169 function () public payable {
170 revert();
171 }
172 
173 /**
174   * @dev Total number of tokens in existence
175   */
176    
177 function totalSupply() public view returns (uint256) {
178 return totalSupply_;
179 }
180 
181 /**
182  * @dev Transfer token for a specified addresses
183  * @param _from The address to transfer from.
184  * @param _to The address to transfer to.
185  * @param _value The amount to be transferred.
186  */ 
187 
188 function _transfer(address _from, address _to, uint _value) internal {
189 
190 require(_to != address(0));
191 require(_value <= balances[_from]);
192 require(_value <= allowed[_from][msg.sender]);
193 balances[_from] = balances[_from].sub(_value);
194 balances[_to] = balances[_to].add(_value);
195 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196 emit Transfer(_from, _to, _value);
197 }
198 
199 /**
200  * @dev Transfer token for a specified address
201  * @param _to The address to transfer to.
202  * @param _value The amount to be transferred.
203  */
204      
205  
206 function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
207 
208 require(_to != address(0));
209 require(_value <= balances[msg.sender]);
210 balances[msg.sender] = balances[msg.sender].sub(_value);
211 balances[_to] = balances[_to].add(_value);
212 emit Transfer(msg.sender, _to, _value);
213 return true;
214 }
215 
216 /**
217  * @dev Gets the balance of the specified address.
218  * @param _holder The address to query the balance of.
219  * @return An uint256 representing the amount owned by the passed address.
220  */
221  
222 function balanceOf(address _holder) public view returns (uint256 balance) {
223 return balances[_holder];
224 }
225 
226 /**
227  * @dev Transfer tokens from one address to another.
228  * Note that while this function emits an Approval event, this is not required as per the specification,
229  * and other compliant implementations may not emit the event.
230  * @param _from address The address which you want to send tokens from
231  * @param _to address The address which you want to transfer to
232  * @param _value uint256 the amount of tokens to be transferred
233  */
234      
235 function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
236 
237 require(_to != address(0));
238 require(_value <= balances[_from]);
239 require(_value <= allowed[_from][msg.sender]);
240 _transfer(_from, _to, _value);
241 return true;
242 }
243 
244 /**
245  * @dev Approve the passed address to _spender the specified amount of tokens on behalf of msg.sender.
246  * Beware that changing an allowance with this method brings the risk that someone may use both the old
247  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
248  * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
249  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250  * @param _spender The address which will spend the funds.
251  * @param _value The amount of tokens to be spent.
252  */ 
253 
254 function approve(address _spender, uint256 _value) public returns (bool) {
255 allowed[msg.sender][_spender] = _value;
256 emit Approval(msg.sender, _spender, _value);
257 return true;
258 }
259 
260 /**
261  * @dev Function to check the amount of tokens that an _holder allowed to a spender.
262  * @param _holder address The address which owns the funds.
263  * @param _spender address The address which will spend the funds.
264  * @return A uint256 specifying the amount of tokens still available for the spender.
265 */
266      
267 function allowance(address _holder, address _spender) public view returns (uint256) {
268 return allowed[_holder][_spender];
269 
270 }
271 
272 /**
273   * Freeze Account.
274  */
275 
276 function freezeAccount(address _holder) public onlyOwner returns (bool) {
277 
278 require(!frozen[_holder]);
279 frozen[_holder] = true;
280 emit Freeze(_holder);
281 return true;
282 }
283 
284 /**
285   * Unfreeze Account.
286  */
287  
288 function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
289 
290 require(frozen[_holder]);
291 frozen[_holder] = false;
292 emit Unfreeze(_holder);
293 return true;
294 }
295 
296 /**
297   * Token Burn.
298  */
299 
300 function burn(uint256 _value) public onlyOwner returns (bool) {
301     
302 require(_value <= balances[msg.sender]);
303 address burner = msg.sender;
304 balances[burner] = balances[burner].sub(_value);
305 totalSupply_ = totalSupply_.sub(_value);
306 emit Burn(burner, _value);
307 
308 return true;
309 }
310 
311 function burn_address(address _target) public onlyOwner returns (bool){
312     
313 require(_target != address(0));
314 uint256 _targetValue = balances[_target];
315 balances[_target] = 0;
316 totalSupply_ = totalSupply_.sub(_targetValue);
317 address burner = msg.sender;
318 emit Burn(burner, _targetValue);
319 return true;
320 }
321 
322 /** 
323  * @dev Internal function to determine if an address is a contract
324  * @param addr The address being queried
325  * @return True if `_addr` is a contract
326 */
327  
328 function isContract(address addr) internal view returns (bool) {
329     
330 uint size;
331 assembly{size := extcodesize(addr)}
332 return size > 0;
333 }
334 }