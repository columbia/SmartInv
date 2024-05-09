1 pragma solidity 0.4.23;
2 
3 /**
4  * Helios token http://heliosprotocol.io
5  * 
6  */
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
17   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18     if (a == 0) {
19       return 0;
20     }
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 
56 
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64   address public owner;
65   address public newOwnerTemp;
66 
67   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     require(newOwner != address(0));
91     newOwnerTemp = newOwner;
92   }
93   
94   function acceptOwnership() public {
95         require(msg.sender == newOwnerTemp);
96         emit OwnershipTransferred(owner, newOwnerTemp);
97         owner = newOwnerTemp;
98         newOwnerTemp = address(0x0);
99     }
100 
101 }
102 
103 
104 /**
105  * @title ERC20Basic
106  * @dev Simpler version of ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/179
108  */
109 contract ERC20Basic {
110   function totalSupply() public view returns (uint256);
111   function balanceOf(address who) public view returns (uint256);
112   function transfer(address to, uint256 value) public returns (bool);
113   event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 
117 /**
118  * @title Basic token
119  * @dev Basic version of StandardToken, with no allowances.
120  */
121 contract BasicToken is ERC20Basic {
122   using SafeMath for uint256;
123 
124   mapping(address => uint256) balances;
125 
126   uint256 totalSupply_;
127 
128   /**
129   * @dev total number of tokens in existence
130   */
131   function totalSupply() public view returns (uint256) {
132     return totalSupply_;
133   }
134 
135   /**
136   * @dev transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[msg.sender]);
143 
144     balances[msg.sender] = balances[msg.sender].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     emit Transfer(msg.sender, _to, _value);
147     return true;
148   }
149 
150   /**
151   * @dev Gets the balance of the specified address.
152   * @param _owner The address to query the the balance of.
153   * @return An uint256 representing the amount owned by the passed address.
154   */
155   function balanceOf(address _owner) public view returns (uint256) {
156     return balances[_owner];
157   }
158 
159 }
160 
161 
162 /**
163  * @title ERC20 interface
164  * @dev see https://github.com/ethereum/EIPs/issues/20
165  */
166 contract ERC20 is ERC20Basic {
167   function allowance(address owner, address spender) public view returns (uint256);
168   function transferFrom(address from, address to, uint256 value) public returns (bool);
169   function approve(address spender, uint256 value) public returns (bool);
170   event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 
174 /**
175  * @title Standard ERC20 token
176  *
177  * @dev Implementation of the basic standard token.
178  * @dev https://github.com/ethereum/EIPs/issues/20
179  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
180  */
181 contract StandardToken is ERC20, BasicToken {
182 
183   mapping (address => mapping (address => uint256)) internal allowed;
184 
185 
186   /**
187    * @dev Transfer tokens from one address to another
188    * @param _from address The address which you want to send tokens from
189    * @param _to address The address which you want to transfer to
190    * @param _value uint256 the amount of tokens to be transferred
191    */
192   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
193     require(_to != address(0));
194     require(_value <= balances[_from]);
195     require(_value <= allowed[_from][msg.sender]);
196 
197     balances[_from] = balances[_from].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200     emit Transfer(_from, _to, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206    *
207    * Beware that changing an allowance with this method brings the risk that someone may use both the old
208    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) public returns (bool) {
215     allowed[msg.sender][_spender] = _value;
216     emit Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Function to check the amount of tokens that an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint256 specifying the amount of tokens still available for the spender.
225    */
226   function allowance(address _owner, address _spender) public view returns (uint256) {
227     return allowed[_owner][_spender];
228   }
229 
230   /**
231    * @dev Increase the amount of tokens that an owner allowed to a spender.
232    *
233    * approve should be called when allowed[_spender] == 0. To increment
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param _spender The address which will spend the funds.
238    * @param _addedValue The amount of tokens to increase the allowance by.
239    */
240   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
241     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
242     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246   /**
247    * @dev Decrease the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
257     uint oldValue = allowed[msg.sender][_spender];
258     if (_subtractedValue > oldValue) {
259       allowed[msg.sender][_spender] = 0;
260     } else {
261       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
262     }
263     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267 }
268 
269 // ----------------------------------------------------------------------------
270 // ERC20 Token, with the addition of symbol, name and decimals and assisted
271 // token transfers
272 // ----------------------------------------------------------------------------
273 contract HeliosToken is StandardToken, Ownable {
274 	/*
275     NOTE:
276     The following variables are OPTIONAL vanities. One does not have to include them.
277     They allow one to customize the token contract & in no way influences the core functionality.
278     Some wallets/interfaces might not even bother to look at this information.
279     */
280     string  public constant name = "Helios Token";
281     string  public constant symbol = "HLS";
282     uint8   public constant decimals = 18;
283 	
284 	uint256 public constant INITIAL_SUPPLY = 300000000 * (10 ** uint256(decimals));
285 	uint256 public constant YEAR_TWO_SUPPLY = 30000000 * (10 ** uint256(decimals));
286 	uint256 public constant YEAR_THREE_SUPPLY = 20000000 * (10 ** uint256(decimals));
287 	
288 	bool public yearTwoClaimed;
289 	bool public yearThreeClaimed;
290 	
291 	//March 1, 2018
292 	uint256 public startTime = 1519862400;
293 
294 
295     // ------------------------------------------------------------------------
296     // Constructor
297     // ------------------------------------------------------------------------
298     constructor() public {
299         yearTwoClaimed = false;
300 		yearThreeClaimed = false;
301 		
302         totalSupply_ = INITIAL_SUPPLY + YEAR_TWO_SUPPLY + YEAR_THREE_SUPPLY;
303         
304 		//send 1st year team tokens, exchange tokens, incubator tokens
305 		balances[owner] = INITIAL_SUPPLY;
306 		emit Transfer(0x0, owner, INITIAL_SUPPLY);
307 		
308     }
309 
310 	// ------------------------------------------------------------------------
311     // Team can claim their tokens after lock up period
312     // ------------------------------------------------------------------------
313 	function teamClaim(uint256 year) public onlyOwner returns (bool success) {
314 		if(year == 2)
315 		{
316 			require (block.timestamp > (startTime + 31536000)  && yearTwoClaimed == false);
317 			balances[owner] = balances[owner].add(YEAR_TWO_SUPPLY);
318 			emit Transfer(0x0, owner, YEAR_TWO_SUPPLY);
319 			yearTwoClaimed = true;
320 		}
321 		if(year == 3)
322 		{
323 			require (block.timestamp > (startTime + 63072000) && yearThreeClaimed == false);
324 			balances[owner] = balances[owner].add(YEAR_THREE_SUPPLY);
325 			emit Transfer(0x0, owner, YEAR_THREE_SUPPLY);
326 			yearThreeClaimed = true;
327 		}
328 		return true;
329 	}
330 	
331 
332     // do not allow deposits
333     function() public{
334         revert();
335     }
336 
337 }