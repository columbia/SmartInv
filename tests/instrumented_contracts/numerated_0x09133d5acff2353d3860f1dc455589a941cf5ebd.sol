1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12     /**
13      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14      * account.
15      */
16     function Ownable() {
17         owner = msg.sender;
18     }
19 
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29 
30     /**
31      * @dev Allows the current owner to transfer control of the contract to a newOwner.
32      * @param newOwner The address to transfer ownership to.
33      */
34     function transferOwnership(address newOwner) onlyOwner {
35         if (newOwner != address(0)) {
36             owner = newOwner;
37         }
38     }
39 }
40 
41 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
42 
43 /*
44     ERC20 compatible smart contract
45 */
46 contract LoggedERC20 is Ownable {
47     /* Structures */
48     struct LogValueBlock {
49     uint256 value;
50     uint256 block;
51     }
52 
53     /* Public variables of the token */
54     string public standard = 'LogValueBlockToken 0.1';
55     string public name;
56     string public symbol;
57     uint8 public decimals;
58     LogValueBlock[] public loggedTotalSupply;
59 
60     bool public locked;
61 
62     uint256 public creationBlock;
63 
64     /* This creates an array with all balances */
65     mapping (address => LogValueBlock[]) public loggedBalances;
66     mapping (address => mapping (address => uint256)) public allowance;
67 
68     /* This generates a public event on the blockchain that will notify clients */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     mapping (address => bool) public frozenAccount;
72 
73     /* This generates a public event on the blockchain that will notify clients */
74     event FrozenFunds(address target, bool frozen);
75 
76     /* Initializes contract with initial supply tokens to the creator of the contract */
77     function LoggedERC20(
78     uint256 initialSupply,
79     string tokenName,
80     uint8 decimalUnits,
81     string tokenSymbol,
82     bool transferAllSupplyToOwner,
83     bool _locked
84     ) {
85         LogValueBlock memory valueBlock = LogValueBlock(initialSupply, block.number);
86 
87         loggedTotalSupply.push(valueBlock);
88 
89         if(transferAllSupplyToOwner) {
90             loggedBalances[msg.sender].push(valueBlock);
91         }
92         else {
93             loggedBalances[this].push(valueBlock);
94         }
95 
96         name = tokenName;                                   // Set the name for display purposes
97         symbol = tokenSymbol;                               // Set the symbol for display purposes
98         decimals = decimalUnits;                            // Amount of decimals for display purposes
99         locked = _locked;
100     }
101 
102     function valueAt(LogValueBlock [] storage checkpoints, uint256 block) internal returns (uint256) {
103         if(checkpoints.length == 0) {
104             return 0;
105         }
106 
107         LogValueBlock memory prevLogValueBlock;
108 
109         for(uint256 i = 0; i < checkpoints.length; i++) {
110 
111             LogValueBlock memory checkpoint = checkpoints[i];
112 
113             if(checkpoint.block > block) {
114                 return prevLogValueBlock.value;
115             }
116 
117             prevLogValueBlock = checkpoint;
118         }
119 
120         return prevLogValueBlock.value;
121     }
122 
123     function setBalance(address _address, uint256 value) internal {
124         loggedBalances[_address].push(LogValueBlock(value, block.number));
125     }
126 
127     function totalSupply() returns (uint256) {
128         return valueAt(loggedTotalSupply, block.number);
129     }
130 
131     function balanceOf(address _address) returns (uint256) {
132         return valueAt(loggedBalances[_address], block.number);
133     }
134 
135     function transferInternal(address _from, address _to, uint256 value) internal returns (bool success) {
136         uint256 balanceFrom = valueAt(loggedBalances[_from], block.number);
137         uint256 balanceTo = valueAt(loggedBalances[_to], block.number);
138 
139         if(value == 0) {
140             return false;
141         }
142 
143         if(frozenAccount[_from] == true) {
144             return false;
145         }
146 
147         if(balanceFrom < value) {
148             return false;
149         }
150 
151         if(balanceTo + value <= balanceTo) {
152             return false;
153         }
154 
155         loggedBalances[_from].push(LogValueBlock(balanceFrom - value, block.number));
156         loggedBalances[_to].push(LogValueBlock(balanceTo + value, block.number));
157 
158         Transfer(_from, _to, value);
159 
160         return true;
161     }
162 
163     /* Send coins */
164     function transfer(address _to, uint256 _value) {
165         require(locked == false);
166 
167         bool status = transferInternal(msg.sender, _to, _value);
168 
169         require(status == true);
170     }
171 
172     /* Allow another contract to spend some tokens in your behalf */
173     function approve(address _spender, uint256 _value) returns (bool success) {
174         if(locked) {
175             return false;
176         }
177 
178         allowance[msg.sender][_spender] = _value;
179         return true;
180     }
181 
182     /* Approve and then communicate the approved contract in a single tx */
183     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
184         if(locked) {
185             return false;
186         }
187 
188         tokenRecipient spender = tokenRecipient(_spender);
189         if (approve(_spender, _value)) {
190             spender.receiveApproval(msg.sender, _value, this, _extraData);
191             return true;
192         }
193     }
194 
195     /* A contract attempts to get the coins */
196     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
197         if(locked) {
198             return false;
199         }
200 
201         if(allowance[_from][msg.sender] < _value) {
202             return false;
203         }
204 
205         bool _success = transferInternal(_from, _to, _value);
206 
207         if(_success) {
208             allowance[_from][msg.sender] -= _value;
209         }
210 
211         return _success;
212     }
213 }
214 
215 /*
216     Reward distribution functionality
217 */
218 contract LoggedReward is Ownable, LoggedERC20 {
219     /* Structs */
220     struct Reward {
221     uint256 id;
222 
223     uint256 block;
224     uint256 time;
225     uint256 amount;
226 
227     uint256 claimedAmount;
228     uint256 transferedBack;
229 
230     uint256 totalSupply;
231     uint256 recycleTime;
232 
233     bool recycled;
234 
235     mapping (address => bool) claimed;
236     }
237 
238     /* variables */
239     Reward [] public rewards;
240 
241     mapping (address => uint256) rewardsClaimed;
242 
243     /* Events */
244     event RewardTransfered(uint256 id, address indexed _address, uint256 _block, uint256 _amount, uint256 _totalSupply);
245     event RewardClaimed(uint256 id, address indexed _address, uint256 _claim);
246     event UnclaimedRewardTransfer(uint256 id, uint256 _value);
247     event RewardRecycled(uint256 id, address indexed _recycler, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply);
248 
249     function LoggedReward(
250     uint256 initialSupply,
251     string tokenName,
252     uint8 decimalUnits,
253     string tokenSymbol,
254     bool transferAllSupplyToOwner,
255     bool _locked
256     ) LoggedERC20(initialSupply, tokenName, decimalUnits, tokenSymbol, transferAllSupplyToOwner, _locked) {
257 
258     }
259 
260     function addReward(uint256 recycleTime) payable onlyOwner {
261         require(msg.sender == owner);
262         require(msg.value > 0);
263 
264         uint256 id = rewards.length;
265         uint256 _totalSupply = valueAt(loggedTotalSupply, block.number);
266 
267         rewards.push(
268         Reward(
269         id,
270         block.number,
271         now,
272         msg.value,
273         0,
274         0,
275         _totalSupply,
276         recycleTime,
277         false
278         )
279         );
280 
281         RewardTransfered(id, msg.sender, block.number, msg.value, _totalSupply);
282     }
283 
284     function claimedRewardHook(uint256 rewardId, address _address, uint256 claimed) internal {
285         RewardClaimed(rewardId, _address, claimed);
286     }
287 
288     function claimReward(uint256 rewardId) public returns (bool) {
289         if(rewards.length - 1 < rewardId) {
290             return false;
291         }
292 
293         Reward storage reward = rewards[rewardId];
294 
295         if(reward.claimed[msg.sender] == true) {
296             return false;
297         }
298 
299         if(reward.recycled == true) {
300             return false;
301         }
302 
303         if(now >= reward.time + reward.recycleTime) {
304             return false;
305         }
306 
307         uint256 balance = valueAt(loggedBalances[msg.sender], reward.block);
308 
309         if(balance == 0) {
310             return false;
311         }
312 
313         uint256 claim = balance * reward.amount / reward.totalSupply;
314 
315         reward.claimed[msg.sender] = true;
316 
317         reward.claimedAmount = reward.claimedAmount + claim;
318 
319         if (claim > 0) {
320             claimedRewardHook(rewardId, msg.sender, claim);
321 
322             msg.sender.transfer(claim);
323 
324             return true;
325         }
326 
327         return false;
328     }
329 
330     function claimRewards() public {
331         require(rewardsClaimed[msg.sender] < rewards.length);
332         for (uint i = rewardsClaimed[msg.sender]; i < rewards.length; i++) {
333             if ((rewards[i].claimed[msg.sender] == false) && (rewards[i].recycled == false)) {
334                 rewardsClaimed[msg.sender] = i + 1;
335                 claimReward(i);
336             }
337         }
338     }
339 
340     function recycleReward(uint256 rewardId) public onlyOwner returns (bool success) {
341         if(rewards.length - 1 < rewardId) {
342             return false;
343         }
344 
345         Reward storage reward = rewards[rewardId];
346 
347         if(reward.recycled) {
348             return false;
349         }
350 
351         reward.recycled = true;
352 
353         return true;
354     }
355 
356     function refundUnclaimedEthers(uint256 rewardId) public onlyOwner returns (bool success) {
357         if(rewards.length - 1 < rewardId) {
358             return false;
359         }
360 
361         Reward storage reward = rewards[rewardId];
362 
363         if(reward.recycled == false) {
364             if(now < reward.time + reward.recycleTime) {
365                 return false;
366             }
367         }
368 
369         uint256 claimedBackAmount = reward.amount - reward.claimedAmount;
370 
371         reward.transferedBack = claimedBackAmount;
372 
373         if(claimedBackAmount > 0) {
374             owner.transfer(claimedBackAmount);
375 
376             UnclaimedRewardTransfer(rewardId, claimedBackAmount);
377 
378             return true;
379         }
380 
381         return false;
382     }
383 }
384 
385 /*
386     Smart contract with reward functionality & erc20 compatible interface
387 */
388 contract Inonit is LoggedReward {
389     /* events */
390     event AddressRecovered(address indexed from, address indexed to);
391     event InactivityHolderResetBalance(address indexed _holder);
392 
393     function Inonit(
394     uint256 initialSupply,
395     string standardName,
396     string tokenName,
397     string tokenSymbol
398     ) LoggedReward(initialSupply, tokenName, 18, tokenSymbol, true, false) {
399         standard = standardName;
400     }
401 
402     function balanceOf(address _address) returns (uint256) {
403         if(rewards.length > 0) {
404             Reward storage reward = rewards[0];
405 
406             if(reward.recycled) {
407                 return 0;
408             }
409 
410             if(now >= reward.time + reward.recycleTime) {
411                 return 0;
412             }
413         }
414 
415         uint256 holderBalance = valueAt(loggedBalances[_address], block.number);
416 
417         return holderBalance;
418     }
419 
420     function claimedRewardHook(uint256 rewardId, address _address, uint256 claimed) internal {
421         setBalance(_address, 0);
422 
423         super.claimedRewardHook(rewardId, _address, claimed);
424     }
425 
426     function recover(address _from, address _to) onlyOwner {
427         uint256 tokens = balanceOf(_from);
428 
429         setBalance(_from, 0);
430         setBalance(_to, tokens);
431 
432         AddressRecovered(_from, _to);
433     }
434 
435     function setLocked(bool _locked) onlyOwner {
436         locked = _locked;
437     }
438 }