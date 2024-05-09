1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
26 
27 pragma solidity ^0.5.2;
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35      * @dev Multiplies two unsigned integers, reverts on overflow.
36      */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53      */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Adds two unsigned integers, reverts on overflow.
75      */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85      * reverts when dividing by zero.
86      */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: contracts/livepeerInterface/IController.sol
94 
95 pragma solidity ^0.5.7;
96 
97 contract IController  {
98     event SetContractInfo(bytes32 id, address contractAddress, bytes20 gitCommitHash);
99 
100     function setContractInfo(bytes32 _id, address _contractAddress, bytes20 _gitCommitHash) external;
101     function updateController(bytes32 _id, address _controller) external;
102     function getContract(bytes32 _id) public view returns (address);
103 }
104 
105 // File: contracts/livepeerInterface/IBondingManager.sol
106 
107 pragma solidity ^0.5.1;
108 
109 contract IBondingManager {
110 
111     function unbondingPeriod() public view returns (uint64);
112 
113 }
114 
115 // File: contracts/livepeerInterface/IRoundsManager.sol
116 
117 pragma solidity ^0.5.1;
118 
119 contract IRoundsManager {
120 
121     function roundLength() public view returns (uint256);
122 
123 }
124 
125 // File: contracts/LptOrderBook.sol
126 
127 pragma solidity ^0.5.7;
128 
129 
130 
131 
132 
133 
134 contract LptOrderBook {
135 
136     using SafeMath for uint256;
137 
138     address private constant ZERO_ADDRESS = address(0);
139 
140     string internal constant ERROR_SELL_ORDER_COMMITTED_TO = "LPT_ORDER_SELL_ORDER_COMMITTED_TO";
141     string internal constant ERROR_SELL_ORDER_NOT_COMMITTED_TO = "LPT_ORDER_SELL_ORDER_NOT_COMMITTED_TO";
142     string internal constant ERROR_INITIALISED_ORDER = "LPT_ORDER_INITIALISED_ORDER";
143     string internal constant ERROR_UNINITIALISED_ORDER = "LPT_ORDER_UNINITIALISED_ORDER";
144     string internal constant ERROR_COMMITMENT_WITHIN_UNBONDING_PERIOD = "LPT_ORDER_COMMITMENT_WITHIN_UNBONDING_PERIOD";
145     string internal constant ERROR_NOT_BUYER = "LPT_ORDER_NOT_BUYER";
146     string internal constant ERROR_STILL_WITHIN_LOCK_PERIOD = "LPT_ORDER_STILL_WITHIN_LOCK_PERIOD";
147 
148     struct LptSellOrder {
149         uint256 lptSellValue;
150         uint256 daiPaymentValue;
151         uint256 daiCollateralValue;
152         uint256 deliveredByBlock;
153         address buyerAddress;
154     }
155 
156     IController livepeerController;
157     IERC20 daiToken;
158     mapping(address => LptSellOrder) public lptSellOrders; // One sell order per address for simplicity
159 
160     constructor(address _livepeerController, address _daiToken) public {
161         livepeerController = IController(_livepeerController);
162         daiToken = IERC20(_daiToken);
163     }
164 
165     /*
166     * @notice Create an LPT sell order, requires approval for this contract to spend _daiCollateralValue amount of DAI.
167     * @param _lptSellValue Value of LPT to sell
168     * @param _daiPaymentValue Value required in exchange for LPT
169     * @param _daiCollateralValue Value of collateral
170     * @param _deliveredByBlock Order filled or cancelled by this block or the collateral can be claimed
171     */
172     function createLptSellOrder(uint256 _lptSellValue, uint256 _daiPaymentValue, uint256 _daiCollateralValue, uint256 _deliveredByBlock) public {
173         LptSellOrder storage lptSellOrder = lptSellOrders[msg.sender];
174 
175         require(lptSellOrder.daiCollateralValue == 0, ERROR_INITIALISED_ORDER);
176 
177         daiToken.transferFrom(msg.sender, address(this), _daiCollateralValue);
178 
179         lptSellOrders[msg.sender] = LptSellOrder(_lptSellValue, _daiPaymentValue, _daiCollateralValue, _deliveredByBlock, ZERO_ADDRESS);
180     }
181 
182     /*
183     * @notice Cancel an LPT sell order, must be executed by the sell order creator.
184     */
185     function cancelLptSellOrder() public {
186         LptSellOrder storage lptSellOrder = lptSellOrders[msg.sender];
187 
188         require(lptSellOrder.buyerAddress == ZERO_ADDRESS, ERROR_SELL_ORDER_COMMITTED_TO);
189 
190         daiToken.transfer(msg.sender, lptSellOrder.daiCollateralValue);
191         delete lptSellOrders[msg.sender];
192     }
193 
194     /*
195     * @notice Commit to buy LPT, requires approval for this contract to spend the payment amount in DAI.
196     * @param _sellOrderCreator Address of sell order creator
197     */
198     function commitToBuyLpt(address _sellOrderCreator) public {
199         LptSellOrder storage lptSellOrder = lptSellOrders[_sellOrderCreator];
200 
201         require(lptSellOrder.lptSellValue > 0, ERROR_UNINITIALISED_ORDER);
202         require(lptSellOrder.buyerAddress == ZERO_ADDRESS, ERROR_SELL_ORDER_COMMITTED_TO);
203         require(lptSellOrder.deliveredByBlock.sub(_getUnbondingPeriodLength()) > block.number, ERROR_COMMITMENT_WITHIN_UNBONDING_PERIOD);
204 
205         daiToken.transferFrom(msg.sender, address(this), lptSellOrder.daiPaymentValue);
206 
207         lptSellOrder.buyerAddress = msg.sender;
208     }
209 
210     /*
211     * @notice Claim collateral and payment after a sell order has been committed to but it hasn't been delivered by
212     *         the block number specified.
213     * @param _sellOrderCreator Address of sell order creator
214     */
215     function claimCollateralAndPayment(address _sellOrderCreator) public {
216         LptSellOrder storage lptSellOrder = lptSellOrders[_sellOrderCreator];
217 
218         require(lptSellOrder.buyerAddress == msg.sender, ERROR_NOT_BUYER);
219         require(lptSellOrder.deliveredByBlock < block.number, ERROR_STILL_WITHIN_LOCK_PERIOD);
220 
221         uint256 totalValue = lptSellOrder.daiPaymentValue.add(lptSellOrder.daiCollateralValue);
222         daiToken.transfer(msg.sender, totalValue);
223     }
224 
225     /*
226     * @notice Fulfill sell order, requires approval for this contract spend the orders LPT value from the seller.
227     *         Returns the collateral and payment to the LPT seller.
228     */
229     function fulfillSellOrder() public {
230         LptSellOrder storage lptSellOrder = lptSellOrders[msg.sender];
231 
232         require(lptSellOrder.buyerAddress != ZERO_ADDRESS, ERROR_SELL_ORDER_NOT_COMMITTED_TO);
233 
234         IERC20 livepeerToken = IERC20(_getLivepeerContractAddress("LivepeerToken"));livepeerToken.transferFrom(msg.sender, lptSellOrder.buyerAddress, lptSellOrder.lptSellValue);
235 
236         uint256 totalValue = lptSellOrder.daiPaymentValue.add(lptSellOrder.daiCollateralValue);
237         daiToken.transfer(msg.sender, totalValue);
238 
239         delete lptSellOrders[msg.sender];
240     }
241 
242     function _getLivepeerContractAddress(string memory _livepeerContract) internal view returns (address) {
243         bytes32 contractId = keccak256(abi.encodePacked(_livepeerContract));
244         return livepeerController.getContract(contractId);
245     }
246 
247     function _getUnbondingPeriodLength() internal view returns (uint256) {
248         IBondingManager bondingManager = IBondingManager(_getLivepeerContractAddress("BondingManager"));
249         uint64 unbondingPeriodRounds = bondingManager.unbondingPeriod();
250 
251         IRoundsManager roundsManager = IRoundsManager(_getLivepeerContractAddress("RoundsManager"));
252         uint256 roundLength = roundsManager.roundLength();
253 
254         return roundLength.mul(unbondingPeriodRounds);
255     }
256 }