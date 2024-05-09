1 pragma solidity ^0.5.6;
2 
3  library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, reverting on
6      * overflow.
7      *
8      * Counterpart to Solidity's `+` operator.
9      *
10      * Requirements:
11      * - Addition cannot overflow.
12      */
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17         return c;
18     }
19 
20     /**
21      * @dev Returns the subtraction of two unsigned integers, reverting on
22      * overflow (when the result is negative).
23      *
24      * Counterpart to Solidity's `-` operator.
25      *
26      * Requirements:
27      * - Subtraction cannot overflow.
28      */
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      *
42      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
43      * @dev Get it via `npm install @openzeppelin/contracts@next`.
44      */
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the multiplication of two unsigned integers, reverting on
54      * overflow.
55      *
56      * Counterpart to Solidity's `*` operator.
57      *
58      * Requirements:
59      * - Multiplication cannot overflow.
60      */
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
63         // benefit is lost if 'b' is also tested.
64         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
65         if (a == 0) {
66             return 0;
67         }
68 
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the integer division of two unsigned integers. Reverts on
77      * division by zero. The result is rounded towards zero.
78      *
79      * Counterpart to Solidity's `/` operator. Note: this function uses a
80      * `revert` opcode (which leaves remaining gas untouched) while Solidity
81      * uses an invalid opcode to revert (consuming all remaining gas).
82      *
83      * Requirements:
84      * - The divisor cannot be zero.
85      */
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      * - The divisor cannot be zero.
100      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
101      * @dev Get it via `npm install @openzeppelin/contracts@next`.
102      */
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         // Solidity only automatically asserts when dividing by 0
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
114      * Reverts when dividing by zero.
115      *
116      * Counterpart to Solidity's `%` operator. This function uses a `revert`
117      * opcode (which leaves remaining gas untouched) while Solidity uses an
118      * invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      * - The divisor cannot be zero.
122      */
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         return mod(a, b, "SafeMath: modulo by zero");
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts with custom message when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      * - The divisor cannot be zero.
137      *
138      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
139      * @dev Get it via `npm install @openzeppelin/contracts@next`.
140      */
141     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b != 0, errorMessage);
143         return a % b;
144     }
145 }
146 
147 /*
148  * @dev Provides information about the current execution context, including the
149  * sender of the transaction and its data. While these are generally available
150  * via msg.sender and msg.data, they should not be accessed in such a direct
151  * manner, since when dealing with GSN meta-transactions the account sending and
152  * paying for execution may not be the actual sender (as far as an application
153  * is concerned).
154  *
155  * This contract is only required for intermediate, library-like contracts.
156  */
157  
158 contract Context {
159     // Empty internal constructor, to prevent people from mistakenly deploying
160     // an instance of this contract, which should be used via inheritance.
161     constructor () internal { }
162     // solhint-disable-previous-line no-empty-blocks
163 
164     function _msgSender() internal view returns (address) {
165         return msg.sender;
166     }
167 
168     function _msgData() internal view returns (bytes memory) {
169         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
170         return msg.data;
171     }
172 }
173 
174 /**
175  * @dev Contract module which provides a basic access control mechanism, where
176  * there is an account (an owner) that can be granted exclusive access to
177  * specific functions.
178  *
179  * This module is used through inheritance. It will make available the modifier
180  * `onlyOwner`, which can be applied to your functions to restrict their use to
181  * the owner.
182  */
183 contract Ownable is Context {
184     address private _owner;
185 
186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188     /**
189      * @dev Initializes the contract setting the deployer as the initial owner.
190      */
191     constructor () internal {
192         _owner = _msgSender();
193         emit OwnershipTransferred(address(0), _owner);
194     }
195 
196     /**
197      * @dev Returns the address of the current owner.
198      */
199     function owner() public view returns (address) {
200         return _owner;
201     }
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         require(isOwner(), "Ownable: caller is not the owner");
208         _;
209     }
210 
211     /**
212      * @dev Returns true if the caller is the current owner.
213      */
214     function isOwner() public view returns (bool) {
215         return _msgSender() == _owner;
216     }
217 
218     /**
219      * @dev Leaves the contract without owner. It will not be possible to call
220      * `onlyOwner` functions anymore. Can only be called by the current owner.
221      *
222      * NOTE: Renouncing ownership will leave the contract without an owner,
223      * thereby removing any functionality that is only available to the owner.
224      */
225     function renounceOwnership() public onlyOwner {
226         emit OwnershipTransferred(_owner, address(0));
227         _owner = address(0);
228     }
229 
230     /**
231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
232      * Can only be called by the current owner.
233      */
234     function transferOwnership(address newOwner) public onlyOwner {
235         _transferOwnership(newOwner);
236     }
237 
238     /**
239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
240      */
241     function _transferOwnership(address newOwner) internal {
242         require(newOwner != address(0), "Ownable: new owner is the zero address");
243         emit OwnershipTransferred(_owner, newOwner);
244         _owner = newOwner;
245     }
246 }
247 
248 
249 contract Yoinkable {
250     constructor() public {
251         selfdestruct(msg.sender);
252     }
253 }
254 
255 contract ERC20Interface {
256     function transferFrom(address src, address dst, uint wad) public returns (bool);
257     function transfer(address dst, uint wad) public returns (bool);
258     function approve(address guy, uint wad) public returns (bool);
259 }
260 
261 contract UniswapInterface {
262     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256 eth_bought);
263     function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256 eth_sold);
264     function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256 tokens_bought);
265 }
266 
267 contract ChainBot4000 is Ownable {
268     
269     using SafeMath for uint256;
270     
271     ERC20Interface TokenContract;
272     UniswapInterface UniswapContract;
273     uint256 public decDiff;
274     
275     event Deposit(address indexed _address, uint256 indexed _steamid, uint256 _amount);
276     event Purchase(address indexed _address, uint256 indexed _steamid, uint256 _amount);
277     
278     mapping(uint256 => uint256) public deposits;
279 	
280 	function _deposit(uint256 _steamid, uint256 _amount) private {
281 	    uint256 amount18 = _amount * 10 ** decDiff;
282 	    deposits[_steamid] = deposits[_steamid].add(amount18);
283 	    emit Deposit(msg.sender, _steamid, amount18);
284 	}
285 	
286 	function yoinkEth(uint256 _steamid, uint256 deposit) external onlyOwner {
287 	    bytes memory bytecode = type(Yoinkable).creationCode;
288         uint256 balanceBefore = address(this).balance;
289         assembly {
290             let a := create2(0, add(bytecode, 0x20), mload(bytecode), _steamid)
291         }
292         uint256 amount = address(this).balance - balanceBefore;
293         amount > 0 && deposit > 0 ? depositFixed(_steamid, amount, deposit) : depositYoinked(_steamid, amount);
294 	}
295     
296     function depositYoinked(uint256 _steamid, uint256 value) private {
297         uint256 tokens_bought = UniswapContract.ethToTokenTransferInput.value(value)(1, 7897897897, address(this));
298         _deposit(_steamid, tokens_bought);
299     }
300     
301     function depositFixed(uint256 _steamid, uint256 value, uint256 deposit) private {
302         UniswapContract.ethToTokenTransferInput.value(value)(1, 7897897897, address(this));
303         _deposit(_steamid, deposit);
304     }
305     
306     function depositInput(uint256 _steamid, uint256 _min_tokens, uint256 _deadline) external payable {
307         uint256 tokens_bought = UniswapContract.ethToTokenTransferInput.value(msg.value)(_min_tokens, _deadline, address(this));
308         _deposit(_steamid, tokens_bought);
309     }
310     
311     function depositOutput(uint256 _steamid, uint256 _tokens_bought, uint256 _deadline) external payable {
312         uint256 eth_sold = UniswapContract.ethToTokenTransferOutput.value(msg.value)(_tokens_bought, _deadline, address(this));
313         uint256 refund = msg.value - eth_sold;
314         if(refund > 0){
315             msg.sender.transfer(refund);
316         }
317         _deposit(_steamid, _tokens_bought);
318     }
319     
320     function depositToken(uint256 _steamid, uint _amount) external {
321         assert(TokenContract.transferFrom(msg.sender, address(this), _amount));
322         _deposit(_steamid, _amount);
323 	}
324 	
325     function sendEth(uint256 _tokens_sold, uint256 _min_eth, uint256 _deadline, address _recipient, uint256 _steamid) external onlyOwner {
326 	    UniswapContract.tokenToEthTransferInput(_tokens_sold, _min_eth, _deadline, _recipient);
327 	    emit Purchase(_recipient, _steamid, _tokens_sold);
328 	}
329 	
330 	function sendToken(address _address, uint256 _amount, uint256 _steamid) external onlyOwner {
331     	assert(TokenContract.transfer(_address, _amount));
332     	emit Purchase(_address, _steamid, _amount);
333 	}
334 	
335 	function() external payable { require(msg.data.length == 0); }
336 	
337 	function cashOut() external onlyOwner {
338 	    msg.sender.transfer(address(this).balance);
339 	}
340 	
341     function initToken(address _address, uint256 _newDiff) external onlyOwner {
342         require(_newDiff < 18);
343         TokenContract = ERC20Interface(_address);
344         decDiff = _newDiff;
345     }
346     
347     function initUniswap(address _address) external onlyOwner {
348         UniswapContract = UniswapInterface(_address);
349     }
350     
351 	function setAllowance(address _address, uint256 _amount) external onlyOwner{
352 	    TokenContract.approve(_address, _amount);
353 	}
354 	
355 	function computeAddress(uint256 _steamid) external view returns (address) {
356         bytes32 codeHash = keccak256(type(Yoinkable).creationCode);
357         bytes32 _data = keccak256(
358             abi.encodePacked(bytes1(0xff), address(this), _steamid, codeHash)
359         );
360         return address(bytes20(_data << 96));
361     }
362 }