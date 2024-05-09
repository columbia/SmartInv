1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) constant returns (uint256);
43   function transfer(address to, uint256 value) returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 is ERC20Basic {
54   function allowance(address owner, address spender) constant returns (uint256);
55   function transferFrom(address from, address to, uint256 value) returns (bool);
56   function approve(address spender, uint256 value) returns (bool);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances. 
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) returns (bool) {
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84   * @dev Gets the balance of the specified address.
85   * @param _owner The address to query the the balance of. 
86   * @return An uint256 representing the amount owned by the passed address.
87   */
88   function balanceOf(address _owner) constant returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92 }
93 
94 // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
95 
96 /**
97  * @title Ownable
98  * @dev The Ownable contract has an owner address, and provides basic authorization control
99  * functions, this simplifies the implementation of "user permissions".
100  */
101 contract Ownable {
102   address public owner;
103 
104 
105   /**
106    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
107    * account.
108    */
109   function Ownable() {
110     owner = msg.sender;
111   }
112 
113 
114   /**
115    * @dev Throws if called by any account other than the owner.
116    */
117   modifier onlyOwner() {
118     require(msg.sender == owner);
119     _;
120   }
121 
122 
123   /**
124    * @dev Allows the current owner to transfer control of the contract to a newOwner.
125    * @param newOwner The address to transfer ownership to.
126    */
127   function transferOwnership(address newOwner) onlyOwner {
128     if (newOwner != address(0)) {
129       owner = newOwner;
130     }
131   }
132 
133 }
134 
135 // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) allowed;
147 
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amout of tokens to be transfered
154    */
155   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
156     var _allowance = allowed[_from][msg.sender];
157 
158     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
159     // require (_value <= _allowance);
160 
161     balances[_to] = balances[_to].add(_value);
162     balances[_from] = balances[_from].sub(_value);
163     allowed[_from][msg.sender] = _allowance.sub(_value);
164     Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    * @param _spender The address which will spend the funds.
171    * @param _value The amount of tokens to be spent.
172    */
173   function approve(address _spender, uint256 _value) returns (bool) {
174 
175     // To change the approve amount you first have to reduce the addresses`
176     //  allowance to zero by calling `approve(_spender, 0)` if it is not
177     //  already 0 to mitigate the race condition described here:
178     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
180 
181     allowed[msg.sender][_spender] = _value;
182     Approval(msg.sender, _spender, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Function to check the amount of tokens that an owner allowed to a spender.
188    * @param _owner address The address which owns the funds.
189    * @param _spender address The address which will spend the funds.
190    * @return A uint256 specifing the amount of tokens still avaible for the spender.
191    */
192   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
193     return allowed[_owner][_spender];
194   }
195 
196 }
197 
198 // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
199 
200 contract ConpayToken is StandardToken, Ownable {
201   string public name = 'ConpayToken';
202   string public symbol = 'COP';
203   uint public decimals = 18;
204 
205   uint public constant crowdsaleEndTime = 1509580800;
206 
207   uint256 public startTime;
208   uint256 public endTime;
209   uint256 public tokensSupply;
210   uint256 public rate;
211   uint256 public perAddressCap;
212   address public wallet;
213 
214   uint256 public tokensSold;
215 
216   bool public stopped; 
217   event SaleStart();
218   event SaleStop();
219 
220   modifier crowdsaleTransferLock() {
221     require(now > crowdsaleEndTime);
222     _;
223   }
224 
225   function ConpayToken() {
226     totalSupply = 2325000000 * (10**18);
227     balances[msg.sender] = totalSupply;
228     startSale(
229       1503921600, /*pre-ico start time*/
230       1505131200, /*pre-ico end time*/
231       75000000 * (10**18), /*pre-ico tokensSupply*/
232       45000, /*pre-ico rate*/
233       0, /*pre-ico perAddressCap*/
234       address(0x2D0a11e28b71788ae72A9beae8FAb937584B05Fd) /*pre-ico wallet*/
235     );
236   }
237 
238   function() payable {
239     buy(msg.sender);
240   }
241 
242   function buy(address buyer) public payable {
243     require(!stopped);
244     require(buyer != 0x0);
245     require(msg.value > 0);
246     require(now >= startTime && now <= endTime);
247 
248     uint256 tokens = msg.value.mul(rate);
249     assert(perAddressCap == 0 || balances[buyer].add(tokens) <= perAddressCap);
250     assert(tokensSupply.sub(tokens) >= 0);
251 
252     balances[buyer] = balances[buyer].add(tokens);
253     balances[owner] = balances[owner].sub(tokens);
254     tokensSupply = tokensSupply.sub(tokens);
255     tokensSold = tokensSold.add(tokens);
256 
257     assert(wallet.send(msg.value));
258     Transfer(this, buyer, tokens);
259   }
260 
261   function startSale(
262     uint256 saleStartTime,
263     uint256 saleEndTime,
264     uint256 saletokensSupply,
265     uint256 saleRate,
266     uint256 salePerAddressCap,
267     address saleWallet
268   ) onlyOwner {
269     startTime = saleStartTime;
270     endTime = saleEndTime;
271     tokensSupply = saletokensSupply;
272     rate = saleRate;
273     perAddressCap = salePerAddressCap;
274     wallet = saleWallet;
275     stopped = false;
276     SaleStart();
277   }
278 
279   function stopSale() onlyOwner {
280     stopped = true;
281     SaleStop();
282   }
283 
284   function transfer(address _to, uint _value) crowdsaleTransferLock returns (bool) {
285     return super.transfer(_to, _value);
286   }
287 
288   function transferFrom(address _from, address _to, uint _value) crowdsaleTransferLock returns (bool) {
289     return super.transferFrom(_from, _to, _value);
290   }
291 }