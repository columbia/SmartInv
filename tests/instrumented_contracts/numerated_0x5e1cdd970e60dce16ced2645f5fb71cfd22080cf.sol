1 contract Ownable {
2   address public owner;
3 
4 
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7 
8   /**
9    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10    * account.
11    */
12   function Ownable() {
13     owner = msg.sender;
14   }
15 
16 
17   /**
18    * @dev Throws if called by any account other than the owner.
19    */
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24 
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) onlyOwner public {
31     require(newOwner != address(0));
32     OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract ERC20 is ERC20Basic {
46   function allowance(address owner, address spender) public constant returns (uint256);
47   function transferFrom(address from, address to, uint256 value) public returns (bool);
48   function approve(address spender, uint256 value) public returns (bool);
49   event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 contract HasNoEther is Ownable {
53 
54   /**
55   * @dev Constructor that rejects incoming Ether
56   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
57   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
58   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
59   * we could use assembly to access msg.value.
60   */
61   function HasNoEther() payable {
62     require(msg.value == 0);
63   }
64 
65   /**
66    * @dev Disallows direct send by settings a default function without the `payable` flag.
67    */
68   function() external {
69   }
70 
71   /**
72    * @dev Transfer all Ether held by the contract to the owner.
73    */
74   function reclaimEther() external onlyOwner {
75     assert(owner.send(this.balance));
76   }
77 }
78 
79 
80 library SafeERC20 {
81   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
82     assert(token.transfer(to, value));
83   }
84 
85   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
86     assert(token.transferFrom(from, to, value));
87   }
88 
89   function safeApprove(ERC20 token, address spender, uint256 value) internal {
90     assert(token.approve(spender, value));
91   }
92 }
93 
94 /**
95  * @title Contracts that should be able to recover tokens
96  * @author SylTi
97  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
98  * This will prevent any accidental loss of tokens.
99  */
100 contract CanReclaimToken is Ownable {
101   using SafeERC20 for ERC20Basic;
102 
103   /**
104    * @dev Reclaim all ERC20Basic compatible tokens
105    * @param token ERC20Basic The address of the token contract
106    */
107   function reclaimToken(ERC20Basic token) external onlyOwner {
108     uint256 balance = token.balanceOf(this);
109     token.safeTransfer(owner, balance);
110   }
111 
112 }
113 
114 /**
115  * @title Contracts that should not own Tokens
116  * @author Remco Bloemen <remco@2π.com>
117  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
118  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
119  * owner to reclaim the tokens.
120  */
121 contract HasNoTokens is CanReclaimToken {
122 
123  /**
124   * @dev Reject all ERC23 compatible tokens
125   * @param from_ address The address that is transferring the tokens
126   * @param value_ uint256 the amount of the specified token
127   * @param data_ Bytes The data passed from the caller.
128   */
129   function tokenFallback(address from_, uint256 value_, bytes data_) external {
130     revert();
131   }
132 
133 }
134 
135 
136 
137 contract ReentrancyGuard {
138 
139   /**
140    * @dev We use a single lock for the whole contract.
141    */
142   bool private rentrancy_lock = false;
143 
144   /**
145    * @dev Prevents a contract from calling itself, directly or indirectly.
146    * @notice If you mark a function `nonReentrant`, you should also
147    * mark it `external`. Calling one nonReentrant function from
148    * another is not supported. Instead, you can implement a
149    * `private` function doing the actual work, and a `external`
150    * wrapper marked as `nonReentrant`.
151    */
152   modifier nonReentrant() {
153     require(!rentrancy_lock);
154     rentrancy_lock = true;
155     _;
156     rentrancy_lock = false;
157   }
158 
159 }
160 contract Claimable is Ownable {
161   address public pendingOwner;
162 
163   /**
164    * @dev Modifier throws if called by any account other than the pendingOwner.
165    */
166   modifier onlyPendingOwner() {
167     require(msg.sender == pendingOwner);
168     _;
169   }
170 
171   /**
172    * @dev Allows the current owner to set the pendingOwner address.
173    * @param newOwner The address to transfer ownership to.
174    */
175   function transferOwnership(address newOwner) onlyOwner public {
176     pendingOwner = newOwner;
177   }
178 
179   /**
180    * @dev Allows the pendingOwner address to finalize the transfer.
181    */
182   function claimOwnership() onlyPendingOwner public {
183     OwnershipTransferred(owner, pendingOwner);
184     owner = pendingOwner;
185     pendingOwner = 0x0;
186   }
187 }
188 
189 
190 /**
191  * @title Pausable
192  * @dev Base contract which allows children to implement an emergency stop mechanism.
193  */
194 contract Pausable is Ownable {
195   event Pause();
196   event Unpause();
197 
198   bool public paused = false;
199 
200 
201   /**
202    * @dev Modifier to make a function callable only when the contract is not paused.
203    */
204   modifier whenNotPaused() {
205     require(!paused);
206     _;
207   }
208 
209   /**
210    * @dev Modifier to make a function callable only when the contract is paused.
211    */
212   modifier whenPaused() {
213     require(paused);
214     _;
215   }
216 
217   /**
218    * @dev called by the owner to pause, triggers stopped state
219    */
220   function pause() onlyOwner whenNotPaused public {
221     paused = true;
222     Pause();
223   }
224 
225   /**
226    * @dev called by the owner to unpause, returns to normal state
227    */
228   function unpause() onlyOwner whenPaused public {
229     paused = false;
230     Unpause();
231   }
232 }
233 contract StandardContract {
234     // allows usage of "require" as a modifier
235     modifier requires(bool b) {
236         require(b);
237         _;
238     }
239 
240     // require at least one of the two conditions to be true
241     modifier requiresOne(bool b1, bool b2) {
242         require(b1 || b2);
243         _;
244     }
245 
246     modifier notNull(address a) {
247         require(a != 0);
248         _;
249     }
250 
251     modifier notZero(uint256 a) {
252         require(a != 0);
253         _;
254     }
255 }
256 
257 contract TokenPaymentGateway is Claimable, HasNoEther, HasNoTokens, ReentrancyGuard, Pausable, StandardContract {
258   
259   ERC20 public token;
260   address public tokenCollector;
261 
262   event LogPayment(address from, uint256 amount, bytes extraData);
263   event LogSettingsUpdate(address tokenAddress, address tokenCollector);
264   
265   function TokenPaymentGateway() {}
266 
267   function receiveApproval(address _from, uint256 _amount, address _ignoreToken, bytes _extraData)
268     requires(msg.sender == address(token))
269     requires(_extraData.length > 0)
270     whenNotPaused
271     nonReentrant
272     external
273   {
274     require(token.transferFrom(_from, tokenCollector, _amount));
275     emit LogPayment(_from, _amount, _extraData);
276   }
277 
278   function adminUpdateSettings(address _tokenAddress, address _tokenCollector)
279     onlyOwner
280     external
281   {
282     token = ERC20(_tokenAddress);
283     tokenCollector = _tokenCollector;
284     emit LogSettingsUpdate(_tokenAddress, _tokenCollector);
285   }
286 }