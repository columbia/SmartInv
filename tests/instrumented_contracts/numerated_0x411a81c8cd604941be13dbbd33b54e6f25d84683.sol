1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.18;
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  */
43 contract ERC20Basic {
44   uint256 public totalSupply;
45   function balanceOf(address who) public view returns (uint256);
46   function transfer(address to, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 /**
51  * @title Basic token
52  * @dev Basic version of StandardToken, with no allowances.
53  */
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58 
59   /**
60   * @dev transfer token for a specified address
61   * @param _to The address to transfer to.
62   * @param _value The amount to be transferred.
63   */
64   function transfer(address _to, uint256 _value) public returns (bool) {
65     require(_to != address(0));
66     require(_value <= balances[msg.sender]);
67 
68     // SafeMath.sub will throw if there is not enough balance.
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of.
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) public view returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 /**
87  * @title Burnable Token
88  * @dev Token that can be irreversibly burned (destroyed).
89  */
90 contract BurnableToken is BasicToken {
91 
92     event Burn(address indexed burner, uint256 value);
93 
94     /**
95      * @dev Burns a specific amount of tokens.
96      * @param _value The amount of token to be burned.
97      */
98     function burn(uint256 _value) public {
99         require(_value <= balances[msg.sender]);
100         // no need to require value <= totalSupply, since that would imply the
101         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
102 
103         address burner = msg.sender;
104         balances[burner] = balances[burner].sub(_value);
105         totalSupply = totalSupply.sub(_value);
106         Burn(burner, _value);
107     }
108 }
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) public view returns (uint256);
116   function transferFrom(address from, address to, uint256 value) public returns (bool);
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129 
130   mapping (address => mapping (address => uint256)) internal allowed;
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143 
144     balances[_from] = balances[_from].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    *
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) public returns (bool) {
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(address _owner, address _spender) public view returns (uint256) {
174     return allowed[_owner][_spender];
175   }
176 
177   /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   /**
194    * @dev Decrease the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To decrement
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _subtractedValue The amount of tokens to decrease the allowance by.
202    */
203   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
204     uint oldValue = allowed[msg.sender][_spender];
205     if (_subtractedValue > oldValue) {
206       allowed[msg.sender][_spender] = 0;
207     } else {
208       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209     }
210     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214 }
215 
216 /**
217  * @title SchedulableToken
218  * @dev The SchedulableToken provide a method to create tokens progressively, in a gradual
219  * and programed way, until a specified date and amount. To effectively create tokens, it
220  * is necessary for someone to periodically run the release() function in the contract.
221  * For example: You want to create a total of 1000 tokens (maxSupply) spread over 2 years (duration).
222  * In this way, when calling the release() function, the number of tokens that are entitled at
223  * that moment will be added to the beneficiary's wallet. In this scenario, by running the
224  * release() function every day at the same time over 2 years, the beneficiary will receive
225  * 1.37 tokens (1000 / 364.25 * 2) everyday.
226  * @author Anselmo Zago (anselmo@letsfair.org), based in TokenVesting by Zeppelin Solidity library.
227  */
228 contract SchedulableToken is StandardToken, BurnableToken {
229   using SafeMath for uint256;
230 
231   event Released(uint256 amount);
232 
233   address public beneficiary;
234   uint256 public maxSupply;
235   uint256 public start;
236   uint256 public duration;
237 
238   /**
239    * @dev Constructor of the SchedulableToken contract that releases the tokens gradually and
240    * programmatically. The balance will be assigned to _beneficiary in the maximum amount of
241    * _maxSupply, divided proportionally during the _duration period.
242    * @param _beneficiary address of the beneficiary to whom schedulable tokens will be added
243    * @param _maxSupply schedulable token max supply
244    * @param _duration duration in seconds of the period in which the tokens will released
245    */
246   function SchedulableToken(address _beneficiary, uint256 _maxSupply, uint256 _duration) public {
247     require(_beneficiary != address(0));
248     require(_maxSupply > 0);
249     require(_duration > 0);
250 
251     beneficiary = _beneficiary;
252     maxSupply = _maxSupply;
253     duration = _duration;
254     start = now;
255   }
256 
257   /**
258    * @notice Transfers schedulable tokens to beneficiary.
259    */
260   function release() public {
261     uint256 amount = calculateAmountToRelease();
262     require(amount > 0);
263 
264     balances[beneficiary] = balances[beneficiary].add(amount);
265     totalSupply = totalSupply.add(amount);
266 
267     Released(amount);
268   }
269 
270   /**
271    * @dev Calculates the amount of tokens by right, until that moment.
272    */
273   function calculateAmountToRelease() public view returns (uint256) {
274     if (now < start.add(duration)) {
275       return maxSupply.mul(now.sub(start)).div(duration).sub(totalSupply);
276     } else {
277       return schedulableAmount();
278     }
279   }
280 
281   /**
282    * @dev Returns the total amount that still to be released by the end of the duration.
283    */
284   function schedulableAmount() public view returns (uint256) {
285     return maxSupply.sub(totalSupply);
286   }
287 
288   /**
289   * @dev Overridden the BurnableToken burn() function to also correct maxSupply.
290   * @param _value The amount of token to be burned.
291   */
292   function burn(uint256 _value) public {
293     super.burn(_value);
294     maxSupply = maxSupply.sub(_value);
295   }
296 }
297 
298 /**
299  * @title Letsfair Token (LTF)
300  * @dev LetsfairToken contract implements the ERC20 with the StandardToken functions.
301  * The token's creation is realize in a gradual and programmatic way, distributed
302  * proportionally over a predefined period, specified by SchedulableToken.
303  * @author Anselmo Zago (anselmo@letsfair.org)
304  */
305  contract LetsfairToken is SchedulableToken {
306 
307   string public constant name = "Letsfair";
308   string public constant symbol = "LTF";
309   uint8 public constant decimals = 18;
310 
311   address _beneficiary = 0xe0F158B382F30A1eccecb5B67B1cf7EB92B5f1E4;
312   uint256 _maxSupply = 10 ** 27; // 1 billion with decimals
313   uint256 _duration = 157788000; // ~5 years in seconds
314 
315   function LetsfairToken() SchedulableToken(_beneficiary, _maxSupply, _duration) public {}
316 }