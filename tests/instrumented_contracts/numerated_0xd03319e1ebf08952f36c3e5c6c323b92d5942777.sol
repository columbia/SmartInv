1 pragma solidity ^0.6.0;
2 
3 library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, reverting on
6      * overflow.
7      *
8      * Counterpart to Solidity's `+` operator.
9      *
10      * Requirements:
11      *
12      * - Addition cannot overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21     /**
22      * @dev Returns the subtraction of two unsigned integers, reverting on
23      * overflow (when the result is negative).
24      *
25      * Counterpart to Solidity's `-` operator.
26      *
27      * Requirements:
28      *
29      * - Subtraction cannot overflow.
30      */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the multiplication of two unsigned integers, reverting on
54      * overflow.
55      *
56      * Counterpart to Solidity's `*` operator.
57      *
58      * Requirements:
59      *
60      * - Multiplication cannot overflow.
61      */
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64         // benefit is lost if 'b' is also tested.
65         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the integer division of two unsigned integers. Reverts on
78      * division by zero. The result is rounded towards zero.
79      *
80      * Counterpart to Solidity's `/` operator. Note: this function uses a
81      * `revert` opcode (which leaves remaining gas untouched) while Solidity
82      * uses an invalid opcode to revert (consuming all remaining gas).
83      *
84      * Requirements:
85      *
86      * - The divisor cannot be zero.
87      */
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return div(a, b, "SafeMath: division by zero");
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
104     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     
113     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
114         return mod(a, b, "SafeMath: modulo by zero");
115     }
116 
117    
118     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b != 0, errorMessage);
120         return a % b;
121     }
122     
123     function ceil(uint a, uint m) internal pure returns (uint r) {
124         return (a + m - 1) / m * m;
125     }
126 }
127 
128 // ----------------------------------------------------------------------------
129 // Owned contract
130 // ----------------------------------------------------------------------------
131 contract Owned {
132     address payable public owner;
133 
134     event OwnershipTransferred(address indexed _from, address indexed _to);
135 
136     constructor() public {
137         owner = msg.sender;
138     }
139 
140     modifier onlyOwner {
141         require(msg.sender == owner);
142         _;
143     }
144 
145     function transferOwnership(address payable _newOwner) public onlyOwner {
146         owner = _newOwner;
147         emit OwnershipTransferred(msg.sender, _newOwner);
148     }
149 }
150 
151 // ----------------------------------------------------------------------------
152 // ERC Token Standard #20 Interface
153 // ----------------------------------------------------------------------------
154 interface IERC20 {
155     function totalSupply() external view returns (uint256);
156     function balanceOf(address tokenOwner) external view returns (uint256 balance);
157     function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
158     function transfer(address to, uint256 tokens) external returns (bool success);
159     function approve(address spender, uint256 tokens) external returns (bool success);
160     function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
161     function burnTokens(uint256 _amount) external;
162     event Transfer(address indexed from, address indexed to, uint256 tokens);
163     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
164 }
165 
166 // ----------------------------------------------------------------------------
167 // ERC20 Token, with the addition of symbol, name and decimals and assisted
168 // token transfers
169 // ----------------------------------------------------------------------------
170 contract DrawStake is Owned {
171     using SafeMath for uint256;
172     
173     address public YFFS = 0x90D702f071d2af33032943137AD0aB4280705817;
174     
175     uint256 public totalStakes = 0;
176     uint256 stakingFee = 0; 
177     uint256 unstakingFee = 0; 
178     uint256 public totalDividends = 0;
179     uint256 private scaledRemainder = 0;
180     uint256 private scaling = uint256(10) ** 12;
181     uint public round = 1;
182     
183     struct USER{
184         uint256 stakedTokens;
185         uint256 lastDividends;
186         uint256 fromTotalDividend;
187         uint round;
188         uint256 remainder;
189     }
190     
191     mapping(address => USER) stakers;
192     mapping (uint => uint256) public payouts;                   // keeps record of each payout
193     
194     event staked(address staker, uint256 tokens, uint256 stakingFee);
195     event unStaked(address staker, uint256 tokens, uint256 unstakingFee);
196     event PAYOUT(uint256 round, uint256 tokens, address sender);
197     event gotReward(address staker, uint256 reward);
198     
199     // ------------------------------------------------------------------------
200     // Token holders can stake their tokens using this function
201     // @param tokens number of tokens to stake
202     // ------------------------------------------------------------------------
203     function stake(uint256 tokens) external {
204         require(IERC20(YFFS).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from user account");
205         
206         uint256 _stakingFee = 0;
207         if(totalStakes > 0)
208             _stakingFee= (onePercent(tokens).mul(stakingFee)).div(10); 
209         
210         if(totalStakes > 0)
211             // distribute the staking fee accumulated before updating the user's stake
212             _addPayout(_stakingFee);
213             
214         // add pending rewards to remainder to be claimed by user later, if there is any existing stake
215         uint256 owing = pendingReward(msg.sender);
216         stakers[msg.sender].remainder += owing;
217         
218         stakers[msg.sender].stakedTokens = (tokens.sub(_stakingFee)).add(stakers[msg.sender].stakedTokens);
219         stakers[msg.sender].lastDividends = owing;
220         stakers[msg.sender].fromTotalDividend= totalDividends;
221         stakers[msg.sender].round =  round;
222         
223         totalStakes = totalStakes.add(tokens.sub(_stakingFee));
224         
225         emit staked(msg.sender, tokens.sub(_stakingFee), _stakingFee);
226     }
227     
228     // ------------------------------------------------------------------------
229     // Owners can send the funds to be distributed to stakers using this function
230     // @param tokens number of tokens to distribute
231     // ------------------------------------------------------------------------
232     function drawToken(uint256 tokens) external {
233         require(IERC20(YFFS).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from funder account");
234         _addPayout(tokens);
235     }
236     
237     // ------------------------------------------------------------------------
238     // Private function to register payouts
239     // ------------------------------------------------------------------------
240     function _addPayout(uint256 tokens) private{
241         // divide the funds among the currently staked tokens
242         // scale the deposit and add the previous remainder
243         uint256 available = (tokens.mul(scaling)).add(scaledRemainder); 
244         uint256 dividendPerToken = available.div(totalStakes);
245         scaledRemainder = available.mod(totalStakes);
246         
247         totalDividends = totalDividends.add(dividendPerToken);
248         payouts[round] = payouts[round-1].add(dividendPerToken);
249         
250         emit PAYOUT(round, tokens, msg.sender);
251         round++;
252     }
253     
254     // ------------------------------------------------------------------------
255     // Stakers can claim their pending rewards using this function
256     // ------------------------------------------------------------------------
257     function getReward() public {
258         if(totalDividends > stakers[msg.sender].fromTotalDividend){
259             uint256 owing = pendingReward(msg.sender);
260         
261             owing = owing.add(stakers[msg.sender].remainder);
262             stakers[msg.sender].remainder = 0;
263         
264             require(IERC20(YFFS).transfer(msg.sender,owing), "ERROR: error in sending reward from contract");
265         
266             emit gotReward(msg.sender, owing);
267         
268             stakers[msg.sender].lastDividends = owing; // unscaled
269             stakers[msg.sender].round = round; // update the round
270             stakers[msg.sender].fromTotalDividend = totalDividends; // scaled
271         }
272     }
273     
274     // ------------------------------------------------------------------------
275     // Get the pending rewards of the staker
276     // @param _staker the address of the staker
277     // ------------------------------------------------------------------------    
278     function pendingReward(address staker) private returns (uint256) {
279         uint256 amount =  ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)).div(scaling);
280         stakers[staker].remainder += ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)) % scaling ;
281         return amount;
282     }
283     
284     function getPendingReward(address staker) public view returns(uint256 _pendingReward) {
285         uint256 amount =  ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)).div(scaling);
286         amount += ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)) % scaling ;
287         return (amount + stakers[staker].remainder);
288     }
289     
290     // ------------------------------------------------------------------------
291     // Stakers can un stake the staked tokens using this function
292     // @param tokens the number of tokens to withdraw
293     // ------------------------------------------------------------------------
294     function withdraw(uint256 tokens) external {
295         
296         require(stakers[msg.sender].stakedTokens >= tokens && tokens > 0, "Invalid token amount to withdraw");
297         
298         uint256 _unstakingFee = (onePercent(tokens).mul(unstakingFee)).div(10);
299         
300         // add pending rewards to remainder to be claimed by user later, if there is any existing stake
301         uint256 owing = pendingReward(msg.sender);
302         stakers[msg.sender].remainder += owing;
303                 
304         require(IERC20(YFFS).transfer(msg.sender, tokens.sub(_unstakingFee)), "Error in un-staking tokens");
305         
306         stakers[msg.sender].stakedTokens = stakers[msg.sender].stakedTokens.sub(tokens);
307         stakers[msg.sender].lastDividends = owing;
308         stakers[msg.sender].fromTotalDividend= totalDividends;
309         stakers[msg.sender].round =  round;
310         
311         totalStakes = totalStakes.sub(tokens);
312         
313         if(totalStakes > 0)
314             // distribute the un staking fee accumulated after updating the user's stake
315             _addPayout(_unstakingFee);
316         
317         emit unStaked(msg.sender, tokens.sub(_unstakingFee), _unstakingFee);
318     }
319     
320     // ------------------------------------------------------------------------
321     // Private function to calculate 1% percentage
322     // ------------------------------------------------------------------------
323     function onePercent(uint256 _tokens) private pure returns (uint256){
324         uint256 roundValue = _tokens.ceil(100);
325         uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
326         return onePercentofTokens;
327     }
328     
329     // ------------------------------------------------------------------------
330     // Get the number of tokens staked by a staker
331     // @param _staker the address of the staker
332     // ------------------------------------------------------------------------
333     function yourStakedYFFS(address staker) external view returns(uint256 stakedYFFS){
334         return stakers[staker].stakedTokens;
335     }
336     
337     // ------------------------------------------------------------------------
338     // Get the YFFS balance of the token holder
339     // @param user the address of the token holder
340     // ------------------------------------------------------------------------
341     function yourYFFSBalance(address user) external view returns(uint256 YFFSBalance){
342         return IERC20(YFFS).balanceOf(user);
343     }
344 }