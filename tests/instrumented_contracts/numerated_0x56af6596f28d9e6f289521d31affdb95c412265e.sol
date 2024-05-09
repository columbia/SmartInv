1 pragma solidity 0.4.25;
2 
3 
4 /******************************************/
5 /*       Owned starts here           */
6 /******************************************/
7 
8 contract owned 
9 {
10     address public owner;
11     address public newOwner;
12 
13     event OwnershipTransferred(address indexed _from, address indexed _to);
14 
15     constructor() public
16     {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner
21     {
22         require(msg.sender == owner, "Sender not authorized.");
23         _;
24     }
25 
26     function transferOwnership(address _newOwner) public onlyOwner
27     {
28         require(_newOwner != address(0), "0x00 address not allowed.");
29         newOwner = _newOwner;
30     }
31 
32     function acceptOwnership() public
33     {
34         require(msg.sender == newOwner, "Sender not authorized.");
35         emit OwnershipTransferred(owner, newOwner);
36         owner = newOwner;
37         newOwner = address(0);
38     }
39 }
40 
41 
42 /******************************************/
43 /*       TokenERC20 starts here           */
44 /******************************************/
45 
46 contract TokenERC20
47 {
48 
49     string public name;
50     string public symbol;
51     uint8 public decimals;
52     uint256 public totalSupply;
53 
54     mapping(address => uint256) public balanceOf;
55     mapping(address => mapping(address => uint256)) public allowance;
56 
57     event Transfer(address indexed _from, address indexed _to, uint256 _value);
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59    
60     constructor() public
61     {
62         decimals = 18;                       // decimals  
63         totalSupply = 0;                     // initialSupply
64         name = "LOOiX";                      // Set the name for display purposes
65         symbol = "LOOIX";                    // Set the symbol for display purposes
66     }
67 
68     /**
69     * @dev Transfer token for a specified addresses
70     * @param _from The address to transfer from.
71     * @param _to The address to transfer to.
72     * @param _value The amount to be transferred.
73     */
74     function _transfer(address _from, address _to, uint256 _value) internal
75     {
76         require(_value > 0, "Transferred value has to be grater than 0."); 
77         require(_to != address(0), "0x00 address not allowed.");                      // Prevent transfer to 0x0 address.
78         require(balanceOf[_from] >= _value, "Not enough funds on sender address.");   // Check if the sender has enough
79         require(balanceOf[_to] + _value > balanceOf[_to], "Overflow protection.");    // Check for overflows
80         balanceOf[_from] -= _value;                                                   // Subtract from the sender
81         balanceOf[_to] += _value;                                                     // Add the same to the recipient
82         emit Transfer(_from, _to, _value);
83     }
84 
85     /**
86     * @dev Transfer tokens
87     * @param _to The address of the recipient
88     * @param _value the amount to send
89     */
90     function transfer(address _to, uint256 _value) public returns(bool success)
91     {
92         _transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97     * @dev Transfer tokens from other address
98     * @param _from The address of the sender
99     * @param _to The address of the recipient
100     * @param _value the amount to send
101     */
102     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success)
103     {
104         require(_value <= allowance[_from][msg.sender], "Funds not approved.");     // Check allowance
105         allowance[_from][msg.sender] -= _value;
106         _transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111     * @dev Set allowance for other address
112     * @param _spender The address authorized to spend
113     * @param _value the max amount they can spend
114     */
115     function approve(address _spender, uint256 _value) public returns(bool success)
116     {
117         require(_value == 0 || allowance[msg.sender][_spender] == 0, "Approved funds or value are not 0.");
118         allowance[msg.sender][_spender] = _value;
119         emit Approval(msg.sender, _spender, _value);
120         return true;
121     }
122 
123 }
124 
125 
126 /******************************************/
127 /*       TokenStaking starts here         */
128 /******************************************/
129 
130 contract TokenStaking
131 {
132 
133     uint256 internal stakeID;
134     uint256 internal threeMonthTime;
135     uint256 internal threeMonthPercentage;
136     uint256 internal sixMonthTime;
137     uint256 internal sixMonthPercentage;
138     uint256 internal twelveMonthTime;
139     uint256 internal twelveMonthPercentage;
140 
141     struct stakeInfo    // Struct for user vestings
142     {
143         uint256 endDate;
144         uint256 amount;
145         address initiator;
146         address receiver;
147     }
148 
149     mapping(address => uint256) public stakedBalanceOf;
150     mapping(uint256 => stakeInfo) internal vestings;
151     mapping(address => uint256[]) internal userVestingIDs;
152 
153     enum StakeOption {three, six, twelve}
154 
155     constructor() TokenStaking() public 
156     { 
157         stakeID = 0;
158        
159         threeMonthTime = 91 days;
160         threeMonthPercentage = 1005012520859401063; // e**(0.02*0.25)
161                                
162         sixMonthTime = 182 days;
163         sixMonthPercentage = 1020201340026755810; // e**(0.04*0.5)
164 
165         twelveMonthTime = 365 days;
166         twelveMonthPercentage = 1061836546545359622; // e**(0.06*1.0)
167     }
168 
169     /**
170     * @dev Function to get the stake info from a corresponding ID.
171     * @param _id uint256 The ID from which the stake info should be read.
172     * @return endDate uint256 specifying the seconds since the UNIX Epoch. amount uint256 specifying the amount that was staked plus the stake bonus.
173     */
174     function getStakeInfo(uint256 _id) external view returns(uint256 endDate, uint256 amount, address receiver, address initiator)
175     {
176         return (vestings[_id].endDate, vestings[_id].amount, vestings[_id].receiver, vestings[_id].initiator);
177     }
178     
179     /**
180     * @dev Function to get the stake IDs from a given address.
181     * @param _address address The address which staked tokens.
182     * @return Ids uint256[] An array of stake IDs from the given address.
183     */
184     function getStakeIDs(address _address) external view returns(uint256[] memory Ids)
185     {
186         return userVestingIDs[_address];
187     }
188 
189     /**
190     * @dev Stake an amount of tokens with one of three options.
191     * @param _amount uint256 The amount of tokens which will be staked.
192     * @param _option StakeOption An enum which decides how long a stake will be frozen (only 0, 1 and 2 are valid values).
193     * @return totalSupplyIncreaseds uint256 The total increase in supply from the staked tokens.
194     */
195     function _stake(uint256 _amount, StakeOption _option, address _receiver) internal returns(uint256 totalSupplyIncrease)
196     {
197         require(_option >= StakeOption.three && _option <= StakeOption.twelve);
198         
199         stakeInfo memory stakeStruct;
200         stakeStruct.endDate = 0;
201         stakeStruct.amount = 0;
202         stakeStruct.initiator = msg.sender;
203         stakeStruct.receiver = address(0);
204 
205         uint256 tempIncrease;
206 
207         if (_option == StakeOption.three) 
208         {
209             stakeStruct.endDate = now + threeMonthTime;
210             stakeStruct.amount = _amount * threeMonthPercentage / (10**18);
211             stakeStruct.initiator = msg.sender;
212             stakeStruct.receiver = _receiver;
213             tempIncrease = (_amount * (threeMonthPercentage - (10**18)) / (10**18));
214         } 
215         else if (_option == StakeOption.six)
216         {
217             stakeStruct.endDate = now + sixMonthTime;
218             stakeStruct.amount = _amount * sixMonthPercentage / (10**18);
219             stakeStruct.initiator = msg.sender;
220             stakeStruct.receiver = _receiver;
221             tempIncrease = (_amount * (sixMonthPercentage - (10**18)) / (10**18));
222         } 
223         else if (_option == StakeOption.twelve)
224         {
225             stakeStruct.endDate = now + twelveMonthTime;
226             stakeStruct.amount = _amount * twelveMonthPercentage / (10**18);
227             stakeStruct.initiator = msg.sender;
228             stakeStruct.receiver = _receiver;
229             tempIncrease = (_amount * (twelveMonthPercentage - (10**18)) / (10**18));
230         }
231 
232         stakeID = stakeID + 1;
233         vestings[stakeID] = stakeStruct;
234         _setVestingID(stakeID, stakeStruct.receiver);
235         stakedBalanceOf[msg.sender] += stakeStruct.amount;
236         return tempIncrease;
237     }
238 
239     /**
240     * @dev Function to set a new vesting ID on the userVestingIDs mapping. Free ID slots in the array will be overwritten.
241     * @param _id uint256 The new ID that has to be written in the corresponding mapping.
242     */
243     function _setVestingID(uint256 _id, address _receiver) internal
244     {
245         bool tempEntryWritten = false;
246         uint256 arrayLength = userVestingIDs[_receiver].length;
247 
248         if(arrayLength != 0)
249         {
250             for (uint256 i = 0; i < arrayLength; i++) 
251             {
252                 if (userVestingIDs[_receiver][i] == 0) 
253                 {
254                     userVestingIDs[_receiver][i] = _id;
255                     tempEntryWritten = true;
256                     break;
257                 } 
258             }
259 
260             if(!tempEntryWritten)
261             {
262                 userVestingIDs[_receiver].push(_id);
263             }
264         } 
265         else
266         {
267             userVestingIDs[_receiver].push(_id);
268         }
269     }
270 
271     /**
272     * @dev Redeem the staked tokens.
273     * @return amount uint256 The amount that has been redeemed.
274     */
275     function _redeem() internal returns(uint256 amount)
276     {
277         uint256[] memory IdArray = userVestingIDs[msg.sender];
278         uint256 tempAmount = 0;
279         uint256 finalAmount = 0;
280         address tempInitiator = address(0);
281 
282         for(uint256 i = 0; i < IdArray.length; i++)
283         {
284             if(IdArray[i] != 0 && vestings[IdArray[i]].endDate <= now)
285             {
286                 tempInitiator = vestings[IdArray[i]].initiator;
287                 tempAmount = vestings[IdArray[i]].amount;
288 
289                 stakedBalanceOf[tempInitiator] -= tempAmount;
290                 finalAmount += tempAmount;
291 
292                 // delete the vesting history
293                 delete userVestingIDs[msg.sender][i];
294                 delete vestings[IdArray[i]];
295             }
296         }
297 
298         require(finalAmount > 0, "No funds to redeem.");
299         return finalAmount;
300     }
301 }
302 
303 
304 /******************************************/
305 /*       LOOiXToken starts here       */
306 /******************************************/
307 
308 contract LOOiXToken is owned, TokenERC20, TokenStaking
309 {
310 
311     bool public mintingActive;
312     address public mintDelegate;
313     uint256 public unlockAt;
314     uint256 public ICO_totalSupply;
315     uint256 internal constant MAX_UINT = 2**256 - 1;
316 
317     mapping(address => uint256) public allocations;
318 
319     event Stake(address indexed _target, uint256 _amount);
320     event Redeem(address indexed _target, uint256 _amount);
321 
322     constructor() TokenERC20() public 
323     {
324         mintingActive = true;
325         mintDelegate = address(0);
326         unlockAt;
327     }
328 
329     /**
330     * @dev Modifier defines addresses allowed to mint. 
331     */
332     modifier mintingAllowed
333     {
334         require(msg.sender == owner || msg.sender == mintDelegate, "Sender not authorized.");
335         _;
336     }
337 
338     /**
339     * @dev Internal ERC20 transfer.
340     */
341     function _transfer(address _from, address _to, uint256 _value) internal
342     {
343         require(_value > 0, "Transferred value has to be grater than 0.");            // value has to be greater than 0
344         require(_to != address(0), "0x00 address not allowed.");                      // Prevent transfer to 0x0 address
345         require(balanceOf[_from] >= _value, "Not enough funds on sender address.");   // Check if the sender has enough
346         require(balanceOf[_to] + _value >= balanceOf[_to], "Overflow protection.");   // Check for overflows
347         balanceOf[_from] -= _value;                                                   // Subtract from the sender
348         balanceOf[_to] += _value;                                                     // Add the same to the recipient
349         emit Transfer(_from, _to, _value);
350     }
351 
352     /**
353     * @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance.
354     * @param _from Address to transfer from.
355     * @param _to Address to transfer to.
356     * @param _value Amount to transfer.
357     * @return Success of transfer.
358     */
359     function transferFrom(address _from, address _to, uint _value) public returns (bool success)
360     {
361         uint256 allowanceTemp = allowance[_from][msg.sender];
362         
363         require(allowanceTemp >= _value, "Funds not approved."); 
364         require(balanceOf[_from] >= _value, "Not enough funds on sender address.");
365         require(balanceOf[_to] + _value >= balanceOf[_to], "Overflow protection.");
366 
367         balanceOf[_to] += _value;
368         balanceOf[_from] -= _value;
369 
370         if (allowanceTemp < MAX_UINT) 
371         {
372             allowance[_from][msg.sender] -= _value;
373         }
374 
375         emit Transfer(_from, _to, _value);
376 
377         return true;
378     }
379 
380     /**
381     * @dev Set new mintDelegate address
382     * @param _newDelegate The address authorized to mint
383     */  
384     function setMintDelegate(address _newDelegate) external onlyOwner
385     {
386         require(_newDelegate != address(0), "0x00 address not allowed.");
387         mintDelegate = _newDelegate;
388     }
389     
390     /**
391     * @dev Set unlimited allowance for other address
392     * @param _controllerAddress The address authorized to spend
393     */   
394     function giveAccess(address _controllerAddress) external
395     {
396         require(msg.sender != owner, "Owner of contract can not use this function.");
397         require(_controllerAddress != address(0), "0x00 address not allowed.");
398         allowance[msg.sender][_controllerAddress] = MAX_UINT;
399         emit Approval(msg.sender, _controllerAddress, MAX_UINT);
400     }
401 
402     /**
403     * @dev Set allowance for other address to 0
404     * @param _controllerAddress The address authorized to spend
405     */   
406     function revokeAccess(address _controllerAddress) external
407     {
408         require(_controllerAddress != address(0), "0x00 address not allowed.");
409         allowance[msg.sender][_controllerAddress] = 0;
410     }
411 
412     /**
413     * @dev Withdraw all LOOiX on the contract.
414     */ 
415     function withdrawLOOiX() external onlyOwner
416     {
417         require(balanceOf[address(this)] > 0, "No funds available.");
418         _transfer(address(this), owner, balanceOf[address(this)]);
419     }
420 
421     /**
422     * @dev Bulk mint function for airdrops. 
423     * @param _address Address array to mint to.
424     * @param _mintAmount Amount array to mint.
425     */
426     function mintTokenBulk(address[] _address, uint256[] _mintAmount) external mintingAllowed
427     {
428         require(mintingActive, "The mint functions are not available anymore.");
429         uint256 tempAmount = 0;
430 
431         for (uint256 i = 0; i < _address.length; i++) 
432         {
433             if(balanceOf[_address[i]] + _mintAmount[i] >= balanceOf[_address[i]])
434             {
435                 balanceOf[_address[i]] += _mintAmount[i] * (10**18);
436                 tempAmount += _mintAmount[i] * (10**18);
437 
438                 emit Transfer(address(0), _address[i], _mintAmount[i] * (10**18));
439             }
440         }
441 
442         totalSupply += tempAmount;
443     }
444 
445     /**
446     * @dev Mint function for creating new tokens. 
447     * @param _target Address to mint to.
448     * @param _mintAmount Amount to mint.
449     */
450     function mintToken(address _target, uint256 _mintAmount) public mintingAllowed 
451     {
452         require(mintingActive, "The mint functions are not available anymore.");
453         require(_target != address(0), "0x00 address not allowed.");
454 
455         balanceOf[_target] += _mintAmount * (10**18);
456         totalSupply += _mintAmount * (10**18);
457 
458         emit Transfer(address(0), _target, _mintAmount * (10**18));
459     }
460 
461     /**
462     * @dev Stops the minting of the token. After this function is called, no new tokens can be minted using the mintToken or mintTokenBulk functions. Irreversible.
463     */
464     function terminateMinting() external onlyOwner 
465     {
466         require(mintingActive, "The mint functions are not available anymore.");
467         uint256 tempTotalSupply = totalSupply;
468 
469         tempTotalSupply = tempTotalSupply + (tempTotalSupply  * 666666666666666666 / 10**18);
470         totalSupply = tempTotalSupply;
471         ICO_totalSupply = tempTotalSupply;
472 
473         mintingActive = false;
474         unlockAt = now + 365 days;
475 
476         // 40% of the total token supply
477         allocations[0xefbDBA37BD0e825d43bac88Ce570dcEFf50373C2] = tempTotalSupply * 9500 / 100000;      // 9.5% - Founders Pot.
478         allocations[0x75dE233590c8Dd593CE1bB89d68e9f18Ecdf34C8] = tempTotalSupply * 9500 / 100000;      // 9.5% - Development and Management.
479         allocations[0x357C2e4253389CE79440e867E9De14E17Bb97D2E] = tempTotalSupply * 3120 / 100000;      // 3.12% - Bonuspool.
480         allocations[0xf35FF681cbb69b47488269CE2BA5CaA34133813A] = tempTotalSupply * 14250 / 100000;     // 14.25% - Marketing.
481 
482         balanceOf[0x2A809456adf8bd5A79D598e880f7Bd78e11B4A1c] += tempTotalSupply * 242 / 100000;        
483         balanceOf[0x36c321017a8d8655ec7a2b862328678932E53b87] += tempTotalSupply * 242 / 100000;        
484         balanceOf[0xc9ebc197Ee00C1E231817b4eb38322C364cFCFCD] += tempTotalSupply * 242 / 100000;
485         balanceOf[0x2BE34a67491c6b1f8e0cA3BAA1249c90686CF6FB] += tempTotalSupply * 726 / 100000;
486         balanceOf[0x1cF6725538AAcC9574108845D58cF2e89f62bbE9] += tempTotalSupply * 4 / 100000;
487         balanceOf[0xc6a3B6ED936bD18FD72e0ae2D50A10B82EF79851] += tempTotalSupply * 130 / 100000;
488         balanceOf[0x204Fb77569ca24C09e1425f979141536B89449E3] += tempTotalSupply * 130 / 100000;
489 
490         balanceOf[0xbE3Ece67B61Ef6D3Fd0F8b159d16A80BB04C0F7B] += tempTotalSupply * 164 / 100000;        // Bonuspool.
491         balanceOf[0x731953d4c9A01c676fb6b013688AA8D512F5Ec03] += tempTotalSupply * 500 / 100000;        // Development and Management.
492         balanceOf[0x84A81f3B42BD99Fd435B1498316F8705f84192bC] += tempTotalSupply * 500 / 100000;        // Founders Pot.
493         balanceOf[0xEAeC9b7382e5abEBe76Fc7BDd2Dc22BA1a338918] += tempTotalSupply * 750 / 100000;        // Marketing.
494     }
495 
496     /**
497     * @dev Public unlock allocated Tokens.
498     */
499     function unlock() public
500     {
501         require(!mintingActive, "Function not available as long as minting is possible.");
502         require(now > unlockAt, "Unlock date not reached.");
503         require(allocations[msg.sender] > 0, "No tokens to unlock.");
504         uint256 tempAmount;
505 
506         tempAmount = allocations[msg.sender];
507         allocations[msg.sender] = 0;
508         balanceOf[msg.sender] += tempAmount;
509     }
510 
511     /**
512     * @dev Public stake function to stake a given amount of tokens for one of the three options.
513     * @param _amount Amount to stake.
514     * @param _option StakeOption enum with values from 0 to 2.
515     * @return Success of stake.
516     */
517     function stake(uint256 _amount, StakeOption _option, address _receiver) external returns(bool success)
518     {
519         require(!mintingActive, "Function not available as long as minting is possible.");
520         require(balanceOf[msg.sender] >= _amount, "Not enough funds on sender address.");
521         require(_amount >= 100*(10**18), "Amount is less than 100 token.");
522         require(_receiver != address(0), "0x00 address not allowed.");
523         uint256 supplyIncrease;
524         uint256 finalBalance;
525 
526         supplyIncrease = _stake(_amount, _option, _receiver);
527         totalSupply += supplyIncrease;
528         balanceOf[msg.sender] -= _amount;
529         finalBalance = _amount + supplyIncrease;
530 
531         emit Stake(_receiver, _amount);
532         emit Transfer(msg.sender, _receiver, finalBalance);
533     
534         return true;
535     }
536     
537     /**
538     * @dev Public redeem function to redeem all redeemable tokens.
539     */
540     function redeem() public
541     {
542         require(userVestingIDs[msg.sender].length > 0, "No funds to redeem.");
543         uint256 amount;
544 
545         amount = _redeem();
546         balanceOf[msg.sender] += amount;
547         emit Redeem(msg.sender, amount); 
548     }
549 }