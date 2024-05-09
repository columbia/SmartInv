1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10      * @dev Multiplies two numbers, throws on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two numbers, truncating the quotient.
27      */
28     function div(uint256 a, uint256 b) internal pure returns(uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37      */
38     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44      * @dev Adds two numbers, throws on overflow.
45      */
46     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 /**
54  * @title SafeERC20
55  * @dev Wrappers around ERC20 operations that throw on failure.
56  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
57  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
58  */
59 library SafeERC20 {
60     function safeTransfer(ERC20 token, address to, uint256 value) internal {
61         require(token.transfer(to, value));
62     }
63 }
64 
65 /**
66  * @title Oraclize contract interface (returns uint256 USD)
67  */
68 contract OraclizeInterface {
69   function getEthPrice() public view returns (uint256);
70 }
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 {
77   function totalSupply() public view returns (uint256);
78 
79   function balanceOf(address _who) public view returns (uint256);
80 
81   function allowance(address _owner, address _spender)
82     public view returns (uint256);
83 
84   function transfer(address _to, uint256 _value) public returns (bool);
85 
86   function approve(address _spender, uint256 _value)
87     public returns (bool);
88 
89   function transferFrom(address _from, address _to, uint256 _value)
90     public returns (bool);
91 
92   event Transfer(
93     address indexed from,
94     address indexed to,
95     uint256 value
96   );
97 
98   event Approval(
99     address indexed owner,
100     address indexed spender,
101     uint256 value
102   );
103 }
104 
105 /**
106  * @title Standard ERC20 token
107  *
108  * @dev Implementation of the basic standard token.
109  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
110  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111  */
112 contract StandardToken is ERC20 {
113   using SafeMath for uint256;
114 
115   mapping (address => uint256) private balances;
116 
117   mapping (address => mapping (address => uint256)) private allowed;
118 
119   uint256 private totalSupply_;
120 
121   /**
122   * @dev Total number of tokens in existence
123   */
124   function totalSupply() public view returns (uint256) {
125     return totalSupply_;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256) {
134     return balances[_owner];
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifying the amount of tokens still available for the spender.
142    */
143   function allowance( address _owner, address _spender ) public view returns (uint256) {
144     return allowed[_owner][_spender];
145   }
146 
147   /**
148   * @dev Transfer token for a specified address
149   * @param _to The address to transfer to.
150   * @param _value The amount to be transferred.
151   */
152   function transfer(address _to, uint256 _value) public returns (bool) {
153     require(_value <= balances[msg.sender]);
154     require(_to != address(0));
155 
156     balances[msg.sender] = balances[msg.sender].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     emit Transfer(msg.sender, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    * Beware that changing an allowance with this method brings the risk that someone may use both the old
165    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168    * @param _spender The address which will spend the funds.
169    * @param _value The amount of tokens to be spent.
170    */
171   function approve(address _spender, uint256 _value) public returns (bool) {
172     allowed[msg.sender][_spender] = _value;
173     emit Approval(msg.sender, _spender, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Transfer tokens from one address to another
179    * @param _from address The address which you want to send tokens from
180    * @param _to address The address which you want to transfer to
181    * @param _value uint256 the amount of tokens to be transferred
182    */
183   function transferFrom( address _from, address _to, uint256 _value ) public returns (bool) {
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186     require(_to != address(0));
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     emit Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    * approve should be called when allowed[_spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _addedValue The amount of tokens to increase the allowance by.
203    */
204   function increaseApproval( address _spender, uint256 _addedValue ) public returns (bool) {
205     allowed[msg.sender][_spender] = (
206       allowed[msg.sender][_spender].add(_addedValue));
207     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211   /**
212    * @dev Decrease the amount of tokens that an owner allowed to a spender.
213    * approve should be called when allowed[_spender] == 0. To decrement
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _subtractedValue The amount of tokens to decrease the allowance by.
219    */
220   function decreaseApproval( address _spender, uint256 _subtractedValue ) public returns (bool) {
221     uint256 oldValue = allowed[msg.sender][_spender];
222     if (_subtractedValue >= oldValue) {
223       allowed[msg.sender][_spender] = 0;
224     } else {
225       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
226     }
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Internal function that mints an amount of the token and assigns it to
233    * an account. This encapsulates the modification of balances such that the
234    * proper events are emitted.
235    * @param _account The account that will receive the created tokens.
236    * @param _amount The amount that will be created.
237    */
238   function _mint(address _account, uint256 _amount) internal {
239     require(_account != 0);
240     totalSupply_ = totalSupply_.add(_amount);
241     balances[_account] = balances[_account].add(_amount);
242     emit Transfer(address(0), _account, _amount);
243   }
244 
245   /**
246    * @dev Internal function that burns an amount of the token of a given
247    * account.
248    * @param _account The account whose tokens will be burnt.
249    * @param _amount The amount that will be burnt.
250    */
251   function _burn(address _account, uint256 _amount) internal {
252     require(_account != 0);
253     require(_amount <= balances[_account]);
254 
255     totalSupply_ = totalSupply_.sub(_amount);
256     balances[_account] = balances[_account].sub(_amount);
257     emit Transfer(_account, address(0), _amount);
258   }
259 
260   /**
261    * @dev Internal function that burns an amount of the token of a given
262    * account, deducting from the sender's allowance for said account. Uses the
263    * internal _burn function.
264    * @param _account The account whose tokens will be burnt.
265    * @param _amount The amount that will be burnt.
266    */
267   function _burnFrom(address _account, uint256 _amount) internal {
268     require(_amount <= allowed[_account][msg.sender]);
269 
270     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
271     // this function needs to emit an event with the updated approval.
272     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
273     _burn(_account, _amount);
274   }
275 }
276 
277 /**
278  * @title Burnable Token
279  * @dev Token that can be irreversibly burned (destroyed).
280  */
281 contract BurnableToken is StandardToken {
282 
283   event Burn(address indexed burner, uint256 value);
284 
285   /**
286    * @dev Burns a specific amount of tokens.
287    * @param _value The amount of token to be burned.
288    */
289   function burn(uint256 _value) public {
290     _burn(msg.sender, _value);
291   }
292 
293   /**
294    * @dev Burns a specific amount of tokens from the target address and decrements allowance
295    * @param _from address The address which you want to send tokens from
296    * @param _value uint256 The amount of token to be burned
297    */
298   function burnFrom(address _from, uint256 _value) public {
299     _burnFrom(_from, _value);
300   }
301 
302   /**
303    * @dev Overrides StandardToken._burn in order for burn and burnFrom to emit
304    * an additional Burn event.
305    */
306   function _burn(address _who, uint256 _value) internal {
307     super._burn(_who, _value);
308     emit Burn(_who, _value);
309   }
310 }
311 
312 /**
313  * @title EVOAIToken
314  */
315 contract EVOAIToken is BurnableToken {
316     string public constant name = "EVOAI";
317     string public constant symbol = "EVOT";
318     uint8 public constant decimals = 18;
319 
320     uint256 public constant INITIAL_SUPPLY = 10000000 * 1 ether; // Need to change
321 
322     /**
323      * @dev Constructor
324      */
325     constructor() public {
326         _mint(msg.sender, INITIAL_SUPPLY);
327     }
328 }