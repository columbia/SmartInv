1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface ICvnToken {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     /**
31     * @dev Multiplies two numbers, reverts on overflow.
32     */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61     */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70     * @dev Adds two numbers, reverts on overflow.
71     */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
81     * reverts when dividing by zero.
82     */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 /**
89  * @title SafeERC20
90  * @dev Wrappers around ERC20 operations that throw on failure.
91  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
92  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
93  */
94 library SafeERC20 {
95     using SafeMath for uint256;
96 
97     function safeTransfer(ICvnToken token, address to, uint256 value) internal {
98         require(token.transfer(to, value));
99     }
100 
101     function safeTransferFrom(ICvnToken token, address from, address to, uint256 value) internal {
102         require(token.transferFrom(from, to, value));
103     }
104 
105     function safeApprove(ICvnToken token, address spender, uint256 value) internal {
106         // safeApprove should only be called when setting an initial allowance,
107         // or when resetting it to zero. To increase and decrease it, use
108         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
109         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
110         require(token.approve(spender, value));
111     }
112 
113     function safeIncreaseAllowance(ICvnToken token, address spender, uint256 value) internal {
114         uint256 newAllowance = token.allowance(address(this), spender).add(value);
115         require(token.approve(spender, newAllowance));
116     }
117 
118     function safeDecreaseAllowance(ICvnToken token, address spender, uint256 value) internal {
119         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
120         require(token.approve(spender, newAllowance));
121     }
122 }
123 
124 /**
125  * @title Ownable
126  * @dev The Ownable contract has an owner address, and provides basic authorization control
127  * functions, this simplifies the implementation of "user permissions".
128  */
129 contract Ownable {
130     address internal _owner;
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134     /**
135      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
136      * account.
137      */
138     constructor () internal {
139         _owner = msg.sender;
140         emit OwnershipTransferred(address(0), _owner);
141     }
142 
143     /**
144      * @return the address of the owner.
145      */
146     function owner() public view returns (address) {
147         return _owner;
148     }
149 
150     /**
151      * @dev Throws if called by any account other than the owner.
152      */
153     modifier onlyOwner() {
154         require(isOwner());
155         _;
156     }
157 
158     /**
159      * @return true if `msg.sender` is the owner of the contract.
160      */
161     function isOwner() public view returns (bool) {
162         return msg.sender == _owner;
163     }
164 
165     /**
166      * @dev Allows the current owner to relinquish control of the contract.
167      * @notice Renouncing to ownership will leave the contract without an owner.
168      * It will not be possible to call the functions with the `onlyOwner`
169      * modifier anymore.
170      */
171     function renounceOwnership() public onlyOwner {
172         emit OwnershipTransferred(_owner, address(0));
173         _owner = address(0);
174     }
175 
176     /**
177      * @dev Allows the current owner to transfer control of the contract to a newOwner.
178      * @param newOwner The address to transfer ownership to.
179      */
180     function transferOwnership(address newOwner) public onlyOwner {
181         _transferOwnership(newOwner);
182     }
183 
184     /**
185      * @dev Transfers control of the contract to a newOwner.
186      * @param newOwner The address to transfer ownership to.
187      */
188     function _transferOwnership(address newOwner) internal {
189         require(newOwner != address(0));
190         emit OwnershipTransferred(_owner, newOwner);
191         _owner = newOwner;
192     }
193 }
194 
195 /**
196  * @title TokenVesting
197  * @dev A token holder contract that can release its token balance gradually like a
198  * typical vesting scheme, with vesting period. Optionally revocable by the
199  * owner.
200  */
201 contract TokenVesting is Ownable {
202   using SafeMath for uint256;
203   using SafeERC20 for ICvnToken;
204 
205   event Released(uint256 amount);
206   event Revoked();
207 
208   // beneficiary of tokens after they are released
209   address public beneficiary;
210 
211   // duration in seconds of every unlock time
212   uint256 public period;
213   uint256 public start;
214   uint256 public duration;
215 
216   bool public revocable;
217 
218   mapping (address => uint256) public released;
219   mapping (address => bool) public revoked;
220 
221   /**
222    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
223    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
224    * of the balance will have vested.
225    * @param _start the time (as Unix time) at which point vesting starts
226    * @param _duration duration in seconds of the period in which the tokens will vest
227    * @param _revocable whether the vesting is revocable or not
228    */
229   constructor(
230     address _beneficiary,
231     uint256 _start,
232     uint256 _duration,
233     bool _revocable
234   )
235     public
236   {
237     require(_beneficiary != address(0));
238     require(_start > block.timestamp);
239 
240     beneficiary = _beneficiary;
241     revocable = _revocable;
242     duration = _duration;
243     period = _duration.div(4);
244     start = _start;
245   }
246 
247   /**
248    * @notice Transfers vested tokens to beneficiary.
249    * @param _token ICvnToken token which is being vested
250    */
251   function release(ICvnToken _token) public {
252     uint256 unreleased = releasableAmount(_token);
253 
254     require(unreleased > 0);
255 
256     released[_token] = released[_token].add(unreleased);
257 
258     _token.safeTransfer(beneficiary, unreleased);
259 
260     emit Released(unreleased);
261   }
262 
263   /**
264    * @notice Allows the owner to revoke the vesting. Tokens already vested
265    * remain in the contract, the rest are returned to the owner.
266    * @param _token ERC20 token which is being vested
267    */
268   function revoke(ICvnToken _token) public onlyOwner {
269     require(revocable);
270     require(!revoked[_token]);
271 
272     uint256 balance = _token.balanceOf(address(this));
273 
274     uint256 unreleased = releasableAmount(_token);
275     uint256 refund = balance.sub(unreleased);
276 
277     revoked[_token] = true;
278 
279     _token.safeTransfer(_owner, refund);
280 
281     emit Revoked();
282   }
283 
284   /**
285    * @dev Calculates the amount that has already vested but hasn't been released yet.
286    * @param _token ICvnToken token which is being vested
287    */
288   function releasableAmount(ICvnToken _token) public view returns (uint256) {
289     return vestedAmount(_token).sub(released[_token]);
290   }
291 
292   /**
293    * @dev Calculates the amount that has already vested.
294    * @param _token ERC20 token which is being vested
295    */
296   function vestedAmount(ICvnToken _token) public view returns (uint256) {
297     uint256 currentBalance = _token.balanceOf(this);
298     uint256 totalBalance = currentBalance.add(released[_token]);
299     
300     if (block.timestamp < start.add(period)) {
301       return 0;
302     } else if (block.timestamp >= start.add(duration) || revoked[_token]) {
303       return totalBalance;
304     } else if (block.timestamp < start.add(period.mul(2))) {
305       return totalBalance.div(4);
306     } else if (block.timestamp < start.add(period.mul(3))) {
307       return totalBalance.div(2);
308     } else if (block.timestamp < start.add(duration)) {
309       return totalBalance.mul(3).div(4);
310     }
311   }
312 
313   // can accept ether
314   function() payable {}
315 }