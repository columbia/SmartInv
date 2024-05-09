1 pragma solidity ^0.4.24;
2 contract ERC223 {
3   uint public totalSupply;
4   function balanceOf(address who) constant returns (uint);
5 
6   function name() constant returns (string _name);
7   function symbol() constant returns (string _symbol);
8   function decimals() constant returns (uint8 _decimals);
9   function totalSupply() constant returns (uint256 _supply);
10 
11   function transfer(address to, uint value) returns (bool ok);
12   function transfer(address to, uint value, bytes data) returns (bool ok);
13   event Transfer(address indexed _from, address indexed _to, uint256 _value);
14   event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
15 }
16 
17 contract ContractReceiver {
18   function tokenFallback(address _from, uint _value, bytes _data);
19 }
20 
21 contract ERC223Token is ERC223 {
22   using SafeMath for uint;
23 
24   mapping(address => uint) balances;
25 
26   string public name;
27   string public symbol;
28   uint8 public decimals;
29   uint256 public totalSupply;
30 
31 
32   // Function to access name of token .
33   function name() constant returns (string _name) {
34       return name;
35   }
36   // Function to access symbol of token .
37   function symbol() constant returns (string _symbol) {
38       return symbol;
39   }
40   // Function to access decimals of token .
41   function decimals() constant returns (uint8 _decimals) {
42       return decimals;
43   }
44   // Function to access total supply of tokens .
45   function totalSupply() constant returns (uint256 _totalSupply) {
46       return totalSupply;
47   }
48 
49   // Function that is called when a user or another contract wants to transfer funds .
50   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
51     if(isContract(_to)) {
52         return transferToContract(_to, _value, _data);
53     }
54     else {
55         return transferToAddress(_to, _value, _data);
56     }
57 }
58 
59   // Standard function transfer similar to ERC20 transfer with no _data .
60   // Added due to backwards compatibility reasons .
61   function transfer(address _to, uint _value) returns (bool success) {
62 
63     //standard function transfer similar to ERC20 transfer with no _data
64     //added due to backwards compatibility reasons
65     bytes memory empty;
66     if(isContract(_to)) {
67         return transferToContract(_to, _value, empty);
68     }
69     else {
70         return transferToAddress(_to, _value, empty);
71     }
72 }
73 
74 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
75   function isContract(address _addr) private returns (bool is_contract) {
76       uint length;
77       assembly {
78             //retrieve the size of the code on target address, this needs assembly
79             length := extcodesize(_addr)
80         }
81         if(length>0) {
82             return true;
83         }
84         else {
85             return false;
86         }
87     }
88 
89   //function that is called when transaction target is an address
90   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
91     if (balanceOf(msg.sender) < _value) revert();
92     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
93     balances[_to] = balanceOf(_to).add(_value);
94     Transfer(msg.sender, _to, _value);
95     ERC223Transfer(msg.sender, _to, _value, _data);
96     return true;
97   }
98 
99   //function that is called when transaction target is a contract
100   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
101     if (balanceOf(msg.sender) < _value) revert();
102     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
103     balances[_to] = balanceOf(_to).add(_value);
104     ContractReceiver reciever = ContractReceiver(_to);
105     reciever.tokenFallback(msg.sender, _value, _data);
106     Transfer(msg.sender, _to, _value);
107     ERC223Transfer(msg.sender, _to, _value, _data);
108     return true;
109   }
110 
111 
112   function balanceOf(address _owner) constant returns (uint balance) {
113     return balances[_owner];
114   }
115 }
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that throw on error
119  */
120 library SafeMath {
121 
122   /**
123   * @dev Multiplies two numbers, throws on overflow.
124   */
125   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126     if (a == 0) {
127       return 0;
128     }
129     uint256 c = a * b;
130     assert(c / a == b);
131     return c;
132   }
133 
134   /**
135   * @dev Integer division of two numbers, truncating the quotient.
136   */
137   function div(uint256 a, uint256 b) internal pure returns (uint256) {
138     // assert(b > 0); // Solidity automatically throws when dividing by 0
139     uint256 c = a / b;
140     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
141     return c;
142   }
143 
144   /**
145   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
146   */
147   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148     assert(b <= a);
149     return a - b;
150   }
151 
152   /**
153   * @dev Adds two numbers, throws on overflow.
154   */
155   function add(uint256 a, uint256 b) internal pure returns (uint256) {
156     uint256 c = a + b;
157     assert(c >= a);
158     return c;
159   }
160 }
161 
162 
163 contract Stish is ERC223Token {
164   using SafeMath for uint256;
165 
166 
167   string public name = "Stish";
168   
169   string public symbol = "stish";
170  
171   uint public decimals = 4;
172  
173   uint public totalSupply = 100000000 * (10**decimals);
174 
175   address private treasury = 0xde16281000631dd23e550bbfa9be1c06facd9aad;
176   
177   uint256 private priceDiv = 100000000000;
178   
179   event Purchase(address indexed purchaser, uint256 amount);
180 
181   constructor() public {
182     // This is how many tokens you want to allocate to yourself
183     balances[msg.sender] = 90000000 * (10**decimals);
184     // This is how many tokens you want to allocate for ICO
185     balances[0x0] = 10000000 * (10**decimals);
186   }
187 
188   function () public payable {
189     bytes memory empty;
190     if (msg.value == 0) { revert(); }
191     uint256 purchasedAmount = msg.value.div(priceDiv);
192     if (purchasedAmount == 0) { revert(); } // not enough ETC sent
193     if (purchasedAmount > balances[0x0]) { revert(); } // too much ETC sent
194 
195     treasury.transfer(msg.value);
196     balances[0x0] = balances[0x0].sub(purchasedAmount);
197     balances[msg.sender] = balances[msg.sender].add(purchasedAmount);
198 
199     emit Transfer(0x0, msg.sender, purchasedAmount);
200     emit ERC223Transfer(0x0, msg.sender, purchasedAmount, empty);
201     emit Purchase(msg.sender, purchasedAmount);
202   }
203 }