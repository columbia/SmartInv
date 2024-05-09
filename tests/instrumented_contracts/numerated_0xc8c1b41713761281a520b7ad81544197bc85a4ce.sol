1 // Dependency file: contracts/ETH/libraries/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity >=0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // Dependency file: contracts/ETH/libraries/TransferHelper.sol
164 
165 // SPDX-License-Identifier: GPL-3.0-or-later
166 
167 // pragma solidity >=0.6.0;
168 
169 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
170 library TransferHelper {
171     function safeApprove(address token, address to, uint value) internal {
172         // bytes4(keccak256(bytes('approve(address,uint256)')));
173         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
174         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
175     }
176 
177     function safeTransfer(address token, address to, uint value) internal {
178         // bytes4(keccak256(bytes('transfer(address,uint256)')));
179         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
180         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
181     }
182 
183     function safeTransferFrom(address token, address from, address to, uint value) internal {
184         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
185         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
186         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
187     }
188 
189     function safeTransferETH(address to, uint value) internal {
190         (bool success,) = to.call{value:value}(new bytes(0));
191         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
192     }
193 }
194 
195 
196 // Root file: contracts/ETH/ETHBurgerTransit.sol
197 
198 // SPDX-License-Identifier: MIT
199 pragma solidity >=0.5.16;
200 
201 // import 'contracts/ETH/libraries/SafeMath.sol';
202 // import 'contracts/ETH/libraries/TransferHelper.sol';
203 
204 interface IWETH {
205     function deposit() external payable;
206     function withdraw(uint) external;
207 }
208 
209 contract ETHBurgerTransit {
210     using SafeMath for uint;
211     
212     address public owner;
213     address public signWallet;
214     address public developWallet;
215     address public WETH;
216     
217     uint public totalFee;
218     uint public developFee;
219     
220     // key: payback_id
221     mapping (bytes32 => bool) public executedMap;
222     
223     uint private unlocked = 1;
224 
225     modifier lock() {
226         require(unlocked == 1, 'Locked');
227         unlocked = 0;
228         _;
229         unlocked = 1;
230     }
231     
232     event Transit(address indexed from, address indexed token, uint amount);
233     event Withdraw(bytes32 paybackId, address indexed to, address indexed token, uint amount);
234     event CollectFee(address indexed handler, uint amount);
235     
236     constructor(address _WETH, address _signer, address _developer) public {
237         WETH = _WETH;
238         signWallet = _signer;
239         developWallet = _developer;
240         owner = msg.sender;
241     }
242     
243     receive() external payable {
244         assert(msg.sender == WETH);
245     }
246     
247     function changeSigner(address _wallet) external {
248         require(msg.sender == owner, "CHANGE_SIGNER_FORBIDDEN");
249         signWallet = _wallet;
250     }
251     
252     function changeDevelopWallet(address _developWallet) external {
253         require(msg.sender == owner, "CHANGE_DEVELOP_WALLET_FORBIDDEN");
254         developWallet = _developWallet;
255     } 
256     
257     function changeDevelopFee(uint _amount) external {
258         require(msg.sender == owner, "CHANGE_DEVELOP_FEE_FORBIDDEN");
259         developFee = _amount;
260     }
261     
262     function collectFee() external {
263         require(msg.sender == owner, "FORBIDDEN");
264         require(developWallet != address(0), "SETUP_DEVELOP_WALLET");
265         require(totalFee > 0, "NO_FEE");
266         TransferHelper.safeTransferETH(developWallet, totalFee);
267         totalFee = 0;
268     }
269     
270     function transitForBSC(address _token, uint _amount) external {
271         require(_amount > 0, "INVALID_AMOUNT");
272         TransferHelper.safeTransferFrom(_token, msg.sender, address(this), _amount);
273         emit Transit(msg.sender, _token, _amount);
274     }
275     
276     function transitETHForBSC() external payable {
277         require(msg.value > 0, "INVALID_AMOUNT");
278         IWETH(WETH).deposit{value: msg.value}();
279         emit Transit(msg.sender, WETH, msg.value);
280     }
281     
282     function withdrawFromBSC(bytes calldata _signature, bytes32 _paybackId, address _token, uint _amount) external lock payable {
283         require(executedMap[_paybackId] == false, "ALREADY_EXECUTED");
284         executedMap[_paybackId] = true;
285         
286         require(_amount > 0, "NOTHING_TO_WITHDRAW");
287         require(msg.value == developFee, "INSUFFICIENT_VALUE");
288         
289         bytes32 message = keccak256(abi.encodePacked(_paybackId, _token, msg.sender, _amount));
290         require(_verify(message, _signature), "INVALID_SIGNATURE");
291         
292         if(_token == WETH) {
293             IWETH(WETH).withdraw(_amount);
294             TransferHelper.safeTransferETH(msg.sender, _amount);
295         } else {
296             TransferHelper.safeTransfer(_token, msg.sender, _amount);
297         }
298         totalFee = totalFee.add(developFee);
299         
300         emit Withdraw(_paybackId, msg.sender, _token, _amount);
301     }
302     
303     function _verify(bytes32 _message, bytes memory _signature) internal view returns (bool) {
304         bytes32 hash = _toEthBytes32SignedMessageHash(_message);
305         address[] memory signList = _recoverAddresses(hash, _signature);
306         return signList[0] == signWallet;
307     }
308     
309     function _toEthBytes32SignedMessageHash (bytes32 _msg) pure internal returns (bytes32 signHash)
310     {
311         signHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _msg));
312     }
313     
314     function _recoverAddresses(bytes32 _hash, bytes memory _signatures) pure internal returns (address[] memory addresses)
315     {
316         uint8 v;
317         bytes32 r;
318         bytes32 s;
319         uint count = _countSignatures(_signatures);
320         addresses = new address[](count);
321         for (uint i = 0; i < count; i++) {
322             (v, r, s) = _parseSignature(_signatures, i);
323             addresses[i] = ecrecover(_hash, v, r, s);
324         }
325     }
326     
327     function _parseSignature(bytes memory _signatures, uint _pos) pure internal returns (uint8 v, bytes32 r, bytes32 s)
328     {
329         uint offset = _pos * 65;
330         assembly {
331             r := mload(add(_signatures, add(32, offset)))
332             s := mload(add(_signatures, add(64, offset)))
333             v := and(mload(add(_signatures, add(65, offset))), 0xff)
334         }
335 
336         if (v < 27) v += 27;
337 
338         require(v == 27 || v == 28);
339     }
340     
341     function _countSignatures(bytes memory _signatures) pure internal returns (uint)
342     {
343         return _signatures.length % 65 == 0 ? _signatures.length / 65 : 0;
344     }
345 }