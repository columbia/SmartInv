1 /************************************************************
2                 CR7Coin
3        Cristiano Ronaldo Immortalized on the blockhain.
4 **********************************************************/
5 
6 pragma solidity ^0.4.19;
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   /**
37   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60   address public owner;
61 
62 
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 /**
95  * @title ERC20Basic
96  * @dev Simpler version of ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/179
98  */
99 contract ERC20Basic {
100   function totalSupply() public view returns (uint256);
101   function balanceOf(address who) public view returns (uint256);
102   function transfer(address to, uint256 value) public returns (bool);
103   event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public view returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 /**
117  * @title Basic token
118  * @dev Basic version of StandardToken, with no allowances. 
119  */
120 contract BasicToken is ERC20Basic, Ownable {
121   using SafeMath for uint256;
122 
123   mapping(address => uint256) balances;
124 
125  uint256 totalSupply_;
126 
127   /**
128   * @dev total number of tokens in existence
129   */
130   function totalSupply() public view returns (uint256) {
131     return totalSupply_;
132   }
133 
134 
135   /**
136   * @dev transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140  function transfer(address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[msg.sender]);
143 
144     // SafeMath.sub will throw if there is not enough balance.
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     Transfer(msg.sender, _to, _value);
148     return true;
149   }
150 
151   /**
152   * @dev Gets the balance of the specified address.
153   * @param _owner The address to query the the balance of. 
154   * @return An uint256 representing the amount owned by the passed address.
155   */
156   function balanceOf(address _owner) public view returns (uint256 balance) {
157     return balances[_owner];
158   }
159 
160 }
161 
162 
163 /**
164  * @title Standard ERC20 token
165  *
166  * @dev Implementation of the basic standard token.
167  * @dev https://github.com/ethereum/EIPs/issues/20
168  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
169  */
170 contract StandardToken is ERC20, BasicToken {
171 
172   mapping (address => mapping (address => uint256)) internal allowed;
173 
174 
175   /**
176    * @dev Transfer tokens from one address to another
177    * @param _from address The address which you want to send tokens from
178    * @param _to address The address which you want to transfer to
179    * @param _value uint256 the amount of tokens to be transfered
180    */
181   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
182     require(_to != address(0));
183     require(_value <= balances[_from]);
184     require(_value <= allowed[_from][msg.sender]);
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    * @param _spender The address which will spend the funds.
196    * @param _value The amount of tokens to be spent.
197    */
198  function approve(address _spender, uint256 _value) public returns (bool) {
199     allowed[msg.sender][_spender] = _value;
200     Approval(msg.sender, _spender, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Function to check the amount of tokens that an owner allowed to a spender.
206    * @param _owner address The address which owns the funds.
207    * @param _spender address The address which will spend the funds.
208    * @return A uint256 specifying the amount of tokens still available for the spender.
209    */
210    function allowance(address _owner, address _spender) public view returns (uint256) {
211     return allowed[_owner][_spender];
212   }
213   
214  
215   
216   /**
217    * @dev Function to revert eth transfers to this contract
218     */
219     function() public payable {
220 	    revert();
221 	}
222 	
223 	
224    /**
225    * @dev  Owner can transfer out any accidentally sent ERC20 tokens
226    */
227  function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
228         return BasicToken(tokenAddress).transfer(owner, tokens);
229     }
230 	
231 
232    // ------------------------------------------------------------------------
233     // Token owner can approve for `spender` to transferFrom(...) `tokens`
234    // from the token owner's account. The `spender` contract function
235   // `receiveApproval(...)` is then executed
236    // ------------------------------------------------------------------------	
237 	
238  
239 	
240   /**
241     * @dev Transfer the specified amounts of tokens to the specified addresses.
242     * @dev Be aware that there is no check for duplicate recipients.
243     *
244     * @param _toAddresses Receiver addresses.
245     * @param _amounts Amounts of tokens that will be transferred.
246     */
247     function multiTransfer(address[] _toAddresses, uint256[] _amounts) public {
248         /* Ensures _toAddresses array is less than or equal to 255 */
249         require(_toAddresses.length <= 255);
250         /* Ensures _toAddress and _amounts have the same number of entries. */
251         require(_toAddresses.length == _amounts.length);
252 
253         for (uint8 i = 0; i < _toAddresses.length; i++) {
254             transfer(_toAddresses[i], _amounts[i]);
255         }
256     }
257 
258     /**
259     * @dev Transfer the specified amounts of tokens to the specified addresses from authorized balance of sender.
260     * @dev Be aware that there is no check for duplicate recipients.
261     *
262     * @param _from The address of the sender
263     * @param _toAddresses The addresses of the recipients (MAX 255)
264     * @param _amounts The amounts of tokens to be transferred
265     */
266     function multiTransferFrom(address _from, address[] _toAddresses, uint256[] _amounts) public {
267         /* Ensures _toAddresses array is less than or equal to 255 */
268         require(_toAddresses.length <= 255);
269         /* Ensures _toAddress and _amounts have the same number of entries. */
270         require(_toAddresses.length == _amounts.length);
271 
272         for (uint8 i = 0; i < _toAddresses.length; i++) {
273             transferFrom(_from, _toAddresses[i], _amounts[i]);
274         }
275     }
276 	
277 	
278  /** 
279 	 * @dev The following variables are OPTIONAL vanities. 
280 	 */
281     string public constant number = "7";   
282 	string public constant fullname = "Cristiano Ronaldo dos Santos Aveiro";
283 	string public constant born = "5th February, 1985";
284 	string public constant country = "Portugal";	
285 	
286 }
287 
288  
289 contract CR7Coin is StandardToken {
290 
291   string public constant name = "CR7Coin";
292   string public constant symbol = "CR7";
293   uint8 public constant decimals = 18; 
294 
295   uint256 public constant INITIAL_SUPPLY = 7000000 * (10 ** uint256(decimals));
296 
297   
298   function CR7Coin() public {
299     totalSupply_ = INITIAL_SUPPLY;
300     balances[msg.sender] = INITIAL_SUPPLY;
301     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
302   }
303 
304 }