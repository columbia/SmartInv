1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC223 {
5   uint public totalSupply;
6   function balanceOf(address who) constant returns (uint);
7 
8   function name() constant returns (string _name);
9   function symbol() constant returns (string _symbol);
10   function decimals() constant returns (uint8 _decimals);
11   function totalSupply() constant returns (uint256 _supply);
12 
13   function transfer(address to, uint value) returns (bool ok);
14   function transfer(address to, uint value, bytes data) returns (bool ok);
15   event Transfer(address indexed _from, address indexed _to, uint256 _value);
16   event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
17 }
18 
19 contract ContractReceiver {
20   function tokenFallback(address _from, uint _value, bytes _data);
21 }
22 
23 contract ERC223Token is ERC223 {
24   using SafeMath for uint;
25 
26   mapping(address => uint) balances;
27 
28   string public name;
29   string public symbol;
30   uint8 public decimals;
31   uint256 public totalSupply;
32 
33 
34   // Function to access name of token .
35   function name() constant returns (string _name) {
36       return name;
37   }
38   // Function to access symbol of token .
39   function symbol() constant returns (string _symbol) {
40       return symbol;
41   }
42   // Function to access decimals of token .
43   function decimals() constant returns (uint8 _decimals) {
44       return decimals;
45   }
46   // Function to access total supply of tokens .
47   function totalSupply() constant returns (uint256 _totalSupply) {
48       return totalSupply;
49   }
50 
51   // Function that is called when a user or another contract wants to transfer funds .
52   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
53     if(isContract(_to)) {
54         return transferToContract(_to, _value, _data);
55     }
56     else {
57         return transferToAddress(_to, _value, _data);
58     }
59 }
60 
61   // Standard function transfer similar to ERC20 transfer with no _data .
62   // Added due to backwards compatibility reasons .
63   function transfer(address _to, uint _value) returns (bool success) {
64 
65     //standard function transfer similar to ERC20 transfer with no _data
66     //added due to backwards compatibility reasons
67     bytes memory empty;
68     if(isContract(_to)) {
69         return transferToContract(_to, _value, empty);
70     }
71     else {
72         return transferToAddress(_to, _value, empty);
73     }
74 }
75 
76 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
77   function isContract(address _addr) private returns (bool is_contract) {
78       uint length;
79       assembly {
80             //retrieve the size of the code on target address, this needs assembly
81             length := extcodesize(_addr)
82         }
83         if(length>0) {
84             return true;
85         }
86         else {
87             return false;
88         }
89     }
90 
91   //function that is called when transaction target is an address
92   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
93     if (balanceOf(msg.sender) < _value) revert();
94     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
95     balances[_to] = balanceOf(_to).add(_value);
96     Transfer(msg.sender, _to, _value);
97     ERC223Transfer(msg.sender, _to, _value, _data);
98     return true;
99   }
100 
101   //function that is called when transaction target is a contract
102   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
103     if (balanceOf(msg.sender) < _value) revert();
104     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
105     balances[_to] = balanceOf(_to).add(_value);
106     ContractReceiver reciever = ContractReceiver(_to);
107     reciever.tokenFallback(msg.sender, _value, _data);
108     Transfer(msg.sender, _to, _value);
109     ERC223Transfer(msg.sender, _to, _value, _data);
110     return true;
111   }
112 
113 
114   function balanceOf(address _owner) constant returns (uint balance) {
115     return balances[_owner];
116   }
117 }
118 
119 
120 
121 
122 
123 /**
124  * @title SafeMath
125  * @dev Math operations with safety checks that throw on error
126  */
127 library SafeMath {
128 
129   /**
130   * @dev Multiplies two numbers, throws on overflow.
131   */
132   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133     if (a == 0) {
134       return 0;
135     }
136     uint256 c = a * b;
137     assert(c / a == b);
138     return c;
139   }
140 
141   /**
142   * @dev Integer division of two numbers, truncating the quotient.
143   */
144   function div(uint256 a, uint256 b) internal pure returns (uint256) {
145     // assert(b > 0); // Solidity automatically throws when dividing by 0
146     uint256 c = a / b;
147     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
148     return c;
149   }
150 
151   /**
152   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
153   */
154   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155     assert(b <= a);
156     return a - b;
157   }
158 
159   /**
160   * @dev Adds two numbers, throws on overflow.
161   */
162   function add(uint256 a, uint256 b) internal pure returns (uint256) {
163     uint256 c = a + b;
164     assert(c >= a);
165     return c;
166   }
167 }
168 
169 
170 
171 
172 // your contract's name
173 
174 contract BIBToken is ERC223Token {
175   using SafeMath for uint256;
176 
177   // name
178   string public name = "Blockchain Investor Bearer";
179   // ticker
180   string public symbol = "BIB";
181   // set token's precision
182   //
183   // for example, 4 decimal points means that
184   // smallest token using will be 0.0001 BIB
185   uint public decimals = 4;
186   // total supply of the token
187   // 1 billion
188   uint public totalSupply = 1000000000 * (10**decimals);
189   //
190   address private treasury = 0x3805D6c12b3d53351Ad128EE78f4ca53Fb52dA77;
191   //
192   // given 4 decimals, this setting means "1 ETC = 4000 BIB"
193   uint256 private priceDiv = 25000000000;
194 
195   event Purchase(address indexed purchaser, uint256 amount);
196 
197   constructor() public {
198     // Tokens allocation. 150 million tokens distributed to current shareholders
199     // and 850 millions for future issuing (capital increase) against digital
200     // assets / currencies.
201     balances[msg.sender] = 1000000000 * (10**decimals);
202     // This is how many tokens you want to allocate for ICO
203     balances[0x0] = 0 * (10**decimals);
204   }
205 
206   function () public payable {
207     bytes memory empty;
208     if (msg.value == 0) { revert(); }
209     uint256 purchasedAmount = msg.value.div(priceDiv);
210     if (purchasedAmount == 0) { revert(); } // not enough ETC sent
211     if (purchasedAmount > balances[0x0]) { revert(); } // too much ETC sent
212 
213     treasury.transfer(msg.value);
214     balances[0x0] = balances[0x0].sub(purchasedAmount);
215     balances[msg.sender] = balances[msg.sender].add(purchasedAmount);
216 
217     emit Transfer(0x0, msg.sender, purchasedAmount);
218     emit ERC223Transfer(0x0, msg.sender, purchasedAmount, empty);
219     emit Purchase(msg.sender, purchasedAmount);
220   }
221 }