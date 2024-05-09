1 pragma solidity ^0.4.16;
2 /**
3  * BMI Coin
4  *
5  * Invest into the future.
6  *
7  * BMI Coin is a ERC20 compatible token with the following properties:
8  *  - 3.000.000 coins max supply
9  *  - 1.500.000 coins mined for the company wallet
10  * 
11  * Visit https://www.bmi-coin.io for more information and tokenholder benefits. 
12  * 
13  * Copyright BMI JAPAN Ltd. All rights reserved.
14  */
15 /**
16  * @title ERC20Basic
17  * @dev Simpler version of ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/179
19  */
20 contract ERC20Basic {
21   function totalSupply() public view returns (uint256);
22   function balanceOf(address who) public view returns (uint256);
23   function transfer(address to, uint256 value) public returns (bool);
24   event Transfer(address indexed from, address indexed to, uint256 value);
25 }
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   /**
32   * @dev Multiplies two numbers, throws on overflow.
33   */
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     if (a == 0) {
36       return 0;
37     }
38     uint256 c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51   /**
52   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 a, uint256 b) internal pure returns (uint256) {
62     uint256 c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73   mapping(address => uint256) balances;
74   uint256 totalSupply_;
75   /**
76   * @dev total number of tokens in existence
77   */
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
93     return true;
94   }
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 }
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) public view returns (uint256);
110   function transferFrom(address from, address to, uint256 value) public returns (bool);
111   function approve(address spender, uint256 value) public returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * @dev https://github.com/ethereum/EIPs/issues/20
119  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
120  */
121 contract StandardToken is ERC20, BasicToken {
122   mapping (address => mapping (address => uint256)) internal allowed;
123   /**
124    * @dev Transfer tokens from one address to another
125    * @param _from address The address which you want to send tokens from
126    * @param _to address The address which you want to transfer to
127    * @param _value uint256 the amount of tokens to be transferred
128    */
129   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
130     require(_to != address(0));
131     require(_value <= balances[_from]);
132     require(_value <= allowed[_from][msg.sender]);
133     balances[_from] = balances[_from].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136     Transfer(_from, _to, _value);
137     return true;
138   }
139   /**
140    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141    *
142    * Beware that changing an allowance with this method brings the risk that someone may use both the old
143    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
144    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
145    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146    * @param _spender The address which will spend the funds.
147    * @param _value The amount of tokens to be spent.
148    */
149   function approve(address _spender, uint256 _value) public returns (bool) {
150     allowed[msg.sender][_spender] = _value;
151     Approval(msg.sender, _spender, _value);
152     return true;
153   }
154   /**
155    * @dev Function to check the amount of tokens that an owner allowed to a spender.
156    * @param _owner address The address which owns the funds.
157    * @param _spender address The address which will spend the funds.
158    * @return A uint256 specifying the amount of tokens still available for the spender.
159    */
160   function allowance(address _owner, address _spender) public view returns (uint256) {
161     return allowed[_owner][_spender];
162   }
163   /**
164    * @dev Increase the amount of tokens that an owner allowed to a spender.
165    *
166    * approve should be called when allowed[_spender] == 0. To increment
167    * allowed value is better to use this function to avoid 2 calls (and wait until
168    * the first transaction is mined)
169    * From MonolithDAO Token.sol
170    * @param _spender The address which will spend the funds.
171    * @param _addedValue The amount of tokens to increase the allowance by.
172    */
173   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
174     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
175     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176     return true;
177   }
178   /**
179    * @dev Decrease the amount of tokens that an owner allowed to a spender.
180    *
181    * approve should be called when allowed[_spender] == 0. To decrement
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    * @param _spender The address which will spend the funds.
186    * @param _subtractedValue The amount of tokens to decrease the allowance by.
187    */
188   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
189     uint oldValue = allowed[msg.sender][_spender];
190     if (_subtractedValue > oldValue) {
191       allowed[msg.sender][_spender] = 0;
192     } else {
193       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
194     }
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 }
199 /**
200  * @title Ownable
201  * @dev The Ownable contract has an owner address, and provides basic authorization control
202  * functions, this simplifies the implementation of "user permissions".
203  */
204 contract Ownable {
205   address public owner;
206   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207   /**
208    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
209    * account.
210    */
211   function Ownable() public {
212     owner = msg.sender;
213   }
214   /**
215    * @dev Throws if called by any account other than the owner.
216    */
217   modifier onlyOwner() {
218     require(msg.sender == owner);
219     _;
220   }
221   /**
222    * @dev Allows the current owner to transfer control of the contract to a newOwner.
223    * @param newOwner The address to transfer ownership to.
224    */
225   function transferOwnership(address newOwner) public onlyOwner {
226     require(newOwner != address(0));
227     OwnershipTransferred(owner, newOwner);
228     owner = newOwner;
229   }
230 }
231 contract BMICoin is StandardToken, Ownable {
232   string public constant name = "BMI Coin";
233   string public constant symbol = "BMI";
234   uint256 public constant decimals = 18;
235   uint256 public constant UNIT = 10 ** decimals;
236   address public companyWallet;
237   address public backendWallet;
238   uint256 public maxSupply = 3000000 * UNIT;
239   /**
240    * event for token purchase logging
241    * @param purchaser who paid for the tokens
242    * @param beneficiary who got the tokens
243    * @param value weis paid for purchase
244    * @param amount amount of tokens purchased
245    */
246   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
247   modifier onlyBackend() {
248     require(msg.sender == backendWallet);
249     _;
250   }
251   function BMICoin(address _companyWallet, address _backendWallet) public {
252     companyWallet = _companyWallet;
253     backendWallet = _backendWallet;
254     balances[companyWallet] = 1500000 * UNIT;
255     totalSupply_ = totalSupply_.add(1500000 * UNIT);
256     Transfer(address(0x0), _companyWallet, 1500000 * UNIT);
257   }
258   /**
259    * Change the backendWallet that is allowed to issue new tokens (used by server side)
260    * Or completely disabled backend unrevokable for all eternity by setting it to 0x0
261    */
262   function setBackendWallet(address _backendWallet) public onlyOwner {
263     require(backendWallet != address(0));
264     backendWallet = _backendWallet;
265   }
266   function() public payable {
267     revert();
268   }
269   /***
270    * This function is used to transfer tokens that have been bought through other means (credit card, bitcoin, etc), and to burn tokens after the sale.
271    */
272   function mint(address receiver, uint256 tokens) public onlyBackend {
273     require(totalSupply_ + tokens <= maxSupply);
274     balances[receiver] += tokens;
275     totalSupply_ += tokens;
276     Transfer(address(0x0), receiver, tokens);
277   }
278   function sendBonus(address receiver, uint256 bonus) public onlyBackend {
279     Transfer(companyWallet, receiver, bonus);
280     balances[companyWallet] = balances[companyWallet].sub(bonus);
281     balances[receiver] = balances[receiver].add(bonus);
282   }
283 }