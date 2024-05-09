1 pragma solidity ^0.4.16;
2 contract IcoData{
3 /////////////////////////////////////////////////////////    
4 ///////(c)2017 tokenchanger.io -all rights reserved////// 
5  
6 /*SUPER ADMINS*/
7 address Mars = 0x1947f347B6ECf1C3D7e1A58E3CDB2A15639D48Be;
8 address Mercury = 0x00795263bdca13104309Db70c11E8404f81576BE;
9 address Europa = 0x00e4E3eac5b520BCa1030709a5f6f3dC8B9e1C37;
10 address Jupiter = 0x2C76F260707672e240DC639e5C9C62efAfB59867;
11 address Neptune = 0xEB04E1545a488A5018d2b5844F564135211d3696;
12 
13 /*CONTRACT ADDRESS*/
14 function GetContractAddr() public constant returns (address){
15 return this;
16 }	
17 address ContractAddr = GetContractAddr();
18 
19 struct State{
20 bool PrivateSale;
21 bool PreSale;
22 bool MainSale; 
23 bool End;
24 }
25 
26 struct Market{
27 uint256 EtherPrice;    
28 uint256 TocPrice;    
29 uint256 Commission;    
30 } 
31 
32 struct Admin{
33 bool Authorised; 
34 uint256 Level;
35 }
36 
37 /*contract state*/
38 mapping (address => State) public state;
39 /*market storage*/
40 mapping (address => Market) public market;
41 /*authorised admins*/
42 mapping (address => Admin) public admin;
43 
44 /*AUTHORISE ADMIN*/
45 function AuthAdmin(address _admin, bool _authority, uint256 _level) external 
46 returns(bool) {
47 if((msg.sender != Mars) && (msg.sender != Mercury) && (msg.sender != Europa)
48 && (msg.sender != Jupiter) && (msg.sender != Neptune)) revert();  
49 admin[_admin].Authorised = _authority; 
50 admin[_admin].Level = _level;
51 return true;
52 } 
53 
54 /*GENERAL PRICE UPDATE*/
55 function GeneralUpdate(uint256 _etherprice, uint256 _tocprice, uint256 _commission) 
56 external returns(bool){
57 /*integrity checks*/    
58 if(admin[msg.sender].Authorised == false) revert();
59 if(admin[msg.sender].Level < 5 ) revert();
60 /*update market record*/
61 market[ContractAddr].EtherPrice = _etherprice; 
62 market[ContractAddr].TocPrice = _tocprice;
63 market[ContractAddr].Commission = _commission;
64 return true;
65 }
66 
67 /*UPDATE ETHER PRICE*/
68 function EtherPriceUpdate(uint256 _etherprice)external returns(bool){
69 /*integrity checks*/    
70 if(admin[msg.sender].Authorised == false) revert();
71 if(admin[msg.sender].Level < 5 ) revert();
72 /*update market record*/
73 market[ContractAddr].EtherPrice = _etherprice; 
74 return true;
75 }
76 
77 /*UPDATE STATE*/
78 function UpdateState(uint256 _state) external returns(bool){
79 /*integrity checks*/    
80 if(admin[msg.sender].Authorised == false) revert();
81 if(admin[msg.sender].Level < 5 ) revert();
82 /*private sale state*/
83 if(_state == 1){
84 state[ContractAddr].PrivateSale = true; 
85 state[ContractAddr].PreSale = false;
86 state[ContractAddr].MainSale = false;
87 state[ContractAddr].End = false;
88 }
89 /*presale state*/
90 if(_state == 2){
91 state[ContractAddr].PrivateSale = false; 
92 state[ContractAddr].PreSale = true;
93 state[ContractAddr].MainSale = false;
94 state[ContractAddr].End = false;
95 }
96 /*main sale state*/
97 if(_state == 3){
98 state[ContractAddr].PrivateSale = false; 
99 state[ContractAddr].PreSale = false;
100 state[ContractAddr].MainSale = true;
101 state[ContractAddr].End = false;
102 }
103 /*end state*/
104 if(_state == 4){
105 state[ContractAddr].PrivateSale = false; 
106 state[ContractAddr].PreSale = false;
107 state[ContractAddr].MainSale = false;
108 state[ContractAddr].End = true;
109 }
110 return true;
111 }
112 
113 /*GETTERS*/
114 
115 /*get private sale state*/
116 function GetPrivateSale() public view returns (bool){
117 return state[ContractAddr].PrivateSale;
118 }
119 /*get pre sale state*/
120 function GetPreSale() public view returns (bool){
121 return state[ContractAddr].PreSale;
122 }
123 /*get main sale state*/
124 function GetMainSale() public view returns (bool){
125 return state[ContractAddr].MainSale;
126 }
127 /*get end state*/
128 function GetEnd() public view returns (bool){
129 return state[ContractAddr].End;
130 }
131 /*get ether price*/
132 function GetEtherPrice() public view returns (uint256){
133 return market[ContractAddr].EtherPrice;
134 }
135 /*get toc price*/
136 function GetTocPrice() public view returns (uint256){
137 return market[ContractAddr].TocPrice;
138 }
139 /*get commission*/
140 function GetCommission() public view returns (uint256){
141 return market[ContractAddr].Commission;
142 }
143 
144 }///////////////////////////////////end of icodata contract
145 
146 
147 
148 pragma solidity ^0.4.16;
149 contract IcoDapp{
150 /////////////////////////////////////////////////////////    
151 ///////(c)2017 tokenchanger.io -all rights reserved////// 
152  
153 /*SUPER ADMINS*/
154 address Mars = 0x1947f347B6ECf1C3D7e1A58E3CDB2A15639D48Be;
155 address Mercury = 0x00795263bdca13104309Db70c11E8404f81576BE;
156 address Europa = 0x00e4E3eac5b520BCa1030709a5f6f3dC8B9e1C37;
157 address Jupiter = 0x2C76F260707672e240DC639e5C9C62efAfB59867;
158 address Neptune = 0xEB04E1545a488A5018d2b5844F564135211d3696;
159 
160 /*GLOBAL VARIABLES*/
161 uint256 Converter = 10000;
162 
163 /*CONTRACT ADDRESS*/
164 function GetContractAddr() public constant returns (address){
165 return this;
166 }	
167 address ContractAddr = GetContractAddr();
168 
169 struct Buyer{
170 bool Withdrawn;    
171 uint256 TocBalance;
172 uint256 WithdrawalBlock;
173 uint256 Num;
174 }
175 
176 struct Transaction{
177 uint256 Amount;
178 uint256 EtherPrice;
179 uint256 TocPrice;
180 uint256 Block;
181 }    
182 
183 struct AddressBook{
184 address TOCAddr;
185 address DataAddr;
186 address Banker;
187 }
188 
189 struct Admin{
190 bool Authorised; 
191 uint256 Level;
192 }
193 
194 struct OrderBooks{
195 uint256 PrivateSupply;
196 uint256 PreSupply;
197 uint256 MainSupply;
198 }
199 
200 struct Promoters{
201 bool Registered;    
202 uint256 TotalCommission; 
203 }
204 
205 struct PromoAdmin{
206 uint256 CurrentNum;
207 uint256 Max;    
208 }
209 
210 
211 /*buyer account*/
212 mapping (address => Buyer) public buyer;
213 /*buyer transactions*/
214 mapping(address => mapping(uint256 => Transaction)) public transaction;
215 /*order books store*/
216 mapping (address => OrderBooks) public orderbooks;
217 /*promoter store*/
218 mapping (address => Promoters) public promoters;
219 /*server address book*/
220 mapping (address => AddressBook) public addressbook;
221 /*administration of promoters*/
222 mapping (address => PromoAdmin) public promoadmin;
223 /*authorised admins*/
224 mapping (address => Admin) public admin;
225 
226 struct TA{
227 uint256 n1;
228 uint256 n2;
229 uint256 n3;
230 uint256 n4;
231 uint256 n5;
232 uint256 n6;
233 uint256 n7;
234 uint256 n8;
235 uint256 n9;
236 uint256 n10;
237 uint256 n11;
238 }
239 
240 struct LA{
241 bool l1;
242 bool l2;
243 bool l3;
244 }
245 
246 /*initialise process variables*/
247 TA ta;
248 LA la;
249 
250 /*AUTHORISE ADMIN*/
251 function AuthAdmin(address _admin, bool _authority, uint256 _level) external 
252 returns(bool) {
253 if((msg.sender != Mars) && (msg.sender != Mercury) && (msg.sender != Europa)
254 && (msg.sender != Jupiter) && (msg.sender != Neptune)) revert();  
255 admin[_admin].Authorised = _authority; 
256 admin[_admin].Level = _level;
257 return true;
258 } 
259 
260 /*ADD ADDRESSES TO ADDRESS BOOK*/
261 function AuthAddr(address _tocaddr, address _dataddr, address _banker) 
262 external returns(bool){
263 /*integrity checks*/      
264 if(admin[msg.sender].Authorised == false) revert();
265 if(admin[msg.sender].Level < 5 ) revert();
266 /*update address record*/
267 addressbook[ContractAddr].TOCAddr = _tocaddr;
268 addressbook[ContractAddr].DataAddr = _dataddr;
269 addressbook[ContractAddr].Banker = _banker;
270 return true;
271 }
272 
273 /*CONFIGURE PROMOTERS*/
274 function ConfigPromoter(uint256 _max) external returns (bool){
275 /*integrity checks*/    
276 if(admin[msg.sender].Authorised == false) revert();
277 if(admin[msg.sender].Level < 5 ) revert();    
278 /*create promoter record*/    
279 promoadmin[ContractAddr].Max = _max; 
280 return true;
281 }
282 
283 /*ADD PROMOTER*/
284 function AddPromoter(address _addpromoter) external returns (bool){
285 /*integrity checks*/    
286 if(admin[msg.sender].Authorised == false) revert();
287 if(admin[msg.sender].Level < 5 ) revert(); 
288 /*create promoter records*/    
289 promoters[_addpromoter].Registered = true;
290 promoters[_addpromoter].TotalCommission = 0;
291 promoadmin[ContractAddr].CurrentNum += 1;
292 return true;
293 }
294 
295 /*REGISTER AS A PROMOTER*/
296 function Register(address _referrer) external returns (bool){
297 /*integrity checks*/ 
298 if(promoters[_referrer].Registered == false) revert();
299 if(promoters[msg.sender].Registered == true) revert();
300 if(promoadmin[ContractAddr].CurrentNum >= promoadmin[ContractAddr].Max) revert();
301 /*create promoter records*/    
302 promoters[msg.sender].Registered = true;
303 promoters[msg.sender].TotalCommission = 0; 
304 promoadmin[ContractAddr].CurrentNum += 1;
305 return true;
306 }
307 
308 /*INCREASE PRIVATE SALE SUPPLY*/
309 function IncPrivateSupply(uint256 _privatesupply) external returns (bool){
310 /*integrity checks*/    
311 if(admin[msg.sender].Authorised == false) revert();
312 if(admin[msg.sender].Level < 5 ) revert();    
313 /*update private supply record*/    
314 orderbooks[ContractAddr].PrivateSupply += _privatesupply; 
315 return true;
316 }
317 
318 /*INCREASE PRESALE SUPPLY*/
319 function IncPreSupply(uint256 _presupply) external returns (bool){
320 /*integrity checks*/    
321 if(admin[msg.sender].Authorised == false) revert();
322 if(admin[msg.sender].Level < 5 ) revert();    
323 /*update presale supply record*/    
324 orderbooks[ContractAddr].PreSupply += _presupply;
325 return true;
326 }
327 
328 /*INCREASE MAINSALE SUPPLY*/
329 function IncMainSupply(uint256 _mainsupply) external returns (bool){
330 /*integrity checks*/    
331 if(admin[msg.sender].Authorised == false) revert();
332 if(admin[msg.sender].Level < 5 ) revert();    
333 /*update main sale supply record*/    
334 orderbooks[ContractAddr].MainSupply += _mainsupply;
335 return true;
336 }
337 
338 /*CALCULATE COMMISSION*/
339 function RefCommission(uint256 _amount, uint256 _com) internal returns (uint256){
340 ta.n1 = mul(_amount, _com);
341 ta.n2 = div(ta.n1,Converter);
342 return ta.n2;
343 }
344 
345 /*CALCULATE TOC PURCHASED*/
346 function CalcToc(uint256 _etherprice, uint256 _tocprice, uint256 _deposit) 
347 internal returns (uint256){    
348 ta.n3 = mul(_etherprice, _deposit);
349 ta.n4 = div(ta.n3,_tocprice);
350 return ta.n4;
351 }
352 
353 /*PRIVATE SALE*/
354 function PrivateSaleBuy(address _referrer) payable external returns (bool){
355 /*integrity checks*/    
356 if(promoters[_referrer].Registered == false) revert();
357 if(msg.value <= 0) revert();
358 /*connect to ico data contract*/
359 IcoData
360 DataCall = IcoData(addressbook[ContractAddr].DataAddr);
361 /*get transaction information*/
362 la.l1 = DataCall.GetEnd();
363 la.l2 = DataCall.GetPrivateSale();
364 ta.n5 = DataCall.GetEtherPrice();    
365 ta.n6 = DataCall.GetTocPrice();    
366 ta.n7 = DataCall.GetCommission();    
367 /*intergrity checks*/    
368 if(la.l1 == true) revert();
369 if(la.l2 == false) revert();
370 /*calculate toc purchased & determine supply avaliability*/
371 ta.n8 = CalcToc(ta.n5, ta.n6, msg.value);
372 if(ta.n8 > orderbooks[ContractAddr].PrivateSupply) revert();
373 /*calculate referrer commission*/
374 ta.n9 = RefCommission(msg.value, ta.n7);
375 /*calculate net revenue*/
376 ta.n10 = sub(msg.value, ta.n9);
377 /*payments and delivery*/
378 addressbook[ContractAddr].Banker.transfer(ta.n10);
379 _referrer.transfer(ta.n9);
380 /*update transaction records*/
381 orderbooks[ContractAddr].PrivateSupply -= ta.n8;
382 buyer[msg.sender].TocBalance += ta.n8;
383 buyer[msg.sender].Num += 1;
384 ta.n11 = buyer[msg.sender].Num; 
385 transaction[msg.sender][ta.n11].Amount = ta.n8;
386 transaction[msg.sender][ta.n11].EtherPrice = ta.n5;
387 transaction[msg.sender][ta.n11].TocPrice = ta.n6;
388 transaction[msg.sender][ta.n11].Block = block.number;
389 promoters[_referrer].TotalCommission += ta.n9;
390 return true;
391 }    
392 
393 /*PRESALE*/
394 function PreSaleBuy(address _referrer) payable external returns (bool){
395 /*integrity checks*/    
396 if(promoters[_referrer].Registered == false) revert();
397 if(msg.value <= 0) revert();
398 /*connect to ico data contract*/
399 IcoData
400 DataCall = IcoData(addressbook[ContractAddr].DataAddr);
401 /*get transaction information*/
402 la.l1 = DataCall.GetEnd();
403 la.l2 = DataCall.GetPreSale();
404 ta.n5 = DataCall.GetEtherPrice();    
405 ta.n6 = DataCall.GetTocPrice();    
406 ta.n7 = DataCall.GetCommission();    
407 /*intergrity checks*/    
408 if(la.l1 == true) revert();
409 if(la.l2 == false) revert();
410 /*calculate toc purchased & determine supply avaliability*/
411 ta.n8 = CalcToc(ta.n5, ta.n6, msg.value);
412 if(ta.n8 > orderbooks[ContractAddr].PreSupply) revert();
413 /*calculate referrer commission*/
414 ta.n9 = RefCommission(msg.value, ta.n7);
415 /*calculate net revenue*/
416 ta.n10 = sub(msg.value, ta.n9);
417 /*payments and delivery*/
418 addressbook[ContractAddr].Banker.transfer(ta.n10);
419 _referrer.transfer(ta.n9);
420 /*update transaction records*/
421 orderbooks[ContractAddr].PreSupply -= ta.n8;
422 buyer[msg.sender].TocBalance += ta.n8;
423 buyer[msg.sender].Num += 1;
424 ta.n11 = buyer[msg.sender].Num; 
425 transaction[msg.sender][ta.n11].Amount = ta.n8;
426 transaction[msg.sender][ta.n11].EtherPrice = ta.n5;
427 transaction[msg.sender][ta.n11].TocPrice = ta.n6;
428 transaction[msg.sender][ta.n11].Block = block.number;
429 promoters[_referrer].TotalCommission += ta.n9;
430 return true;
431 }    
432 
433 
434 /*MAIN SALE*/
435 function MainSaleBuy() payable external returns (bool){
436 /*integrity checks*/    
437 if(msg.value <= 0) revert();
438 /*connect to ico data contract*/
439 IcoData
440 DataCall = IcoData(addressbook[ContractAddr].DataAddr);
441 /*get transaction information*/
442 la.l1 = DataCall.GetEnd();
443 la.l2 = DataCall.GetMainSale();
444 ta.n5 = DataCall.GetEtherPrice();    
445 ta.n6 = DataCall.GetTocPrice();    
446 ta.n7 = DataCall.GetCommission();    
447 /*intergrity checks*/    
448 if(la.l1 == true) revert();
449 if(la.l2 == false) revert();
450 /*calculate toc purchased & determine supply avaliability*/
451 ta.n8 = CalcToc(ta.n5, ta.n6, msg.value);
452 if(ta.n8 > orderbooks[ContractAddr].MainSupply) revert();
453 /*payments and delivery*/
454 addressbook[ContractAddr].Banker.transfer(msg.value);
455 /*update transaction records*/
456 orderbooks[ContractAddr].MainSupply -= ta.n8;
457 buyer[msg.sender].TocBalance += ta.n8;
458 buyer[msg.sender].Num += 1;
459 ta.n9 = buyer[msg.sender].Num; 
460 transaction[msg.sender][ta.n9].Amount = ta.n8;
461 transaction[msg.sender][ta.n11].EtherPrice = ta.n5;
462 transaction[msg.sender][ta.n11].TocPrice = ta.n6;
463 transaction[msg.sender][ta.n9].Block = block.number;
464 return true;
465 }    
466 
467 /*WITHDRAW TOC TOKENS*/
468 function Withdraw() external returns (bool){
469 /*connect to ico data contract*/
470 IcoData
471 DataCall = IcoData(addressbook[ContractAddr].DataAddr);
472 /*get ico cycle information*/
473 la.l3 = DataCall.GetEnd();
474 /*integrity checks*/ 
475 if(la.l3 == false) revert();
476 if(buyer[msg.sender].TocBalance <= 0) revert();
477 if(buyer[msg.sender].Withdrawn == true) revert();
478 /*update buyer record*/
479 buyer[msg.sender].Withdrawn = true;
480 buyer[msg.sender].WithdrawalBlock = block.number;
481 /*connect to toc contract*/
482 TOC
483 TOCCall = TOC(addressbook[ContractAddr].TOCAddr);
484 /*check integrity before sending tokens*/
485 assert(buyer[msg.sender].Withdrawn == true);
486 /*send toc to message sender*/
487 TOCCall.transfer(msg.sender,buyer[msg.sender].TocBalance);
488 /*check integrity after sending tokens*/
489 assert(buyer[msg.sender].Withdrawn == true);
490 return true;
491 }  
492 
493 /*RECEIVE APPROVAL & WITHDRAW TOC TOKENS*/
494 function receiveApproval(address _from, uint256 _value, 
495 address _token, bytes _extraData) external returns(bool){ 
496 TOC
497 TOCCall = TOC(_token);
498 TOCCall.transferFrom(_from,this,_value);
499 return true;
500 }
501 
502 /*INVALID TRANSACTIONS*/
503 function () payable external{
504 revert();  
505 }
506 
507 /*SAFE MATHS*/
508 function mul(uint256 a, uint256 b) public pure returns (uint256) {
509     uint256 c = a * b;
510     assert(a == 0 || c / a == b);
511     return c;
512   }
513 function div(uint256 a, uint256 b) public pure returns (uint256) {
514     // assert(b > 0); // Solidity automatically throws when dividing by 0
515     uint256 c = a / b;
516     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
517     return c;
518   }  
519 function sub(uint256 a, uint256 b) public pure returns (uint256) {
520     assert(b <= a);
521     return a - b;
522   }
523 function add(uint256 a, uint256 b) public pure returns (uint256) {
524     uint256 c = a + b;
525     assert(c >= a);
526     return c;
527   }
528 }///////////////////////////////////end of icodapp contract
529 
530 
531 pragma solidity ^0.4.16;
532 
533 /*SPEND APPROVAL ALERT INTERFACE*/
534 interface tokenRecipient { 
535 function receiveApproval(address _from, uint256 _value, 
536 address _token, bytes _extraData) external; 
537 }
538 
539 contract TOC {
540 /*tokenchanger.io*/
541 
542 /*TOC TOKEN*/
543 string public name;
544 string public symbol;
545 uint8 public decimals;
546 uint256 public totalSupply;
547 
548 /*user coin balance*/
549 mapping (address => uint256) public balances;
550 /*user coin allowances*/
551 mapping(address => mapping (address => uint256)) public allowed;
552 
553 /*EVENTS*/		
554 /*broadcast token transfers on the blockchain*/
555 event Transfer(address indexed from, address indexed to, uint256 value);
556 /*broadcast token spend approvals on the blockchain*/
557 event Approval(address indexed _owner, address indexed _spender, uint _value);
558 
559 /*MINT TOKEN*/
560 constructor() public {
561 name = "TokenChanger";
562 symbol = "TOC";
563 decimals = 18;
564 /*one billion base units*/
565 totalSupply = 10**27;
566 balances[msg.sender] = totalSupply; 
567 }
568 
569 /*INTERNAL TRANSFER*/
570 function _transfer(address _from, address _to, uint _value) internal {    
571 /*prevent transfer to invalid address*/    
572 if(_to == 0x0) revert();
573 /*check if the sender has enough value to send*/
574 if(balances[_from] < _value) revert(); 
575 /*check for overflows*/
576 if(balances[_to] + _value < balances[_to]) revert();
577 /*compute sending and receiving balances before transfer*/
578 uint PreviousBalances = balances[_from] + balances[_to];
579 /*substract from sender*/
580 balances[_from] -= _value;
581 /*add to the recipient*/
582 balances[_to] += _value; 
583 /*check integrity of transfer operation*/
584 assert(balances[_from] + balances[_to] == PreviousBalances);
585 /*broadcast transaction*/
586 emit Transfer(_from, _to, _value); 
587 }
588 
589 /*PUBLIC TRANSFERS*/
590 function transfer(address _to, uint256 _value) external returns (bool){
591 _transfer(msg.sender, _to, _value);
592 return true;
593 }
594 
595 /*APPROVE THIRD PARTY SPENDING*/
596 function approve(address _spender, uint256 _value) public returns (bool success){
597 /*update allowance record*/    
598 allowed[msg.sender][_spender] = _value;
599 /*broadcast approval*/
600 emit Approval(msg.sender, _spender, _value); 
601 return true;                                        
602 }
603 
604 /*THIRD PARTY TRANSFER*/
605 function transferFrom(address _from, address _to, uint256 _value) 
606 external returns (bool success) {
607 /*check if the message sender can spend*/
608 require(_value <= allowed[_from][msg.sender]); 
609 /*substract from message sender's spend allowance*/
610 allowed[_from][msg.sender] -= _value;
611 /*transfer tokens*/
612 _transfer(_from, _to, _value);
613 return true;
614 }
615 
616 /*APPROVE SPEND ALLOWANCE AND CALL SPENDER*/
617 function approveAndCall(address _spender, uint256 _value, 
618  bytes _extraData) external returns (bool success) {
619 tokenRecipient 
620 spender = tokenRecipient(_spender);
621 if(approve(_spender, _value)) {
622 spender.receiveApproval(msg.sender, _value, this, _extraData);
623 }
624 return true;
625 }
626 
627 /*INVALID TRANSACTIONS*/
628 function () payable external{
629 revert();  
630 }
631 }/////////////////////////////////end of toc token contract