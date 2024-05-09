1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
48 
49 /**
50  * @title Pausable
51  * @dev Base contract which allows children to implement an emergency stop mechanism.
52  */
53 contract Pausable is Ownable {
54   event Pause();
55   event Unpause();
56 
57   bool public paused = false;
58 
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is not paused.
62    */
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is paused.
70    */
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     Unpause();
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/math/SafeMath.sol
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
101     uint256 c = a * b;
102     assert(a == 0 || c / a == b);
103     return c;
104   }
105 
106   function div(uint256 a, uint256 b) internal constant returns (uint256) {
107     // assert(b > 0); // Solidity automatically throws when dividing by 0
108     uint256 c = a / b;
109     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110     return c;
111   }
112 
113   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
114     assert(b <= a);
115     return a - b;
116   }
117 
118   function add(uint256 a, uint256 b) internal constant returns (uint256) {
119     uint256 c = a + b;
120     assert(c >= a);
121     return c;
122   }
123 }
124 
125 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
126 
127 /**
128  * @title ERC20Basic
129  * @dev Simpler version of ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/179
131  */
132 contract ERC20Basic {
133   uint256 public totalSupply;
134   function balanceOf(address who) public constant returns (uint256);
135   function transfer(address to, uint256 value) public returns (bool);
136   event Transfer(address indexed from, address indexed to, uint256 value);
137 }
138 
139 // File: zeppelin-solidity/contracts/token/ERC20.sol
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/20
144  */
145 contract ERC20 is ERC20Basic {
146   function allowance(address owner, address spender) public constant returns (uint256);
147   function transferFrom(address from, address to, uint256 value) public returns (bool);
148   function approve(address spender, uint256 value) public returns (bool);
149   event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 // File: zeppelin-solidity/contracts/token/SafeERC20.sol
153 
154 /**
155  * @title SafeERC20
156  * @dev Wrappers around ERC20 operations that throw on failure.
157  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
158  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
159  */
160 library SafeERC20 {
161   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
162     assert(token.transfer(to, value));
163   }
164 
165   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
166     assert(token.transferFrom(from, to, value));
167   }
168 
169   function safeApprove(ERC20 token, address spender, uint256 value) internal {
170     assert(token.approve(spender, value));
171   }
172 }
173 
174 // File: zeppelin-solidity/contracts/ownership/CanReclaimToken.sol
175 
176 /**
177  * @title Contracts that should be able to recover tokens
178  * @author SylTi
179  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
180  * This will prevent any accidental loss of tokens.
181  */
182 contract CanReclaimToken is Ownable {
183   using SafeERC20 for ERC20Basic;
184 
185   /**
186    * @dev Reclaim all ERC20Basic compatible tokens
187    * @param token ERC20Basic The address of the token contract
188    */
189   function reclaimToken(ERC20Basic token) external onlyOwner {
190     uint256 balance = token.balanceOf(this);
191     token.safeTransfer(owner, balance);
192   }
193 
194 }
195 
196 // File: zeppelin-solidity/contracts/ownership/HasNoEther.sol
197 
198 /**
199  * @title Contracts that should not own Ether
200  * @author Remco Bloemen <remco@2π.com>
201  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
202  * in the contract, it will allow the owner to reclaim this ether.
203  * @notice Ether can still be send to this contract by:
204  * calling functions labeled `payable`
205  * `selfdestruct(contract_address)`
206  * mining directly to the contract address
207 */
208 contract HasNoEther is Ownable {
209 
210   /**
211   * @dev Constructor that rejects incoming Ether
212   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
213   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
214   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
215   * we could use assembly to access msg.value.
216   */
217   function HasNoEther() payable {
218     require(msg.value == 0);
219   }
220 
221   /**
222    * @dev Disallows direct send by settings a default function without the `payable` flag.
223    */
224   function() external {
225   }
226 
227   /**
228    * @dev Transfer all Ether held by the contract to the owner.
229    */
230   function reclaimEther() external onlyOwner {
231     assert(owner.send(this.balance));
232   }
233 }
234 
235 // File: contracts/EcoPayments.sol
236 
237 interface Vault {
238     function contributionsOf(address _addr) public constant returns (uint256);
239 }
240 
241 contract EcoPayments is Ownable, Pausable, HasNoEther, CanReclaimToken {
242 
243     using SafeMath for uint256;
244     using SafeERC20 for ERC20;
245 
246     uint256[] private payoutDates = [
247         1512086400, // Dec 1, 2017
248         1514764800, // Jan 1, 2018
249         1517443200, // Feb 1, 2018
250         1519862400, // Mar 1, 2018
251         1522540800, // Apr 1, 2018
252         1525132800, // May 1, 2018
253         1527811200, // Jun 1, 2018
254         1530403200, // Jul 1, 2018
255         1533081600, // Aug 1, 2018
256         1535760000, // Sep 1, 2018
257         1538352000, // Oct 1, 2018
258         1541030400  // Nov 1, 2018
259     ];
260 
261     ERC20 public token;
262     Vault public vault;
263 
264     mapping (address => uint256) private withdrawals;
265 
266     bool public initialized = false;
267 
268     modifier whenInitialized() {
269         require (initialized == true);
270         _;
271     }
272 
273     function EcoPayments(ERC20 _token, Vault _vault) {
274         token = _token;
275         vault = _vault;
276     }
277 
278     function init() onlyOwner returns (uint256) {
279         require(token.balanceOf(this) == 5000000 * 10**18);
280         initialized = true;
281     }
282 
283     function withdraw() whenInitialized whenNotPaused public {
284         uint256 amount = earningsOf(msg.sender);
285         require (amount > 0);
286         withdrawals[msg.sender] = withdrawals[msg.sender].add(amount);
287         token.safeTransfer(msg.sender, amount);
288     }
289 
290     function earningsOf(address _addr) public constant returns (uint256) {
291         uint256 total = 0;
292         uint256 interest = vault.contributionsOf(_addr).mul(833).div(10000);
293 
294         for (uint8 i = 0; i < payoutDates.length; i++) {
295             if (now < payoutDates[i]) {
296                 break;
297             }
298 
299             total = total.add(interest);
300         }
301 
302         // Subtract any previously withdrawn earnings
303         total = total.sub(withdrawals[_addr]);
304 
305         return total;
306     }
307 }