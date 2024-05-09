1 pragma solidity ^0.4.0;
2 
3 library SafeERC20 {
4   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
5     assert(token.transfer(to, value));
6   }
7 
8   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
9     assert(token.transferFrom(from, to, value));
10   }
11 
12   function safeApprove(ERC20 token, address spender, uint256 value) internal {
13     assert(token.approve(spender, value));
14   }
15 }
16 
17 
18 contract Ownable {
19   address public owner;
20 
21 
22   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   function Ownable() {
30     owner = msg.sender;
31   }
32 
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address newOwner) onlyOwner public {
48     require(newOwner != address(0));
49     OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 
56 contract ERC20Basic {
57   uint256 public totalSupply;
58   function balanceOf(address who) public constant returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) public constant returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 
71 
72 contract CanReclaimToken is Ownable {
73   using SafeERC20 for ERC20Basic;
74 
75   /**
76    * @dev Reclaim all ERC20Basic compatible tokens
77    * @param token ERC20Basic The address of the token contract
78    */
79   function reclaimToken(ERC20Basic token) external onlyOwner {
80     uint256 balance = token.balanceOf(this);
81     token.safeTransfer(owner, balance);
82   }
83 
84 }
85 
86 contract HasNoTokens is CanReclaimToken {
87 
88  /**
89   * @dev Reject all ERC23 compatible tokens
90   * @param from_ address The address that is transferring the tokens
91   * @param value_ uint256 the amount of the specified token
92   * @param data_ Bytes The data passed from the caller.
93   */
94   function tokenFallback(address from_, uint256 value_, bytes data_) external {
95     revert();
96   }
97 
98 }
99 
100 contract HasNoEther is Ownable {
101 
102   /**
103   * @dev Constructor that rejects incoming Ether
104   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
105   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
106   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
107   * we could use assembly to access msg.value.
108   */
109   function HasNoEther() payable {
110     require(msg.value == 0);
111   }
112 
113   /**
114    * @dev Disallows direct send by settings a default function without the `payable` flag.
115    */
116   function() external {
117   }
118 
119   /**
120    * @dev Transfer all Ether held by the contract to the owner.
121    */
122   function reclaimEther() external onlyOwner {
123     assert(owner.send(this.balance));
124   }
125 }
126 
127 
128 contract Claimable is Ownable {
129   address public pendingOwner;
130 
131   /**
132    * @dev Modifier throws if called by any account other than the pendingOwner.
133    */
134   modifier onlyPendingOwner() {
135     require(msg.sender == pendingOwner);
136     _;
137   }
138 
139   /**
140    * @dev Allows the current owner to set the pendingOwner address.
141    * @param newOwner The address to transfer ownership to.
142    */
143   function transferOwnership(address newOwner) onlyOwner public {
144     pendingOwner = newOwner;
145   }
146 
147   /**
148    * @dev Allows the pendingOwner address to finalize the transfer.
149    */
150   function claimOwnership() onlyPendingOwner public {
151     OwnershipTransferred(owner, pendingOwner);
152     owner = pendingOwner;
153     pendingOwner = 0x0;
154   }
155 }
156 
157 
158 contract AuthorizedUsers is Claimable, HasNoEther, HasNoTokens {
159   // account => user
160   mapping(address => address) public authorizedUsers;
161 
162   // account => token => user
163   mapping(address => mapping(address => address)) public authorizedTokenUsers;
164 
165   function AuthorizedUsers()
166     public
167   {
168 
169   }
170 
171 
172   event UserAuthorizedForToken(address account, address user, address token);
173  event UserAuthorized(address account, address user);
174 
175   function authorizeForToken(address user, address token)
176     public
177   {
178     authorizedTokenUsers[msg.sender][token] = user;
179     UserAuthorizedForToken(msg.sender, user, token);
180   }
181 
182   /**
183    * Authorizes the given user to claim credit for the callers tokens.  For ETH, use token = 0x0
184    */
185   function authorize(address user)
186     public
187   {
188     authorizedUsers[msg.sender] = user;
189     UserAuthorized(msg.sender, user);
190   }
191 
192 
193   function isAuthorizedForToken(address account, address user, address token)
194     public
195     constant
196     returns (bool)
197   {
198     return authorizedTokenUsers[account][token] == user || authorizedUsers[account] == user;
199   }
200 }