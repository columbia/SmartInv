1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Contract that will work with ERC223 tokens.
52  */
53  
54 contract ERC223ReceivingContract {
55 
56   struct TKN {
57     address sender;
58     uint value;
59     bytes data;
60     bytes4 sig;
61   }
62 
63   /**
64    * @dev Standard ERC223 function that will handle incoming token transfers.
65    *
66    * @param _from  Token sender address.
67    * @param _value Amount of tokens.
68    * @param _data  Transaction metadata.
69    */
70   function tokenFallback(address _from, uint _value, bytes _data) public pure {
71     TKN memory tkn;
72     tkn.sender = _from;
73     tkn.value = _value;
74     tkn.data = _data;
75     if(_data.length > 0) {
76       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
77       tkn.sig = bytes4(u);
78     }
79 
80     /* tkn variable is analogue of msg variable of Ether transaction
81     *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
82     *  tkn.value the number of tokens that were sent   (analogue of msg.value)
83     *  tkn.data is data of token transaction   (analogue of msg.data)
84     *  tkn.sig is 4 bytes signature of function
85     *  if data of token transaction is a function execution
86     */
87   }
88 
89 }
90 
91 contract ERC223Interface {
92   uint public totalSupply;
93   function balanceOf(address who) public view returns (uint);
94   function allowedAddressesOf(address who) public view returns (bool);
95   function getTotalSupply() public view returns (uint);
96 
97   function transfer(address to, uint value) public returns (bool ok);
98   function transfer(address to, uint value, bytes data) public returns (bool ok);
99   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
100 
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 /**
105  * @title Unity Token is ERC223 token.
106  * @author Vladimir Kovalchuk
107  */
108 
109 contract UnityToken is ERC223Interface {
110   using SafeMath for uint;
111 
112   string public constant name = "Unity Token";
113   string public constant symbol = "UNT";
114   uint8 public constant decimals = 18;
115 
116 
117   /* The supply is initially 100UNT to the precision of 18 decimals */
118   uint public constant INITIAL_SUPPLY = 100000 * (10 ** uint(decimals));
119 
120   mapping(address => uint) balances; // List of user balances.
121   mapping(address => bool) allowedAddresses;
122 
123   modifier onlyOwner() {
124     require(msg.sender == owner);
125     _;
126   }
127 
128   function addAllowed(address newAddress) public onlyOwner {
129     allowedAddresses[newAddress] = true;
130   }
131 
132   function removeAllowed(address remAddress) public onlyOwner {
133     allowedAddresses[remAddress] = false;
134   }
135 
136 
137   address public owner;
138 
139   /* Constructor initializes the owner's balance and the supply  */
140   function UnityToken() public {
141     owner = msg.sender;
142     totalSupply = INITIAL_SUPPLY;
143     balances[owner] = INITIAL_SUPPLY;
144   }
145 
146   function getTotalSupply() public view returns (uint) {
147     return totalSupply;
148   }
149 
150   // Function that is called when a user or another contract wants to transfer funds .
151   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
152     if (isContract(_to)) {
153       require(allowedAddresses[_to]);
154       if (balanceOf(msg.sender) < _value)
155         revert();
156 
157       balances[msg.sender] = balances[msg.sender].sub(_value);
158       balances[_to] = balances[_to].add(_value);
159       assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
160       Transfer(msg.sender, _to, _value);
161       return true;
162     }
163     else {
164       return transferToAddress(_to, _value);
165     }
166   }
167 
168 
169   // Function that is called when a user or another contract wants to transfer funds .
170   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
171 
172     if (isContract(_to)) {
173       return transferToContract(_to, _value, _data);
174     } else {
175       return transferToAddress(_to, _value);
176     }
177   }
178 
179   // Standard function transfer similar to ERC20 transfer with no _data .
180   // Added due to backwards compatibility reasons .
181   function transfer(address _to, uint _value) public returns (bool success) {
182     //standard function transfer similar to ERC20 transfer with no _data
183     //added due to backwards compatibility reasons
184     bytes memory empty;
185     if (isContract(_to)) {
186       return transferToContract(_to, _value, empty);
187     }
188     else {
189       return transferToAddress(_to, _value);
190     }
191   }
192 
193   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
194   function isContract(address _addr) private view returns (bool is_contract) {
195     uint length;
196     assembly {
197     //retrieve the size of the code on target address, this needs assembly
198       length := extcodesize(_addr)
199     }
200     return (length > 0);
201   }
202 
203   //function that is called when transaction target is an address
204   function transferToAddress(address _to, uint _value) private returns (bool success) {
205     if (balanceOf(msg.sender) < _value)
206       revert();
207     balances[msg.sender] = balances[msg.sender].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     Transfer(msg.sender, _to, _value);
210     return true;
211   }
212 
213   //function that is called when transaction target is a contract
214   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
215     require(allowedAddresses[_to]);
216     if (balanceOf(msg.sender) < _value)
217       revert();
218     balances[msg.sender] = balances[msg.sender].sub(_value);
219     balances[_to] = balances[_to].add(_value);
220     ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
221     receiver.tokenFallback(msg.sender, _value, _data);
222     Transfer(msg.sender, _to, _value);
223     return true;
224   }
225 
226 
227   function balanceOf(address _owner) public view returns (uint balance) {
228     return balances[_owner];
229   }
230 
231   function allowedAddressesOf(address _owner) public view returns (bool allowed) {
232     return allowedAddresses[_owner];
233   }
234 }