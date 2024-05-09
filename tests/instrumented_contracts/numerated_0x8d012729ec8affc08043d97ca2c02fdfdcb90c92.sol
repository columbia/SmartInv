1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 interface ITokenInterface {
162     /** ERC20 **/
163     function totalSupply() external view returns (uint);
164     function transfer(address recipient, uint amount) external returns (bool);
165 
166     /** VALUE, YFV, vUSD, vETH has minters **/
167     function minters(address account) external view returns (bool);
168     function mint(address _to, uint _amount) external;
169 
170     /** VALUE **/
171     function cap() external returns (uint);
172     function yfvLockedBalance() external returns (uint);
173 }
174 
175 interface IFreeFromUpTo {
176     function freeFromUpTo(address from, uint valueToken) external returns (uint freed);
177 }
178 
179 contract GovVaultRewardAutoCompound {
180     using SafeMath for uint;
181 
182     IFreeFromUpTo public constant chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
183 
184     modifier discountCHI(uint8 _flag) {
185         if ((_flag & 0x1) == 0) {
186             _;
187         } else {
188             uint gasStart = gasleft();
189             _;
190             uint gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
191             chi.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
192         }
193     }
194 
195     ITokenInterface public valueToken = ITokenInterface(0x49E833337ECe7aFE375e44F4E3e8481029218E5c);
196 
197     address public govVault = address(0xceC03a960Ea678A2B6EA350fe0DbD1807B22D875);
198     address public insuranceFund = address(0xb7b2Ea8A1198368f950834875047aA7294A2bDAa); // set to Governance Multisig at start
199     address public exploitCompensationFund = address(0x0000000000000000000000000000000000000000); // to compensate who lost during the exploit on Nov 14 2020
200     address public otherReserve = address(0x0000000000000000000000000000000000000000); // to reserve for future use
201 
202     uint public govVaultValuePerBlock = 0.2 ether;         // VALUE/block
203     uint public insuranceFundValuePerBlock = 0;            // VALUE/block
204     uint public exploitCompensationFundValuePerBlock = 0;  // VALUE/block
205     uint public otherReserveValuePerBlock = 0;             // VALUE/block
206 
207     uint public lastRewardBlock;    // Last block number that reward distribution occurs.
208     bool public minterPaused;       // if the minter is paused
209 
210     address public governance;
211 
212     event TransferToFund(address indexed fund, uint amount);
213 
214     constructor (ITokenInterface _valueToken, uint _govVaultValuePerBlock, uint _startBlock) public {
215         if (address(_valueToken) != address(0)) valueToken = _valueToken;
216         govVaultValuePerBlock = _govVaultValuePerBlock;
217         lastRewardBlock = (block.number > _startBlock) ? block.number : _startBlock;
218         governance = msg.sender;
219     }
220 
221     modifier onlyGovernance() {
222         require(msg.sender == governance, "!governance");
223         _;
224     }
225 
226     function setGovernance(address _governance) external onlyGovernance {
227         governance = _governance;
228     }
229 
230     function setMinterPaused(bool _minterPaused) external onlyGovernance {
231         minterPaused = _minterPaused;
232     }
233 
234     function setGovVault(address _govVault) external onlyGovernance {
235         govVault = _govVault;
236     }
237 
238     function setInsuranceFund(address _insuranceFund) external onlyGovernance {
239         insuranceFund = _insuranceFund;
240     }
241 
242     function setExploitCompensationFund(address _exploitCompensationFund) external onlyGovernance {
243         exploitCompensationFund = _exploitCompensationFund;
244     }
245 
246     function setOtherReserve(address _otherReserve) external onlyGovernance {
247         otherReserve = _otherReserve;
248     }
249 
250     function setGovVaultValuePerBlock(uint _govVaultValuePerBlock) external onlyGovernance {
251         require(_govVaultValuePerBlock <= 10 ether, "_govVaultValuePerBlock is insanely high");
252         mintAndSendFund(uint8(0));
253         govVaultValuePerBlock = _govVaultValuePerBlock;
254     }
255 
256     function setInsuranceFundValuePerBlock(uint _insuranceFundValuePerBlock) external onlyGovernance {
257         require(_insuranceFundValuePerBlock <= 1 ether, "_insuranceFundValuePerBlock is insanely high");
258         mintAndSendFund(uint8(0));
259         insuranceFundValuePerBlock = _insuranceFundValuePerBlock;
260     }
261 
262     function setExploitCompensationFundValuePerBlock(uint _exploitCompensationFundValuePerBlock) external onlyGovernance {
263         require(_exploitCompensationFundValuePerBlock <= 1 ether, "_exploitCompensationFundValuePerBlock is insanely high");
264         mintAndSendFund(uint8(0));
265         exploitCompensationFundValuePerBlock = _exploitCompensationFundValuePerBlock;
266     }
267 
268     function setOtherReserveValuePerBlock(uint _otherReserveValuePerBlock) external onlyGovernance {
269         require(_otherReserveValuePerBlock <= 1 ether, "_otherReserveValuePerBlock is insanely high");
270         mintAndSendFund(uint8(0));
271         otherReserveValuePerBlock = _otherReserveValuePerBlock;
272     }
273 
274     function mintAndSendFund(uint8 _flag) public discountCHI(_flag) {
275         if (minterPaused || lastRewardBlock >= block.number) {
276             return;
277         }
278         uint numBlks = block.number.sub(lastRewardBlock);
279         lastRewardBlock = block.number;
280         if (govVaultValuePerBlock > 0) _safeValueMint(govVault, govVaultValuePerBlock.mul(numBlks));
281         if (insuranceFundValuePerBlock > 0) _safeValueMint(insuranceFund, insuranceFundValuePerBlock.mul(numBlks));
282         if (exploitCompensationFundValuePerBlock > 0) _safeValueMint(exploitCompensationFund, exploitCompensationFundValuePerBlock.mul(numBlks));
283         if (otherReserveValuePerBlock > 0) _safeValueMint(otherReserve, otherReserveValuePerBlock.mul(numBlks));
284     }
285 
286     // Safe valueToken mint, ensure it is never over cap and we are the current owner.
287     function _safeValueMint(address _to, uint _amount) internal {
288         if (valueToken.minters(address(this)) && _to != address(0)) {
289             uint totalSupply = valueToken.totalSupply();
290             uint realCap = valueToken.cap().add(valueToken.yfvLockedBalance());
291             if (totalSupply.add(_amount) > realCap) {
292                 _amount = realCap.sub(totalSupply);
293             }
294             valueToken.mint(_to, _amount);
295             emit TransferToFund(_to, _amount);
296         }
297     }
298 
299     /**
300      * This function allows governance to take unsupported tokens out of the contract. This is in an effort to make someone whole, should they seriously mess up.
301      * There is no guarantee governance will vote to return these. It also allows for removal of airdropped tokens.
302      */
303     function governanceRecoverUnsupported(ITokenInterface _token, uint _amount, address _to) external onlyGovernance {
304         _token.transfer(_to, _amount);
305     }
306 }