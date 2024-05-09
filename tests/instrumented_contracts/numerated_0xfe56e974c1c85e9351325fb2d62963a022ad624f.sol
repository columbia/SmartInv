1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-17
3 */
4 
5 pragma solidity ^0.5.0;
6 
7  /**
8  * @title SafeMath
9  * @dev   Unsigned math operations with safety checks that revert on error
10  */
11 library SafeMath {
12     /**
13     * @dev Multiplies two unsigned integers, reverts on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256){
16         if (a == 0) {
17             return 0;
18         }
19         uint256 c = a * b;
20         require(c / a == b,"Calculation error");
21         return c;
22     }
23     
24     /**
25     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256){
28         // Solidity only automatically asserts when dividing by 0
29         require(b > 0,"Calculation error");
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33     }
34 
35     /**
36     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256){
39         require(b <= a,"Calculation error");
40         uint256 c = a - b;
41         return c;
42     }
43 
44     /**
45     * @dev Adds two unsigned integers, reverts on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256){
48         uint256 c = a + b;
49         require(c >= a,"Calculation error");
50         return c;
51     }
52 
53     /**
54     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55     * reverts when dividing by zero.
56     */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256){
58         require(b != 0,"Calculation error");
59         return a % b;
60     }
61 }
62 
63  /**
64  * @title ERC20 interface
65  * @dev see https://eips.ethereum.org/EIPS/eip-20
66  */
67 interface IERC20 {
68   function totalSupply() external view returns (uint256);
69   function balanceOf(address account) external view returns (uint256);
70   function transfer(address recipient, uint256 amount) external returns (bool);
71   function allowance(address owner, address spender) external view returns (uint256);
72   function approve(address spender, uint256 amount) external returns (bool);
73   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 contract Owned {
79     address public owner;
80 
81     event OwnershipTransferred(address indexed _from, address indexed _to);
82 
83     modifier onlyOwner {
84         require(msg.sender == owner);
85         _;
86     }
87 
88     function transferOwnership(address _newOwner) public onlyOwner {
89         require(_newOwner != address(0), "Ownable: new owner is the zero address");
90         emit OwnershipTransferred(owner, _newOwner);
91         owner = _newOwner;
92     }
93 }
94 
95 contract ApproveAndCallFallBack {
96     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
97 }
98 
99  /**
100  * @title Layerx Contract For ERC20 Tokens
101  * @dev LAYERX tokens as per ERC20 Standards
102  */
103 contract Layerx is IERC20, Owned {
104     using SafeMath for uint256;
105     
106     string public symbol;
107     string public  name;
108     uint8 public decimals;
109     uint _totalSupply;
110     uint public totalEthRewards = 0;
111     uint stakeNum = 0;
112     uint amtByDay = 27397260274000000000;
113     uint public stakePeriod = 30 days;
114     address public stakeCreator; 
115     bool isPaused = false;
116     
117     struct Stake {
118         uint start;
119         uint end;
120         uint layerLockedTotal;
121         uint layerxReward;
122         uint ethReward;
123     }
124     
125     struct StakeHolder {
126         uint layerLocked;
127         uint firstStake;
128         uint time;
129     }
130     
131     struct Rewards {
132         uint layerLocked;
133         uint layersx;
134         uint eth;
135         bool isReceived;
136     }    
137     
138     event logLockedTokens(address holder, uint amountLocked, uint timeLocked, uint stakeId);
139     event logUnlockedTokens(address holder, uint amountUnlocked, uint timeUnlocked);
140     event logWithdraw(address holder, uint layerx, uint eth, uint stakeId, uint time);
141     event logCloseStake(uint id, uint amount, uint timeClosed);
142     
143     modifier paused {
144         require(isPaused == false, "This contract was paused by the owner!");
145         _;
146     }
147     
148     modifier exist (uint index) {
149         require(index <= stakeNum, 'This stake does not exist.');
150         _;        
151     }
152     
153     mapping (address => StakeHolder) public stakeHolders;
154     mapping (uint => Stake) public stakes;
155     mapping (address => mapping (uint => Rewards)) public rewards;
156     mapping (address => uint) balances;
157     mapping (address => mapping(address => uint)) allowed;   
158     mapping (address => bool) private swap;
159     
160     IERC20 UNILAYER = IERC20(0x0fF6ffcFDa92c53F615a4A75D982f399C989366b);
161 
162     constructor(address _owner) public {
163         owner = _owner;
164         stakeCreator = owner;
165         symbol = "LAYERX";
166         name = "UNILAYERX";
167         decimals = 18;
168         _totalSupply = 40000 * 10**uint(decimals);
169         balances[owner] = _totalSupply;
170         emit Transfer(address(0), owner, _totalSupply);
171         stakes[0] = Stake(now, 0, 0, 0, 0);
172     }
173     
174     /**
175      * @dev Total number of tokens in existence.
176      */
177     function totalSupply() public view returns (uint) {
178         return _totalSupply.sub(balances[address(0)]);
179     }
180 
181     /**
182      * @dev Gets the balance of the specified address.
183      * @param tokenOwner The address to query the balance of.
184      * @return A uint256 representing the amount owned by the passed address.
185      */
186     function balanceOf(address tokenOwner) public view returns (uint balance) {
187         return balances[tokenOwner];
188     }
189     
190     function transfer(address to, uint tokens) public returns (bool success) {
191         balances[msg.sender] = balances[msg.sender].sub(tokens);
192         balances[to] = balances[to].add(tokens);
193         emit Transfer(msg.sender, to, tokens);
194         return true;
195     }
196 
197     function approve(address spender, uint tokens) public returns (bool success) {
198         allowed[msg.sender][spender] = tokens;
199         emit Approval(msg.sender, spender, tokens);
200         return true;
201     }
202 
203     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
204         balances[from] = balances[from].sub(tokens);
205         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
206         balances[to] = balances[to].add(tokens);
207         emit Transfer(from, to, tokens);
208         return true;
209     }
210     
211     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
212         return allowed[tokenOwner][spender];
213     }
214 
215     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
216         allowed[msg.sender][spender] = tokens;
217         emit Approval(msg.sender, spender, tokens);
218         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
219         return true;
220     }   
221     
222     /**
223      * @dev Burns a specific amount of tokens.
224      * @param value The amount of token to be burned.
225      */
226     function burn(uint256 value) public onlyOwner {
227         require(value > 0, "Invalid Amount.");
228         require(_totalSupply >= value, "Invalid account state.");
229         require(balances[owner] >= value, "Invalid account balances state.");
230         _totalSupply = _totalSupply.sub(value);
231         balances[owner] = balances[owner].sub(value);
232         emit Transfer(owner, address(0), value);
233     }    
234     
235     /**
236      * @dev Set new Stake Creator address.
237      * @param _stakeCreator The address of the new Stake Creator.
238      */    
239     function setNewStakeCreator(address _stakeCreator) external onlyOwner {
240         require(_stakeCreator != address(0), 'Do not use 0 address');
241         stakeCreator = _stakeCreator;
242     }
243     
244     /**
245      * @dev Set new pause status.
246      * @param newIsPaused The pause status: 0 - not paused, 1 - paused.
247      */ 
248     function setIsPaused(bool newIsPaused) external onlyOwner {
249         isPaused = newIsPaused;
250     }
251     
252     /**
253      * @dev Set new Stake Period.
254      * @param newStakePeriod indicates new stake period, it was 7 days by default.
255      */
256     function setStakePeriod(uint256 newStakePeriod) external onlyOwner {
257         stakePeriod = newStakePeriod;
258     }    
259     
260     /**
261     * @dev Stake LAYER tokens for earning rewards, Tokens will be deducted from message sender account
262     * @param payment Amount of LAYER to be staked in the pool
263     */    
264     function lock(uint payment) external paused {
265         require(payment > 0, 'Payment must be greater than 0.');
266         require(UNILAYER.balanceOf(msg.sender) >= payment, 'Holder does not have enough tokens.');
267         require(UNILAYER.allowance(msg.sender, address(this)) >= payment, 'Call Approve function firstly.');
268         
269         UNILAYER.transferFrom(msg.sender, address(this), payment);
270         
271         StakeHolder memory holder = stakeHolders[msg.sender];
272         Stake memory stake = stakes[stakeNum];
273         
274         if(holder.layerLocked == 0) {
275             holder.firstStake = stakeNum;
276             holder.time = now;
277         } else if(holder.layerLocked > 0 && stakeNum > holder.firstStake) {
278             Rewards memory rwds = rewards[msg.sender][stakeNum-1];
279             require(rwds.isReceived == true,'Withdraw your rewards.');
280         }
281         
282         holder.layerLocked = holder.layerLocked.add(payment);
283         stakeHolders[msg.sender] = holder;
284         stake.layerLockedTotal = stake.layerLockedTotal.add(payment);
285         stakes[stakeNum] = stake;
286         
287         emit logLockedTokens(msg.sender, payment, now, stakeNum);
288     }
289     
290     /**
291     * @dev Withdraw My Staked Tokens from staker pool
292     */    
293     function unlock() external paused {
294         StakeHolder memory holder = stakeHolders[msg.sender]; 
295         uint amt = holder.layerLocked;
296         require(amt > 0, 'You do not have locked tokens.');
297         require(UNILAYER.balanceOf(address(this))  >= amt, 'Insufficient account balance!');
298         
299         if(holder.layerLocked > 0 && stakeNum > 0) {
300             Rewards memory rwds = rewards[msg.sender][stakeNum-1];
301             require(rwds.isReceived == true,'Withdraw your rewards.');
302         }
303         
304         Stake memory stake = stakes[stakeNum];
305         stake.layerLockedTotal = stake.layerLockedTotal.sub(holder.layerLocked);
306         stakes[stakeNum] = stake;
307         
308         delete stakeHolders[msg.sender];
309         
310         UNILAYER.transfer(msg.sender, amt);
311         
312         emit logUnlockedTokens(msg.sender, amt, now);
313     }    
314     
315     /**
316     * @dev Stake Creator finalizes the stake, the stake receives the accumulated ETH as reward and calculates everyone's percentages.
317     */      
318     function closeStake() external {
319         require(msg.sender == stakeCreator, 'You cannot call this function');
320         
321         Stake memory stake = stakes[stakeNum]; 
322         require(now >= stake.start.add(stakePeriod), 'You cannot call this function until stakePeriod is over');
323         
324         stake.end = now;
325         stake.ethReward = stake.ethReward.add(totalEthRewards);
326   
327         uint amtLayerx = stake.end.sub(stake.start).mul(amtByDay).div(1 days);
328         
329         if(amtLayerx > balances[owner]) { amtLayerx = balances[owner]; }
330         
331         stake.layerxReward = amtLayerx;
332         stakes[stakeNum] = stake;
333         
334         emit logCloseStake(stakeNum, totalEthRewards, now);
335         
336         stakeNum++;
337         stakes[stakeNum] = Stake(now, 0, stake.layerLockedTotal, 0, 0);
338         totalEthRewards = 0;
339     }
340     
341     /**
342     * @dev Withdraw Reward Layerx Tokens and ETH
343     * @param index Stake index
344     */
345     function withdraw(uint index) external paused exist(index) {
346         Rewards memory rwds = rewards[msg.sender][index];
347         Stake memory stake = stakes[index];
348         StakeHolder memory holder = stakeHolders[msg.sender];
349         
350         uint endTime = holder.time + stakePeriod;
351         
352         require(endTime <= now, 'Wait the minimum time');
353         require(stake.end <= now, 'Invalid date for withdrawal.');
354         require(rwds.isReceived == false, 'You already withdrawal your rewards.');
355         require(balances[owner] >= rwds.layersx, 'Insufficient account balance!');
356         require(address(this).balance >= rwds.eth,'Invalid account state, not enough funds.');
357         require(index >= holder.firstStake, 'Invalid index.');
358         
359         if(holder.firstStake != index) {
360             Rewards memory rwdsOld = rewards[msg.sender][index-1];
361             require(rwdsOld.isReceived == true,'Withdraw your old rewards first.');
362         }
363         
364         rwds.isReceived = true;
365         rwds.layerLocked = holder.layerLocked;    
366         if(rwds.layerLocked > 0) {
367             rwds.layersx = rwds.layerLocked.mul(stake.layerxReward).div(stake.layerLockedTotal);
368             rwds.eth = rwds.layerLocked.mul(stake.ethReward).div(stake.layerLockedTotal);            
369         }
370         rewards[msg.sender][index] = rwds;
371         emit logWithdraw(msg.sender, rwds.layersx, rwds.eth, index, now);
372             
373         if(rwds.layersx > 0) {
374             balances[owner] = balances[owner].sub(rwds.layersx);
375             balances[msg.sender] = balances[msg.sender].add(rwds.layersx);  
376             emit Transfer(owner, msg.sender, rwds.layersx);
377         }
378         
379         if(rwds.eth > 0) { msg.sender.transfer(rwds.eth); }
380     }
381     
382     /**
383     * @dev Function to get the number of stakes
384     * @return number of stakes
385     */    
386     function getStakesNum() external view returns (uint) {
387         return stakeNum;
388     }
389     
390     function stakeOf(address tokenOwner) public view returns (uint balance) {
391         StakeHolder memory holder = stakeHolders[tokenOwner];
392         return holder.layerLocked;
393     }
394     
395     /**
396     * @dev Receive ETH and add value to the accumulated eth for stake
397     */      
398     function() external payable {
399         totalEthRewards = totalEthRewards.add(msg.value); 
400     }
401     
402     function destroyContract() external onlyOwner {
403         selfdestruct(msg.sender);
404     }    
405 
406 }