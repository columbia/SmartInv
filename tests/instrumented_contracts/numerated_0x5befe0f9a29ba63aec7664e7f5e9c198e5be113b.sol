1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 // accepted from zeppelin-solidity https://github.com/OpenZeppelin/zeppelin-solidity
36 /*
37  * ERC20 interface
38  * see https://github.com/ethereum/EIPs/issues/20
39  */
40 contract ERC20 {
41   uint public totalSupply;
42   function balanceOf(address _who) public constant returns (uint);
43   function allowance(address _owner, address _spender) public constant returns (uint);
44 
45   function transfer(address _to, uint _value) public returns (bool ok);
46   function transferFrom(address _from, address _to, uint _value) public returns (bool ok);
47   function approve(address _spender, uint _value) public returns (bool ok);
48   event Transfer(address indexed from, address indexed to, uint value);
49   event Approval(address indexed owner, address indexed spender, uint value);
50 }
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   // event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     // OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 contract DSTToken is ERC20, Ownable, SafeMath {
94 
95     // Token related informations
96     string public constant name = "Decentralize Silver Token";
97     string public constant symbol = "DST";
98     uint256 public constant decimals = 18; // decimal places
99 
100     uint256 public tokensPerEther = 1500;
101 
102     // MultiSig Wallet Address
103     address public DSTMultisig;
104 
105     // Wallet L,M,N and O address
106     address dstWalletLMNO;
107 
108     bool public startStop = false;
109 
110     mapping (address => uint256) public walletA;
111     mapping (address => uint256) public walletB; 
112     mapping (address => uint256) public walletC;
113     mapping (address => uint256) public walletF;
114     mapping (address => uint256) public walletG;
115     mapping (address => uint256) public walletH;
116 
117     mapping (address => uint256) public releasedA;
118     mapping (address => uint256) public releasedB; 
119     mapping (address => uint256) public releasedC;
120     mapping (address => uint256) public releasedF;
121     mapping (address => uint256) public releasedG; 
122     mapping (address => uint256) public releasedH;
123 
124     // Mapping of token balance and allowed address for each address with transfer limit
125     mapping (address => uint256) balances;
126     //mapping of allowed address for each address with tranfer limit
127     mapping (address => mapping (address => uint256)) allowed;
128 
129     struct WalletConfig{
130         uint256 start;
131         uint256 cliff;
132         uint256 duration;
133     }
134 
135     mapping (uint => address) public walletAddresses;
136     mapping (uint => WalletConfig) public allWalletConfig;
137 
138     // @param _dstWalletLMNO Ether Address for wallet L,M,N and O
139     // Only to be called by Owner of this contract
140     function setDSTWalletLMNO(address _dstWalletLMNO) onlyOwner external{
141         require(_dstWalletLMNO != address(0));
142         dstWalletLMNO = _dstWalletLMNO;
143     }
144 
145     // Owner can Set Multisig wallet
146     // @param _dstMultisig address of Multisig wallet.
147     function setDSTMultiSig(address _dstMultisig) onlyOwner external{
148         require(_dstMultisig != address(0));
149         DSTMultisig = _dstMultisig;
150     }
151 
152     function startStopICO(bool status) onlyOwner external{
153         startStop = status;
154     }
155 
156     function addWalletAddressAndTokens(uint _id, address _walletAddress, uint256 _tokens) onlyOwner external{
157         require(_walletAddress != address(0));
158         walletAddresses[_id] = _walletAddress;
159         balances[_walletAddress] = safeAdd(balances[_walletAddress],_tokens); // wallet tokens initialize        
160     }
161 
162     // function preAllocation(uint256 _walletId, uint256 _tokens) onlyOwner external{
163     //     require(_tokens > 0);
164     //     balances[walletAddresses[_walletId]] = safeAdd(balances[walletAddresses[_walletId]],_tokens); // wallet tokens initialize
165     // }
166 
167     function addWalletConfig(uint256 _id, uint256 _start, uint256 _cliff, uint256 _duration) onlyOwner external{
168         uint256 start = safeAdd(_start,now);
169         uint256 cliff = safeAdd(start,_cliff);
170         allWalletConfig[_id] = WalletConfig(
171             start,
172             cliff,
173             _duration
174         );
175     }
176 
177     function assignToken(address _investor,uint256 _tokens) external {
178         // Check investor address and tokens.Not allow 0 value
179         require(_investor != address(0) && _tokens > 0);
180         // Check wallet have enough token balance to assign
181         require(_tokens <= balances[msg.sender]);
182         
183         // Debit the tokens from the wallet
184         balances[msg.sender] = safeSub(balances[msg.sender],_tokens);
185         // Increasing the totalSupply
186         totalSupply = safeAdd(totalSupply, _tokens);
187 
188         // Assign tokens to the investor
189         if(msg.sender == walletAddresses[0]){
190             walletA[_investor] = safeAdd(walletA[_investor],_tokens);
191         }
192         else if(msg.sender == walletAddresses[1]){
193             walletB[_investor] = safeAdd(walletB[_investor],_tokens);
194         }
195         else if(msg.sender == walletAddresses[2]){
196             walletC[_investor] = safeAdd(walletC[_investor],_tokens);
197         }
198         else if(msg.sender == walletAddresses[5]){
199             walletF[_investor] = safeAdd(walletF[_investor],_tokens);
200         }
201         else if(msg.sender == walletAddresses[6]){
202             walletG[_investor] = safeAdd(walletG[_investor],_tokens);
203         }
204         else if(msg.sender == walletAddresses[7]){
205             walletH[_investor] = safeAdd(walletH[_investor],_tokens);
206         }
207         else{
208             revert();
209         }
210     }
211 
212     function assignTokenIJK(address _userAddress,uint256 _tokens) external {
213         require(msg.sender == walletAddresses[8] || msg.sender == walletAddresses[9] || msg.sender == walletAddresses[10]);
214         // Check investor address and tokens.Not allow 0 value
215         require(_userAddress != address(0) && _tokens > 0);
216         // Assign tokens to the investor
217         assignTokensWallet(msg.sender,_userAddress, _tokens);
218     }
219 
220     function withdrawToken() public {
221         //require(walletA[msg.sender] > 0 || walletB[msg.sender] > 0 || walletC[msg.sender] > 0);
222         uint256 currentBalance = 0;
223         if(walletA[msg.sender] > 0){
224             uint256 unreleasedA = getReleasableAmount(0,msg.sender);
225             walletA[msg.sender] = safeSub(walletA[msg.sender], unreleasedA);
226             currentBalance = safeAdd(currentBalance, unreleasedA);
227             releasedA[msg.sender] = safeAdd(releasedA[msg.sender], unreleasedA);
228         }
229         if(walletB[msg.sender] > 0){
230             uint256 unreleasedB = getReleasableAmount(1,msg.sender);
231             walletB[msg.sender] = safeSub(walletB[msg.sender], unreleasedB);
232             currentBalance = safeAdd(currentBalance, unreleasedB);
233             releasedB[msg.sender] = safeAdd(releasedB[msg.sender], unreleasedB);
234         }
235         if(walletC[msg.sender] > 0){
236             uint256 unreleasedC = getReleasableAmount(2,msg.sender);
237             walletC[msg.sender] = safeSub(walletC[msg.sender], unreleasedC);
238             currentBalance = safeAdd(currentBalance, unreleasedC);
239             releasedC[msg.sender] = safeAdd(releasedC[msg.sender], unreleasedC);
240         }
241         require(currentBalance > 0);
242         // Assign tokens to the sender
243         balances[msg.sender] = safeAdd(balances[msg.sender], currentBalance);
244     }
245 
246     function withdrawBonusToken() public {
247         //require(walletF[msg.sender] > 0 || walletG[msg.sender] > 0 || walletH[msg.sender] > 0);
248         uint256 currentBalance = 0;
249         if(walletF[msg.sender] > 0){
250             uint256 unreleasedF = getReleasableBonusAmount(5,msg.sender);
251             walletF[msg.sender] = safeSub(walletF[msg.sender], unreleasedF);
252             currentBalance = safeAdd(currentBalance, unreleasedF);
253             releasedF[msg.sender] = safeAdd(releasedF[msg.sender], unreleasedF);
254         }
255         if(walletG[msg.sender] > 0){
256             uint256 unreleasedG = getReleasableBonusAmount(6,msg.sender);
257             walletG[msg.sender] = safeSub(walletG[msg.sender], unreleasedG);
258             currentBalance = safeAdd(currentBalance, unreleasedG);
259             releasedG[msg.sender] = safeAdd(releasedG[msg.sender], unreleasedG);
260         }
261         if(walletH[msg.sender] > 0){
262             uint256 unreleasedH = getReleasableBonusAmount(7,msg.sender);
263             walletH[msg.sender] = safeSub(walletH[msg.sender], unreleasedH);
264             currentBalance = safeAdd(currentBalance, unreleasedH);
265             releasedH[msg.sender] = safeAdd(releasedH[msg.sender], unreleasedH);
266         }
267         require(currentBalance > 0);
268         // Assign tokens to the sender
269         balances[msg.sender] = safeAdd(balances[msg.sender], currentBalance);
270     }
271 
272     function getReleasableAmount(uint256 _walletId,address _beneficiary) public view returns (uint256){
273         uint256 totalBalance;
274 
275         if(_walletId == 0){
276             totalBalance = safeAdd(walletA[_beneficiary], releasedA[_beneficiary]);    
277             return safeSub(getData(_walletId,totalBalance), releasedA[_beneficiary]);
278         }
279         else if(_walletId == 1){
280             totalBalance = safeAdd(walletB[_beneficiary], releasedB[_beneficiary]);
281             return safeSub(getData(_walletId,totalBalance), releasedB[_beneficiary]);
282         }
283         else if(_walletId == 2){
284             totalBalance = safeAdd(walletC[_beneficiary], releasedC[_beneficiary]);
285             return safeSub(getData(_walletId,totalBalance), releasedC[_beneficiary]);
286         }
287         else{
288             revert();
289         }
290     }
291 
292     function getReleasableBonusAmount(uint256 _walletId,address _beneficiary) public view returns (uint256){
293         uint256 totalBalance;
294 
295         if(_walletId == 5){
296             totalBalance = safeAdd(walletF[_beneficiary], releasedF[_beneficiary]);    
297             return safeSub(getData(_walletId,totalBalance), releasedF[_beneficiary]);
298         }
299         else if(_walletId == 6){
300             totalBalance = safeAdd(walletG[_beneficiary], releasedG[_beneficiary]);
301             return safeSub(getData(_walletId,totalBalance), releasedG[_beneficiary]);
302         }
303         else if(_walletId == 7){
304             totalBalance = safeAdd(walletH[_beneficiary], releasedH[_beneficiary]);
305             return safeSub(getData(_walletId,totalBalance), releasedH[_beneficiary]);
306         }
307         else{
308             revert();
309         }
310     }
311 
312     function getData(uint256 _walletId,uint256 _totalBalance) public view returns (uint256) {
313         uint256 availableBalanceIn = safeDiv(safeMul(_totalBalance, safeSub(allWalletConfig[_walletId].cliff, allWalletConfig[_walletId].start)), allWalletConfig[_walletId].duration);
314         return safeMul(availableBalanceIn, safeDiv(getVestedAmount(_walletId,_totalBalance), availableBalanceIn));
315     }
316 
317     function getVestedAmount(uint256 _walletId,uint256 _totalBalance) public view returns (uint256) {
318         uint256 cliff = allWalletConfig[_walletId].cliff;
319         uint256 start = allWalletConfig[_walletId].start;
320         uint256 duration = allWalletConfig[_walletId].duration;
321 
322         if (now < cliff) {
323             return 0;
324         } else if (now >= safeAdd(start,duration)) {
325             return _totalBalance;
326         } else {
327             return safeDiv(safeMul(_totalBalance,safeSub(now,start)),duration);
328         }
329     }
330 
331     // Sale of the tokens. Investors can call this method to invest into DST Tokens
332     function() payable external {
333         // Allow only to invest in ICO stage
334         require(startStop);
335         // Sorry !! We only allow to invest with minimum 1 Ether as value
336         require(msg.value >= 1 ether);
337 
338         // multiply by exchange rate to get newly created token amount
339         uint256 createdTokens = safeMul(msg.value, tokensPerEther);
340 
341         // Call to Internal function to assign tokens
342         assignTokensWallet(walletAddresses[3],msg.sender, createdTokens);
343     }
344 
345     // DST accepts Cash Investment through manual process in Fiat Currency
346     // DST Team will assign the tokens to investors manually through this function
347     //@ param cashInvestor address of investor
348     //@ param assignedTokens number of tokens to give to investor
349     function cashInvestment(address cashInvestor, uint256 assignedTokens) onlyOwner external {
350         // Check if cashInvestor address is set or not
351         // By mistake tokens mentioned as 0, save the cost of assigning tokens.
352         require(cashInvestor != address(0) && assignedTokens > 0);
353 
354         // Call to Internal function to assign tokens
355         assignTokensWallet(walletAddresses[4],cashInvestor, assignedTokens);
356     }
357 
358     // // Function will transfer the tokens to investor's address
359     // // Common function code for Crowdsale Investor And Cash Investor 
360     // function assignTokens(address investor, uint256 tokens) internal {
361     //     // Creating tokens and  increasing the totalSupply
362     //     totalSupply = safeAdd(totalSupply, tokens);
363 
364     //     // Assign new tokens to the sender
365     //     balances[investor] = safeAdd(balances[investor], tokens);
366 
367     //     // Finally token created for sender, log the creation event
368     //     Transfer(0, investor, tokens);
369     // }
370 
371     // Function will transfer the tokens to investor's address
372     // Common function code for Crowdsale Investor And Cash Investor 
373     function assignTokensWallet(address walletAddress,address investor, uint256 tokens) internal {
374         // Check wallet have enough token balance to assign
375         require(tokens <= balances[walletAddress]);
376         // Creating tokens and  increasing the totalSupply
377         totalSupply = safeAdd(totalSupply, tokens);
378 
379         // Debit the tokens from wallet
380         balances[walletAddress] = safeSub(balances[walletAddress],tokens);
381         // Assign new tokens to the sender
382         balances[investor] = safeAdd(balances[investor], tokens);
383 
384         // Finally token created for sender, log the creation event
385         Transfer(0, investor, tokens);
386     }
387 
388     function finalizeCrowdSale() external{
389         // Check DST Multisig wallet set or not
390         require(DSTMultisig != address(0));
391         // Send fund to multisig wallet
392         require(DSTMultisig.send(address(this).balance));
393     }
394 
395     // @param _who The address of the investor to check balance
396     // @return balance tokens of investor address
397     function balanceOf(address _who) public constant returns (uint) {
398         return balances[_who];
399     }
400 
401     // @param _owner The address of the account owning tokens
402     // @param _spender The address of the account able to transfer the tokens
403     // @return Amount of remaining tokens allowed to spent
404     function allowance(address _owner, address _spender) public constant returns (uint) {
405         return allowed[_owner][_spender];
406     }
407 
408     //  Transfer `value` DST tokens from sender's account
409     // `msg.sender` to provided account address `to`.
410     // @param _to The address of the recipient
411     // @param _value The number of DST tokens to transfer
412     // @return Whether the transfer was successful or not
413     function transfer(address _to, uint _value) public returns (bool ok) {
414         //validate receiver address and value.Not allow 0 value
415         require(_to != 0 && _value > 0);
416         uint256 senderBalance = balances[msg.sender];
417         //Check sender have enough balance
418         require(senderBalance >= _value);
419         senderBalance = safeSub(senderBalance, _value);
420         balances[msg.sender] = senderBalance;
421         balances[_to] = safeAdd(balances[_to], _value);
422         Transfer(msg.sender, _to, _value);
423         return true;
424     }
425 
426     //  Transfer `value` DST tokens from sender 'from'
427     // to provided account address `to`.
428     // @param from The address of the sender
429     // @param to The address of the recipient
430     // @param value The number of miBoodle to transfer
431     // @return Whether the transfer was successful or not
432     function transferFrom(address _from, address _to, uint _value) public returns (bool ok) {
433         //validate _from,_to address and _value(Now allow with 0)
434         require(_from != 0 && _to != 0 && _value > 0);
435         //Check amount is approved by the owner for spender to spent and owner have enough balances
436         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value);
437         balances[_from] = safeSub(balances[_from],_value);
438         balances[_to] = safeAdd(balances[_to],_value);
439         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
440         Transfer(_from, _to, _value);
441         return true;
442     }
443 
444     //  `msg.sender` approves `spender` to spend `value` tokens
445     // @param spender The address of the account able to transfer the tokens
446     // @param value The amount of wei to be approved for transfer
447     // @return Whether the approval was successful or not
448     function approve(address _spender, uint _value) public returns (bool ok) {
449         //validate _spender address
450         require(_spender != 0);
451         allowed[msg.sender][_spender] = _value;
452         Approval(msg.sender, _spender, _value);
453         return true;
454     }
455 
456     // This method is only use for debit DSTToken from DST wallet L,M,N and O
457     // @dev Required state: is dstWalletLMNO set
458     // @param _walletAddress The address of the wallet from tokens debit
459     // @param token The number of DST tokens to debit
460     // @return Whether the debit was successful or not
461     function debitWalletLMNO(address _walletAddress,uint256 token) external onlyDSTWalletLMNO returns (bool){
462         // Check if DST wallet LMNO is set or not
463         require(dstWalletLMNO != address(0));
464         // Check wallet have enough token and token is valid
465         require(balances[_walletAddress] >= token && token > 0);
466         // Increasing the totalSupply
467         totalSupply = safeAdd(totalSupply, token);
468         // Debit tokens from wallet balance
469         balances[_walletAddress] = safeSub(balances[_walletAddress],token);
470         return true;
471     }
472 
473     // This method is only use for credit DSTToken to DST wallet L,M,N and O users
474     // @dev Required state: is dstWalletLMNO set
475     // @param claimAddress The address of the wallet user to credit tokens
476     // @param token The number of DST tokens to credit
477     // @return Whether the credit was successful or not
478     function creditWalletUserLMNO(address claimAddress,uint256 token) external onlyDSTWalletLMNO returns (bool){
479         // Check if DST wallet LMNO is set or not
480         require(dstWalletLMNO != address(0));
481         // Check claiment address and token is valid or not
482         require(claimAddress != address(0) && token > 0);
483         // Assign tokens to user
484         balances[claimAddress] = safeAdd(balances[claimAddress], token);
485         // balances[_walletAddress] = safeSub(balances[_walletAddress],token);
486         return true;
487     }
488 
489     // DSTWalletLMNO related modifer
490     // @dev Throws if called by any account other than the DSTWalletLMNO owner
491     modifier onlyDSTWalletLMNO() {
492         require(msg.sender == dstWalletLMNO);
493         _;
494     }
495 }