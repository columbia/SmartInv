1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity >=0.8.11 <0.9.0;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function transfer(address recipient, uint256 amount) external returns (bool);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 contract ThreeChargeKings {
17     bool private lock = false;
18     uint private dayCount = 1 days;
19 
20     uint reviewETHBalance;
21     uint devETHBalance;
22     uint burnChargeAmount;
23     uint totalChargeStaked;
24     uint totalPieBonus;
25     uint currentJuice;
26 
27     IERC20 chargeContract;
28     address private owner_;
29     address private chargeContractAddress;
30 
31     address private constant emptyAccount = 0x804748C80B4186aCAb5eC1EE8461dD3146612A67;
32     address private constant devAddress = 0xA8544199b573dbeFd2a1388820B527E01C3184CA;
33     address private constant reviewerAddress = 0xcC8376Ff36424C02EbfE35f5E7C202084789B345;
34 
35     address[] private threeKings = [emptyAccount,emptyAccount,emptyAccount];
36 
37     mapping(address => uint) balances;
38     mapping(address => uint) pieBonus;
39     mapping(address => uint) stakeBalances;
40     mapping(address => uint) threeKingsLockTimes;
41     mapping(address => uint) stakeLockTimes;
42     mapping(address => bool) addressExists;
43 
44     address[] balanceKeys;
45 
46     constructor(address _address) {
47         chargeContractAddress = _address;
48         chargeContract = IERC20(_address);
49         owner_ = msg.sender;   
50     }
51 
52     //
53     //  The first thing you have to do is jump in zPool
54     //  The UI will make sure the user does this
55     //
56     function z_jumpInThePool() external {
57         require(addressExists[msg.sender] == false, "You are in the pool already");
58         addressExists[msg.sender] = true;
59         balanceKeys.push(msg.sender);
60     }
61 
62     function a_stakeCharge(uint256 amount) external {
63         _checkAllowance(amount);
64         require(chargeContract.transferFrom(msg.sender, address(this), amount));
65         
66         require(lock == false);
67         lock = true;
68 
69         uint disPercent;
70         uint totalAmountToAdd;
71 
72         unchecked {
73             disPercent = amount / 8;
74             totalAmountToAdd = amount - disPercent;
75             currentJuice += disPercent;
76             totalChargeStaked += totalAmountToAdd;
77             stakeBalances[msg.sender] += totalAmountToAdd;
78             stakeLockTimes[msg.sender] = block.timestamp + dayCount;
79         }
80 
81         lock = false;
82     }
83 
84     function a_unStake() external {
85         require(stakeBalances[msg.sender] > 0, "User has nothing staked");
86         require(block.timestamp > stakeLockTimes[msg.sender], "Lock time has not expired yet");
87 
88         require(lock == false);
89         lock = true;
90 
91         uint piBonus = pieBonus[msg.sender];
92         uint amountPotential = stakeBalances[msg.sender];
93 
94         totalChargeStaked -= amountPotential;
95         totalPieBonus -= piBonus;
96 
97         pieBonus[msg.sender] = 0;
98         stakeBalances[msg.sender] = 0;
99 
100         lock = false;
101         require(chargeContract.transfer(msg.sender, amountPotential + piBonus));
102     }
103 
104     receive() external payable {
105         require(lock == false);
106 
107         uint devTax = msg.value / 400;
108         if(msg.value > 0) {
109             // there is a require in the else branch
110             // that we need to check before locking
111             // thats why its within each branch
112             lock = true;
113 
114             threeKingsLockTimes[msg.sender] = block.timestamp + dayCount;
115             handleETHCutLogic(devTax);
116             handleDeposit(devTax);
117 
118             lock = false;
119         } else {
120             require(balances[msg.sender] > 0);
121             require(block.timestamp > threeKingsLockTimes[msg.sender], "Lock time has not expired yet");
122             lock = true;
123 
124             devTax = balances[msg.sender] / 400;
125 
126             handleETHCutLogic(devTax);
127             uint amountToSend = handleFundsReturn(devTax);
128 
129             lock = false;
130             
131             (bool sent, ) = msg.sender.call{value: amountToSend}("");
132             require(sent, "Failed to send Ether");
133         }
134     }
135 
136     function handleETHCutLogic(uint devTax) private {
137         uint reviewerTax = devTax / 10;
138         devETHBalance += devTax - reviewerTax;
139         reviewETHBalance += reviewerTax;
140     }
141 
142     function handleDeposit(uint devTax) private {
143         uint amount = msg.value - devTax;
144         balances[msg.sender] += amount;
145         updateKing();
146     }
147 
148     function handleFundsReturn(uint devTax) private returns (uint) {
149         uint amountToRedistribute = sendTokenAmount() / 10;
150         uint potential = sendTokenAmount() - amountToRedistribute;
151 
152         uint amountToSend = balances[msg.sender] - devTax;
153         balances[msg.sender] = 0;
154 
155         currentJuice += amountToRedistribute;
156 
157         uint piBonusForUser = pieBonus[msg.sender];
158         totalPieBonus -= piBonusForUser;
159         pieBonus[msg.sender] = 0;
160         uint chargeToPayoutPotential = potential + piBonusForUser;
161         
162         if(isThreeKing(msg.sender)) {
163             resetKing();
164         }
165 
166         if(chargeToPayoutPotential <= totalThreeChargeKingBalance()) {
167             // we unlock twice if we hit this branch
168             // never want to leave the contract in a locked state
169             lock = false;
170             require(chargeContract.transfer(msg.sender, chargeToPayoutPotential));
171         }
172         return amountToSend;
173     }
174 
175     function updateKing() private {
176         uint newBalance = balances[msg.sender];
177         uint oldKingOne = balances[threeKings[0]];
178         uint oldKingTwo = balances[threeKings[1]];
179         uint oldKingThree = balances[threeKings[2]];
180 
181         if(isThreeKing(msg.sender)) {
182             if(msg.sender == threeKings[1] && oldKingOne < newBalance) {
183                 threeKings[1] = threeKings[0];
184                 threeKings[0] = msg.sender;
185             } else if(msg.sender == threeKings[2] && oldKingTwo < newBalance && oldKingOne >= newBalance) {
186                 threeKings[2] = threeKings[1];
187                 threeKings[1] = msg.sender;
188             } else if(msg.sender == threeKings[2] && oldKingOne < newBalance) {
189                 threeKings[2] = threeKings[1];
190                 threeKings[1] = threeKings[0];
191                 threeKings[0] = msg.sender;
192             }
193         } else if(oldKingOne < newBalance) {
194             threeKings[2] = threeKings[1];
195             threeKings[1] = threeKings[0];
196             threeKings[0] = msg.sender;
197         } else if(oldKingTwo < newBalance) {
198             threeKings[2] = threeKings[1];
199             threeKings[1] = msg.sender;
200         } else if(oldKingThree < newBalance) {
201             threeKings[2] = msg.sender;
202         }
203     }
204 
205     function resetKing() private {
206         uint count = balanceKeys.length;
207         uint rollingCurrentBalance;
208         address currentAddressToReplace = emptyAccount;
209         
210         for (uint i=0; i < count; i++) {
211             if(isThreeKing(balanceKeys[i]) == false
212                && balances[balanceKeys[i]] > rollingCurrentBalance) {
213                    rollingCurrentBalance = balances[balanceKeys[i]];
214                    currentAddressToReplace = balanceKeys[i];
215                }
216         }
217         
218         if(threeKings[0] == msg.sender) {
219             threeKings[0] = threeKings[1];
220             threeKings[1] = threeKings[2];
221             threeKings[2] = currentAddressToReplace;
222         } else if(threeKings[1] == msg.sender) {
223             threeKings[1] = threeKings[2];
224             threeKings[2] = currentAddressToReplace;
225         } else if(threeKings[2] == msg.sender) {
226             threeKings[2] = currentAddressToReplace;
227         }
228     }
229 
230     function z_updateChargeContract(address newAddress) external {
231         require(msg.sender == owner_, "You are not the owner");
232 
233         chargeContractAddress = newAddress;
234         chargeContract = IERC20(newAddress);
235         uint count = balanceKeys.length;
236         for(uint i = 0; i < count; i++) {
237             pieBonus[balanceKeys[i]] = 0;
238         }
239 
240         totalPieBonus = 0;
241         totalChargeStaked = 0;
242         burnChargeAmount = 0;
243         currentJuice = 0;
244     }
245 
246     function z_getTokens(address tokenAddress) external {
247         require(msg.sender == owner_, "You are not the owner");
248         require(tokenAddress != chargeContractAddress, "Sorry bro that would be unfair");
249         
250         IERC20 found = IERC20(tokenAddress);
251         uint256 contract_token_balance = found.balanceOf(address(this));
252         require(contract_token_balance != 0);
253         require(found.transfer(owner_, contract_token_balance));
254     }
255 
256     function stakeFromDistribution(address forAddress, uint distributeAmount) view internal returns (uint) {
257         if(totalChargeStaked == 0) return 0;
258         return (stakeBalances[forAddress] * distributeAmount) / totalChargeStaked;
259     }
260 
261     function sendTokenAmount() view private returns (uint) {
262         if(totalThreeChargeKingBalance() > 0) {
263             uint potential;
264             if(threeKings[0] == msg.sender) {
265                 potential = totalThreeChargeKingBalance() / 2;
266             } else if(threeKings[1] == msg.sender) {
267                 potential = totalThreeChargeKingBalance() / 4;
268             } else if(threeKings[2] == msg.sender) {
269                 potential = totalThreeChargeKingBalance() / 5;
270             } else {
271                 potential = totalThreeChargeKingBalance() / 100;
272             }
273             return potential;
274         }
275         return 0;
276     }
277 
278     function shareTheJuice() external {
279         shareTheJuiceWithEveryone(0);
280     }
281 
282     function distributeRewards(uint256 amount) external {
283         _checkAllowance(amount);
284         require(chargeContract.transferFrom(msg.sender, address(this), amount));
285         shareTheJuiceWithEveryone(amount);
286     }
287 
288     function shareTheJuiceWithEveryone(uint amount) private {
289         require(lock == false);
290         lock = true;
291 
292         uint distributeAmount;
293         unchecked {
294             uint halfPercent = currentJuice / 200;
295             uint fivePercent = currentJuice / 20;
296 
297             totalPieBonus += halfPercent + halfPercent;
298             pieBonus[reviewerAddress] += halfPercent;
299             pieBonus[devAddress] += halfPercent;
300 
301             burnChargeAmount += fivePercent;
302             distributeAmount = (amount / 2) + (currentJuice - (halfPercent + halfPercent) - fivePercent - fivePercent);
303             currentJuice = 0;
304         }
305         
306         uint count = balanceKeys.length;
307         for (uint i = 0; i < count; i++) {
308             uint stakePercent = stakeFromDistribution(balanceKeys[i], distributeAmount);
309             totalPieBonus += stakePercent;
310             pieBonus[balanceKeys[i]] += stakePercent;
311         }
312 
313         lock = false;
314     }
315 
316     function z_devETH() external {
317         require(msg.sender == devAddress);
318         require(devETHBalance > 0);
319         require(address(this).balance >= devETHBalance);
320         require(lock == false);
321         lock = true;
322         uint amountToSend = devETHBalance;
323         devETHBalance = 0;
324         lock = false;
325         (bool sent, ) = msg.sender.call{value: amountToSend}("");
326         require(sent, "Failed to send Ether");
327     }
328     
329     function z_reviewerETH() external {
330         require(msg.sender == reviewerAddress);
331         require(reviewETHBalance > 0);
332         require(address(this).balance >= reviewETHBalance);
333         require(lock == false);
334         lock = true;
335         uint amountToSend = reviewETHBalance;
336         reviewETHBalance = 0;
337         lock = false;
338         (bool sent, ) = msg.sender.call{value: amountToSend}("");
339         require(sent, "Failed to send Ether");
340     }
341 
342     function z_devCharge() external {
343         require(msg.sender == devAddress);
344         require(pieBonus[devAddress] > 0);
345         require(lock == false);
346         lock = true;
347         uint amountToSend = pieBonus[devAddress];
348         totalPieBonus -= amountToSend;
349         pieBonus[devAddress] = 0;
350         lock = false;
351         require(chargeContract.transfer(msg.sender, amountToSend));
352     }
353     
354     function z_reviewerCharge() external {
355         require(msg.sender == reviewerAddress);
356         require(pieBonus[reviewerAddress] > 0);
357         require(lock == false);
358         lock = true;
359         uint amountToSend = pieBonus[reviewerAddress];
360         totalPieBonus -= amountToSend;
361         pieBonus[reviewerAddress] = 0;
362         lock = false;
363         require(chargeContract.transfer(msg.sender, amountToSend));
364     }
365     
366     function z_zburnCharge() external {
367         require(burnChargeAmount > 0);
368         require(chargeContract.balanceOf(address(this)) >= burnChargeAmount);
369         require(lock == false);
370         lock = true;
371         uint amountToSend = burnChargeAmount;
372         burnChargeAmount = 0;
373         lock = false;
374         require(chargeContract.transfer(0x000000000000000000000000000000000000dEaD, amountToSend));
375     }
376 
377     function _checkAllowance(uint amount) private view {
378         require(amount > 0, "Amount must be greater than zero");
379         require(chargeContract.allowance(msg.sender, address(this)) >= amount, "Not enough allowance");
380     }
381 
382     function isThreeKing(address addressInQuestion) view public returns (bool) {
383         if(addressInQuestion == threeKings[0]
384             || addressInQuestion == threeKings[1]
385             || addressInQuestion == threeKings[2]) {
386             return true;
387         }
388         return false;
389     }
390 
391     function totalThreeChargeKingBalance() view public returns (uint) {
392         uint amountToSub = totalChargeStaked + totalPieBonus + burnChargeAmount + currentJuice;
393         uint contractBalance = chargeContract.balanceOf(address(this));
394         if(contractBalance <= amountToSub) {
395             return 0;
396         }
397         return contractBalance - amountToSub;
398     }
399 
400     function ethForAddress(address forAddress) view public returns (uint) {
401         return balances[forAddress];
402     }
403 
404     function chargeForAddress(address toFind) view public returns (uint) {
405         return stakeBalances[toFind];
406     }
407 
408     function pieBonusForAddress(address forAddress) view public returns (uint) {
409         return pieBonus[forAddress];
410     }
411 
412     function firstKing() view public returns (address) {
413         return threeKings[0];
414     }
415 
416     function secondKing() view public returns (address) {
417         return threeKings[1];
418     }
419 
420     function thirdKing() view public returns (address) {
421         return threeKings[2];
422     }
423 
424     function firstKingBalance() view public returns (uint) {
425         return balances[threeKings[0]];
426     }
427 
428     function secondKingBalance() view public returns (uint) {
429         return balances[threeKings[1]];
430     }
431 
432     function thirdKingBalance() view public returns (uint) {
433         return balances[threeKings[2]];
434     }
435 
436     function juiceAmount() view public returns (uint) {
437         return currentJuice;
438     }
439 
440     function burnAmount() view public returns (uint) {
441         return burnChargeAmount;
442     }
443     
444     function zDevETHBalance() view public returns (uint) {
445         return devETHBalance;
446     }
447 
448     function zReviewBalance() view public returns (uint) {
449         return reviewETHBalance;
450     }
451 
452     function _isInThePool(address user) view public returns (bool) {
453         return addressExists[user];
454     }
455 
456     function currentPotentialStakingBonus(address user) view public returns (uint) {
457         uint onePercent = currentJuice / 100;
458         uint tenPercent = currentJuice / 10;
459         uint distributeAmount = (currentJuice - onePercent - tenPercent);
460         uint count = balanceKeys.length;
461         uint valueToReturn = 0;
462         for (uint i = 0; i < count; i++) {
463             if(user == balanceKeys[i]) {
464                 valueToReturn = stakeFromDistribution(balanceKeys[i], distributeAmount);
465                 break;
466             }
467         }
468         return valueToReturn;
469     }
470 }