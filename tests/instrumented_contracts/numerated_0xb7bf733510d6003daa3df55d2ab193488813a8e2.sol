1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
31 
32 /**
33  * @title SafeERC20
34  * @dev Wrappers around ERC20 operations that throw on failure.
35  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
36  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
37  */
38 library SafeERC20 {
39   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
40     assert(token.transfer(to, value));
41   }
42 
43   function safeTransferFrom(
44     ERC20 token,
45     address from,
46     address to,
47     uint256 value
48   )
49     internal
50   {
51     assert(token.transferFrom(from, to, value));
52   }
53 
54   function safeApprove(ERC20 token, address spender, uint256 value) internal {
55     assert(token.approve(spender, value));
56   }
57 }
58 
59 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
60 
61 /**
62  * @title Ownable
63  * @dev The Ownable contract has an owner address, and provides basic authorization control
64  * functions, this simplifies the implementation of "user permissions".
65  */
66 contract Ownable {
67   address public owner;
68 
69 
70   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   function Ownable() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address newOwner) public onlyOwner {
94     require(newOwner != address(0));
95     emit OwnershipTransferred(owner, newOwner);
96     owner = newOwner;
97   }
98 
99 }
100 
101 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
102 
103 /**
104  * @title Contracts that should be able to recover tokens
105  * @author SylTi
106  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
107  * This will prevent any accidental loss of tokens.
108  */
109 contract CanReclaimToken is Ownable {
110   using SafeERC20 for ERC20Basic;
111 
112   /**
113    * @dev Reclaim all ERC20Basic compatible tokens
114    * @param token ERC20Basic The address of the token contract
115    */
116   function reclaimToken(ERC20Basic token) external onlyOwner {
117     uint256 balance = token.balanceOf(this);
118     token.safeTransfer(owner, balance);
119   }
120 
121 }
122 
123 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
124 
125 /**
126  * @title Contracts that should not own Ether
127  * @author Remco Bloemen <remco@2π.com>
128  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
129  * in the contract, it will allow the owner to reclaim this ether.
130  * @notice Ether can still be sent to this contract by:
131  * calling functions labeled `payable`
132  * `selfdestruct(contract_address)`
133  * mining directly to the contract address
134  */
135 contract HasNoEther is Ownable {
136 
137   /**
138   * @dev Constructor that rejects incoming Ether
139   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
140   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
141   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
142   * we could use assembly to access msg.value.
143   */
144   function HasNoEther() public payable {
145     require(msg.value == 0);
146   }
147 
148   /**
149    * @dev Disallows direct send by settings a default function without the `payable` flag.
150    */
151   function() external {
152   }
153 
154   /**
155    * @dev Transfer all Ether held by the contract to the owner.
156    */
157   function reclaimEther() external onlyOwner {
158     // solium-disable-next-line security/no-send
159     assert(owner.send(address(this).balance));
160   }
161 }
162 
163 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
164 
165 /**
166  * @title SafeMath
167  * @dev Math operations with safety checks that throw on error
168  */
169 library SafeMath {
170 
171   /**
172   * @dev Multiplies two numbers, throws on overflow.
173   */
174   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
175     if (a == 0) {
176       return 0;
177     }
178     c = a * b;
179     assert(c / a == b);
180     return c;
181   }
182 
183   /**
184   * @dev Integer division of two numbers, truncating the quotient.
185   */
186   function div(uint256 a, uint256 b) internal pure returns (uint256) {
187     // assert(b > 0); // Solidity automatically throws when dividing by 0
188     // uint256 c = a / b;
189     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
190     return a / b;
191   }
192 
193   /**
194   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
195   */
196   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
197     assert(b <= a);
198     return a - b;
199   }
200 
201   /**
202   * @dev Adds two numbers, throws on overflow.
203   */
204   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
205     c = a + b;
206     assert(c >= a);
207     return c;
208   }
209 }
210 
211 // File: contracts/RTELockingVault.sol
212 
213 /**
214  * @title RTELockingVault
215  * @dev For RTE token holders to lock up their tokens for incentives
216  */
217 contract RTELockingVault is HasNoEther, CanReclaimToken {
218   using SafeERC20 for ERC20;
219   using SafeMath for uint256;
220 
221   ERC20 public token;
222 
223   bool public vaultUnlocked;
224 
225   uint256 public cap;
226 
227   uint256 public minimumDeposit;
228 
229   uint256 public tokensDeposited;
230 
231   uint256 public interestRate;
232 
233   uint256 public vaultDepositDeadlineTime;
234 
235   uint256 public vaultUnlockTime;
236 
237   uint256 public vaultLockDays;
238 
239   address public rewardWallet;
240 
241   mapping(address => uint256) public lockedBalances;
242 
243   /**
244    * @dev Locked tokens event
245    * @param _investor Investor address
246    * @param _value Tokens locked
247    */
248   event TokenLocked(address _investor, uint256 _value);
249 
250   /**
251    * @dev Withdrawal event
252    * @param _investor Investor address
253    * @param _value Tokens withdrawn
254    */
255   event TokenWithdrawal(address _investor, uint256 _value);
256 
257   constructor (
258     ERC20 _token,
259     uint256 _cap,
260     uint256 _minimumDeposit,
261     uint256 _interestRate,
262     uint256 _vaultDepositDeadlineTime,
263     uint256 _vaultUnlockTime,
264     uint256 _vaultLockDays,
265     address _rewardWallet
266   )
267     public
268   {
269     require(_vaultDepositDeadlineTime > now);
270     // require(_vaultDepositDeadlineTime < _vaultUnlockTime);
271 
272     vaultUnlocked = false;
273 
274     token = _token;
275     cap = _cap;
276     minimumDeposit = _minimumDeposit;
277     interestRate = _interestRate;
278     vaultDepositDeadlineTime = _vaultDepositDeadlineTime;
279     vaultUnlockTime = _vaultUnlockTime;
280     vaultLockDays = _vaultLockDays;
281     rewardWallet = _rewardWallet;
282   }
283 
284   /**
285    * @dev Deposit and lock tokens
286    * @param _amount Amount of tokens to transfer and lock
287    */
288   function lockToken(uint256 _amount) public {
289     require(_amount >= minimumDeposit);
290     require(now < vaultDepositDeadlineTime);
291     require(tokensDeposited.add(_amount) <= cap);
292 
293     token.safeTransferFrom(msg.sender, address(this), _amount);
294 
295     lockedBalances[msg.sender] = lockedBalances[msg.sender].add(_amount);
296 
297     tokensDeposited = tokensDeposited.add(_amount);
298 
299     emit TokenLocked(msg.sender, _amount);
300   }
301 
302   /**
303    * @dev Withdraw locked tokens
304    */
305   function withdrawToken() public {
306     // require(vaultUnlocked);
307 
308     uint256 interestAmount = (interestRate.mul(lockedBalances[msg.sender]).div(36500)).mul(vaultLockDays);
309 
310     uint256 withdrawAmount = (lockedBalances[msg.sender]).add(interestAmount);
311     require(withdrawAmount > 0);
312 
313     lockedBalances[msg.sender] = 0;
314 
315     token.safeTransfer(msg.sender, withdrawAmount);
316 
317     emit TokenWithdrawal(msg.sender, withdrawAmount);
318   }
319 
320   /**
321    * @dev Force Withdraw locked tokens
322    */
323   function forceWithdrawToken(address _forceAddress) public onlyOwner {
324     require(vaultUnlocked);
325 
326     uint256 interestAmount = (interestRate.mul(lockedBalances[_forceAddress]).div(36500)).mul(vaultLockDays);
327 
328     uint256 withdrawAmount = (lockedBalances[_forceAddress]).add(interestAmount);
329     require(withdrawAmount > 0);
330 
331     lockedBalances[_forceAddress] = 0;
332 
333     token.safeTransfer(_forceAddress, withdrawAmount);
334 
335     emit TokenWithdrawal(_forceAddress, withdrawAmount);
336   }
337 
338   /**
339    * @dev Irreversibly finalizes and unlocks the vault - only owner of contract can call this
340    */
341   function finalizeVault() public onlyOwner {
342     // require(!vaultUnlocked);
343     require(now >= vaultUnlockTime);
344 
345     vaultUnlocked = true;
346 
347     uint256 bonusTokens = ((tokensDeposited.mul(interestRate)).div(36500)).mul(vaultLockDays);
348 
349     token.safeTransferFrom(rewardWallet, address(this), bonusTokens);
350   }
351 }