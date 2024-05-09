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
196     uint public constant PRICE = 600;
197 
198     uint public constant _ONE = 1 * WEI;
199     uint public constant _FIFTY = 50 * WEI;
200     uint public constant _HUNDRED = 100 * WEI;
201     uint public constant _FIVEHUNDRED = 500 * WEI;
202     uint public constant _THOUSAND = 1000 * WEI;
203     uint public constant _FIVETHOUSAND = 5000 * WEI;
204 
205     address public TEAM_WALLET = 0x08FB9bF8645c5f1B2540436C6352dA23eE843b50;
206     address public ICO_ADDRESS = 0x1c01C01C01C01c01C01c01c01c01C01c01c01c01;
207 
208     //----------------------  Variables  -------------------------//
209     uint public current_supply = 0; // Holding the number of all the coins in existence
210     uint public ico_starting_supply = 0; // How many WEI tokens were available for sale at the beginning of the ICO
211 
212     //-------------   Flags describing ICO stages   --------------//
213     bool public preMarketingSharesDistributed = false; // Prevents accidental re-distribution of shares
214     // private venture pre ico
215     bool public isPreICOPrivateOpened = false;
216     bool public isPreICOPrivateClosed = false;
217     // public pre ico
218     bool public isPreICOPublicOpened = false;
219     bool public isPreICOPublicClosed = false;
220     // public ico
221     bool public isICOOpened = false;
222     bool public isICOClosed = false;
223 
224     //----------------------   Events  ---------------------------//
225     event PreICOPrivateOpened();
226     event PreICOPrivateClosed();
227     event PreICOPublicOpened();
228     event PreICOPublicClosed();
229     event ICOOpened();
230     event ICOClosed();
231     event SupplyChanged(uint supply, uint old_supply);
232     event SMPAcquired(address account, uint amount_in_wei, uint amount_in_rkc);
233 
234     // *
235 
236     // Constructor
237     function SIMPLECOIN() {
238         // Some percentage of the tokens is already reserved by early employees and investors
239         // Here we're initializing their balances
240         distributeMarketingShares();
241     }
242 
243     // Sending ether directly to the contract invokes buy() and assigns tokens to the sender
244     function () payable {
245         buy();
246     }
247 
248     // *
249 
250     // Buy token by sending ether here
251     //
252     // You can also send the ether directly to the contract address
253     function buy() payable {
254         if (msg.value == 0) {
255             revert();
256         }
257 
258         // prevent from buying before starting preico or ico
259         if (!isPreICOPrivateOpened && !isPreICOPublicOpened && !isICOOpened) {
260             revert();
261         }
262 
263         if (isICOClosed) {
264             revert();
265         }
266 
267         // Deciding how many tokens can be bought with the ether received
268         uint tokens = getSMPTokensAmountPerEthInternal(msg.value);
269 
270         // Just in case
271         if (tokens > balances[ICO_ADDRESS]) { 
272             revert();
273         }
274 
275         // Transfer from the ICO pool
276         balances[ICO_ADDRESS] = balances[ICO_ADDRESS].sub(tokens); // if not enough, will revert()
277         balances[msg.sender] = balances[msg.sender].add(tokens);
278 
279         // Broadcasting the buying event
280         SMPAcquired(msg.sender, msg.value, tokens);
281     }
282 
283     // *
284 
285     // Functions for the contract owner
286     function openPreICOPrivate() onlyOwner {
287         if (isPreICOPrivateOpened) revert();
288         if (isPreICOPrivateClosed) revert();
289 
290         if (isPreICOPublicOpened) revert();
291         if (isPreICOPublicClosed) revert();
292 
293         if (isICOOpened) revert();
294         if (isICOClosed) revert();        
295 
296         isPreICOPrivateOpened = true;
297 
298         PreICOPrivateOpened();
299     }
300 
301     function closePreICOPrivate() onlyOwner {
302         if (!isPreICOPrivateOpened) revert();
303         if (isPreICOPrivateClosed) revert();
304 
305         if (isPreICOPublicOpened) revert();
306         if (isPreICOPublicClosed) revert();
307 
308         if (isICOOpened) revert();
309         if (isICOClosed) revert();
310 
311         isPreICOPrivateOpened = false;
312         isPreICOPrivateClosed = true;
313 
314         PreICOPrivateClosed();
315     }
316 
317     function openPreICOPublic() onlyOwner {
318         if (isPreICOPrivateOpened) revert();
319         if (!isPreICOPrivateClosed) revert();
320 
321         if (isPreICOPublicOpened) revert();
322         if (isPreICOPublicClosed) revert();
323 
324         if (isICOOpened) revert();
325         if (isICOClosed) revert();        
326 
327         isPreICOPublicOpened = true;
328 
329         PreICOPublicOpened();
330     }
331 
332     function closePreICOPublic() onlyOwner {
333         if (isPreICOPrivateOpened) revert();
334         if (!isPreICOPrivateClosed) revert();
335 
336         if (!isPreICOPublicOpened) revert();
337         if (isPreICOPublicClosed) revert();
338 
339         if (isICOOpened) revert();
340         if (isICOClosed) revert();
341 
342         isPreICOPublicOpened = false;
343         isPreICOPublicClosed = true;
344 
345         PreICOPublicClosed();
346     }
347 
348     function openICO() onlyOwner {
349         if (isPreICOPrivateOpened) revert();
350         if (!isPreICOPrivateClosed) revert();
351 
352         if (isPreICOPublicOpened) revert();
353         if (!isPreICOPublicClosed) revert();
354 
355         if (isICOOpened) revert();
356         if (isICOClosed) revert();
357 
358         isICOOpened = true;
359 
360         ICOOpened();
361     }
362 
363     function closeICO() onlyOwner {
364         if (isPreICOPrivateOpened) revert();
365         if (!isPreICOPrivateClosed) revert();
366 
367         if (isPreICOPublicOpened) revert();
368         if (!isPreICOPublicClosed) revert();
369 
370         if (!isICOOpened) revert();
371         if (isICOClosed) revert();
372 
373         isICOOpened = false;
374         isICOClosed = true;
375 
376         balances[ICO_ADDRESS] = 0;
377 
378         ICOClosed();
379     }
380 
381     function pullEtherFromContractAfterPreICOPrivate() onlyOwner {       
382         if (isPreICOPrivateOpened) revert();
383         if (!isPreICOPrivateClosed) revert();
384 
385         if (isPreICOPublicOpened) revert();
386         if (isPreICOPublicClosed) revert();
387 
388         if (isICOOpened) revert();
389         if (isICOClosed) revert();
390 
391         if (!TEAM_WALLET.send(this.balance)) {
392             revert();
393         }
394     }
395 
396     function pullEtherFromContractAfterPreICOPublic() onlyOwner {       
397         if (isPreICOPrivateOpened) revert();
398         if (!isPreICOPrivateClosed) revert();
399 
400         if (isPreICOPublicOpened) revert();
401         if (!isPreICOPublicClosed) revert();
402 
403         if (isICOOpened) revert();
404         if (isICOClosed) revert();
405 
406         if (!TEAM_WALLET.send(this.balance)) {
407             revert();
408         }
409     }
410 
411     function pullEtherFromContractAfterICO() onlyOwner {
412         if (isPreICOPrivateOpened) revert();
413         if (!isPreICOPrivateClosed) revert();
414 
415         if (isPreICOPublicOpened) revert();
416         if (!isPreICOPublicClosed) revert();
417 
418         if (isICOOpened) revert();
419         if (!isICOClosed) revert();
420 
421         if (!TEAM_WALLET.send(this.balance)) {
422             revert();
423         }
424     }
425 
426     // *
427 
428     // Some percentage of the tokens is already reserved for marketing
429     function distributeMarketingShares() onlyOwner {
430         // Making it impossible to call this function twice
431         if (preMarketingSharesDistributed) {
432             revert();
433         }
434 
435         preMarketingSharesDistributed = true;
436 
437         // Values are in WEI tokens
438         balances[0xAc5C2414dae4ADB07D82d40dE71B4Bc5E2b417fd] = 100000000 * WEI; // referral
439         balances[0x603D3e11E88dD9aDdc4D9AbE205C7C02e9e13483] = 20000000 * WEI; // social marketing
440         
441         current_supply = (100000000 + 20000000) * WEI;
442 
443         // Sending the rest to ICO pool
444         balances[ICO_ADDRESS] = INITIAL_SUPPLY.sub(current_supply);
445 
446         // Initializing the supply variables
447         ico_starting_supply = balances[ICO_ADDRESS];
448         current_supply = INITIAL_SUPPLY;
449         SupplyChanged(0, current_supply);
450     }
451 
452     // *
453 
454     // Some useful getters (although you can just query the public variables)
455 
456     function getPriceSMPTokensPerWei() public constant returns (uint result) {
457         return PRICE;
458     }
459 
460     /* function getSMPTokensAmountPerEthInternal(uint value) public payable returns (uint result) {     
461         return value * PRICE;
462     } */
463 
464     function getSMPTokensAmountPerEthInternal(uint value) public payable returns (uint result) {    
465         if (isPreICOPrivateOpened) {
466             if (value >= _FIFTY && value < _FIVEHUNDRED) {
467                 return (value + (value * 35) / 100) * PRICE;
468             }
469 
470             if (value >= _FIVEHUNDRED && value < _THOUSAND) {
471                 return (value + (value * 40) / 100) * PRICE;
472             }
473 
474             if (value >= _THOUSAND && value < _FIVETHOUSAND) {
475                 return (value + (value * 60) / 100) * PRICE;
476             }
477 
478             if (value >= _FIVETHOUSAND) {
479                 return (value + value) * PRICE;
480             }
481         }
482 
483         if (isPreICOPublicOpened) {
484             if (value >= _ONE && value < _HUNDRED) {
485                 return (value + (value * 20) / 100) * PRICE;
486             }
487 
488             if (value >= _HUNDRED && value < _FIVEHUNDRED) {
489                 return (value + (value * 30) / 100) * PRICE;
490             }
491 
492             if (value >= _FIVEHUNDRED && value < _THOUSAND) {
493                 return (value + (value * 40) / 100) * PRICE;
494             }
495 
496             if (value >= _THOUSAND) {
497                 return (value + (value * 50) / 100) * PRICE;
498             }
499         }
500 
501         return value * PRICE;
502     }
503 
504     function getSMPTokensAmountPerWei(uint value) public constant returns (uint result) {
505         return getSMPTokensAmountPerEthInternal(value);
506     }
507     function getSupply() public constant returns (uint result) {
508         return current_supply;
509     }
510     function getSMPTokensLeftForICO() public constant returns (uint result) {
511         return balances[ICO_ADDRESS];
512     }
513     function getSMPTokensBoughtInICO() public constant returns (uint result) {
514         return ico_starting_supply - getSMPTokensLeftForICO();
515     }
516     function getBalance(address addr) public constant returns (uint balance) {
517         return balances[addr];
518     }
519 
520     function transferFrom(address _from, address _to, uint _value) {
521         super.transferFrom(_from, _to, _value);
522     }
523     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
524         super.transfer(_to, _value);
525     }
526 
527 }