1 pragma solidity ^0.4.23;
2 
3 // File: contracts/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: contracts/SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
79     if (a == 0) {
80       return 0;
81     }
82     c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, truncating the quotient.
89   */
90   function div(uint256 a, uint256 b) internal pure returns (uint256) {
91     // assert(b > 0); // Solidity automatically throws when dividing by 0
92     // uint256 c = a / b;
93     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94     return a / b;
95   }
96 
97   /**
98   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101     assert(b <= a);
102     return a - b;
103   }
104 
105   /**
106   * @dev Adds two numbers, throws on overflow.
107   */
108   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
109     c = a + b;
110     assert(c >= a);
111     return c;
112   }
113 }
114 
115 // File: contracts/ArbitrageETHStaking.sol
116 
117 /**
118 * @title ArbitrageETHStaking
119 * @dev The ArbitrageETHStaking contract staking Ether(ETH) tokens.
120 *      Here is stored all function and data of user stakes in contract.
121 *      Staking is configured for 2%.
122 */
123 contract ArbitrageETHStaking is Ownable {
124 
125     using SafeMath for uint256;
126 
127     /*==============================
128      =            EVENTS            =
129      ==============================*/
130 
131     event onPurchase(
132        address indexed customerAddress,
133        uint256 etherIn,
134        uint256 contractBal,
135        uint256 poolFee,
136        uint timestamp
137     );
138 
139     event onWithdraw(
140          address indexed customerAddress,
141          uint256 etherOut,
142          uint256 contractBal,
143          uint timestamp
144     );
145 
146 
147     /*** STORAGE ***/
148 
149     mapping(address => uint256) internal personalFactorLedger_; // personal factor ledger
150     mapping(address => uint256) internal balanceLedger_; // users balance ledger
151 
152     // Configurations
153     uint256 minBuyIn = 0.001 ether; // can't buy less then 0.0001 ETH
154     uint256 stakingPrecent = 2;
155     uint256 internal globalFactor = 10e21; // global factor
156     uint256 constant internal constantFactor = 10e21 * 10e21; // constant factor
157 
158     /// @dev Forward all Ether in buy() function
159     function() external payable {
160         buy();
161     }
162 
163     // @dev Buy in staking pool, transfer ethereum in the contract, pay 2% fee
164     function buy()
165         public
166         payable
167     {
168         address _customerAddress = msg.sender;
169 
170         require(msg.value >= minBuyIn, "should be more the 0.0001 ether sent");
171 
172         uint256 _etherBeforeBuyIn = getBalance().sub(msg.value);
173 
174         uint256 poolFee;
175         // Check is not a first buy in
176         if (_etherBeforeBuyIn != 0) {
177 
178             // Add 2% fee of the buy to the staking pool
179             poolFee = msg.value.mul(stakingPrecent).div(100);
180 
181             // Increase amount of eth everyone else owns
182             uint256 globalIncrease = globalFactor.mul(poolFee) / _etherBeforeBuyIn;
183             globalFactor = globalFactor.add(globalIncrease);
184         }
185 
186 
187         balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).add(msg.value).sub(poolFee);
188         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
189 
190         emit onPurchase(_customerAddress, msg.value, getBalance(), poolFee, now);
191     }
192 
193     /**
194      * @dev Withdraw selected amount of ethereum from the contract back to user,
195      *      update the balance.
196      * @param _sellEth - Amount of ethereum to withdraw from contract
197      */
198     function withdraw(uint256 _sellEth)
199         public
200     {
201         address _customerAddress = msg.sender;
202         // User must have enough eth and cannot sell 0
203         require(_sellEth > 0, "user cant spam transactions with 0 value");
204         require(_sellEth <= ethBalanceOf(_customerAddress), "user cant withdraw more then he holds ");
205 
206 
207         // Transfer balance and update user ledgers
208         _customerAddress.transfer(_sellEth);
209         balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).sub(_sellEth);
210         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
211 
212         emit onWithdraw(_customerAddress, _sellEth, getBalance(), now);
213     }
214 
215     // @dev Withdraw all the ethereum user holds in the contract, set balance to 0
216     function withdrawAll()
217         public
218     {
219         address _customerAddress = msg.sender;
220         // Set the sell amount to the user's full balance, don't sell if empty
221         uint256 _sellEth = ethBalanceOf(_customerAddress);
222         require(_sellEth > 0, "user cant call withdraw, when holds nothing");
223         // Transfer balance and update user ledgers
224         _customerAddress.transfer(_sellEth);
225         balanceLedger_[_customerAddress] = 0;
226         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
227 
228         emit onWithdraw(_customerAddress, _sellEth, getBalance(), now);
229     }
230 
231     /**
232     * UI Logic - View Functions
233     */
234 
235     // @dev Returns contract ETH balance
236     function getBalance()
237         public
238         view
239         returns (uint256)
240     {
241         return address(this).balance;
242     }
243 
244     // @dev Returns user ETH tokens balance in contract
245     function ethBalanceOf(address _customerAddress)
246         public
247         view
248         returns (uint256)
249     {
250         // Balance ledger * personal factor * globalFactor / constantFactor
251         return balanceLedger_[_customerAddress].mul(personalFactorLedger_[_customerAddress]).mul(globalFactor) / constantFactor;
252     }
253 }