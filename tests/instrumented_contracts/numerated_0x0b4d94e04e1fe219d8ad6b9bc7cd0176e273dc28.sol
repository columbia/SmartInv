1 pragma solidity 0.4.24;
2  
3 /**
4  * Copyright 2018, Flowchain.co
5  *
6  * The dapp of team vesting. The lock period is one year.
7  */
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that revert on error
12  */
13 library SafeMath {
14     int256 constant private INT256_MIN = -2**255;
15 
16     /**
17     * @dev Multiplies two unsigned integers, reverts on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
21         // benefit is lost if 'b' is also tested.
22         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b);
29 
30         return c;
31     }
32 
33     /**
34     * @dev Multiplies two signed integers, reverts on overflow.
35     */
36     function mul(int256 a, int256 b) internal pure returns (int256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
45 
46         int256 c = a * b;
47         require(c / a == b);
48 
49         return c;
50     }
51 
52     /**
53     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
54     */
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // Solidity only automatically asserts when dividing by 0
57         require(b > 0);
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60 
61         return c;
62     }
63 
64     /**
65     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
66     */
67     function div(int256 a, int256 b) internal pure returns (int256) {
68         require(b != 0); // Solidity only automatically asserts when dividing by 0
69         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
70 
71         int256 c = a / b;
72 
73         return c;
74     }
75 
76     /**
77     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
78     */
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b <= a);
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     /**
87     * @dev Subtracts two signed integers, reverts on overflow.
88     */
89     function sub(int256 a, int256 b) internal pure returns (int256) {
90         int256 c = a - b;
91         require((b >= 0 && c <= a) || (b < 0 && c > a));
92 
93         return c;
94     }
95 
96     /**
97     * @dev Adds two unsigned integers, reverts on overflow.
98     */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a);
102 
103         return c;
104     }
105 
106     /**
107     * @dev Adds two signed integers, reverts on overflow.
108     */
109     function add(int256 a, int256 b) internal pure returns (int256) {
110         int256 c = a + b;
111         require((b >= 0 && c >= a) || (b < 0 && c < a));
112 
113         return c;
114     }
115 
116     /**
117     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
118     * reverts when dividing by zero.
119     */
120     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b != 0);
122         return a % b;
123     }
124 }
125 
126 interface Token {
127     /// @param _owner The address from which the balance will be retrieved
128     /// @return The balance
129     function balanceOf(address _owner) public view returns (uint256 balance);
130 
131     /// @notice send `_value` token to `_to` from `msg.sender`
132     /// @param _to The address of the recipient
133     /// @param _value The amount of token to be transferred
134     /// @return Whether the transfer was successful or not
135     function transfer(address _to, uint256 _value) public returns (bool success);    
136 }
137 
138 /**
139  * @title Ownable
140  * @dev The Ownable contract has an owner address, and provides basic authorization control
141  * functions, this simplifies the implementation of "user permissions".
142  */
143 contract Ownable {
144     address private _owner;
145 
146     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
147 
148     /**
149      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
150      * account.
151      */
152     constructor () internal {
153         _owner = msg.sender;
154         emit OwnershipTransferred(address(0), _owner);
155     }
156 
157     /**
158      * @return the address of the owner.
159      */
160     function owner() public view returns (address) {
161         return _owner;
162     }
163 
164     /**
165      * @dev Throws if called by any account other than the owner.
166      */
167     modifier onlyOwner() {
168         require(isOwner());
169         _;
170     }
171 
172     /**
173      * @return true if `msg.sender` is the owner of the contract.
174      */
175     function isOwner() public view returns (bool) {
176         return msg.sender == _owner;
177     }
178 
179     /**
180      * @dev Allows the current owner to relinquish control of the contract.
181      * @notice Renouncing to ownership will leave the contract without an owner.
182      * It will not be possible to call the functions with the `onlyOwner`
183      * modifier anymore.
184      */
185     function renounceOwnership() public onlyOwner {
186         emit OwnershipTransferred(_owner, address(0));
187         _owner = address(0);
188     }
189 
190     /**
191      * @dev Allows the current owner to transfer control of the contract to a newOwner.
192      * @param newOwner The address to transfer ownership to.
193      */
194     function transferOwnership(address newOwner) public onlyOwner {
195         _transferOwnership(newOwner);
196     }
197 
198     /**
199      * @dev Transfers control of the contract to a newOwner.
200      * @param newOwner The address to transfer ownership to.
201      */
202     function _transferOwnership(address newOwner) internal {
203         require(newOwner != address(0));
204         emit OwnershipTransferred(_owner, newOwner);
205         _owner = newOwner;
206     }
207 }
208 
209 /**
210  * @title TokenVesting
211  * @dev A token holder contract that can release its token balance gradually like a
212  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
213  * owner.
214  */
215 contract Vesting is Ownable {
216     using SafeMath for uint256;
217 
218     Token public tokenReward;
219 
220     // beneficiary of tokens after they are released
221     address private _beneficiary;
222 
223     uint256 private _cliff;
224     uint256 private _start;
225     uint256 private _duration;
226 
227     address public _addressOfTokenUsedAsReward;
228     address public creator;
229 
230     mapping (address => uint256) private _released;
231 
232     uint256 constant public   VESTING_DURATION    =  31536000; // 1 Year in second
233 
234     /* Constrctor function */
235     function Vesting() payable {
236         creator = msg.sender;
237         createVestingPeriod(
238             0xA2690D72D6c932AE7Aa1cC0dE48aEaBBDCaf2799,
239             block.timestamp,
240             0,
241             VESTING_DURATION,
242             0x5b53f9755f82439cba66007ec7073c59e0da4a7d
243         );
244     }
245 
246     /**
247      * @dev Creates a vesting contract that vests its balance of FLC token to the
248      * beneficiary, gradually in a linear fashion until start + duration. By then all
249      * of the balance will have vested.
250      * @param beneficiary address of the beneficiary to whom vested tokens are transferred     
251      * @param cliffDuration duration in seconds of the cliff in which tokens will begin to vest
252      * @param start the time (as Unix time) at which point vesting starts
253      * @param duration duration in seconds of the period in which the tokens will vest
254      * @param addressOfTokenUsedAsReward where is the token contract
255      */
256     function createVestingPeriod(address beneficiary, uint256 start, uint256 cliffDuration, uint256 duration, address addressOfTokenUsedAsReward) public onlyOwner {
257         require(cliffDuration <= duration);
258         require(duration > 0);
259         require(start.add(duration) > block.timestamp);
260 
261         _beneficiary = beneficiary;
262         _duration = duration;
263         _cliff = start.add(cliffDuration);
264         _start = start;
265         _addressOfTokenUsedAsReward = addressOfTokenUsedAsReward;
266         tokenReward = Token(addressOfTokenUsedAsReward);
267     }
268 
269     /**
270      * @return the beneficiary of the tokens.
271      */
272     function beneficiary() public view returns (address) {
273         return _beneficiary;
274     }
275 
276     /**
277      * @return the cliff time of the token vesting.
278      */
279     function cliff() public view returns (uint256) {
280         return _cliff;
281     }
282 
283     /**
284      * @return the start time of the token vesting.
285      */
286     function start() public view returns (uint256) {
287         return _start;
288     }
289 
290     /**
291      * @return the duration of the token vesting.
292      */
293     function duration() public view returns (uint256) {
294         return _duration;
295     }
296 
297     /**
298      * @return the amount of the token released.
299      */
300     function released(address token) public view returns (uint256) {
301         return _released[token];
302     }
303 
304     /**
305      * @notice Mints and transfers tokens to beneficiary.
306      * @param token ERC20 token which is being vested
307      */
308     function release(address token) public onlyOwner {    
309         uint256 unreleased = _releasableAmount(token);
310 
311         require(unreleased > 0);
312 
313         _released[token] = _released[token].add(unreleased);
314 
315         tokenReward.transfer(_beneficiary, unreleased);
316     }
317 
318     /**
319      * @dev Calculates the amount that has already vested but hasn't been released yet.
320      * @param token ERC20 token which is being vested
321      */
322     function _releasableAmount(address token) private view returns (uint256) {
323         return _vestedAmount(token).sub(_released[token]);
324     }
325 
326     /**
327      * @dev Calculates the amount that has already vested.
328      * @param token ERC20 token which is being vested
329      */
330     function _vestedAmount(address token) private view returns (uint256) {
331         uint256 currentBalance = tokenReward.balanceOf(address(this));
332         uint256 totalBalance = currentBalance.add(_released[token]);
333 
334         if (block.timestamp < _cliff) {
335             return 0;
336         } else if (block.timestamp >= _start.add(_duration)) {
337             return totalBalance;
338         } else {
339             return totalBalance.mul(block.timestamp.sub(_start)).div(_duration);
340         }
341     }
342 }