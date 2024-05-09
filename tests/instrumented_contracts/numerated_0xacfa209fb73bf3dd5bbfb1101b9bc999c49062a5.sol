1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 /**
77  * @title VestedToken
78  * @dev The VestedToken contract implements ERC20 standard basics function and 
79  * - vesting for an address
80  * - token tradability delay
81  */
82 contract VestedToken {
83     using SafeMath for uint256;
84     
85     // Vested wallet address
86     address public vestedAddress;
87     // Vesting time
88     uint private constant VESTING_DELAY = 1 years;  
89     // Token will be tradable TOKEN_TRADABLE_DELAY after 
90     uint private constant TOKEN_TRADABLE_DELAY = 12 days;
91 
92     // True if aside tokens have already been minted after second round
93     bool public asideTokensHaveBeenMinted = false;
94     // When aside tokens have been minted ?
95     uint public asideTokensMintDate;
96 
97     mapping(address => uint256) balances;
98     mapping(address => mapping (address => uint256)) allowed;
99     
100     modifier transferAllowed { require(asideTokensHaveBeenMinted && now > asideTokensMintDate + TOKEN_TRADABLE_DELAY); _; }
101     
102     // Get the balance from an address
103     function balanceOf(address _owner) public constant returns (uint256) { return balances[_owner]; }  
104 
105     // transfer ERC20 function
106     function transfer(address _to, uint256 _value) transferAllowed public returns (bool success) {
107         require(_to != 0x0);
108         
109         // founders wallets is blocked 1 year
110         if (msg.sender == vestedAddress && (now < (asideTokensMintDate + VESTING_DELAY))) { revert(); }
111 
112         return privateTransfer(_to, _value);
113     }
114 
115     // transferFrom ERC20 function
116     function transferFrom(address _from, address _to, uint256 _value) transferAllowed public returns (bool success) {
117         require(_from != 0x0);
118         require(_to != 0x0);
119         
120         // founders wallet is blocked 1 year
121         if (_from == vestedAddress && (now < (asideTokensMintDate + VESTING_DELAY))) { revert(); }
122 
123         uint256 _allowance = allowed[_from][msg.sender];
124         balances[_from] = balances[_from].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         allowed[_from][msg.sender] = _allowance.sub(_value);
127         Transfer(_from, _to, _value);
128         
129         return true;
130     }
131 
132     // approve ERC20 function
133     function approve(address _spender, uint256 _value) public returns (bool success) {
134         allowed[msg.sender][_spender] = _value;
135         Approval(msg.sender, _spender, _value);
136         
137         return true;
138     }
139 
140     // allowance ERC20 function
141     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
142         return allowed[_owner][_spender];
143     }
144     
145     function privateTransfer (address _to, uint256 _value) private returns (bool success) {
146         balances[msg.sender] = balances[msg.sender].sub(_value);
147         balances[_to] = balances[_to].add(_value);
148         Transfer(msg.sender, _to, _value);
149         return true;
150     }
151     
152     // Events ERC20
153     event Transfer(address indexed _from, address indexed _to, uint256 _value);
154     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
155 }
156 
157 /**
158  * @title WhitelistsRegistration
159  * @dev This is an extension to add 2 levels whitelists to the crowdsale
160  */
161 contract WhitelistsRegistration is Ownable {
162     // List of whitelisted addresses for KYC under 10 ETH
163     mapping(address => bool) silverWhiteList;
164     
165     // List of whitelisted addresses for KYC over 10 ETH
166     mapping(address => bool) goldWhiteList;
167     
168     // Different stage from the ICO
169     enum WhiteListState {
170         // This address is not whitelisted
171         None,
172         // this address is on the silver whitelist
173         Silver,
174         // this address is on the gold whitelist
175         Gold
176     }
177     
178     address public whiteLister;
179 
180     event SilverWhitelist(address indexed _address, bool _isRegistered);
181     event GoldWhitelist(address indexed _address, bool _isRegistered);  
182     event SetWhitelister(address indexed newWhiteLister);
183     
184     /**
185     * @dev Throws if called by any account other than the owner or the whitelister.
186     */
187     modifier onlyOwnerOrWhiteLister() {
188         require((msg.sender == owner) || (msg.sender == whiteLister));
189     _;
190     }
191     
192     // Return registration status of an specified address
193     function checkRegistrationStatus(address _address) public constant returns (WhiteListState) {
194         if (goldWhiteList[_address]) { return WhiteListState.Gold; }
195         if (silverWhiteList[_address]) { return WhiteListState.Silver; }
196         return WhiteListState.None;
197     }
198     
199     // Change registration status for an address in the whitelist for KYC under 10 ETH
200     function changeRegistrationStatusForSilverWhiteList(address _address, bool _isRegistered) public onlyOwnerOrWhiteLister {
201         silverWhiteList[_address] = _isRegistered;
202         SilverWhitelist(_address, _isRegistered);
203     }
204     
205     // Change registration status for an address in the whitelist for KYC over 10 ETH
206     function changeRegistrationStatusForGoldWhiteList(address _address, bool _isRegistered) public onlyOwnerOrWhiteLister {
207         goldWhiteList[_address] = _isRegistered;
208         GoldWhitelist(_address, _isRegistered);
209     }
210     
211     // Change registration status for several addresses in the whitelist for KYC under 10 ETH
212     function massChangeRegistrationStatusForSilverWhiteList(address[] _targets, bool _isRegistered) public onlyOwnerOrWhiteLister {
213         for (uint i = 0; i < _targets.length; i++) {
214             changeRegistrationStatusForSilverWhiteList(_targets[i], _isRegistered);
215         }
216     } 
217     
218     // Change registration status for several addresses in the whitelist for KYC over 10 ETH
219     function massChangeRegistrationStatusForGoldWhiteList(address[] _targets, bool _isRegistered) public onlyOwnerOrWhiteLister {
220         for (uint i = 0; i < _targets.length; i++) {
221             changeRegistrationStatusForGoldWhiteList(_targets[i], _isRegistered);
222         }
223     }
224     
225     /**
226     * @dev Allows the current owner or whiteLister to transfer control of the whitelist to a newWhitelister.
227     * @param _newWhiteLister The address to transfer whitelist to.
228     */
229     function setWhitelister(address _newWhiteLister) public onlyOwnerOrWhiteLister {
230       require(_newWhiteLister != address(0));
231       SetWhitelister(_newWhiteLister);
232       whiteLister = _newWhiteLister;
233     }
234 }
235 
236 /**
237  * @title BCDToken
238  * @dev The BCDT crowdsale
239  */
240 contract BCDToken is VestedToken, WhitelistsRegistration {
241     
242     string public constant name = "Blockchain Certified Data Token";
243     string public constant symbol = "BCDT";
244     uint public constant decimals = 18;
245 
246     // Maximum contribution in ETH for silver whitelist 
247     uint private constant MAX_ETHER_FOR_SILVER_WHITELIST = 10 ether;
248     
249     // ETH/BCDT rate
250     uint public rateETH_BCDT = 13000;
251 
252     // Soft cap, if not reached contributors can withdraw their ethers
253     uint public softCap = 1800 ether;
254 
255     // Cap in ether of presale
256     uint public presaleCap = 1800 ether;
257     
258     // Cap in ether of Round 1 (presale cap + 1800 ETH)
259     uint public round1Cap = 3600 ether;    
260     
261     // BCD Reserve/Community Wallets
262     address public reserveAddress;
263     address public communityAddress;
264 
265     // Different stage from the ICO
266     enum State {
267         // ICO isn't started yet, initial state
268         Init,
269         // Presale has started
270         PresaleRunning,
271         // Presale has ended
272         PresaleFinished,
273         // Round 1 has started
274         Round1Running,
275         // Round 1 has ended
276         Round1Finished,
277         // Round 2 has started
278         Round2Running,
279         // Round 2 has ended
280         Round2Finished
281     }
282     
283     // Initial state is Init
284     State public currentState = State.Init;
285     
286     // BCDT total supply
287     uint256 public totalSupply = MAX_TOTAL_BCDT_TO_SELL;
288 
289     // How much tokens have been sold
290     uint256 public tokensSold;
291     
292     // Amount of ETH raised during ICO
293     uint256 private etherRaisedDuringICO;
294     
295     // Maximum total of BCDT Token sold during ITS
296     uint private constant MAX_TOTAL_BCDT_TO_SELL = 100000000 * 1 ether;
297 
298     // Token allocation per mille for reserve/community/founders
299     uint private constant RESERVE_ALLOCATION_PER_MILLE_RATIO =  200;
300     uint private constant COMMUNITY_ALLOCATION_PER_MILLE_RATIO =  103;
301     uint private constant FOUNDERS_ALLOCATION_PER_MILLE_RATIO =  30;
302     
303     // List of contributors/contribution in ETH
304     mapping(address => uint256) contributors;
305 
306     // Use to allow function call only if currentState is the one specified
307     modifier inStateInit()
308     {
309         require(currentState == State.Init); 
310         _; 
311     }
312 	
313     modifier inStateRound2Finished()
314     {
315         require(currentState == State.Round2Finished); 
316         _; 
317     }
318     
319     // Event call when aside tokens are minted
320     event AsideTokensHaveBeenAllocated(address indexed to, uint256 amount);
321     // Event call when a contributor withdraw his ethers
322     event Withdraw(address indexed to, uint256 amount);
323     // Event call when ICO state change
324     event StateChanged(uint256 timestamp, State currentState);
325 
326     // Constructor
327     function BCDToken() public {
328     }
329 
330     function() public payable {
331         require(currentState == State.PresaleRunning || currentState == State.Round1Running || currentState == State.Round2Running);
332 
333         // min transaction is 0.1 ETH
334         if (msg.value < 100 finney) { revert(); }
335 
336         // If you're not in any whitelist, you cannot continue
337         if (!silverWhiteList[msg.sender] && !goldWhiteList[msg.sender]) {
338             revert();
339         }
340 
341         // ETH sent by contributor
342         uint256 ethSent = msg.value;
343         
344         // how much ETH will be used for contribution
345         uint256 ethToUse = ethSent;
346 
347         // Address is only in the silver whitelist: contribution is capped
348         if (!goldWhiteList[msg.sender]) {
349             // Check if address has already contributed for maximum allowance
350             if (contributors[msg.sender] >= MAX_ETHER_FOR_SILVER_WHITELIST) {
351                 revert();
352             }
353             // limit the total contribution to MAX_ETHER_FOR_SILVER_WHITELIST
354             if (contributors[msg.sender].add(ethToUse) > MAX_ETHER_FOR_SILVER_WHITELIST) {
355                 ethToUse = MAX_ETHER_FOR_SILVER_WHITELIST.sub(contributors[msg.sender]);
356             }
357         }
358         
359          // Calculate how much ETH are available for this stage
360         uint256 ethAvailable = getRemainingEthersForCurrentRound();
361         uint rate = getBCDTRateForCurrentRound();
362 
363         // If cap of the round has been reached
364         if (ethAvailable <= ethToUse) {
365             // End the round
366             privateSetState(getEndedStateForCurrentRound());
367             // Only available ethers will be used to reach the cap
368             ethToUse = ethAvailable;
369         }
370         
371         // Calculate token amount to send in accordance to rate
372         uint256 tokenToSend = ethToUse.mul(rate);
373         
374         // Amount of tokens sold to the current contributors is added to total sold
375         tokensSold = tokensSold.add(tokenToSend);
376         // Amount of ethers used for the current contribution is added the total raised
377         etherRaisedDuringICO = etherRaisedDuringICO.add(ethToUse);
378         // Token balance updated for current contributor
379         balances[msg.sender] = balances[msg.sender].add(tokenToSend);
380         // Contribution is stored for an potential withdraw
381         contributors[msg.sender] = contributors[msg.sender].add(ethToUse);
382         
383         // Send back the unused ethers        
384         if (ethToUse < ethSent) {
385             msg.sender.transfer(ethSent.sub(ethToUse));
386         }
387         // Log token transfer operation
388         Transfer(0x0, msg.sender, tokenToSend); 
389     }
390 
391     // Allow contributors to withdraw after the end of the ICO if the softcap hasn't been reached
392     function withdraw() public inStateRound2Finished {
393         // Only contributors with positive ETH balance could Withdraw
394         if(contributors[msg.sender] == 0) { revert(); }
395         
396         // Withdraw is possible only if softcap has not been reached
397         require(etherRaisedDuringICO < softCap);
398         
399         // Get how much ethers sender has contribute
400         uint256 ethToSendBack = contributors[msg.sender];
401         
402         // Set contribution to 0 for the contributor
403         contributors[msg.sender] = 0;
404         
405         // Send back ethers
406         msg.sender.transfer(ethToSendBack);
407         
408         // Log withdraw operation
409         Withdraw(msg.sender, ethToSendBack);
410     }
411 
412     // At the end of the sale, mint the aside tokens for the reserve, community and founders
413     function mintAsideTokens() public onlyOwner inStateRound2Finished {
414 
415         // Reserve, community and founders address have to be set before mint aside tokens
416         require((reserveAddress != 0x0) && (communityAddress != 0x0) && (vestedAddress != 0x0));
417 
418         // Aside tokens can be minted only if softcap is reached
419         require(this.balance >= softCap);
420 
421         // Revert if aside tokens have already been minted 
422         if (asideTokensHaveBeenMinted) { revert(); }
423 
424         // Set minted flag and date
425         asideTokensHaveBeenMinted = true;
426         asideTokensMintDate = now;
427 
428         // If 100M sold, 50M more have to be mint (15 / 10 = * 1.5 = +50%)
429         totalSupply = tokensSold.mul(15).div(10);
430 
431         // 20% of total supply is allocated to reserve
432         uint256 _amountMinted = setAllocation(reserveAddress, RESERVE_ALLOCATION_PER_MILLE_RATIO);
433 
434         // 10.3% of total supply is allocated to community
435         _amountMinted = _amountMinted.add(setAllocation(communityAddress, COMMUNITY_ALLOCATION_PER_MILLE_RATIO));
436 
437         // 3% of total supply is allocated to founders
438         _amountMinted = _amountMinted.add(setAllocation(vestedAddress, FOUNDERS_ALLOCATION_PER_MILLE_RATIO));
439         
440         // the allocation is only 33.3%*150/100 = 49.95% of the token solds. It is therefore slightly higher than it should.
441         // to avoid that, we correct the real total number of tokens
442         totalSupply = tokensSold.add(_amountMinted);
443         // Send the eth to the owner of the contract
444         owner.transfer(this.balance);
445     }
446     
447     function setTokenAsideAddresses(address _reserveAddress, address _communityAddress, address _founderAddress) public onlyOwner {
448         require(_reserveAddress != 0x0 && _communityAddress != 0x0 && _founderAddress != 0x0);
449 
450         // Revert when aside tokens have already been minted 
451         if (asideTokensHaveBeenMinted) { revert(); }
452 
453         reserveAddress = _reserveAddress;
454         communityAddress = _communityAddress;
455         vestedAddress = _founderAddress;
456     }
457     
458     function updateCapsAndRate(uint _presaleCapInETH, uint _round1CapInETH, uint _softCapInETH, uint _rateETH_BCDT) public onlyOwner inStateInit {
459             
460         // Caps and rate are updatable until ICO starts
461         require(_round1CapInETH > _presaleCapInETH);
462         require(_rateETH_BCDT != 0);
463         
464         presaleCap = _presaleCapInETH * 1 ether;
465         round1Cap = _round1CapInETH * 1 ether;
466         softCap = _softCapInETH * 1 ether;
467         rateETH_BCDT = _rateETH_BCDT;
468     }
469     
470     function getRemainingEthersForCurrentRound() public constant returns (uint) {
471         require(currentState != State.Init); 
472         require(!asideTokensHaveBeenMinted);
473         
474         if((currentState == State.PresaleRunning) || (currentState == State.PresaleFinished)) {
475             // Presale cap is fixed in ETH
476             return presaleCap.sub(etherRaisedDuringICO);
477         }
478         if((currentState == State.Round1Running) || (currentState == State.Round1Finished)) {
479             // Round 1 cap is fixed in ETH
480             return round1Cap.sub(etherRaisedDuringICO);
481         }
482         if((currentState == State.Round2Running) || (currentState == State.Round2Finished)) {
483             // Round 2 cap is limited in tokens, 
484             uint256 remainingTokens = totalSupply.sub(tokensSold);
485             // ETH available is calculated from the number of remaining tokens regarding the rate
486             return remainingTokens.div(rateETH_BCDT);
487         }        
488     }   
489 
490     function getBCDTRateForCurrentRound() public constant returns (uint) {
491         require(currentState == State.PresaleRunning || currentState == State.Round1Running || currentState == State.Round2Running);              
492         
493         // ETH/BCDT rate during presale: 20% bonus
494         if(currentState == State.PresaleRunning) {
495             return rateETH_BCDT + rateETH_BCDT * 20 / 100;
496         }
497         // ETH/BCDT rate during presale: 10% bonus
498         if(currentState == State.Round1Running) {
499             return rateETH_BCDT + rateETH_BCDT * 10 / 100;
500         }
501         if(currentState == State.Round2Running) {
502             return rateETH_BCDT;
503         }        
504     }  
505 
506     function setState(State _newState) public onlyOwner {
507         privateSetState(_newState);
508     }
509     
510     function privateSetState(State _newState) private {
511         // no way to go back    
512         if(_newState <= currentState) { revert(); }
513         
514         currentState = _newState;
515         StateChanged(now, currentState);
516     }
517     
518     
519     function getEndedStateForCurrentRound() private constant returns (State) {
520         require(currentState == State.PresaleRunning || currentState == State.Round1Running || currentState == State.Round2Running);
521         
522         if(currentState == State.PresaleRunning) {
523             return State.PresaleFinished;
524         }
525         if(currentState == State.Round1Running) {
526             return State.Round1Finished;
527         }
528         if(currentState == State.Round2Running) {
529             return State.Round2Finished;
530         }        
531     }   
532 
533     function setAllocation(address _to, uint _ratio) private onlyOwner returns (uint256) {
534         // Aside token is a percentage of totalSupply
535         uint256 tokenAmountToTransfert = totalSupply.mul(_ratio).div(1000);
536         balances[_to] = balances[_to].add(tokenAmountToTransfert);
537         AsideTokensHaveBeenAllocated(_to, tokenAmountToTransfert);
538         Transfer(0x0, _to, tokenAmountToTransfert);
539         return tokenAmountToTransfert;
540     }
541 }