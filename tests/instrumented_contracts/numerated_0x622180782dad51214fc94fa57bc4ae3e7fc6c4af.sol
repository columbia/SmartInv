1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
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
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public view returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 /**
112  * @title Basic token
113  * @dev Basic version of StandardToken, with no allowances. 
114  */
115 contract BasicToken is ERC20Basic, Ownable {
116   using SafeMath for uint256;
117 
118   mapping(address => uint256) balances;
119 
120  uint256 totalSupply_;
121 
122   /**
123   * @dev total number of tokens in existence
124   */
125   function totalSupply() public view returns (uint256) {
126     return totalSupply_;
127   }
128 
129 
130   /**
131   * @dev transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135  function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[msg.sender]);
138 
139     // SafeMath.sub will throw if there is not enough balance.
140     balances[msg.sender] = balances[msg.sender].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     Transfer(msg.sender, _to, _value);
143     return true;
144   }
145 
146   /**
147   * @dev Gets the balance of the specified address.
148   * @param _owner The address to query the the balance of. 
149   * @return An uint256 representing the amount owned by the passed address.
150   */
151   function balanceOf(address _owner) public view returns (uint256 balance) {
152     return balances[_owner];
153   }
154 
155 }
156 
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * @dev https://github.com/ethereum/EIPs/issues/20
163  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transfered
175    */
176   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177     require(_to != address(0));
178     require(_value <= balances[_from]);
179     require(_value <= allowed[_from][msg.sender]);
180 
181     balances[_from] = balances[_from].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184     Transfer(_from, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193  function approve(address _spender, uint256 _value) public returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205    function allowance(address _owner, address _spender) public view returns (uint256) {
206     return allowed[_owner][_spender];
207   }
208   
209  
210   
211   /**
212    * @dev Function to revert eth transfers to this contract
213     */
214     function() public payable {
215 	    revert();
216 	}
217 	
218 	
219    /**
220    * @dev  Owner can transfer out any accidentally sent ERC20 tokens
221    */
222  function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
223         return BasicToken(tokenAddress).transfer(owner, tokens);
224     }
225 	
226   /**
227     * @dev Transfer the specified amounts of tokens to the specified addresses.
228     * @dev Be aware that there is no check for duplicate recipients.
229     *
230     * @param _toAddresses Receiver addresses.
231     * @param _amounts Amounts of tokens that will be transferred.
232     */
233     function multiSend(address[] _toAddresses, uint256[] _amounts) public {
234         /* Ensures _toAddresses array is less than or equal to 255 */
235         require(_toAddresses.length <= 255);
236         /* Ensures _toAddress and _amounts have the same number of entries. */
237         require(_toAddresses.length == _amounts.length);
238 
239         for (uint8 i = 0; i < _toAddresses.length; i++) {
240             transfer(_toAddresses[i], _amounts[i]);
241         }
242     }
243 
244     /**
245     * @dev Transfer the specified amounts of tokens to the specified addresses from authorized balance of sender.
246     * @dev Be aware that there is no check for duplicate recipients.
247     *
248     * @param _from The address of the sender
249     * @param _toAddresses The addresses of the recipients (MAX 255)
250     * @param _amounts The amounts of tokens to be transferred
251     */
252     function multiSendFrom(address _from, address[] _toAddresses, uint256[] _amounts) public {
253         /* Ensures _toAddresses array is less than or equal to 255 */
254         require(_toAddresses.length <= 255);
255         /* Ensures _toAddress and _amounts have the same number of entries. */
256         require(_toAddresses.length == _amounts.length);
257 
258         for (uint8 i = 0; i < _toAddresses.length; i++) {
259             transferFrom(_from, _toAddresses[i], _amounts[i]);
260         }
261     }
262 	
263 }
264 
265 	
266  /**
267  * @title Burnable Token
268  * @dev Token that can be irreversibly burned (destroyed).
269  */
270 contract BurnableToken is BasicToken {
271 
272   event Burn(address indexed burner, uint256 value);
273 
274  
275    /**
276    * @dev Burns a specific amount of tokens.
277    * @param _value The amount of token to be burned.
278    */
279   function burn(uint256 _value) public onlyOwner {
280     require(_value <= balances[msg.sender]);
281     // no need to require value <= totalSupply, since that would imply the
282     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
283 
284     address burner = msg.sender;
285     balances[burner] = balances[burner].sub(_value);
286     totalSupply_ = totalSupply_.sub(_value);
287     Burn(burner, _value);
288     Transfer(burner, address(0), _value);
289   }
290   }
291 
292  
293 contract AlarmxToken is StandardToken, BurnableToken {
294 
295   string public constant name = "Alarmx Token";
296   string public constant symbol = "ALRMX";
297   uint8 public constant decimals = 18; 
298 
299   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
300 
301   
302   function AlarmxToken() public {
303     totalSupply_ = INITIAL_SUPPLY;
304     balances[msg.sender] = INITIAL_SUPPLY;
305     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
306   }
307 
308 }