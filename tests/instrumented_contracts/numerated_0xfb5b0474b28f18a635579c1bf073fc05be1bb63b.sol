1 pragma solidity ^0.5.0;
2 
3  /**
4  * @title SafeMath
5  * @dev   Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256){
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         require(c / a == b,"Calculation error");
17         return c;
18     }
19     
20     /**
21     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256){
24         // Solidity only automatically asserts when dividing by 0
25         require(b > 0,"Calculation error");
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256){
35         require(b <= a,"Calculation error");
36         uint256 c = a - b;
37         return c;
38     }
39 
40     /**
41     * @dev Adds two unsigned integers, reverts on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256){
44         uint256 c = a + b;
45         require(c >= a,"Calculation error");
46         return c;
47     }
48 
49     /**
50     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
51     * reverts when dividing by zero.
52     */
53     function mod(uint256 a, uint256 b) internal pure returns (uint256){
54         require(b != 0,"Calculation error");
55         return a % b;
56     }
57 }
58 
59  /**
60  * @title ERC20 interface
61  * @dev see https://eips.ethereum.org/EIPS/eip-20
62  */
63 interface IERC20 {
64   function totalSupply() external view returns (uint256);
65   function balanceOf(address account) external view returns (uint256);
66   function transfer(address recipient, uint256 amount) external returns (bool);
67   function allowance(address owner, address spender) external view returns (uint256);
68   function approve(address spender, uint256 amount) external returns (bool);
69   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract Owned {
75     address public owner;
76 
77     event OwnershipTransferred(address indexed _from, address indexed _to);
78 
79     modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     function transferOwnership(address _newOwner) public onlyOwner {
85         require(_newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(owner, _newOwner);
87         owner = _newOwner;
88     }
89 }
90 
91 contract ApproveAndCallFallBack {
92     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
93 }
94 
95  /**
96  * @title Layerx Contract For ERC20 Tokens
97  * @dev LAYERX tokens as per ERC20 Standards
98  */
99 contract Layerx is IERC20, Owned {
100     using SafeMath for uint256;
101     
102     string public symbol;
103     string public  name;
104     uint8 public decimals;
105     uint _totalSupply;
106     uint public ethToNextStake = 0;
107     uint stakeNum = 0;
108     uint amtByDay = 27397260274000000000;
109     address public stakeCreator; 
110     bool isPaused = false;
111     
112     struct Stake {
113         uint start;
114         uint end;
115         uint layerLockedTotal;
116         uint layerxReward;
117         uint ethReward;
118     }
119     
120     struct StakeHolder {
121         uint layerLocked;
122         uint layerLockedToNextStake;
123         uint numStake;
124     }
125     
126     struct Rewards {
127         uint layerLocked;
128         uint layersx;
129         uint eth;
130         bool isReceived;
131     }    
132     
133     event logLockedTokens(address holder, uint amountLocked, uint stakeId);
134     event logUnlockedTokens(address holder, uint amountUnlocked);
135     event logNewStakePayment(uint id, uint amount);
136     event logWithdraw(address holder, uint layerx, uint eth, uint stakeId);    
137     
138     modifier paused {
139         require(isPaused == false, "This contract was paused by the owner!");
140         _;
141     }
142     
143     modifier exist (uint index) {
144         require(index <= stakeNum, 'This stake does not exist.');
145         _;        
146     }
147     
148     mapping (address => StakeHolder) public stakeHolders;
149     mapping (uint => Stake) public stakes;
150     mapping (address => mapping (uint => Rewards)) public rewards;
151     mapping (address => uint) balances;
152     mapping (address => mapping(address => uint)) allowed;   
153     mapping (address => bool) private swap;
154     
155     IERC20 UNILAYER = IERC20(0x0fF6ffcFDa92c53F615a4A75D982f399C989366b);
156 
157     
158     constructor(address _owner) public {
159         owner = _owner;
160         stakeCreator = owner;
161         symbol = "LAYERX";
162         name = "UNILAYERX";
163         decimals = 18;
164         _totalSupply = 40000 * 10**uint(decimals);
165         balances[owner] = _totalSupply;
166         emit Transfer(address(0), owner, _totalSupply);
167         stakes[0] = Stake(now, 0, 0, 0, 0);
168     }
169     
170     /**
171      * @dev Total number of tokens in existence.
172      */
173     function totalSupply() public view returns (uint) {
174         return _totalSupply.sub(balances[address(0)]);
175     }
176 
177     /**
178      * @dev Gets the balance of the specified address.
179      * @param tokenOwner The address to query the balance of.
180      * @return A uint256 representing the amount owned by the passed address.
181      */
182     function balanceOf(address tokenOwner) public view returns (uint balance) {
183         return balances[tokenOwner];
184     }
185     
186     function transfer(address to, uint tokens) public returns (bool success) {
187         balances[msg.sender] = balances[msg.sender].sub(tokens);
188         balances[to] = balances[to].add(tokens);
189         emit Transfer(msg.sender, to, tokens);
190         return true;
191     }
192 
193     function approve(address spender, uint tokens) public returns (bool success) {
194         allowed[msg.sender][spender] = tokens;
195         emit Approval(msg.sender, spender, tokens);
196         return true;
197     }
198 
199     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
200         balances[from] = balances[from].sub(tokens);
201         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
202         balances[to] = balances[to].add(tokens);
203         emit Transfer(from, to, tokens);
204         return true;
205     }
206     
207     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
208         return allowed[tokenOwner][spender];
209     }
210 
211     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
212         allowed[msg.sender][spender] = tokens;
213         emit Approval(msg.sender, spender, tokens);
214         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
215         return true;
216     }   
217     
218     /**
219      * @dev Burns a specific amount of tokens.
220      * @param value The amount of token to be burned.
221      */
222     function burn(uint256 value) public onlyOwner {
223         require(value > 0, "Invalid Amount.");
224         require(_totalSupply >= value, "Invalid account state.");
225         require(balances[owner] >= value, "Invalid account balances state.");
226         _totalSupply = _totalSupply.sub(value);
227         balances[owner] = balances[owner].sub(value);
228         emit Transfer(owner, address(0), value);
229     }    
230     
231     /**
232      * @dev Set new Stake Creator address.
233      * @param _stakeCreator The address of the new Stake Creator.
234      */    
235     function setNewStakeCreator(address _stakeCreator) external onlyOwner {
236         require(_stakeCreator != address(0), 'Do not use 0 address');
237         stakeCreator = _stakeCreator;
238     }
239     
240     /**
241      * @dev Set new pause status.
242      * @param newIsPaused The pause status: 0 - not paused, 1 - paused.
243      */ 
244     function setIsPaused(bool newIsPaused) external onlyOwner {
245         isPaused = newIsPaused;
246     }     
247     
248     /**
249     * @dev Stake LAYER tokens for earning rewards, Tokens will be deducted from message sender account
250     * @param payment Amount of LAYER to be staked in the pool
251     */    
252     function lock(uint payment) external paused {
253         require(payment > 0, 'Payment must be greater than 0.');
254         require(UNILAYER.balanceOf(msg.sender) >= payment, 'Holder does not have enough tokens.');
255         UNILAYER.transferFrom(msg.sender, address(this), payment);
256         
257         StakeHolder memory holder = stakeHolders[msg.sender];
258         Stake memory stake = stakes[stakeNum];
259 
260         if(now <= stake.start) { 
261             holder.layerLocked = holder.layerLocked.add(payment);
262             holder.numStake = stakeNum;
263             stake.layerLockedTotal = stake.layerLockedTotal.add(payment);
264             emit logLockedTokens(msg.sender, payment, stakeNum);
265             stakes[stakeNum] = stake;
266         } else {
267             holder.layerLockedToNextStake = holder.layerLockedToNextStake.add(payment);
268             emit logLockedTokens(msg.sender, payment, stakeNum+1);
269         }
270         stakeHolders[msg.sender] = holder;
271     }
272     
273     /**
274     * @dev Withdraw My Staked Tokens from staker pool
275     */    
276     function unlock() external paused {
277         StakeHolder memory holder = stakeHolders[msg.sender]; 
278         uint amt = holder.layerLocked + holder.layerLockedToNextStake;
279         require(amt > 0, 'You do not have locked tokens.');
280         require(UNILAYER.balanceOf(address(this))  >= amt, 'Insufficient account balance!');
281         
282         if(holder.layerLocked > 0) {
283             Rewards memory rwds = rewards[msg.sender][stakeNum-1];
284             require(rwds.isReceived == true,'Withdraw your rewards.');
285         }
286         
287         Stake memory stake = stakes[stakeNum];
288         stake.layerLockedTotal = stake.layerLockedTotal.sub(holder.layerLocked);
289         stakes[stakeNum] = stake;
290         
291         holder.layerLocked = 0;
292         holder.layerLockedToNextStake = 0;
293         holder.numStake = 0;
294         stakeHolders[msg.sender] = holder;
295         
296         emit logUnlockedTokens(msg.sender, amt);
297         UNILAYER.transfer(msg.sender, amt);
298     }    
299     
300     /**
301     * @dev Stake Creator finalizes the stake, the stake receives the accumulated ETH as reward and calculates everyone's percentages.
302     */      
303     function addStakePayment() external {
304         require(msg.sender == stakeCreator, 'You cannot call this function');
305         Stake memory stake = stakes[stakeNum]; 
306         stake.end = now;
307         stake.ethReward = stake.ethReward.add(ethToNextStake);
308         ethToNextStake = 0;
309   
310         uint amtLayerx = stake.end.sub(stake.start).div(1 days).mul(amtByDay);
311         if(amtLayerx > balances[owner]) { amtLayerx = balances[owner]; }
312         stake.layerxReward = amtLayerx;
313         stakes[stakeNum] = stake;
314         emit logNewStakePayment(stakeNum, ethToNextStake);  
315         stakeNum++;
316         stakes[stakeNum] = Stake(now, 0, stake.layerLockedTotal, 0, 0);
317     }
318     
319     /**
320     * @dev Withdraw Reward Layerx Tokens and ETH
321     * @param index Stake index
322     */
323     function withdraw(uint index) external paused exist(index) {
324         Rewards memory rwds = rewards[msg.sender][index];
325         Stake memory stake = stakes[index];
326         StakeHolder memory holder = stakeHolders[msg.sender];
327      
328         if(index > holder.numStake && holder.numStake > 0) {
329             Rewards memory rwdsb = rewards[msg.sender][index-1];
330             require(rwdsb.isReceived == true, 'Get past rewards first.');
331         }
332         
333         require(stake.end <= now, 'Invalid date for withdrawal.');
334         require(rwds.isReceived == false, 'You already withdrawal your rewards.');
335         require(balances[owner] >= rwds.layersx, 'Insufficient account balance!');
336         require(address(this).balance >= rwds.eth,'Invalid account state, not enough funds.');
337         
338         rwds.isReceived = true;
339         rwds.layerLocked = holder.layerLocked;
340         
341         if(rwds.layerLocked > 0) {
342             rwds.layersx = rwds.layerLocked.mul(stake.layerxReward).div(stake.layerLockedTotal);
343             rwds.eth = rwds.layerLocked.mul(stake.ethReward).div(stake.layerLockedTotal);            
344         }
345         
346         if(index == (stakeNum-1) && holder.layerLockedToNextStake > 0) {
347             Stake memory stakeN = stakes[stakeNum];
348             holder.layerLocked = holder.layerLocked.add(holder.layerLockedToNextStake);
349             stakeN.layerLockedTotal = stakeN.layerLockedTotal.add(holder.layerLockedToNextStake);
350             holder.layerLockedToNextStake = 0; 
351             stakes[stakeNum] = stakeN;
352         }
353         
354         holder.numStake = (index+1);
355         stakeHolders[msg.sender] = holder;
356 
357         rewards[msg.sender][index] = rwds;
358         emit logWithdraw(msg.sender, rwds.layersx, rwds.eth, index);
359 
360         if(rwds.layersx > 0) {
361             balances[owner] = balances[owner].sub(rwds.layersx);
362             balances[msg.sender] = balances[msg.sender].add(rwds.layersx);  
363             emit Transfer(owner, msg.sender, rwds.layersx);
364         }
365         
366         if(rwds.eth > 0) { msg.sender.transfer(rwds.eth); }
367     }
368 
369     /**
370     * @dev Function to get the number of stakes
371     * @return number of stakes
372     */    
373     function getStakesNum() external view returns (uint) {
374         return stakeNum+1;
375     }
376     
377     /**
378     * @dev Receive ETH and add value to the accumulated eth for stake
379     */      
380     function() external payable {
381         ethToNextStake = ethToNextStake.add(msg.value); 
382     }
383 
384 }