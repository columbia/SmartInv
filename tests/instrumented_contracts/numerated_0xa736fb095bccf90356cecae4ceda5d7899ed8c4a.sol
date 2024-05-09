1 pragma solidity ^0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 /**
48  * @title Basic token
49  * @dev Basic version of StandardToken, with no allowances.
50  */
51 contract BasicToken is ERC20Basic {
52   using SafeMath for uint256;
53 
54   mapping(address => uint256) balances;
55 
56   /**
57   * @dev transfer token for a specified address
58   * @param _to The address to transfer to.
59   * @param _value The amount to be transferred.
60   */
61   function transfer(address _to, uint256 _value) public returns (bool) {
62     require(_to != address(0));
63     require(_value <= balances[msg.sender]);
64 
65     // SafeMath.sub will throw if there is not enough balance.
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     Transfer(msg.sender, _to, _value);
69     return true;
70   }
71 
72   /**
73   * @dev Gets the balance of the specified address.
74   * @param _owner The address to query the the balance of.
75   * @return An uint256 representing the amount owned by the passed address.
76   */
77   function balanceOf(address _owner) public view returns (uint256 balance) {
78     return balances[_owner];
79   }
80 
81 }
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public view returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amount of tokens to be transferred
112    */
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    */
157   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
158     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
164     uint oldValue = allowed[msg.sender][_spender];
165     if (_subtractedValue > oldValue) {
166       allowed[msg.sender][_spender] = 0;
167     } else {
168       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169     }
170     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174 }
175 
176 
177 /**
178  * @title Ownable
179  * @dev The Ownable contract has an owner address, and provides basic authorization control
180  * functions, this simplifies the implementation of "user permissions".
181  */
182 contract Ownable {
183   address public owner;
184 
185 
186   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188 
189   /**
190    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191    * account.
192    */
193   function Ownable() public {
194     owner = msg.sender;
195   }
196 
197 
198   /**
199    * @dev Throws if called by any account other than the owner.
200    */
201   modifier onlyOwner() {
202     require(msg.sender == owner);
203     _;
204   }
205 
206 
207   /**
208    * @dev Allows the current owner to transfer control of the contract to a newOwner.
209    * @param newOwner The address to transfer ownership to.
210    */
211   function transferOwnership(address newOwner) public onlyOwner {
212     require(newOwner != address(0));
213     OwnershipTransferred(owner, newOwner);
214     owner = newOwner;
215   }
216 
217 }
218 
219 
220 /**
221  * @title RestrictedCaller
222  * @dev storage of callers who available to call some methods of contracts
223  */
224 contract RestrictedCaller is Ownable {
225 
226 	mapping(address => address) public callers;
227 
228 	event callerAdded(address caller);
229 
230 	/**
231 	* @dev Throws if called by any account other than the caller.
232 	*/
233 	modifier onlyAvailableCaller() {
234 		require(callers[msg.sender] != address(0));
235 		_;
236 	}
237 
238 	/**
239 	* @dev add new caller for call methods permissions.
240 	* @param _address The address to transfer permissions to call to.
241 	*/
242 	function callerAdd(address _address) public onlyOwner {
243 		require(_address != address(0));
244 		require(callers[_address] == address(0)); // no exists
245 		callers[_address] = _address;
246 	}
247 
248 	/**
249 	* @dev delete caller for call methods permissions.
250 	* @param _address The address to del caller.
251 	*/
252 	function callerDel(address _address) public onlyOwner {
253 		require(_address != address(0));
254 		require(callers[_address] == _address); // already exists
255 		delete callers[_address];
256 	}
257 }
258 
259 /**
260 * @title VICoin token
261 */
262 contract VICoin is StandardToken, RestrictedCaller {
263 
264 	string public constant name = "Virtonomics Token - VICoin";
265 	string public constant symbol = "VIC";
266 	uint8 public constant decimals = 18;
267 
268 	event Mint(address to, uint256 amount);
269 	event Burn(address at, uint256 value);
270 
271 	/**
272 	* @dev Function to mint tokens
273 	* @param _to The address that will receive the minted tokens.
274 	* @param _amount The amount of tokens to mint.
275 	* @return A boolean that indicates if the operation was successful.
276 	*/
277 	function mint(address _to, uint256 _amount) onlyAvailableCaller public returns (bool) {
278 		require(_to != address(0));
279 		require(_amount > 0);
280 		totalSupply = totalSupply.add(_amount);
281 		balances[_to] = balances[_to].add(_amount);
282 		Mint(_to, _amount);
283 		Transfer(msg.sender, _to, _amount);
284 		return true;
285 	}
286 
287 	/**
288 	* @dev Function to burn tokens
289 	* @param _at The address that will burned tokens.
290 	* @param _amount The amount of tokens to burn.
291 	* @return A boolean that indicates if the operation was successful.
292 	*/
293 	function burn(address _at, uint256 _amount) onlyAvailableCaller public returns (bool) {
294 		require(_at != address(0));
295 		require(_amount > 0);
296 		require(_amount <= balances[_at]);
297 		totalSupply = totalSupply.sub(_amount);
298 		balances[_at] = balances[_at].sub(_amount);
299 		Burn(_at, _amount);
300 		Transfer(_at, msg.sender, _amount);
301 		return true;
302 	}
303 }