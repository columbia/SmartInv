1 pragma solidity ^0.4.9;
2 
3 // import "./receiver_interface.sol";
4 // import "./erc223_interface.sol";
5 
6  contract ContractReceiver {
7      
8     struct TKN {
9         address sender;
10         uint value;
11         bytes data;
12         bytes4 sig;
13     }
14     
15     
16     function tokenFallback(address _from, uint _value, bytes _data){
17       TKN memory tkn;
18       tkn.sender = _from;
19       tkn.value = _value;
20       tkn.data = _data;
21       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
22       tkn.sig = bytes4(u);
23       
24       /* tkn variable is analogue of msg variable of Ether transaction
25       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
26       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
27       *  tkn.data is data of token transaction   (analogue of msg.data)
28       *  tkn.sig is 4 bytes signature of function
29       *  if data of token transaction is a function execution
30       */
31     }
32 }
33 
34 
35 contract ERC223 {
36   uint public totalSupply;
37   function balanceOf(address who) constant returns (uint);
38   
39   function name() constant returns (string _name);
40   function symbol() constant returns (string _symbol);
41   function decimals() constant returns (uint8 _decimals);
42   function totalSupply() constant returns (uint256 _supply);
43 
44   function transfer(address to, uint value) returns (bool ok);
45   function transfer(address to, uint value, bytes data) returns (bool ok);
46   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
47 }
48 
49 
50 contract SafeMath {
51     uint256 constant public MAX_UINT256 =
52     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
53 
54     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
55         if (x > MAX_UINT256 - y) throw;
56         return x + y;
57     }
58 
59     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
60         if (x < y) throw;
61         return x - y;
62     }
63 
64     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
65         if (y == 0) return 0;
66         if (x > MAX_UINT256 / y) throw;
67         return x * y;
68     }
69 }
70  
71 contract StellarToken is ERC223, SafeMath {
72 
73   mapping(address => uint) balances;
74   
75   string public name;
76   string public symbol;
77   uint8 public decimals;
78   uint256 public totalSupply;
79 
80 
81   // Constructor
82   function StellarToken(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) {
83     balances[msg.sender] = initialSupply;
84     name = tokenName;                                   // Set the name for display purposes
85     symbol = tokenSymbol;                               // Set the symbol for display purposes
86     decimals = decimalUnits;                            // Amount of decimals for display purposes
87     totalSupply = initialSupply;
88   }
89 
90 
91   // Function to access name of token .
92   function name() constant returns (string _name) {
93       return name;
94   }
95   // Function to access symbol of token .
96   function symbol() constant returns (string _symbol) {
97       return symbol;
98   }
99   // Function to access decimals of token .
100   function decimals() constant returns (uint8 _decimals) {
101       return decimals;
102   }
103   // Function to access total supply of tokens .
104   function totalSupply() constant returns (uint256 _totalSupply) {
105       return totalSupply;
106   }
107   
108   
109 
110   // Function that is called when a user or another contract wants to transfer funds .
111   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
112       
113     if(isContract(_to)) {
114         return transferToContract(_to, _value, _data);
115     }
116     else {
117         return transferToAddress(_to, _value, _data);
118     }
119 }
120   
121   // Standard function transfer similar to ERC20 transfer with no _data .
122   // Added due to backwards compatibility reasons .
123   function transfer(address _to, uint _value) returns (bool success) {
124       
125     //standard function transfer similar to ERC20 transfer with no _data
126     //added due to backwards compatibility reasons
127     bytes memory empty;
128     if(isContract(_to)) {
129         return transferToContract(_to, _value, empty);
130     }
131     else {
132         return transferToAddress(_to, _value, empty);
133     }
134 }
135 
136 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
137   function isContract(address _addr) private returns (bool is_contract) {
138       uint length; 
139       assembly {
140             //retrieve the size of the code on target address, this needs assembly
141             length := extcodesize(_addr)
142         }
143         if(length>0) {
144             return true;
145         }
146         else {
147             return false;
148         }
149     }
150 
151   //function that is called when transaction target is an address
152   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
153     if (balanceOf(msg.sender) < _value) throw;
154     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
155     balances[_to] = safeAdd(balanceOf(_to), _value);
156     Transfer(msg.sender, _to, _value, _data);
157     return true;
158   }
159   
160   //function that is called when transaction target is a contract
161   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
162     if (balanceOf(msg.sender) < _value) throw;
163     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
164     balances[_to] = safeAdd(balanceOf(_to), _value);
165     ContractReceiver reciever = ContractReceiver(_to);
166     reciever.tokenFallback(msg.sender, _value, _data);
167     Transfer(msg.sender, _to, _value, _data);
168     return true;
169 }
170 
171 
172   function balanceOf(address _owner) constant returns (uint balance) {
173     return balances[_owner];
174   }
175 }