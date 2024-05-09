1 pragma solidity 0.5.9;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Unsigned math operations with safety checks that revert on error
7  */
8 library SafeMath {
9     /**
10      * @dev Multiplies two unsigned integers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Adds two unsigned integers, reverts on overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://eips.ethereum.org/EIPS/eip-20
71  */
72 interface IERC20 {
73     function transfer(address to, uint256 value) external returns (bool);
74 
75     function approve(address spender, uint256 value) external returns (bool);
76 
77     function transferFrom(address from, address to, uint256 value) external returns (bool);
78 
79     function totalSupply() external view returns (uint256);
80 
81     function balanceOf(address who) external view returns (uint256);
82 
83     function allowance(address owner, address spender) external view returns (uint256);
84 
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 
91 
92 /**
93  * @title Claimable
94  * @dev Claimable contract, where the ownership needs to be claimed.
95  * This allows the new owner to accept the transfer.
96  */
97 contract Claimable {
98     address public owner;
99     address public pendingOwner;
100 
101     event OwnershipTransferred(
102         address indexed previousOwner,
103         address indexed newOwner
104     );
105 
106     /**
107     * @dev The Claimable constructor sets the original `owner` of the contract to the sender
108     * account.
109     */
110     constructor() public {
111         owner = msg.sender;
112     }
113 
114     /**
115     * @dev Throws if called by any account other than the owner.
116     */
117     modifier onlyOwner() {
118         require(msg.sender == owner);
119         _;
120     }
121 
122     /**
123     * @dev Modifier throws if called by any account other than the pendingOwner.
124     */
125     modifier onlyPendingOwner() {
126         require(msg.sender == pendingOwner);
127         _;
128     }
129 
130     /**
131     * @dev Allows the current owner to set the pendingOwner address.
132     * @param newOwner The address to transfer ownership to.
133     */
134     function transferOwnership(address newOwner) public onlyOwner {
135         pendingOwner = newOwner;
136     }
137 
138     /**
139     * @dev Allows the pendingOwner address to finalize the transfer.
140     */
141     function claimOwnership() public onlyPendingOwner {
142         emit OwnershipTransferred(owner, pendingOwner);
143         owner = pendingOwner;
144         pendingOwner = address(0);
145     }
146 }
147 
148 /**
149 * @title Keeper
150 *
151 * @dev Implements the early investors' SWG tokens locking mechanism.
152 * To avoid momentary dumping SWG token, the Keeper holds the early
153 * investor's funds frozen until unFreezeStartDate. Between unFreezeStartDate
154 * and totalUnFreezeDate, the contract allows holder to withdraw amount
155 * proportional to time passed. After totalUnFreezeDate the funds get totally
156 * unlocked and the early investor can spend the entire amount at any moment.
157 */
158 contract Keeper is Claimable {
159     using SafeMath for uint256;
160     IERC20 public token;
161     // the date when withdrawals become possible
162     uint256 public unFreezeStartDate;
163     // the date when all funds get unfrozen
164     uint256 public totalUnFreezeDate;
165     // the records about individual balances
166     mapping(address => uint256) public balances;
167     // the records about already withdrawn amounts
168     mapping(address => uint256) public withdrawnBalances;
169     // the sum of registered balance
170     uint256 public totalBalance;
171 
172     constructor(
173         IERC20 _token,
174         uint256 _unFreezeStartDate,
175         uint256 _totalUnFreezeDate
176     ) public {
177         // solhint-disable-next-line not-rely-on-time
178         require(_unFreezeStartDate >= block.timestamp);
179         require(_totalUnFreezeDate > _unFreezeStartDate);
180         token = _token;
181         unFreezeStartDate = _unFreezeStartDate;
182         totalUnFreezeDate = _totalUnFreezeDate;
183     }
184 
185     /**
186      * @dev Adds the individual holder's balance
187      *
188      * Called by the backend of payout engine per holder (after token got transferred on the Keeper)
189      */
190     function addBalance(address _to, uint256 _value) public onlyOwner {
191         require(_to != address(0));
192         require(_value > 0);
193         require(totalBalance.add(_value)
194                 <= token.balanceOf(address(this)), "not enough tokens");
195         balances[_to] = balances[_to].add(_value);
196         totalBalance = totalBalance.add(_value);
197     }
198 
199     /**
200      * @dev Withdraws the allowed amount of tokens
201      *
202      * Called by the investor through Keeper Dapp or Etherscan write interface
203      */
204     function withdraw(address _to, uint256 _value) public {
205         require(_to != address(0));
206         require(_value > 0);
207         require(unFreezeStartDate < now, "not unfrozen yet");
208         require(
209             (getUnfrozenAmount(msg.sender).sub(withdrawnBalances[msg.sender]))
210             >= _value
211         );
212         withdrawnBalances[msg.sender] = withdrawnBalances[msg.sender].add(_value);
213         totalBalance = totalBalance.sub(_value);
214         token.transfer(_to, _value);
215     }
216 
217     /**
218      * @dev Shows the amount of tokens allowed to withdraw
219      *
220      * Called by the investor through Keeper Dapp or Etherscan write interface
221      */
222     function getUnfrozenAmount(address _holder) public view returns (uint256) {
223         if (now > unFreezeStartDate) {
224             if (now > totalUnFreezeDate) {
225                 // tokens are totally unfrozen
226                 return balances[_holder];
227             }
228             // tokens are partially unfrozen
229             uint256 partialFreezePeriodLen =
230                 totalUnFreezeDate.sub(unFreezeStartDate);
231             uint256 secondsSincePeriodStart = now.sub(unFreezeStartDate);
232             uint256 amount = balances[_holder]
233                 .mul(secondsSincePeriodStart)
234                 .div(partialFreezePeriodLen);
235             return amount;
236         }
237         // tokens are totally frozen
238         return 0;
239     }
240 }