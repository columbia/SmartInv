1 pragma solidity ^0.4.13;
2 
3  /*
4  * This is the smart contract for the Fornicoin token.
5  * More information can be found on our website at: https://fornicoin.network
6  * Created by the Fornicoin Team <info@fornicoin.network>
7  */
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   uint256 public totalSupply;
16   function balanceOf(address who) public constant returns (uint256);
17   function transfer(address to, uint256 value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal constant returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint _value) public returns (bool) {
69     require(_to != address(0));
70 
71     // SafeMath.sub will throw if there is not enough balance.
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of.
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) public constant returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94   function allowance(address owner, address spender) public constant returns (uint256);
95   function transferFrom(address from, address to, uint256 value) public returns (bool);
96   function approve(address spender, uint256 value) public returns (bool);
97   event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, BasicToken {
109     
110      mapping (address => mapping (address => uint256)) allowed;
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     
121     var _allowance = allowed[_from][msg.sender];
122 
123     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
124     // require (_value <= _allowance);
125 
126     balances[_from] = balances[_from].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     allowed[_from][msg.sender] = _allowance.sub(_value);
129     Transfer(_from, _to, _value);
130     return true;
131   }
132   
133     /**
134    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
135    * @param _spender The address which will spend the funds.
136    * @param _value The amount of tokens to be spent.
137    */
138   function approve(address _spender, uint256 _value) returns (bool) {
139 
140     // To change the approve amount you first have to reduce the addresses`
141     //  allowance to zero by calling `approve(_spender, 0)` if it is not
142     //  already 0 to mitigate the race condition described here:
143     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
145 
146     allowed[msg.sender][_spender] = _value;
147     Approval(msg.sender, _spender, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Function to check the amount of tokens that an owner allowed to a spender.
153    * @param _owner address The address which owns the funds.
154    * @param _spender address The address which will spend the funds.
155    * @return A uint256 specifing the amount of tokens still avaible for the spender.
156    */
157   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
158     return allowed[_owner][_spender];
159   }
160 
161 }
162 
163 /**
164  * @title Ownable
165  * @dev The Ownable contract has an owner address, and provides basic authorization control
166  * functions, this simplifies the implementation of "user permissions".
167  */
168 contract Ownable {
169   address public owner;
170 
171   /**
172    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
173    * account.
174    */
175   function Ownable() {
176     owner = msg.sender;
177   }
178 
179 
180   /**
181    * @dev Throws if called by any account other than the owner.
182    */
183   modifier onlyOwner() {
184     require(msg.sender == owner);
185     _;
186   }
187 
188 }
189 
190 
191 
192  /*
193  * This is the smart contract for the Fornicoin token.
194  * More information can be found on our website at: https://fornicoin.network
195  * Created by the Fornicoin Team <info@fornicoin.network>
196  */
197 
198 contract FornicoinToken is StandardToken, Ownable {
199   using SafeMath for uint256;
200 
201   string public constant name = "Fornicoin";
202   string public constant symbol = "FXX";
203   uint8 public constant decimals = 18;
204 
205   // 100 000 000 Fornicoin tokens created
206   uint256 public constant MAX_SUPPLY = 100000000 * (10 ** uint256(decimals));
207   
208   // admin address for team functions
209   address public admin;
210   uint256 public teamTokens = 25000000 * (10 ** 18);
211   
212   // Top up gas balance
213   uint256 public minBalanceForTxFee = 55000 * 3 * 10 ** 9 wei; // == 55000 gas @ 3 gwei
214   // 800 FXX per ETH as the gas generation price
215   uint256 public sellPrice = 800; 
216   
217   event Refill(uint256 amount);
218   
219   modifier onlyAdmin() {
220     require(msg.sender == admin);
221     _;
222   }
223 
224   function FornicoinToken(address _admin) {
225     totalSupply = teamTokens;
226     balances[msg.sender] = MAX_SUPPLY;
227     admin =_admin;
228   }
229   
230   function setSellPrice(uint256 _price) public onlyAdmin {
231       require(_price >= 0);
232       // FXX can only become stronger
233       require(_price <= sellPrice);
234       
235       sellPrice = _price;
236   }
237   
238   // Update state of contract showing tokens bought
239   function updateTotalSupply(uint256 additions) onlyOwner {
240       require(totalSupply.add(additions) <= MAX_SUPPLY);
241       totalSupply += additions;
242   }
243   
244   function setMinTxFee(uint256 _balance) public onlyAdmin {
245       require(_balance >= 0);
246       // can only add more eth
247       require(_balance > minBalanceForTxFee);
248       
249       minBalanceForTxFee = _balance;
250   }
251   
252   function refillTxFeeMinimum() public payable onlyAdmin {
253       Refill(msg.value);
254   }
255   
256   // Transfers FXX tokens to another address
257   // Utilises transaction fee obfuscation
258   function transfer(address _to, uint _value) public returns (bool) {
259         // Prevent transfer to 0x0 address
260         require (_to != 0x0);
261         // Check for overflows 
262         require (balanceOf(_to) + _value > balanceOf(_to));
263         // Determine if account has necessary funding for another tx
264         if(msg.sender.balance < minBalanceForTxFee && 
265         balances[msg.sender].sub(_value) >= minBalanceForTxFee * sellPrice && 
266         this.balance >= minBalanceForTxFee){
267             sellFXX((minBalanceForTxFee.sub(msg.sender.balance)) *                                 
268                              sellPrice);
269     	        }
270         // Subtract from the sender
271         balances[msg.sender] = balances[msg.sender].sub(_value);
272         // Add the same to the recipient                   
273         balances[_to] = balances[_to].add(_value); 
274         // Send out Transfer event to notify all parties
275         Transfer(msg.sender, _to, _value);
276         return true;
277     }
278 
279     // Sells the amount of FXX to refill the senders ETH balance for another transaction
280     function sellFXX(uint amount) internal returns (uint revenue){
281         // checks if the sender has enough to sell
282         require(balanceOf(msg.sender) >= amount);  
283         // adds the amount to owner's balance       
284         balances[admin] = balances[admin].add(amount);          
285         // subtracts the amount from seller's balance              
286         balances[msg.sender] = balances[msg.sender].sub(amount);   
287         // Determines amount of ether to send to the seller 
288         revenue = amount / sellPrice;
289         msg.sender.transfer(revenue);
290         // executes an event reflecting on the change
291         Transfer(msg.sender, this, amount); 
292         // ends function and returns              
293         return revenue;                                   
294     }
295 }