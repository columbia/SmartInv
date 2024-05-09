1 pragma solidity ^0.4.24;
2 
3 contract PerformanceBond {
4 /*(c)2018 tokenchanger.io -all rights reserved*/
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
19 /*GLOBAL*/
20 uint256 PercentConverter = 10000;
21 
22 /*DATA STRUCTURE*/
23 struct Bond{
24 uint256 BondNum;
25 }
26 
27 struct Specification{
28 uint256 WriterDeposit;
29 uint256 BeneficiaryStake;
30 uint256 BeneficiaryDeposit;
31 uint256 ExtensionLimit;
32 uint256 CreationBlock;
33 uint256 ExpirationBlock;
34 address BondWriter;
35 address BondBeneficiary;
36 bool StopExtension;
37 bool Activated;
38 bool Dispute;
39 uint256 CtrFee;
40 uint256 ArbFee;
41 }
42 
43 struct Agreement{
44 address Arbiter;
45 bool Writer;    
46 bool Beneficiary;    
47 }
48 
49 struct Settlement{
50 uint256 Writer;    
51 uint256 Beneficiary;
52 bool WriterSettled;
53 bool BeneficiarySettled;
54 bool Judgement;
55 }
56 
57 struct User{
58 uint256 TransactionNum;
59 }
60 
61 struct Log{
62 uint256 BondNum;
63 }
64 
65 struct Admin{
66 bool Authorised; 
67 uint256 Level;
68 }
69 
70 struct Arbiter{
71 bool Registered; 
72 }
73 
74 struct Configuration{
75 uint256 ArbiterFee;
76 uint256 ContractFee;
77 uint256 StakePercent;
78 address Banker;
79 }
80 
81 struct TR{
82 uint256 n0;    
83 uint256 n1;
84 uint256 n2;
85 uint256 n3;
86 uint256 n4;
87 uint256 n5;
88 uint256 n6;
89 uint256 n7;
90 uint256 n8;
91 uint256 n9;
92 }
93 
94 struct Identifier {
95 uint256 c0;    
96 uint256 c1;
97 uint256 c2;
98 uint256 c3;
99 uint256 c4;
100 uint256 c5;
101 uint256 c6;
102 uint256 c7;
103 }
104 
105 /*initialise process variables*/
106 TR tr;
107 Identifier id;
108 
109 /*DATA STORAGE*/
110 mapping (address => Bond) public bond;
111 mapping (uint256 => Specification) public spec;
112 mapping (uint256 => Agreement) public agree;
113 mapping (address => User) public user;
114 mapping (uint256 => Settlement) public settle;
115 mapping (address => mapping (uint256 => Log)) public tracker;
116 mapping (address => Configuration) public config;
117 mapping (address => Admin) public admin;
118 mapping (address => Arbiter) public arbiter;
119 
120 /*AUTHORISE ADMIN*/
121 function AuthAdmin(address _admin, bool _authority, uint256 _level) external 
122 returns(bool) {
123 if((msg.sender != Mars) && (msg.sender != Mercury) && (msg.sender != Europa)
124 && (msg.sender != Jupiter) && (msg.sender != Neptune)) revert();  
125 admin[_admin].Authorised = _authority; 
126 admin[_admin].Level = _level;
127 return true;
128 } 
129 
130 /*CONFIGURE CONTRACT*/
131 function SetUp(uint256 _afee,uint256 _cfee,uint256 _spercent,address _banker) 
132 external returns(bool){
133 /*integrity checks*/      
134 if(admin[msg.sender].Authorised == false) revert();
135 if(admin[msg.sender].Level < 5 ) revert();
136 /*update contract configuration*/
137 config[ContractAddr].ArbiterFee = _afee;
138 config[ContractAddr].ContractFee = _cfee;
139 config[ContractAddr].StakePercent = _spercent;
140 config[ContractAddr].Banker = _banker;
141 return true;
142 }
143 
144 /*REGISTER ARBITER*/
145 function Register(address arbiter_, bool authority_) external 
146 returns(bool) {
147 /*integrity checks*/      
148 if(admin[msg.sender].Authorised == false) revert();
149 if(admin[msg.sender].Level < 5 ) revert();
150 /*register arbitrator*/
151 arbiter[arbiter_].Registered = authority_; 
152 return true;
153 }
154 
155 /*PERCENTAGE CALCULATOR*/
156 function Percent(uint256 _value, uint256 _percent) internal returns(uint256){
157 tr.n1 = mul(_value,_percent);
158 tr.n2 = div(tr.n1,PercentConverter);
159 return tr.n2;
160 } 
161 
162 /*WRITE PERFORMANCE BOND*/
163 function WriteBond(uint256 _expire, address _bene, address _arbi) payable external returns (bool){
164 /*integrity checks*/    
165 if(msg.value <= 0) revert();
166 require(arbiter[_arbi].Registered == true);
167 /*assign bond number*/
168 bond[ContractAddr].BondNum += 1;
169 tr.n3 = bond[ContractAddr].BondNum; 
170 /*write bond*/
171 spec[tr.n3].WriterDeposit = msg.value;
172 tr.n4 = Percent(msg.value,config[ContractAddr].StakePercent);
173 spec[tr.n3].BeneficiaryStake = tr.n4;
174 spec[tr.n3].ExtensionLimit = _expire;
175 spec[tr.n3].CreationBlock = block.number;
176 tr.n5 = add(block.number,_expire);
177 spec[tr.n3].ExpirationBlock = tr.n5;
178 spec[tr.n3].BondWriter = msg.sender;
179 spec[tr.n3].BondBeneficiary = _bene;
180 /*create writer record*/
181 user[msg.sender].TransactionNum += 1;
182 tr.n6 = user[msg.sender].TransactionNum;
183 tracker[msg.sender][tr.n6].BondNum = tr.n3;
184 /*create beneficiary record*/
185 user[_bene].TransactionNum += 1;
186 tr.n7 = user[_bene].TransactionNum;
187 tracker[_bene][tr.n7].BondNum = tr.n3;
188 /*create arbitration record*/
189 agree[tr.n3].Arbiter = _arbi;
190 agree[tr.n3].Writer = true;
191 /*determine transaction fees*/
192 tr.n0 = Percent(msg.value,config[ContractAddr].ContractFee);
193 id.c0 = Percent(msg.value,config[ContractAddr].ArbiterFee);
194 /*transaction fees*/
195 spec[tr.n3].CtrFee = tr.n0;
196 spec[tr.n3].ArbFee = id.c0;
197 return true;
198 }    
199 
200 /*STOP OR ENABLE CHANGE OF BOND EXPIRATION TIME*/
201 function ChangeExtension(uint256 _bondnum, bool _change) external returns(bool){
202 /*integrity checks*/     
203 require(spec[_bondnum].BondWriter == msg.sender);
204 /*change record*/
205 spec[_bondnum].StopExtension = _change;
206 return true;
207 } 
208 
209 /*DEPOSIT BENEFICIARY STAKE*/
210 function BeneficiaryStake(uint256 _bondnum) payable external returns(bool){
211 /*integrity checks*/
212 if(msg.value <= 0) revert();
213 require(spec[_bondnum].BondBeneficiary == msg.sender);
214 require(spec[_bondnum].ExpirationBlock >= block.number);
215 require(spec[_bondnum].Activated == false);
216 require(settle[_bondnum].WriterSettled == false);
217 require(msg.value >= spec[_bondnum].BeneficiaryStake);
218 /*change record*/
219 spec[_bondnum].Activated = true;
220 spec[_bondnum].BeneficiaryDeposit = msg.value;
221 return true;
222 } 
223 
224 /*APPOINT ARBITRATOR*/
225 function Appoint(uint256 _bondnum, address _arbi) external returns(bool){
226 /*integrity checks*/
227 require(arbiter[_arbi].Registered == true); 
228 if((agree[_bondnum].Writer ==true) && (agree[_bondnum].Beneficiary == true)) revert();
229 /*bond beneficiary appointment*/     
230 if(spec[_bondnum].BondBeneficiary == msg.sender){
231 agree[_bondnum].Arbiter = _arbi;
232 agree[_bondnum].Beneficiary = true;
233 agree[_bondnum].Writer = false;
234 }
235 /*bond writer appointment*/     
236 if(spec[_bondnum].BondWriter == msg.sender){
237 agree[_bondnum].Arbiter = _arbi;
238 agree[_bondnum].Writer = true;
239 agree[_bondnum].Beneficiary = false;
240 }
241 return true;
242 } 
243 
244 /*FILE A DISPUTE*/
245 function Dispute(uint256 _bondnum) external returns(bool){
246 /*integrity checks*/     
247 require(spec[_bondnum].Activated == true);
248 require(settle[_bondnum].WriterSettled == false);    
249 require(settle[_bondnum].BeneficiarySettled == false);      
250 /*bond beneficiary*/     
251 if(spec[_bondnum].BondBeneficiary == msg.sender){
252 spec[_bondnum].Dispute = true;
253 }
254 /*bond writer*/     
255 if(spec[_bondnum].BondWriter == msg.sender){
256 spec[_bondnum].Dispute = true;
257 }
258 return true;
259 } 
260 
261 /*APPROVE ARBITRATOR*/
262 function Approve(uint256 _bondnum) external returns(bool){
263 /*bond beneficiary approve*/     
264 if(spec[_bondnum].BondBeneficiary == msg.sender){
265 agree[_bondnum].Beneficiary = true;
266 }
267 /*bond writer approve*/     
268 if(spec[_bondnum].BondWriter == msg.sender){
269 agree[_bondnum].Writer = true;
270 }
271 return true;
272 } 
273 
274 /*ARBITRATOR JUDGEMENT*/
275 function Judgement(uint256 _bondnum, uint256 writer_, uint256 bene_) external returns(bool){
276 /*integrity check-1*/ 
277 require(spec[_bondnum].Dispute == true);
278 require(agree[_bondnum].Arbiter == msg.sender);
279 require(agree[_bondnum].Writer == true);
280 require(agree[_bondnum].Beneficiary == true);
281 require(settle[_bondnum].Judgement == false);
282 /*change judgement status*/
283 settle[_bondnum].Judgement = true;
284 /*integrity check-2*/
285 tr.n8 = add(spec[_bondnum].WriterDeposit,spec[_bondnum].BeneficiaryDeposit);
286 tr.n9 = add(writer_,bene_);
287 assert(tr.n9 <= tr.n8);
288 /*assign judgement values*/
289 settle[_bondnum].Writer = writer_;
290 settle[_bondnum].Beneficiary = bene_;
291 return true;
292 } 
293 
294 /*EXTEND PERFORMANCE BOND EXPIRATION TIME*/
295 function Extend(uint256 _bondnum, uint256 _blocks) external returns(bool){
296 /*integrity checks*/  
297 require(spec[_bondnum].StopExtension == false);
298 require(spec[_bondnum].BondBeneficiary == msg.sender);
299 require(spec[_bondnum].ExpirationBlock >= block.number);
300 require(_blocks <= spec[_bondnum].ExtensionLimit);
301 /*change record*/
302 spec[_bondnum].ExpirationBlock = add(block.number,_blocks);
303 return true;
304 } 
305 
306 /*SETTLE PERFORMANCE BOND*/
307 function SettleBond(uint256 _bondnum) external returns(bool){
308 /*determine transaction fees*/     
309 id.c1 = spec[_bondnum].CtrFee;
310 id.c2 = spec[_bondnum].ArbFee;
311 id.c3 = add(id.c1,id.c2);
312 
313 /*non-activated bond: bond writer*/
314 if((spec[_bondnum].BondWriter == msg.sender) && (spec[_bondnum].Activated == false)){
315 /*integrity checks*/ 
316 require(settle[_bondnum].WriterSettled == false);
317 /*change writer settlement status*/
318 settle[_bondnum].WriterSettled = true;
319 /*settle performnace bond*/
320 msg.sender.transfer(spec[_bondnum].WriterDeposit);
321 assert(settle[_bondnum].WriterSettled == true);
322 }
323 
324 /*activated bond is not disputed: bond writer*/
325 if((block.number > spec[_bondnum].ExpirationBlock) && (spec[_bondnum].Dispute == false)
326 && (spec[_bondnum].BondWriter == msg.sender) && (spec[_bondnum].Activated == true)){
327 /*integrity checks*/ 
328 require(settle[_bondnum].WriterSettled == false);
329 /*change writer settlement status*/
330 settle[_bondnum].WriterSettled = true;
331 /*settle performnace bond*/
332 id.c4 = sub(spec[_bondnum].WriterDeposit,id.c3);
333 config[ContractAddr].Banker.transfer(id.c1);
334 agree[_bondnum].Arbiter.transfer(id.c2);
335 msg.sender.transfer(id.c4);
336 assert(settle[_bondnum].WriterSettled == true);
337 }/*bond writer: bond not disputed*/
338 
339 /*bond is disputed: bond writer*/
340 if((settle[_bondnum].Judgement == true) && (spec[_bondnum].Dispute == true)
341 && (spec[_bondnum].BondWriter == msg.sender)){
342 /*integrity checks*/ 
343 require(settle[_bondnum].WriterSettled == false);
344 /*change writer settlement status*/
345 settle[_bondnum].WriterSettled = true;
346 /*writer can pay fees*/
347 if(settle[_bondnum].Writer > id.c3){
348 id.c5 = sub(settle[_bondnum].Writer,id.c3);
349 config[ContractAddr].Banker.transfer(id.c1);
350 agree[_bondnum].Arbiter.transfer(id.c2);
351 msg.sender.transfer(id.c5);
352 }/*writer can pay fees*/
353 assert(settle[_bondnum].WriterSettled == true);
354 }
355 
356 /*bond is disputed: bond beneficiary*/
357 if((settle[_bondnum].Judgement == true) && (spec[_bondnum].Dispute == true)
358 && (spec[_bondnum].BondBeneficiary == msg.sender)){
359 /*integrity checks*/ 
360 require(settle[_bondnum].BeneficiarySettled == false);
361 /*change beneficiary settlement status*/
362 settle[_bondnum].BeneficiarySettled = true;
363 /*beneficiary can pay fees*/
364 if(settle[_bondnum].Beneficiary > id.c3){
365 id.c6 = sub(settle[_bondnum].Beneficiary,id.c3);
366 config[ContractAddr].Banker.transfer(id.c1);
367 agree[_bondnum].Arbiter.transfer(id.c2);
368 msg.sender.transfer(id.c6);
369 }/*bond beneficiary can pay fees*/
370 assert(settle[_bondnum].BeneficiarySettled == true);
371 }
372 
373 /*activated bond is not disputed: bond beneficiary*/
374 if((block.number > spec[_bondnum].ExpirationBlock) && (spec[_bondnum].Dispute == false)
375 && (spec[_bondnum].BondBeneficiary == msg.sender) && (spec[_bondnum].Activated == true)){
376 /*integrity checks*/ 
377 require(settle[_bondnum].BeneficiarySettled == false);
378 /*change writer settlement status*/
379 settle[_bondnum].BeneficiarySettled = true;
380 /*settle performnace bond*/
381 id.c7 = sub(spec[_bondnum].BeneficiaryDeposit,id.c3);
382 config[ContractAddr].Banker.transfer(id.c1);
383 agree[_bondnum].Arbiter.transfer(id.c2);
384 msg.sender.transfer(id.c7);
385 assert(settle[_bondnum].BeneficiarySettled == true);
386 }/*bond beneficiary: no dispute*/
387 
388 return true;
389 }/*end of settle bond*/ 
390 
391 /*INVALID TRANSACTIONS*/
392 function () payable external{
393 revert();  
394 }
395 
396 /*SAFE MATHS*/
397 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
398     uint256 c = a * b;
399     assert(a == 0 || c / a == b);
400     return c;
401   }
402 function div(uint256 a, uint256 b) internal pure returns (uint256) {
403     // assert(b > 0); // Solidity automatically throws when dividing by 0
404     uint256 c = a / b;
405     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
406     return c;
407   }
408   
409 function add(uint256 a, uint256 b) internal pure returns (uint256) {
410     uint256 c = a + b;
411     assert(c >= a);
412     return c;
413   }  
414  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
415     assert(b <= a);
416     return a - b;
417   }
418 }////////////////////////////////end of PerformanceBond contract