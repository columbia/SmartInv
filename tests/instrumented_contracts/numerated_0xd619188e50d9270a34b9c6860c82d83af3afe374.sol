1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Math
6  * @dev Assorted math operations
7  */
8 library Math {
9   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
10     return a >= b ? a : b;
11   }
12 
13   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
14     return a < b ? a : b;
15   }
16 
17   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
18     return a >= b ? a : b;
19   }
20 
21   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
22     return a < b ? a : b;
23   }
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
36     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
37     // benefit is lost if 'b' is also tested.
38     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39     if (a == 0) {
40       return 0;
41     }
42 
43     c = a * b;
44     assert(c / a == b);
45     return c;
46   }
47 
48   /**
49   * @dev Integer division of two numbers, truncating the quotient.
50   */
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     // uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return a / b;
56   }
57 
58   /**
59   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
60   */
61   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65 
66   /**
67   * @dev Adds two numbers, throws on overflow.
68   */
69   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
70     c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   function totalSupply() public view returns (uint256);
83   function balanceOf(address who) public view returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender)
94     public view returns (uint256);
95 
96   function transferFrom(address from, address to, uint256 value)
97     public returns (bool);
98 
99   function approve(address spender, uint256 value) public returns (bool);
100   event Approval(
101     address indexed owner,
102     address indexed spender,
103     uint256 value
104   );
105 }
106 
107 /**
108  * @title SafeERC20
109  * @dev Wrappers around ERC20 operations that throw on failure.
110  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
111  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
112  */
113 library SafeERC20 {
114   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
115     require(token.transfer(to, value));
116   }
117 
118   function safeTransferFrom(
119     ERC20 token,
120     address from,
121     address to,
122     uint256 value
123   )
124     internal
125   {
126     require(token.transferFrom(from, to, value));
127   }
128 
129   function safeApprove(ERC20 token, address spender, uint256 value) internal {
130     require(token.approve(spender, value));
131   }
132 }
133 
134 contract ARPLongTermHolding {
135     using SafeERC20 for ERC20;
136     using SafeMath for uint256;
137     using Math for uint256;
138 
139     // During the first 31 days of deployment, this contract opens for deposit of ARP.
140     uint256 public constant DEPOSIT_PERIOD      = 31 days; // = 1 months
141 
142     // 16 months after deposit, user can withdrawal all his/her ARP.
143     uint256 public constant WITHDRAWAL_DELAY    = 480 days; // = 16 months
144 
145     // Ower can drain all remaining ARP after 3 years.
146     uint256 public constant DRAIN_DELAY         = 1080 days; // = 3 years.
147 
148     // 50% bonus ARP return
149     uint256 public constant BONUS_SCALE         = 2;
150 
151     // ERC20 basic token contract being held
152     ERC20 public arpToken;
153     address public owner;
154     uint256 public arpDeposited;
155     uint256 public depositStartTime;
156     uint256 public depositStopTime;
157 
158     struct Record {
159         uint256 amount;
160         uint256 timestamp;
161     }
162 
163     mapping (address => Record) records;
164 
165     /* 
166      * EVENTS
167      */
168 
169     /// Emitted when all ARP are drained.
170     event Drained(uint256 _amount);
171 
172     /// Emitted for each sucuessful deposit.
173     uint256 public depositId = 0;
174     event Deposit(uint256 _depositId, address indexed _addr, uint256 _amount, uint256 _bonus);
175 
176     /// Emitted for each sucuessful withdrawal.
177     uint256 public withdrawId = 0;
178     event Withdrawal(uint256 _withdrawId, address indexed _addr, uint256 _amount);
179 
180     /// Initialize the contract
181     constructor(ERC20 _arpToken, uint256 _depositStartTime) public {
182         arpToken = _arpToken;
183         owner = msg.sender;
184         depositStartTime = _depositStartTime;
185         depositStopTime = _depositStartTime.add(DEPOSIT_PERIOD);
186     }
187 
188     /*
189      * PUBLIC FUNCTIONS
190      */
191 
192     /// Drains ARP.
193     function drain() public {
194         require(msg.sender == owner);
195         // solium-disable-next-line security/no-block-members
196         require(now >= depositStartTime.add(DRAIN_DELAY));
197 
198         uint256 balance = arpToken.balanceOf(address(this));
199         require(balance > 0);
200 
201         arpToken.safeTransfer(owner, balance);
202 
203         emit Drained(balance);
204     }
205 
206     function() public {
207         // solium-disable-next-line security/no-block-members
208         if (now >= depositStartTime && now < depositStopTime) {
209             deposit();
210         // solium-disable-next-line security/no-block-members
211         } else if (now > depositStopTime){
212             withdraw();
213         } else {
214             revert();
215         }
216     }
217 
218     /// Gets the balance of the specified address.
219     function balanceOf(address _owner) view public returns (uint256) {
220         return records[_owner].amount;
221     }
222 
223     /// Gets the withdrawal timestamp of the specified address.
224     function withdrawalTimeOf(address _owner) view public returns (uint256) {
225         return records[_owner].timestamp.add(WITHDRAWAL_DELAY);
226     }
227 
228     /// Deposits ARP.
229     function deposit() private {
230         uint256 amount = arpToken
231             .balanceOf(msg.sender)
232             .min256(arpToken.allowance(msg.sender, address(this)));
233         require(amount > 0);
234 
235         uint256 bonus = amount.div(BONUS_SCALE);
236 
237         Record storage record = records[msg.sender];
238         record.amount = record.amount.add(amount).add(bonus);
239         // solium-disable-next-line security/no-block-members
240         record.timestamp = now;
241         records[msg.sender] = record;
242 
243         arpDeposited = arpDeposited.add(amount).add(bonus);
244 
245         if (bonus > 0) {
246             arpToken.safeTransferFrom(owner, address(this), bonus);
247         }
248         arpToken.safeTransferFrom(msg.sender, address(this), amount);
249 
250         emit Deposit(depositId++, msg.sender, amount, bonus);
251     }
252 
253     /// Withdraws ARP.
254     function withdraw() private {
255         require(arpDeposited > 0);
256 
257         Record storage record = records[msg.sender];
258         require(record.amount > 0);
259         // solium-disable-next-line security/no-block-members
260         require(now >= record.timestamp.add(WITHDRAWAL_DELAY));
261         uint256 amount = record.amount;
262         delete records[msg.sender];
263 
264         arpDeposited = arpDeposited.sub(amount);
265 
266         arpToken.safeTransfer(msg.sender, amount);
267 
268         emit Withdrawal(withdrawId++, msg.sender, amount);
269     }
270 }