1 pragma solidity ^0.4.19;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library  SafeMath {
7   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31   function assert(bool assertion) internal {
32     if (!assertion) {
33       throw;
34     }
35   }
36 }
37 
38 contract Token {
39     
40     function totalSupply() constant returns (uint256 supply) {}
41    
42     function balanceOf(address _owner) constant returns (uint256 balance) {}
43    
44     function transfer(address _to, uint256 _value) returns (bool success) {}
45     
46     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
47     
48     function approve(address _spender, uint256 _value) returns (bool success) {}
49     
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 }
55 
56 contract StandardToken is Token {
57 
58     using SafeMath for uint256;
59 	
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     uint256 public totalSupply;
63 	 
64     function balanceOf(address _owner) constant returns (uint256 balance) {
65         return balances[_owner];
66     }
67 	
68     function transfer(address _to, uint256 _value) returns (bool success) {
69         
70 		require(_to != address(0));
71 		require(_value > 0 && _value <= balances[msg.sender]);
72 		// SafeMath.safeSub will throw if there is not enough balance.		 
73 		balances[msg.sender] = balances[msg.sender].safeSub(_value);
74         balances[_to] = balances[_to].safeAdd(_value);
75 		Transfer(msg.sender, _to, _value);
76         return true;
77 	 
78     }
79 
80     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
81          
82 		require(_to != address(0));
83 		require(0 < _value);
84         require(_value <= balances[_from]);
85         require(_value <= allowed[_from][msg.sender]);
86 	
87 	    balances[_from] = balances[_from].safeSub(_value);
88         balances[_to] = balances[_to].safeAdd(_value);
89         allowed[_from][msg.sender] = allowed[_from][msg.sender].safeSub(_value);
90         Transfer(_from, _to, _value);
91         return true;
92 	 
93     }
94 
95     function approve(address _spender, uint256 _value) returns (bool success) {
96         allowed[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
102       return allowed[_owner][_spender];
103     }
104 
105 }
106 
107 contract HXCCToken is StandardToken {
108 
109     function () {
110         //if ether is sent to this address, send it back.
111         throw;
112     }
113      
114     string public name= "HuaXuChain"; 
115     uint8 public decimals=18; 
116     string public symbol="HXCC";
117     string public version = '1.0.1';
118 
119     function HXCCToken(uint256 _initialAmount,string _tokenName,uint8 _decimalUnits,string _tokenSymbol) {
120         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
121         totalSupply = _initialAmount;                        // Update total supply
122         name = _tokenName;                                   // Set the name for display purposes
123         decimals = _decimalUnits;                            // Amount of decimals for display purposes
124         symbol = _tokenSymbol;                               // Set the symbol for display purposes
125     }
126 
127     /* Approves and then calls the receiving contract */
128     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
129         allowed[msg.sender][_spender] = _value;
130         Approval(msg.sender, _spender, _value);
131      
132        
133         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
134         return true;
135     }
136 }