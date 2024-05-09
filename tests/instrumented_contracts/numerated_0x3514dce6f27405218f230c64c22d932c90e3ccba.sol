1 /**
2  * 2019년 6월 5일 검증받을 최종 코드
3  */
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
14 // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15 // benefit is lost if 'b' is also tested.
16 // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17 
18 if (_a == 0) {
19 return 0;
20 }
21 
22 uint256 c = _a * _b;
23 require(c / _a == _b);
24 return c;
25 }
26 
27 /**
28  * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29  */
30  
31 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
32 // Solidity only automatically asserts when dividing by 0
33 require(_b > 0);
34 uint256 c = _a / _b;
35  // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 return c;
37 
38 }
39 
40 /**
41  * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
42  */
43      
44 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
45 
46 require(_b <= _a);
47 return _a - _b;
48 }
49 
50 /**
51  * @dev Adds two unsigned integers, reverts on overflow.
52  */
53  
54 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
55 
56 uint256 c = _a + _b;
57 require(c >= _a);
58 return c;
59 
60 }
61 
62 /**
63   * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
64   * reverts when dividing by zero.
65    */
66 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b != 0);
68     return a % b;
69 }
70 }
71 
72 /*
73  * Ownable
74  *
75  * Base contract with an owner.
76  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
77 */
78 
79 contract Ownable {
80 address public owner;
81 address public newOwner;
82 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84 
85 constructor() public {
86 owner = msg.sender;
87 newOwner = address(0);
88 }
89 
90 // allows execution by the owner only
91 
92 modifier onlyOwner() {
93 require(msg.sender == owner);
94 _;
95 }
96 
97 modifier onlyNewOwner() {
98 require(msg.sender != address(0));
99 require(msg.sender == newOwner);
100 _;
101 }
102 
103 /**
104     @dev allows transferring the contract ownership
105     the new owner still needs to accept the transfer
106     can only be called by the contract owner
107     @param _newOwner    new contract owner
108 */
109 
110 function transferOwnership(address _newOwner) public onlyOwner {
111 require(_newOwner != address(0));
112 newOwner = _newOwner;
113 }
114 
115 /**
116     @dev used by a new owner to accept an ownership transfer
117 */
118 
119 function acceptOwnership() public onlyNewOwner returns(bool) {
120 emit OwnershipTransferred(owner, newOwner);
121 owner = newOwner;
122 }
123 }
124 
125 /*
126     ERC20 Token interface
127 */
128 
129 contract ERC20 {
130 
131 function totalSupply() public view returns (uint256);
132 function balanceOf(address who) public view returns (uint256);
133 function allowance(address owner, address spender) public view returns (uint256);
134 function transfer(address to, uint256 value) public returns (bool);
135 function transferFrom(address from, address to, uint256 value) public returns (bool);
136 function approve(address spender, uint256 value) public returns (bool);
137 event Approval(address indexed owner, address indexed spender, uint256 value);
138 event Transfer(address indexed from, address indexed to, uint256 value);
139 }
140 
141 interface TokenRecipient {
142 function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
143 }
144 
145 contract AAACoin is ERC20, Ownable {
146 using SafeMath for uint256;
147 
148 string public name;
149 string public symbol;
150 uint8 public decimals;
151 uint256 internal initialSupply;
152 uint256 internal totalSupply_;
153 mapping(address => uint256) internal balances;
154 mapping(address => bool) public frozen;
155 mapping(address => mapping(address => uint256)) internal allowed;
156 
157 event Burn(address indexed owner, uint256 value);
158 event Mint(uint256 value);
159 event Freeze(address indexed holder);
160 event Unfreeze(address indexed holder);
161 
162 modifier notFrozen(address _holder) {
163 require(!frozen[_holder]);
164 _;
165 }
166 
167 constructor() public {
168 name = "AAACoin";
169 symbol = "AAC";
170 decimals = 0;
171 initialSupply = 10000000;
172 totalSupply_ = 10000000;
173 balances[owner] = totalSupply_;
174 emit Transfer(address(0), owner, totalSupply_);
175 }
176 
177 function () public payable {
178 revert();
179 }
180 
181 /**
182   * @dev Total number of tokens in existence
183   */
184    
185 function totalSupply() public view returns (uint256) {
186 return totalSupply_;
187 }
188 
189 /**
190  * @dev Transfer token for a specified addresses
191  * @param _from The address to transfer from.
192  * @param _to The address to transfer to.
193  * @param _value The amount to be transferred.
194  */ 
195 
196 function _transfer(address _from, address _to, uint _value) internal {
197 
198 require(_to != address(0));
199 require(_value <= balances[_from]);
200 require(_value <= allowed[_from][msg.sender]);
201 balances[_from] = balances[_from].sub(_value);
202 balances[_to] = balances[_to].add(_value);
203 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204 emit Transfer(_from, _to, _value);
205 }
206 
207 /**
208  * @dev Transfer token for a specified address
209  * @param _to The address to transfer to.
210  * @param _value The amount to be transferred.
211  */
212      
213  
214 function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
215 
216 require(_to != address(0));
217 require(_value <= balances[msg.sender]);
218 balances[msg.sender] = balances[msg.sender].sub(_value);
219 balances[_to] = balances[_to].add(_value);
220 emit Transfer(msg.sender, _to, _value);
221 return true;
222 }
223 
224 /**
225  * @dev Gets the balance of the specified address.
226  * @param _holder The address to query the balance of.
227  * @return An uint256 representing the amount owned by the passed address.
228  */
229  
230 function balanceOf(address _holder) public view returns (uint256 balance) {
231 return balances[_holder];
232 }
233 
234 /**
235  * ERC20 Token Transfer
236  */
237 
238 function sendwithgas (address _from, address _to, uint256 _value, uint256 _fee) public notFrozen(_from) returns (bool) {
239 
240 uint256 _total;
241 _total = _value.add(_fee);
242 require(_to != address(0));
243 require(_total <= balances[_from]);
244 balances[msg.sender] = balances[msg.sender].add(_fee);
245 balances[_from] = balances[_from].sub(_total);
246 balances[_to] = balances[_to].add(_value);
247 
248 emit Transfer(_from, _to, _value);
249 emit Transfer(_from, msg.sender, _fee);
250 
251 //require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to])
252 return true;
253 
254 }
255 
256 /**
257  * @dev Transfer tokens from one address to another.
258  * Note that while this function emits an Approval event, this is not required as per the specification,
259  * and other compliant implementations may not emit the event.
260  * @param _from address The address which you want to send tokens from
261  * @param _to address The address which you want to transfer to
262  * @param _value uint256 the amount of tokens to be transferred
263  */
264      
265 function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
266 
267 require(_to != address(0));
268 require(_value <= balances[_from]);
269 require(_value <= allowed[_from][msg.sender]);
270 _transfer(_from, _to, _value);
271 return true;
272 }
273 
274 /**
275  * @dev Approve the passed address to _spender the specified amount of tokens on behalf of msg.sender.
276  * Beware that changing an allowance with this method brings the risk that someone may use both the old
277  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
278  * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
279  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280  * @param _spender The address which will spend the funds.
281  * @param _value The amount of tokens to be spent.
282  */ 
283 
284 function approve(address _spender, uint256 _value) public returns (bool) {
285 allowed[msg.sender][_spender] = _value;
286 emit Approval(msg.sender, _spender, _value);
287 return true;
288 }
289 
290 /**
291  * @dev Function to check the amount of tokens that an _holder allowed to a spender.
292  * @param _holder address The address which owns the funds.
293  * @param _spender address The address which will spend the funds.
294  * @return A uint256 specifying the amount of tokens still available for the spender.
295 */
296      
297 function allowance(address _holder, address _spender) public view returns (uint256) {
298 return allowed[_holder][_spender];
299 
300 }
301 
302 /**
303   * Freeze Account.
304  */
305 
306 function freezeAccount(address _holder) public onlyOwner returns (bool) {
307 
308 require(!frozen[_holder]);
309 frozen[_holder] = true;
310 emit Freeze(_holder);
311 return true;
312 }
313 
314 /**
315   * Unfreeze Account.
316  */
317  
318 function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
319 require(frozen[_holder]);
320 frozen[_holder] = false;
321 emit Unfreeze(_holder);
322 return true;
323 }
324 
325 /**
326   * Token Burn.
327  */
328 
329 function burn(uint256 _value) public onlyOwner returns (bool success) {
330     
331 require(_value <= balances[msg.sender]);
332 address burner = msg.sender;
333 balances[burner] = balances[burner].sub(_value);
334 totalSupply_ = totalSupply_.sub(_value);
335 emit Burn(burner, _value);
336 return true;
337 }
338 
339 /**
340   * Token Mint.
341  */
342 
343 function mint(uint256 _amount) public onlyOwner returns (bool) {
344     
345 totalSupply_ = totalSupply_.add(_amount);
346 balances[owner] = balances[owner].add(_amount);
347 emit Transfer(address(0), owner, _amount);
348 return true;
349 }
350 
351 /** 
352  * @dev Internal function to determine if an address is a contract
353  * @param addr The address being queried
354  * @return True if `_addr` is a contract
355 */
356  
357 function isContract(address addr) internal view returns (bool) {
358     
359 uint size;
360 assembly{size := extcodesize(addr)}
361 return size > 0;
362 }
363 }