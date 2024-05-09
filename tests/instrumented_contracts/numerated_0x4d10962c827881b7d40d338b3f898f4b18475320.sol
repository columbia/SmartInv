1 /**
2  * Copyright (c) 2018 blockimmo AG license@blockimmo.ch
3  * Non-Profit Open Software License 3.0 (NPOSL-3.0)
4  * https://opensource.org/licenses/NPOSL-3.0
5  */
6  
7 
8 pragma solidity 0.4.25;
9 
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16 
17   /**
18   * @dev Multiplies two numbers, throws on overflow.
19   */
20   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
21     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
22     // benefit is lost if 'b' is also tested.
23     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24     if (_a == 0) {
25       return 0;
26     }
27 
28     c = _a * _b;
29     assert(c / _a == _b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
37     // assert(_b > 0); // Solidity automatically throws when dividing by 0
38     // uint256 c = _a / _b;
39     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
40     return _a / _b;
41   }
42 
43   /**
44   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
47     assert(_b <= _a);
48     return _a - _b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
55     c = _a + _b;
56     assert(c >= _a);
57     return c;
58   }
59 }
60 
61 
62 /**
63  * @title Ownable
64  * @dev The Ownable contract has an owner address, and provides basic authorization control
65  * functions, this simplifies the implementation of "user permissions".
66  */
67 contract Ownable {
68   address public owner;
69 
70 
71   event OwnershipRenounced(address indexed previousOwner);
72   event OwnershipTransferred(
73     address indexed previousOwner,
74     address indexed newOwner
75   );
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   constructor() public {
83     owner = msg.sender;
84   }
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94   /**
95    * @dev Allows the current owner to relinquish control of the contract.
96    * @notice Renouncing to ownership will leave the contract without an owner.
97    * It will not be possible to call the functions with the `onlyOwner`
98    * modifier anymore.
99    */
100   function renounceOwnership() public onlyOwner {
101     emit OwnershipRenounced(owner);
102     owner = address(0);
103   }
104 
105   /**
106    * @dev Allows the current owner to transfer control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function transferOwnership(address _newOwner) public onlyOwner {
110     _transferOwnership(_newOwner);
111   }
112 
113   /**
114    * @dev Transfers control of the contract to a newOwner.
115    * @param _newOwner The address to transfer ownership to.
116    */
117   function _transferOwnership(address _newOwner) internal {
118     require(_newOwner != address(0));
119     emit OwnershipTransferred(owner, _newOwner);
120     owner = _newOwner;
121   }
122 }
123 
124 
125 /**
126  * @title Escrow
127  * @dev Base escrow contract, holds funds destinated to a payee until they
128  * withdraw them. The contract that uses the escrow as its payment method
129  * should be its owner, and provide public methods redirecting to the escrow's
130  * deposit and withdraw.
131  */
132 contract Escrow is Ownable {
133   using SafeMath for uint256;
134 
135   event Deposited(address indexed payee, uint256 weiAmount);
136   event Withdrawn(address indexed payee, uint256 weiAmount);
137 
138   mapping(address => uint256) private deposits;
139 
140   function depositsOf(address _payee) public view returns (uint256) {
141     return deposits[_payee];
142   }
143 
144   /**
145   * @dev Stores the sent amount as credit to be withdrawn.
146   * @param _payee The destination address of the funds.
147   */
148   function deposit(address _payee) public onlyOwner payable {
149     uint256 amount = msg.value;
150     deposits[_payee] = deposits[_payee].add(amount);
151 
152     emit Deposited(_payee, amount);
153   }
154 
155   /**
156   * @dev Withdraw accumulated balance for a payee.
157   * @param _payee The address whose funds will be withdrawn and transferred to.
158   */
159   function withdraw(address _payee) public onlyOwner {
160     uint256 payment = deposits[_payee];
161     assert(address(this).balance >= payment);
162 
163     deposits[_payee] = 0;
164 
165     _payee.transfer(payment);
166 
167     emit Withdrawn(_payee, payment);
168   }
169 }
170 
171 
172 /**
173  * @title ConditionalEscrow
174  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
175  */
176 contract ConditionalEscrow is Escrow {
177   /**
178   * @dev Returns whether an address is allowed to withdraw their funds. To be
179   * implemented by derived contracts.
180   * @param _payee The destination address of the funds.
181   */
182   function withdrawalAllowed(address _payee) public view returns (bool);
183 
184   function withdraw(address _payee) public {
185     require(withdrawalAllowed(_payee));
186     super.withdraw(_payee);
187   }
188 }
189 
190 
191 /**
192  * @title RefundEscrow
193  * @dev Escrow that holds funds for a beneficiary, deposited from multiple parties.
194  * The contract owner may close the deposit period, and allow for either withdrawal
195  * by the beneficiary, or refunds to the depositors.
196  */
197 contract RefundEscrow is Ownable, ConditionalEscrow {
198   enum State { Active, Refunding, Closed }
199 
200   event Closed();
201   event RefundsEnabled();
202 
203   State public state;
204   address public beneficiary;
205 
206   /**
207    * @dev Constructor.
208    * @param _beneficiary The beneficiary of the deposits.
209    */
210   constructor(address _beneficiary) public {
211     require(_beneficiary != address(0));
212     beneficiary = _beneficiary;
213     state = State.Active;
214   }
215 
216   /**
217    * @dev Stores funds that may later be refunded.
218    * @param _refundee The address funds will be sent to if a refund occurs.
219    */
220   function deposit(address _refundee) public payable {
221     require(state == State.Active);
222     super.deposit(_refundee);
223   }
224 
225   /**
226    * @dev Allows for the beneficiary to withdraw their funds, rejecting
227    * further deposits.
228    */
229   function close() public onlyOwner {
230     require(state == State.Active);
231     state = State.Closed;
232     emit Closed();
233   }
234 
235   /**
236    * @dev Allows for refunds to take place, rejecting further deposits.
237    */
238   function enableRefunds() public onlyOwner {
239     require(state == State.Active);
240     state = State.Refunding;
241     emit RefundsEnabled();
242   }
243 
244   /**
245    * @dev Withdraws the beneficiary's funds.
246    */
247   function beneficiaryWithdraw() public {
248     require(state == State.Closed);
249     beneficiary.transfer(address(this).balance);
250   }
251 
252   /**
253    * @dev Returns whether refundees can withdraw their deposits (be refunded).
254    */
255   function withdrawalAllowed(address _payee) public view returns (bool) {
256     return state == State.Refunding;
257   }
258 }