1 // SIMPLECOIN TOKEN
2 // simplecoin.co
3 //
4 // SMP token is a virtual token, governed by ERC20-compatible Ethereum Smart Contract and secured by Ethereum Blockchain
5 // The official website is https://www.simplecoin.co
6 //
7 // The uints are all in wei and WEI tokens (*10^-18)
8 
9 // The contract code itself, as usual, is at the end, after all the connected libraries
10 
11 pragma solidity ^0.4.11;
12 
13 /**
14  * Math operations with safety checks
15  */
16 
17 library SafeMath {
18   function mul(uint a, uint b) internal returns (uint) {
19     uint c = a * b;
20     validate(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint a, uint b) internal returns (uint) {
25     validate(b > 0);
26     uint c = a / b;
27     validate(a == b * c + a % b);
28     return c;
29   }
30 
31   function sub(uint a, uint b) internal returns (uint) {
32     validate(b <= a);
33     return a - b;
34   }
35 
36   function add(uint a, uint b) internal returns (uint) {
37     uint c = a + b;
38     validate(c >= a);
39     return c;
40   }
41 
42   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
43     return a >= b ? a : b;
44   }
45 
46   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
47     return a < b ? a : b;
48   }
49 
50   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
51     return a >= b ? a : b;
52   }
53 
54   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
55     return a < b ? a : b;
56   }
57 
58   function validate(bool validation) internal {
59     if (!validation) {
60       revert();
61     }
62   }
63 }
64 
65 
66 /*
67  * ERC20Basic
68  * Simpler version of ERC20 interface
69  * see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20Basic {
72   uint public totalSupply;
73   function balanceOf(address who) constant returns (uint);
74   function transfer(address to, uint value);
75   event Transfer(address indexed from, address indexed to, uint value);
76 }
77 
78 
79 /*
80  * Basic token
81  * Basic version of StandardToken, with no allowances
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint;
85 
86   mapping(address => uint) balances;
87 
88   /*
89    * Fix for the ERC20 short address attack  
90    */
91   modifier onlyPayloadSize(uint size) {
92      if(msg.data.length < size + 4) {
93        revert();
94      }
95      _;
96   }
97 
98   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     Transfer(msg.sender, _to, _value);
102   }
103 
104   function balanceOf(address _owner) constant returns (uint balance) {
105     return balances[_owner];
106   }
107   
108 }
109 
110 /*
111  * ERC20 interface
112  * see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) constant returns (uint);
116   function transferFrom(address from, address to, uint value);
117   function approve(address spender, uint value);
118   event Approval(address indexed owner, address indexed spender, uint value);
119 }
120 
121 /**
122  * Standard ERC20 token
123  *
124  * https://github.com/ethereum/EIPs/issues/20
125  * Based on code by FirstBlood:
126  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is BasicToken, ERC20 {
129 
130   mapping (address => mapping (address => uint)) allowed;
131 
132   function transferFrom(address _from, address _to, uint _value) {
133     var _allowance = allowed[_from][msg.sender];
134 
135     // Check is not needed because sub(_allowance, _value) will already revert() if this condition is not met
136     // if (value > allowance) revert();
137 
138     balances[_to] = balances[_to].add(_value);
139     balances[_from] = balances[_from].sub(_value);
140     allowed[_from][msg.sender] = _allowance.sub(_value);
141     Transfer(_from, _to, _value);
142   }
143 
144   function approve(address _spender, uint _value) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147   }
148 
149   function allowance(address _owner, address _spender) constant returns (uint remaining) {
150     return allowed[_owner][_spender];
151   }
152 
153 }
154 
155 
156 /*
157  * Ownable
158  *
159  * Base contract with an owner.
160  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
161  */
162 contract Ownable {
163   address public owner;
164 
165   function Ownable() {
166     owner = msg.sender;
167   }
168 
169   modifier onlyOwner() {
170     if (msg.sender != owner) {
171       revert();
172     }
173     _;
174   }
175 
176   function transferOwnership(address newOwner) onlyOwner {
177     if (newOwner != address(0)) {
178       owner = newOwner;
179     }
180   }
181 
182 }
183 
184 
185 contract SIMPLECOIN is StandardToken, Ownable {
186     using SafeMath for uint;
187 
188     //--------------   Info for ERC20 explorers  -----------------//
189     string public name = "SIMPLECOIN";
190     string public symbol = "SIM";
191     uint public decimals = 18;
192 
193     //---------------------   Constants   ------------------------//
194     uint public constant WEI = 1000000000000000000;
195     uint public constant INITIAL_SUPPLY = 500000000 * WEI; // 500 mln SMP. Impossible to mint more than this
196     uint public constant ICO_START_TIME = 1507572447;
197     uint public constant PRICE = 600;
198 
199     uint public constant _ONE = 1 * WEI;
200     uint public constant _FIFTY = 50 * WEI;
201     uint public constant _HUNDRED = 100 * WEI;
202     uint public constant _FIVEHUNDRED = 500 * WEI;
203     uint public constant _THOUSAND = 1000 * WEI;
204     uint public constant _FIVETHOUSAND = 5000 * WEI;
205 
206     address public TEAM_WALLET = 0x08FB9bF8645c5f1B2540436C6352dA23eE843b50;
207     address public ICO_ADDRESS = 0x1c01C01C01C01c01C01c01c01c01C01c01c01c01;
208 
209     //----------------------  Variables  -------------------------//
210     uint public current_supply = 0; // Holding the number of all the coins in existence
211     uint public ico_starting_supply = 0; // How many WEI tokens were available for sale at the beginning of the ICO
212 
213     //-------------   Flags describing ICO stages   --------------//
214     bool public preMarketingSharesDistributed = false; // Prevents accidental re-distribution of shares
215     // private venture pre ico
216     bool public isPreICOPrivateOpened = false;
217     bool public isPreICOPrivateClosed = false;
218     // public pre ico
219     bool public isPreICOPublicOpened = false;
220     bool public isPreICOPublicClosed = false;
221     // public ico
222     bool public isICOOpened = false;
223     bool public isICOClosed = false;
224 
225     //----------------------   Events  ---------------------------//
226     event PreICOPrivateOpened();
227     event PreICOPrivateClosed();
228     event PreICOPublicOpened();
229     event PreICOPublicClosed();
230     event ICOOpened();
231     event ICOClosed();
232     event SupplyChanged(uint supply, uint old_supply);
233     event SMPAcquired(address account, uint amount_in_wei, uint amount_in_rkc);
234 
235     // *
236 
237     // Constructor
238     function SIMPLECOIN() {
239         // Some percentage of the tokens is already reserved by early employees and investors
240         // Here we're initializing their balances
241         distributeMarketingShares();
242     }
243 
244     // Sending ether directly to the contract invokes buy() and assigns tokens to the sender
245     function () payable {
246         buy();
247     }
248 
249     // *
250 
251     // Buy token by sending ether here
252     //
253     // You can also send the ether directly to the contract address
254     function buy() payable {
255         if (msg.value == 0) {
256             revert();
257         }
258 
259         // prevent from buying before starting preico or ico
260         if (!isPreICOPrivateOpened && !isPreICOPublicOpened && !isICOOpened) {
261             revert();
262         }
263 
264         if (isICOClosed) {
265             revert();
266         }
267 
268         // Deciding how many tokens can be bought with the ether received
269         uint tokens = getSMPTokensAmountPerEthInternal(msg.value);
270 
271         // Just in case
272         if (tokens > balances[ICO_ADDRESS]) { 
273             revert();
274         }
275 
276         // Transfer from the ICO pool
277         balances[ICO_ADDRESS] = balances[ICO_ADDRESS].sub(tokens); // if not enough, will revert()
278         balances[msg.sender] = balances[msg.sender].add(tokens);
279 
280         // Broadcasting the buying event
281         SMPAcquired(msg.sender, msg.value, tokens);
282     }
283 
284     // *
285 
286     // Functions for the contract owner
287     function openPreICOPrivate() onlyOwner {
288         if (isPreICOPrivateOpened) revert();
289         if (isPreICOPrivateClosed) revert();
290 
291         if (isPreICOPublicOpened) revert();
292         if (isPreICOPublicClosed) revert();
293 
294         if (isICOOpened) revert();
295         if (isICOClosed) revert();        
296 
297         isPreICOPrivateOpened = true;
298 
299         PreICOPrivateOpened();
300     }
301 
302     function closePreICOPrivate() onlyOwner {
303         if (!isPreICOPrivateOpened) revert();
304         if (isPreICOPrivateClosed) revert();
305 
306         if (isPreICOPublicOpened) revert();
307         if (isPreICOPublicClosed) revert();
308 
309         if (isICOOpened) revert();
310         if (isICOClosed) revert();
311 
312         isPreICOPrivateOpened = false;
313         isPreICOPrivateClosed = true;
314 
315         PreICOPrivateClosed();
316     }
317 
318     function openPreICOPublic() onlyOwner {
319         if (isPreICOPrivateOpened) revert();
320         if (!isPreICOPrivateClosed) revert();
321 
322         if (isPreICOPublicOpened) revert();
323         if (isPreICOPublicClosed) revert();
324 
325         if (isICOOpened) revert();
326         if (isICOClosed) revert();        
327 
328         isPreICOPublicOpened = true;
329 
330         PreICOPublicOpened();
331     }
332 
333     function closePreICOPublic() onlyOwner {
334         if (isPreICOPrivateOpened) revert();
335         if (!isPreICOPrivateClosed) revert();
336 
337         if (!isPreICOPublicOpened) revert();
338         if (isPreICOPublicClosed) revert();
339 
340         if (isICOOpened) revert();
341         if (isICOClosed) revert();
342 
343         isPreICOPublicOpened = false;
344         isPreICOPublicClosed = true;
345 
346         PreICOPublicClosed();
347     }
348 
349     function openICO() onlyOwner {
350         if (isPreICOPrivateOpened) revert();
351         if (!isPreICOPrivateClosed) revert();
352 
353         if (isPreICOPublicOpened) revert();
354         if (!isPreICOPublicClosed) revert();
355 
356         if (isICOOpened) revert();
357         if (isICOClosed) revert();
358 
359         isICOOpened = true;
360 
361         ICOOpened();
362     }
363 
364     function closeICO() onlyOwner {
365         if (isPreICOPrivateOpened) revert();
366         if (!isPreICOPrivateClosed) revert();
367 
368         if (isPreICOPublicOpened) revert();
369         if (!isPreICOPublicClosed) revert();
370 
371         if (!isICOOpened) revert();
372         if (isICOClosed) revert();
373 
374         isICOOpened = false;
375         isICOClosed = true;
376 
377         balances[ICO_ADDRESS] = 0;
378 
379         ICOClosed();
380     }
381 
382     function pullEtherFromContractAfterPreICOPrivate() onlyOwner {       
383         if (isPreICOPrivateOpened) revert();
384         if (!isPreICOPrivateClosed) revert();
385 
386         if (isPreICOPublicOpened) revert();
387         if (isPreICOPublicClosed) revert();
388 
389         if (isICOOpened) revert();
390         if (isICOClosed) revert();
391 
392         if (!TEAM_WALLET.send(this.balance)) {
393             revert();
394         }
395     }
396 
397     function pullEtherFromContractAfterPreICOPublic() onlyOwner {       
398         if (isPreICOPrivateOpened) revert();
399         if (!isPreICOPrivateClosed) revert();
400 
401         if (isPreICOPublicOpened) revert();
402         if (!isPreICOPublicClosed) revert();
403 
404         if (isICOOpened) revert();
405         if (isICOClosed) revert();
406 
407         if (!TEAM_WALLET.send(this.balance)) {
408             revert();
409         }
410     }
411 
412     function pullEtherFromContractAfterICO() onlyOwner {
413         if (isPreICOPrivateOpened) revert();
414         if (!isPreICOPrivateClosed) revert();
415 
416         if (isPreICOPublicOpened) revert();
417         if (!isPreICOPublicClosed) revert();
418 
419         if (isICOOpened) revert();
420         if (!isICOClosed) revert();
421 
422         if (!TEAM_WALLET.send(this.balance)) {
423             revert();
424         }
425     }
426 
427     // *
428 
429     // Some percentage of the tokens is already reserved for marketing
430     function distributeMarketingShares() onlyOwner {
431         // Making it impossible to call this function twice
432         if (preMarketingSharesDistributed) {
433             revert();
434         }
435 
436         preMarketingSharesDistributed = true;
437 
438         // Values are in WEI tokens
439         balances[0xAc5C2414dae4ADB07D82d40dE71B4Bc5E2b417fd] = 100000000 * WEI; // referral
440         balances[0x603D3e11E88dD9aDdc4D9AbE205C7C02e9e13483] = 20000000 * WEI; // social marketing
441         
442         current_supply = (100000000 + 20000000) * WEI;
443 
444         // Sending the rest to ICO pool
445         balances[ICO_ADDRESS] = INITIAL_SUPPLY.sub(current_supply);
446 
447         // Initializing the supply variables
448         ico_starting_supply = balances[ICO_ADDRESS];
449         current_supply = INITIAL_SUPPLY;
450         SupplyChanged(0, current_supply);
451     }
452 
453     // *
454 
455     // Some useful getters (although you can just query the public variables)
456 
457     function getPriceSMPTokensPerWei() public constant returns (uint result) {
458         return PRICE;
459     }
460 
461     /* function getSMPTokensAmountPerEthInternal(uint value) public payable returns (uint result) {     
462         return value * PRICE;
463     } */
464 
465     function getSMPTokensAmountPerEthInternal(uint value) public payable returns (uint result) {    
466         if (isPreICOPrivateOpened) {
467             if (value >= _FIFTY && value < _FIVEHUNDRED) {
468                 return (value + (value * 35) / 100) * PRICE;
469             }
470 
471             if (value >= _FIVEHUNDRED && value < _THOUSAND) {
472                 return (value + (value * 40) / 100) * PRICE;
473             }
474 
475             if (value >= _THOUSAND && value < _FIVETHOUSAND) {
476                 return (value + (value * 60) / 100) * PRICE;
477             }
478 
479             if (value >= _FIVETHOUSAND) {
480                 return (value + value) * PRICE;
481             }
482         }
483 
484         if (isPreICOPublicOpened) {
485             if (value >= _ONE && value < _HUNDRED) {
486                 return (value + (value * 20) / 100) * PRICE;
487             }
488 
489             if (value >= _HUNDRED && value < _FIVEHUNDRED) {
490                 return (value + (value * 30) / 100) * PRICE;
491             }
492 
493             if (value >= _FIVEHUNDRED && value < _THOUSAND) {
494                 return (value + (value * 40) / 100) * PRICE;
495             }
496 
497             if (value >= _THOUSAND) {
498                 return (value + (value * 50) / 100) * PRICE;
499             }
500         }
501 
502         return value * PRICE;
503     }
504 
505     function getSMPTokensAmountPerWei(uint value) public constant returns (uint result) {
506         return getSMPTokensAmountPerEthInternal(value);
507     }
508     function getSupply() public constant returns (uint result) {
509         return current_supply;
510     }
511     function getSMPTokensLeftForICO() public constant returns (uint result) {
512         return balances[ICO_ADDRESS];
513     }
514     function getSMPTokensBoughtInICO() public constant returns (uint result) {
515         return ico_starting_supply - getSMPTokensLeftForICO();
516     }
517     function getBalance(address addr) public constant returns (uint balance) {
518         return balances[addr];
519     }
520 
521     // *
522 
523     // Overriding payment functions to take control over the logic
524     modifier allowedPayments(address payer, uint value) {
525         // Don't allow to transfer coins until the ICO ends
526         if (isPreICOPrivateOpened || isPreICOPublicOpened || isICOOpened) {
527             revert();
528         }
529 
530         if (!isPreICOPrivateClosed || !isPreICOPublicClosed || !isICOClosed) {
531             revert();
532         }
533 
534         if (block.timestamp < ICO_START_TIME) {
535             revert();
536         }
537 
538         _;
539     }
540 
541     function transferFrom(address _from, address _to, uint _value) allowedPayments(_from, _value) {
542         super.transferFrom(_from, _to, _value);
543     }
544     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) allowedPayments(msg.sender, _value) {
545         super.transfer(_to, _value);
546     }
547 
548 }