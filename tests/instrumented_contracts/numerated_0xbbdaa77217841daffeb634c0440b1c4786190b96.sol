1 pragma solidity ^0.4.9;
2 
3  /*
4  * Contract that is working with ERC223 tokens
5  */
6  
7  contract ContractReceiver {
8      
9     struct TKN {
10         address sender;
11         uint value;
12         bytes data;
13         bytes4 sig;
14     }
15     
16     
17     function tokenFallback(address _from, uint _value, bytes _data) public pure {
18       TKN memory tkn;
19       tkn.sender = _from;
20       tkn.value = _value;
21       tkn.data = _data;
22       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
23       tkn.sig = bytes4(u);
24       
25       /* tkn variable is analogue of msg variable of Ether transaction
26       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
27       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
28       *  tkn.data is data of token transaction   (analogue of msg.data)
29       *  tkn.sig is 4 bytes signature of function
30       *  if data of token transaction is a function execution
31       */
32     }
33 }
34 
35  /* New ERC23 contract interface */
36  
37 contract ERC223 {
38   uint public totalSupply;
39   function balanceOf(address who) public view returns (uint);
40   
41   function name() public view returns (string _name);
42   function symbol() public view returns (string _symbol);
43   function decimals() public view returns (uint8 _decimals);
44   function totalSupply() public view returns (uint256 _supply);
45 
46   function transfer(address to, uint value) public returns (bool ok);
47   function transfer(address to, uint value, bytes data) public returns (bool ok);
48   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
49   
50   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
51 }
52 
53  /**
54  * ERC223 token by Dexaran
55  *
56  * https://github.com/Dexaran/ERC223-token-standard
57  */
58  
59  
60  /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
61 contract SafeMath {
62     uint256 constant public MAX_UINT256 =
63     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
64 
65     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
66         if (x > MAX_UINT256 - y) revert();
67         return x + y;
68     }
69 
70     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
71         if (x < y) revert();
72         return x - y;
73     }
74 
75     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
76         if (y == 0) return 0;
77         if (x > MAX_UINT256 / y) revert();
78         return x * y;
79     }
80 }
81  
82 contract Axo is ERC223, SafeMath {
83 
84   mapping(address => uint) balances;
85   
86   string public name;
87   string public symbol;
88   uint8 public decimals;
89   uint256 public totalSupply;
90   
91   // Function to access name of token .
92   function name() public view returns (string _name) {
93       return name;
94   }
95   // Function to access symbol of token .
96   function symbol() public view returns (string _symbol) {
97       return symbol;
98   }
99   // Function to access decimals of token .
100   function decimals() public view returns (uint8 _decimals) {
101       return decimals;
102   }
103   // Function to access total supply of tokens .
104   function totalSupply() public view returns (uint256 _totalSupply) {
105       return totalSupply;
106   }
107   
108   function Axo() public {
109 	  name = "axor";
110 	  symbol = "axo";
111 	  decimals = 18;
112 	  // 1 billion
113 	  uint256 totalUnits = 1000000000;
114 	  totalSupply = totalUnits * (10 ** uint256(decimals));
115 	  address genesis = 0xb2B34Ba2fddaC30B747cf45C2457a37c126288E4;
116 	  balances[genesis] = totalSupply;
117   }
118   
119   // Function that is called when a user or another contract wants to transfer funds .
120   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
121       
122     if(isContract(_to)) {
123         if (balanceOf(msg.sender) < _value) revert();
124         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
125         balances[_to] = safeAdd(balanceOf(_to), _value);
126         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
127         Transfer(msg.sender, _to, _value, _data);
128         return true;
129     }
130     else {
131         return transferToAddress(_to, _value, _data);
132     }
133 }
134   
135 
136   // Function that is called when a user or another contract wants to transfer funds .
137   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
138       
139     if(isContract(_to)) {
140         return transferToContract(_to, _value, _data);
141     }
142     else {
143         return transferToAddress(_to, _value, _data);
144     }
145 }
146   
147   // Standard function transfer similar to ERC20 transfer with no _data .
148   // Added due to backwards compatibility reasons .
149   function transfer(address _to, uint _value) public returns (bool success) {
150       
151     //standard function transfer similar to ERC20 transfer with no _data
152     //added due to backwards compatibility reasons
153     bytes memory empty;
154     if(isContract(_to)) {
155         return transferToContract(_to, _value, empty);
156     }
157     else {
158         return transferToAddress(_to, _value, empty);
159     }
160 }
161 
162   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
163   function isContract(address _addr) private view returns (bool is_contract) {
164       uint length;
165       assembly {
166             //retrieve the size of the code on target address, this needs assembly
167             length := extcodesize(_addr)
168       }
169       return (length>0);
170     }
171 
172   //function that is called when transaction target is an address
173   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
174     if (balanceOf(msg.sender) < _value) revert();
175     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
176     balances[_to] = safeAdd(balanceOf(_to), _value);
177     Transfer(msg.sender, _to, _value, _data);
178     return true;
179   }
180   
181   //function that is called when transaction target is a contract
182   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
183     if (balanceOf(msg.sender) < _value) revert();
184     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
185     balances[_to] = safeAdd(balanceOf(_to), _value);
186     ContractReceiver receiver = ContractReceiver(_to);
187     receiver.tokenFallback(msg.sender, _value, _data);
188     Transfer(msg.sender, _to, _value, _data);
189     return true;
190   }
191 
192 
193   function balanceOf(address _owner) public view returns (uint balance) {
194     return balances[_owner];
195   }
196 }