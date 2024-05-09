1 contract DSAuthority {
2     function canCall(
3         address src, address dst, bytes4 sig
4     ) constant returns (bool);
5 }
6 
7 contract DSAuthEvents {
8     event LogSetAuthority (address indexed authority);
9     event LogSetOwner     (address indexed owner);
10 }
11 
12 contract DSAuth is DSAuthEvents {
13     DSAuthority  public  authority;
14     address      public  owner;
15 
16     function DSAuth() {
17         owner = msg.sender;
18         LogSetOwner(msg.sender);
19     }
20 
21     function setOwner(address owner_)
22         auth
23     {
24         owner = owner_;
25         LogSetOwner(owner);
26     }
27 
28     function setAuthority(DSAuthority authority_)
29         auth
30     {
31         authority = authority_;
32         LogSetAuthority(authority);
33     }
34 
35     modifier auth {
36         assert(isAuthorized(msg.sender, msg.sig));
37         _;
38     }
39 
40     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
41         if (src == address(this)) {
42             return true;
43         } else if (src == owner) {
44             return true;
45         } else if (authority == DSAuthority(0)) {
46             return false;
47         } else {
48             return authority.canCall(src, this, sig);
49         }
50     }
51 
52     function assert(bool x) internal {
53         if (!x) throw;
54     }
55 }
56 
57 
58 
59 
60 
61 contract ERC20 {
62     function totalSupply() constant returns (uint supply);
63     function balanceOf( address who ) constant returns (uint value);
64     function allowance( address owner, address spender ) constant returns (uint _allowance);
65 
66     function transfer( address to, uint value) returns (bool ok);
67     function transferFrom( address from, address to, uint value) returns (bool ok);
68     function approve( address spender, uint value ) returns (bool ok);
69 
70     event Transfer( address indexed from, address indexed to, uint value);
71     event Approval( address indexed owner, address indexed spender, uint value);
72 }
73 
74 contract DSMath {
75     
76 
77     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
78         assert((z = x + y) >= x);
79     }
80 
81     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
82         assert((z = x - y) <= x);
83     }
84 
85     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
86         z = x * y;
87         assert(x == 0 || z / x == y);
88     }
89 
90     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
91         z = x / y;
92     }
93 
94     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
95         return x <= y ? x : y;
96     }
97     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
98         return x >= y ? x : y;
99     }
100 
101 
102 
103     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
104         assert((z = x + y) >= x);
105     }
106 
107     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
108         assert((z = x - y) <= x);
109     }
110 
111     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
112         z = x * y;
113         assert(x == 0 || z / x == y);
114     }
115 
116     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
117         z = x / y;
118     }
119 
120     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
121         return x <= y ? x : y;
122     }
123     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
124         return x >= y ? x : y;
125     }
126 
127 
128 
129     function imin(int256 x, int256 y) constant internal returns (int256 z) {
130         return x <= y ? x : y;
131     }
132     function imax(int256 x, int256 y) constant internal returns (int256 z) {
133         return x >= y ? x : y;
134     }
135 
136     /*
137     WAD math
138      */
139 
140     uint128 constant WAD = 10 ** 18;
141 
142     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
143         return hadd(x, y);
144     }
145 
146     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
147         return hsub(x, y);
148     }
149 
150     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
151         z = cast((uint256(x) * y + WAD / 2) / WAD);
152     }
153 
154     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
155         z = cast((uint256(x) * WAD + y / 2) / y);
156     }
157 
158     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
159         return hmin(x, y);
160     }
161     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
162         return hmax(x, y);
163     }
164 
165     /*
166     RAY math
167      */
168 
169     uint128 constant RAY = 10 ** 27;
170 
171     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
172         return hadd(x, y);
173     }
174 
175     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
176         return hsub(x, y);
177     }
178 
179     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
180         z = cast((uint256(x) * y + RAY / 2) / RAY);
181     }
182 
183     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
184         z = cast((uint256(x) * RAY + y / 2) / y);
185     }
186 
187     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
188         
189         
190         
191         
192         
193         
194         
195         
196         
197         
198         
199         
200         
201         
202 
203         z = n % 2 != 0 ? x : RAY;
204 
205         for (n /= 2; n != 0; n /= 2) {
206             x = rmul(x, x);
207 
208             if (n % 2 != 0) {
209                 z = rmul(z, x);
210             }
211         }
212     }
213 
214     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
215         return hmin(x, y);
216     }
217     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
218         return hmax(x, y);
219     }
220 
221     function cast(uint256 x) constant internal returns (uint128 z) {
222         assert((z = uint128(x)) == x);
223     }
224 
225 }
226 
227 contract IkuraStorage is DSMath, DSAuth {
228   
229   address[] ownerAddresses;
230 
231   
232   mapping(address => uint) coinBalances;
233 
234   
235   mapping(address => uint) tokenBalances;
236 
237   
238   mapping(address => mapping (address => uint)) coinAllowances;
239 
240   
241   uint _totalSupply = 0;
242 
243   
244   
245   
246   uint _transferFeeRate = 500;
247 
248   
249   
250   
251   uint8 _transferMinimumFee = 5;
252 
253   address tokenAddress;
254   address multiSigAddress;
255   address authorityAddress;
256 
257   
258   
259   
260   function IkuraStorage() DSAuth() {
261     /*address controllerAddress = 0x34c5605A4Ef1C98575DB6542179E55eE1f77A188;
262     owner = controllerAddress;
263     LogSetOwner(controllerAddress);*/
264   }
265 
266   function changeToken(address tokenAddress_) auth {
267     tokenAddress = tokenAddress_;
268   }
269 
270   function changeAssociation(address multiSigAddress_) auth {
271     multiSigAddress = multiSigAddress_;
272   }
273 
274   function changeAuthority(address authorityAddress_) auth {
275     authorityAddress = authorityAddress_;
276   }
277 
278   function totalSupply() auth returns (uint) {
279     return _totalSupply;
280   }
281   function addTotalSupply(uint amount) auth {
282     _totalSupply = add(_totalSupply, amount);
283   }
284   function subTotalSupply(uint amount) auth {
285     _totalSupply = sub(_totalSupply, amount);
286   }
287   function transferFeeRate() auth returns (uint) {
288     return _transferFeeRate;
289   }
290 
291   function setTransferFeeRate(uint newTransferFeeRate) auth returns (bool) {
292     _transferFeeRate = newTransferFeeRate;
293 
294     return true;
295   }
296 
297   
298   
299   
300 
301   function transferMinimumFee() auth returns (uint8) {
302     return _transferMinimumFee;
303   }
304 
305   function setTransferMinimumFee(uint8 newTransferMinimumFee) auth {
306     _transferMinimumFee = newTransferMinimumFee;
307   }
308 
309   function addOwnerAddress(address addr) internal returns (bool) {
310     ownerAddresses.push(addr);
311 
312     return true;
313   }
314 
315   function removeOwnerAddress(address addr) internal returns (bool) {
316     uint i = 0;
317 
318     while (ownerAddresses[i] != addr) { i++; }
319 
320     while (i < ownerAddresses.length - 1) {
321       ownerAddresses[i] = ownerAddresses[i + 1];
322       i++;
323     }
324 
325     ownerAddresses.length--;
326 
327     return true;
328   }
329 
330   function primaryOwner() auth returns (address) {
331     return ownerAddresses[0];
332   }
333 
334   function isOwnerAddress(address addr) auth returns (bool) {
335     for (uint i = 0; i < ownerAddresses.length; i++) {
336       if (ownerAddresses[i] == addr) return true;
337     }
338 
339     return false;
340   }
341 
342   function numOwnerAddress() auth constant returns (uint) {
343     return ownerAddresses.length;
344   }
345 
346   
347   
348   
349 
350   function coinBalance(address addr) auth returns (uint) {
351     return coinBalances[addr];
352   }
353 
354   function addCoinBalance(address addr, uint amount) auth returns (bool) {
355     coinBalances[addr] = add(coinBalances[addr], amount);
356 
357     return true;
358   }
359 
360   function subCoinBalance(address addr, uint amount) auth returns (bool) {
361     coinBalances[addr] = sub(coinBalances[addr], amount);
362 
363     return true;
364   }
365 
366   
367   
368   
369 
370   function tokenBalance(address addr) auth returns (uint) {
371     return tokenBalances[addr];
372   }
373 
374   function addTokenBalance(address addr, uint amount) auth returns (bool) {
375     tokenBalances[addr] = add(tokenBalances[addr], amount);
376 
377     if (tokenBalances[addr] > 0 && !isOwnerAddress(addr)) {
378       addOwnerAddress(addr);
379     }
380 
381     return true;
382   }
383 
384   function subTokenBalance(address addr, uint amount) auth returns (bool) {
385     tokenBalances[addr] = sub(tokenBalances[addr], amount);
386 
387     if (tokenBalances[addr] <= 0) {
388       removeOwnerAddress(addr);
389     }
390 
391     return true;
392   }
393 
394   
395   
396   
397 
398   function coinAllowance(address owner_, address spender) auth returns (uint) {
399     return coinAllowances[owner_][spender];
400   }
401 
402   function addCoinAllowance(address owner_, address spender, uint amount) auth returns (bool) {
403     coinAllowances[owner_][spender] = add(coinAllowances[owner_][spender], amount);
404 
405     return true;
406   }
407 
408   function subCoinAllowance(address owner_, address spender, uint amount) auth returns (bool) {
409     coinAllowances[owner_][spender] = sub(coinAllowances[owner_][spender], amount);
410 
411     return true;
412   }
413 
414   function setCoinAllowance(address owner_, address spender, uint amount) auth returns (bool) {
415     coinAllowances[owner_][spender] = amount;
416 
417     return true;
418   }
419 
420   function isAuthorized(address src, bytes4 sig) internal returns (bool) {
421     sig; 
422 
423     return  src == address(this) ||
424             src == owner ||
425             src == tokenAddress ||
426             src == authorityAddress ||
427             src == multiSigAddress;
428   }
429 }
430 
431 contract IkuraTokenEvent {
432   /** オーナーがdJPYを鋳造した際に発火するイベント */
433   event IkuraMint(address indexed owner, uint);
434 
435   /** オーナーがdJPYを消却した際に発火するイベント */
436   event IkuraBurn(address indexed owner, uint);
437 
438   /** トークンの移動時に発火するイベント */
439   event IkuraTransferToken(address indexed from, address indexed to, uint value);
440 
441   /** 手数料が発生したときに発火するイベント */
442   event IkuraTransferFee(address indexed from, address indexed to, address indexed owner, uint value);
443 
444   event IkuraTransfer(address indexed from, address indexed to, uint value);
445 
446   /** 送金許可イベント */
447   event IkuraApproval(address indexed owner, address indexed spender, uint value);
448 }
449 
450 contract IkuraAssociation is DSMath, DSAuth {
451   
452   
453   
454 
455   
456   uint public confirmTotalTokenThreshold = 50;
457 
458   
459   
460   
461 
462   
463   IkuraStorage _storage;
464   IkuraToken _token;
465 
466   
467   Proposal[] mintProposals;
468   Proposal[] burnProposals;
469   Proposal[] transferMinimumFeeProposals;
470   Proposal[] transferFeeRateProposals;
471 
472   mapping (bytes32 => Proposal[]) proposals;
473 
474   struct Proposal {
475     address proposer;                     
476     bytes32 digest;                       
477     bool executed;                        
478     uint createdAt;                       
479     uint expireAt;                        
480     address[] confirmers;                 
481     uint amount;                          
482     uint8 transferMinimumFee;             
483     uint transferFeeRate;                 
484   }
485 
486   
487   
488   
489 
490   event MintProposalAdded(uint proposalId, address proposer, uint amount);
491   event MintConfirmed(uint proposalId, address confirmer, uint amount);
492   event MintExecuted(uint proposalId, address proposer, uint amount);
493 
494   event BurnProposalAdded(uint proposalId, address proposer, uint amount);
495   event BurnConfirmed(uint proposalId, address confirmer, uint amount);
496   event BurnExecuted(uint proposalId, address proposer, uint amount);
497 
498   event TransferMinimumFeeProposalAdded(uint proposalId, address proposer, uint8 transferMinimumFee);
499   event TransferMinimumFeeConfirmed(uint proposalId, address confirmer, uint8 transferMinimumFee);
500   event TransferMinimumFeeExecuted(uint proposalId, address proposer, uint8 transferMinimumFee);
501 
502   event TransferFeeRateProposalAdded(uint proposalId, address proposer, uint transferFeeRate);
503   event TransferFeeRateConfirmed(uint proposalId, address confirmer, uint transferFeeRate);
504   event TransferFeeRateExecuted(uint proposalId, address proposer, uint transferFeeRate);
505 
506   function IkuraAssociation() {
507     proposals[sha3('mint')] = mintProposals;
508     proposals[sha3('burn')] = burnProposals;
509     proposals[sha3('transferMinimumFee')] = transferMinimumFeeProposals;
510     proposals[sha3('transferFeeRate')] = transferFeeRateProposals;
511 
512   }
513 
514   function changeStorage(IkuraStorage newStorage) auth returns (bool) {
515     _storage = newStorage;
516 
517     return true;
518   }
519 
520   function changeToken(IkuraToken token_) auth returns (bool) {
521     _token = token_;
522 
523     return true;
524   }
525 
526   function newProposal(bytes32 type_, address proposer, uint amount, uint8 transferMinimumFee, uint transferFeeRate, bytes transationBytecode) returns (uint) {
527     uint proposalId = proposals[type_].length++;
528     Proposal proposal = proposals[type_][proposalId];
529     proposal.proposer = proposer;
530     proposal.amount = amount;
531     proposal.transferMinimumFee = transferMinimumFee;
532     proposal.transferFeeRate = transferFeeRate;
533     proposal.digest = sha3(proposer, amount, transationBytecode);
534     proposal.executed = false;
535     proposal.createdAt = now;
536     proposal.expireAt = proposal.createdAt + 86400;
537 
538     
539     
540     if (type_ == sha3('mint')) MintProposalAdded(proposalId, proposer, amount);
541     if (type_ == sha3('burn')) BurnProposalAdded(proposalId, proposer, amount);
542     if (type_ == sha3('transferMinimumFee')) TransferMinimumFeeProposalAdded(proposalId, proposer, transferMinimumFee);
543     if (type_ == sha3('transferFeeRate')) TransferFeeRateProposalAdded(proposalId, proposer, transferFeeRate);
544 
545     
546     confirmProposal(type_, proposer, proposalId);
547 
548     return proposalId;
549   }
550 
551   function confirmProposal(bytes32 type_, address confirmer, uint proposalId) {
552     Proposal proposal = proposals[type_][proposalId];
553 
554     
555     if (hasConfirmed(type_, confirmer, proposalId)) throw;
556 
557     
558     proposal.confirmers.push(confirmer);
559 
560     
561     
562     if (type_ == sha3('mint')) MintConfirmed(proposalId, confirmer, proposal.amount);
563     if (type_ == sha3('burn')) BurnConfirmed(proposalId, confirmer, proposal.amount);
564     if (type_ == sha3('transferMinimumFee')) TransferMinimumFeeConfirmed(proposalId, confirmer, proposal.transferMinimumFee);
565     if (type_ == sha3('transferFeeRate')) TransferFeeRateConfirmed(proposalId, confirmer, proposal.transferFeeRate);
566 
567     if (isProposalExecutable(type_, proposalId, proposal.proposer, '')) {
568       proposal.executed = true;
569 
570       
571       
572       if (type_ == sha3('mint')) executeMintProposal(proposalId);
573       if (type_ == sha3('burn')) executeBurnProposal(proposalId);
574       if (type_ == sha3('transferMinimumFee')) executeUpdateTransferMinimumFeeProposal(proposalId);
575       if (type_ == sha3('transferFeeRate')) executeUpdateTransferFeeRateProposal(proposalId);
576     }
577   }
578 
579   function hasConfirmed(bytes32 type_, address addr, uint proposalId) returns (bool) {
580     Proposal proposal = proposals[type_][proposalId];
581     uint length = proposal.confirmers.length;
582 
583     for (uint i = 0; i < length; i++) {
584       if (proposal.confirmers[i] == addr) return true;
585     }
586 
587     return false;
588   }
589 
590   function confirmedTotalToken(bytes32 type_, uint proposalId) returns (uint) {
591     Proposal proposal = proposals[type_][proposalId];
592     uint length = proposal.confirmers.length;
593     uint total = 0;
594 
595     for (uint i = 0; i < length; i++) {
596       total = add(total, _storage.tokenBalance(proposal.confirmers[i]));
597     }
598 
599     return total;
600   }
601 
602   function proposalExpireAt(bytes32 type_, uint proposalId) returns (uint) {
603     Proposal proposal = proposals[type_][proposalId];
604     return proposal.expireAt;
605   }
606 
607   function isProposalExecutable(bytes32 type_, uint proposalId, address proposer, bytes transactionBytecode) returns (bool) {
608     Proposal proposal = proposals[type_][proposalId];
609 
610     
611     if (_storage.numOwnerAddress() < 2) {
612       return true;
613     }
614 
615     return  proposal.digest == sha3(proposer, proposal.amount, transactionBytecode) &&
616             isProposalNotExpired(type_, proposalId) &&
617             div(mul(100, confirmedTotalToken(type_, proposalId)), _storage.totalSupply()) > confirmTotalTokenThreshold;
618   }
619 
620   function numberOfProposals(bytes32 type_) constant returns (uint) {
621     return proposals[type_].length;
622   }
623 
624   function numberOfActiveProposals(bytes32 type_) constant returns (uint) {
625     uint numActiveProposal = 0;
626 
627     for(uint i = 0; i < proposals[type_].length; i++) {
628       Proposal proposal = proposals[type_][i];
629 
630       if (isProposalNotExpired(type_, i)) {
631         numActiveProposal++;
632       }
633     }
634 
635     return numActiveProposal;
636   }
637 
638   function isProposalNotExpired(bytes32 type_, uint proposalId) internal returns (bool) {
639     Proposal proposal = proposals[type_][proposalId];
640 
641     return  !proposal.executed &&
642             now < proposal.expireAt;
643   }
644 
645   function executeMintProposal(uint proposalId) internal {
646     Proposal proposal = proposals[sha3('mint')][proposalId];
647 
648     
649     if (proposal.amount <= 0) throw;
650 
651     MintExecuted(proposalId, proposal.proposer, proposal.amount);
652 
653     
654     _storage.addTotalSupply(proposal.amount);
655     _storage.addCoinBalance(proposal.proposer, proposal.amount);
656     _storage.addTokenBalance(proposal.proposer, proposal.amount);
657   }
658 
659   function executeBurnProposal(uint proposalId) internal {
660     Proposal proposal = proposals[sha3('burn')][proposalId];
661 
662     
663     if (proposal.amount <= 0) throw;
664     if (_storage.coinBalance(proposal.proposer) < proposal.amount) throw;
665     if (_storage.tokenBalance(proposal.proposer) < proposal.amount) throw;
666 
667     BurnExecuted(proposalId, proposal.proposer, proposal.amount);
668 
669     
670     _storage.subTotalSupply(proposal.amount);
671     _storage.subCoinBalance(proposal.proposer, proposal.amount);
672     _storage.subTokenBalance(proposal.proposer, proposal.amount);
673   }
674 
675   function executeUpdateTransferMinimumFeeProposal(uint proposalId) internal {
676     Proposal proposal = proposals[sha3('transferMinimumFee')][proposalId];
677 
678     if (proposal.transferMinimumFee < 0) throw;
679 
680     TransferMinimumFeeExecuted(proposalId, proposal.proposer, proposal.transferMinimumFee);
681 
682     _storage.setTransferMinimumFee(proposal.transferMinimumFee);
683   }
684 
685   function executeUpdateTransferFeeRateProposal(uint proposalId) internal {
686     Proposal proposal = proposals[sha3('transferFeeRate')][proposalId];
687 
688     if (proposal.transferFeeRate < 0) throw;
689 
690     TransferFeeRateExecuted(proposalId, proposal.proposer, proposal.transferFeeRate);
691 
692     _storage.setTransferFeeRate(proposal.transferFeeRate);
693   }
694 
695   function isAuthorized(address src, bytes4 sig) internal returns (bool) {
696     sig; 
697 
698     return  src == address(this) ||
699             src == owner ||
700             src == address(_token);
701   }
702 }
703 library ProposalLibrary {
704   
705   
706   
707 
708   
709   struct Entity {
710     IkuraStorage _storage;
711     IkuraAssociation _association;
712   }
713 
714   function changeStorage(Entity storage self, address storage_) internal {
715     self._storage = IkuraStorage(storage_);
716   }
717 
718   function changeAssociation(Entity storage self, address association_) internal {
719     self._association = IkuraAssociation(association_);
720   }
721 
722   function updateTransferMinimumFee(Entity storage self, address sender, uint8 fee) returns (bool) {
723     if (fee < 0) throw;
724 
725     self._association.newProposal(sha3('transferMinimumFee'), sender, 0, fee, 0, '');
726 
727     return true;
728   }
729 
730   function updateTransferFeeRate(Entity storage self, address sender, uint rate) returns (bool) {
731     if (rate < 0) throw;
732 
733     self._association.newProposal(sha3('transferFeeRate'), sender, 0, 0, rate, '');
734 
735     return true;
736   }
737 
738   function mint(Entity storage self, address sender, uint amount) returns (bool) {
739     if (amount <= 0) throw;
740 
741     self._association.newProposal(sha3('mint'), sender, amount, 0, 0, '');
742 
743     return true;
744   }
745 
746   function burn(Entity storage self, address sender, uint amount) returns (bool) {
747     if (amount <= 0) throw;
748     if (self._storage.coinBalance(sender) < amount) throw;
749     if (self._storage.tokenBalance(sender) < amount) throw;
750 
751     self._association.newProposal(sha3('burn'), sender, amount, 0, 0, '');
752 
753     return true;
754   }
755 
756   function confirmProposal(Entity storage self, address sender, bytes32 type_, uint proposalId) {
757     self._association.confirmProposal(type_, sender, proposalId);
758   }
759 
760   function numberOfProposals(Entity storage self, bytes32 type_) constant returns (uint) {
761     return self._association.numberOfProposals(type_);
762   }
763 }
764 
765 contract IkuraToken is IkuraTokenEvent, DSMath, DSAuth {
766   
767   
768   
769 
770   /*using ProposalLibrary for ProposalLibrary.Entity;
771   ProposalLibrary.Entity proposalEntity;*/
772 
773   
774   
775   
776 
777   
778   IkuraStorage _storage;
779   IkuraAssociation _association;
780 
781   function IkuraToken() DSAuth() {
782     
783     
784     
785     /*address controllerAddress = 0x34c5605A4Ef1C98575DB6542179E55eE1f77A188;
786     owner = controllerAddress;
787     LogSetOwner(controllerAddress);*/
788   }
789 
790   function totalSupply(address sender) auth constant returns (uint) {
791     sender; 
792 
793     return _storage.totalSupply();
794   }
795 
796   function balanceOf(address sender, address addr) auth constant returns (uint) {
797     sender; 
798 
799     return _storage.coinBalance(addr);
800   }
801 
802   function transfer(address sender, address to, uint amount) auth returns (bool success) {
803     uint fee = transferFee(sender, sender, to, amount);
804 
805     if (_storage.coinBalance(sender) < add(amount, fee)) throw;
806     if (amount <= 0) throw;
807 
808     
809     address owner = selectOwnerAddressForTransactionFee(sender);
810 
811     
812     _storage.subCoinBalance(sender, add(amount, fee));
813 
814     
815     _storage.addCoinBalance(to, amount);
816 
817     
818     _storage.addCoinBalance(owner, fee);
819 
820     
821     IkuraTransfer(sender, to, amount);
822     IkuraTransferFee(sender, to, owner, fee);
823 
824     return true;
825   }
826 
827   function transferFrom(address sender, address from, address to, uint amount) auth returns (bool success) {
828     uint fee = transferFee(sender, from, to, amount);
829 
830     if (_storage.coinBalance(from) < amount) throw;
831     if (_storage.coinAllowance(from, sender) < amount) throw;
832     if (amount <= 0) throw;
833     if (add(_storage.coinBalance(to), amount) <= _storage.coinBalance(to)) throw;
834     if (_storage.coinBalance(sender) < fee) throw;
835 
836     
837     address owner = selectOwnerAddressForTransactionFee(sender);
838 
839     
840     _storage.subCoinBalance(sender, fee);
841 
842     
843     _storage.subCoinBalance(from, amount);
844 
845     
846     _storage.subCoinAllowance(from, sender, amount);
847 
848     
849     _storage.addCoinBalance(to, amount);
850 
851     
852     _storage.addCoinBalance(owner, fee);
853 
854     
855     IkuraTransfer(from, to, amount);
856 
857     return true;
858   }
859 
860   function approve(address sender, address spender, uint amount) auth returns (bool success) {
861     _storage.setCoinAllowance(sender, spender, amount);
862 
863     
864     IkuraApproval(sender, spender, amount);
865 
866     return true;
867   }
868 
869 
870   function allowance(address sender, address owner, address spender) auth constant returns (uint remaining) {
871     sender; 
872 
873     return _storage.coinAllowance(owner, spender);
874   }
875 
876   
877   
878   
879 
880 
881   function tokenBalanceOf(address sender, address owner) auth constant returns (uint balance) {
882     sender; 
883 
884     return _storage.tokenBalance(owner);
885   }
886 
887 
888   function transferToken(address sender, address to, uint amount) auth returns (bool success) {
889     if (_storage.tokenBalance(sender) < amount ) throw;
890     if (amount <= 0) throw;
891     if (add(_storage.tokenBalance(to), amount) <= _storage.tokenBalance(to)) throw;
892 
893     _storage.subTokenBalance(sender, amount);
894     _storage.addTokenBalance(to, amount);
895 
896     IkuraTransferToken(sender, to, amount);
897 
898     return true;
899   }
900 
901 
902   function transferFeeRate(address sender) auth constant returns (uint) {
903     sender; 
904 
905     return _storage.transferFeeRate();
906   }
907 
908 
909   function transferMinimumFee(address sender) auth constant returns (uint8) {
910     sender; 
911 
912     return _storage.transferMinimumFee();
913   }
914 
915 
916   function transferFee(address sender, address from, address to, uint amount) auth returns (uint) {
917     from; to; 
918 
919     uint rate = transferFeeRate(sender);
920     uint denominator = 1000000; 
921     uint numerator = mul(amount, rate);
922 
923     uint fee = div(numerator, denominator);
924     uint remainder = sub(numerator, mul(denominator, fee));
925 
926     
927     if (remainder > 0) {
928       fee++;
929     }
930 
931     if (fee < transferMinimumFee(sender)) {
932       fee = transferMinimumFee(sender);
933     }
934 
935     return fee;
936   }
937 
938 
939   function updateTransferMinimumFee(address sender, uint8 fee) auth returns (bool) {
940     if (fee < 0) throw;
941 
942     _association.newProposal(sha3('transferMinimumFee'), sender, 0, fee, 0, '');
943     return true;
944 
945     /*return proposalEntity.updateTransferMinimumFee(sender, fee);*/
946   }
947 
948 
949   function updateTransferFeeRate(address sender, uint rate) auth returns (bool) {
950     if (rate < 0) throw;
951 
952     _association.newProposal(sha3('transferFeeRate'), sender, 0, 0, rate, '');
953     return true;
954 
955     /*return proposalEntity.updateTransferFeeRate(sender, rate);*/
956   }
957 
958 
959   function selectOwnerAddressForTransactionFee(address sender) auth returns (address) {
960     sender; 
961 
962     return _storage.primaryOwner();
963   }
964 
965   function mint(address sender, uint amount) auth returns (bool) {
966     if (amount <= 0) throw;
967 
968     _association.newProposal(sha3('mint'), sender, amount, 0, 0, '');
969 
970     /*return proposalEntity.mint(sender, amount);*/
971   }
972 
973 
974   function burn(address sender, uint amount) auth returns (bool) {
975     if (amount <= 0) throw;
976     if (_storage.coinBalance(sender) < amount) throw;
977     if (_storage.tokenBalance(sender) < amount) throw;
978 
979     _association.newProposal(sha3('burn'), sender, amount, 0, 0, '');
980     /*return proposalEntity.burn(sender, amount);*/
981   }
982 
983   function confirmProposal(address sender, bytes32 type_, uint proposalId) auth {
984     _association.confirmProposal(type_, sender, proposalId);
985     /*proposalEntity.confirmProposal(sender, type_, proposalId);*/
986   }
987 
988 
989   function numberOfProposals(bytes32 type_) constant returns (uint) {
990     return _association.numberOfProposals(type_);
991     /*return proposalEntity.numberOfProposals(type_);*/
992   }
993 
994 
995   function changeAssociation(address association_) auth returns (bool) {
996     _association = IkuraAssociation(association_);
997     /*proposalEntity.changeAssociation(_association);*/
998 
999     return true;
1000   }
1001 
1002 
1003   function changeStorage(address storage_) auth returns (bool) {
1004     _storage = IkuraStorage(storage_);
1005     /*proposalEntity.changeStorage(_storage);*/
1006 
1007     return true;
1008   }
1009 
1010 
1011   function logicVersion(address sender) auth constant returns (uint) {
1012     sender; 
1013 
1014     return 1;
1015   }
1016 }
1017 
1018 
1019 contract IkuraAuthority is DSAuthority, DSAuth {
1020   
1021   IkuraStorage tokenStorage;
1022 
1023   
1024   
1025   mapping(bytes4 => bool) actionsWithToken;
1026 
1027   
1028   mapping(bytes4 => bool) actionsForbidden;
1029 
1030   
1031   
1032   
1033   function IkuraAuthority() DSAuth() {
1034     /*address controllerAddress = 0x34c5605A4Ef1C98575DB6542179E55eE1f77A188;
1035     owner = controllerAddress;
1036     LogSetOwner(controllerAddress);*/
1037   }
1038 
1039 
1040   function changeStorage(address storage_) auth {
1041     tokenStorage = IkuraStorage(storage_);
1042 
1043     
1044     actionsWithToken[stringToSig('mint(uint256)')] = true;
1045     actionsWithToken[stringToSig('burn(uint256)')] = true;
1046     actionsWithToken[stringToSig('updateTransferMinimumFee(uint8)')] = true;
1047     actionsWithToken[stringToSig('updateTransferFeeRate(uint256)')] = true;
1048     actionsWithToken[stringToSig('confirmProposal(string, uint256)')] = true;
1049     actionsWithToken[stringToSig('numberOfProposals(string)')] = true;
1050 
1051     
1052     actionsForbidden[stringToSig('forbiddenAction()')] = true;
1053   }
1054 
1055   function canCall(address src, address dst, bytes4 sig) constant returns (bool) {
1056     
1057     if (actionsWithToken[sig]) return canCallWithAssociation(src, dst);
1058 
1059     
1060     if (actionsForbidden[sig]) return canCallWithNoOne();
1061 
1062     
1063     return canCallDefault(src);
1064   }
1065 
1066   function canCallDefault(address src) internal constant returns (bool) {
1067     return tokenStorage.isOwnerAddress(src);
1068   }
1069 
1070 
1071   function canCallWithAssociation(address src, address dst) internal returns (bool) {
1072     
1073     dst;
1074 
1075     return tokenStorage.isOwnerAddress(src) &&
1076            (tokenStorage.numOwnerAddress() == 1 || tokenStorage.tokenBalance(src) > 0);
1077   }
1078 
1079 
1080   function canCallWithNoOne() internal constant returns (bool) {
1081     return false;
1082   }
1083 
1084 
1085   function stringToSig(string str) internal constant returns (bytes4) {
1086     return bytes4(sha3(str));
1087   }
1088 }
1089 
1090 
1091 contract IkuraController is ERC20, DSAuth {
1092   
1093   
1094   
1095 
1096   
1097   string public name = "XJP 0.6.0";
1098 
1099   
1100   string public constant symbol = "XJP";
1101 
1102   
1103   uint8 public constant decimals = 0;
1104 
1105   
1106   
1107   
1108 
1109   
1110   
1111   IkuraToken private token;
1112 
1113   
1114   IkuraStorage private tokenStorage;
1115 
1116   
1117   IkuraAuthority private authority;
1118 
1119   
1120   IkuraAssociation private association;
1121 
1122   
1123   
1124   
1125 
1126   function totalSupply() constant returns (uint) {
1127     return token.totalSupply(msg.sender);
1128   }
1129 
1130   function balanceOf(address addr) constant returns (uint) {
1131     return token.balanceOf(msg.sender, addr);
1132   }
1133 
1134   function transfer(address to, uint amount) returns (bool) {
1135     if (token.transfer(msg.sender, to, amount)) {
1136       Transfer(msg.sender, to, amount);
1137 
1138       return true;
1139     } else {
1140       return false;
1141     }
1142   }
1143 
1144   function transferFrom(address from, address to, uint amount) returns (bool) {
1145     if (token.transferFrom(msg.sender, from, to, amount)) {
1146       Transfer(from, to, amount);
1147 
1148       return true;
1149     } else {
1150       return false;
1151     }
1152   }
1153 
1154   function approve(address spender, uint amount) returns (bool) {
1155     if (token.approve(msg.sender, spender, amount)) {
1156       Approval(msg.sender, spender, amount);
1157 
1158       return true;
1159     } else {
1160       return false;
1161     }
1162   }
1163 
1164   function allowance(address addr, address spender) constant returns (uint) {
1165     return token.allowance(msg.sender, addr, spender);
1166   }
1167 
1168   
1169   
1170   
1171 
1172   function tokenBalanceOf(address addr) constant returns (uint) {
1173     return token.tokenBalanceOf(msg.sender, addr);
1174   }
1175 
1176   function transferToken(address to, uint amount) returns (bool) {
1177     return token.transferToken(msg.sender, to, amount);
1178   }
1179 
1180   function transferFeeRate() constant returns (uint) {
1181     return token.transferFeeRate(msg.sender);
1182   }
1183 
1184   function transferMinimumFee() constant returns (uint8) {
1185     return token.transferMinimumFee(msg.sender);
1186   }
1187 
1188   function transferFee(address from, address to, uint amount) returns (uint) {
1189     return token.transferFee(msg.sender, from, to, amount);
1190   }
1191 
1192   
1193 
1194   function updateTransferMinimumFee(uint8 minimumFee) auth returns (bool) {
1195     return token.updateTransferMinimumFee(msg.sender, minimumFee);
1196   }
1197 
1198   function updateTransferFeeRate(uint feeRate) auth returns (bool) {
1199     return token.updateTransferFeeRate(msg.sender, feeRate);
1200   }
1201 
1202   function mint(uint amount) auth returns (bool) {
1203     return token.mint(msg.sender, amount);
1204   }
1205 
1206   function burn(uint amount) auth returns (bool) {
1207     return token.burn(msg.sender, amount);
1208   }
1209 
1210   function isOwner(address addr) auth returns (bool) {
1211     return tokenStorage.isOwnerAddress(addr);
1212   }
1213 
1214 
1215   function confirmProposal(string type_, uint proposalId) auth {
1216     token.confirmProposal(msg.sender, sha3(type_), proposalId);
1217   }
1218 
1219   function numOwnerAddress() auth constant returns (uint) {
1220     return tokenStorage.numOwnerAddress();
1221   }
1222 
1223 
1224   function numberOfProposals(string type_) auth constant returns (uint) {
1225     return token.numberOfProposals(sha3(type_));
1226   }
1227 
1228   
1229   
1230   
1231 
1232 
1233   function setup(address storageAddress, address tokenAddress, address authorityAddress, address associationAddress) auth {
1234     changeStorage(storageAddress);
1235     changeToken(tokenAddress);
1236     changeAuthority(authorityAddress);
1237     changeAssociation(associationAddress);
1238   }
1239 
1240 
1241   function changeToken(address tokenAddress) auth {
1242     
1243     token = IkuraToken(tokenAddress);
1244 
1245     
1246     tokenStorage.changeToken(token);
1247     token.changeStorage(tokenStorage);
1248 
1249     
1250     if (association != address(0)) {
1251       association.changeToken(token);
1252       token.changeAssociation(association);
1253     }
1254   }
1255 
1256   function changeStorage(address storageAddress) auth {
1257     
1258     tokenStorage = IkuraStorage(storageAddress);
1259   }
1260 
1261 
1262   function changeAuthority(address authorityAddress) auth {
1263     
1264     authority = IkuraAuthority(authorityAddress);
1265     setAuthority(authority);
1266 
1267     
1268     authority.changeStorage(tokenStorage);
1269     tokenStorage.changeAuthority(authority);
1270   }
1271 
1272   function changeAssociation(address associationAddress) auth {
1273     
1274     association = IkuraAssociation(associationAddress);
1275 
1276     
1277     association.changeStorage(tokenStorage);
1278     tokenStorage.changeAssociation(association);
1279 
1280     
1281     if (token != address(0)) {
1282       association.changeToken(token);
1283       token.changeAssociation(association);
1284     }
1285   }
1286 
1287 
1288   function forbiddenAction() auth returns (bool) {
1289     return true;
1290   }
1291 
1292  
1293   function logicVersion() constant returns (uint) {
1294     return token.logicVersion(msg.sender);
1295   }
1296 
1297 
1298   function isAuthorized(address src, bytes4 sig) internal returns (bool) {
1299     return  src == address(this) ||
1300             src == owner ||
1301             authority.canCall(src, this, sig);
1302   }
1303 }