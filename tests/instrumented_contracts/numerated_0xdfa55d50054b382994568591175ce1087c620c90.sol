1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 }
89 
90 /**
91  * @title Claimable
92  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
93  * This allows the new owner to accept the transfer.
94  */
95 contract Claimable is Ownable {
96   address public pendingOwner;
97 
98   /**
99    * @dev Modifier throws if called by any account other than the pendingOwner.
100    */
101   modifier onlyPendingOwner() {
102     require(msg.sender == pendingOwner);
103     _;
104   }
105 
106   /**
107    * @dev Allows the current owner to set the pendingOwner address.
108    * @param newOwner The address to transfer ownership to.
109    */
110   function transferOwnership(address newOwner) onlyOwner public {
111     pendingOwner = newOwner;
112   }
113 
114   /**
115    * @dev Allows the pendingOwner address to finalize the transfer.
116    */
117   function claimOwnership() onlyPendingOwner public {
118     OwnershipTransferred(owner, pendingOwner);
119     owner = pendingOwner;
120     pendingOwner = address(0);
121   }
122 }
123 
124 /**
125  * @title ERC20Basic
126  * @dev Simpler version of ERC20 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/179
128  */
129 contract ERC20Basic {
130   function totalSupply() public view returns (uint256);
131   function balanceOf(address who) public view returns (uint256);
132   function transfer(address to, uint256 value) public returns (bool);
133   event Transfer(address indexed from, address indexed to, uint256 value);
134 }
135 
136 
137 /**
138  * @title ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/20
140  */
141 contract ERC20 is ERC20Basic {
142   function allowance(address owner, address spender) public view returns (uint256);
143   function transferFrom(address from, address to, uint256 value) public returns (bool);
144   function approve(address spender, uint256 value) public returns (bool);
145   event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 
148 /**
149  * @title SafeERC20
150  * @dev Wrappers around ERC20 operations that throw on failure.
151  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
152  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
153  */
154 library SafeERC20 {
155   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
156     assert(token.transfer(to, value));
157   }
158 
159   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
160     assert(token.transferFrom(from, to, value));
161   }
162 
163   function safeApprove(ERC20 token, address spender, uint256 value) internal {
164     assert(token.approve(spender, value));
165   }
166 }
167 
168 /**
169  * @title TokenTimelock
170  * @dev TokenTimelock is a token holder contract that will allow a
171  * beneficiary to extract the tokens after a given release time
172  */
173 contract TokenTimelock is Claimable {
174   using SafeERC20 for ERC20Basic;
175   using SafeMath for uint256;
176   // ERC20 basic token contract being held
177   ERC20Basic public token;
178   
179   // tokens deposited.
180   uint256 public tokenBalance;
181   // beneficiary of tokens after they are released
182   mapping (address => uint256) public beneficiaryMap;
183   // timestamp when token release is enabled
184   uint256 public releaseTime;
185 
186   function TokenTimelock(ERC20Basic _token, uint256 _releaseTime) public {
187     require(_releaseTime > now);
188     token = _token;
189     releaseTime = _releaseTime;
190   }
191 
192   function isAvailable() public view returns (bool){
193     if(now >= releaseTime){
194       return true;
195     } else { 
196       return false; 
197     }
198   }
199 
200   /**
201      * @param _beneficiary address to lock tokens
202      * @param _amount number of tokens
203      */
204   function depositTokens(address _beneficiary, uint256 _amount)
205       public
206       onlyOwner
207   {
208       // Confirm tokens transfered
209       require(tokenBalance.add(_amount) == token.balanceOf(this));
210       tokenBalance = tokenBalance.add(_amount);
211 
212       // Increment total tokens owed.
213       beneficiaryMap[_beneficiary] = beneficiaryMap[_beneficiary].add(_amount);
214   }
215 
216   /**
217    * @notice Transfers tokens held by timelock to beneficiary.
218    */
219   function release() public {
220     require(now >= releaseTime);
221 
222     // Get tokens owed, then set to 0 before proceeding.
223     uint256 amount = beneficiaryMap[msg.sender];
224     beneficiaryMap[msg.sender] = 0;
225 
226     // Proceed only of there are tokens to send.
227     require(amount > 0 && token.balanceOf(this) > 0);
228 
229     token.safeTransfer(msg.sender, amount);
230   }
231 }