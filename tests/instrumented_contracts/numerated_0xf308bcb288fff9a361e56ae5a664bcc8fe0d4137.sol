1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7  library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
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
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 contract ERC20Basic {
51   function totalSupply() public view returns (uint256);
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances.
60  */
61  contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   uint256 totalSupply_;
67 
68   /**
69   * @dev total number of tokens in existence
70   */
71   function totalSupply() public view returns (uint256) {
72     return totalSupply_;
73   }
74 
75   /**
76   * @dev transfer token for a specified address
77   * @param _to The address to transfer to.
78   * @param _value The amount to be transferred.
79   */
80   function transfer(address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balances[msg.sender]);
83 
84     balances[msg.sender] = balances[msg.sender].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     emit Transfer(msg.sender, _to, _value);
87     return true;
88   }
89 
90   /**
91   * @dev Gets the balance of the specified address.
92   * @param _owner The address to query the the balance of.
93   * @return An uint256 representing the amount owned by the passed address.
94   */
95   function balanceOf(address _owner) public view returns (uint256) {
96     return balances[_owner];
97   }
98 
99 }
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105  contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public view returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 contract Ownable {
113   address public owner;
114 
115 
116   event OwnershipRenounced(address indexed previousOwner);
117   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119 
120   /**
121    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
122    * account.
123    */
124    constructor() public {
125     owner = msg.sender;
126   }
127 
128   /**
129    * @dev Throws if called by any account other than the owner.
130    */
131    modifier onlyOwner() {
132     require(msg.sender == owner);
133     _;
134   }
135 
136   /**
137    * @dev Allows the current owner to transfer control of the contract to a newOwner.
138    * @param newOwner The address to transfer ownership to.
139    */
140    function transferOwnership(address newOwner) public onlyOwner {
141     require(newOwner != address(0));
142     emit OwnershipTransferred(owner, newOwner);
143     owner = newOwner;
144   }
145 
146   /**
147    * @dev Allows the current owner to relinquish control of the contract.
148    */
149    function renounceOwnership() public onlyOwner {
150     emit OwnershipRenounced(owner);
151     owner = address(0);
152   }
153 }
154 
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * @dev https://github.com/ethereum/EIPs/issues/20
160  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
161  */
162  contract StandardToken is ERC20, BasicToken {
163 
164   mapping (address => mapping (address => uint256)) internal allowed;
165 
166   /**
167    * @dev Transfer tokens from one address to another
168    * @param _from address The address which you want to send tokens from
169    * @param _to address The address which you want to transfer to
170    * @param _value uint256 the amount of tokens to be transferred
171    */
172    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
173     require(_to != address(0));
174     require(_value <= balances[_from]);
175     require(_value <= allowed[_from][msg.sender]);
176 
177     balances[_from] = balances[_from].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180     emit Transfer(_from, _to, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186    *
187    * Beware that changing an allowance with this method brings the risk that someone may use both the old
188    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    * @param _spender The address which will spend the funds.
192    * @param _value The amount of tokens to be spent.
193    */
194    function approve(address _spender, uint256 _value) public returns (bool) {
195     allowed[msg.sender][_spender] = _value;
196     emit Approval(msg.sender, _spender, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Function to check the amount of tokens that an owner allowed to a spender.
202    * @param _owner address The address which owns the funds.
203    * @param _spender address The address which will spend the funds.
204    * @return A uint256 specifying the amount of tokens still available for the spender.
205    */
206    function allowance(address _owner, address _spender) public view returns (uint256) {
207     return allowed[_owner][_spender];
208   }
209 
210   /**
211    * @dev Increase the amount of tokens that an owner allowed to a spender.
212    *
213    * approve should be called when allowed[_spender] == 0. To increment
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _addedValue The amount of tokens to increase the allowance by.
219    */
220    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
221     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226   /**
227    * @dev Decrease the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _subtractedValue The amount of tokens to decrease the allowance by.
235    */
236    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
237     uint oldValue = allowed[msg.sender][_spender];
238     if (_subtractedValue > oldValue) {
239       allowed[msg.sender][_spender] = 0;
240       } else {
241         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242       }
243       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244       return true;
245     }
246   }
247 
248   /**
249    * @title Mintable token
250    * @dev Simple ERC20 Token example, with mintable token creation
251    * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
252    * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
253    */
254    contract MintableToken is StandardToken, Ownable {
255     event Mint(address indexed to, uint256 amount);
256     event MintFinished();
257 
258     bool public mintingFinished = false;
259 
260 
261     modifier canMint() {
262       require(!mintingFinished);
263       _;
264     }
265 
266     modifier hasMintPermission() {
267       require(msg.sender == owner);
268       _;
269     }
270 
271     /**
272      * @dev Function to mint tokens
273      * @param _to The address that will receive the minted tokens.
274      * @param _amount The amount of tokens to mint.
275      * @return A boolean that indicates if the operation was successful.
276      */
277      function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {
278       totalSupply_ = totalSupply_.add(_amount);
279       balances[_to] = balances[_to].add(_amount);
280       emit Mint(_to, _amount);
281       emit Transfer(address(0), _to, _amount);
282       return true;
283     }
284 
285     /**
286      * @dev Function to stop minting new tokens.
287      * @return True if the operation was successful.
288      */
289      function finishMinting() onlyOwner canMint public returns (bool) {
290       mintingFinished = true;
291       emit MintFinished();
292       return true;
293     }
294   }
295 
296   contract InspiriumToken is MintableToken {
297     string public name = "INSPIRIUM";
298     string public symbol = "INSPIRIUM";
299     uint8 public decimals = 0;
300   }