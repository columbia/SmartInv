1 pragma solidity ^0.6.0;
2 // SPDX-License-Identifier: UNLICENSED
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  *
8 */
9  
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37  
38   function ceil(uint a, uint m) internal pure returns (uint r) {
39     return (a + m - 1) / m * m;
40   }
41 }
42 
43 // ----------------------------------------------------------------------------
44 // ERC Token Standard #20 Interface
45 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
46 // ----------------------------------------------------------------------------
47 abstract contract ERC20Interface {
48     function totalSupply() public virtual view returns (uint);
49     function balanceOf(address tokenOwner) public virtual view returns (uint256 balance);
50     function allowance(address tokenOwner, address spender) public virtual view returns (uint256 remaining);
51     function transfer(address to, uint256 tokens) public virtual returns (bool success);
52     function approve(address spender, uint256 tokens) public virtual returns (bool success);
53     function transferFrom(address from, address to, uint256 tokens) public virtual returns (bool success);
54 
55     event Transfer(address indexed from, address indexed to, uint256 tokens);
56     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
57 }
58 
59 // ----------------------------------------------------------------------------
60 // Owned contract
61 // ----------------------------------------------------------------------------
62 contract Owned {
63     address payable public owner;
64 
65     event OwnershipTransferred(address indexed _from, address indexed _to);
66 
67     constructor() public {
68         owner = msg.sender;
69     }
70 
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     function transferOwnership(address payable _newOwner) public onlyOwner {
77         owner = _newOwner;
78         emit OwnershipTransferred(msg.sender, _newOwner);
79     }
80 }
81 
82 
83 contract HedgeHog is ERC20Interface, Owned {
84     using SafeMath for uint256;
85    
86     string public symbol = "HHOG";
87     string public  name = "HedgeHog";
88     uint256 public decimals = 18;
89     
90     uint256 _totalSupply = 1e9 * 10 ** (decimals); // 1,000,000,000
91     
92     mapping(address => uint256) balances;
93     mapping(address => mapping(address => uint256)) allowed;
94    
95     // ------------------------------------------------------------------------
96     // Constructor
97     // ------------------------------------------------------------------------
98     constructor (address owner) public {
99         
100         owner = 0x5E220057920Dcc7826AB5e5EB5Cf4Bb41C6CD902;
101         
102         balances[address(owner)] =  1000000000 * 10 ** (18); // 1,000,000,000
103         emit Transfer(address(0), address(owner), 1000000000 * 10 ** (18));
104     }
105 
106    
107     /** ERC20Interface function's implementation **/
108    
109     function totalSupply() public override view returns (uint256){
110        return _totalSupply;
111     }
112    
113     // ------------------------------------------------------------------------
114     // Get the token balance for account `tokenOwner`
115     // ------------------------------------------------------------------------
116     function balanceOf(address tokenOwner) public override view returns (uint256 balance) {
117         return balances[tokenOwner];
118     }
119     
120     // ------------------------------------------------------------------------
121     // Token owner can approve for `spender` to transferFrom(...) `tokens`
122     // from the token owner's account
123     // ------------------------------------------------------------------------
124     function approve(address spender, uint256 tokens) public override returns (bool success){
125         allowed[msg.sender][spender] = tokens;
126         emit Approval(msg.sender,spender,tokens);
127         return true;
128     }
129     
130     // ------------------------------------------------------------------------
131     // Returns the amount of tokens approved by the owner that can be
132     // transferred to the spender's account
133     // ------------------------------------------------------------------------
134     function allowance(address tokenOwner, address spender) public override view returns (uint256 remaining) {
135         return allowed[tokenOwner][spender];
136     }
137 
138     // ------------------------------------------------------------------------
139     // Transfer the balance from token owner's account to `to` account
140     // - Owner's account must have sufficient balance to transfer
141     // - 0 value transfers are allowed
142     // ------------------------------------------------------------------------
143     function transfer(address to, uint256 tokens) public override returns (bool success) {
144         // prevent transfer to 0x0, use burn instead
145         require(address(to) != address(0));
146         require(balances[msg.sender] >= tokens );
147         require(balances[to] + tokens >= balances[to]);
148         
149         balances[msg.sender] = balances[msg.sender].sub(tokens);
150        
151         uint256 deduction = deductionsToApply(tokens);
152         applyDeductions(deduction);
153         
154         balances[to] = balances[to].add(tokens.sub(deduction));
155         emit Transfer(msg.sender, to, tokens.sub(deduction));
156         return true;
157     }
158     
159     // ------------------------------------------------------------------------
160     // Transfer `tokens` from the `from` account to the `to` account
161     //
162     // The calling account must already have sufficient tokens approve(...)-d
163     // for spending from the `from` account and
164     // - From account must have sufficient balance to transfer
165     // - Spender must have sufficient allowance to transfer
166     // - 0 value transfers are allowed
167     // ------------------------------------------------------------------------
168     function transferFrom(address from, address to, uint256 tokens) public override returns (bool success){
169         require(tokens <= allowed[from][msg.sender]); //check allowance
170         require(balances[from] >= tokens);
171         balances[from] = balances[from].sub(tokens);
172         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
173       
174         uint256 deduction = deductionsToApply(tokens);
175         applyDeductions(deduction);
176        
177         balances[to] = balances[to].add(tokens.sub(deduction));
178         emit Transfer(from, to, tokens.sub(tokens));
179         return true;
180     }
181     
182     function _transfer(address to, uint256 tokens, bool rewards) internal returns(bool){
183         // prevent transfer to 0x0, use burn instead
184         require(address(to) != address(0));
185         require(balances[address(this)] >= tokens );
186         require(balances[to] + tokens >= balances[to]);
187         
188         balances[address(this)] = balances[address(this)].sub(tokens);
189         
190         uint256 deduction = 0;
191         
192         if(!rewards){
193             deduction = deductionsToApply(tokens);
194             applyDeductions(deduction);
195         }
196         
197         balances[to] = balances[to].add(tokens.sub(deduction));
198             
199         emit Transfer(address(this),to,tokens.sub(deduction));
200         
201         return true;
202     }
203 
204     function deductionsToApply(uint256 tokens) private view returns(uint256){
205         uint256 deduction = 0;
206         uint256 minSupply = 100000 * 10 ** (18);
207         
208         if(_totalSupply > minSupply){
209         
210             deduction = onePercent(tokens).mul(5); // 5% transaction cost
211         
212             if(_totalSupply.sub(deduction) < minSupply)
213                 deduction = _totalSupply.sub(minSupply);
214         }
215         
216         return deduction;
217     }
218     
219     function applyDeductions(uint256 deduction) private{
220         if(stakedCoins == 0){
221             burnTokens(deduction);
222         }
223         else{
224             burnTokens(deduction.div(2));
225             disburse(deduction.div(2));
226         }
227     }
228     
229     // ------------------------------------------------------------------------
230     // Burn the ``value` amount of tokens from the `account`
231     // ------------------------------------------------------------------------
232     function burnTokens(uint256 value) internal{
233         require(_totalSupply >= value); // burn only unsold tokens
234         _totalSupply = _totalSupply.sub(value);
235         emit Transfer(msg.sender, address(0), value);
236     }
237     
238     // ------------------------------------------------------------------------
239     // Calculates onePercent of the uint256 amount sent
240     // ------------------------------------------------------------------------
241     function onePercent(uint256 _tokens) internal pure returns (uint256){
242         uint256 roundValue = _tokens.ceil(100);
243         uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
244         return onePercentofTokens;
245     }
246     
247     
248     /********************************STAKING CONTRACT**********************************/
249     
250     uint256 deployTime;
251     uint256 private totalDividentPoints;
252     uint256 private unclaimedDividendPoints;
253     uint256 pointMultiplier = 1000000000000000000;
254     uint256 public stakedCoins;
255     
256     uint256 public totalStakes;
257     uint256 public totalRewardsClaimed;
258     
259     bool public stakingOpen;
260     
261     struct  Account {
262         uint256 balance;
263         uint256 lastDividentPoints;
264         uint256 timeInvest;
265         uint256 lastClaimed;
266         uint256 rewardsClaimed;
267         uint256 pending;
268     }
269 
270     mapping(address => Account) accounts;
271     
272     function openStaking() external onlyOwner{
273         require(!stakingOpen, "staking already open");
274         stakingOpen = true;
275     }
276     
277     function STAKE(uint256 _tokens) external returns(bool){
278         require(stakingOpen, "staking is close");
279 
280         require(transfer(address(this), _tokens), "In sufficient tokens in user wallet");
281         
282         uint256 owing = dividendsOwing(msg.sender);
283         
284         if(owing > 0) // early stakes
285             accounts[msg.sender].pending = owing;
286             
287         uint256 deduction = deductionsToApply(_tokens);
288         
289         stakedCoins = stakedCoins.add(_tokens.sub(deduction));
290         accounts[msg.sender].balance = accounts[msg.sender].balance.add(_tokens.sub(deduction));
291         accounts[msg.sender].lastDividentPoints = totalDividentPoints;
292         accounts[msg.sender].timeInvest = now;
293         accounts[msg.sender].lastClaimed = now;
294         
295         totalStakes = totalStakes.add(_tokens.sub(deduction));
296         
297         return true;
298     }
299     
300     function pendingReward(address _user) external view returns(uint256){
301         uint256 owing = dividendsOwing(_user);
302         return owing;
303     }
304     
305     function dividendsOwing(address investor) internal view returns (uint256){
306         uint256 newDividendPoints = totalDividentPoints.sub(accounts[investor].lastDividentPoints);
307         return (((accounts[investor].balance).mul(newDividendPoints)).div(pointMultiplier)).add(accounts[investor].pending);
308     }
309    
310     function updateDividend(address investor) internal returns(uint256){
311         uint256 owing = dividendsOwing(investor);
312         if (owing > 0){
313             unclaimedDividendPoints = unclaimedDividendPoints.sub(owing);
314             accounts[investor].lastDividentPoints = totalDividentPoints;
315         }
316         return owing;
317     }
318    
319     function activeStake(address _user) external view returns (uint256){
320         return accounts[_user].balance;
321     }
322    
323     function UNSTAKE() external returns (bool){
324         require(accounts[msg.sender].balance > 0);
325         
326         uint256 owing = updateDividend(msg.sender);
327         if(owing > 0) // unclaimed reward
328             accounts[msg.sender].pending = owing;
329         
330         stakedCoins = stakedCoins.sub(accounts[msg.sender].balance);
331 
332         require(_transfer(msg.sender, accounts[msg.sender].balance, false));
333        
334         accounts[msg.sender].balance = 0;
335         return true;
336     }
337    
338     function disburse(uint256 amount) internal{
339         balances[address(this)] = balances[address(this)].add(amount);
340         
341         uint256 unnormalized = amount.mul(pointMultiplier);
342         totalDividentPoints = totalDividentPoints.add(unnormalized.div(stakedCoins));
343         unclaimedDividendPoints = unclaimedDividendPoints.add(amount);
344     }
345    
346     function claimReward() external returns(bool){
347         uint256 owing = updateDividend(msg.sender);
348         
349         require(owing > 0);
350 
351         require(_transfer(msg.sender, owing, true));
352         
353         accounts[msg.sender].rewardsClaimed = accounts[msg.sender].rewardsClaimed.add(owing);
354        
355         totalRewardsClaimed = totalRewardsClaimed.add(owing);
356         return true;
357     }
358     
359     function rewardsClaimed(address _user) external view returns(uint256 rewardClaimed){
360         return accounts[_user].rewardsClaimed;
361     }
362 }