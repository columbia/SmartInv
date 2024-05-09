1 pragma solidity ^0.4.16;
2 
3 /*SPEND APPROVAL ALERT INTERFACE*/
4 interface tokenRecipient { 
5 function receiveApproval(address _from, uint256 _value, 
6 address _token, bytes _extraData) external; 
7 }
8 
9 contract TOC {
10 /*tokenchanger.io*/
11 
12 /*TOC TOKEN*/
13 string public name;
14 string public symbol;
15 uint8 public decimals;
16 uint256 public totalSupply;
17 
18 /*user coin balance*/
19 mapping (address => uint256) public balances;
20 /*user coin allowances*/
21 mapping(address => mapping (address => uint256)) public allowed;
22 
23 /*EVENTS*/		
24 /*broadcast token transfers on the blockchain*/
25 event BroadcastTransfer(address indexed from, address indexed to, uint256 value);
26 /*broadcast token spend approvals on the blockchain*/
27 event BroadcastApproval(address indexed _owner, address indexed _spender, uint _value);
28 
29 /*MINT TOKEN*/
30 function TOC() public {
31 name = "TOC";
32 symbol = "TOC";
33 decimals = 18;
34 /*one billion base units*/
35 totalSupply = 10**27;
36 balances[msg.sender] = totalSupply; 
37 }
38 
39 /*INTERNAL TRANSFER*/
40 function _transfer(address _from, address _to, uint _value) internal {    
41 /*prevent transfer to invalid address*/    
42 if(_to == 0x0) revert();
43 /*check if the sender has enough value to send*/
44 if(balances[_from] < _value) revert(); 
45 /*check for overflows*/
46 if(balances[_to] + _value < balances[_to]) revert();
47 /*compute sending and receiving balances before transfer*/
48 uint PreviousBalances = balances[_from] + balances[_to];
49 /*substract from sender*/
50 balances[_from] -= _value;
51 /*add to the recipient*/
52 balances[_to] += _value; 
53 /*check integrity of transfer operation*/
54 assert(balances[_from] + balances[_to] == PreviousBalances);
55 /*broadcast transaction*/
56 emit BroadcastTransfer(_from, _to, _value); 
57 }
58 
59 /*PUBLIC TRANSFERS*/
60 function transfer(address _to, uint256 _value) external returns (bool){
61 _transfer(msg.sender, _to, _value);
62 return true;
63 }
64 
65 /*APPROVE THIRD PARTY SPENDING*/
66 function approve(address _spender, uint256 _value) public returns (bool success){
67 /*update allowance record*/    
68 allowed[msg.sender][_spender] = _value;
69 /*broadcast approval*/
70 emit BroadcastApproval(msg.sender, _spender, _value); 
71 return true;                                        
72 }
73 
74 /*THIRD PARTY TRANSFER*/
75 function transferFrom(address _from, address _to, uint256 _value) 
76 external returns (bool success) {
77 /*check if the message sender can spend*/
78 require(_value <= allowed[_from][msg.sender]); 
79 /*substract from message sender's spend allowance*/
80 allowed[_from][msg.sender] -= _value;
81 /*transfer tokens*/
82 _transfer(_from, _to, _value);
83 return true;
84 }
85 
86 /*APPROVE SPEND ALLOWANCE AND CALL SPENDER*/
87 function approveAndCall(address _spender, uint256 _value, 
88  bytes _extraData) external returns (bool success) {
89 tokenRecipient 
90 spender = tokenRecipient(_spender);
91 if(approve(_spender, _value)) {
92 spender.receiveApproval(msg.sender, _value, this, _extraData);
93 }
94 return true;
95 }
96 
97 }/////////////////////////////////end of toc token contract
98 
99 
100 pragma solidity ^0.4.16;
101 contract BlockPoints{
102 /////////////////////////////////////////////////////////    
103 ///////(c)2017 tokenchanger.io -all rights reserved////// 
104  
105 /*SUPER ADMINS*/
106 address Mars = 0x1947f347B6ECf1C3D7e1A58E3CDB2A15639D48Be;
107 address Mercury = 0x00795263bdca13104309Db70c11E8404f81576BE;
108 address Europa = 0x00e4E3eac5b520BCa1030709a5f6f3dC8B9e1C37;
109 address Jupiter = 0x2C76F260707672e240DC639e5C9C62efAfB59867;
110 address Neptune = 0xEB04E1545a488A5018d2b5844F564135211d3696;
111 
112 /*CONTRACT ADDRESS*/
113 function GetContractAddr() public constant returns (address){
114 return this;
115 }	
116 address ContractAddr = GetContractAddr();
117 
118 /*TOKEN VARIABLES*/
119 string public Name;
120 string public Symbol;
121 uint8 public Decimals;
122 uint256 public TotalSupply;
123 
124 struct Global{
125 bool Suspend;
126 uint256 Rate;
127 }
128 
129 struct DApps{
130 bool AuthoriseMint;
131 bool AuthoriseBurn;
132 bool AuthoriseRate;
133 }
134  
135 struct Admin{
136 bool Authorised; 
137 uint256 Level;
138 }
139 
140 struct Coloured{
141 uint256 Amount;
142 uint256 Rate;
143 }
144 
145 struct AddressBook{
146 address TOCAddr;
147 }
148 
149 struct Process{
150 uint256 n1;
151 uint256 n2;
152 uint256 n3;
153 uint256 n4;
154 uint256 n5;
155 }
156 
157 /*INITIALIZE DATA STORES*/
158 Process pr;
159 
160 /*global operational record*/
161 mapping (address => Global) public global;
162 /*user coin balances*/
163 mapping (address => uint256) public balances;
164 /*list of authorised dapps*/
165 mapping (address => DApps) public dapps;
166 /*special exchange rates for block points*/
167 mapping(address => mapping(address => Coloured)) public coloured;
168 /*list of authorised admins*/
169 mapping (address => Admin) public admin;
170 /*comms address book*/
171 mapping (address => AddressBook) public addressbook;
172 
173 
174 /*MINT FIRST TOKEN*/
175 function BlockPoints() public {
176 Name = 'BlockPoints';
177 Symbol = 'BKP';
178 Decimals = 0;
179 TotalSupply = 1;
180 balances[msg.sender] = TotalSupply; 
181 }
182 
183 /*broadcast minting of tokens*/
184 event BrodMint(address indexed from, address indexed enduser, uint256 amount);
185 /*broadcast buring of tokens*/
186 event BrodBurn(address indexed from, address indexed enduser, uint256 amount);
187 
188 /*RECEIVE APPROVAL & WITHDRAW TOC TOKENS*/
189 function receiveApproval(address _from, uint256 _value, 
190 address _token, bytes _extraData) external returns(bool){ 
191 TOC
192 TOCCall = TOC(_token);
193 TOCCall.transferFrom(_from,this,_value);
194 return true;
195 }
196 
197 /*AUTHORISE ADMINS*/
198 function AuthAdmin (address _admin, bool _authority, uint256 _level) external 
199 returns(bool){
200 if((msg.sender != Mars) && (msg.sender != Mercury) && (msg.sender != Europa) &&
201 (msg.sender != Jupiter) && (msg.sender != Neptune)) revert();      
202 admin[_admin].Authorised = _authority;
203 admin[_admin].Level = _level;
204 return true;
205 }
206 
207 /*ADD ADDRESSES TO ADDRESS BOOK*/
208 function AuthAddr(address _tocaddr) external returns(bool){
209 if(admin[msg.sender].Authorised == false) revert();
210 if(admin[msg.sender].Level < 3 ) revert();
211 addressbook[ContractAddr].TOCAddr = _tocaddr;
212 return true;
213 }
214 
215 /*AUTHORISE DAPPS*/
216 function AuthDapps (address _dapp, bool _mint, bool _burn, bool _rate) external 
217 returns(bool){
218 if(admin[msg.sender].Authorised == false) revert();
219 if(admin[msg.sender].Level < 5) revert();
220 dapps[_dapp].AuthoriseMint = _mint;
221 dapps[_dapp].AuthoriseBurn = _burn;
222 dapps[_dapp].AuthoriseRate = _rate;
223 return true;
224 }
225 
226 /*SUSPEND CONVERSIONS*/
227 function AuthSuspend (bool _suspend) external returns(bool){
228 if(admin[msg.sender].Authorised == false) revert();
229 if(admin[msg.sender].Level < 3) revert();
230 global[ContractAddr].Suspend = _suspend;
231 return true;
232 }
233 
234 /*SET GLOBAL RATE*/
235 function SetRate (uint256 _globalrate) external returns(bool){
236 if(admin[msg.sender].Authorised == false) revert();
237 if(admin[msg.sender].Level < 5) revert();
238 global[ContractAddr].Rate = _globalrate;
239 return true;
240 }
241 
242 /*LET DAPPS ALLOCATE SPECIAL EXCHANGE RATES*/
243 function SpecialRate (address _user, address _dapp, uint256 _amount, uint256 _rate) 
244 external returns(bool){
245 /*conduct integrity check*/    
246 if(dapps[msg.sender].AuthoriseRate == false) revert(); 
247 if(dapps[_dapp].AuthoriseRate == false) revert(); 
248 coloured[_user][_dapp].Amount += _amount;
249 coloured[_user][_dapp].Rate = _rate;
250 return true;
251 }
252 
253 
254 /*BLOCK POINTS REWARD*/
255 function Reward(address r_to, uint256 r_amount) external returns (bool){
256 /*conduct integrity check*/    
257 if(dapps[msg.sender].AuthoriseMint == false) revert(); 
258 /*mint block point for beneficiary*/
259 balances[r_to] += r_amount;
260 /*increase total supply*/
261 TotalSupply += r_amount;
262 /*broadcast mint*/
263 emit BrodMint(msg.sender,r_to,r_amount);     
264 return true;
265 }
266 
267 /*GENERIC CONVERSION OF BLOCKPOINTS*/
268 function ConvertBkp(uint256 b_amount) external returns (bool){
269 /*conduct integrity check*/
270 require(global[ContractAddr].Suspend == false);
271 require(b_amount > 0);
272 require(global[ContractAddr].Rate > 0);
273 /*compute expected balance after conversion*/
274 pr.n1 = sub(balances[msg.sender],b_amount);
275 /*check whether the converting address has enough block points to convert*/
276 require(balances[msg.sender] >= b_amount); 
277 /*substract block points from converter and total supply*/
278 balances[msg.sender] -= b_amount;
279 TotalSupply -= b_amount;
280 /*determine toc liability*/
281 pr.n2 = mul(b_amount,global[ContractAddr].Rate);
282 /*connect to toc contract*/
283 TOC
284 TOCCall = TOC(addressbook[ContractAddr].TOCAddr);
285 /*check integrity of conversion operation*/
286 assert(pr.n1 == balances[msg.sender]);
287 /*send toc to message sender*/
288 TOCCall.transfer(msg.sender,pr.n2);
289 return true;
290 }
291 
292 /*CONVERSION OF COLOURED BLOCKPOINTS*/
293 function ConvertColouredBkp(address _dapp) external returns (bool){
294 /*conduct integrity check*/
295 require(global[ContractAddr].Suspend == false);
296 require(coloured[msg.sender][_dapp].Rate > 0);
297 /*determine conversion amount*/
298 uint256 b_amount = coloured[msg.sender][_dapp].Amount;
299 require(b_amount > 0);
300 /*check whether the converting address has enough block points to convert*/
301 require(balances[msg.sender] >= b_amount); 
302 /*compute expected balance after conversion*/
303 pr.n3 = sub(coloured[msg.sender][_dapp].Amount,b_amount);
304 pr.n4 = sub(balances[msg.sender],b_amount);
305 /*substract block points from converter balances and total supply*/
306 coloured[msg.sender][_dapp].Amount -= b_amount;
307 balances[msg.sender] -= b_amount;
308 TotalSupply -= b_amount;
309 /*determine toc liability*/
310 pr.n5 = mul(b_amount,coloured[msg.sender][_dapp].Rate);
311 /*connect to toc contract*/
312 TOC
313 TOCCall = TOC(addressbook[ContractAddr].TOCAddr);
314 /*check integrity of conversion operation*/
315 assert(pr.n3 == coloured[msg.sender][_dapp].Amount);
316 assert(pr.n4 == balances[msg.sender]);
317 /*send toc to message sender*/
318 TOCCall.transfer(msg.sender,pr.n5);
319 return true;
320 }
321 
322 /*BURN BLOCK POINTS*/
323 function Burn(address b_to, uint256 b_amount) external returns (bool){
324 /*check if dapp can burn blockpoints*/    
325 if(dapps[msg.sender].AuthoriseBurn == false) revert();    
326 /*check whether the burning address has enough block points to burn*/
327 require(balances[b_to] >= b_amount); 
328 /*substract blockpoints from burning address balance*/
329 balances[b_to] -= b_amount;
330 /*substract blockpoints from total supply*/
331 TotalSupply -= b_amount;
332 /*broadcast burning*/
333 emit BrodBurn(msg.sender, b_to,b_amount); 
334 return true;
335 }
336 
337 /*SAFE MATHS*/
338 function mul(uint256 a, uint256 b) public pure returns (uint256) {
339 uint256 c = a * b;
340 assert(a == 0 || c / a == b);
341 return c;
342   }
343 function sub(uint256 a, uint256 b) public pure returns (uint256) {
344     assert(b <= a);
345     return a - b;
346   }  
347   
348 }///////////////////////////////////end of blockpoints contract