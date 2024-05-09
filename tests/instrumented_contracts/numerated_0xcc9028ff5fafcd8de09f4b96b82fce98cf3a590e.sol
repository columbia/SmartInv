1 pragma solidity 0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /root/code/solidity/xixoio-contracts/flat/TokenPool.sol
6 // flattened :  Monday, 03-Dec-18 10:34:17 UTC
7 contract Ownable {
8   address private _owner;
9 
10   event OwnershipTransferred(
11     address indexed previousOwner,
12     address indexed newOwner
13   );
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   constructor() internal {
20     _owner = msg.sender;
21     emit OwnershipTransferred(address(0), _owner);
22   }
23 
24   /**
25    * @return the address of the owner.
26    */
27   function owner() public view returns(address) {
28     return _owner;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(isOwner());
36     _;
37   }
38 
39   /**
40    * @return true if `msg.sender` is the owner of the contract.
41    */
42   function isOwner() public view returns(bool) {
43     return msg.sender == _owner;
44   }
45 
46   /**
47    * @dev Allows the current owner to relinquish control of the contract.
48    * @notice Renouncing to ownership will leave the contract without an owner.
49    * It will not be possible to call the functions with the `onlyOwner`
50    * modifier anymore.
51    */
52   function renounceOwnership() public onlyOwner {
53     emit OwnershipTransferred(_owner, address(0));
54     _owner = address(0);
55   }
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     _transferOwnership(newOwner);
63   }
64 
65   /**
66    * @dev Transfers control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function _transferOwnership(address newOwner) internal {
70     require(newOwner != address(0));
71     emit OwnershipTransferred(_owner, newOwner);
72     _owner = newOwner;
73   }
74 }
75 
76 library SafeMath {
77 
78   /**
79   * @dev Multiplies two numbers, reverts on overflow.
80   */
81   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83     // benefit is lost if 'b' is also tested.
84     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
85     if (a == 0) {
86       return 0;
87     }
88 
89     uint256 c = a * b;
90     require(c / a == b);
91 
92     return c;
93   }
94 
95   /**
96   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
97   */
98   function div(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b > 0); // Solidity only automatically asserts when dividing by 0
100     uint256 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102 
103     return c;
104   }
105 
106   /**
107   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
108   */
109   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110     require(b <= a);
111     uint256 c = a - b;
112 
113     return c;
114   }
115 
116   /**
117   * @dev Adds two numbers, reverts on overflow.
118   */
119   function add(uint256 a, uint256 b) internal pure returns (uint256) {
120     uint256 c = a + b;
121     require(c >= a);
122 
123     return c;
124   }
125 
126   /**
127   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
128   * reverts when dividing by zero.
129   */
130   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
131     require(b != 0);
132     return a % b;
133   }
134 }
135 
136 interface IERC20 {
137   function totalSupply() external view returns (uint256);
138 
139   function balanceOf(address who) external view returns (uint256);
140 
141   function allowance(address owner, address spender)
142     external view returns (uint256);
143 
144   function transfer(address to, uint256 value) external returns (bool);
145 
146   function approve(address spender, uint256 value)
147     external returns (bool);
148 
149   function transferFrom(address from, address to, uint256 value)
150     external returns (bool);
151 
152   event Transfer(
153     address indexed from,
154     address indexed to,
155     uint256 value
156   );
157 
158   event Approval(
159     address indexed owner,
160     address indexed spender,
161     uint256 value
162   );
163 }
164 
165 interface ITokenPool {
166     function balanceOf(uint128 id) public view returns (uint256);
167     function allocate(uint128 id, uint256 value) public;
168     function withdraw(uint128 id, address to, uint256 value) public;
169     function complete() public;
170 }
171 
172 contract TokenPool is ITokenPool, Ownable {
173     using SafeMath for uint256;
174 
175     IERC20 public token;
176     bool public completed = false;
177 
178     mapping(uint128 => uint256) private balances;
179     uint256 public allocated = 0;
180 
181     event FundsAllocated(uint128 indexed account, uint256 value);
182     event FundsWithdrawn(uint128 indexed account, address indexed to, uint256 value);
183 
184     constructor(address tokenAddress) public {
185         token = IERC20(tokenAddress);
186     }
187 
188     /**
189      * @return The balance of the account in pool
190      */
191     function balanceOf(uint128 account) public view returns (uint256) {
192         return balances[account];
193     }
194 
195     /**
196      * Token allocation function
197      * @dev should be called after every token deposit to allocate these token to the account
198      */
199     function allocate(uint128 account, uint256 value) public onlyOwner {
200         require(!completed, "Pool is already completed");
201         assert(unallocated() >= value);
202         allocated = allocated.add(value);
203         balances[account] = balances[account].add(value);
204         emit FundsAllocated(account, value);
205     }
206 
207     /**
208      * Allows withdrawal of tokens and dividends from temporal storage to the wallet
209      * @dev transfers corresponding amount of dividend in ETH
210      */
211     function withdraw(uint128 account, address to, uint256 value) public onlyOwner {
212         balances[account] = balances[account].sub(value);
213         uint256 balance = address(this).balance;
214         uint256 dividend = balance.mul(value).div(allocated);
215         allocated = allocated.sub(value);
216         token.transfer(to, value);
217         if (dividend > 0) {
218             to.transfer(dividend);
219         }
220         emit FundsWithdrawn(account, to, value);
221     }
222 
223     /**
224      * Concludes allocation of tokens and serves as a drain for unallocated tokens
225      */
226     function complete() public onlyOwner {
227         completed = true;
228         token.transfer(msg.sender, unallocated());
229     }
230 
231     /**
232      * Fallback function enabling deposit of dividends in ETH
233      * @dev dividend has to be deposited only after pool completion, as additional token
234      *      allocations after the deposit would skew shares
235      */
236     function () public payable {
237         require(completed, "Has to be completed first");
238     }
239 
240     /**
241      * @return Amount of unallocated tokens in the pool
242      */
243     function unallocated() internal view returns (uint256) {
244         return token.balanceOf(this).sub(allocated);
245     }
246 }