1 pragma solidity ^0.4.22;
2 
3 // File: contracts/zeppelin/math/SafeMath.sol
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
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57 
58   address public owner;
59 
60   address public newOwner;
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   constructor() public {
75     owner = msg.sender;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param _newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address _newOwner) public onlyOwner {
83     require(_newOwner != address(0));
84     emit OwnershipTransferred(owner, _newOwner);
85     owner = _newOwner;
86   }
87   
88   event OwnershipTransferred(address oldOwner, address newOwner);
89 }
90 
91 contract FUNToken is Ownable { //ERC - 20 token contract
92   using SafeMath for uint;
93   // Triggered when tokens are transferred.
94   event Transfer(address indexed _from, address indexed _to, uint256 _value);
95 
96   // Triggered whenever approve(address _spender, uint256 _value) is called.
97   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
98 
99   string public constant symbol = "FUN"; // solium-disable-line uppercase
100   string public constant name = "THEFORTUNEFUND"; // solium-disable-line uppercase
101   uint8 public constant decimals = 18; // solium-disable-line uppercase
102   /** @dev maximum token supply
103   */
104   uint256 _totalSupply = 88888888 ether;
105 
106   // Balances for each account
107   mapping(address => uint256) balances;
108 
109   // Owner of account approves the transfer of an amount to another account
110   mapping(address => mapping (address => uint256)) allowed;
111 
112   /**
113   * @dev total number of tokens in existence
114   */
115   function totalSupply() public view returns (uint256) { //standart ERC-20 function
116     return _totalSupply;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public view returns (uint256 balance) {//standart ERC-20 function
125     return balances[_owner];
126   }
127   
128   // @dev is token transfer is locked
129   bool public locked = false;
130 
131   // @dev is token transfer can be changed
132   bool public canChangeLocked = true;
133 
134   /**
135   * @dev change lock transfer token ('locked')
136   * @param _request true or false
137   */
138   function changeLockTransfer (bool _request) public onlyOwner {
139     require(canChangeLocked);
140     locked = _request;
141   }
142 
143   /**
144   * @dev final unlock transfer token ('locked' and 'canChangeLocked')
145   * Makes for crypto exchangers to prevent the possibility of further blocking
146   */
147   function finalUnlockTransfer () public {
148     require (canChangeLocked);
149   
150     locked = false;
151     canChangeLocked = false;
152   }
153   
154   /**
155   * @dev transfer token for a specified address
156   * @param _to The address to transfer to.
157   * @param _amount The amount to be transferred.
158   */
159   function transfer(address _to, uint256 _amount) public returns (bool success) {
160     require(this != _to);
161     require (_to != address(0));
162     require(!locked);
163     balances[msg.sender] = balances[msg.sender].sub(_amount);
164     balances[_to] = balances[_to].add(_amount);
165     emit Transfer(msg.sender,_to,_amount);
166     return true;
167   }
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _amount uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _amount) public returns(bool success){
176     require(this != _to);
177     require (_to != address(0));
178     require(!locked);
179     balances[_from] = balances[_from].sub(_amount);
180     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
181     balances[_to] = balances[_to].add(_amount);
182     emit Transfer(_from,_to,_amount);
183     return true;
184   }
185   
186   /**
187    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188    *
189    * Beware that changing an allowance with this method brings the risk that someone may use both the old
190    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193    * @param _spender The address which will spend the funds.
194    * @param _amount The amount of tokens to be spent.
195    */
196   function approve(address _spender, uint256 _amount)public returns (bool success) { 
197     allowed[msg.sender][_spender] = _amount;
198     emit Approval(msg.sender, _spender, _amount);
199     return true;
200   }
201 
202   /**
203    * @dev Function to check the amount of tokens that an owner allowed to a spender.
204    * @param _owner address The address which owns the funds.
205    * @param _spender address The address which will spend the funds.
206    * @return A uint256 specifying the amount of tokens still available for the spender.
207    */
208   function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
209     return allowed[_owner][_spender];
210   }
211 
212   /**
213    * @dev Increase the amount of tokens that an owner allowed to a spender.
214    *
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _addedValue The amount of tokens to increase the allowance by.
221    */
222   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
239     uint oldValue = allowed[msg.sender][_spender];
240     if (_subtractedValue > oldValue) {
241       allowed[msg.sender][_spender] = 0;
242     } else {
243       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244     }
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   /** @dev Token cunstructor
250     */
251   constructor () public {
252     owner = 0x85BC7DC54c637Dd432e90B91FE803AaA7744E158;
253     tokenHolder = 0x85BC7DC54c637Dd432e90B91FE803AaA7744E158;
254     balances[tokenHolder] = _totalSupply;
255   }
256 
257   // @dev Address which contains all minted tokens
258   address public tokenHolder;
259 
260   // @dev Crowdsale contract address
261   address public crowdsaleContract;
262 
263   /**
264    * @dev setting 'crowdsaleContract' variable. Call automatically when crowdsale contract deployed 
265    * throws 'crowdsaleContract' already exists
266    */
267   function setCrowdsaleContract (address _address) public{
268     require(crowdsaleContract == address(0));
269 
270     crowdsaleContract = _address;
271   }
272 
273   //@dev How many tokens crowdsale contract has to sell
274   uint public crowdsaleBalance = 77333333 ether; //Tokens
275   
276   /**
277    * @dev gets `_address` and `_value` as input and sells tokens to '_address'
278    * throws if not enough tokens after calculation
279    */
280   function sendCrowdsaleTokens (address _address, uint _value) public {
281     require(msg.sender == crowdsaleContract);
282 
283     balances[tokenHolder] = balances[tokenHolder].sub(_value);
284     balances[_address] = balances[_address].add(_value);
285     
286     crowdsaleBalance = crowdsaleBalance.sub(_value);
287     
288     emit Transfer(tokenHolder,_address,_value);    
289   }
290 
291   /// @dev event when someone burn Tokens
292   event Burn(address indexed burner, uint tokens);
293 
294   /**
295    * @dev `_value` as input and burn tokens 
296    * throws if message sender has not enough tokens after calculation
297    */
298   function burnTokens (uint _value) external {
299     balances[msg.sender] = balances[msg.sender].sub(_value);
300 
301     _totalSupply = _totalSupply.sub(_value);
302 
303     emit Transfer(msg.sender, 0, _value);
304     emit Burn(msg.sender, _value);
305   } 
306 }