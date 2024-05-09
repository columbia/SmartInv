1 pragma solidity 0.5.8;
2 
3 interface IERC20 
4 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address who) external view returns (uint256);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function transfer(address to, uint256 value) external returns (bool);
9     function approve(address spender, uint256 value) external returns (bool);
10     function transferFrom(address from, address to, uint256 value) external returns (bool);
11     
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 contract ApproveAndCallFallBack {
17 
18     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
19 }
20 
21 library SafeMath 
22 {
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) 
24     {
25         if (a == 0) 
26         {
27             return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33     
34     function div(uint256 a, uint256 b) internal pure returns (uint256) 
35     {
36         uint256 c = a / b;
37         return c;
38     }
39     
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
41     {
42         assert(b <= a);
43         return a - b;
44     }
45     
46     function add(uint256 a, uint256 b) internal pure returns (uint256) 
47     {
48         uint256 c = a + b;
49         assert(c >= a);
50         return c;
51     }
52     
53     function ceil(uint256 a, uint256 m) internal pure returns (uint256) 
54     {
55         uint256 c = add(a,m);
56         uint256 d = sub(c,1);
57         return mul(div(d,m),m);
58     }
59 }
60 
61 contract ERC20Detailed is IERC20 
62 {
63     string private _name;
64     string private _symbol;
65     uint8 private _decimals;
66     
67     constructor(string memory name, string memory symbol, uint8 decimals) public {
68         _name = name;
69         _symbol = symbol;
70         _decimals = decimals;
71     }
72     
73     function name() public view returns(string memory) {
74         return _name;
75     }
76     
77     function symbol() public view returns(string memory) {
78         return _symbol;
79     }
80     
81     function decimals() public view returns(uint8) {
82         return _decimals;
83     }
84 }
85 
86 contract AfterShock is ERC20Detailed 
87 {
88     using SafeMath for uint256;
89     
90     mapping (address => uint256) private _balances;
91     mapping (address => mapping (address => uint256)) private _allowed;
92     
93     string constant tokenName = "AfterShock";//"AfterShock";
94     string constant tokenSymbol = "SHOCK";//"SHOCK"; 
95     uint8  constant tokenDecimals = 18;
96     uint256 _totalSupply = 0;
97     
98     // ------------------------------------------------------------------------
99   
100     address public contractOwner;
101 
102     uint256 public fullUnitsStaked_total = 0;
103     mapping (address => bool) public excludedFromStaking; //exchanges/other contracts will be excluded from staking
104 
105     uint256 _totalRewardsPerUnit = 0;
106     mapping (address => uint256) private _totalRewardsPerUnit_positions;
107     mapping (address => uint256) private _savedRewards;
108     
109     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110     
111     // ------------------------------------------------------------------------
112     
113     constructor() public ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) 
114     {
115         contractOwner = msg.sender;
116         excludedFromStaking[msg.sender] = true;
117         excludedFromStaking[address(this)] = true;
118         _mint(msg.sender, 1000000 * (10**uint256(tokenDecimals)));
119     }
120     
121     // ------------------------------------------------------------------------
122 
123     function transferOwnership(address newOwner) public 
124     {
125         require(msg.sender == contractOwner);
126         require(newOwner != address(0));
127         emit OwnershipTransferred(contractOwner, newOwner);
128         contractOwner = newOwner;
129     }
130     
131     function totalSupply() public view returns (uint256) 
132     {
133         return _totalSupply;
134     }
135     
136     function balanceOf(address owner) public view returns (uint256) 
137     {
138         return _balances[owner];
139     }
140     
141     function fullUnitsStaked(address owner) public view returns (uint256) 
142     {
143         return toFullUnits(_balances[owner]);
144     }
145     
146     function toFullUnits(uint256 valueWithDecimals) public pure returns (uint256) 
147     {
148         return valueWithDecimals.div(10**uint256(tokenDecimals));
149     }
150     
151     function allowance(address owner, address spender) public view returns (uint256) 
152     {
153         return _allowed[owner][spender];
154     }
155     
156     function transfer(address to, uint256 value) public returns (bool) 
157     {
158         _executeTransfer(msg.sender, to, value);
159         return true;
160     }
161     
162     function multiTransfer(address[] memory receivers, uint256[] memory values) public
163     {
164         require(receivers.length == values.length);
165         for(uint256 i = 0; i < receivers.length; i++)
166             _executeTransfer(msg.sender, receivers[i], values[i]);
167     }
168     
169     function transferFrom(address from, address to, uint256 value) public returns (bool) 
170     {
171         require(value <= _allowed[from][msg.sender]);
172         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
173         _executeTransfer(from, to, value);
174         return true;
175     }
176     
177     function approve(address spender, uint256 value) public returns (bool) 
178     {
179         require(spender != address(0));
180         _allowed[msg.sender][spender] = value;
181         emit Approval(msg.sender, spender, value);
182         return true;
183     }
184     
185     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) 
186     {
187         _allowed[msg.sender][spender] = tokens;
188         emit Approval(msg.sender, spender, tokens);
189         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
190         return true;
191     }
192     
193     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) 
194     {
195         require(spender != address(0));
196         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
197         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
198         return true;
199     }
200     
201     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) 
202     {
203         require(spender != address(0));
204         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
205         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
206         return true;
207     }
208     
209     function _mint(address account, uint256 value) internal 
210     {
211         require(value != 0);
212         
213         uint256 initalBalance = _balances[account];
214         uint256 newBalance = initalBalance.add(value);
215         
216         _balances[account] = newBalance;
217         _totalSupply = _totalSupply.add(value);
218         
219         //update full units staked
220         if(!excludedFromStaking[account])
221         {
222             uint256 fus_total = fullUnitsStaked_total;
223             fus_total = fus_total.sub(toFullUnits(initalBalance));
224             fus_total = fus_total.add(toFullUnits(newBalance));
225             fullUnitsStaked_total = fus_total;
226         }
227         emit Transfer(address(0), account, value);
228     }
229     
230     function burn(uint256 value) external 
231     {
232         _burn(msg.sender, value);
233     }
234     
235     function burnFrom(address account, uint256 value) external 
236     {
237         require(value <= _allowed[account][msg.sender]);
238         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
239         _burn(account, value);
240     }
241     
242     function _burn(address account, uint256 value) internal 
243     {
244         require(value != 0);
245         require(value <= _balances[account]);
246         
247         uint256 initalBalance = _balances[account];
248         uint256 newBalance = initalBalance.sub(value);
249         
250         _balances[account] = newBalance;
251         _totalSupply = _totalSupply.sub(value);
252         
253         //update full units staked
254         if(!excludedFromStaking[account])
255         {
256             uint256 fus_total = fullUnitsStaked_total;
257             fus_total = fus_total.sub(toFullUnits(initalBalance));
258             fus_total = fus_total.add(toFullUnits(newBalance));
259             fullUnitsStaked_total = fus_total;
260         }
261         
262         emit Transfer(account, address(0), value);
263     }
264     
265     /*
266     *   transfer with additional burn and stake rewards
267     *   the receiver gets 94% of the sent value
268     *   6% are split to be burnt and distributed to holders
269     */
270     function _executeTransfer(address from, address to, uint256 value) private
271     {
272         require(value <= _balances[from]);
273         require(to != address(0) && to != address(this));
274 
275         //Update sender and receivers rewards - changing balances will change rewards shares
276         updateRewardsFor(from);
277         updateRewardsFor(to);
278         
279         uint256 sixPercent = value.mul(6).div(100);
280         
281         //set a minimum burn rate to prevent no-burn-txs due to precision loss
282         if(sixPercent == 0 && value > 0)
283             sixPercent = 1;
284             
285         uint256 initalBalance_from = _balances[from];
286         uint256 newBalance_from = initalBalance_from.sub(value);
287         
288         value = value.sub(sixPercent);
289         
290         uint256 initalBalance_to = _balances[to];
291         uint256 newBalance_to = initalBalance_to.add(value);
292         
293         //transfer
294         _balances[from] = newBalance_from;
295         _balances[to] = newBalance_to;
296         emit Transfer(from, to, value);
297          
298         //update full units staked
299         uint256 fus_total = fullUnitsStaked_total;
300         if(!excludedFromStaking[from])
301         {
302             fus_total = fus_total.sub(toFullUnits(initalBalance_from));
303             fus_total = fus_total.add(toFullUnits(newBalance_from));
304         }
305         if(!excludedFromStaking[to])
306         {
307             fus_total = fus_total.sub(toFullUnits(initalBalance_to));
308             fus_total = fus_total.add(toFullUnits(newBalance_to));
309         }
310         fullUnitsStaked_total = fus_total;
311         
312         uint256 amountToBurn = sixPercent;
313         
314         if(fus_total > 0)
315         {
316             uint256 stakingRewards = sixPercent.div(2);
317             //split up to rewards per unit in stake
318             uint256 rewardsPerUnit = stakingRewards.div(fus_total);
319             //apply rewards
320             _totalRewardsPerUnit = _totalRewardsPerUnit.add(rewardsPerUnit);
321             _balances[address(this)] = _balances[address(this)].add(stakingRewards);
322             emit Transfer(msg.sender, address(this), stakingRewards);
323     
324             amountToBurn = amountToBurn.sub(stakingRewards);
325         }
326         
327         //update total supply
328         _totalSupply = _totalSupply.sub(amountToBurn);
329         emit Transfer(msg.sender, address(0), amountToBurn);
330     }
331     
332     //catch up with the current total rewards. This needs to be done before an addresses balance is changed
333     function updateRewardsFor(address staker) private
334     {
335         _savedRewards[staker] = viewUnpaidRewards(staker);
336         _totalRewardsPerUnit_positions[staker] = _totalRewardsPerUnit;
337     }
338     
339     //get all rewards that have not been claimed yet
340     function viewUnpaidRewards(address staker) public view returns (uint256)
341     {
342         if(excludedFromStaking[staker])
343             return _savedRewards[staker];
344         uint256 newRewardsPerUnit = _totalRewardsPerUnit.sub(_totalRewardsPerUnit_positions[staker]);
345         
346         uint256 newRewards = newRewardsPerUnit.mul(fullUnitsStaked(staker));
347         return _savedRewards[staker].add(newRewards);
348     }
349     
350     //pay out unclaimed rewards
351     function payoutRewards() public
352     {
353         updateRewardsFor(msg.sender);
354         uint256 rewards = _savedRewards[msg.sender];
355         require(rewards > 0 && rewards <= _balances[address(this)]);
356         
357         _savedRewards[msg.sender] = 0;
358         
359         uint256 initalBalance_staker = _balances[msg.sender];
360         uint256 newBalance_staker = initalBalance_staker.add(rewards);
361         
362         //update full units staked
363         if(!excludedFromStaking[msg.sender])
364         {
365             uint256 fus_total = fullUnitsStaked_total;
366             fus_total = fus_total.sub(toFullUnits(initalBalance_staker));
367             fus_total = fus_total.add(toFullUnits(newBalance_staker));
368             fullUnitsStaked_total = fus_total;
369         }
370         
371         //transfer
372         _balances[address(this)] = _balances[address(this)].sub(rewards);
373         _balances[msg.sender] = newBalance_staker;
374         emit Transfer(address(this), msg.sender, rewards);
375     }
376     
377     //exchanges or other contracts can be excluded from receiving stake rewards
378     function excludeAddressFromStaking(address excludeAddress, bool exclude) public
379     {
380         require(msg.sender == contractOwner);
381         require(excludeAddress != address(this)); //contract may never be included
382         require(exclude != excludedFromStaking[excludeAddress]);
383         updateRewardsFor(excludeAddress);
384         excludedFromStaking[excludeAddress] = exclude;
385         fullUnitsStaked_total = exclude ? fullUnitsStaked_total.sub(fullUnitsStaked(excludeAddress)) : fullUnitsStaked_total.add(fullUnitsStaked(excludeAddress));
386     }
387     
388     //withdraw tokens that were sent to this contract by accident
389     function withdrawERC20Tokens(address tokenAddress, uint256 amount) public
390     {
391         require(msg.sender == contractOwner);
392         require(tokenAddress != address(this));
393         IERC20(tokenAddress).transfer(msg.sender, amount);
394     }
395     
396 }