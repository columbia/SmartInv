1 pragma solidity 0.5.9;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://eips.ethereum.org/EIPS/eip-20
70  */
71 interface IERC20 {
72     function transfer(address to, uint256 value) external returns (bool);
73 
74     function approve(address spender, uint256 value) external returns (bool);
75 
76     function transferFrom(address from, address to, uint256 value) external returns (bool);
77 
78     function totalSupply() external view returns (uint256);
79 
80     function balanceOf(address who) external view returns (uint256);
81 
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * @title Claimable
91  * @dev Claimable contract, where the ownership needs to be claimed.
92  * This allows the new owner to accept the transfer.
93  */
94 contract Claimable {
95     address public owner;
96     address public pendingOwner;
97 
98     event OwnershipTransferred(
99         address indexed previousOwner,
100         address indexed newOwner
101     );
102 
103     /**
104     * @dev The Claimable constructor sets the original `owner` of the contract to the sender
105     * account.
106     */
107     constructor() public {
108         owner = msg.sender;
109     }
110 
111     /**
112     * @dev Throws if called by any account other than the owner.
113     */
114     modifier onlyOwner() {
115         require(msg.sender == owner);
116         _;
117     }
118 
119     /**
120     * @dev Modifier throws if called by any account other than the pendingOwner.
121     */
122     modifier onlyPendingOwner() {
123         require(msg.sender == pendingOwner);
124         _;
125     }
126 
127     /**
128     * @dev Allows the current owner to set the pendingOwner address.
129     * @param newOwner The address to transfer ownership to.
130     */
131     function transferOwnership(address newOwner) public onlyOwner {
132         pendingOwner = newOwner;
133     }
134 
135     /**
136     * @dev Allows the pendingOwner address to finalize the transfer.
137     */
138     function claimOwnership() public onlyPendingOwner {
139         emit OwnershipTransferred(owner, pendingOwner);
140         owner = pendingOwner;
141         pendingOwner = address(0);
142     }
143 }
144 
145 /**
146 * @title Keeper
147 *
148 * @dev Implements the early investors' SWG tokens locking mechanism.
149 * To avoid momentary dumping SWG token, the Keeper holds the early
150 * investor's funds frozen until unFreezeStartDate. Between unFreezeStartDate
151 * and totalUnFreezeDate, the contract allows holder to withdraw amount
152 * proportional to time passed. After totalUnFreezeDate the funds get totally
153 * unlocked and the early investor can spend the entire amount at any moment.
154 */
155 contract Keeper is Claimable {
156     using SafeMath for uint256;
157     IERC20 public token;
158     // the date when withdrawals become possible
159     uint256 public unFreezeStartDate;
160     // the date when all funds get unfrozen
161     uint256 public totalUnFreezeDate;
162     // the records about individual balances
163     mapping(address => uint256) public balances;
164     // the records about already withdrawn amounts
165     mapping(address => uint256) public withdrawnBalances;
166     // the sum of registered balance
167     uint256 public totalBalance;
168 
169     constructor(
170         IERC20 _token,
171         uint256 _unFreezeStartDate,
172         uint256 _totalUnFreezeDate
173     ) public {
174         // solhint-disable-next-line not-rely-on-time
175         require(_unFreezeStartDate >= block.timestamp);
176         require(_totalUnFreezeDate > _unFreezeStartDate);
177         token = _token;
178         unFreezeStartDate = _unFreezeStartDate;
179         totalUnFreezeDate = _totalUnFreezeDate;
180     }
181 
182     /**
183      * @dev Adds the individual holder's balance
184      *
185      * Called by the backend of payout engine per holder (after token got transferred on the Keeper)
186      */
187     function addBalance(address _to, uint256 _value) public onlyOwner {
188         require(_to != address(0));
189         require(_value > 0);
190         require(totalBalance.add(_value)
191                 <= token.balanceOf(address(this)), "not enough tokens");
192         balances[_to] = balances[_to].add(_value);
193         totalBalance = totalBalance.add(_value);
194     }
195 
196     /**
197      * @dev Withdraws the allowed amount of tokens
198      *
199      * Called by the investor through Keeper Dapp or Etherscan write interface
200      */
201     function withdraw(address _to, uint256 _value) public {
202         require(_to != address(0));
203         require(_value > 0);
204         require(unFreezeStartDate < now, "not unfrozen yet");
205         require(
206             (getUnfrozenAmount(msg.sender).sub(withdrawnBalances[msg.sender]))
207             >= _value
208         );
209         withdrawnBalances[msg.sender] = withdrawnBalances[msg.sender].add(_value);
210         totalBalance = totalBalance.sub(_value);
211         token.transfer(_to, _value);
212     }
213 
214     /**
215      * @dev Shows the amount of tokens allowed to withdraw
216      *
217      * Called by the investor through Keeper Dapp or Etherscan write interface
218      */
219     function getUnfrozenAmount(address _holder) public view returns (uint256) {
220         if (now > unFreezeStartDate) {
221             if (now > totalUnFreezeDate) {
222                 return balances[_holder];
223             }
224             uint256 partialFreezePeriodLen =
225                 totalUnFreezeDate.sub(unFreezeStartDate);
226             uint256 secondsSincePeriodStart = now.sub(unFreezeStartDate);
227             uint256 amount = balances[_holder]
228                 .mul(secondsSincePeriodStart)
229                 .div(partialFreezePeriodLen);
230             return amount;
231         }
232         return 0;
233     }
234 }