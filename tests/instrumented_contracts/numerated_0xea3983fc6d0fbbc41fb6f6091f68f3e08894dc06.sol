1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.0;
3 
4 contract Ownable {
5     address public owner;
6     address private _nextOwner;
7     
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9     
10     constructor() {
11         owner = msg.sender;
12         emit OwnershipTransferred(address(0), owner);
13     }
14     
15     modifier onlyOwner() {
16         require(msg.sender == owner, 'Only the owner of the contract can do that');
17         _;
18     }
19     
20     function transferOwnership(address nextOwner) public onlyOwner {
21         _nextOwner = nextOwner;
22     }
23     
24     function takeOwnership() public {
25         require(msg.sender == _nextOwner, 'Must be given ownership to do that');
26         emit OwnershipTransferred(owner, _nextOwner);
27         owner = _nextOwner;
28     }
29 }
30 
31 library SafeMath {
32     /**
33      * @dev Returns the addition of two unsigned integers, reverting on
34      * overflow.
35      *
36      * Counterpart to Solidity's `+` operator.
37      *
38      * Requirements:
39      * - Addition cannot overflow.
40      */
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44 
45         return c;
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      */
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b <= a, "SafeMath: subtraction overflow");
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         // Solidity only automatically asserts when dividing by 0
100         require(b != 0, "SafeMath: division by zero");
101         uint256 c = a / b;
102         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
109      * Reverts when dividing by zero.
110      *
111      * Counterpart to Solidity's `%` operator. This function uses a `revert`
112      * opcode (which leaves remaining gas untouched) while Solidity uses an
113      * invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      * - The divisor cannot be zero.
117      */
118     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b != 0, "SafeMath: modulo by zero");
120         return a % b;
121     }
122 }
123 
124 contract UnidoDistribution is Ownable {
125     using SafeMath for uint256;
126     
127     // 0 - SEED
128     // 1 - PRIVATE
129     // 2 - TEAM
130     // 3 - ADVISOR
131     // 4 - ECOSYSTEM
132     // 5 - LIQUIDITY
133     // 6 - RESERVE
134     enum POOL{SEED, PRIVATE, TEAM, ADVISOR, ECOSYSTEM, LIQUIDITY, RESERVE}
135     
136     mapping (POOL => uint) public pools;
137     
138     uint256 public totalSupply;
139     string public constant name = "Unido";
140     uint256 public constant decimals = 18;
141     string public constant symbol = "UDO";
142     address[] public participants;
143     
144     bool private isActive;
145     uint256 private scanLength = 150;
146     uint256 private continuePoint;
147     uint256[] private deletions;
148     
149     mapping (address => uint256) private balances;
150     mapping (address => mapping(address => uint256)) private allowances;
151     mapping (address => uint256) public lockoutPeriods;
152     mapping (address => uint256) public lockoutBalances;
153     mapping (address => uint256) public lockoutReleaseRates;
154     
155     event Active(bool isActive);
156     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
157     event Transfer(address indexed from, address indexed to, uint tokens);
158     event Burn(address indexed tokenOwner, uint tokens);
159     
160     constructor () {
161         pools[POOL.SEED] = 15000000 * 10**decimals;
162         pools[POOL.PRIVATE] = 16000000 * 10**decimals;
163         pools[POOL.TEAM] = 18400000 * 10**decimals;
164         pools[POOL.ADVISOR] = 10350000 * 10**decimals;
165         pools[POOL.ECOSYSTEM] = 14375000 * 10**decimals;
166         pools[POOL.LIQUIDITY] = 8625000 * 10**decimals;
167         pools[POOL.RESERVE] = 32250000 * 10**decimals;
168         
169         totalSupply = pools[POOL.SEED] + pools[POOL.PRIVATE] + pools[POOL.TEAM] + pools[POOL.ADVISOR] + pools[POOL.ECOSYSTEM] + pools[POOL.LIQUIDITY] + pools[POOL.RESERVE];
170 
171         // Give POLS private sale directly
172         uint pols = 2000000 * 10**decimals;
173         pools[POOL.PRIVATE] = pools[POOL.PRIVATE].sub(pols);
174         balances[address(0xeFF02cB28A05EebF76cB6aF993984731df8479b1)] = pols;
175         
176         // Give LIQUIDITY pool their half directly
177         uint liquid = pools[POOL.LIQUIDITY].div(2);
178         pools[POOL.LIQUIDITY] = pools[POOL.LIQUIDITY].sub(liquid);
179         balances[address(0xd6221a4f8880e9Aa355079F039a6012555556974)] = liquid;
180     }
181     
182     function _isTradeable() internal view returns (bool) {
183         return isActive;
184     }
185     
186     function isTradeable() public view returns (bool) {
187         return _isTradeable();
188     }
189     
190     function setTradeable() external onlyOwner {
191         require (!isActive, "Can only set tradeable when its not already tradeable");
192         isActive = true;
193         Active(true);
194     }
195     
196     function setScanLength(uint256 len) external onlyOwner {
197         require (len > 20, "Values 20 or less are impractical");
198         require (len <= 200, "Values greater than 200 may cause the updateRelease function to fail");
199         scanLength = len;
200     }
201     
202     function balanceOf(address tokenOwner) public view returns (uint) {
203         return balances[tokenOwner];
204     }
205     
206     function allowance(address tokenOwner, address spender) public view returns (uint) {
207         return allowances[tokenOwner][spender];
208     }
209     
210     function spendable(address tokenOwner) public view returns (uint) {
211         return balances[tokenOwner].sub(lockoutBalances[tokenOwner]);
212     }
213     
214     function transfer(address to, uint tokens) public returns (bool) {
215         require (_isTradeable(), "Contract is not tradeable yet");
216         require (balances[msg.sender].sub(lockoutBalances[msg.sender]) >= tokens, "Must have enough spendable tokens");
217         require (tokens > 0, "Must transfer non-zero amount");
218         require (to != address(0), "Cannot send to the 0 address");
219         
220         balances[msg.sender] = balances[msg.sender].sub(tokens);
221         balances[to] = balances[to].add(tokens);
222         Transfer(msg.sender, to, tokens);
223         return true;
224     }
225     
226     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
227         _approve(msg.sender, spender, allowances[msg.sender][spender].add(addedValue));
228         return true;
229     }
230     
231     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
232         _approve(msg.sender, spender, allowances[msg.sender][spender].sub(subtractedValue));
233         return true;
234     }
235     
236     function approve(address spender, uint tokens) public returns (bool) {
237         _approve(msg.sender, spender, tokens);
238         return true;
239     }
240     
241     function _approve(address owner, address spender, uint tokens) internal {
242         require (owner != address(0), "Cannot approve from the 0 address");
243         require (spender != address(0), "Cannot approve the 0 address");
244         
245         allowances[owner][spender] = tokens;
246         Approval(owner, spender, tokens);
247     }
248     
249     function burn(uint tokens) public {
250         require (balances[msg.sender].sub(lockoutBalances[msg.sender]) >= tokens, "Must have enough spendable tokens");
251         require (tokens > 0, "Must burn non-zero amount");
252         
253         balances[msg.sender] = balances[msg.sender].sub(tokens);
254         totalSupply = totalSupply.sub(tokens);
255         Burn(msg.sender, tokens);
256     }
257     
258     function transferFrom(address from, address to, uint tokens) public returns (bool) {
259         require (_isTradeable(), "Contract is not trading yet");
260         require (balances[from].sub(lockoutBalances[from]) >= tokens, "Must have enough spendable tokens");
261         require (allowances[from][msg.sender] >= tokens, "Must be approved to spend that much");
262         require (tokens > 0, "Must transfer non-zero amount");
263         require (from != address(0), "Cannot send from the 0 address");
264         require (to != address(0), "Cannot send to the 0 address");
265         
266         balances[from] = balances[from].sub(tokens);
267         balances[to] = balances[to].add(tokens);
268         allowances[from][msg.sender] = allowances[from][msg.sender].sub(tokens);
269         Transfer(from, to, tokens);
270         return true;
271     }
272     
273     function addParticipants(POOL pool, address[] calldata _participants, uint256[] calldata _stakes) external onlyOwner {
274         require (pool >= POOL.SEED && pool <= POOL.RESERVE, "Must select a valid pool");
275         require (_participants.length == _stakes.length, "Must have equal array sizes");
276         
277         uint lockoutPeriod;
278         uint lockoutReleaseRate;
279         
280         if (pool == POOL.SEED) {
281             lockoutPeriod = 1;
282             lockoutReleaseRate = 5;
283         } else if (pool == POOL.PRIVATE) {
284             lockoutReleaseRate = 4;
285         } else if (pool == POOL.TEAM) {
286             lockoutPeriod = 12;
287             lockoutReleaseRate = 12;
288         } else if (pool == POOL.ADVISOR) {
289             lockoutPeriod = 6;
290             lockoutReleaseRate = 6;
291         } else if (pool == POOL.ECOSYSTEM) {
292             lockoutPeriod = 3;
293             lockoutReleaseRate = 9;
294         } else if (pool == POOL.LIQUIDITY) {
295             lockoutReleaseRate = 1;
296             lockoutPeriod = 1;
297         } else if (pool == POOL.RESERVE) {
298             lockoutReleaseRate = 18;
299         }
300         
301         uint256 sum;
302         uint256 len = _participants.length;
303         for (uint256 i = 0; i < len; i++) {
304             address p = _participants[i];
305             require(lockoutBalances[p] == 0, "Participants can't be involved in multiple lock ups simultaneously");
306         
307             participants.push(p);
308             lockoutBalances[p] = _stakes[i];
309             balances[p] = balances[p].add(_stakes[i]);
310             lockoutPeriods[p] = lockoutPeriod;
311             lockoutReleaseRates[p] = lockoutReleaseRate;
312             sum = sum.add(_stakes[i]);
313         }
314         
315         require(sum <= pools[pool], "Insufficient amount left in pool for this");
316         pools[pool] = pools[pool].sub(sum);
317     }
318     
319     function finalizeParticipants(POOL pool) external onlyOwner {
320         uint leftover = pools[pool];
321         pools[pool] = 0;
322         totalSupply = totalSupply.sub(leftover);
323     }
324     
325     /**
326      * For each account with an active lockout, if their lockout has expired 
327      * then release their lockout at the lockout release rate
328      * If the lockout release rate is 0, assume its all released at the date
329      * Only do max 100 at a time, call repeatedly which it returns true
330      */
331     function updateRelease() external onlyOwner returns (bool) {
332         uint scan = scanLength;
333         uint len = participants.length;
334         uint continueAddScan = continuePoint.add(scan);
335         for (uint i = continuePoint; i < len && i < continueAddScan; i++) {
336             address p = participants[i];
337             if (lockoutPeriods[p] > 0) {
338                 lockoutPeriods[p]--;
339             } else if (lockoutReleaseRates[p] > 0) {
340                 uint rate = lockoutReleaseRates[p];
341                 
342                 uint release;
343                 if (rate == 18) {
344                     // First release of reserve is 12.5%
345                     release = lockoutBalances[p].div(8);
346                 } else {
347                     release = lockoutBalances[p].div(lockoutReleaseRates[p]);
348                 }
349                 
350                 lockoutBalances[p] = lockoutBalances[p].sub(release);
351                 lockoutReleaseRates[p]--;
352             } else {
353                 deletions.push(i);
354             }
355         }
356         continuePoint = continuePoint.add(scan);
357         if (continuePoint >= len) {
358             continuePoint = 0;
359             while (deletions.length > 0) {
360                 uint index = deletions[deletions.length-1];
361                 deletions.pop();
362 
363                 participants[index] = participants[participants.length - 1];
364                 participants.pop();
365             }
366             return false;
367         }
368         
369         return true;
370     }
371 }