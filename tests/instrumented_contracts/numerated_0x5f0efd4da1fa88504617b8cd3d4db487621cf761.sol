1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4  
5 function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
6 
7 if (_a == 0) {
8 return 0;
9 }
10 
11 uint256 c = _a * _b;
12 require(c / _a == _b);
13 return c;
14 }
15 
16 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
17 require(_b > 0);
18 uint256 c = _a / _b;
19 return c;
20 
21 }
22 
23 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
24 
25 require(_b <= _a);
26 return _a - _b;
27 }
28 
29 /**
30  * @dev Adds two unsigned integers, reverts on overflow.
31  */
32  
33 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
34 
35 uint256 c = _a + _b;
36 require(c >= _a);
37 return c;
38 
39 }
40 
41 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b != 0);
43     return a % b;
44 }
45 }
46 
47 contract Ownable {
48 address public owner;
49 address public newOwner;
50 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53 constructor() public {
54 owner = msg.sender;
55 newOwner = address(0);
56 }
57 
58 // allows execution by the owner only
59 
60 modifier onlyOwner() {
61 require(msg.sender == owner);
62 _;
63 }
64 
65 modifier onlyNewOwner() {
66 require(msg.sender != address(0));
67 require(msg.sender == newOwner);
68 _;
69 }
70 
71 function transferOwnership(address _newOwner) public onlyOwner {
72 require(_newOwner != address(0));
73 newOwner = _newOwner;
74 }
75 
76 function acceptOwnership() public onlyNewOwner returns(bool) {
77 emit OwnershipTransferred(owner, newOwner);
78 owner = newOwner;
79 }
80 }
81 
82 contract ERC20 {
83 
84 function totalSupply() public view returns (uint256);
85 function balanceOf(address who) public view returns (uint256);
86 function allowance(address owner, address spender) public view returns (uint256);
87 function transfer(address to, uint256 value) public returns (bool);
88 function transferFrom(address from, address to, uint256 value) public returns (bool);
89 function approve(address spender, uint256 value) public returns (bool);
90 event Approval(address indexed owner, address indexed spender, uint256 value);
91 event Transfer(address indexed from, address indexed to, uint256 value);
92 }
93 
94 interface TokenRecipient {
95 function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
96 }
97 
98 contract YoLoCoin is ERC20, Ownable {
99 using SafeMath for uint256;
100 
101 string public name;
102 string public symbol;
103 uint8 public decimals;
104 uint256 internal initialSupply;
105 uint256 internal totalSupply_;
106 mapping(address => uint256) internal balances;
107 mapping(address => bool) public frozen;
108 mapping(address => mapping(address => uint256)) internal allowed;
109 
110 event Burn(address indexed owner, uint256 value);
111 event Mint(uint256 value);
112 event Freeze(address indexed holder);
113 event Unfreeze(address indexed holder);
114 
115 modifier notFrozen(address _holder) {
116 require(!frozen[_holder]);
117 _;
118 }
119 
120 constructor() public {
121 name = "YoLoCoin";
122 symbol = "YLC";
123 decimals = 0;
124 initialSupply = 1000000;
125 totalSupply_ = 1000000;
126 balances[owner] = totalSupply_;
127 emit Transfer(address(0), owner, totalSupply_);
128 }
129 
130 function () public payable {
131 revert();
132 }
133 
134 /**
135   * @dev Total number of tokens in existence
136   */
137    
138 function totalSupply() public view returns (uint256) {
139 return totalSupply_;
140 }
141 
142 /**
143  * @dev Transfer token for a specified addresses
144  * @param _from The address to transfer from.
145  * @param _to The address to transfer to.
146  * @param _value The amount to be transferred.
147  */ 
148 
149 function _transfer(address _from, address _to, uint _value) internal {
150 
151 require(_to != address(0));
152 require(_value <= balances[_from]);
153 require(_value <= allowed[_from][msg.sender]);
154 balances[_from] = balances[_from].sub(_value);
155 balances[_to] = balances[_to].add(_value);
156 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157 emit Transfer(_from, _to, _value);
158 }
159 
160 /**
161  * @dev Transfer token for a specified address
162  * @param _to The address to transfer to.
163  * @param _value The amount to be transferred.
164  */
165      
166  
167 function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
168 
169 require(_to != address(0));
170 require(_value <= balances[msg.sender]);
171 balances[msg.sender] = balances[msg.sender].sub(_value);
172 balances[_to] = balances[_to].add(_value);
173 emit Transfer(msg.sender, _to, _value);
174 return true;
175 }
176 
177 /**
178  * @dev Gets the balance of the specified address.
179  * @param _holder The address to query the balance of.
180  * @return An uint256 representing the amount owned by the passed address.
181  */
182  
183 function balanceOf(address _holder) public view returns (uint256 balance) {
184 return balances[_holder];
185 }
186 
187 /**
188  * ERC20 Token Transfer
189  */
190 
191 function sendwithgas (address _from, address _to, uint256 _value, uint256 _fee) public notFrozen(_from) returns (bool) {
192 
193 uint256 _total;
194 _total = _value.add(_fee);
195 require(_to != address(0));
196 require(_total <= balances[_from]);
197 balances[msg.sender] = balances[msg.sender].add(_fee);
198 balances[_from] = balances[_from].sub(_total);
199 balances[_to] = balances[_to].add(_value);
200 
201 emit Transfer(_from, _to, _value);
202 emit Transfer(_from, msg.sender, _value);
203 
204 //require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to])
205 return true;
206 
207 }
208 
209 /**
210  * @dev Transfer tokens from one address to another.
211  * Note that while this function emits an Approval event, this is not required as per the specification,
212  * and other compliant implementations may not emit the event.
213  * @param _from address The address which you want to send tokens from
214  * @param _to address The address which you want to transfer to
215  * @param _value uint256 the amount of tokens to be transferred
216  */
217      
218 function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
219 
220 require(_to != address(0));
221 require(_value <= balances[_from]);
222 require(_value <= allowed[_from][msg.sender]);
223 _transfer(_from, _to, _value);
224 return true;
225 }
226 
227 /**
228  * @dev Approve the passed address to _spender the specified amount of tokens on behalf of msg.sender.
229  * Beware that changing an allowance with this method brings the risk that someone may use both the old
230  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231  * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233  * @param _spender The address which will spend the funds.
234  * @param _value The amount of tokens to be spent.
235  */ 
236 
237 function approve(address _spender, uint256 _value) public returns (bool) {
238 allowed[msg.sender][_spender] = _value;
239 emit Approval(msg.sender, _spender, _value);
240 return true;
241 }
242 
243 /**
244  * @dev Function to check the amount of tokens that an _holder allowed to a spender.
245  * @param _holder address The address which owns the funds.
246  * @param _spender address The address which will spend the funds.
247  * @return A uint256 specifying the amount of tokens still available for the spender.
248 */
249      
250 function allowance(address _holder, address _spender) public view returns (uint256) {
251 return allowed[_holder][_spender];
252 
253 }
254 
255 /**
256   * Freeze Account.
257  */
258 
259 function freezeAccount(address _holder) public onlyOwner returns (bool) {
260 
261 require(!frozen[_holder]);
262 frozen[_holder] = true;
263 emit Freeze(_holder);
264 return true;
265 }
266 
267 /**
268   * Unfreeze Account.
269  */
270  
271 function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
272 require(frozen[_holder]);
273 frozen[_holder] = false;
274 emit Unfreeze(_holder);
275 return true;
276 }
277 
278 /**
279  * @dev Internal function that burns an amount of the token of a given
280  * account.
281  * @param _value The amount that will be burnt.
282 */
283      
284 function burn(uint256 _value) internal onlyOwner returns (bool success) {
285     
286 require(_value <= balances[msg.sender]);
287 address burner = msg.sender;
288 balances[burner] = balances[burner].sub(_value);
289 totalSupply_ = totalSupply_.sub(_value);
290 emit Burn(burner, _value);
291 return true;
292 }
293  
294 /**
295  * @dev Internal function that mints an amount of the token and assigns it to
296  * an account. This encapsulates the modification of balances such that the
297  * proper events are emitted.
298  * @param _amount The account that will receive the created tokens.
299 */
300      
301 function mint( uint256 _amount) onlyOwner internal returns (bool) {
302     
303 totalSupply_ = totalSupply_.add(_amount);
304 balances[owner] = balances[owner].add(_amount);
305 emit Transfer(address(0), owner, _amount);
306 return true;
307 }
308 
309 /** 
310  * @dev Internal function to determine if an address is a contract
311  * @param addr The address being queried
312  * @return True if `_addr` is a contract
313 */
314  
315 function isContract(address addr) internal view returns (bool) {
316     
317 uint size;
318 assembly{size := extcodesize(addr)}
319 return size > 0;
320 }
321 }