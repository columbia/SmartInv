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
30 constructor() public {
31 name = "TokenChanger";
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
101 }/////////////////////////////////end of toc token contract