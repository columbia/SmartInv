1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) public constant returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37   function allowance(address owner, address spender) public constant returns (uint256);
38   function transferFrom(address from, address to, uint256 value) public returns (bool);
39   function approve(address spender, uint256 value) public returns (bool);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) onlyOwner public {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract HasNoEther is Ownable {
81 
82   /**
83   * @dev Constructor that rejects incoming Ether
84   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
85   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
86   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
87   * we could use assembly to access msg.value.
88   */
89   function HasNoEther() public payable {
90     require(msg.value == 0);
91   }
92 
93   /**
94    * @dev Disallows direct send by settings a default function without the `payable` flag.
95    */
96   function() external {
97   }
98 
99   /**
100    * @dev Transfer all Ether held by the contract to the owner.
101    */
102   function reclaimEther() external onlyOwner {
103     assert(owner.send(this.balance));
104   }
105 }
106 
107 contract Pausable is Ownable {
108   event Pause();
109   event Unpause();
110 
111   bool public paused = false;
112 
113 
114   /**
115    * @dev Modifier to make a function callable only when the contract is not paused.
116    */
117   modifier whenNotPaused() {
118     require(!paused);
119     _;
120   }
121 
122   /**
123    * @dev Modifier to make a function callable only when the contract is paused.
124    */
125   modifier whenPaused() {
126     require(paused);
127     _;
128   }
129 
130   /**
131    * @dev called by the owner to pause, triggers stopped state
132    */
133   function pause() onlyOwner whenNotPaused public {
134     paused = true;
135     Pause();
136   }
137 
138   /**
139    * @dev called by the owner to unpause, returns to normal state
140    */
141   function unpause() onlyOwner whenPaused public {
142     paused = false;
143     Unpause();
144   }
145 }
146 
147 library SafeERC20 {
148   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
149     assert(token.transfer(to, value));
150   }
151 
152   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
153     assert(token.transferFrom(from, to, value));
154   }
155 
156   function safeApprove(ERC20 token, address spender, uint256 value) internal {
157     assert(token.approve(spender, value));
158   }
159 }
160 
161 contract CanReclaimToken is Ownable {
162   using SafeERC20 for ERC20Basic;
163 
164   /**
165    * @dev Reclaim all ERC20Basic compatible tokens
166    * @param token ERC20Basic The address of the token contract
167    */
168   function reclaimToken(ERC20Basic token) external onlyOwner {
169     uint256 balance = token.balanceOf(this);
170     token.safeTransfer(owner, balance);
171   }
172 
173 }
174 
175 contract EcoVault is Ownable, Pausable, HasNoEther, CanReclaimToken
176 {
177 
178     using SafeMath for uint256;
179     using SafeERC20 for ERC20;
180 
181     uint256 public constant MAX_CONTRIBUTION = 100000 * 10**18; // Max amount of WILD per address
182     uint256 public constant MAX_TOTAL_CONTRIBUTIONS = 5000000 * 10**18; // Max amount for all WILD contributed
183     uint256 public constant CONTRIBUTION_START = 1508544000; // 21 Oct, 2018 00:00:00 UTC
184     uint256 public constant CONTRIBUTION_END = 1509494400; // 1 Nov, 2018 00:00:00 UTC
185     uint256 public constant TIME_LOCK_END = 1525132800; // 1 May, 2018 00:00:00 UTC
186 
187     mapping (address => uint256) public contributions;
188     uint256 public totalContributions = 0;
189 
190     ERC20 public token;
191 
192     event Contribution(address indexed _addr, uint256 _amount);
193     event Withdrawal(address indexed _addr, uint256 _amount);
194 
195     modifier whenAbleToContribute(uint256 _amount)
196     {
197         require(
198             now > CONTRIBUTION_START &&
199             now < CONTRIBUTION_END &&
200             _amount > 0 &&
201             contributions[msg.sender].add(_amount) <= MAX_CONTRIBUTION &&
202             totalContributions.add(_amount) <= MAX_TOTAL_CONTRIBUTIONS &&
203             token.allowance(msg.sender, this) >= _amount
204         );
205         _;
206     }
207 
208     modifier whenAbleToWithdraw()
209     {
210         require(
211             now >= TIME_LOCK_END &&
212             contributions[msg.sender] > 0
213         );
214         _;
215     }
216 
217     function EcoVault(address _tokenAddress) public
218     {
219         token = ERC20(_tokenAddress);
220     }
221 
222     function contribute(uint256 _amount) whenAbleToContribute(_amount) whenNotPaused public
223     {
224         contributions[msg.sender] = contributions[msg.sender].add(_amount);
225         totalContributions = totalContributions.add(_amount);
226         token.safeTransferFrom(msg.sender, this, _amount);
227         Contribution(msg.sender, _amount);
228     }
229 
230     function contributionsOf(address _addr) public constant returns (uint256)
231     {
232         return contributions[_addr];
233     }
234 
235     function withdraw() whenAbleToWithdraw whenNotPaused public
236     {
237         uint256 amount = contributions[msg.sender];
238         contributions[msg.sender] = 0;
239         totalContributions = totalContributions.sub(amount);
240         token.safeTransfer(msg.sender, amount);
241         Withdrawal(msg.sender, amount);
242     }
243 }