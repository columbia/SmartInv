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
79 * Stable Awareness Token - STA
80 */
81 contract ERC223Token_STA is ERC223, SafeMath, Ownable {
82     string public name;
83     string public symbol;
84     uint8 public decimals;
85     uint256 public totalSupply;
86     mapping(address => uint) balances;
87     
88     // stable:
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
108         icoEndBlock = 4230150;  // INIT                      // last block number for ICO
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
132         if (block.number <= icoEndBlock+14*3456) throw;           // allow to suicide STA token after around 2 weeks (25s/block) from the end of ICO
133         suicide(this); 
134     }
135     // /stable
136    
137     // Function to access name of token .
138     function name() constant returns (string _name) {
139         return name;
140     }
141     // Function to access symbol of token .
142     function symbol() constant returns (string _symbol) {
143         return symbol;
144     }
145     // Function to access decimals of token .
146     function decimals() constant returns (uint8 _decimals) {
147         return decimals;
148     }
149     // Function to access total supply of tokens .
150     function totalSupply() constant returns (uint256 _totalSupply) {
151         return totalSupply;
152     }
153     function minedTokenCount() constant returns (uint256 _minedTokenCount) {
154         return minedTokenCount;
155     }
156     function icoAddress() constant returns (address _icoAddress) {
157         return icoAddress;
158     }
159 
160     // Function that is called when a user or another contract wants to transfer funds .
161     function transfer(address _to, uint _value, bytes _data) returns (bool success) {
162         if(isContract(_to)) {
163             transferToContract(_to, _value, _data);
164         }
165         else {
166             transferToAddress(_to, _value, _data);
167         }
168         return true;
169     }
170   
171     // Standard function transfer similar to ERC20 transfer with no _data .
172     // Added due to backwards compatibility reasons .
173     function transfer(address _to, uint _value) returns (bool success) {
174         bytes memory empty;
175         if(isContract(_to)) {
176             transferToContract(_to, _value, empty);
177         }
178         else {
179             transferToAddress(_to, _value, empty);
180         }
181         return true;
182     }
183 
184     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
185     function isContract(address _addr) private returns (bool is_contract) {
186         uint length;
187         _addr = _addr;  // workaround for Mist's inability to compile
188         is_contract = is_contract;  // workaround for Mist's inability to compile
189         assembly {
190                 //retrieve the size of the code on target address, this needs assembly
191                 length := extcodesize(_addr)
192         }
193         if(length>0) {
194             return true;
195         }
196         else {
197             return false;
198         }
199     }
200 
201     //function that is called when transaction target is an address
202     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
203         if (balanceOf(msg.sender) < _value) throw;
204         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
205         balances[_to] = safeAdd(balanceOf(_to), _value);
206         Transfer(msg.sender, _to, _value, _data);
207         return true;
208     }
209   
210     //function that is called when transaction target is a contract
211     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
212         if (balanceOf(msg.sender) < _value) throw;
213         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
214         balances[_to] = safeAdd(balanceOf(_to), _value);
215         ContractReceiver receiver = ContractReceiver(_to);
216         receiver.tokenFallback(msg.sender, _value, _data);
217         Transfer(msg.sender, _to, _value, _data);
218         return true;
219     }
220 
221     function balanceOf(address _owner) constant returns (uint balance) {
222         return balances[_owner];
223     }
224 	
225     function burn(address _address, uint256 _value) returns (bool success) {
226         if (icoAddress == address(0)) throw;
227         if (msg.sender != owner && msg.sender != icoAddress) throw; // only owner and ico contract are allowed
228         if (balances[_address] < _value) throw;                     // Check if the sender has enough tokens
229         balances[_address] -= _value;                               // Subtract from the sender
230         totalSupply -= _value;                               
231         Burn(_address, _value);
232         return true;
233     }
234 	
235     /* setting ICO address for allowing execution from the ICO contract */
236     function setIcoAddress(address _address) onlyOwner {
237         if (icoAddress == address(0)) {
238             icoAddress = _address;
239         }    
240         else throw;
241     }
242 }
243 
244 /**
245 * Stable Token - STB
246 */
247 contract ERC223Token_STB is ERC223, SafeMath, Ownable {
248     string public name;
249     string public symbol;
250     uint8 public decimals;
251     uint256 public totalSupply;
252     mapping(address => uint) balances;
253     
254     // stable:
255     uint256 public maxSupply;
256     uint256 public icoEndBlock;
257     address public icoAddress;
258 	
259     function ERC223Token_STB() {
260         totalSupply = 0;                                     // Update total supply
261         maxSupply = 1000000000000;                           // Maximum possible supply of STB == 100M STB
262         name = "STABLE STB Token";                           // Set the name for display purposes
263         decimals = 4;                                        // Amount of decimals for display purposes
264         symbol = "STB";                                      // Set the symbol for display purposes
265         icoEndBlock = 4230150;  // INIT                      // last block number of ICO  // INIT PARAM             
266         //balances[msg.sender] = totalSupply;                // Give the creator all initial tokens       
267     }
268     
269     // Function to access max supply of tokens .
270     function maxSupply() constant returns (uint256 _maxSupply) {
271         return maxSupply;
272     }
273     // /stable
274   
275     // Function to access name of token .
276     function name() constant returns (string _name) {
277         return name;
278     }
279     // Function to access symbol of token .
280     function symbol() constant returns (string _symbol) {
281         return symbol;
282     }
283     // Function to access decimals of token .
284     function decimals() constant returns (uint8 _decimals) {
285         return decimals;
286     }
287     // Function to access total supply of tokens .
288     function totalSupply() constant returns (uint256 _totalSupply) {
289         return totalSupply;
290     }
291     function icoAddress() constant returns (address _icoAddress) {
292         return icoAddress;
293     }
294 
295     // Function that is called when a user or another contract wants to transfer funds .
296     function transfer(address _to, uint _value, bytes _data) returns (bool success) {
297         if(isContract(_to)) {
298             transferToContract(_to, _value, _data);
299         }
300         else {
301             transferToAddress(_to, _value, _data);
302         }
303         return true;
304     }
305   
306     // Standard function transfer similar to ERC20 transfer with no _data .
307     // Added due to backwards compatibility reasons .
308     function transfer(address _to, uint _value) returns (bool success) {
309         bytes memory empty;
310         if(isContract(_to)) {
311             transferToContract(_to, _value, empty);
312         }
313         else {
314             transferToAddress(_to, _value, empty);
315         }
316         return true;
317     }
318 
319     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
320     function isContract(address _addr) private returns (bool is_contract) {
321         uint length;
322         _addr = _addr;  // workaround for Mist's inability to compile
323         is_contract = is_contract;  // workaround for Mist's inability to compile
324         assembly {
325             //retrieve the size of the code on target address, this needs assembly
326             length := extcodesize(_addr)
327         }
328         if(length>0) {
329             return true;
330         }
331         else {
332             return false;
333         }
334     }
335 
336     //function that is called when transaction target is an address
337     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
338         if (balanceOf(msg.sender) < _value) throw;
339         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
340         balances[_to] = safeAdd(balanceOf(_to), _value);
341         Transfer(msg.sender, _to, _value, _data);
342         return true;
343     }
344   
345     //function that is called when transaction target is a contract
346     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
347         if (balanceOf(msg.sender) < _value) throw;
348         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
349         balances[_to] = safeAdd(balanceOf(_to), _value);
350         ContractReceiver receiver = ContractReceiver(_to);
351         receiver.tokenFallback(msg.sender, _value, _data);
352         Transfer(msg.sender, _to, _value, _data);
353         return true;
354     }
355 
356     function balanceOf(address _owner) constant returns (uint balance) {
357         return balances[_owner];
358     }
359 
360     /* setting ICO address for allowing execution from the ICO contract */
361     function setIcoAddress(address _address) onlyOwner {
362         if (icoAddress == address(0)) {
363             icoAddress = _address;
364         }    
365         else throw;
366     }
367 
368     /* mint new tokens */
369     function mint(address _receiver, uint256 _amount) {
370         if (icoAddress == address(0)) throw;
371         if (msg.sender != icoAddress && msg.sender != owner) throw;     // mint allowed only for ICO contract and owner
372         // if (block.number <= icoEndBlock) throw;                      // mint allowed only after ICO
373         if (safeAdd(totalSupply, _amount) > maxSupply) throw;
374         totalSupply = safeAdd(totalSupply, _amount); 
375         balances[_receiver] = safeAdd(balances[_receiver], _amount);
376         Transfer(0, _receiver, _amount, new bytes(0)); 
377     }
378     
379     function selfDestroy() onlyOwner { // TEST ONLY
380         suicide(this); 
381     }
382 }
383 
384 /* main contract - ICO */
385 contract StableICO is Ownable, SafeMath {
386     uint256 public crowdfundingTarget;         // ICO target, in wei
387     ERC223Token_STA public sta;                // address of STA token
388     ERC223Token_STB public stb;                // address of STB token
389     address public beneficiary;                // where the donation is transferred after successful ICO
390     uint256 public icoStartBlock;              // number of start block of ICO
391     uint256 public icoEndBlock;                // number of end block of ICO
392     bool public isIcoFinished;                 // boolean for ICO status - is ICO finished?
393     bool public isIcoSucceeded;                // boolean for ICO status - is crowdfunding target reached?
394     bool public isDonatedEthTransferred;       // boolean for ICO status - is donation transferred to the secure account?
395     bool public isStbMintedForStaEx;           // boolean for ICO status - is extra STB tokens minted for covering exchange of STA token?
396     uint256 public receivedStaAmount;          // amount of received STA tokens from rewarded miners
397     uint256 public totalFunded;                // amount of ETH donations
398     uint256 public ownersEth;                  // amount of ETH transferred to ICO contract by the owner
399     uint256 public oneStaIsStb;                // one STA value in STB
400     
401     struct Donor {                                                      // struct for ETH donations
402         address donorAddress;
403         uint256 ethAmount;
404         uint256 block;
405         bool exchangedOrRefunded;
406         uint256 stbAmount;
407     }
408     mapping (uint256 => Donor) public donations;                        // storage for ETH donations
409     uint256 public donationNum;                                         // counter of ETH donations
410 	
411     struct Miner {                                                      // struct for received STA tokens
412         address minerAddress;
413         uint256 staAmount;
414         uint256 block;
415         bool exchanged;
416         uint256 stbAmount;
417     }
418     mapping (uint256 => Miner) public receivedSta;                      // storage for received STA tokens
419     uint256 public minerNum;                                            // counter of STA receives
420 
421     /* This generates a public event on the blockchain that will notify clients */
422     event Transfer(address indexed from, address indexed to, uint256 value); 
423     
424     event MessageExchangeEthStb(address from, uint256 eth, uint256 stb);
425     event MessageExchangeStaStb(address from, uint256 sta, uint256 stb);
426     event MessageReceiveEth(address from, uint256 eth, uint256 block);
427     event MessageReceiveSta(address from, uint256 sta, uint256 block);
428     event MessageReceiveStb(address from, uint256 stb, uint256 block, bytes data);  // it should never happen
429     event MessageRefundEth(address donor_address, uint256 eth);
430   
431     /* constructor */
432     function StableICO() {
433         crowdfundingTarget = 200000000000000000; // INIT (test: 0.2 ETH)
434         sta = ERC223Token_STA(0xe1e8f9bd535384a345c2a7a29a15df8fc345ad9c);  // INIT
435         stb = ERC223Token_STB(0x1e46a3f0552c5acf8ced4fe21a789b412f0e792a);  // INIT
436         beneficiary = 0x29ef9329bc15b7c11d047217618186b52bb4c8ff;  // INIT
437         icoStartBlock = 4230000;  // INIT
438         icoEndBlock = 4230150;  // INIT
439     }		
440     
441     /* trigger rewarding the miner with STA token */
442     function claimMiningReward() public onlyOwner {
443         sta.claimMiningReward();
444     }
445 	
446     /* Receiving STA from miners - during and after ICO */
447     function tokenFallback(address _from, uint256 _value, bytes _data) {
448         if (block.number < icoStartBlock) throw;
449         if (msg.sender == address(sta)) {
450             if (_value < 50000000) throw; // minimum 0.5 STA
451             if (block.number < icoEndBlock+14*3456) {  // allow STA tokens exchange for around 14 days (25s/block) after ICO
452                 receivedSta[minerNum] = Miner(_from, _value, block.number, false, 0);
453                 minerNum += 1;
454                 receivedStaAmount = safeAdd(receivedStaAmount, _value);
455                 MessageReceiveSta(_from, _value, block.number);
456             } else throw;	
457         } else if(msg.sender == address(stb)) {
458             MessageReceiveStb(_from, _value, block.number, _data);
459         } else {
460             throw; // other tokens
461         }
462     }
463 
464     /* Receiving ETH */
465     function () payable {
466 
467         if (msg.value < 10000000000000000) throw;  // minimum 0.1 ETH  TEST: 0.01ETH
468 		
469         // before ICO (pre-ico)
470         if (block.number < icoStartBlock) {
471             if (msg.sender == owner) {
472                 ownersEth = safeAdd(ownersEth, msg.value);
473             } else {
474                 totalFunded = safeAdd(totalFunded, msg.value);
475                 donations[donationNum] = Donor(msg.sender, msg.value, block.number, false, 0);
476                 donationNum += 1;
477                 MessageReceiveEth(msg.sender, msg.value, block.number);
478             }    
479         } 
480         // during ICO
481         else if (block.number >= icoStartBlock && block.number <= icoEndBlock) {
482             if (msg.sender != owner) {
483                 totalFunded = safeAdd(totalFunded, msg.value);
484                 donations[donationNum] = Donor(msg.sender, msg.value, block.number, false, 0);
485                 donationNum += 1;
486                 MessageReceiveEth(msg.sender, msg.value, block.number);
487             } else ownersEth = safeAdd(ownersEth, msg.value);
488         }
489         // after ICO - first ETH transfer is returned to the sender
490         else if (block.number > icoEndBlock) {
491             if (!isIcoFinished) {
492                 isIcoFinished = true;
493                 msg.sender.transfer(msg.value);  // return ETH to the sender
494                 if (totalFunded >= crowdfundingTarget) {
495                     isIcoSucceeded = true;
496                     exchangeStaStb(0, minerNum);
497                     exchangeEthStb(0, donationNum);
498                     drawdown();
499                 } else {
500                     refund(0, donationNum);
501                 }	
502             } else {
503                 if (msg.sender != owner) throw;  // WARNING: senders ETH may be lost (if transferred after finished ICO)
504                 ownersEth = safeAdd(ownersEth, msg.value);
505             }    
506         } else {
507             throw;  // WARNING: senders ETH may be lost (if transferred after finished ICO)
508         }
509     }
510 
511     /* send STB to the miners who returned STA tokens - after successful ICO */
512     function exchangeStaStb(uint256 _from, uint256 _to) private {  
513         if (!isIcoSucceeded) throw;
514         if (_from >= _to) return;  // skip the function if there is invalid range given for loop
515         uint256 _sta2stb = 10**4; 
516         uint256 _wei2stb = 10**14; 
517 
518         if (!isStbMintedForStaEx) {
519             uint256 _mintAmount = (10*totalFunded)*5/1000 / _wei2stb;  // 0.5% extra STB minting for STA covering
520             oneStaIsStb = _mintAmount / 100;
521             stb.mint(address(this), _mintAmount);
522             isStbMintedForStaEx = true;
523         }	
524 			
525         /* exchange */
526         uint256 _toBurn = 0;
527         for (uint256 i = _from; i < _to; i++) {
528             if (receivedSta[i].exchanged) continue;  // skip already exchanged STA
529             stb.transfer(receivedSta[i].minerAddress, receivedSta[i].staAmount/_sta2stb * oneStaIsStb / 10**4);
530             receivedSta[i].exchanged = true;
531             receivedSta[i].stbAmount = receivedSta[i].staAmount/_sta2stb * oneStaIsStb / 10**4;
532             _toBurn += receivedSta[i].staAmount;
533             MessageExchangeStaStb(receivedSta[i].minerAddress, receivedSta[i].staAmount, 
534               receivedSta[i].staAmount/_sta2stb * oneStaIsStb / 10**4);
535         }
536         sta.burn(address(this), _toBurn);  // burn received and processed STA tokens
537     }
538 	
539     /* send STB to the donors - after successful ICO */
540     function exchangeEthStb(uint256 _from, uint256 _to) private { 
541         if (!isIcoSucceeded) throw;
542         if (_from >= _to) return;  // skip the function if there is invalid range given for loop
543         uint256 _wei2stb = 10**14; // calculate eth to stb exchange
544         uint _pb = (icoEndBlock - icoStartBlock)/4; 
545         uint _bonus;
546 
547         /* mint */
548         uint256 _mintAmount = 0;
549         for (uint256 i = _from; i < _to; i++) {
550             if (donations[i].exchangedOrRefunded) continue;  // skip already minted STB
551             if (donations[i].block < icoStartBlock + _pb) _bonus = 6;  // first period; bonus in %
552             else if (donations[i].block >= icoStartBlock + _pb && donations[i].block < icoStartBlock + 2*_pb) _bonus = 4;  // 2nd
553             else if (donations[i].block >= icoStartBlock + 2*_pb && donations[i].block < icoStartBlock + 3*_pb) _bonus = 2;  // 3rd
554             else _bonus = 0;  // 4th
555             _mintAmount += 10 * ( (100 + _bonus) * (donations[i].ethAmount / _wei2stb) / 100);
556         }
557         stb.mint(address(this), _mintAmount);
558 
559         /* exchange */
560         for (i = _from; i < _to; i++) {
561             if (donations[i].exchangedOrRefunded) continue;  // skip already exchanged ETH
562             if (donations[i].block < icoStartBlock + _pb) _bonus = 6;  // first period; bonus in %
563             else if (donations[i].block >= icoStartBlock + _pb && donations[i].block < icoStartBlock + 2*_pb) _bonus = 4;  // 2nd
564             else if (donations[i].block >= icoStartBlock + 2*_pb && donations[i].block < icoStartBlock + 3*_pb) _bonus = 2;  // 3rd
565             else _bonus = 0;  // 4th
566             stb.transfer(donations[i].donorAddress, 10 * ( (100 + _bonus) * (donations[i].ethAmount / _wei2stb) / 100) );
567             donations[i].exchangedOrRefunded = true;
568             donations[i].stbAmount = 10 * ( (100 + _bonus) * (donations[i].ethAmount / _wei2stb) / 100);
569             MessageExchangeEthStb(donations[i].donorAddress, donations[i].ethAmount, 
570               10 * ( (100 + _bonus) * (donations[i].ethAmount / _wei2stb) / 100));
571         }
572     }
573   
574     // send funds to the ICO beneficiary account - after successful ICO
575     function drawdown() private {
576         if (!isIcoSucceeded || isDonatedEthTransferred) throw;
577         beneficiary.transfer(totalFunded);  
578         isDonatedEthTransferred = true;
579     }
580   
581     /* refund ETH - after unsuccessful ICO */
582     function refund(uint256 _from, uint256 _to) private {
583         if (!isIcoFinished || isIcoSucceeded) throw;
584         if (_from >= _to) return;
585         for (uint256 i = _from; i < _to; i++) {
586             if (donations[i].exchangedOrRefunded) continue;
587             donations[i].donorAddress.transfer(donations[i].ethAmount);
588             donations[i].exchangedOrRefunded = true;
589             MessageRefundEth(donations[i].donorAddress, donations[i].ethAmount);
590         }
591     }
592     
593     // send owner's funds to the ICO owner - after ICO
594     function transferEthToOwner(uint256 _amount) public onlyOwner { 
595         if (!isIcoFinished || _amount <= 0 || _amount > ownersEth) throw;
596         owner.transfer(_amount); 
597         ownersEth -= _amount;
598     }    
599 
600     // send STB to the ICO owner - after ICO
601     function transferStbToOwner(uint256 _amount) public onlyOwner { 
602         if (!isIcoFinished || _amount <= 0) throw;
603         stb.transfer(owner, _amount); 
604     }    
605     
606     
607     /* backup functions to be executed "manually" - in case of a critical ethereum platform failure 
608       during automatic function execution */
609     function backup_finishIcoVars() public onlyOwner {
610         if (block.number <= icoEndBlock || isIcoFinished) throw;
611         isIcoFinished = true;
612         if (totalFunded >= crowdfundingTarget) isIcoSucceeded = true;
613     }
614     function backup_exchangeStaStb(uint256 _from, uint256 _to) public onlyOwner { 
615         exchangeStaStb(_from, _to);
616     }
617     function backup_exchangeEthStb(uint256 _from, uint256 _to) public onlyOwner { 
618         exchangeEthStb(_from, _to);
619     }
620     function backup_drawdown() public onlyOwner { 
621         drawdown();
622     }
623     function backup_drawdown_amount(uint256 _amount) public onlyOwner {
624         if (!isIcoSucceeded) throw;
625         beneficiary.transfer(_amount);  
626     }
627     function backup_refund(uint256 _from, uint256 _to) public onlyOwner { 
628         refund(_from, _to);
629     }
630     /* /backup */
631 
632     function selfDestroy() onlyOwner { // TEST ONLY
633         suicide(this); 
634     }
635 }