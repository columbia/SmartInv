1 pragma solidity ^0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 interface IERC20 {
83     function transfer(address to, uint256 value) external returns (bool);
84 
85     function approve(address spender, uint256 value) external returns (bool);
86 
87     function transferFrom(address from, address to, uint256 value) external returns (bool);
88 
89     function totalSupply() external view returns (uint256);
90 
91     function balanceOf(address who) external view returns (uint256);
92 
93     function allowance(address owner, address spender) external view returns (uint256);
94 
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
101 
102 /**
103  * @title SafeMath
104  * @dev Unsigned math operations with safety checks that revert on error
105  */
106 library SafeMath {
107     /**
108     * @dev Multiplies two unsigned integers, reverts on overflow.
109     */
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
112         // benefit is lost if 'b' is also tested.
113         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
114         if (a == 0) {
115             return 0;
116         }
117 
118         uint256 c = a * b;
119         require(c / a == b);
120 
121         return c;
122     }
123 
124     /**
125     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
126     */
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         // Solidity only automatically asserts when dividing by 0
129         require(b > 0);
130         uint256 c = a / b;
131         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132 
133         return c;
134     }
135 
136     /**
137     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
138     */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         require(b <= a);
141         uint256 c = a - b;
142 
143         return c;
144     }
145 
146     /**
147     * @dev Adds two unsigned integers, reverts on overflow.
148     */
149     function add(uint256 a, uint256 b) internal pure returns (uint256) {
150         uint256 c = a + b;
151         require(c >= a);
152 
153         return c;
154     }
155 
156     /**
157     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
158     * reverts when dividing by zero.
159     */
160     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
161         require(b != 0);
162         return a % b;
163     }
164 }
165 
166 // File: contracts/LockedWallet.sol
167 
168 contract LockedWallet is Ownable {
169     using SafeMath for uint256;
170 
171     event Withdrawn (
172         uint256 period,
173         uint256 amount,
174         uint256 timestamp
175     );
176 
177     uint256 public depositedTime;
178     uint256 public periodLength;
179     uint256 public amountPerPeriod;
180     IERC20 public token;
181     uint256 public depositedAmount;
182     mapping(uint256 => uint256) public withdrawalByPeriod;
183 
184     constructor(uint256 newPeriodLength, uint256 newAmountPerPeriod, address tokenAddress) public {
185         require(tokenAddress != address(0));
186         require(newPeriodLength > 0);
187         require(newAmountPerPeriod > 0);
188 
189         token = IERC20(tokenAddress);
190         periodLength = newPeriodLength;
191         amountPerPeriod = newAmountPerPeriod;
192     }
193 
194     function deposit(uint256 amount) public {
195         require(depositedTime == 0, "already deposited");
196 
197         depositedTime = now;
198         depositedAmount = amount;
199 
200         token.transferFrom(msg.sender, address(this), amount);
201     }
202 
203     function withdraw() public onlyOwner {
204         require(depositedTime > 0, "not deposited");
205 
206         uint256 currentPeriod = now.sub(depositedTime).div(periodLength);
207         require(currentPeriod > 0, "invalid period 1");
208         require(withdrawalByPeriod[currentPeriod] == 0, "already withdrawn");
209 
210         uint256 balance = token.balanceOf(address(this));
211         uint256 amount = amountPerPeriod < balance ? amountPerPeriod : balance;
212         require(amount > 0, "empty");
213 
214         withdrawalByPeriod[currentPeriod] = amount;
215 
216         emit Withdrawn(currentPeriod, amount, now);
217 
218         token.transfer(owner(), amount);
219     }
220 
221     function balance() public view returns (uint256) {
222         return token.balanceOf(address(this));
223     }
224 }