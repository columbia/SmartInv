1 pragma solidity ^0.4.4;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint a, uint b) internal returns (uint) {
11     assert(b > 0);
12     uint c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       throw;
47     }
48   }
49 }
50 
51 
52 
53 contract Token is SafeMath {
54 
55     function totalSupply() constant returns (uint256 supply) {}
56 
57     function balanceOf(address _owner) constant returns (uint256 balance) {}
58 
59     function transfer(address _to, uint256 _value) returns (bool success) {}
60 
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
62 
63     function approve(address _spender, uint256 _value) returns (bool success) {}
64 
65     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
66 
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69     
70 }
71 
72 
73 //ERC20 Complient
74 contract StandardToken is Token {
75 
76     function transfer(address _to, uint256 _value) returns (bool success) {
77         if (balances[msg.sender] >= _value && _value > 0) {
78             balances[msg.sender] = safeSub(balances[msg.sender],_value);
79             balances[_to] = safeAdd(balances[_to],_value);
80             Transfer(msg.sender, _to, _value);
81             return true;
82         } else { return false; }
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
86         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
87             balances[_to] =safeAdd(balances[_to],_value);
88             balances[_from] =safeSub(balances[_from],_value);
89             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value); 
90             Transfer(_from, _to, _value);
91             return true;
92         } else { return false; }
93     }
94 
95     function balanceOf(address _owner) constant returns (uint256 balance) {
96         return balances[_owner];
97     }
98 
99     function approve(address _spender, uint256 _value) returns (bool success) {
100         allowed[msg.sender][_spender] = _value;
101         Approval(msg.sender, _spender, _value);
102         return true;
103     }
104 
105     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
106       return allowed[_owner][_spender];
107     }
108 
109 
110    mapping (address => uint256) balances;
111     mapping (address => mapping (address => uint256)) allowed;
112     uint256 public totalSupply;
113 
114 }
115 
116 contract CryptoDegree is StandardToken {
117 
118     function () {
119         //if ether is sent to this address, send it back.
120         throw;
121     }
122 
123     string public name;                  
124     uint8 public decimals;               
125     string public symbol;
126     string public version = 'H1.0';       
127 
128 
129         function CryptoDegree(
130         ) {
131         balances[msg.sender] = 50000000000000;               
132         totalSupply = 50000000000000;                        
133         name = "CryptoDegree";                                   
134         decimals = 6;                            
135         symbol = "CRDG";                               
136                             
137     }
138 
139    
140     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
141         allowed[msg.sender][_spender] = _value;
142         Approval(msg.sender, _spender, _value);
143 
144         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
145         return true;
146     }
147 }