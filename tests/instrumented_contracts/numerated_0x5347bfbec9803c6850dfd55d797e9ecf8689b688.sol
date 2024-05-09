1 pragma solidity ^0.4.24;
2 
3 contract ContractReceiver {
4      
5     struct TKN {
6         address sender;
7         uint value;
8         bytes data;
9         bytes4 sig;
10     }
11     
12     function tokenFallback(address _from, uint _value, bytes _data){
13       TKN memory tkn;
14       tkn.sender = _from;
15       tkn.value = _value;
16       tkn.data = _data;
17       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
18       tkn.sig = bytes4(u); 
19  
20     }
21 }
22 
23 contract SafeMath {
24     uint256 constant public MAX_UINT256 =
25     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
26 
27     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
28         if (x > MAX_UINT256 - y) throw;
29         return x + y;
30     }
31 
32     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
33         if (x < y) throw;
34         return x - y;
35     }
36 
37     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
38         if (y == 0) return 0;
39         if (x > MAX_UINT256 / y) throw;
40         return x * y;
41     }
42 }
43 
44 contract Token is SafeMath{
45 
46   mapping(address => uint) balances;
47   
48   string public symbol = "";
49   string public name = "";
50   uint8 public decimals = 18;
51   uint256 public totalSupply = 0;
52   address owner = 0;
53   
54   event Transfer(address indexed from, address indexed to, uint value);
55   event TransferToCon(address indexed from, address indexed to, uint value, bytes indexed data);
56   
57   function Token(string _tokenName, string _tokenSymbol, uint256 _tokenSupply) {
58 		owner = msg.sender;   
59 		symbol = _tokenSymbol;
60 		name = _tokenName;
61 		totalSupply = _tokenSupply * 1000000000000000000;
62 		balances[owner] = totalSupply;
63     }
64 
65   
66   function name() constant returns (string _name) {
67       return name;
68   }
69 
70   function symbol() constant returns (string _symbol) {
71       return symbol;
72   }
73 
74   function decimals() constant returns (uint8 _decimals) {
75       return decimals;
76   }
77 
78   function totalSupply() constant returns (uint256 _totalSupply) {
79       return totalSupply;
80   }
81   
82   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
83       
84     if(isContract(_to)) {
85         return transferToContract(_to, _value, _data);
86     }
87     else {
88         return transferToAddress(_to, _value);
89     }
90 }
91   
92   function transfer(address _to, uint _value) returns (bool success) {
93       
94     bytes memory empty;
95     if(isContract(_to)) {
96         return transferToContract(_to, _value, empty);
97     }
98     else {
99         return transferToAddress(_to, _value);
100     }
101 }
102 
103   function isContract(address _addr) private returns (bool is_contract) {
104       uint length;
105 	  
106 	  if (balanceOf(_addr) >=0 )
107 	  
108       assembly {
109             length := extcodesize(_addr)
110         }
111         if(length>0) {
112             return true;
113         }
114         else {
115             return false;
116         }
117     }
118 
119   function transferToAddress(address _to, uint _value) private returns (bool success) {
120     if (balanceOf(msg.sender) < _value) throw;
121     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
122     balances[_to] = safeAdd(balanceOf(_to), _value);
123     Transfer(msg.sender, _to, _value);
124     return true;
125   }
126   
127   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
128     if (balanceOf(msg.sender) < _value) throw;
129     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
130     balances[_to] = safeAdd(balanceOf(_to), _value);
131     ContractReceiver reciever = ContractReceiver(_to);
132     reciever.tokenFallback(msg.sender, _value, _data);
133     TransferToCon(msg.sender, _to, _value, _data);
134     return true;
135 }
136 
137   function balanceOf(address _owner) constant returns (uint balance) {
138     return balances[_owner];
139   }
140   
141 }