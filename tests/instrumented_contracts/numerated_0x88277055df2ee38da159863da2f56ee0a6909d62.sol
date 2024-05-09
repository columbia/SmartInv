1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity >=0.4.23 <0.7.0;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address who) external view returns (uint256);
8 
9     function allowance(address owner, address spender) external view returns (uint256);
10 
11     function transfer(address to, uint256 value) external returns (bool);
12 
13     function approve(address spender, uint256 value) external returns (bool);
14 
15     function transferFrom(address from, address to, uint256 value) external returns (bool);
16 
17     event Transfer(
18         address indexed from,
19         address indexed to,
20         uint256 value
21     );
22 
23     event Approval(
24         address indexed owner,
25         address indexed spender,
26         uint256 value
27     );
28 }
29 
30 pragma solidity >=0.4.23 <0.7.0;
31 
32 library SafeMath {
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     if (a == 0) {
35       return 0;
36     }
37     uint256 c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a / b;
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 
58   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
59     uint256 c = add(a,m);
60     uint256 d = sub(c,1);
61     return mul(div(d,m),m);
62   }
63 }
64 
65 pragma solidity >=0.4.23 <0.7.0;
66 
67 
68 /*
69 --------------------------------------------------------------------------
70 -        Distribution Contract for the Analys-X (XYS) Token              -
71 -                   Written by: Admirral                                 -
72 -                     ~~~~~~~~~~~~~~~~                                   -
73 -    This contract will track XYS stakers and distribute payments        -
74 -    received from users who purchase Analys-X products. All payments    -
75 -    will be received in XYS tokens.                                     -
76 -                                                                        -
77 -    Only 100 stakers will be allowed at any one time.                   -
78 -    When a new user stakes, the oldest on the list is removed and       -
79 -    they receive their stake back. The price to stake                   -
80 -    increases by 1% after each new stake.                               -
81 -                                                                        -
82 -    When product fees are collected, 90% of that fee is redistributed   -
83 -    to the 100 addresses on the list.                                   -
84 --------------------------------------------------------------------------
85 */
86 
87 contract Distribute is IERC20 {
88     using SafeMath for uint256;
89 
90     // EVENTS
91     event Stake(address indexed user);
92     event Purchase(address indexed user, uint256 amount);
93     event Withdraw(address indexed user);
94 
95     //basic identifiers - ERC20 Standard
96     string public name = "ANALYSX";
97     string public symbol = "XYS";
98     uint256 public decimals = 6;
99 
100     //total Supply - currently 40'000'000
101     uint256 private _totalSupply = 40000000 * (10 ** decimals);
102 
103     // balances and allowance - ERC20 Standard
104     mapping (address => uint256) private _balances;
105     mapping (address => mapping (address => uint256)) private _allowances;
106 
107     // Staked Token Tracking
108     mapping (address => uint256) public _staked;
109 
110     // Users earnings from staking
111     mapping (address => uint256) private _earned;
112 
113     // Is user on staking list? 
114     mapping (address => bool) public _isStaked;
115 
116     // Stake List
117     address[100] private _stakeList;
118 
119     // initial staking fee
120     uint256 public _initialFee = 100000 * (10 ** decimals);
121 
122     // Current Staking Fee
123     uint256 public _stakeFee;
124 
125     // Total Amount Staked;
126     uint256 public _totalStaked;
127 
128     // Time of Previous Staker
129     uint256 public _lastStakerTime;
130 
131     // Contract owner Address
132     address payable _owner;
133 
134 
135     // Constructor
136     constructor(address payable owner) public {
137 
138         // mints tokens
139         _mint(owner, _totalSupply);
140 
141         // Sets owner of contract
142         _owner = owner;  
143 
144         // Sets staking fee to initial amount             
145         _stakeFee = _initialFee;
146 
147         // initiates time of most recent staker
148         _lastStakerTime = block.timestamp;
149 
150         // fills stakeList with owner.
151         for (uint i = 0; i <= 99; i++) {
152             _stakeList[i] = _owner;
153         }
154 
155     }
156 
157     // ---------------------------------
158     // --       ERC20 Functions       --
159     // --        Open Zeppelin        --
160     // ---------------------------------
161 
162     function totalSupply() override public view returns (uint256) {
163         return _totalSupply;
164     }
165 
166     function balanceOf(address account) public override view returns (uint256) {
167         return _balances[account];
168     }
169 
170     function transfer(address recipient, uint256 amount) override public returns (bool) {
171         _transfer(msg.sender, recipient, amount);
172         return true;
173     }
174 
175     function allowance(address owner, address spender) override public view returns (uint256) {
176         return _allowances[owner][spender];
177     }
178 
179     function approve(address spender, uint256 value) override public returns (bool) {
180         _approve(msg.sender, spender, value);
181         return true;
182     }
183 
184     function transferFrom(address sender, address recipient, uint256 amount) override public returns (bool) {
185         _transfer(sender, recipient, amount);
186         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
187         return true;
188     }
189 
190     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
191         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
192         return true;
193     }
194 
195     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
196         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
197         return true;
198     }
199 
200     function _transfer(address sender, address recipient, uint256 amount) internal {
201         require(sender != address(0), "ERC20: transfer from the zero address");
202         require(recipient != address(0), "ERC20: transfer to the zero address");
203 
204         _balances[sender] = _balances[sender].sub(amount);
205         _balances[recipient] = _balances[recipient].add(amount);
206         emit Transfer(sender, recipient, amount);
207     }
208 
209     function _mint(address account, uint256 amount) internal {
210         require(account != address(0), "ERC20: mint to the zero address");
211 
212         _totalSupply = _totalSupply.add(amount);
213         _balances[account] = _balances[account].add(amount);
214         emit Transfer(address(0), account, amount);
215     }
216 
217     function _burn(address account, uint256 value) internal {
218         require(account != address(0), "ERC20: burn from the zero address");
219 
220         _totalSupply = _totalSupply.sub(value);
221         _balances[account] = _balances[account].sub(value);
222         emit Transfer(account, address(0), value);
223     }
224 
225     function _approve(address owner, address spender, uint256 value) internal {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228 
229         _allowances[owner][spender] = value;
230         emit Approval(owner, spender, value);
231     }
232 
233     function _burnFrom(address account, uint256 amount) internal {
234         _burn(account, amount);
235         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
236     }
237 
238     // --------------------------------------
239     // --       Custom Functions           --
240     // --------------------------------------
241 
242     // Owner modifier. Functions with this modifier can only be called by contract owner
243     modifier onlyOwner() {
244         require(isOwner(), "Ownable: caller is not the owner");
245         _;
246     } 
247 
248     // checks if the sending user is owner. Returns true or false
249     function isOwner() public view returns (bool) {
250         return msg.sender == _owner;
251     }
252 
253     // change owner
254     function changeOwner(address payable newOwner) public onlyOwner {
255         _owner = newOwner;
256     }
257 
258     // Returns users stake earnings
259     function checkReward() public view returns (uint256) {
260         return _earned[msg.sender];
261     }
262 
263     // returns staker list
264     function showStakers() public view returns (address[100] memory) {
265         return _stakeList;
266     }
267 
268     // Stake Function
269     function stake() public {
270         require(msg.sender != _owner, "Owner cannot stake");
271         require(_balances[msg.sender] >= _stakeFee, "Insufficient Tokens");
272         require(_isStaked[msg.sender] == false, "You are already staking");
273         require(_staked[msg.sender] == 0, "You have stake"); // Maybe redundant?
274 
275         // updates new stakers balances and records stake
276         _balances[msg.sender] = _balances[msg.sender].sub(_stakeFee);
277         _staked[msg.sender] = _stakeFee;
278         _totalStaked = _totalStaked.add(_stakeFee);
279 
280         // updates staking fee
281         uint256 stakeIncrease = _stakeFee.div(100);
282         _stakeFee = _stakeFee.add(stakeIncrease);
283         _lastStakerTime = block.timestamp;
284 
285         // updates stake list
286         updateStaking();
287 
288         emit Stake(msg.sender);
289 
290     }
291     
292     // Remove a user from staking, and replace slot with _owner address
293     function exitStake() public returns(bool) {
294         require(msg.sender != _owner, "owner cannot exit");
295         require(_isStaked[msg.sender] == true, "You are not staking");
296         require(_staked[msg.sender] != 0, "You don't have stake"); // Maybe redundant?
297         
298         for (uint i = 0; i < 99; i++) {
299             if (_stakeList[i] == msg.sender) {
300                 _balances[msg.sender] = _balances[msg.sender].add(_earned[msg.sender]).add(_staked[msg.sender]);
301                 _staked[msg.sender] = 0;
302                 _earned[msg.sender] = 0;
303                 _stakeList[i] = _owner;
304                 _isStaked[msg.sender] = false;
305                 return true;
306             }
307         }
308         return false;
309     }
310 
311     //Adds new user to staking list, removes oldest user, returns their stake
312     function updateStaking() internal {
313 
314         // Refunds the user at the end of the list
315         address lastUser = _stakeList[99];
316         _balances[lastUser] = _balances[lastUser].add(_staked[lastUser]);
317         _staked[lastUser] = 0;
318         _isStaked[lastUser] = false;
319         
320         // Gives the final user their collected rewards
321         _balances[lastUser] = _balances[lastUser].add(_earned[lastUser]);
322         _earned[lastUser] = 0;
323 
324         // Updates positions on list
325         for (uint i = 99; i > 0; i--) {
326             uint previous = i.sub(1);
327             address previousUser = _stakeList[previous];
328             _stakeList[i] = previousUser;
329         }
330 
331         // Inserts new staker to top of list
332         _stakeList[0] = msg.sender;
333         _isStaked[msg.sender] = true;
334     }
335 
336     // Function to purchase service (any price is possible, product is offerred off-chain)
337     function purchaseService(uint256 price, address purchaser) public {
338         
339         // Check if user has required balance
340         require (_balances[purchaser] >= price, "Insufficient funds");
341         
342         // token value must be > 0.001 to avoid computation errors)
343         require (price > 1000, "Value too Small");
344 
345         // 10% goes to owner (this can be adjusted)
346         uint256 ownerShare = price.div(10);
347         uint256 toSplit = price.sub(ownerShare);
348         uint256 stakeShare = toSplit.div(100);
349         _earned[_owner] = _earned[_owner].add(ownerShare);
350 
351         // distributes funds to each staker, except the last one. 
352         for (uint i = 0; i < 99; i++) {
353             
354             // adds stakeShare to each user
355             _earned[_stakeList[i]] = _earned[_stakeList[i]].add(stakeShare);
356             
357             // We subtract from toSplit to produce a final amount for the final staker
358             toSplit = toSplit.sub(stakeShare);
359         }
360         
361         // toSplit should be equal or slightly higher than stakeShare. This is to avoid accidental burning.
362         _earned[_stakeList[99]] = _earned[_stakeList[99]].add(toSplit);
363         
364         // Remove the price from sender.
365         _balances[purchaser] = _balances[purchaser].sub(price);
366 
367         emit Purchase(purchaser, price);
368     }
369 
370     // Stakers can call this function to claim their funds without leaving the pool. 
371     function withdraw() public {
372         require(_earned[msg.sender] > 0, "Stake some more");
373         _balances[msg.sender] = _balances[msg.sender].add(_earned[msg.sender]);
374         _earned[msg.sender] = 0;
375 
376         emit Withdraw(msg.sender);
377     }
378 
379     // Resets staking price. Can only be usable if no new staker has entered the pool in 1 month (2592000 seconds)
380     function stakeReset() public  onlyOwner {
381         require(block.timestamp.sub(_lastStakerTime) >= 2592000, "not enough time has passed");
382         _stakeFee = _initialFee;
383     }
384 }