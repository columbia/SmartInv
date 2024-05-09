1 // Sources flattened with hardhat v2.11.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3
4 
5 // SPDX-License-Identifier: BUSL-1.1
6 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Emitted when `value` tokens are moved from one account (`from`) to
16      * another (`to`).
17      *
18      * Note that `value` may be zero.
19      */
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     /**
23      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
24      * a call to {approve}. `value` is the new allowance.
25      */
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `to`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address to, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `from` to `to` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address from,
83         address to,
84         uint256 amount
85     ) external returns (bool);
86 }
87 
88 
89 // File contracts/Rabbit.sol
90 
91 pragma solidity ^0.8.17;
92 
93 // import "hardhat/console.sol";
94 
95 interface IStarknetCore {
96     /**
97        Sends a message to an L2 contract.
98 
99        Returns the hash of the message.
100     */
101     function sendMessageToL2(uint toAddress, uint selector, uint[] calldata payload)
102         external payable returns (bytes32);
103 
104     /**
105        Consumes a message that was sent from an L2 contract.
106 
107        Returns the hash of the message.
108     */
109     function consumeMessageFromL2(uint fromAddress, uint[] calldata payload)
110         external returns (bytes32);
111 }
112 
113 contract Rabbit {
114 
115     /* Starknet deposit function selector
116        It's obtained from the @l1_handler function name (in this 
117        case 'deposit_handler') using the following Python code:
118 
119        from starkware.starknet.compiler.compile import get_selector_from_name
120        print(get_selector_from_name('deposit_handler'))
121     */
122     uint constant DEPOSIT_SELECTOR = 0x1696B17FB8498D5E407EB2F58D76080BF011D88BB933EFA9A4AC548391251AF;
123     uint constant MESSAGE_WITHDRAW_RECEIVED = 0x1010101010101010;
124     uint constant UNLOCKED = 1;
125     uint constant LOCKED = 2;
126 
127     address public immutable owner;
128     IStarknetCore public immutable starknetCore;
129     uint public rabbitStarknetAddress;
130     IERC20 public paymentToken;
131 
132     // balance of trader's funds available for withdrawal
133     mapping(address => uint) public withdrawableBalance;
134 
135     // total of trader's deposits to date
136     mapping(address => uint) public deposits;
137 
138     // total of trader's withdrawals to date
139     mapping(address => uint) public withdrawals;
140 
141     uint nextDepositId = 1;
142     uint reentryLockStatus = UNLOCKED;
143 
144     struct Receipt {
145         uint fromAddress;
146         address toAddress;
147         uint[] payload;
148     }
149 
150     event Deposit(uint indexed id, address indexed trader, uint amount, bool isResend);
151     event Withdraw(address indexed trader, uint amount);
152     event WithdrawTo(address indexed to, uint amount);
153     event WithdrawalReceipt(address indexed trader, uint amount);
154     event UnknownReceipt(uint indexed messageType, uint[] payload);
155     event MsgNotFound(uint indexed fromAddress, uint[] payload);
156 
157     constructor(address _owner, address _starknetCore, address _paymentToken) {
158         owner = _owner;
159         starknetCore = IStarknetCore(_starknetCore);
160         paymentToken = IERC20(_paymentToken);
161     }
162 
163     modifier onlyOwner() {
164         require(msg.sender == owner, "ONLY_OWNER");
165         _;
166     }
167 
168     modifier nonReentrant() {
169         require(reentryLockStatus == UNLOCKED, "NO_REENTRY");
170         reentryLockStatus = LOCKED;
171         _;
172         reentryLockStatus = UNLOCKED;
173     }
174 
175     function setRabbitStarknetAddress(uint _rabbitStarknetAddress) external onlyOwner {
176         rabbitStarknetAddress = _rabbitStarknetAddress;
177     }
178 
179     function setPaymentToken(address _paymentToken) external onlyOwner {
180         paymentToken = IERC20(_paymentToken);
181     }
182 
183     function allocateDepositId() private returns (uint depositId) {
184         depositId = nextDepositId;
185         nextDepositId++;
186         return depositId;
187     }
188 
189     // re-entrancy shouldn't be possible anyway, but have nonReentrant modifier as well
190     function deposit(uint amount) external nonReentrant {
191         bool success = makeTransferFrom(msg.sender, address(this) , amount);
192         require(success, "TRANSFER_FAILED");
193         deposits[msg.sender] += amount;
194         depositOnStarknet(amount, msg.sender, false);
195     }
196 
197     function resend (uint amount, address trader) external onlyOwner {
198         depositOnStarknet(amount, trader, true);
199     }
200 
201     function depositOnStarknet(uint amount, address trader, bool isResend) private {
202         uint depositId = allocateDepositId();
203         emit Deposit(depositId, trader, amount, isResend);
204         uint traderInt = uint(uint160(trader));
205         uint[] memory payload = new uint[](3);
206         payload[0] = depositId;
207         payload[1] = traderInt;
208         payload[2] = amount;
209         starknetCore.sendMessageToL2(rabbitStarknetAddress, DEPOSIT_SELECTOR, payload);
210     }
211 
212     function withdrawTokensTo(uint amount, address to) onlyOwner external {
213         require(amount > 0, "WRONG_AMOUNT");
214         require(to != address(0), "ZERO_ADDRESS");
215 
216         bool success = makeTransfer(to, amount);
217         require(success, "TRANSFER_FAILED");
218 
219 
220         emit WithdrawTo(to, amount);
221     }
222     
223 
224     // re-entrancy shouldn't be possible anyway, but have nonReentrant modifier as well
225     function withdraw() nonReentrant external {
226         uint amount = withdrawableBalance[msg.sender];
227         require(amount != 0, "INSUFFICIENT_FUNDS");
228         withdrawableBalance[msg.sender] = 0;
229         emit Withdraw(msg.sender, amount); 
230         bool success = makeTransfer(msg.sender, amount);
231         require(success, "TRANSFER_FAILED");
232     }
233 
234     // re-entrancy shouldn't be possible anyway, but have nonReentrant modifier as well
235     function consumeMessages(Receipt[] calldata receipts) nonReentrant external {
236         for (uint i = 0; i < receipts.length; i++) {            
237             Receipt calldata receipt = receipts[i];
238             uint[] calldata payload = receipt.payload;
239             if (receipt.fromAddress == rabbitStarknetAddress) {
240                 // Consume the message from the Starknet core contract. This will
241                 // revert the (Ethereum) transaction if the message does not exist.
242                 try starknetCore.consumeMessageFromL2(rabbitStarknetAddress, payload) {
243                     uint messageType = payload[0];
244                     if (messageType == MESSAGE_WITHDRAW_RECEIVED) {
245                         handleWithdrawalReceipt(payload);
246                     } else {
247                         emit UnknownReceipt(messageType, payload);
248                     }
249                 } catch {
250                     emit MsgNotFound(rabbitStarknetAddress, payload);
251                 }
252             }
253         }
254     }
255 
256     function handleWithdrawalReceipt(uint[] calldata payload) private {
257         uint next = 1;
258         uint len = payload.length;
259         while (next < len - 1) {
260             address trader = address(uint160(payload[next]));
261             uint amount = payload[next + 1];
262             withdrawals[trader] += amount;
263             withdrawableBalance[trader] += amount;
264             emit WithdrawalReceipt(trader, amount);
265             next = next + 2;
266         }
267     }
268 
269     function makeTransfer(address to, uint256 amount) private returns (bool success) {
270         return tokenCall(abi.encodeWithSelector(paymentToken.transfer.selector, to, amount));
271     }
272 
273     function makeTransferFrom(address from, address to, uint256 amount) private returns (bool success) {
274         return tokenCall(abi.encodeWithSelector(paymentToken.transferFrom.selector, from, to, amount));
275     }
276 
277     function tokenCall(bytes memory data) private returns (bool) {
278         (bool success, bytes memory returndata) = address(paymentToken).call(data);
279         if (success && returndata.length > 0) {
280             success = abi.decode(returndata, (bool));
281         }
282         return success;
283     }
284 }