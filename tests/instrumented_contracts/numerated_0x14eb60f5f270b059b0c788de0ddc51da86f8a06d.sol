1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
4 
5 abstract contract Pausable {
6     /**
7      * @dev Emitted when the pause is triggered by `account`.
8      */
9     event Paused(address account);
10 
11     /**
12      * @dev Emitted when the pause is lifted by `account`.
13      */
14     event Unpaused(address account);
15 
16     bool private _paused;
17 
18     /**
19      * @dev Initializes the contract in unpaused state.
20      */
21     constructor () {
22         _paused = false;
23     }
24 
25     /**
26      * @dev Returns true if the contract is paused, and false otherwise.
27      */
28     function paused() public view returns (bool) {
29         return _paused;
30     }
31 
32     /**
33      * @dev Modifier to make a function callable only when the contract is not paused.
34      *
35      * Requirements:
36      *
37      * - The contract must not be paused.
38      */
39     modifier whenNotPaused() {
40         require(!_paused, "Pausable: paused");
41         _;
42     }
43 
44     /**
45      * @dev Modifier to make a function callable only when the contract is paused.
46      *
47      * Requirements:
48      *
49      * - The contract must be paused.
50      */
51     modifier whenPaused() {
52         require(_paused, "Pausable: not paused");
53         _;
54     }
55 
56     /**
57      * @dev Triggers stopped state.
58      *
59      * Requirements:
60      *
61      * - The contract must not be paused.
62      */
63     function _pause() internal virtual whenNotPaused {
64         _paused = true;
65         emit Paused(msg.sender);
66     }
67 
68     /**
69      * @dev Returns to normal state.
70      *
71      * Requirements:
72      *
73      * - The contract must be paused.
74      */
75     function _unpause() internal virtual whenPaused {
76         _paused = false;
77         emit Unpaused(msg.sender);
78     }
79 }
80 
81 /**
82  * @dev Wrappers over Solidity's arithmetic operations with added overflow
83  * checks.
84  *
85  * Arithmetic operations in Solidity wrap on overflow. This can easily result
86  * in bugs, because programmers usually assume that an overflow raises an
87  * error, which is the standard behavior in high level programming languages.
88  * `SafeMath` restores this intuition by reverting the transaction when an
89  * operation overflows.
90  *
91  * Using this library instead of the unchecked operations eliminates an entire
92  * class of bugs, so it's recommended to use it always.
93  */
94 library SafeMath {
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         return div(a, b, "SafeMath: division by zero");
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         // Solidity only automatically asserts when dividing by 0
191         require(b > 0, errorMessage);
192         uint256 c = a / b;
193         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210         return mod(a, b, "SafeMath: modulo by zero");
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts with custom message when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b != 0, errorMessage);
226         return a % b;
227     }
228 }
229 
230 contract PhantasmaToken is Pausable {
231 
232 	using SafeMath for uint256;
233 
234     string private _name;
235     string private _symbol;
236     uint8 private _decimals;
237 
238     uint256 constant private MAX_UINT256 = 2**256 - 1;
239     mapping (address => uint256) private _balances;
240     mapping (address => mapping (address => uint256)) private _allowances;
241     mapping(address => bool) private _burnAddresses;
242 	
243 	uint256 private _totalSupply;
244     address private _producer;
245 	
246 	function name() public view returns (string memory) {
247         return _name;
248     }
249 
250     function symbol() public view returns (string memory) {
251         return _symbol;
252     }
253 	
254     function decimals() public view returns (uint8) {
255         return _decimals;
256     }
257 
258     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
259         _name = name_;
260         _symbol = symbol_;
261         _decimals = decimals_;
262         _totalSupply = 0;                        
263 		_producer = msg.sender;
264 		addNodeAddress(msg.sender);
265     }
266 	
267     function addNodeAddress(address _address) public {
268 		require(msg.sender == _producer);
269 		require(!_burnAddresses[msg.sender]);
270         _burnAddresses[_address] = true;
271     }
272 
273     function deleteNodeAddress(address _address) public {
274 		require(msg.sender == _producer);
275         require(_burnAddresses[_address]);
276         _burnAddresses[_address] = true;
277     }
278 
279     function transfer(address _to, uint256 _value) public returns (bool success) {
280         require(!paused(), "transfer while paused" );
281         require(_balances[msg.sender] >= _value);
282 
283         if (_burnAddresses[_to]) {
284 
285            return swapOut(msg.sender, _to, _value);
286 
287         } else {
288 
289             _balances[msg.sender] = _balances[msg.sender].sub(_value);
290             _balances[_to] = _balances[_to].add(_value);
291             emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
292             return true;
293 
294         }
295     }
296 
297     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
298         require(!paused(), "transferFrom while paused");
299 
300         uint256 allowance = _allowances[_from][msg.sender];
301         require(_balances[_from] >= _value && allowance >= _value);
302 
303         _balances[_to] = _balances[_to].add(_value);
304         _balances[_from] = _balances[_from].sub(_value);
305 
306         if (allowance < MAX_UINT256) {
307             _allowances[_from][msg.sender] -= _value;
308         }
309 
310         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
311         return true;
312     }
313 
314     function balanceOf(address account) public view returns (uint256) {
315         return _balances[account];
316     }
317 
318     function approve(address _spender, uint256 _value) public returns (bool) {
319         _allowances[msg.sender][_spender] = _value;
320         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
321         return true;
322     }
323 
324     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
325         require(!paused(), "allowance while paused");
326         return _allowances[_owner][_spender];
327     }
328 	
329     function totalSupply() public view returns (uint256) {
330         return _totalSupply;
331     }
332 
333     function swapInit(address newProducer) public returns (bool success) {
334 		require(msg.sender == _producer);
335 		_burnAddresses[_producer] = false;
336 		_producer = newProducer;
337 		_burnAddresses[newProducer] = true;
338 		emit SwapInit(msg.sender, newProducer);
339 		return true;
340     }
341 
342     function swapIn(address source, address target, uint256 amount) public returns (bool success) {
343         require(!paused(), "swapIn while paused" );
344 		require(msg.sender == _producer); // only called by Spook
345         _totalSupply = _totalSupply.add(amount);
346         _balances[target] = _balances[target].add(amount);
347         emit Transfer(source, target, amount);
348 		return true;
349     }
350 
351     function swapOut(address source, address target, uint256 amount) private returns (bool success) {
352 		require(msg.sender == source, "sender != source");
353 		require(_balances[source] >= amount);
354 		require(_totalSupply >= amount);
355 		
356         _totalSupply = _totalSupply.sub(amount);
357         _balances[source] = _balances[source].sub(amount);
358         emit Transfer(source, target, amount);
359 		return true;
360     }
361 
362     function pause() public {
363 		require(msg.sender == _producer);
364         _pause();
365     }
366 
367     function unpause() public {
368 		require(msg.sender == _producer);
369         _unpause();
370     }
371 
372     
373     // solhint-disable-next-line no-simple-event-func-name
374     event SwapInit(address indexed _from, address indexed _to);
375     event Transfer(address indexed _from, address indexed _to, uint256 _value);
376     event Approval(address indexed _owner, address indexed _spender, uint256 _value);	
377 }