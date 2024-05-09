1 pragma solidity ^0.4.24;
2 //ERC223
3 contract ERC223Ownable {
4     address public owner;
5 
6     function ERC223Ownable() public{
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14     function transferOwnership(address newOwner) onlyOwner public{
15         if (newOwner != address(0)) {
16             owner = newOwner;
17         }
18     }
19 }
20 
21 contract ContractReceiver {
22      
23     struct TKN {
24         address sender;
25         uint value;
26         bytes data;
27         bytes4 sig;
28     }
29     
30     function tokenFallback(address _from, uint _value, bytes _data) public pure {
31       TKN memory tkn;
32       tkn.sender = _from;
33       tkn.value = _value;
34       tkn.data = _data;
35       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
36       tkn.sig = bytes4(u);
37       
38       /* tkn variable is analogue of msg variable of Ether transaction
39       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
40       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
41       *  tkn.data is data of token transaction   (analogue of msg.data)
42       *  tkn.sig is 4 bytes signature of function
43       *  if data of token transaction is a function execution
44       */
45     }
46 }
47 
48 contract ERC223 {
49   uint public totalSupply;
50   function balanceOf(address who) public view returns (uint);
51 
52   function transfer(address to, uint value) public returns (bool ok);
53   function transfer(address to, uint value, bytes data) public returns (bool ok);
54   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
55 
56   event Transfer(address indexed from, address indexed to, uint value);
57   event Transfer(address indexed from, address indexed to, uint value, bytes data);
58 }
59 
60 contract SafeMath {
61     uint256 constant public MAX_UINT256 =
62     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
63 
64     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
65         if (x > MAX_UINT256 - y) revert();
66         return x + y;
67     }
68 
69     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
70         if (x < y) revert();
71         return x - y;
72     }
73 
74     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
75         if (y == 0) return 0;
76         if (x > MAX_UINT256 / y) revert();
77         return x * y;
78     }
79 }
80 
81 contract ERC223Token is ERC223, SafeMath {
82 
83   mapping(address => uint) balances;
84 
85   string public name;
86   string public symbol;
87   uint256 public decimals;
88   uint256 public totalSupply;
89   bool public mintable;
90 
91 
92 
93   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
94 
95     if(isContract(_to)) {
96         if (balanceOf(msg.sender) < _value) revert();
97         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
98         balances[_to] = safeAdd(balanceOf(_to), _value);
99         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
100         emit Transfer(msg.sender, _to, _value);
101         emit Transfer(msg.sender, _to, _value, _data);
102         return true;
103     }
104     else {
105         return transferToAddress(_to, _value, _data);
106     }
107 }
108 
109 
110 function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
111 
112     if(isContract(_to)) {
113         return transferToContract(_to, _value, _data);
114     }
115     else {
116         return transferToAddress(_to, _value, _data);
117     }
118 }
119 
120   function transfer(address _to, uint _value) public returns (bool success) {
121 
122     //standard function transfer similar to ERC20 transfer with no _data
123     //added due to backwards compatibility reasons
124     bytes memory empty;
125     if(isContract(_to)) {
126         return transferToContract(_to, _value, empty);
127     }
128     else {
129         return transferToAddress(_to, _value, empty);
130     }
131 }
132 
133   function isContract(address _addr) private view returns (bool is_contract) {
134       uint length;
135       assembly {
136             //retrieve the size of the code on target address, this needs assembly
137             length := extcodesize(_addr)
138       }
139       return (length>0);
140     }
141 
142   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
143     if (balanceOf(msg.sender) < _value) revert();
144     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
145     balances[_to] = safeAdd(balanceOf(_to), _value);
146     emit Transfer(msg.sender, _to, _value);
147     emit Transfer(msg.sender, _to, _value, _data);
148     return true;
149   }
150 
151   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
152     if (balanceOf(msg.sender) < _value) revert();
153     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
154     balances[_to] = safeAdd(balanceOf(_to), _value);
155     ContractReceiver receiver = ContractReceiver(_to);
156     receiver.tokenFallback(msg.sender, _value, _data);
157     emit Transfer(msg.sender, _to, _value);
158     emit Transfer(msg.sender, _to, _value, _data);
159     return true;
160 }
161 
162 
163   function balanceOf(address _owner) public view returns (uint balance) {
164     return balances[_owner];
165   }
166 }
167 
168 contract ERC223StandardToken is ERC223Token,ERC223Ownable {
169     
170     function ERC223StandardToken(address _owner, string _name, string _symbol, uint256 _decimals, uint256 _totalSupply, bool _mintable) public {
171         
172         require(_owner != address(0));
173         owner = _owner;
174 		decimals = _decimals;
175 		symbol = _symbol;
176 		name = _name;
177 		mintable = _mintable;
178         totalSupply = _totalSupply;
179         balances[_owner] = totalSupply;
180         emit Transfer(address(0), _owner, totalSupply);
181         emit Transfer(address(0), _owner, totalSupply, "");
182     }
183   
184     function mint(uint256 amount) onlyOwner public {
185 		require(mintable);
186 		require(amount >= 0);
187 		balances[msg.sender] += amount;
188 		totalSupply += amount;
189 	}
190 
191     function burn(uint256 _value) onlyOwner public returns (bool) {
192         require(balances[msg.sender] >= _value  && totalSupply >=_value && _value > 0);
193         balances[msg.sender] -= _value;
194         totalSupply -= _value;
195         emit Transfer(msg.sender, 0x0, _value);
196         return true;
197     }
198 }