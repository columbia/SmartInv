1 pragma solidity 0.5.4;
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
13         
14         if (a == 0) {
15             return 0;
16         }
17 
18         uint256 c = a * b;
19         require(c / a == b);
20 
21         return c;
22     }
23 
24     /**
25      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
26      */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28        
29         require(b > 0);
30         uint256 c = a / b;
31        
32         return c;
33     }
34 
35     /**
36      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37      */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a);
40         uint256 c = a - b;
41 
42         return c;
43     }
44 
45     /**
46      * @dev Adds two unsigned integers, reverts on overflow.
47      */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a);
51 
52         return c;
53     }
54 
55     /**
56      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
57      * reverts when dividing by zero.
58      */
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b != 0);
61         return a % b;
62     }
63 }
64 /**
65 * @title interface of ERC 20 token
66 * 
67 */
68 
69 interface IERC20 {
70     function transfer(address to, uint256 value) external returns (bool);
71 
72     function approve(address spender, uint256 value) external returns (bool);
73 
74     function transferFrom(address from, address to, uint256 value) external returns (bool);
75 
76     function totalSupply() external view returns (uint256);
77 
78     function balanceOf(address who) external view returns (uint256);
79 
80     function allowance(address owner, address spender) external view returns (uint256);
81 
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 /**
88  * @title SafeERC20
89  * @dev Wrappers around ERC20 operations that throw on failure.
90  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
91  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
92  */
93  
94 library SafeERC20 {
95     
96     using SafeMath for uint256;
97 
98     function safeTransfer(IERC20 token, address to, uint256 value) internal {
99         require(token.transfer(to, value));
100     }
101 
102     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
103         require(token.transferFrom(from, to, value));
104     }
105 
106     function safeApprove(IERC20 token, address spender, uint256 value) internal {
107         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
108         require(token.approve(spender, value));
109     }
110 
111     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
112         uint256 newAllowance = token.allowance(address(this), spender).add(value);
113         require(token.approve(spender, newAllowance));
114     }
115 
116     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
117         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
118         require(token.approve(spender, newAllowance));
119     }
120 }
121 /**
122  * @title Ownable
123  * @dev The Ownable contract has an owner address, and provides basic authorization control
124  * functions, this simplifies the implementation of "user permissions".
125  */
126 contract Ownable {
127     address private _owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     /**
132      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
133      * account.
134      */
135     constructor () internal {
136         _owner = msg.sender;
137         emit OwnershipTransferred(address(0), _owner);
138     }
139 
140     /**
141      * @return the address of the owner.
142      */
143     function owner() public view returns (address) {
144         return _owner;
145     }
146 
147     /**
148      * @dev Throws if called by any account other than the owner.
149      */
150     modifier onlyOwner() {
151         require(isOwner());
152         _;
153     }
154 
155     /**
156      * @return true if `msg.sender` is the owner of the contract.
157      */
158     function isOwner() public view returns (bool) {
159         return msg.sender == _owner;
160     }
161 
162     /**
163      * @dev Allows the current owner to relinquish control of the contract.
164      * @notice Warning!!!! only be used when owner address is compromised
165      */
166     function renounceOwnership() public onlyOwner {
167         emit OwnershipTransferred(_owner, address(0));
168         _owner = address(0);
169     }
170 
171     /**
172      * @dev Allows the current owner to transfer control of the contract to a newOwner.
173      * @param newOwner The address to transfer ownership to.
174      */
175     function transferOwnership(address newOwner) public onlyOwner {
176         _transferOwnership(newOwner);
177     }
178 
179     /**
180      * @dev Transfers control of the contract to a newOwner.
181      * @param newOwner The address to transfer ownership to.
182      */
183     function _transferOwnership(address newOwner) internal {
184         require(newOwner != address(0));
185         emit OwnershipTransferred(_owner, newOwner);
186         _owner = newOwner;
187     }
188 }
189 contract TokenVesting is Ownable{
190     
191     using SafeMath for uint256;
192     using SafeERC20 for IERC20;
193     
194     struct VestedToken{
195         uint256 cliff;
196         uint256 start;
197         uint256 duration;
198         uint256 releasedToken;
199         uint256 totalToken;
200         bool revoked;
201     }
202     
203     mapping (address => VestedToken) public vestedUser; 
204     
205     // default Vesting parameter values
206     uint256 private _cliff = 2592000; // 30 days period
207     uint256 private _duration = 93312000; // for 3 years
208     bool private _revoked = false;
209     
210     IERC20 public LCXToken;
211     
212     event TokenReleased(address indexed account, uint256 amount);
213     event VestingRevoked(address indexed account);
214     
215     /**
216      * @dev Its a modifier in which we authenticate the caller is owner or LCXToken Smart Contract
217      */ 
218     modifier onlyLCXTokenAndOwner() {
219         require(msg.sender==owner() || msg.sender == address(LCXToken));
220         _;
221     }
222     
223     /**
224      * @dev First we have to set token address before doing any thing 
225      * @param token LCX Smart contract Address
226      */
227      
228     function setTokenAddress(IERC20 token) public onlyOwner returns(bool){
229         LCXToken = token;
230         return true;
231     }
232     
233     /**
234      * @dev this will set the beneficiary with default vesting 
235      * parameters ie, every month for 3 years
236      * @param account address of the beneficiary for vesting
237      * @param amount  totalToken to be vested
238      */
239      
240      function setDefaultVesting(address account, uint256 amount) public onlyLCXTokenAndOwner returns(bool){
241          _setDefaultVesting(account, amount);
242          return true;
243      }
244      
245      /**
246       *@dev Internal function to set default vesting parameters
247       */
248       
249      function _setDefaultVesting(address account, uint256 amount)  internal {
250          require(account!=address(0));
251          VestedToken storage vested = vestedUser[account];
252          vested.cliff = _cliff;
253          vested.start = block.timestamp;
254          vested.duration = _duration;
255          vested.totalToken = amount;
256          vested.releasedToken = 0;
257          vested.revoked = _revoked;
258      }
259      
260      
261      /**
262      * @dev this will set the beneficiary with vesting 
263      * parameters provided
264      * @param account address of the beneficiary for vesting
265      * @param amount  totalToken to be vested
266      * @param cliff In seconds of one period in vesting
267      * @param duration In seconds of total vesting 
268      * @param startAt UNIX timestamp in seconds from where vesting will start
269      */
270      
271      function setVesting(address account, uint256 amount, uint256 cliff, uint256 duration, uint256 startAt ) public onlyLCXTokenAndOwner  returns(bool){
272          _setVesting(account, amount, cliff, duration, startAt);
273          return true;
274      }
275      
276      /**
277       * @dev Internal function to set default vesting parameters
278       * @param account address of the beneficiary for vesting
279       * @param amount  totalToken to be vested
280       * @param cliff In seconds of one period in vestin
281       * @param duration In seconds of total vesting duration
282       * @param startAt UNIX timestamp in seconds from where vesting will start
283       *
284       */
285      
286      function _setVesting(address account, uint256 amount, uint256 cliff, uint256 duration, uint256 startAt) internal {
287          
288          require(account!=address(0));
289          require(cliff<=duration);
290          VestedToken storage vested = vestedUser[account];
291          vested.cliff = cliff;
292          vested.start = startAt;
293          vested.duration = duration;
294          vested.totalToken = amount;
295          vested.releasedToken = 0;
296          vested.revoked = false;
297      }
298 
299     /**
300      * @notice Transfers vested tokens to beneficiary.
301      * anyone can release their token 
302      */
303      
304     function releaseMyToken() public returns(bool) {
305         releaseToken(msg.sender);
306         return true;
307     }
308     
309      /**
310      * @notice Transfers vested tokens to the given account.
311      * @param account address of the vested user
312      */
313     function releaseToken(address account) public {
314        require(account != address(0));
315        VestedToken storage vested = vestedUser[account];
316        uint256 unreleasedToken = _releasableAmount(account);  // total releasable token currently
317        require(unreleasedToken>0);
318        vested.releasedToken = vested.releasedToken.add(unreleasedToken);
319        LCXToken.safeTransfer(account,unreleasedToken);
320        emit TokenReleased(account, unreleasedToken);
321     }
322     
323     /**
324      * @dev Calculates the amount that has already vested but hasn't been released yet.
325      * @param account address of user
326      */
327     function _releasableAmount(address account) internal view returns (uint256) {
328         return _vestedAmount(account).sub(vestedUser[account].releasedToken);
329     }
330 
331   
332     /**
333      * @dev Calculates the amount that has already vested.
334      * @param account address of the user
335      */
336     function _vestedAmount(address account) internal view returns (uint256) {
337         VestedToken storage vested = vestedUser[account];
338         uint256 totalToken = vested.totalToken;
339         if(block.timestamp <  vested.start.add(vested.cliff)){
340             return 0;
341         }else if(block.timestamp >= vested.start.add(vested.duration) || vested.revoked){
342             return totalToken;
343         }else{
344             uint256 numberOfPeriods = (block.timestamp.sub(vested.start)).div(vested.cliff);
345             return totalToken.mul(numberOfPeriods.mul(vested.cliff)).div(vested.duration);
346         }
347     }
348     
349     /**
350      * @notice Allows the owner to revoke the vesting. Tokens already vested
351      * remain in the contract, the rest are returned to the owner.
352      * @param account address in which the vesting is revoked
353      */
354     function revoke(address account) public onlyOwner {
355         VestedToken storage vested = vestedUser[account];
356         require(!vested.revoked);
357         uint256 balance = vested.totalToken;
358         uint256 unreleased = _releasableAmount(account);
359         uint256 refund = balance.sub(unreleased);
360         vested.revoked = true;
361         vested.totalToken = unreleased;
362         LCXToken.safeTransfer(owner(), refund);
363         emit VestingRevoked(account);
364     }
365     
366     
367     
368     
369 }