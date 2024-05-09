1 pragma solidity ^0.4.11;
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
12     
13     function tokenFallback(address _from, uint _value, bytes _data){
14       TKN memory tkn;
15       tkn.sender = _from;
16       tkn.value = _value;
17       tkn.data = _data;
18       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
19       tkn.sig = bytes4(u);
20  
21     }
22 }
23 
24 contract SafeMath {
25     uint256 constant public MAX_UINT256 =
26     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
27 
28     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
29         if (x > MAX_UINT256 - y) throw;
30         return x + y;
31     }
32 
33     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
34         if (x < y) throw;
35         return x - y;
36     }
37 
38     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
39         if (y == 0) return 0;
40         if (x > MAX_UINT256 / y) throw;
41         return x * y;
42     }
43 }
44 
45 contract Token is SafeMath{
46 
47   mapping(address => uint) balances;
48   
49   string public symbol = "";
50   string public name = "";
51   uint8 public decimals = 18;
52   uint256 public totalSupply = 0;
53   address owner = 0;
54   bool setupDone = false;
55   
56   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
57   
58   function Token(address adr) {
59 		owner = adr;        
60     }
61 	
62 	function SetupToken(string _tokenName, string _tokenSymbol, uint256 _tokenSupply)
63 	{
64 		if (msg.sender == owner && setupDone == false)
65 		{
66 			symbol = _tokenSymbol;
67 			name = _tokenName;
68 			totalSupply = _tokenSupply * 1000000000000000000;
69 			balances[owner] = totalSupply;
70 			setupDone = true;
71 		}
72 	}
73   
74   function name() constant returns (string _name) {
75       return name;
76   }
77 
78   function symbol() constant returns (string _symbol) {
79       return symbol;
80   }
81 
82   function decimals() constant returns (uint8 _decimals) {
83       return decimals;
84   }
85 
86   function totalSupply() constant returns (uint256 _totalSupply) {
87       return totalSupply;
88   }
89   
90   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
91       
92     if(isContract(_to)) {
93         return transferToContract(_to, _value, _data);
94     }
95     else {
96         return transferToAddress(_to, _value, _data);
97     }
98 }
99   
100   function transfer(address _to, uint _value) returns (bool success) {
101       
102     bytes memory empty;
103     if(isContract(_to)) {
104         return transferToContract(_to, _value, empty);
105     }
106     else {
107         return transferToAddress(_to, _value, empty);
108     }
109 }
110 
111   function isContract(address _addr) private returns (bool is_contract) {
112       uint length;
113 	  
114 	  if (balanceOf(_addr) >=0 )
115 	  
116       assembly {
117             length := extcodesize(_addr)
118         }
119         if(length>0) {
120             return true;
121         }
122         else {
123             return false;
124         }
125     }
126 
127   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
128     if (balanceOf(msg.sender) < _value) throw;
129     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
130     balances[_to] = safeAdd(balanceOf(_to), _value);
131     Transfer(msg.sender, _to, _value, _data);
132     return true;
133   }
134   
135   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
136     if (balanceOf(msg.sender) < _value) throw;
137     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
138     balances[_to] = safeAdd(balanceOf(_to), _value);
139     ContractReceiver reciever = ContractReceiver(_to);
140     reciever.tokenFallback(msg.sender, _value, _data);
141     Transfer(msg.sender, _to, _value, _data);
142     return true;
143 }
144 
145   function balanceOf(address _owner) constant returns (uint balance) {
146     return balances[_owner];
147   }
148 }