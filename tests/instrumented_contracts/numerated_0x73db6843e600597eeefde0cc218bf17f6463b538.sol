1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256){
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         require(c / a == b,"Calculation error");
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256){
14         // Solidity only automatically asserts when dividing by 0
15         require(b > 0,"Calculation error");
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256){
22         require(b <= a,"Calculation error");
23         uint256 c = a - b;
24         return c;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256){
28         uint256 c = a + b;
29         require(c >= a,"Calculation error");
30         return c;
31     }
32 
33     function mod(uint256 a, uint256 b) internal pure returns (uint256){
34         require(b != 0,"Calculation error");
35         return a % b;
36     }
37 }
38 
39 interface IERC20 {
40   function totalSupply() external view returns (uint256);
41   function balanceOf(address account) external view returns (uint256);
42   function transfer(address recipient, uint256 amount) external returns (bool);
43   function allowance(address owner, address spender) external view returns (uint256);
44   function approve(address spender, uint256 amount) external returns (bool);
45   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 contract ApproveAndCallFallBack {
51     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
52 }
53 
54 contract Owned {
55     address public owner;
56 
57     event OwnershipTransferred(address indexed _from, address indexed _to);
58 
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63     modifier onlyOwner {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     function transferOwnership(address _newOwner) public onlyOwner {
69         require(_newOwner != address(0), "Ownable: new owner is the zero address");
70         emit OwnershipTransferred(owner, _newOwner);
71         owner = _newOwner;
72     }
73 }
74 
75 contract Layerx is IERC20, Owned {
76     using SafeMath for uint256;
77     
78     string public symbol;
79     string public  name;
80     uint8 public decimals;
81     uint _totalSupply;
82 
83     uint public ethToNextStake = 0;
84     uint stakeNum = 0;
85     uint constant CAP = 1000000000000000000; //smallest currency unit
86     uint amtByDay = 27397260274000000000;
87     address public stakeCreator = owner;
88     address[] private activeHolders;
89     
90     bool isPaused = false;
91 
92     struct Stake {
93        uint start;
94        uint end;
95        uint layerLockedTotal;
96        uint rewardPayment;
97        uint ethLayerx;
98     }
99 
100     struct StakeHolder {
101         uint layerLocked;
102         uint id;
103     }
104     
105     struct Rewards {
106         uint layersx;
107         uint eth;
108         bool withLayersx;
109     }
110     
111     event logLockedTokens(address holder, uint amountLocked, uint stakeId);
112     event logUnlockedTokens(address holder, uint amountUnlocked);
113     event logNewStakePayment(uint id, uint amount);
114     event logWithdraw(address holder, uint amount, uint stakeId);  
115     event logTradeLayersxEth(address holder, uint amount, uint stakeId);  
116     
117     modifier paused {
118         require(isPaused == false, "This contract was paused by the owner!");
119         _;
120     }
121     
122     modifier exist (uint index) {
123         require(index <= stakeNum, 'This stake does not exist.');
124         _;        
125     }
126     
127     mapping (address => StakeHolder) public stakeHolders;
128     mapping (address => mapping (uint => Rewards)) public rewards;
129     mapping (uint => Stake) public stakes;
130     mapping(address => uint) balances;
131     mapping(address => mapping(address => uint)) allowed;
132     
133     IERC20 UNILAYER = IERC20(0x0fF6ffcFDa92c53F615a4A75D982f399C989366b);  
134     
135     constructor() public {
136         symbol = "LAYERX";
137         name = "UNILAYERX";
138         decimals = 18;
139         _totalSupply = 40000 * 10**uint(decimals);
140         balances[owner] = _totalSupply;
141         emit Transfer(address(0), owner, _totalSupply);
142         
143         stakes[0] = Stake(now, 0, 0, 0, 0);
144     }
145 
146     function totalSupply() public view returns (uint) {
147         return _totalSupply.sub(balances[address(0)]);
148     }
149 
150     function balanceOf(address tokenOwner) public view returns (uint balance) {
151         return balances[tokenOwner];
152     }
153 
154     function transfer(address to, uint tokens) public returns (bool success) {
155         balances[msg.sender] = balances[msg.sender].sub(tokens);
156         balances[to] = balances[to].add(tokens);
157         emit Transfer(msg.sender, to, tokens);
158         return true;
159     }
160 
161     function approve(address spender, uint tokens) public returns (bool success) {
162         allowed[msg.sender][spender] = tokens;
163         emit Approval(msg.sender, spender, tokens);
164         return true;
165     }
166 
167     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
168         balances[from] = balances[from].sub(tokens);
169         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
170         balances[to] = balances[to].add(tokens);
171         emit Transfer(from, to, tokens);
172         return true;
173     }
174     
175     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
176         return allowed[tokenOwner][spender];
177     }
178 
179     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
180         allowed[msg.sender][spender] = tokens;
181         emit Approval(msg.sender, spender, tokens);
182         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
183         return true;
184     }
185     
186     function setNewStakeCreator(address _stakeCreator) external onlyOwner {
187         require(_stakeCreator != address(0), 'Do not use 0 address');
188         stakeCreator = _stakeCreator;
189     }
190     
191     function setIsPaused(bool newIsPaused) external onlyOwner {
192         isPaused = newIsPaused;
193     }     
194     
195     function removeHolder(StakeHolder memory holder) internal {
196         uint openId = holder.id;
197         address openWallet = activeHolders[openId];
198         if(activeHolders.length > 1) {
199             uint lastId = activeHolders.length-1;
200             address lastWallet = activeHolders[lastId];
201             StakeHolder memory lastHolder = stakeHolders[lastWallet];
202             
203             lastHolder.id = openId;
204             stakeHolders[lastWallet] = lastHolder;
205             activeHolders[openId] = lastWallet;
206         }
207         activeHolders.pop();
208         holder.id = 0;
209         stakeHolders[openWallet] = holder;        
210     }    
211     
212     function lock(uint payment) external paused {
213         require(payment > 0, 'Payment must be greater than 0.');
214         require(UNILAYER.balanceOf(msg.sender) >= payment, 'Holder does not have enough tokens.');
215         UNILAYER.transferFrom(msg.sender, address(this), payment);
216         
217         StakeHolder memory holder = stakeHolders[msg.sender];
218         
219         if(holder.layerLocked == 0) {
220             uint holderId = activeHolders.length;
221             activeHolders.push(msg.sender);
222             holder.id = holderId;
223         }        
224         
225         holder.layerLocked = holder.layerLocked.add(payment);
226         
227         Stake memory stake = stakes[stakeNum];
228         stake.layerLockedTotal = stake.layerLockedTotal.add(payment);
229         
230         stakeHolders[msg.sender] = holder;
231         stakes[stakeNum] = stake;
232         
233         emit logLockedTokens(msg.sender, payment, stakeNum);
234     }    
235     
236     function unlock() external paused {
237         StakeHolder memory holder = stakeHolders[msg.sender]; 
238         uint amt = holder.layerLocked;
239         require(amt > 0, 'You do not have locked tokens.');
240         
241         UNILAYER.transfer(msg.sender, amt);
242         
243         Stake memory stake = stakes[stakeNum];
244         require(stake.end == 0, 'Invalid date for unlock, please use withdraw.');
245         stake.layerLockedTotal = stake.layerLockedTotal.sub(amt);
246         stakes[stakeNum] = stake;
247         
248         holder.layerLocked = 0;
249         stakeHolders[msg.sender] = holder;
250         removeHolder(holder);        
251         emit logUnlockedTokens(msg.sender, amt);
252     }
253     
254     function addStakePayment() external {
255         require(msg.sender == stakeCreator, 'You cannot call this function');
256         Stake memory stake = stakes[stakeNum]; 
257         stake.end = now;
258         stake.rewardPayment = stake.rewardPayment.add(ethToNextStake);
259         ethToNextStake = 0;
260   
261         uint days_passed = stake.end.sub(stake.start).mul(100000000).div(86400); //86400 = 1 day
262         uint amtLayerx = days_passed.mul(amtByDay).div(100000000);
263         
264         for(uint i = 0; i < activeHolders.length; i++) {
265             StakeHolder memory holder = stakeHolders[activeHolders[i]];
266             uint rate = holder.layerLocked.mul(CAP).div(stake.layerLockedTotal);
267             rewards[activeHolders[i]][stakeNum].layersx = amtLayerx.mul(rate).div(CAP);
268         }
269         
270         stake.ethLayerx = stake.rewardPayment.mul(CAP).div(amtLayerx);
271         stakes[stakeNum] = stake;
272         emit logNewStakePayment(stakeNum, ethToNextStake);  
273         stakeNum++;
274         stakes[stakeNum] = Stake(now, 0, stake.layerLockedTotal, 0, 0);
275     }
276     
277     function withdraw(uint index) external paused exist(index) {
278         Rewards memory rwds = rewards[msg.sender][index];
279         Stake memory stake = stakes[index];
280         
281         require(stake.end <= now, 'Invalid date for withdrawal.');
282         require(stake.rewardPayment > 0, 'There is no value to distribute.');
283         require(rwds.withLayersx == false, 'You already withdrawal your Layersx.');
284         require(rwds.layersx > 0, 'You dont have Layerx to withdraw.');
285    
286         balances[owner] = balances[owner].sub(rwds.layersx);
287         balances[msg.sender] = balances[msg.sender].add(rwds.layersx);
288    
289         rwds.withLayersx = true;
290         
291         emit logWithdraw(msg.sender, rwds.layersx, index);
292         rewards[msg.sender][index] = rwds;
293     }
294     
295     function tradeLayersxToEth(uint index) external paused exist(index) {
296         Rewards memory rwds = rewards[msg.sender][index];
297         Stake memory stake = stakes[index];
298         
299         require(stake.end <= now, 'Invalid date for withdrawal.');
300         require(rwds.layersx > 0, 'You do not have Layersx for this stake to exchange for ETH.');
301         require(rwds.eth == 0, 'You already traded the Layersx of this stake for ETH');
302         
303         balances[msg.sender] = balances[msg.sender].sub(rwds.layersx);
304         balances[owner] = balances[owner].add(rwds.layersx);
305         
306         uint eths = stake.ethLayerx.mul(rwds.layersx).div(CAP);
307         rwds.eth = eths;
308         
309         msg.sender.transfer(eths);
310         rewards[msg.sender][index] = rwds;
311         emit logTradeLayersxEth(msg.sender, eths, index);
312     }
313     
314     function getStakesNum() external view returns (uint) {
315         return stakeNum+1;
316     }
317     
318     function() external payable {
319         ethToNextStake = ethToNextStake.add(msg.value); 
320     }
321 }