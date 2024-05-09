1 pragma solidity ^0.4.16;
2 contract TocIcoData{
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
20 bool Suspend;    
21 bool PrivateSale;
22 bool PreSale;
23 bool MainSale; 
24 bool End;
25 }
26 
27 struct Market{
28 uint256 EtherPrice;    
29 uint256 TocPrice;    
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
55 function GeneralUpdate(uint256 _etherprice, uint256 _tocprice) external returns(bool){
56 /*integrity checks*/    
57 if(admin[msg.sender].Authorised == false) revert();
58 if(admin[msg.sender].Level < 5 ) revert();
59 /*update market record*/
60 market[ContractAddr].EtherPrice = _etherprice; 
61 market[ContractAddr].TocPrice = _tocprice;
62 return true;
63 }
64 
65 /*UPDATE ETHER PRICE*/
66 function EtherPriceUpdate(uint256 _etherprice)external returns(bool){
67 /*integrity checks*/    
68 if(admin[msg.sender].Authorised == false) revert();
69 if(admin[msg.sender].Level < 5 ) revert();
70 /*update market record*/
71 market[ContractAddr].EtherPrice = _etherprice; 
72 return true;
73 }
74 
75 /*UPDATE STATE*/
76 function UpdateState(uint256 _state) external returns(bool){
77 /*integrity checks*/    
78 if(admin[msg.sender].Authorised == false) revert();
79 if(admin[msg.sender].Level < 5 ) revert();
80 /*suspend sale state*/
81 if(_state == 1){
82 state[ContractAddr].Suspend = true;     
83 state[ContractAddr].PrivateSale = false; 
84 state[ContractAddr].PreSale = false;
85 state[ContractAddr].MainSale = false;
86 state[ContractAddr].End = false;
87 }
88 /*private sale state*/
89 if(_state == 2){
90 state[ContractAddr].Suspend = false;     
91 state[ContractAddr].PrivateSale = true; 
92 state[ContractAddr].PreSale = false;
93 state[ContractAddr].MainSale = false;
94 state[ContractAddr].End = false;
95 }
96 /*presale state*/
97 if(_state == 3){
98 state[ContractAddr].Suspend = false;    
99 state[ContractAddr].PrivateSale = false; 
100 state[ContractAddr].PreSale = true;
101 state[ContractAddr].MainSale = false;
102 state[ContractAddr].End = false;
103 }
104 /*main sale state*/
105 if(_state == 4){
106 state[ContractAddr].Suspend = false;    
107 state[ContractAddr].PrivateSale = false; 
108 state[ContractAddr].PreSale = false;
109 state[ContractAddr].MainSale = true;
110 state[ContractAddr].End = false;
111 }
112 /*end state*/
113 if(_state == 5){
114 state[ContractAddr].Suspend = false;    
115 state[ContractAddr].PrivateSale = false; 
116 state[ContractAddr].PreSale = false;
117 state[ContractAddr].MainSale = false;
118 state[ContractAddr].End = true;
119 }
120 return true;
121 }
122 
123 /*GETTERS*/
124 
125 /*get suspend state*/
126 function GetSuspend() public view returns (bool){
127 return state[ContractAddr].Suspend;
128 }
129 /*get private sale state*/
130 function GetPrivateSale() public view returns (bool){
131 return state[ContractAddr].PrivateSale;
132 }
133 /*get pre sale state*/
134 function GetPreSale() public view returns (bool){
135 return state[ContractAddr].PreSale;
136 }
137 /*get main sale state*/
138 function GetMainSale() public view returns (bool){
139 return state[ContractAddr].MainSale;
140 }
141 /*get end state*/
142 function GetEnd() public view returns (bool){
143 return state[ContractAddr].End;
144 }
145 /*get ether price*/
146 function GetEtherPrice() public view returns (uint256){
147 return market[ContractAddr].EtherPrice;
148 }
149 /*get toc price*/
150 function GetTocPrice() public view returns (uint256){
151 return market[ContractAddr].TocPrice;
152 }
153 
154 }///////////////////////////////////end of icodata contract
155 
156 
157 pragma solidity ^0.4.16;
158 contract TocIcoDapp{
159 /////////////////////////////////////////////////////////    
160 ///////(c)2017 tokenchanger.io -all rights reserved////// 
161  
162 /*SUPER ADMINS*/
163 address Mars = 0x1947f347B6ECf1C3D7e1A58E3CDB2A15639D48Be;
164 address Mercury = 0x00795263bdca13104309Db70c11E8404f81576BE;
165 address Europa = 0x00e4E3eac5b520BCa1030709a5f6f3dC8B9e1C37;
166 address Jupiter = 0x2C76F260707672e240DC639e5C9C62efAfB59867;
167 address Neptune = 0xEB04E1545a488A5018d2b5844F564135211d3696;
168 
169 /*GLOBAL VARIABLES*/
170 uint256 Converter = 10000;
171 
172 /*CONTRACT ADDRESS*/
173 function GetContractAddr() public constant returns (address){
174 return this;
175 }	
176 address ContractAddr = GetContractAddr();
177 
178 struct Buyer{
179 bool Withdrawn;    
180 uint256 TocBalance;
181 uint256 WithdrawalBlock;
182 uint256 Num;
183 }
184 
185 struct Transaction{
186 uint256 Amount;
187 uint256 EtherPrice;
188 uint256 TocPrice;
189 uint256 Block;
190 }    
191 
192 struct AddressBook{
193 address TOCAddr;
194 address DataAddr;
195 address Banker;
196 }
197 
198 struct Admin{
199 bool Authorised; 
200 uint256 Level;
201 }
202 
203 struct OrderBooks{
204 uint256 PrivateSupply;
205 uint256 PreSupply;
206 uint256 MainSupply;
207 }
208 
209 /*buyer account*/
210 mapping (address => Buyer) public buyer;
211 /*buyer transactions*/
212 mapping(address => mapping(uint256 => Transaction)) public transaction;
213 /*order books store*/
214 mapping (address => OrderBooks) public orderbooks;
215 /*server address book*/
216 mapping (address => AddressBook) public addressbook;
217 /*authorised admins*/
218 mapping (address => Admin) public admin;
219 
220 struct TA{
221 uint256 n1;
222 uint256 n2;
223 uint256 n3;
224 uint256 n4;
225 uint256 n5;
226 uint256 n6;
227 }
228 
229 struct LA{
230 bool l1;
231 bool l2;
232 bool l3;
233 bool l4;
234 }
235 
236 /*initialise process variables*/
237 TA ta;
238 LA la;
239 
240 /*AUTHORISE ADMIN*/
241 function AuthAdmin(address _admin, bool _authority, uint256 _level) external 
242 returns(bool) {
243 if((msg.sender != Mars) && (msg.sender != Mercury) && (msg.sender != Europa)
244 && (msg.sender != Jupiter) && (msg.sender != Neptune)) revert();  
245 admin[_admin].Authorised = _authority; 
246 admin[_admin].Level = _level;
247 return true;
248 } 
249 
250 /*ADD ADDRESSES TO ADDRESS BOOK*/
251 function AuthAddr(address _tocaddr, address _dataddr, address _banker) 
252 external returns(bool){
253 /*integrity checks*/      
254 if(admin[msg.sender].Authorised == false) revert();
255 if(admin[msg.sender].Level < 5 ) revert();
256 /*update address record*/
257 addressbook[ContractAddr].TOCAddr = _tocaddr;
258 addressbook[ContractAddr].DataAddr = _dataddr;
259 addressbook[ContractAddr].Banker = _banker;
260 return true;
261 }
262 
263 /*TOC SUPPLY OPERATIONS*/
264 function SupplyOp(uint256 _type, uint256 _stage, uint256 _amount) external returns (bool){
265 /*integrity checks*/    
266 if(admin[msg.sender].Authorised == false) revert();
267 if(admin[msg.sender].Level < 5 ) revert(); 
268 /*increase private sale supply*/
269 if((_type == 1) && (_stage == 1)){
270 orderbooks[ContractAddr].PrivateSupply += _amount; 
271 }
272 /*decrease private sale supply*/
273 if((_type == 0) && (_stage == 1)){
274 require(orderbooks[ContractAddr].PrivateSupply >= _amount);
275 orderbooks[ContractAddr].PrivateSupply -= _amount; 
276 }
277 /*increase presale supply*/
278 if((_type == 1) && (_stage == 2)){
279 orderbooks[ContractAddr].PreSupply += _amount; 
280 }
281 /*decrease presale supply*/
282 if((_type == 0) && (_stage == 2)){
283 require(orderbooks[ContractAddr].PreSupply >= _amount);    
284 orderbooks[ContractAddr].PreSupply -= _amount; 
285 }
286 /*increase main sale supply*/
287 if((_type == 1) && (_stage == 3)){
288 orderbooks[ContractAddr].MainSupply += _amount; 
289 }
290 /*decrease main sale supply*/
291 if((_type == 0) && (_stage == 3)){
292 require(orderbooks[ContractAddr].MainSupply >= _amount);    
293 orderbooks[ContractAddr].MainSupply -= _amount; 
294 }
295 return true;
296 }
297 
298 /*CALCULATE TOC PURCHASED*/
299 function CalcToc(uint256 _etherprice, uint256 _tocprice, uint256 _deposit) 
300 internal returns (uint256){    
301 ta.n1 = mul(_etherprice, _deposit);
302 ta.n2 = div(ta.n1,_tocprice);
303 return ta.n2;
304 }
305 
306 /*PRIVATE SALE*/
307 function PrivateSaleBuy() payable external returns (bool){
308 /*integrity checks*/    
309 if(msg.value <= 0) revert();
310 /*connect to ico data contract*/
311 TocIcoData
312 DataCall = TocIcoData(addressbook[ContractAddr].DataAddr);
313 /*get transaction information*/
314 la.l1 = DataCall.GetEnd();
315 la.l2 = DataCall.GetPrivateSale();
316 la.l3 = DataCall.GetSuspend();
317 ta.n3 = DataCall.GetEtherPrice();    
318 ta.n4 = DataCall.GetTocPrice();    
319 /*intergrity checks*/ 
320 if(la.l1 == true) revert();
321 if(la.l2 == false) revert();
322 if(la.l3 == true) revert();
323 /*calculate toc purchased & determine supply avaliability*/
324 ta.n5 = CalcToc(ta.n3, ta.n4, msg.value);
325 if(ta.n5 > orderbooks[ContractAddr].PrivateSupply) revert();
326 /*payments and delivery*/
327 addressbook[ContractAddr].Banker.transfer(msg.value);
328 /*update transaction records*/
329 orderbooks[ContractAddr].PrivateSupply -= ta.n5;
330 buyer[msg.sender].TocBalance += ta.n5;
331 buyer[msg.sender].Num += 1;
332 ta.n6 = buyer[msg.sender].Num; 
333 transaction[msg.sender][ta.n6].Amount = ta.n5;
334 transaction[msg.sender][ta.n6].EtherPrice = ta.n3;
335 transaction[msg.sender][ta.n6].TocPrice = ta.n4;
336 transaction[msg.sender][ta.n6].Block = block.number;
337 return true;
338 }    
339 
340 /*PRESALE*/
341 function PreSaleBuy() payable external returns (bool){
342 /*integrity checks*/    
343 if(msg.value <= 0) revert();
344 /*connect to ico data contract*/
345 TocIcoData
346 DataCall = TocIcoData(addressbook[ContractAddr].DataAddr);
347 /*get transaction information*/
348 la.l1 = DataCall.GetEnd();
349 la.l2 = DataCall.GetPreSale();
350 la.l3 = DataCall.GetSuspend();
351 ta.n3 = DataCall.GetEtherPrice();    
352 ta.n4 = DataCall.GetTocPrice();    
353 /*intergrity checks*/ 
354 if(la.l1 == true) revert();
355 if(la.l2 == false) revert();
356 if(la.l3 == true) revert();
357 /*calculate toc purchased & determine supply avaliability*/
358 ta.n5 = CalcToc(ta.n3, ta.n4, msg.value);
359 if(ta.n5 > orderbooks[ContractAddr].PreSupply) revert();
360 /*payments and delivery*/
361 addressbook[ContractAddr].Banker.transfer(msg.value);
362 /*update transaction records*/
363 orderbooks[ContractAddr].PreSupply -= ta.n5;
364 buyer[msg.sender].TocBalance += ta.n5;
365 buyer[msg.sender].Num += 1;
366 ta.n6 = buyer[msg.sender].Num; 
367 transaction[msg.sender][ta.n6].Amount = ta.n5;
368 transaction[msg.sender][ta.n6].EtherPrice = ta.n3;
369 transaction[msg.sender][ta.n6].TocPrice = ta.n4;
370 transaction[msg.sender][ta.n6].Block = block.number;
371 return true;
372 }    
373 
374 /*MAIN SALE*/
375 function MainSaleBuy() payable external returns (bool){
376 /*integrity checks*/    
377 if(msg.value <= 0) revert();
378 /*connect to ico data contract*/
379 TocIcoData
380 DataCall = TocIcoData(addressbook[ContractAddr].DataAddr);
381 /*get transaction information*/
382 la.l1 = DataCall.GetEnd();
383 la.l2 = DataCall.GetMainSale();
384 la.l3 = DataCall.GetSuspend();
385 ta.n3 = DataCall.GetEtherPrice();    
386 ta.n4 = DataCall.GetTocPrice();    
387 /*intergrity checks*/ 
388 if(la.l1 == true) revert();
389 if(la.l2 == false) revert();
390 if(la.l3 == true) revert();
391 /*calculate toc purchased & determine supply avaliability*/
392 ta.n5 = CalcToc(ta.n3, ta.n4, msg.value);
393 if(ta.n5 > orderbooks[ContractAddr].MainSupply) revert();
394 /*payments and delivery*/
395 addressbook[ContractAddr].Banker.transfer(msg.value);
396 /*update transaction records*/
397 orderbooks[ContractAddr].MainSupply -= ta.n5;
398 buyer[msg.sender].TocBalance += ta.n5;
399 buyer[msg.sender].Num += 1;
400 ta.n6 = buyer[msg.sender].Num; 
401 transaction[msg.sender][ta.n6].Amount = ta.n5;
402 transaction[msg.sender][ta.n6].EtherPrice = ta.n3;
403 transaction[msg.sender][ta.n6].TocPrice = ta.n4;
404 transaction[msg.sender][ta.n6].Block = block.number;
405 return true;
406 }    
407 
408 /*WITHDRAW TOC TOKENS*/
409 function Withdraw() external returns (bool){
410 /*connect to ico data contract*/
411 TocIcoData
412 DataCall = TocIcoData(addressbook[ContractAddr].DataAddr);
413 /*get ico cycle information*/
414 la.l4 = DataCall.GetEnd();
415 /*integrity checks*/ 
416 if(la.l4 == false) revert();
417 if(buyer[msg.sender].TocBalance <= 0) revert();
418 if(buyer[msg.sender].Withdrawn == true) revert();
419 /*update buyer record*/
420 buyer[msg.sender].Withdrawn = true;
421 buyer[msg.sender].WithdrawalBlock = block.number;
422 /*connect to toc contract*/
423 TOC
424 TOCCall = TOC(addressbook[ContractAddr].TOCAddr);
425 /*check integrity before sending tokens*/
426 assert(buyer[msg.sender].Withdrawn == true);
427 /*send toc to message sender*/
428 TOCCall.transfer(msg.sender,buyer[msg.sender].TocBalance);
429 /*check integrity after sending tokens*/
430 assert(buyer[msg.sender].Withdrawn == true);
431 return true;
432 }  
433 
434 /*RECEIVE APPROVAL & WITHDRAW TOC TOKENS*/
435 function receiveApproval(address _from, uint256 _value, 
436 address _token, bytes _extraData) external returns(bool){ 
437 TOC
438 TOCCall = TOC(_token);
439 TOCCall.transferFrom(_from,this,_value);
440 return true;
441 }
442 
443 /*INVALID TRANSACTIONS*/
444 function () payable external{
445 revert();  
446 }
447 
448 /*SAFE MATHS*/
449 function mul(uint256 a, uint256 b) public pure returns (uint256) {
450     uint256 c = a * b;
451     assert(a == 0 || c / a == b);
452     return c;
453   }
454 function div(uint256 a, uint256 b) public pure returns (uint256) {
455     // assert(b > 0); // Solidity automatically throws when dividing by 0
456     uint256 c = a / b;
457     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
458     return c;
459   }  
460 function sub(uint256 a, uint256 b) public pure returns (uint256) {
461     assert(b <= a);
462     return a - b;
463   }
464 function add(uint256 a, uint256 b) public pure returns (uint256) {
465     uint256 c = a + b;
466     assert(c >= a);
467     return c;
468   }
469  
470 }///////////////////////////////////end of icodapp contract
471 
472 
473 pragma solidity ^0.4.16;
474 
475 /*SPEND APPROVAL ALERT INTERFACE*/
476 interface tokenRecipient { 
477 function receiveApproval(address _from, uint256 _value, 
478 address _token, bytes _extraData) external; 
479 }
480 
481 contract TOC {
482 /*tokenchanger.io*/
483 
484 /*TOC TOKEN*/
485 string public name;
486 string public symbol;
487 uint8 public decimals;
488 uint256 public totalSupply;
489 
490 /*user coin balance*/
491 mapping (address => uint256) public balances;
492 /*user coin allowances*/
493 mapping(address => mapping (address => uint256)) public allowed;
494 
495 /*EVENTS*/		
496 /*broadcast token transfers on the blockchain*/
497 event Transfer(address indexed from, address indexed to, uint256 value);
498 /*broadcast token spend approvals on the blockchain*/
499 event Approval(address indexed _owner, address indexed _spender, uint _value);
500 
501 /*MINT TOKEN*/
502 constructor() public {
503 name = "Token Changer";
504 symbol = "TOC";
505 decimals = 18;
506 /*one billion base units*/
507 totalSupply = 10**27;
508 balances[msg.sender] = totalSupply; 
509 }
510 
511 /*INTERNAL TRANSFER*/
512 function _transfer(address _from, address _to, uint _value) internal {    
513 /*prevent transfer to invalid address*/    
514 if(_to == 0x0) revert();
515 /*check if the sender has enough value to send*/
516 if(balances[_from] < _value) revert(); 
517 /*check for overflows*/
518 if(balances[_to] + _value < balances[_to]) revert();
519 /*compute sending and receiving balances before transfer*/
520 uint PreviousBalances = balances[_from] + balances[_to];
521 /*substract from sender*/
522 balances[_from] -= _value;
523 /*add to the recipient*/
524 balances[_to] += _value; 
525 /*check integrity of transfer operation*/
526 assert(balances[_from] + balances[_to] == PreviousBalances);
527 /*broadcast transaction*/
528 emit Transfer(_from, _to, _value); 
529 }
530 
531 /*PUBLIC TRANSFERS*/
532 function transfer(address _to, uint256 _value) external returns (bool){
533 _transfer(msg.sender, _to, _value);
534 return true;
535 }
536 
537 /*APPROVE THIRD PARTY SPENDING*/
538 function approve(address _spender, uint256 _value) public returns (bool success){
539 /*update allowance record*/    
540 allowed[msg.sender][_spender] = _value;
541 /*broadcast approval*/
542 emit Approval(msg.sender, _spender, _value); 
543 return true;                                        
544 }
545 
546 /*THIRD PARTY TRANSFER*/
547 function transferFrom(address _from, address _to, uint256 _value) 
548 external returns (bool success) {
549 /*check if the message sender can spend*/
550 require(_value <= allowed[_from][msg.sender]); 
551 /*substract from message sender's spend allowance*/
552 allowed[_from][msg.sender] -= _value;
553 /*transfer tokens*/
554 _transfer(_from, _to, _value);
555 return true;
556 }
557 
558 /*APPROVE SPEND ALLOWANCE AND CALL SPENDER*/
559 function approveAndCall(address _spender, uint256 _value, 
560  bytes _extraData) external returns (bool success) {
561 tokenRecipient 
562 spender = tokenRecipient(_spender);
563 if(approve(_spender, _value)) {
564 spender.receiveApproval(msg.sender, _value, this, _extraData);
565 }
566 return true;
567 }
568 
569 /*INVALID TRANSACTIONS*/
570 function () payable external{
571 revert();  
572 }
573 
574 }/////////////////////////////////end of toc token contract