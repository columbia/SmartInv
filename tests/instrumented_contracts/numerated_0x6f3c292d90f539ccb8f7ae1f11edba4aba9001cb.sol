1 pragma solidity >=0.4.22 <0.6.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b); // will fail if overflow
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32 
33     return c;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     require(b <= a);
41     uint256 c = a - b;
42 
43     return c;
44   }
45 
46   /**
47   * @dev Adds two numbers, reverts on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     require(c >= a); // will fail if overflow because of wraparound
52 
53     return c;
54   }
55 
56   /**
57   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
58   * reverts when dividing by zero.
59   */
60   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b != 0);
62     return a % b;
63   }
64 }
65 
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic
69  * authorization control functions, this simplifies the implementation of
70  * "user permissions".
71  */
72 contract Ownable {
73   using SafeMath for uint256;
74   address public owner;
75  
76   /**
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78    * account.
79    */
80   constructor() public {
81     owner = msg.sender;
82   }
83  
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91  
92   /**
93    * @dev Allows the current owner to transfer control of the contract to a newOwner.
94    * @param newOwner The address to transfer ownership to.
95    */
96   function transferOwnership(address newOwner) public onlyOwner {
97     require(newOwner != address(0));  // can't accidentally burn the entire contract
98     owner = newOwner;
99   }
100 
101   /**
102    * @dev Allows the owner to withdraw the ether for conversion to USD to handle
103    * tax credits properly.
104    * Note: this function withdraws the entire balance of the contract!
105    * @param destination The destination address to withdraw the funds to
106    */
107   function withdraw(address payable destination) public onlyOwner {
108     require(destination != address(0));
109     destination.transfer(address(this).balance);
110   }
111 
112   /**
113    * @dev Allows the owner to view the current balance of the contract to 6 decimal places
114    */
115   function getBalance() public view onlyOwner returns (uint256) {
116     return address(this).balance.div(1 szabo);
117   }
118 
119 }
120 
121 /**
122  * @title Tokenization of tax credits
123  *
124  * @dev Implementation of a permissioned token.
125  */
126 contract TaxCredit is Ownable {
127   using SafeMath for uint256;
128 
129   mapping (address => uint256) private balances;
130   mapping (address => string) private emails;
131   address[] addresses;
132   uint256 public minimumPurchase = 1950 ether;  // minimum purchase is 300,000 credits (270,000 USD)
133   uint256 private _totalSupply;
134   uint256 private exchangeRate = (270000 ether / minimumPurchase) + 1;  // convert to credit tokens - account for integer division
135   uint256 private discountRate = 1111111111111111111 wei;  // giving credits at 10% discount (90 * 1.11111 = 100)
136 
137   string public name = "Tax Credit Token";
138   string public symbol = "TCT";
139   uint public INITIAL_SUPPLY = 20000000;  // 20m credits reserved for use by Clean Energy Systems LLC
140 
141   event Transfer(
142     address indexed from,
143     address indexed to,
144     uint256 value
145   );
146 
147   event Exchange(
148     string indexed email,
149     address indexed addr,
150     uint256 value
151   );
152 
153   constructor() public {
154     mint(msg.sender, INITIAL_SUPPLY);
155   }
156 
157   /**
158   * @dev Total number of tokens in existence
159   */
160   function totalSupply() public view returns (uint256) {
161     return _totalSupply;
162   }
163 
164   /**
165   * @dev Gets the balance of the specified address.
166   * @param owner The address to query the balance of.
167   * @return An uint256 representing the amount owned by the passed address.
168   */
169   function balanceOf(address owner) public view returns (uint256) {
170     return balances[owner];
171   }
172 
173   /**
174    * @dev Transfer tokens from one address to another - since there are off-chain legal
175    * transactions that must occur, this function can only be called by the owner; any
176    * entity that wants to transfer tax credit tokens must go through the contract owner in order
177    * to get legal documents dispersed first
178    * @param from address The address to send tokens from
179    * @param to address The address to transfer to
180    * @param value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(address from, address to, uint256 value) public onlyOwner {
183     require(value <= balances[from]);
184 
185     balances[from] = balances[from].sub(value);
186     balances[to] = balances[to].add(value);
187     emit Transfer(from, to, value);
188   }
189 
190   /**
191    * @dev Public function that mints an amount of the token and assigns it to
192    * an account. This encapsulates the modification of balances such that the
193    * proper events are emitted. Only the owner of the contract can mint tokens at will.
194    * @param account The account that will receive the created tokens.
195    * @param value The amount that will be created.
196    */
197   function mint(address account, uint256 value) public onlyOwner {
198     _handleMint(account, value);
199   }
200 
201   /**
202    * @dev Internal function that handles and executes the minting of tokens. This
203    * function exists because there are times when tokens may need to be minted,
204    * but not by the owner of the contract (namely, when participants exchange their
205    * ether for tokens).
206    * @param account The account that will receive the created tokens.
207    * @param value The amount that will be created.
208    */
209   function _handleMint(address account, uint256 value) internal {
210     require(account != address(0));
211     _totalSupply = _totalSupply.add(value);
212     balances[account] = balances[account].add(value);
213     emit Transfer(address(0), account, value);
214   }
215 
216   /**
217    * @dev Internal function that burns an amount of the token of a given
218    * account.
219    * @param account The account whose tokens will be burnt.
220    * @param value The amount that will be burnt.
221    */
222   function burn(address account, uint256 value) public onlyOwner {
223     require(account != address(0));
224     require(value <= balances[account]);
225 
226     _totalSupply = _totalSupply.sub(value);
227     balances[account] = balances[account].sub(value);
228     emit Transfer(account, address(0), value);
229   }
230 
231   /**
232    * @dev Allows entities to exchange their Ethereum for tokens representing
233    * their tax credits. This function mints new tax credit tokens that are backed
234    * by the ethereum sent to exchange for them.
235    */
236   function exchange(string memory email) public payable {
237     require(msg.value > minimumPurchase);
238     require(keccak256(bytes(email)) != keccak256(bytes("")));  // require email parameter
239 
240     addresses.push(msg.sender);
241     emails[msg.sender] = email;
242     uint256 tokens = msg.value.mul(exchangeRate);
243     tokens = tokens.mul(discountRate);
244     tokens = tokens.div(1 ether).div(1 ether);  // offset exchange rate & discount rate multiplications
245     _handleMint(msg.sender, tokens);
246     emit Exchange(email, msg.sender, tokens);
247   }
248 
249   /**
250    * @dev Allows owner to change minimum purchase in order to keep minimum
251    * tax credit exchange around a certain USD threshold
252    * @param newMinimum The new minimum amount of ether required to purchase tax credit tokens
253    */
254   function changeMinimumExchange(uint256 newMinimum) public onlyOwner {
255     require(newMinimum > 0);  // if minimum is 0 then division errors will occur for exchange and discount rates
256     minimumPurchase = newMinimum * 1 ether;
257     exchangeRate = 270000 ether / minimumPurchase;
258   }
259 
260   /**
261    * @dev Return a list of all participants in the contract by address
262    */
263   function getAllAddresses() public view returns (address[] memory) {
264     return addresses;
265   }
266 
267   /**
268    * @dev Return the email of a participant by Ethereum address
269    * @param addr The address from which to retrieve the email
270    */
271   function getParticipantEmail(address addr) public view returns (string memory) {
272     return emails[addr];
273   }
274 
275   /*
276    * @dev Return all addresses belonging to a certain email (it is possible that an
277    * entity may purchase tax credit tokens multiple times with different Ethereum addresses).
278    * 
279    * NOTE: This transaction may incur a significant gas cost as more participants purchase credits.
280    */
281   function getAllAddresses(string memory email) public view onlyOwner returns (address[] memory) {
282     address[] memory all = new address[](addresses.length);
283     for (uint32 i = 0; i < addresses.length; i++) {
284       if (keccak256(bytes(emails[addresses[i]])) == keccak256(bytes(email))) {
285         all[i] = addresses[i];
286       }
287     }
288     return all;
289   }
290 
291 }