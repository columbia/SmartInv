1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner {
66     if (newOwner != address(0)) {
67       owner = newOwner;
68     }
69   }
70 }
71 
72 
73 /**
74  * @title Pausable
75  * @dev Base contract which allows children to implement an emergency stop mechanism.
76  */
77 contract Pausable is Ownable {
78   event Pause();
79   event Unpause();
80 
81   bool public paused = false;
82 
83 
84   /**
85    * @dev modifier to allow actions only when the contract IS paused
86    */
87   modifier whenNotPaused() {
88     require(!paused);
89     _;
90   }
91 
92   /**
93    * @dev modifier to allow actions only when the contract IS NOT paused
94    */
95   modifier whenPaused {
96     require(paused);
97     _;
98   }
99 
100   /**
101    * @dev called by the owner to pause, triggers stopped state
102    */
103   function pause() onlyOwner whenNotPaused returns (bool) {
104     paused = true;
105     Pause();
106     return true;
107   }
108 
109   /**
110    * @dev called by the owner to unpause, returns to normal state
111    */
112   function unpause() onlyOwner whenPaused returns (bool) {
113     paused = false;
114     Unpause();
115     return true;
116   }
117 }
118 
119 
120 /**
121  * @title ERC20Basic
122  * @dev Simpler version of ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/179
124  */
125 contract ERC20Basic {
126   uint256 public totalSupply;
127   function balanceOf(address who) constant returns (uint256);
128   function transfer(address to, uint256 value) returns (bool);
129   event Transfer(address indexed from, address indexed to, uint256 value);
130 }
131 
132 
133 /**
134  * @title ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/20
136  */
137 contract ERC20 is ERC20Basic {
138   function allowance(address owner, address spender) constant returns (uint256);
139   function transferFrom(address from, address to, uint256 value) returns (bool);
140   function approve(address spender, uint256 value) returns (bool);
141   event Approval(address indexed owner, address indexed spender, uint256 value);
142 }
143 
144 
145 /**
146  * @title Basic token
147  * @dev Basic version of StandardToken, with no allowances.
148  */
149 contract BasicToken is ERC20Basic {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) balances;
153 
154   /**
155   * @dev transfer token for a specified address
156   * @param _to The address to transfer to.
157   * @param _value The amount to be transferred.
158   */
159   function transfer(address _to, uint256 _value) returns (bool) {
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     Transfer(msg.sender, _to, _value);
163     return true;
164   }
165 
166   /**
167   * @dev Gets the balance of the specified address.
168   * @param _owner The address to query the the balance of.
169   * @return An uint256 representing the amount owned by the passed address.
170   */
171   function balanceOf(address _owner) constant returns (uint256 balance) {
172     return balances[_owner];
173   }
174 
175 }
176 
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * @dev https://github.com/ethereum/EIPs/issues/20
183  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicToken {
186 
187   mapping (address => mapping (address => uint256)) allowed;
188 
189 
190   /**
191    * @dev Transfer tokens from one address to another
192    * @param _from address The address which you want to send tokens from
193    * @param _to address The address which you want to transfer to
194    * @param _value uint256 the amout of tokens to be transfered
195    */
196   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
197     var _allowance = allowed[_from][msg.sender];
198 
199     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
200     // require (_value <= _allowance);
201 
202     balances[_to] = balances[_to].add(_value);
203     balances[_from] = balances[_from].sub(_value);
204     allowed[_from][msg.sender] = _allowance.sub(_value);
205     Transfer(_from, _to, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) returns (bool) {
215 
216     // To change the approve amount you first have to reduce the addresses`
217     //  allowance to zero by calling `approve(_spender, 0)` if it is not
218     //  already 0 to mitigate the race condition described here:
219     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
221 
222     allowed[msg.sender][_spender] = _value;
223     Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifing the amount of tokens still avaible for the spender.
232    */
233   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
234     return allowed[_owner][_spender];
235   }
236 
237 }
238 
239 
240 /**
241  * Pausable token
242  *
243  * Simple ERC20 Token example, with pausable token creation
244  **/
245 contract PausableToken is StandardToken, Pausable {
246 
247   function transfer(address _to, uint _value) whenNotPaused returns (bool) {
248     return super.transfer(_to, _value);
249   }
250 
251   function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
252     return super.transferFrom(_from, _to, _value);
253   }
254 }
255 
256 
257 // @title The PallyCoin
258 /// @author Manoj Patidar
259 contract PallyCoin is PausableToken {
260    using SafeMath for uint256;
261 
262    string public constant name = 'PallyCoin';
263 
264    string public constant symbol = 'PAL';
265 
266    uint8 public constant decimals = 18;
267 
268    uint256 public  totalSupply = 100e24; // 100M tokens with 18 decimals
269 
270    bool public remainingTokenBurnt = false;
271 
272    // The tokens already used for the presale buyers
273    uint256 public tokensDistributedPresale = 0;
274 
275    // The tokens already used for the ICO buyers
276    uint256 public tokensDistributedCrowdsale = 0;
277 
278    // The address of the crowdsale
279    address public crowdsale;
280 
281    // The initial supply used for platform and development as specified in the whitepaper
282    uint256 public initialSupply = 40e24;
283 
284    // The maximum amount of tokens for the presale investors
285    uint256 public limitPresale = 10e24;
286 
287    // The maximum amount of tokens sold in the crowdsale
288    uint256 public limitCrowdsale = 50e24;
289 
290    /// @notice Only allows the execution of the function if it's comming from crowdsale
291    modifier onlyCrowdsale() {
292       require(msg.sender == crowdsale);
293       _;
294    }
295 
296    // When someone refunds tokens
297    event RefundedTokens(address indexed user, uint256 tokens);
298 
299    /// @notice Constructor used to set the platform & development tokens. This is
300    /// The 20% + 20% of the 100 M tokens used for platform and development team.
301    /// The owner, msg.sender, is able to do allowance for other contracts. Remember
302    /// to use `transferFrom()` if you're allowed
303    function PallyCoin() {
304       balances[msg.sender] = initialSupply; // 40M tokens wei
305    }
306 
307    /// @notice Function to set the crowdsale smart contract's address only by the owner of this token
308    /// @param _crowdsale The address that will be used
309    function setCrowdsaleAddress(address _crowdsale) external onlyOwner whenNotPaused {
310       require(_crowdsale != address(0));
311 
312       crowdsale = _crowdsale;
313    }
314 
315    /// @notice Distributes the presale tokens. Only the owner can do this
316    /// @param _buyer The address of the buyer
317    /// @param tokens The amount of tokens corresponding to that buyer
318    function distributePresaleTokens(address _buyer, uint tokens) external onlyOwner whenNotPaused {
319       require(_buyer != address(0));
320       require(tokens > 0 && tokens <= limitPresale);
321 
322       // Check that the limit of 10M presale tokens hasn't been met yet
323       require(tokensDistributedPresale < limitPresale);
324       require(tokensDistributedPresale.add(tokens) < limitPresale);
325 
326       tokensDistributedPresale = tokensDistributedPresale.add(tokens);
327       balances[_buyer] = balances[_buyer].add(tokens);
328    }
329 
330    /// @notice Distributes the ICO tokens. Only the crowdsale address can execute this
331    /// @param _buyer The buyer address
332    /// @param tokens The amount of tokens to send to that address
333    function distributeICOTokens(address _buyer, uint tokens) external onlyCrowdsale whenNotPaused {
334       require(_buyer != address(0));
335       require(tokens > 0);
336 
337       // Check that the limit of 50M ICO tokens hasn't been met yet
338       require(tokensDistributedCrowdsale < limitCrowdsale);
339       require(tokensDistributedCrowdsale.add(tokens) <= limitCrowdsale);
340 
341       tokensDistributedCrowdsale = tokensDistributedCrowdsale.add(tokens);
342       balances[_buyer] = balances[_buyer].add(tokens);
343    }
344 
345    /// @notice Deletes the amount of tokens refunded from that buyer balance
346    /// @param _buyer The buyer that wants the refund
347    /// @param tokens The tokens to return
348    function refundTokens(address _buyer, uint256 tokens) external onlyCrowdsale whenNotPaused {
349       require(_buyer != address(0));
350       require(tokens > 0);
351       require(balances[_buyer] >= tokens);
352 
353       balances[_buyer] = balances[_buyer].sub(tokens);
354       RefundedTokens(_buyer, tokens);
355    }
356 
357    /// @notice Burn the amount of tokens remaining after ICO ends
358    function burnTokens() external onlyCrowdsale whenNotPaused {
359       
360       uint256 remainingICOToken = limitCrowdsale.sub(tokensDistributedCrowdsale);
361       if(remainingICOToken > 0 && !remainingTokenBurnt) {
362       remainingTokenBurnt = true;    
363       limitCrowdsale = limitCrowdsale.sub(remainingICOToken);  
364       totalSupply = totalSupply.sub(remainingICOToken);
365       }
366    }
367 }