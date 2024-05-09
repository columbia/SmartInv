1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 /**
52  * @title Contract that will work with ERC223 tokens.
53  */
54  
55 contract ERC223ReceivingContract {
56 
57   struct TKN {
58     address sender;
59     uint value;
60     bytes data;
61     bytes4 sig;
62   }
63 
64   /**
65    * @dev Standard ERC223 function that will handle incoming token transfers.
66    *
67    * @param _from  Token sender address.
68    * @param _value Amount of tokens.
69    * @param _data  Transaction metadata.
70    */
71   function tokenFallback(address _from, uint _value, bytes _data) public pure {
72     TKN memory tkn;
73     tkn.sender = _from;
74     tkn.value = _value;
75     tkn.data = _data;
76     if(_data.length > 0) {
77       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
78       tkn.sig = bytes4(u);
79     }
80 
81     /* tkn variable is analogue of msg variable of Ether transaction
82     *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
83     *  tkn.value the number of tokens that were sent   (analogue of msg.value)
84     *  tkn.data is data of token transaction   (analogue of msg.data)
85     *  tkn.sig is 4 bytes signature of function
86     *  if data of token transaction is a function execution
87     */
88   }
89 
90 }
91 
92 contract ERC223Interface {
93   uint public totalSupply;
94   function balanceOf(address who) public view returns (uint);
95   function allowedAddressesOf(address who) public view returns (bool);
96   function getTotalSupply() public view returns (uint);
97 
98   function transfer(address to, uint value) public returns (bool ok);
99   function transfer(address to, uint value, bytes data) public returns (bool ok);
100   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
101 
102   event Transfer(address indexed from, address indexed to, uint value, bytes data);
103   event TransferContract(address indexed from, address indexed to, uint value, bytes data);
104 }
105 
106 /**
107  * @title Unity Token is ERC223 token.
108  * @author Vladimir Kovalchuk
109  */
110 
111 contract UnityToken is ERC223Interface {
112   using SafeMath for uint;
113 
114   string public constant name = "Unity Token";
115   string public constant symbol = "UNT";
116   uint8 public constant decimals = 18;
117 
118 
119   /* The supply is initially 100UNT to the precision of 18 decimals */
120   uint public constant INITIAL_SUPPLY = 100000 * (10 ** uint(decimals));
121 
122   mapping(address => uint) balances; // List of user balances.
123   mapping(address => bool) allowedAddresses;
124 
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130   function addAllowed(address newAddress) public onlyOwner {
131     allowedAddresses[newAddress] = true;
132   }
133 
134   function removeAllowed(address remAddress) public onlyOwner {
135     allowedAddresses[remAddress] = false;
136   }
137 
138 
139   address public owner;
140 
141   /* Constructor initializes the owner's balance and the supply  */
142   function UnityToken() public {
143     owner = msg.sender;
144     totalSupply = INITIAL_SUPPLY;
145     balances[owner] = INITIAL_SUPPLY;
146   }
147 
148   function getTotalSupply() public view returns (uint) {
149     return totalSupply;
150   }
151 
152   // Function that is called when a user or another contract wants to transfer funds .
153   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
154     if (isContract(_to)) {
155       require(allowedAddresses[_to]);
156       if (balanceOf(msg.sender) < _value)
157         revert();
158 
159       balances[msg.sender] = balances[msg.sender].sub(_value);
160       balances[_to] = balances[_to].add(_value);
161       assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
162       TransferContract(msg.sender, _to, _value, _data);
163       return true;
164     }
165     else {
166       return transferToAddress(_to, _value, _data);
167     }
168   }
169 
170 
171   // Function that is called when a user or another contract wants to transfer funds .
172   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
173 
174     if (isContract(_to)) {
175       return transferToContract(_to, _value, _data);
176     } else {
177       return transferToAddress(_to, _value, _data);
178     }
179   }
180 
181   // Standard function transfer similar to ERC20 transfer with no _data .
182   // Added due to backwards compatibility reasons .
183   function transfer(address _to, uint _value) public returns (bool success) {
184     //standard function transfer similar to ERC20 transfer with no _data
185     //added due to backwards compatibility reasons
186     bytes memory empty;
187     if (isContract(_to)) {
188       return transferToContract(_to, _value, empty);
189     }
190     else {
191       return transferToAddress(_to, _value, empty);
192     }
193   }
194 
195   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
196   function isContract(address _addr) private view returns (bool is_contract) {
197     uint length;
198     assembly {
199     //retrieve the size of the code on target address, this needs assembly
200       length := extcodesize(_addr)
201     }
202     return (length > 0);
203   }
204 
205   //function that is called when transaction target is an address
206   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
207     if (balanceOf(msg.sender) < _value)
208       revert();
209     balances[msg.sender] = balances[msg.sender].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     Transfer(msg.sender, _to, _value, _data);
212     return true;
213   }
214 
215   //function that is called when transaction target is a contract
216   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
217     require(allowedAddresses[_to]);
218     if (balanceOf(msg.sender) < _value)
219       revert();
220     balances[msg.sender] = balances[msg.sender].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
223     receiver.tokenFallback(msg.sender, _value, _data);
224     TransferContract(msg.sender, _to, _value, _data);
225     return true;
226   }
227 
228 
229   function balanceOf(address _owner) public view returns (uint balance) {
230     return balances[_owner];
231   }
232 
233   function allowedAddressesOf(address _owner) public view returns (bool allowed) {
234     return allowedAddresses[_owner];
235   }
236 }