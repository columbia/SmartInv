1 pragma solidity ^0.4.24; 
2 
3 contract ERC223 {
4   uint public totalSupply;
5   function balanceOf(address who) constant returns (uint);
6 
7   function name() constant returns (string _name);
8   function symbol() constant returns (string _symbol);
9   function decimals() constant returns (uint8 _decimals);
10   function totalSupply() constant returns (uint256 _supply);
11 
12   function transfer(address to, uint value) returns (bool ok);
13   function transfer(address to, uint value, bytes data) returns (bool ok);
14   event Transfer(address indexed _from, address indexed _to, uint256 _value);
15   event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
16 }
17 
18 contract ContractReceiver {
19   function tokenFallback(address _from, uint _value, bytes _data);
20 }
21 
22 contract ERC223Token is ERC223 {
23   using SafeMath for uint;
24 
25   mapping(address => uint) balances;
26 
27   string public name;
28   string public symbol;
29   uint8 public decimals;
30   uint256 public totalSupply;
31 
32 
33   // Function to access name of token .
34   function name() constant returns (string _name) {
35       return name;
36   }
37   // Function to access symbol of token .
38   function symbol() constant returns (string _symbol) {
39       return symbol;
40   }
41   // Function to access decimals of token .
42   function decimals() constant returns (uint8 _decimals) {
43       return decimals;
44   }
45   // Function to access total supply of tokens .
46   function totalSupply() constant returns (uint256 _totalSupply) {
47       return totalSupply;
48   }
49 
50   // Function that is called when a user or another contract wants to transfer funds .
51   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
52     if(isContract(_to)) {
53         return transferToContract(_to, _value, _data);
54     }
55     else {
56         return transferToAddress(_to, _value, _data);
57     }
58 }
59 
60   // Standard function transfer similar to ERC20 transfer with no _data .
61   // Added due to backwards compatibility reasons .
62   function transfer(address _to, uint _value) returns (bool success) {
63 
64     //standard function transfer similar to ERC20 transfer with no _data
65     //added due to backwards compatibility reasons
66     bytes memory empty;
67     if(isContract(_to)) {
68         return transferToContract(_to, _value, empty);
69     }
70     else {
71         return transferToAddress(_to, _value, empty);
72     }
73 }
74 
75 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
76   function isContract(address _addr) private returns (bool is_contract) {
77       uint length;
78       assembly {
79             //retrieve the size of the code on target address, this needs assembly
80             length := extcodesize(_addr)
81         }
82         if(length>0) {
83             return true;
84         }
85         else {
86             return false;
87         }
88     }
89 
90   //function that is called when transaction target is an address
91   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
92     if (balanceOf(msg.sender) < _value) revert();
93     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
94     balances[_to] = balanceOf(_to).add(_value);
95     Transfer(msg.sender, _to, _value);
96     ERC223Transfer(msg.sender, _to, _value, _data);
97     return true;
98   }
99 
100   //function that is called when transaction target is a contract
101   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
102     if (balanceOf(msg.sender) < _value) revert();
103     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
104     balances[_to] = balanceOf(_to).add(_value);
105     ContractReceiver reciever = ContractReceiver(_to);
106     reciever.tokenFallback(msg.sender, _value, _data);
107     Transfer(msg.sender, _to, _value);
108     ERC223Transfer(msg.sender, _to, _value, _data);
109     return true;
110   }
111 
112 
113   function balanceOf(address _owner) constant returns (uint balance) {
114     return balances[_owner];
115   }
116 }
117 
118 
119 
120 /**
121  * @title SafeMath
122  * @dev Math operations with safety checks that throw on error
123  */
124 library SafeMath {
125 
126   /**
127   * @dev Multiplies two numbers, throws on overflow.
128   */
129   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130     if (a == 0) {
131       return 0;
132     }
133     uint256 c = a * b;
134     assert(c / a == b);
135     return c;
136   }
137 
138   /**
139   * @dev Integer division of two numbers, truncating the quotient.
140   */
141   function div(uint256 a, uint256 b) internal pure returns (uint256) {
142     // assert(b > 0); // Solidity automatically throws when dividing by 0
143     uint256 c = a / b;
144     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
145     return c;
146   }
147 
148   /**
149   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
150   */
151   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152     assert(b <= a);
153     return a - b;
154   }
155 
156   /**
157   * @dev Adds two numbers, throws on overflow.
158   */
159   function add(uint256 a, uint256 b) internal pure returns (uint256) {
160     uint256 c = a + b;
161     assert(c >= a);
162     return c;
163   }
164 }
165 
166 
167 
168 
169   
170 
171 // change contract name to your contract's name
172 // i.e. "contract Bitcoin is ERC223Token"
173 contract BitUnits is ERC223Token {
174   using SafeMath for uint256;
175 
176   // for example, "Bitcoin"
177   string public name = "BitUnits";
178   // for example, "BTC"
179   string public symbol = "UNITX";
180   // set token's precision
181   // pick any number from 0 to 18
182   // for example, 4 decimal points means that
183   // smallest token using will be 0.0001 TKN
184   uint public decimals = 8;
185   // total supply of the token
186   // for example, for Bitcoin it would be 21000000
187   uint public totalSupply = 10000000 * (10**decimals);
188 
189   // Treasure is where ICO funds (ETH/ETC) will be forwarded
190   // replace this address with your wallet address!
191   // it is recommended that you create a paper wallet for this purpose
192   address private treasury = 0xeb3C95a5CEB6Ae90f47380694F1922dFA1aed3C4;
193   
194   // ICO price. You will need to do a little bit of math to figure it out
195   // given 4 decimals, this setting means "1 ETC = 50,000 TKN"
196   uint256 private priceDiv = 2000000000;
197   
198   event Purchase(address indexed purchaser, uint256 amount);
199 
200   constructor() public {
201     // This is how many tokens you want to allocate to yourself
202     balances[msg.sender] = 10000000 * (10**decimals);
203     // This is how many tokens you want to allocate for ICO
204     balances[0x0] = 0 * (10**decimals);
205   }
206 
207   function () public payable {
208     bytes memory empty;
209     if (msg.value == 0) { revert(); }
210     uint256 purchasedAmount = msg.value.div(priceDiv);
211     if (purchasedAmount == 0) { revert(); } // not enough ETC sent
212     if (purchasedAmount > balances[0x0]) { revert(); } // too much ETC sent
213 
214     treasury.transfer(msg.value);
215     balances[0x0] = balances[0x0].sub(purchasedAmount);
216     balances[msg.sender] = balances[msg.sender].add(purchasedAmount);
217 
218     emit Transfer(0x0, msg.sender, purchasedAmount);
219     emit ERC223Transfer(0x0, msg.sender, purchasedAmount, empty);
220     emit Purchase(msg.sender, purchasedAmount);
221   }
222 }