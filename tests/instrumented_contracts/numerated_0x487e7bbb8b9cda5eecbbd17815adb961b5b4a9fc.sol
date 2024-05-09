1 pragma solidity ^0.4.11;
2 /* Inlined from ./contracts/PortMayor.sol */
3 
4 
5 /* Inlined from node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol */
6 
7 
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28 
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 
49 }
50 
51 /* Inlined from node_modules/zeppelin-solidity/contracts/ownership/HasNoEther.sol */
52 
53 
54 
55 
56 /**
57  * @title Contracts that should not own Ether
58  * @author Remco Bloemen <remco@2π.com>
59  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
60  * in the contract, it will allow the owner to reclaim this ether.
61  * @notice Ether can still be send to this contract by:
62  * calling functions labeled `payable`
63  * `selfdestruct(contract_address)`
64  * mining directly to the contract address
65 */
66 contract HasNoEther is Ownable {
67 
68   /**
69   * @dev Constructor that rejects incoming Ether
70   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
71   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
72   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
73   * we could use assembly to access msg.value.
74   */
75   function HasNoEther() public payable {
76     require(msg.value == 0);
77   }
78 
79   /**
80    * @dev Disallows direct send by settings a default function without the `payable` flag.
81    */
82   function() external {
83   }
84 
85   /**
86    * @dev Transfer all Ether held by the contract to the owner.
87    */
88   function reclaimEther() external onlyOwner {
89     assert(owner.send(this.balance));
90   }
91 }
92 
93 /* Inlined from node_modules/zeppelin-solidity/contracts/ownership/CanReclaimToken.sol */
94 
95 
96 
97 /* Inlined from node_modules/zeppelin-solidity/contracts/token/ERC20Basic.sol */
98 
99 
100 
101 /**
102  * @title ERC20Basic
103  * @dev Simpler version of ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/179
105  */
106 contract ERC20Basic {
107   uint256 public totalSupply;
108   function balanceOf(address who) public view returns (uint256);
109   function transfer(address to, uint256 value) public returns (bool);
110   event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 /* Inlined from node_modules/zeppelin-solidity/contracts/token/SafeERC20.sol */
114 
115 
116 
117 /* Inlined from node_modules/zeppelin-solidity/contracts/token/ERC20.sol */
118 
119 
120 
121 
122 
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender) public view returns (uint256);
130   function transferFrom(address from, address to, uint256 value) public returns (bool);
131   function approve(address spender, uint256 value) public returns (bool);
132   event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 
136 /**
137  * @title SafeERC20
138  * @dev Wrappers around ERC20 operations that throw on failure.
139  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
140  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
141  */
142 library SafeERC20 {
143   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
144     assert(token.transfer(to, value));
145   }
146 
147   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
148     assert(token.transferFrom(from, to, value));
149   }
150 
151   function safeApprove(ERC20 token, address spender, uint256 value) internal {
152     assert(token.approve(spender, value));
153   }
154 }
155 
156 
157 /**
158  * @title Contracts that should be able to recover tokens
159  * @author SylTi
160  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
161  * This will prevent any accidental loss of tokens.
162  */
163 contract CanReclaimToken is Ownable {
164   using SafeERC20 for ERC20Basic;
165 
166   /**
167    * @dev Reclaim all ERC20Basic compatible tokens
168    * @param token ERC20Basic The address of the token contract
169    */
170   function reclaimToken(ERC20Basic token) external onlyOwner {
171     uint256 balance = token.balanceOf(this);
172     token.safeTransfer(owner, balance);
173   }
174 
175 }
176 
177 
178 /* Inlined from contracts/PortCoin.sol */
179 
180 
181 
182 
183 contract PortCoin is ERC20 {
184 
185   address mayor;
186 
187   string public name = "Portland Maine Token";
188   string public symbol = "PORT";
189   uint public decimals = 0;
190 
191   mapping(address => uint256) balances;
192   mapping(address => mapping(address => uint256)) approvals;
193 
194   event NewMayor(address indexed oldMayor, address indexed newMayor);
195 
196   function PortCoin() public {
197     mayor = msg.sender;
198   }
199 
200   modifier onlyMayor() {
201     require(msg.sender == mayor);
202     _;
203   }
204 
205   function electNewMayor(address newMayor) onlyMayor public {
206     address oldMayor = mayor;
207     mayor = newMayor;
208     NewMayor(oldMayor, newMayor);
209   }
210 
211   function issue(address to, uint256 amount) onlyMayor public returns (bool){
212     totalSupply += amount;
213     balances[to] += amount;
214     Transfer(0x0, to, amount);
215     return true;
216   }
217 
218   function balanceOf(address who) public constant returns (uint256) {
219     return balances[who];
220   }
221 
222   function transfer(address to, uint256 value) public returns (bool) {
223     require(balances[msg.sender] >= value);
224     balances[to] += value;
225     balances[msg.sender] -= value;
226     Transfer(msg.sender, to, value);
227     return true;
228   }
229 
230   function approve(address spender, uint256 value) public returns (bool) {
231     approvals[msg.sender][spender] = value;
232     Approval(msg.sender, spender, value);
233     return true;
234   }
235 
236   function allowance(address owner, address spender) public constant returns (uint256) {
237     return approvals[owner][spender];
238   }
239 
240   function transferFrom(address from, address to, uint256 value) public returns (bool) {
241     require(approvals[from][msg.sender] >= value);
242     require(balances[from] >= value);
243 
244     balances[to] += value;
245     balances[from] -= value;
246     approvals[from][msg.sender] -= value;
247     Transfer(from, to, value);
248     return true;
249   }
250 }
251 
252 
253 contract PortMayor is Ownable, HasNoEther, CanReclaimToken {
254 
255   PortCoin coin;
256   mapping(address => uint256) tickets;
257 
258   event Attend(address indexed attendee, uint256 ticket, address indexed eventAddress);
259   event EventCreated(address eventAddress);
260 
261   function PortMayor(address portCoinAddress) public {
262     coin = PortCoin(portCoinAddress);
263   }
264 
265   function electNewMayor(address newMayor) onlyOwner public {
266     coin.electNewMayor(newMayor);
267   }
268 
269   function isEvent(address eventAddress) view public returns (bool) {
270     return tickets[eventAddress] > 0;
271   }
272 
273   function isValidTicket(address eventAddress, uint8 ticket) view public returns (bool){
274     return (tickets[eventAddress] & (uint256(2) ** ticket)) > 0;
275   }
276 
277   function createEvent(address eventAddress) onlyOwner public {
278     tickets[eventAddress] = uint256(0) - 1; // fill with 1s
279     EventCreated(eventAddress);
280   }
281 
282   function stringify(uint8 v) public pure returns (string ret) {
283     bytes memory data = new bytes(3);
284     data[0] = bytes1(48 + (v / 100) % 10);
285     data[1] = bytes1(48 + (v / 10) % 10);
286     data[2] = bytes1(48 + v % 10);
287     return string(data);
288   }
289 
290   function attend(uint8 ticket, bytes32 r, bytes32 s, uint8 v) public {
291     address eventAddress = ecrecover(keccak256("\x19Ethereum Signed Message:\n3",stringify(ticket)),v,r,s);
292     require(isValidTicket(eventAddress, ticket));
293     tickets[eventAddress] = tickets[eventAddress] ^ (uint256(2) ** ticket);
294     coin.issue(msg.sender, 1);
295     Attend(msg.sender, ticket, eventAddress);
296   }
297 
298   function issue(address to, uint quantity) public onlyOwner {
299     coin.issue(to, quantity);
300   }
301 }