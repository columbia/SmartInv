1 pragma solidity ^0.4.17;
2  /*
3  * Contract that is working with ERC223 tokens
4  */
5   /* New ERC23 contract interface */
6  
7 contract ERC223 {
8   uint public totalSupply;
9   function balanceOf(address who) constant returns (uint);
10   
11   function name() constant returns (string _name);
12   function symbol() constant returns (string _symbol);
13   function decimals() constant returns (uint8 _decimals);
14   function totalSupply() constant returns (uint256 _supply);
15 
16   function transfer(address to, uint value) returns (bool ok);
17   function transfer(address to, uint value, bytes data) returns (bool ok);
18   function transfer(address to, uint value, bytes data, string custom_fallback) returns (bool ok);
19   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
20 }
21 
22  contract ContractReceiver {
23      
24     struct TKN {
25         address sender;
26         uint value;
27         bytes data;
28         bytes4 sig;
29     }
30     
31     
32     function tokenFallback(address _from, uint _value, bytes _data){
33       TKN memory tkn;
34       tkn.sender = _from;
35       tkn.value = _value;
36       tkn.data = _data;
37       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
38       tkn.sig = bytes4(u);
39       
40       /* tkn variable is analogue of msg variable of Ether transaction
41       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
42       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
43       *  tkn.data is data of token transaction   (analogue of msg.data)
44       *  tkn.sig is 4 bytes signature of function
45       *  if data of token transaction is a function execution
46       */
47     }
48 }
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
71 
72 contract TokenStorage{
73     
74   function name() constant returns (string _name) {}
75   
76   function symbol() constant returns (string _symbol) {}
77   
78   function decimals() constant returns (uint8 _decimals) {}
79   
80   function totalSupply() constant returns (uint48 _totalSupply)  {}
81   
82   
83   
84   function transfer(address _to, uint48 _value, bytes _data, string _custom_fallback) returns (bool success) {}
85 
86 
87   function transfer(address _to, uint48 _value, bytes _data) returns (bool success) {}
88   function transfer(address _to, uint48 _value) returns (bool success) {}
89 
90   function isContract(address _addr) private returns (bool is_contract) {}
91 
92   
93   function transferToAddress(address _to, uint48 _value, bytes _data) private returns (bool success)  {}
94   
95   
96   function transferToContract(address _to, uint48 _value, bytes _data) private returns (bool success)  {}
97 
98 
99   function balanceOf(address _owner) constant returns (uint48 balance) {}
100 }
101 
102 contract GameCoin is ERC223, SafeMath {
103   TokenStorage _s;
104   mapping(address => uint) balances;
105   
106   string public name;
107   string public symbol;
108   uint8 public decimals;
109   uint256 public totalSupply;
110   
111     
112   // Function to access name of token .
113   function name() constant returns (string _name) {
114       return name;
115   }
116   // Function to access symbol of token .
117   function symbol() constant returns (string _symbol) {
118       return symbol;
119   }
120   // Function to access decimals of token .
121   function decimals() constant returns (uint8 _decimals) {
122       return decimals;
123   }
124   // Function to access total supply of tokens .
125   function totalSupply() constant returns (uint256 _totalSupply) {
126       return totalSupply;
127   }
128   
129   
130   function GameCoin() {
131         _s = TokenStorage(0x9ff62629aec4436d03a84665acfb2a3195ca784b);
132         name = "GameCoin";
133         symbol = "GMC";
134         decimals = 2;
135         totalSupply = 25907002099;
136         
137   }
138   
139   
140 
141   // Function that is called when a user or another contract wants to transfer funds .
142   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) returns (bool success) {
143       
144     if(isContract(_to)) {
145         if (balanceOf(msg.sender) < _value) throw;
146         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
147         balances[_to] = safeAdd(balanceOf(_to), _value);
148         ContractReceiver receiver = ContractReceiver(_to);
149         receiver.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data);
150         Transfer(msg.sender, _to, _value, _data);
151         return true;
152     }
153     else {
154         return transferToAddress(_to, _value, _data);
155     }
156 }
157   
158 
159   // Function that is called when a user or another contract wants to transfer funds .
160   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
161       
162     if(isContract(_to)) {
163         return transferToContract(_to, _value, _data);
164     }
165     else {
166         return transferToAddress(_to, _value, _data);
167     }
168 }
169   
170   // Standard function transfer similar to ERC20 transfer with no _data .
171   // Added due to backwards compatibility reasons .
172   function transfer(address _to, uint _value) returns (bool success) {
173       
174     //standard function transfer similar to ERC20 transfer with no _data
175     //added due to backwards compatibility reasons
176     bytes memory empty;
177     if(isContract(_to)) {
178         return transferToContract(_to, _value, empty);
179     }
180     else {
181         return transferToAddress(_to, _value, empty);
182     }
183 }
184 
185 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
186   function isContract(address _addr) private returns (bool is_contract) {
187       uint length;
188       assembly {
189             //retrieve the size of the code on target address, this needs assembly
190             length := extcodesize(_addr)
191       }
192       return (length>0);
193     }
194 
195   //function that is called when transaction target is an address
196   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
197     if (balanceOf(msg.sender) < _value) throw;
198     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
199     balances[_to] = safeAdd(balanceOf(_to), _value);
200     Transfer(msg.sender, _to, _value, _data);
201     return true;
202   }
203   
204   //function that is called when transaction target is a contract
205   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
206     if (balanceOf(msg.sender) < _value) throw;
207     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
208     balances[_to] = safeAdd(balanceOf(_to), _value);
209     ContractReceiver receiver = ContractReceiver(_to);
210     receiver.tokenFallback(msg.sender, _value, _data);
211     Transfer(msg.sender, _to, _value, _data);
212     return true;
213 }
214 
215 
216   function balanceOf(address _owner) constant returns (uint balance) {
217     if(balances[_owner] == 0){
218       return uint(_s.balanceOf(_owner));
219     }
220     else
221     {
222     return uint(balances[_owner]);
223     }
224   }
225   
226 }