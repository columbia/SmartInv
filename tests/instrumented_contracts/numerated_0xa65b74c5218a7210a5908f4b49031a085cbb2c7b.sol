1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6   uint constant public MAX_UINT256 =
7     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /*
50   Contract to handle all behavior related to ownership of contracts
51   -handles tracking current owner and transferring ownership to new owners
52 */
53 contract Owned {
54   address public owner;
55   address private newOwner;
56 
57   event OwnershipTransferred(address indexed_from, address indexed_to);
58 
59   function Owned() public {
60     owner = msg.sender;
61   }
62 
63   modifier onlyOwner {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   function transferOwnership(address _newOwner) public onlyOwner {
69     newOwner = _newOwner;
70   }
71 
72   function acceptOwnership() public {
73     require(msg.sender == newOwner);
74     emit OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76     newOwner = address(0); //reset newOwner to 0/null
77   }
78 }
79 
80 /*
81   Interface for being ERC223 compliant
82   -ERC223 is an industry standard for smart contracts
83 */
84 contract ERC223 {
85   function balanceOf(address who) public view returns (uint);
86   
87   function name() public view returns (string _name);
88   function symbol() public view returns (string _symbol);
89   function decimals() public view returns (uint8 _decimals);
90   function totalSupply() public view returns (uint256 _supply);
91 
92   function transfer(address to, uint value) public returns (bool ok);
93   function transfer(address to, uint value, bytes data) public returns (bool ok);
94   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
95   
96   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
97 }
98 
99 /*
100  * Contract that is working with ERC223 tokens as a receiver for contract transfers
101  */
102  
103  contract ContractReceiver {
104      
105     struct TKN {
106         address sender;
107         uint value;
108         bytes data;
109         bytes4 sig;
110     }
111     
112     
113     function tokenFallback(address _from, uint _value, bytes _data) public pure {
114       TKN memory tkn;
115       tkn.sender = _from;
116       tkn.value = _value;
117       tkn.data = _data;
118       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
119       tkn.sig = bytes4(u);
120       
121       /* tkn variable is analogue of msg variable of Ether transaction
122       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
123       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
124       *  tkn.data is data of token transaction   (analogue of msg.data)
125       *  tkn.sig is 4 bytes signature of function
126       *  if data of token transaction is a function execution
127       */
128     }
129 }
130 
131 /*
132   @author Nicholas Tuley
133   @desc Contract for the C2L token that carries out all token-specific behaviors for the C2L token
134 */
135 contract C2L is ERC223, Owned {
136   //constants
137   uint internal constant INITIAL_COIN_BALANCE = 21000000; //starting balance of 21 million coins
138 
139   //variables
140   string public name = "C2L"; //name of currency
141   string public symbol = "C2L";
142   uint8 public decimals = 0;
143   mapping(address => bool) beingEdited; //mapping to prevent multiple edits of the same account occuring at the same time (reentrancy)
144 
145   uint public totalCoinSupply = INITIAL_COIN_BALANCE; //number of this coin in active existence
146   mapping(address => uint) internal balances; //balances of users with this coin
147   mapping(address => mapping(address => uint)) internal allowed; //map holding how much each user is allowed to transfer out of other addresses
148   address[] addressLUT;
149 
150   //C2L contract constructor
151   function C2L() public {
152     totalCoinSupply = INITIAL_COIN_BALANCE;
153     balances[owner] = totalCoinSupply;
154     updateAddresses(owner);
155   }
156 
157   //getter methods for basic contract info
158   function name() public view returns (string _name) {
159     return name;
160   }
161 
162   function symbol() public view returns (string _symbol) {
163     return symbol;
164   }
165 
166   function decimals() public view returns (uint8 _decimals) {
167     return decimals;
168   }
169 
170   /*
171     @return the total supply of this coin
172   */
173   function totalSupply() public view returns (uint256 _supply) {
174     return totalCoinSupply;
175   }
176 
177   //toggle beingEdited status of this account
178   function setEditedTrue(address _subject) private {
179     beingEdited[_subject] = true;
180   }
181 
182   function setEditedFalse(address _subject) private {
183     beingEdited[_subject] = false;
184   }
185 
186   /*
187     get the balance of a given user
188     @param tokenOwner the address of the user account being queried
189     @return the balance of the given account
190   */
191   function balanceOf(address who) public view returns (uint) {
192     return balances[who];
193   }
194 
195   /*
196     Check if the given address is a contract
197   */
198   function isContract(address _addr) private view returns (bool is_contract) {
199     uint length;
200     assembly {
201           //retrieve the size of the code on target address, this needs assembly
202           length := extcodesize(_addr)
203     }
204     return (length>0);
205   }
206 
207   /*
208     owner mints new coins
209     @param amount The number of coins to mint
210     @condition
211       -the sender of this message must be the owner/minter/creator of this contract
212   */
213   function mint(uint amount) public onlyOwner {
214     require(beingEdited[owner] != true);
215     setEditedTrue(owner);
216     totalCoinSupply = SafeMath.add(totalCoinSupply, amount);
217     balances[owner] = SafeMath.add(balances[owner], amount);
218     setEditedFalse(owner);
219   }
220 
221   /*
222     transfer tokens to a user from the msg sender
223     @param _to The address of the user coins are being sent to
224     @param _value The number of coins to send
225     @param _data The msg data for this transfer
226     @param _custom_fallback A custom fallback function for this transfer
227     @conditions:
228       -coin sender must have enough coins to carry out transfer
229       -the balances of the sender and receiver of the tokens must not be being edited by another transfer at the same time
230     @return True if execution of transfer is successful, False otherwise
231   */
232   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
233     if(isContract(_to)) {
234       require(beingEdited[_to] != true && beingEdited[msg.sender] != true);
235       //make sure the sender has enough coins to transfer
236       require (balances[msg.sender] >= _value); 
237       setEditedTrue(_to);
238       setEditedTrue(msg.sender);
239       //transfer the coins
240       balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
241       balances[_to] = SafeMath.add(balances[_to], _value);
242       assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
243       emit Transfer(msg.sender, _to, _value, _data); //log the transfer
244       setEditedFalse(_to);
245       setEditedFalse(msg.sender);
246       updateAddresses(_to);
247       updateAddresses(msg.sender);
248       return true;
249     }
250     else {
251       return transferToAddress(_to, _value, _data);
252     }
253   }
254 
255   /*
256     Carry out transfer of tokens between accounts
257     @param _to The address of the user coins are being sent to
258     @param _value The number of coins to send
259     @param _data The msg data for this transfer
260     @conditions:
261       -coin sender must have enough coins to carry out transfer
262       -the balances of the sender and receiver of the tokens must not be being edited by another transfer at the same time
263     @return True if execution of transfer is successful, False otherwise
264   */
265   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
266       if(isContract(_to)) {
267           return transferToContract(_to, _value, _data);
268       }
269       else {
270           return transferToAddress(_to, _value, _data);
271       }
272   }
273 
274   /*
275     Backwards compatible transfer function to satisfy ERC20
276   */
277   function transfer(address _to, uint _value) public returns (bool success) {
278       //standard function transfer similar to ERC20 transfer with no _data
279       //added due to backwards compatibility reasons
280       bytes memory empty;
281       if(isContract(_to)) {
282           return transferToContract(_to, _value, empty);
283       }
284       else {
285           return transferToAddress(_to, _value, empty);
286       }
287   }
288 
289   //transfer function that is called when transaction target is an address
290     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
291       require(beingEdited[_to] != true && beingEdited[msg.sender] != true);
292       require (balanceOf(msg.sender) >= _value);
293       setEditedTrue(_to);
294       setEditedTrue(msg.sender);
295       balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
296       balances[_to] = SafeMath.add(balanceOf(_to), _value);
297       emit Transfer(msg.sender, _to, _value, _data);
298       setEditedFalse(_to);
299       setEditedFalse(msg.sender);
300       updateAddresses(_to);
301       updateAddresses(msg.sender);
302       return true;
303     }
304 
305   //transfer function that is called when transaction target is a contract
306     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
307       require(beingEdited[_to] != true && beingEdited[msg.sender] != true);
308       require (balanceOf(msg.sender) >= _value);
309       setEditedTrue(_to);
310       setEditedTrue(msg.sender);
311       balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
312       balances[_to] = SafeMath.add(balanceOf(_to), _value);
313       ContractReceiver receiver = ContractReceiver(_to);
314       receiver.tokenFallback(msg.sender, _value, _data);
315       emit Transfer(msg.sender, _to, _value, _data);
316       setEditedFalse(_to);
317       setEditedFalse(msg.sender);
318       updateAddresses(_to);
319       updateAddresses(msg.sender);
320       return true;
321   }
322 
323   /*
324     update the addressLUT list of addresses by checking if the address is in the list already, and if not, add the address to the list
325     @param _lookup The address to check if it is in the list
326   */
327   function updateAddresses(address _lookup) private {
328     for(uint i = 0; i < addressLUT.length; i++) {
329       if(addressLUT[i] == _lookup) return;
330     }
331     addressLUT.push(_lookup);
332   }
333 
334   //default, fallback function
335   function () public payable {
336   }
337 
338   //self-destruct function for this contract
339   function killCoin() public onlyOwner {
340     selfdestruct(owner);
341   }
342 
343 }