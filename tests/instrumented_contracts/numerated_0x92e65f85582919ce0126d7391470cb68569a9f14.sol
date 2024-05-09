1 pragma solidity ^0.4.13;
2 
3 library Roles {
4   struct Role {
5     mapping (address => bool) bearer;
6   }
7 
8   /**
9    * @dev give an account access to this role
10    */
11   function add(Role storage role, address account) internal {
12     require(account != address(0));
13     require(!has(role, account));
14 
15     role.bearer[account] = true;
16   }
17 
18   /**
19    * @dev remove an account's access to this role
20    */
21   function remove(Role storage role, address account) internal {
22     require(account != address(0));
23     require(has(role, account));
24 
25     role.bearer[account] = false;
26   }
27 
28   /**
29    * @dev check if an account has this role
30    * @return bool
31    */
32   function has(Role storage role, address account)
33     internal
34     view
35     returns (bool)
36   {
37     require(account != address(0));
38     return role.bearer[account];
39   }
40 }
41 
42 contract PauserRole {
43   using Roles for Roles.Role;
44 
45   event PauserAdded(address indexed account);
46   event PauserRemoved(address indexed account);
47 
48   Roles.Role private pausers;
49 
50   constructor() internal {
51     _addPauser(msg.sender);
52   }
53 
54   modifier onlyPauser() {
55     require(isPauser(msg.sender));
56     _;
57   }
58 
59   function isPauser(address account) public view returns (bool) {
60     return pausers.has(account);
61   }
62 
63   function addPauser(address account) public onlyPauser {
64     _addPauser(account);
65   }
66 
67   function renouncePauser() public {
68     _removePauser(msg.sender);
69   }
70 
71   function _addPauser(address account) internal {
72     pausers.add(account);
73     emit PauserAdded(account);
74   }
75 
76   function _removePauser(address account) internal {
77     pausers.remove(account);
78     emit PauserRemoved(account);
79   }
80 }
81 
82 contract Pausable is PauserRole {
83   event Paused(address account);
84   event Unpaused(address account);
85 
86   bool private _paused;
87 
88   constructor() internal {
89     _paused = false;
90   }
91 
92   /**
93    * @return true if the contract is paused, false otherwise.
94    */
95   function paused() public view returns(bool) {
96     return _paused;
97   }
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is not paused.
101    */
102   modifier whenNotPaused() {
103     require(!_paused);
104     _;
105   }
106 
107   /**
108    * @dev Modifier to make a function callable only when the contract is paused.
109    */
110   modifier whenPaused() {
111     require(_paused);
112     _;
113   }
114 
115   /**
116    * @dev called by the owner to pause, triggers stopped state
117    */
118   function pause() public onlyPauser whenNotPaused {
119     _paused = true;
120     emit Paused(msg.sender);
121   }
122 
123   /**
124    * @dev called by the owner to unpause, returns to normal state
125    */
126   function unpause() public onlyPauser whenPaused {
127     _paused = false;
128     emit Unpaused(msg.sender);
129   }
130 }
131 
132 contract Ownable {
133   address private _owner;
134 
135   event OwnershipTransferred(
136     address indexed previousOwner,
137     address indexed newOwner
138   );
139 
140   /**
141    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
142    * account.
143    */
144   constructor() internal {
145     _owner = msg.sender;
146     emit OwnershipTransferred(address(0), _owner);
147   }
148 
149   /**
150    * @return the address of the owner.
151    */
152   function owner() public view returns(address) {
153     return _owner;
154   }
155 
156   /**
157    * @dev Throws if called by any account other than the owner.
158    */
159   modifier onlyOwner() {
160     require(isOwner());
161     _;
162   }
163 
164   /**
165    * @return true if `msg.sender` is the owner of the contract.
166    */
167   function isOwner() public view returns(bool) {
168     return msg.sender == _owner;
169   }
170 
171   /**
172    * @dev Allows the current owner to relinquish control of the contract.
173    * @notice Renouncing to ownership will leave the contract without an owner.
174    * It will not be possible to call the functions with the `onlyOwner`
175    * modifier anymore.
176    */
177   function renounceOwnership() public onlyOwner {
178     emit OwnershipTransferred(_owner, address(0));
179     _owner = address(0);
180   }
181 
182   /**
183    * @dev Allows the current owner to transfer control of the contract to a newOwner.
184    * @param newOwner The address to transfer ownership to.
185    */
186   function transferOwnership(address newOwner) public onlyOwner {
187     _transferOwnership(newOwner);
188   }
189 
190   /**
191    * @dev Transfers control of the contract to a newOwner.
192    * @param newOwner The address to transfer ownership to.
193    */
194   function _transferOwnership(address newOwner) internal {
195     require(newOwner != address(0));
196     emit OwnershipTransferred(_owner, newOwner);
197     _owner = newOwner;
198   }
199 }
200 
201 interface IERC20 {
202   function totalSupply() external view returns (uint256);
203 
204   function balanceOf(address who) external view returns (uint256);
205 
206   function allowance(address owner, address spender)
207     external view returns (uint256);
208 
209   function transfer(address to, uint256 value) external returns (bool);
210 
211   function approve(address spender, uint256 value)
212     external returns (bool);
213 
214   function transferFrom(address from, address to, uint256 value)
215     external returns (bool);
216 
217   event Transfer(
218     address indexed from,
219     address indexed to,
220     uint256 value
221   );
222 
223   event Approval(
224     address indexed owner,
225     address indexed spender,
226     uint256 value
227   );
228 }
229 
230 contract CSTWallet is Ownable, Pausable {
231 
232     // Account balances
233     mapping (address => uint) public balances; 
234   
235     // ERC20 Token Contract address
236     address public tokenAddress;
237 
238     // Emergency withdraw address, only for recovering ETH/ERC20 that is stuck in the smart contract, due an incorrect behaviour.
239     address public emergencyWithdrawAddress;
240   
241     // ERC20 Token Instance
242     IERC20 tokenInstance;
243 
244     event Deposit(address from, uint amount, uint blockNumber);
245     event Withdrawal(address to, uint amount, uint blockNumber);
246     
247     event EmergencyWithdrawERC20(address to, uint balance, address tokenTarget);
248     event EmergencyWithdrawETH(address to, uint balance);
249     event EmergencyAddressChanged(address account);
250 
251     constructor(address targetToken) public {
252         setToken(targetToken);
253         setEmergencyWithdrawAddress(msg.sender);
254     }
255 
256     function depositERC20(address account, uint256 amount) public whenNotPaused{
257         require(tokenAddress != address(0), "ERC20 token contract is not set. Please contact with the smart contract owner.");
258         require(account != address(0), "The 0x address is not allowed to deposit tokens in this contract.");
259         require(tokenInstance.allowance(account, address(this)) >= amount, "Owner did not allow this smart contract to transfer.");
260         require(amount > 0, "Amount can not be zero");
261         tokenInstance.transferFrom(account, address(this), amount);
262         balances[account] += amount;
263         emit Deposit(account, amount, block.number);
264     }
265 
266     function withdrawERC20(uint amount) public whenNotPaused {
267         require(tokenAddress != address(0), "ERC20 token contract is not set. Please contact with the smart contract owner.");
268         require(msg.sender != address(0), "The 0x address is not allowed to withdraw tokens in this contract.");
269         require(amount > 0, "Amount can not be zero");
270         uint256 currentBalance = balances[msg.sender];
271         require(amount <= currentBalance,  "Amount is greater than current balance.");
272         balances[msg.sender] -= amount;
273         require(tokenInstance.transfer(msg.sender, amount), "Error while making ERC20 transfer");
274         emit Withdrawal(msg.sender, amount, block.number);
275     }
276 
277     function emergencyWithdrawERC20(address tokenTarget, uint amount) public onlyOwner whenPaused {
278         require(tokenTarget != address(0), "Token address can not be the zero address");
279         require(emergencyWithdrawAddress != address(0), "The emergency withdraw address can not be the zero address");
280         uint currentBalance = IERC20(tokenTarget).balanceOf(address(this));
281         require(amount <= currentBalance, "Withdrawal amount is bigger than balance");
282         IERC20(tokenTarget).transfer(emergencyWithdrawAddress, amount);
283         emit EmergencyWithdrawERC20(emergencyWithdrawAddress, amount, tokenTarget);
284     }
285 
286     function emergencyWithdrawETH(uint amount) public onlyOwner whenPaused {
287         require(emergencyWithdrawAddress != address(0), "The emergency withdraw address can not be the zero address");
288         uint currentBalance = address(this).balance;
289         require(amount <= currentBalance, "Withdrawal amount is bigger than balance");
290         emergencyWithdrawAddress.transfer(amount);
291         emit EmergencyWithdrawETH(emergencyWithdrawAddress, amount);
292     }
293 
294     function setEmergencyWithdrawAddress(address withdrawAddress) public onlyOwner {
295         require(withdrawAddress != address(0), "The emergency withdraw address can not be the zero address");
296         emergencyWithdrawAddress = withdrawAddress;
297         emit EmergencyAddressChanged(emergencyWithdrawAddress);
298     }
299 
300     function setToken(address contractAddress) public onlyOwner {
301         tokenAddress = contractAddress;
302         tokenInstance = IERC20(tokenAddress);
303     }
304 
305     function () external {
306         require(false, "Fallback function is disabled");
307     }
308 }