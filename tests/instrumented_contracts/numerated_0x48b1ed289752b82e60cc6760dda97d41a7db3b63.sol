1 pragma solidity ^0.4.25;
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
65   constructor() public {
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
83     emit OwnershipTransferred(owner, newOwner);
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
129   /**
130   * @dev transfer token for a specified address
131   * @param _to The address to transfer to.
132   * @param _value The amount to be transferred.
133   */
134  function transfer(address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[msg.sender]);
137 
138     // SafeMath.sub will throw if there is not enough balance.
139     balances[msg.sender] = balances[msg.sender].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     emit Transfer(msg.sender, _to, _value);
142     return true;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of. 
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256 balance) {
151     return balances[_owner];
152   }
153 
154 }
155 
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) internal allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transfered
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183     emit Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    * @param _spender The address which will spend the funds.
190    * @param _value The amount of tokens to be spent.
191    */
192  function approve(address _spender, uint256 _value) public returns (bool) {
193     allowed[msg.sender][_spender] = _value;
194     emit Approval(msg.sender, _spender, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Function to check the amount of tokens that an owner allowed to a spender.
200    * @param _owner address The address which owns the funds.
201    * @param _spender address The address which will spend the funds.
202    * @return A uint256 specifying the amount of tokens still available for the spender.
203    */
204    function allowance(address _owner, address _spender) public view returns (uint256) {
205     return allowed[_owner][_spender];
206   }
207   
208   /**
209    * @dev Function to revert eth transfers to this contract
210     */
211     function() public payable {
212 	    revert();
213 	}
214 	
215    /**
216    * @dev  Owner can transfer out any accidentally sent ERC20 tokens
217    */
218  function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
219         return BasicToken(tokenAddress).transfer(owner, tokens);
220     }
221 	
222   /**
223     * @dev Transfer the specified amounts of tokens to the specified addresses.
224     * @dev Be aware that there is no check for duplicate recipients.
225     *
226     * @param _toAddresses Receiver addresses.
227     * @param _amounts Amounts of tokens that will be transferred.
228     */
229     function multiSend(address[] _toAddresses, uint256[] _amounts) public {
230         /* Ensures _toAddresses array is less than or equal to 255 */
231         require(_toAddresses.length <= 255);
232         /* Ensures _toAddress and _amounts have the same number of entries. */
233         require(_toAddresses.length == _amounts.length);
234 
235         for (uint8 i = 0; i < _toAddresses.length; i++) {
236             transfer(_toAddresses[i], _amounts[i]);
237         }
238     }
239 
240     /**
241     * @dev Transfer the specified amounts of tokens to the specified addresses from authorized balance of sender.
242     * @dev Be aware that there is no check for duplicate recipients.
243     *
244     * @param _from The address of the sender
245     * @param _toAddresses The addresses of the recipients (MAX 255)
246     * @param _amounts The amounts of tokens to be transferred
247     */
248     function multiSendFrom(address _from, address[] _toAddresses, uint256[] _amounts) public {
249         /* Ensures _toAddresses array is less than or equal to 255 */
250         require(_toAddresses.length <= 255);
251         /* Ensures _toAddress and _amounts have the same number of entries. */
252         require(_toAddresses.length == _amounts.length);
253 
254         for (uint8 i = 0; i < _toAddresses.length; i++) {
255             transferFrom(_from, _toAddresses[i], _amounts[i]);
256         }
257     }
258 	
259 }
260 	
261  /**
262  * @title Burnable Token
263  * @dev Token that can be irreversibly burned (destroyed).
264  */
265 contract BurnableToken is BasicToken {
266 
267   event Burn(address indexed burner, uint256 value);
268  
269    /**
270    * @dev Burns a specific amount of tokens.
271    * @param _value The amount of token to be burned.
272    */
273   function burn(uint256 _value) public onlyOwner {
274     require(_value <= balances[msg.sender]);
275     // no need to require value <= totalSupply, since that would imply the
276     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
277 
278     address burner = msg.sender;
279     balances[burner] = balances[burner].sub(_value);
280     totalSupply_ = totalSupply_.sub(_value);
281     emit Burn(burner, _value);
282     emit Transfer(burner, address(0), _value);
283   }
284   }
285  
286 contract WFCCToken is StandardToken, BurnableToken {
287 
288   string public constant name = "Wells Fargo & Co - Digital Asset Common Token";
289   string public constant symbol = "WFCC"; 
290   uint8 public constant decimals = 18; 
291 
292   uint256 public constant INITIAL_SUPPLY = 500000000000 * (10 ** uint256(decimals));
293 
294     constructor() public {
295     totalSupply_ = INITIAL_SUPPLY;
296     balances[msg.sender] = INITIAL_SUPPLY;
297     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
298   }
299 }