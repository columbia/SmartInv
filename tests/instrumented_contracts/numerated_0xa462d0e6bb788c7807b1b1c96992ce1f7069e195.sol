1 pragma solidity 0.7.0;
2 
3 // SafeMath library provided by the OpenZeppelin Group on Github
4 // SPDX-License-Identifier: MIT
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on
22      * overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      *
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      *
59      * - Subtraction cannot overflow.
60      */
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `*` operator.
73      *
74      * Requirements:
75      *
76      * - Multiplication cannot overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      *
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      *
118      * - The divisor cannot be zero.
119      */
120     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return mod(a, b, "SafeMath: modulo by zero");
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * Reverts with custom message when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b != 0, errorMessage);
158         return a % b;
159     }
160 }
161 
162 /* ERC20 Standards followed by OpenZeppelin Group libraries on Github */
163 
164 interface IERC20 {
165     
166     function totalSupply() external view returns (uint256);
167     
168     function balanceOf(address who) external view returns (uint256);
169     
170     function allowance(address owner, address spender) external view returns (uint256);
171     
172     function transfer(address to, uint256 value) external returns (bool);
173     
174     function approve(address spender, uint256 value) external returns (bool);
175     
176     function transferFrom(address from, address to, uint256 value) external returns (bool);
177     
178     event Transfer(address indexed from, address indexed to, uint256 value);
179     
180     event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 /* Staking process is followed according to the ERC900: Simple Staking Interface #900 issue on Github */
184 
185 interface Staking {
186     
187     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
188     
189     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
190 
191     function stake(uint256 amount, bytes memory data) external returns (bool);
192     
193     function unstake(uint256 amount, bytes memory data) external returns (bool);
194     
195     function totalStakedFor(address addr) external view returns (uint256);
196     
197     function totalStaked() external view returns (uint256);
198     
199     function supportsHistory() external pure returns (bool);
200 
201 }
202 
203 /*EQUUS Protocol being created with the help of the above interfaces for compatibility*/
204 
205 contract EQUUSMiningToken is IERC20, Staking {
206     
207     /* Constant variables created for the ERC20 requirements*/
208     
209     string public constant name = "EQUUSMiningToken";
210     string public constant symbol = "EQMT";
211     uint8 public constant decimals = 18;
212     
213     //Burn address saved as constant for future burning processes
214     address public constant burnaddress = 0x0000000000000000000000000000000000000000;
215 
216     mapping(address => uint256) balances; //EQUUS balance for all network participants
217     
218     mapping(address => uint256) stakedbalances; //EQUUS stake balance to lock stakes
219     
220     mapping(address => uint) staketimestamps; //EQUUS stake timestamp to record updates on staking for multipliers, this involves the idea that multipliers will reset upon staking
221 
222     mapping(address => mapping (address => uint256)) allowed; //Approval array to record delegation of thrid-party accounts to handle transaction per allowance
223     
224     /* Total variables created to record information */
225     uint256 totalSupply_;
226     uint256 totalstaked = 0;
227     address theowner; //Owner address saved to recognise on future processes
228     
229     using SafeMath for uint256; //Important*** as this library provides security to handle maths without overflow attacks
230     
231     constructor() public {
232         totalSupply_ = 100000000000000000000000000;
233         balances[msg.sender] = totalSupply_;
234         theowner = msg.sender;
235         emit Transfer(msg.sender, msg.sender, totalSupply_);
236    } //Constructor stating the total supply as well as saving owner address and sending supply to owner address
237    
238    //Function to report on totalsupply following ERC20 Standard
239    function totalSupply() public override view returns (uint256) {
240        return totalSupply_;
241    }
242    
243    //Function to report on account balance following ERC20 Standard
244    function balanceOf(address tokenOwner) public override view returns (uint) {
245        return balances[tokenOwner];
246    }
247    
248    //Burn process is just a funtion to calculate burn amount depending on an amount of Tokens
249    function cutForBurn(uint256 a) public pure returns (uint256) {
250        uint256 c = a.div(20);
251        return c;
252    }
253    
254    //Straight forward transfer following ERC20 Standard
255    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
256        require(numTokens <= balances[msg.sender], 'Amount exceeds balance.');
257        balances[msg.sender] = balances[msg.sender].sub(numTokens);
258        
259        balances[receiver] = balances[receiver].add(numTokens);
260        emit Transfer(msg.sender, receiver, numTokens);
261        return true;
262    }
263    
264    //Approve function following ERC20 Standard
265    function approve(address delegate, uint256 numTokens) public override returns (bool) {
266        require(numTokens <= balances[msg.sender], 'Amount exceeds balance.');
267        allowed[msg.sender][delegate] = numTokens;
268        emit Approval(msg.sender, delegate, numTokens);
269        return true;
270    }
271    
272    //Allowance function to verify allowance allowed on delegate address following ERC20 Standard
273    function allowance(address owner, address delegate) public override view returns (uint) {
274        return allowed[owner][delegate];
275    }
276    
277    //The following function is added to mitigate ERC20 API: An Attack Vector on Approve/TransferFrom Methods
278    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
279        require(addedValue <= balances[msg.sender].sub(allowed[msg.sender][spender]), 'Amount exceeds balance.');
280        
281        allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
282        
283        emit Approval(msg.sender, spender, allowed[msg.sender][spender].add(addedValue));
284        return true;
285    }
286    
287    //The following function is added to mitigate ERC20 API: An Attack Vector on Approve/TransferFrom Methods
288    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
289        require(subtractedValue <= allowed[msg.sender][spender], 'Amount exceeds balance.');
290        
291        allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
292        
293        emit Approval(msg.sender, spender, allowed[msg.sender][spender].sub(subtractedValue));
294    }
295    
296    //Transfer For function for allowed accounts to allow tranfers
297    function transferFrom(address owner, address buyer, uint numTokens) public override returns (bool) {
298        require(numTokens <= balances[owner], 'Amount exceeds balance.');
299        require(numTokens <= allowed[owner][msg.sender], 'Amount exceeds allowance.');
300        
301        balances[owner] = balances[owner].sub(numTokens);
302        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
303        balances[buyer] = balances[buyer].add(numTokens);
304        emit Transfer(msg.sender, buyer, numTokens);
305        return true;
306    }
307    
308    //Staking processes
309    
310    //Stake process created updating balances, stakebalances and also recording time on process run, the process will burn 5% of the amount
311    function stake(uint256 amount, bytes memory data) public override returns (bool) {
312        require(amount <= balances[msg.sender]);
313        require(amount < 20, "Amount to low to process");
314        balances[msg.sender] = balances[msg.sender].sub(amount);
315        
316        uint256 burned = cutForBurn(amount);
317        
318        totalSupply_ = totalSupply_.sub(burned);
319        
320        balances[burnaddress] = balances[burnaddress].add(burned);
321        
322        stakedbalances[msg.sender] = stakedbalances[msg.sender].add(amount.sub(burned));
323        totalstaked = totalstaked.add(amount.sub(burned));
324        
325        staketimestamps[msg.sender] = block.timestamp;
326        
327        emit Staked(msg.sender, amount.sub(burned), stakedbalances[msg.sender], data);
328        emit Transfer(msg.sender, msg.sender, amount.sub(burned));
329        emit Transfer(msg.sender, burnaddress, burned);
330        return true;
331    }
332    
333    //This function unstakes locked in amount and burns 5%, this also updates amounts on total supply
334    function unstake(uint256 amount, bytes memory data) public override returns (bool) {
335        require(amount <= stakedbalances[msg.sender]);
336        require(amount <= totalstaked);
337        require(amount < 20, "Amount to low to process");
338        stakedbalances[msg.sender] = stakedbalances[msg.sender].sub(amount);
339        totalstaked = totalstaked.sub(amount);
340        
341        uint256 burned = cutForBurn(amount);
342        
343        totalSupply_ = totalSupply_.sub(burned);
344        
345        balances[burnaddress] = balances[burnaddress].add(burned);
346        
347        balances[msg.sender] = balances[msg.sender].add(amount.sub(burned));
348        
349        emit Unstaked(msg.sender, amount.sub(burned), stakedbalances[msg.sender], data);
350        emit Transfer(msg.sender, msg.sender, amount.sub(burned));
351        emit Transfer(msg.sender, burnaddress, burned);
352        return true;
353    }
354    
355    //Function to return total staked on a single address
356    function totalStakedFor(address addr) public override view returns (uint256) {
357        return stakedbalances[addr];
358    }
359    
360    //Function to shows timestamp on stake processes
361    function stakeTimestampFor(address addr) public view returns (uint256) {
362        return staketimestamps[addr];
363    }
364    
365    //Function to find out time passed since last timestamp on address
366    function stakeTimeFor(address addr) public view returns (uint256) {
367        return block.timestamp.sub(staketimestamps[addr]);
368    }
369    
370    //Total staked on all addresses
371    function totalStaked() public override view returns (uint256) {
372        return totalstaked;
373    }
374    
375    //Support History variable to show support on optional stake details
376    function supportsHistory() public override pure returns (bool) {
377        return false;
378    }
379    
380 }