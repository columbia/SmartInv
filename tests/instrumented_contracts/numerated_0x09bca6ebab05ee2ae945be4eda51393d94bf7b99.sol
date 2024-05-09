1 pragma solidity ^0.4.11;
2 
3 /// @title STABLE Project ICO
4 /// @author Konrad Szałapak <konrad.szalapak@gmail.com>
5 
6 /*
7  * Ownable
8  *
9  * Base contract with an owner.
10  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
11  */
12 contract Ownable {
13     address public owner;
14 
15     function Ownable() {
16         owner = msg.sender;
17     }
18 
19     modifier onlyOwner() {
20         if (msg.sender != owner) {
21             throw;
22         }
23         _;
24     }
25 }
26   
27 /* New ERC23 contract interface */
28 contract ERC223 {
29     uint public totalSupply;
30     function balanceOf(address who) constant returns (uint);
31   
32     function name() constant returns (string _name);
33     function symbol() constant returns (string _symbol);
34     function decimals() constant returns (uint8 _decimals);
35     function totalSupply() constant returns (uint256 _supply);
36 
37     function transfer(address to, uint value) returns (bool ok);
38     function transfer(address to, uint value, bytes data) returns (bool ok);
39     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
40 }
41 
42 /*
43 * Contract that is working with ERC223 tokens
44 */
45 contract ContractReceiver {
46     function tokenFallback(address _from, uint _value, bytes _data);
47 }
48 
49 /**
50 * ERC23 token by Dexaran
51 *
52 * https://github.com/Dexaran/ERC23-tokens
53 */
54  
55  
56 /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
57 contract SafeMath {
58     uint256 constant public MAX_UINT256 =
59     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
60 
61     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
62         if (x > MAX_UINT256 - y) throw;
63         return x + y;
64     }
65 
66     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
67         if (x < y) throw;
68         return x - y;
69     }
70 
71     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
72         if (y == 0) return 0;
73         if (x > MAX_UINT256 / y) throw;
74         return x * y;
75     }
76 }
77 
78 /**
79 * STABLE Awareness Token - STA
80 */
81 contract ERC223Token_STA is ERC223, SafeMath, Ownable {
82     string public name;
83     string public symbol;
84     uint8 public decimals;
85     uint256 public totalSupply;
86     mapping(address => uint) balances;
87     
88     // stable params:
89     uint256 public icoEndBlock;                              // last block number of ICO 
90     uint256 public maxSupply;                                // maximum token supply
91     uint256 public minedTokenCount;                          // counter of mined tokens
92     address public icoAddress;                               // address of ICO contract    
93     uint256 private multiplier;                              // for managing token fractionals
94     struct Miner {                                           // struct for mined tokens data
95         uint256 block;
96         address minerAddress;
97     }
98     mapping (uint256 => Miner) public minedTokens;           // mined tokens data
99     event MessageClaimMiningReward(address indexed miner, uint256 block, uint256 sta);  // notifies clients about sta winning miner
100     event Burn(address indexed from, uint256 value);         // notifies clients about the amount burnt
101     
102     function ERC223Token_STA() {
103         decimals = 8;
104         multiplier = 10**uint256(decimals);
105         maxSupply = 10000000000;                             // Maximum possible supply == 100 STA
106         name = "STABLE STA Token";                           // Set the name for display purposes
107         symbol = "STA";                                      // Set the symbol for display purposes
108         icoEndBlock = 4332000;  // INIT                      // last block number for ICO
109         totalSupply = 0;                                     // Update total supply
110         // balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
111     }
112  
113     // trigger rewarding a miner with STA token:
114     function claimMiningReward() {  
115         if (icoAddress == address(0)) throw;                         // ICO address must be set up first
116         if (msg.sender != icoAddress && msg.sender != owner) throw;  // triggering enabled only for ICO or owner
117         if (block.number > icoEndBlock) throw;                       // rewarding enabled only before the end of ICO
118         if (minedTokenCount * multiplier >= maxSupply) throw; 
119         if (minedTokenCount > 0) {
120             for (uint256 i = 0; i < minedTokenCount; i++) {
121                 if (minedTokens[i].block == block.number) throw; 
122             }
123         }
124         totalSupply += 1 * multiplier;
125         balances[block.coinbase] += 1 * multiplier;                  // reward miner with one STA token
126         minedTokens[minedTokenCount] = Miner(block.number, block.coinbase);
127         minedTokenCount += 1;
128         MessageClaimMiningReward(block.coinbase, block.number, 1 * multiplier);
129     } 
130     
131     function selfDestroy() onlyOwner {
132         // allow to suicide STA token after around 2 weeks (25s/block) from the end of ICO
133         if (block.number <= icoEndBlock+14*3456) throw;
134         suicide(this); 
135     }
136     // /stable params
137    
138     // Function to access name of token .
139     function name() constant returns (string _name) {
140         return name;
141     }
142     // Function to access symbol of token .
143     function symbol() constant returns (string _symbol) {
144         return symbol;
145     }
146     // Function to access decimals of token .
147     function decimals() constant returns (uint8 _decimals) {
148         return decimals;
149     }
150     // Function to access total supply of tokens .
151     function totalSupply() constant returns (uint256 _totalSupply) {
152         return totalSupply;
153     }
154     function minedTokenCount() constant returns (uint256 _minedTokenCount) {
155         return minedTokenCount;
156     }
157     function icoAddress() constant returns (address _icoAddress) {
158         return icoAddress;
159     }
160 
161     // Function that is called when a user or another contract wants to transfer funds .
162     function transfer(address _to, uint _value, bytes _data) returns (bool success) {
163         if(isContract(_to)) {
164             transferToContract(_to, _value, _data);
165         }
166         else {
167             transferToAddress(_to, _value, _data);
168         }
169         return true;
170     }
171   
172     // Standard function transfer similar to ERC20 transfer with no _data .
173     // Added due to backwards compatibility reasons .
174     function transfer(address _to, uint _value) returns (bool success) {
175         bytes memory empty;
176         if(isContract(_to)) {
177             transferToContract(_to, _value, empty);
178         }
179         else {
180             transferToAddress(_to, _value, empty);
181         }
182         return true;
183     }
184 
185     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
186     function isContract(address _addr) private returns (bool is_contract) {
187         uint length;
188         _addr = _addr;  // workaround for Mist's inability to compile
189         is_contract = is_contract;  // workaround for Mist's inability to compile
190         assembly {
191                 //retrieve the size of the code on target address, this needs assembly
192                 length := extcodesize(_addr)
193         }
194         if(length>0) {
195             return true;
196         }
197         else {
198             return false;
199         }
200     }
201 
202     //function that is called when transaction target is an address
203     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
204         if (balanceOf(msg.sender) < _value) throw;
205         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
206         balances[_to] = safeAdd(balanceOf(_to), _value);
207         Transfer(msg.sender, _to, _value, _data);
208         return true;
209     }
210   
211     //function that is called when transaction target is a contract
212     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
213         if (balanceOf(msg.sender) < _value) throw;
214         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
215         balances[_to] = safeAdd(balanceOf(_to), _value);
216         ContractReceiver receiver = ContractReceiver(_to);
217         receiver.tokenFallback(msg.sender, _value, _data);
218         Transfer(msg.sender, _to, _value, _data);
219         return true;
220     }
221 
222     function balanceOf(address _owner) constant returns (uint balance) {
223         return balances[_owner];
224     }
225 	
226     function burn(address _address, uint256 _value) returns (bool success) {
227         if (icoAddress == address(0)) throw;
228         if (msg.sender != owner && msg.sender != icoAddress) throw; // only owner and ico contract are allowed
229         if (balances[_address] < _value) throw;                     // Check if the sender has enough tokens
230         balances[_address] -= _value;                               // Subtract from the sender
231         totalSupply -= _value;                               
232         Burn(_address, _value);
233         return true;
234     }
235 	
236     /* setting ICO address for allowing execution from the ICO contract */
237     function setIcoAddress(address _address) onlyOwner {
238         if (icoAddress == address(0)) {
239             icoAddress = _address;
240         }    
241         else throw;
242     }
243 }
244 
245 /**
246 * Stable Token - STB
247 */
248 contract ERC223Token_STB is ERC223, SafeMath, Ownable {
249     string public name;
250     string public symbol;
251     uint8 public decimals;
252     uint256 public totalSupply;
253     mapping(address => uint) balances;
254     
255     // stable params:
256     uint256 public maxSupply;
257     uint256 public icoEndBlock;
258     address public icoAddress;
259 	
260     function ERC223Token_STB() {
261         totalSupply = 0;                                     // Update total supply
262         maxSupply = 1000000000000;                           // Maximum possible supply of STB == 100M STB
263         name = "STABLE STB Token";                           // Set the name for display purposes
264         decimals = 4;                                        // Amount of decimals for display purposes
265         symbol = "STB";                                      // Set the symbol for display purposes
266         icoEndBlock = 4332000;  // INIT                      // last block number of ICO          
267         //balances[msg.sender] = totalSupply;                // Give the creator all initial tokens       
268     }
269     
270     // Function to access max supply of tokens .
271     function maxSupply() constant returns (uint256 _maxSupply) {
272         return maxSupply;
273     }
274     // /stable params
275   
276     // Function to access name of token .
277     function name() constant returns (string _name) {
278         return name;
279     }
280     // Function to access symbol of token .
281     function symbol() constant returns (string _symbol) {
282         return symbol;
283     }
284     // Function to access decimals of token .
285     function decimals() constant returns (uint8 _decimals) {
286         return decimals;
287     }
288     // Function to access total supply of tokens .
289     function totalSupply() constant returns (uint256 _totalSupply) {
290         return totalSupply;
291     }
292     function icoAddress() constant returns (address _icoAddress) {
293         return icoAddress;
294     }
295 
296     // Function that is called when a user or another contract wants to transfer funds .
297     function transfer(address _to, uint _value, bytes _data) returns (bool success) {
298         if(isContract(_to)) {
299             transferToContract(_to, _value, _data);
300         }
301         else {
302             transferToAddress(_to, _value, _data);
303         }
304         return true;
305     }
306   
307     // Standard function transfer similar to ERC20 transfer with no _data .
308     // Added due to backwards compatibility reasons .
309     function transfer(address _to, uint _value) returns (bool success) {
310         bytes memory empty;
311         if(isContract(_to)) {
312             transferToContract(_to, _value, empty);
313         }
314         else {
315             transferToAddress(_to, _value, empty);
316         }
317         return true;
318     }
319 
320     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
321     function isContract(address _addr) private returns (bool is_contract) {
322         uint length;
323         _addr = _addr;  // workaround for Mist's inability to compile
324         is_contract = is_contract;  // workaround for Mist's inability to compile
325         assembly {
326             //retrieve the size of the code on target address, this needs assembly
327             length := extcodesize(_addr)
328         }
329         if(length>0) {
330             return true;
331         }
332         else {
333             return false;
334         }
335     }
336 
337     //function that is called when transaction target is an address
338     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
339         if (balanceOf(msg.sender) < _value) throw;
340         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
341         balances[_to] = safeAdd(balanceOf(_to), _value);
342         Transfer(msg.sender, _to, _value, _data);
343         return true;
344     }
345   
346     //function that is called when transaction target is a contract
347     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
348         if (balanceOf(msg.sender) < _value) throw;
349         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
350         balances[_to] = safeAdd(balanceOf(_to), _value);
351         ContractReceiver receiver = ContractReceiver(_to);
352         receiver.tokenFallback(msg.sender, _value, _data);
353         Transfer(msg.sender, _to, _value, _data);
354         return true;
355     }
356 
357     function balanceOf(address _owner) constant returns (uint balance) {
358         return balances[_owner];
359     }
360 
361     /* setting ICO address for allowing execution from the ICO contract */
362     function setIcoAddress(address _address) onlyOwner {
363         if (icoAddress == address(0)) {
364             icoAddress = _address;
365         }    
366         else throw;
367     }
368 
369     /* mint new tokens */
370     function mint(address _receiver, uint256 _amount) {
371         if (icoAddress == address(0)) throw;
372         if (msg.sender != icoAddress && msg.sender != owner) throw;     // mint allowed only for ICO contract or owner
373         if (safeAdd(totalSupply, _amount) > maxSupply) throw;
374         totalSupply = safeAdd(totalSupply, _amount); 
375         balances[_receiver] = safeAdd(balances[_receiver], _amount);
376         Transfer(0, _receiver, _amount, new bytes(0)); 
377     }
378     
379 }
380 
381 /* main contract - ICO */
382 contract StableICO is Ownable, SafeMath {
383     uint256 public crowdfundingTarget;         // ICO target, in wei
384     ERC223Token_STA public sta;                // address of STA token
385     ERC223Token_STB public stb;                // address of STB token
386     address public beneficiary;                // where the donation is transferred after successful ICO
387     uint256 public icoStartBlock;              // number of start block of ICO
388     uint256 public icoEndBlock;                // number of end block of ICO
389     bool public isIcoFinished;                 // boolean for ICO status - is ICO finished?
390     bool public isIcoSucceeded;                // boolean for ICO status - is crowdfunding target reached?
391     bool public isDonatedEthTransferred;       // boolean for ICO status - is donation transferred to the secure account?
392     bool public isStbMintedForStaEx;           // boolean for ICO status - is extra STB tokens minted for covering exchange of STA token?
393     uint256 public receivedStaAmount;          // amount of received STA tokens from rewarded miners
394     uint256 public totalFunded;                // amount of ETH donations
395     uint256 public ownersEth;                  // amount of ETH transferred to ICO contract by the owner
396     uint256 public oneStaIsStb;                // one STA value in STB
397     
398     struct Donor {                                                      // struct for ETH donations
399         address donorAddress;
400         uint256 ethAmount;
401         uint256 block;
402         bool exchangedOrRefunded;
403         uint256 stbAmount;
404     }
405     mapping (uint256 => Donor) public donations;                        // storage for ETH donations
406     uint256 public donationNum;                                         // counter of ETH donations
407 	
408     struct Miner {                                                      // struct for received STA tokens
409         address minerAddress;
410         uint256 staAmount;
411         uint256 block;
412         bool exchanged;
413         uint256 stbAmount;
414     }
415     mapping (uint256 => Miner) public receivedSta;                      // storage for received STA tokens
416     uint256 public minerNum;                                            // counter of STA receives
417 
418     /* This generates a public event on the blockchain that will notify clients */
419     event Transfer(address indexed from, address indexed to, uint256 value); 
420     
421     event MessageExchangeEthStb(address from, uint256 eth, uint256 stb);
422     event MessageExchangeStaStb(address from, uint256 sta, uint256 stb);
423     event MessageReceiveEth(address from, uint256 eth, uint256 block);
424     event MessageReceiveSta(address from, uint256 sta, uint256 block);
425     event MessageReceiveStb(address from, uint256 stb, uint256 block, bytes data);  // it should never happen
426     event MessageRefundEth(address donor_address, uint256 eth);
427   
428     /* constructor */
429     function StableICO() {
430         crowdfundingTarget = 750000000000000000000; // INIT
431         sta = ERC223Token_STA(0x164489AB676C578bED0515dDCF92Ef37aacF9a29);  // INIT
432         stb = ERC223Token_STB(0x09bca6ebab05ee2ae945be4eda51393d94bf7b99);  // INIT
433         beneficiary = 0xb2e7579f84a8ddafdb376f9872916b7fcb8dbec0;  // INIT
434         icoStartBlock = 4232000;  // INIT
435         icoEndBlock = 4332000;  // INIT
436     }		
437     
438     /* trigger rewarding the miner with STA token */
439     function claimMiningReward() public onlyOwner {
440         sta.claimMiningReward();
441     }
442 	
443     /* Receiving STA from miners - during and after ICO */
444     function tokenFallback(address _from, uint256 _value, bytes _data) {
445         if (block.number < icoStartBlock) throw;
446         if (msg.sender == address(sta)) {
447             if (_value < 50000000) throw; // minimum 0.5 STA
448             if (block.number < icoEndBlock+14*3456) {  // allow STA tokens exchange for around 14 days (25s/block) after ICO
449                 receivedSta[minerNum] = Miner(_from, _value, block.number, false, 0);
450                 minerNum += 1;
451                 receivedStaAmount = safeAdd(receivedStaAmount, _value);
452                 MessageReceiveSta(_from, _value, block.number);
453             } else throw;	
454         } else if(msg.sender == address(stb)) {
455             MessageReceiveStb(_from, _value, block.number, _data);
456         } else {
457             throw; // other tokens
458         }
459     }
460 
461     /* Receiving ETH */
462     function () payable {
463 
464         if (msg.value < 100000000000000000) throw;  // minimum 0.1 ETH
465 		
466         // before ICO (pre-ico)
467         if (block.number < icoStartBlock) {
468             if (msg.sender == owner) {
469                 ownersEth = safeAdd(ownersEth, msg.value);
470             } else {
471                 totalFunded = safeAdd(totalFunded, msg.value);
472                 donations[donationNum] = Donor(msg.sender, msg.value, block.number, false, 0);
473                 donationNum += 1;
474                 MessageReceiveEth(msg.sender, msg.value, block.number);
475             }    
476         } 
477         // during ICO
478         else if (block.number >= icoStartBlock && block.number <= icoEndBlock) {
479             if (msg.sender != owner) {
480                 totalFunded = safeAdd(totalFunded, msg.value);
481                 donations[donationNum] = Donor(msg.sender, msg.value, block.number, false, 0);
482                 donationNum += 1;
483                 MessageReceiveEth(msg.sender, msg.value, block.number);
484             } else ownersEth = safeAdd(ownersEth, msg.value);
485         }
486         // after ICO - first ETH transfer is returned to the sender
487         else if (block.number > icoEndBlock) {
488             if (!isIcoFinished) {
489                 isIcoFinished = true;
490                 msg.sender.transfer(msg.value);  // return ETH to the sender
491                 if (totalFunded >= crowdfundingTarget) {
492                     isIcoSucceeded = true;
493                     exchangeStaStb(0, minerNum);
494                     exchangeEthStb(0, donationNum);
495                     drawdown();
496                 } else {
497                     refund(0, donationNum);
498                 }	
499             } else {
500                 if (msg.sender != owner) throw;  // WARNING: senders ETH may be lost (if transferred after finished ICO)
501                 ownersEth = safeAdd(ownersEth, msg.value);
502             }    
503         } else {
504             throw;  // WARNING: senders ETH may be lost (if transferred after finished ICO)
505         }
506     }
507 
508     /* send STB to the miners who returned STA tokens - after successful ICO */
509     function exchangeStaStb(uint256 _from, uint256 _to) private {  
510         if (!isIcoSucceeded) throw;
511         if (_from >= _to) return;  // skip the function if there is invalid range given for loop
512         uint256 _sta2stb = 10**4; 
513         uint256 _wei2stb = 10**14; 
514 
515         if (!isStbMintedForStaEx) {
516             uint256 _mintAmount = (10*totalFunded)*5/1000 / _wei2stb;  // 0.5% extra STB minting for STA covering
517             oneStaIsStb = _mintAmount / 100;
518             stb.mint(address(this), _mintAmount);
519             isStbMintedForStaEx = true;
520         }	
521 			
522         /* exchange */
523         uint256 _toBurn = 0;
524         for (uint256 i = _from; i < _to; i++) {
525             if (receivedSta[i].exchanged) continue;  // skip already exchanged STA
526             stb.transfer(receivedSta[i].minerAddress, receivedSta[i].staAmount/_sta2stb * oneStaIsStb / 10**4);
527             receivedSta[i].exchanged = true;
528             receivedSta[i].stbAmount = receivedSta[i].staAmount/_sta2stb * oneStaIsStb / 10**4;
529             _toBurn += receivedSta[i].staAmount;
530             MessageExchangeStaStb(receivedSta[i].minerAddress, receivedSta[i].staAmount, 
531               receivedSta[i].staAmount/_sta2stb * oneStaIsStb / 10**4);
532         }
533         sta.burn(address(this), _toBurn);  // burn received and processed STA tokens
534     }
535 	
536     /* send STB to the donors - after successful ICO */
537     function exchangeEthStb(uint256 _from, uint256 _to) private { 
538         if (!isIcoSucceeded) throw;
539         if (_from >= _to) return;  // skip the function if there is invalid range given for loop
540         uint256 _wei2stb = 10**14; // calculate eth to stb exchange
541         uint _pb = (icoEndBlock - icoStartBlock)/4; 
542         uint _bonus;
543 
544         /* mint */
545         uint256 _mintAmount = 0;
546         for (uint256 i = _from; i < _to; i++) {
547             if (donations[i].exchangedOrRefunded) continue;  // skip already minted STB
548             if (donations[i].block < icoStartBlock + _pb) _bonus = 6;  // first period; bonus in %
549             else if (donations[i].block >= icoStartBlock + _pb && donations[i].block < icoStartBlock + 2*_pb) _bonus = 4;  // 2nd
550             else if (donations[i].block >= icoStartBlock + 2*_pb && donations[i].block < icoStartBlock + 3*_pb) _bonus = 2;  // 3rd
551             else _bonus = 0;  // 4th
552             _mintAmount += 10 * ( (100 + _bonus) * (donations[i].ethAmount / _wei2stb) / 100);
553         }
554         stb.mint(address(this), _mintAmount);
555 
556         /* exchange */
557         for (i = _from; i < _to; i++) {
558             if (donations[i].exchangedOrRefunded) continue;  // skip already exchanged ETH
559             if (donations[i].block < icoStartBlock + _pb) _bonus = 6;  // first period; bonus in %
560             else if (donations[i].block >= icoStartBlock + _pb && donations[i].block < icoStartBlock + 2*_pb) _bonus = 4;  // 2nd
561             else if (donations[i].block >= icoStartBlock + 2*_pb && donations[i].block < icoStartBlock + 3*_pb) _bonus = 2;  // 3rd
562             else _bonus = 0;  // 4th
563             stb.transfer(donations[i].donorAddress, 10 * ( (100 + _bonus) * (donations[i].ethAmount / _wei2stb) / 100) );
564             donations[i].exchangedOrRefunded = true;
565             donations[i].stbAmount = 10 * ( (100 + _bonus) * (donations[i].ethAmount / _wei2stb) / 100);
566             MessageExchangeEthStb(donations[i].donorAddress, donations[i].ethAmount, 
567               10 * ( (100 + _bonus) * (donations[i].ethAmount / _wei2stb) / 100));
568         }
569     }
570   
571     // send funds to the ICO beneficiary account - after successful ICO
572     function drawdown() private {
573         if (!isIcoSucceeded || isDonatedEthTransferred) throw;
574         beneficiary.transfer(totalFunded);  
575         isDonatedEthTransferred = true;
576     }
577   
578     /* refund ETH - after unsuccessful ICO */
579     function refund(uint256 _from, uint256 _to) private {
580         if (!isIcoFinished || isIcoSucceeded) throw;
581         if (_from >= _to) return;
582         for (uint256 i = _from; i < _to; i++) {
583             if (donations[i].exchangedOrRefunded) continue;
584             donations[i].donorAddress.transfer(donations[i].ethAmount);
585             donations[i].exchangedOrRefunded = true;
586             MessageRefundEth(donations[i].donorAddress, donations[i].ethAmount);
587         }
588     }
589     
590     // send owner's funds to the ICO owner - after ICO
591     function transferEthToOwner(uint256 _amount) public onlyOwner { 
592         if (!isIcoFinished || _amount <= 0 || _amount > ownersEth) throw;
593         owner.transfer(_amount); 
594         ownersEth -= _amount;
595     }    
596 
597     // send STB to the ICO owner - after ICO
598     function transferStbToOwner(uint256 _amount) public onlyOwner { 
599         if (!isIcoFinished || _amount <= 0) throw;
600         stb.transfer(owner, _amount); 
601     }    
602     
603     
604     /* backup functions to be executed "manually" - in case of a critical ethereum platform failure 
605       during automatic function execution */
606     function backup_finishIcoVars() public onlyOwner {
607         if (block.number <= icoEndBlock || isIcoFinished) throw;
608         isIcoFinished = true;
609         if (totalFunded >= crowdfundingTarget) isIcoSucceeded = true;
610     }
611     function backup_exchangeStaStb(uint256 _from, uint256 _to) public onlyOwner { 
612         exchangeStaStb(_from, _to);
613     }
614     function backup_exchangeEthStb(uint256 _from, uint256 _to) public onlyOwner { 
615         exchangeEthStb(_from, _to);
616     }
617     function backup_drawdown() public onlyOwner { 
618         drawdown();
619     }
620     function backup_drawdown_amount(uint256 _amount) public onlyOwner {
621         if (!isIcoSucceeded) throw;
622         beneficiary.transfer(_amount);  
623     }
624     function backup_refund(uint256 _from, uint256 _to) public onlyOwner { 
625         refund(_from, _to);
626     }
627     /* /backup */
628  
629 }