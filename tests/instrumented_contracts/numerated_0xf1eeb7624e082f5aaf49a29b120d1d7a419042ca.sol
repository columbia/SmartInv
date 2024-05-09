1 pragma solidity ^0.4.24;
2 
3 
4 /**
5 * @title SafeMath
6 * @dev Math operations with safety checks that throw on error
7 */
8 library SafeMath {
9 
10 /**
11 * @dev Multiplies two numbers, throws on overflow.
12 */
13 function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14 if (a == 0) {
15 return 0;
16 }
17 c = a * b;
18 assert(c / a == b);
19 return c;
20 }
21 
22 /**
23 * @dev Integer division of two numbers, truncating the quotient.
24 */
25 function div(uint256 a, uint256 b) internal pure returns (uint256) {
26 // assert(b > 0); // Solidity automatically throws when dividing by 0
27 // uint256 c = a / b;
28 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 return a / b;
30 }
31 
32 /**
33 * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34 */
35 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36 assert(b <= a);
37 return a - b;
38 }
39 
40 /**
41 * @dev Adds two numbers, throws on overflow.
42 */
43 function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44 c = a + b;
45 assert(c >= a);
46 return c;
47 }
48 }
49 
50 
51 /**
52 * @title Ownable
53 * @dev The Ownable contract has an owner address, and provides basic authorization control
54 * functions, this simplifies the implementation of "user permissions".
55 */
56 contract Ownable {
57 address public owner;
58 
59 
60 /**
61 * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
62 */
63 constructor() public {
64 owner = msg.sender;
65 }
66 
67 /**
68 * @dev Throws if called by any account other than the owner.
69 */
70 modifier onlyOwner() {
71 require(msg.sender == owner);
72 _;
73 }
74 
75 /**
76 * @dev Allows the current owner to transfer control of the contract to a newOwner.
77 * @param newOwner The address to transfer ownership to.
78 */
79 function transferOwnership(address newOwner) public onlyOwner {
80 if (newOwner != address(0)) {
81 owner = newOwner;
82 }
83 }
84 
85 }
86 
87 
88 contract ERC223 {
89 uint256 public totalSupply_;
90 function balanceOf(address _owner) public view returns (uint256 balance);
91 function totalSupply() public view returns (uint256 _supply);
92 
93 function allowance(address owner, address spender) public view returns (uint256);
94 function transferFrom(address from, address to, uint256 value) public returns (bool);
95 function approve(address spender, uint256 value) public returns (bool);
96 event Approval(address indexed owner, address indexed spender, uint256 value);
97 
98 function transfer(address to, uint value) public returns (bool success);
99 function transfer(address to, uint value, bytes data) public returns (bool success);
100 event Transfer(address indexed _from, address indexed _to, uint256 _value);
101 event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
102 }
103 
104 
105 contract ContractReceiver {
106 /**
107 * @dev Standard ERC223 function that will handle incoming token transfers.
108 * @param _from Token sender address.
109 * @param _value Amount of tokens.
110 * @param _data Transaction metadata.
111 */
112 function tokenFallback(address _from, uint _value, bytes _data) public;
113 }
114 
115 
116 contract ERC223Token is ERC223 {
117 using SafeMath for uint256;
118 
119 mapping(address => uint256) balances;
120 mapping (address => mapping (address => uint256)) internal allowed;
121 
122 uint256 public totalSupply_;
123 
124 /**
125 * @dev total number of tokens in existence
126 */
127 function totalSupply() public view returns (uint256 _supply) {
128 return totalSupply_;
129 }
130 
131 /**
132 * @dev transfer token for a specified address
133 * @param _to The address to transfer to.
134 * @param _value The amount to be transferred.
135 * @param _data Transaction metadata.
136 */
137 function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
138 if (isContract(_to)) {
139 return transferToContract(_to, _value, _data);
140 } else {
141 return transferToAddress(_to, _value, _data);
142 }
143 }
144 
145 /**
146 * @dev transfer token for a specified address similar to ERC20 transfer.
147 * @dev Added due to backwards compatibility reasons.
148 * @param _to The address to transfer to.
149 * @param _value The amount to be transferred.
150 */
151 function transfer(address _to, uint _value) public returns (bool success) {
152 bytes memory empty;
153 if (isContract(_to)) {
154 return transferToContract(_to, _value, empty);
155 } else {
156 return transferToAddress(_to, _value, empty);
157 }
158 }
159 
160 /**
161 * @dev Gets the balance of the specified address.
162 * @param _owner The address to query the balance of.
163 * @return An uint256 representing the amount owned by the passed address.
164 */
165 function balanceOf(address _owner) public view returns (uint256 balance) {
166 return balances[_owner];
167 }
168 
169 /**
170 * @dev Transfer tokens from one address to another
171 * @param _from address The address which you want to send tokens from
172 * @param _to address The address which you want to transfer to
173 * @param _value uint256 the amount of tokens to be transferred
174 */
175 function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176 require(_to != address(0));
177 require(_value <= balances[_from]);
178 require(_value <= allowed[_from][msg.sender]);
179 
180 balances[_from] = balances[_from].sub(_value);
181 balances[_to] = balances[_to].add(_value);
182 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183 Transfer(_from, _to, _value);
184 return true;
185 }
186 
187 /**
188 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189 *
190 * Beware that changing an allowance with this method brings the risk that someone may use both the old
191 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194 * @param _spender The address which will spend the funds.
195 * @param _value The amount of tokens to be spent.
196 */
197 function approve(address _spender, uint256 _value) public returns (bool) {
198 allowed[msg.sender][_spender] = _value;
199 Approval(msg.sender, _spender, _value);
200 return true;
201 }
202 
203 /**
204 * @dev Function to check the amount of tokens that an owner allowed to a spender.
205 * @param _owner address The address which owns the funds.
206 * @param _spender address The address which will spend the funds.
207 * @return A uint256 specifying the amount of tokens still available for the spender.
208 */
209 function allowance(address _owner, address _spender) public view returns (uint256) {
210 return allowed[_owner][_spender];
211 }
212 
213 /**
214 * @dev Increase the amount of tokens that an owner allowed to a spender.
215 *
216 * approve should be called when allowed[_spender] == 0. To increment
217 * allowed value is better to use this function to avoid 2 calls (and wait until
218 * the first transaction is mined)
219 * From MonolithDAO Token.sol
220 * @param _spender The address which will spend the funds.
221 * @param _addedValue The amount of tokens to increase the allowance by.
222 */
223 function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
224 allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225 Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226 return true;
227 }
228 
229 /**
230 * @dev Decrease the amount of tokens that an owner allowed to a spender.
231 *
232 * approve should be called when allowed[_spender] == 0. To decrement
233 * allowed value is better to use this function to avoid 2 calls (and wait until
234 * the first transaction is mined)
235 * From MonolithDAO Token.sol
236 * @param _spender The address which will spend the funds.
237 * @param _subtractedValue The amount of tokens to decrease the allowance by.
238 */
239 function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240 uint oldValue = allowed[msg.sender][_spender];
241 if (_subtractedValue > oldValue) {
242 allowed[msg.sender][_spender] = 0;
243 } else {
244 allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245 }
246 Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247 return true;
248 }
249 
250 /**
251 * @dev isContract
252 * @param _addr The address to check if it's a contract or not
253 * @return true if _addr is a contract
254 */
255 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
256 function isContract(address _addr) private view returns (bool is_contract) {
257 uint length;
258 /* solium-disable-next-line */
259 assembly {
260 //retrieve the size of the code on target address, this needs assembly
261 length := extcodesize(_addr)
262 }
263 if (length > 0) {
264 return true;
265 } else {
266 return false;
267 }
268 }
269 
270 /**
271 * @dev transferToAddress transfers the specified amount of tokens to the specified address
272 * @param _to Receiver address.
273 * @param _value Amount of tokens that will be transferred.
274 * @param _data Transaction metadata.
275 * @return true if transaction went through
276 */
277 function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
278 if (balanceOf(msg.sender) < _value) revert();
279 balances[msg.sender] = balanceOf(msg.sender).sub(_value);
280 balances[_to] = balanceOf(_to).add(_value);
281 Transfer(msg.sender, _to, _value);
282 ERC223Transfer(msg.sender, _to, _value, _data);
283 return true;
284 }
285 
286 /**
287 * @dev transferToContract transfers the specified amount of tokens to the specified contract address
288 * @param _to Receiver address.
289 * @param _value Amount of tokens that will be transferred.
290 * @param _data Transaction metadata.
291 * @return true if transaction went through
292 */
293 function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
294 if (balanceOf(msg.sender) < _value) revert();
295 balances[msg.sender] = balanceOf(msg.sender).sub(_value);
296 balances[_to] = balanceOf(_to).add(_value);
297 ContractReceiver reciever = ContractReceiver(_to);
298 reciever.tokenFallback(msg.sender, _value, _data);
299 Transfer(msg.sender, _to, _value);
300 ERC223Transfer(msg.sender, _to, _value, _data);
301 return true;
302 }
303 
304 function addTokenToTotalSupply(uint _value) public {
305 require(_value > 0);
306 balances[msg.sender] = balances[msg.sender] + _value;
307 totalSupply_ = totalSupply_ + _value;
308 
309 }
310 }
311 
312 /**
313 * @title BFEXToken Bank Future Exchange Token Contract by AngelCoin.io
314 */
315 contract LIRAS is ERC223Token, Ownable {
316 
317 string public constant name = "LIRAS";
318 string public constant symbol = "LRS";
319 uint8 public constant decimals = 18;
320 
321 uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
322 address public feeHoldingAddress;
323 
324 address public owner;
325 
326 /**
327 * @dev BFEXToken Constructor gives msg..
328 */
329 function LIRAS() public {
330 totalSupply_ = INITIAL_SUPPLY;
331 balances[msg.sender] = INITIAL_SUPPLY;
332 owner = msg.sender;
333 feeHoldingAddress = owner;
334 Transfer(0x0, msg.sender, INITIAL_SUPPLY);
335 }
336 
337 /**
338 * @dev transfer token for a specified address similar to ERC20 transfer.
339 * @dev Added due to backwards compatibility reasons.
340 * @param _to The address to transfer to.
341 * @param _value The amount to be transferred.
342 */
343 function adminTransfer(address _from, address _to, uint _value, uint _fee) public payable onlyOwner returns (bool success) {
344 require(_to != address(0));
345 require(_value <= balances[_from]);
346 require(_value > _fee);
347 
348 balances[feeHoldingAddress] = balances[feeHoldingAddress].add(_fee);
349 
350 uint256 actualValue = _value.sub(_fee);
351 balances[_from] = balances[_from].sub(_value);
352 balances[_to] = balances[_to].add(actualValue);
353 Transfer(_from, _to, actualValue);
354 Transfer(_from, feeHoldingAddress, _fee);
355 return true;
356 }
357 
358 
359 function changeFeeHoldingAddress(address newFeeHoldingAddress) public onlyOwner {
360 feeHoldingAddress = newFeeHoldingAddress;
361 }
362 
363 
364 }