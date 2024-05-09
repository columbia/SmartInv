1 pragma solidity 0.4.24;
2  
3 /**
4  * Copyright 2018, Flowchain.co
5  *
6  * The FlowchainCoin (FLC) token contract for vesting sale
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
127     /// @dev Mint an amount of tokens and transfer to the backer
128     /// @param to The address of the backer who will receive the tokens
129     /// @param amount The amount of rewarded tokens
130     /// @return The result of token transfer
131     function mintToken(address to, uint amount) external returns (bool success);  
132 
133     /// @param _owner The address from which the balance will be retrieved
134     /// @return The balance
135     function balanceOf(address _owner) public view returns (uint256 balance);
136 
137     /// @notice send `_value` token to `_to` from `msg.sender`
138     /// @param _to The address of the recipient
139     /// @param _value The amount of token to be transferred
140     /// @return Whether the transfer was successful or not
141     function transfer(address _to, uint256 _value) public returns (bool success);    
142 }
143 
144 /**
145  * @title Ownable
146  * @dev The Ownable contract has an owner address, and provides basic authorization control
147  * functions, this simplifies the implementation of "user permissions".
148  */
149 contract Ownable {
150     address private _owner;
151 
152     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
153 
154     /**
155      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
156      * account.
157      */
158     constructor () internal {
159         _owner = msg.sender;
160         emit OwnershipTransferred(address(0), _owner);
161     }
162 
163     /**
164      * @return the address of the owner.
165      */
166     function owner() public view returns (address) {
167         return _owner;
168     }
169 
170     /**
171      * @dev Throws if called by any account other than the owner.
172      */
173     modifier onlyOwner() {
174         require(isOwner());
175         _;
176     }
177 
178     /**
179      * @return true if `msg.sender` is the owner of the contract.
180      */
181     function isOwner() public view returns (bool) {
182         return msg.sender == _owner;
183     }
184 
185     /**
186      * @dev Allows the current owner to relinquish control of the contract.
187      * @notice Renouncing to ownership will leave the contract without an owner.
188      * It will not be possible to call the functions with the `onlyOwner`
189      * modifier anymore.
190      */
191     function renounceOwnership() public onlyOwner {
192         emit OwnershipTransferred(_owner, address(0));
193         _owner = address(0);
194     }
195 
196     /**
197      * @dev Allows the current owner to transfer control of the contract to a newOwner.
198      * @param newOwner The address to transfer ownership to.
199      */
200     function transferOwnership(address newOwner) public onlyOwner {
201         _transferOwnership(newOwner);
202     }
203 
204     /**
205      * @dev Transfers control of the contract to a newOwner.
206      * @param newOwner The address to transfer ownership to.
207      */
208     function _transferOwnership(address newOwner) internal {
209         require(newOwner != address(0));
210         emit OwnershipTransferred(_owner, newOwner);
211         _owner = newOwner;
212     }
213 }
214 
215 /**
216  * @title TokenVesting
217  * @dev A token holder contract that can release its token balance gradually like a
218  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
219  * owner.
220  */
221 contract Vesting is Ownable {
222     using SafeMath for uint256;
223 
224     Token public tokenReward;
225 
226     // beneficiary of tokens after they are released
227     address private _beneficiary;
228 
229     uint256 private _cliff;
230     uint256 private _start;
231     uint256 private _duration;
232 
233     address public _addressOfTokenUsedAsReward;
234     address public creator;
235 
236     mapping (address => uint256) private _released;
237 
238     /* Constrctor function */
239     function Vesting() payable {
240         creator = msg.sender;
241     }
242 
243     /**
244      * @dev Creates a vesting contract that vests its balance of FLC token to the
245      * beneficiary, gradually in a linear fashion until start + duration. By then all
246      * of the balance will have vested.
247      * @param beneficiary address of the beneficiary to whom vested tokens are transferred     
248      * @param cliffDuration duration in seconds of the cliff in which tokens will begin to vest
249      * @param start the time (as Unix time) at which point vesting starts
250      * @param duration duration in seconds of the period in which the tokens will vest
251      * @param addressOfTokenUsedAsReward where is the token contract
252      */
253     function createVestingPeriod(address beneficiary, uint256 start, uint256 cliffDuration, uint256 duration, address addressOfTokenUsedAsReward) public {
254         require(msg.sender == creator);
255         require(cliffDuration <= duration);
256         require(duration > 0);
257         require(start.add(duration) > block.timestamp);
258 
259         _beneficiary = beneficiary;
260         _duration = duration;
261         _cliff = start.add(cliffDuration);
262         _start = start;
263         _addressOfTokenUsedAsReward = addressOfTokenUsedAsReward;
264         tokenReward = Token(addressOfTokenUsedAsReward);
265     }
266 
267     /**
268      * @return the beneficiary of the tokens.
269      */
270     function beneficiary() public view returns (address) {
271         return _beneficiary;
272     }
273 
274     /**
275      * @return the cliff time of the token vesting.
276      */
277     function cliff() public view returns (uint256) {
278         return _cliff;
279     }
280 
281     /**
282      * @return the start time of the token vesting.
283      */
284     function start() public view returns (uint256) {
285         return _start;
286     }
287 
288     /**
289      * @return the duration of the token vesting.
290      */
291     function duration() public view returns (uint256) {
292         return _duration;
293     }
294 
295     /**
296      * @return the amount of the token released.
297      */
298     function released(address token) public view returns (uint256) {
299         return _released[token];
300     }
301 
302     /**
303      * @notice Mints and transfers tokens to beneficiary.
304      * @param token ERC20 token which is being vested
305      */
306     function release(address token) public {
307         require(msg.sender == creator);
308     
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