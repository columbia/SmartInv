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
25 event Transfer(address indexed from, address indexed to, uint256 value);
26 /*broadcast token spend approvals on the blockchain*/
27 event Approval(address indexed _owner, address indexed _spender, uint _value);
28 
29 /*MINT TOKEN*/
30 function TOC() public {
31 name = "Token Changer";
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
56 emit Transfer(_from, _to, _value); 
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
70 emit Approval(msg.sender, _spender, _value); 
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
97 /*INVALID TRANSACTIONS*/
98 function () payable external{
99 revert();  
100 }
101 
102 }/////////////////////////////////end of toc token contract
103 
104 pragma solidity ^0.4.22;
105 
106 contract AirdropDIST {
107 /*(c)2018 tokenchanger.io -all rights reserved*/
108 
109 /*SUPER ADMINS*/
110 address Mars = 0x1947f347B6ECf1C3D7e1A58E3CDB2A15639D48Be;
111 address Mercury = 0x00795263bdca13104309Db70c11E8404f81576BE;
112 address Europa = 0x00e4E3eac5b520BCa1030709a5f6f3dC8B9e1C37;
113 address Jupiter = 0x2C76F260707672e240DC639e5C9C62efAfB59867;
114 address Neptune = 0xEB04E1545a488A5018d2b5844F564135211d3696;
115 
116 /*CONTRACT ADDRESS*/
117 function GetContractAddr() public constant returns (address){
118 return this;
119 }	
120 address ContractAddr = GetContractAddr();
121 
122 
123 /*AIRDROP RECEPIENTS*/
124 struct Accounting{
125 bool Received;    
126 }
127 
128 struct Admin{
129 bool Authorised; 
130 uint256 Level;
131 }
132 
133 struct Config{
134 uint256 TocAmount;	
135 address TocAddr;
136 }
137 
138 /*DATA STORAGE*/
139 mapping (address => Accounting) public account;
140 mapping (address => Config) public config;
141 mapping (address => Admin) public admin;
142 
143 /*AUTHORISE ADMIN*/
144 function AuthAdmin(address _admin, bool _authority, uint256 _level) external 
145 returns(bool) {
146 if((msg.sender != Mars) && (msg.sender != Mercury) && (msg.sender != Europa)
147 && (msg.sender != Jupiter) && (msg.sender != Neptune)) revert();  
148 admin[_admin].Authorised = _authority; 
149 admin[_admin].Level = _level;
150 return true;
151 } 
152 
153 /*CONFIGURATION*/
154 function SetUp(uint256 _amount, address _tocaddr) external returns(bool){
155 /*integrity checks*/      
156 if(admin[msg.sender].Authorised == false) revert();
157 if(admin[msg.sender].Level < 5 ) revert();
158 /*update configuration records*/
159 config[ContractAddr].TocAmount = _amount;
160 config[ContractAddr].TocAddr = _tocaddr;
161 return true;
162 }
163 
164 /*DEPOSIT TOC*/
165 function receiveApproval(address _from, uint256 _value, 
166 address _token, bytes _extraData) external returns(bool){ 
167 TOC
168 TOCCall = TOC(_token);
169 TOCCall.transferFrom(_from,this,_value);
170 return true;
171 }
172 
173 /*WITHDRAW TOC*/
174 function Withdraw(uint256 _amount) external returns(bool){
175 /*integrity checks*/      
176 if(admin[msg.sender].Authorised == false) revert();
177 if(admin[msg.sender].Level < 5 ) revert();
178 /*withdraw TOC from this contract*/
179 TOC
180 TOCCall = TOC(config[ContractAddr].TocAddr);
181 TOCCall.transfer(msg.sender, _amount);
182 return true;
183 }
184 
185 /*GET TOC*/
186 function Get() external returns(bool){
187 /*integrity check-1*/      
188 if(account[msg.sender].Received == true) revert();
189 /*change message sender received status*/
190 account[msg.sender].Received = true;
191 /*send TOC to message sender*/
192 TOC
193 TOCCall = TOC(config[ContractAddr].TocAddr);
194 TOCCall.transfer(msg.sender, config[ContractAddr].TocAmount);
195 /*integrity check-2*/      
196 assert(account[msg.sender].Received == true);
197 return true;
198 }
199 
200 /*INVALID TRANSACTIONS*/
201 function () payable external{
202 revert();  
203 }
204 
205 }////////////////////////////////end of AirdropDIST contract