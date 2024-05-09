1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     uint256 public totalSupply;
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13    
14 }
15 
16 /**
17  * @title Ownable
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract Ownable {
22     address public owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26   /**
27    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28    * account.
29    */
30     constructor() public  {
31         owner = msg.sender;
32     }
33 
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38     modifier onlyOwner() {
39         require(msg.sender == owner,"owner Must Eq Msg.sender");
40         _;
41     }
42 
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param newOwner The address to transfer ownership to.
47    */
48     function transferOwnership(address newOwner) public onlyOwner  {
49         require(newOwner != address(0),"newOwner Must Not Eq 0");
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52     }
53 
54 }
55 
56 
57 /**
58  * @title SafeMath
59  * @dev Math operations with safety checks that throw on error
60  */
61 library SafeMath {
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         if (a == 0) {
64             return 0;
65         }
66         uint256 c = a * b;
67         assert(c / a == b);
68         return c;
69     }
70 
71     function div(uint256 a, uint256 b) internal  pure returns (uint256) {
72         // assert(b > 0); // Solidity automatically throws when dividing by 0
73         uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75         return c;
76     }
77 
78     function sub(uint256 a, uint256 b) internal  pure returns (uint256) {
79         assert(b <= a);
80         return a - b;
81     }
82 
83     function add(uint256 a, uint256 b) internal  pure returns (uint256) {
84         uint256 c = a + b;
85         assert(c >= a);
86         return c;
87     }
88 }
89 
90 
91 
92 /**
93  * @title Basic token
94  * @dev Basic version of StandardToken, with no allowances.
95  */
96 contract BasicToken is ERC20Basic {
97     using SafeMath for uint256;
98     mapping(address => uint256) balances;
99 
100   /**
101   * @dev transfer token for a specified address
102   * @param _to The address to transfer to.
103   * @param _value The amount to be transferred.
104   */
105     function transfer(address _to, uint256 _value) public returns (bool) {
106         require(_to != address(0),"toaddress Must No Eq 0");
107 
108         // SafeMath.sub will throw if there is not enough balance.
109         balances[msg.sender] = balances[msg.sender].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         emit Transfer(msg.sender, _to, _value);
112         return true;
113     }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param _owner The address to query the the balance of.
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120     function balanceOf(address _owner) public view returns (uint256 balance) {
121         return balances[_owner];
122     }
123 
124 }
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131     function allowance(address owner, address spender) public view returns (uint256);
132     function transferFrom(address from, address to, uint256 value) public returns (bool);
133     function approve(address spender, uint256 value) public returns (bool);
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147     mapping (address => mapping (address => uint256)) allowed;
148     /**
149     * @dev Transfer tokens from one address to another
150     * @param _from address The address which you want to send tokens from
151     * @param _to address The address which you want to transfer to
152     * @param _value uint256 the amount of tokens to be transferred
153     */
154     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
155         require(_to != address(0),"toaddress Must Not Eq 0");
156 
157         uint256 _allowance = allowed[_from][msg.sender];
158 
159         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
160         // require (_value <= _allowance);
161 
162         balances[_from] = balances[_from].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         allowed[_from][msg.sender] = _allowance.sub(_value);
165         emit Transfer(_from, _to, _value);
166         return true;
167     }
168 
169     /**
170     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171     *
172     * Beware that changing an allowance with this method brings the risk that someone may use both the old
173     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176     * @param _spender The address which will spend the funds.
177     * @param _value The amount of tokens to be spent.
178     */
179     function approve(address _spender, uint256 _value) public returns (bool) {
180         allowed[msg.sender][_spender] = _value;
181         emit Approval(msg.sender, _spender, _value);
182         return true;
183     }
184 
185     /**
186     * @dev Function to check the amount of tokens that an owner allowed to a spender.
187     * @param _owner address The address which owns the funds.
188     * @param _spender address The address which will spend the funds.
189     * @return A uint256 specifying the amount of tokens still available for the spender.
190     */
191     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
192         return allowed[_owner][_spender];
193     }
194 
195     /**
196     * approve should be called when allowed[_spender] == 0. To increment
197     * allowed value is better to use this function to a void 2 calls (and wait until
198     * the first transaction is mined)
199     * From MonolithDAO Token.sol
200     */
201     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
202         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204         return true;
205     }
206 
207     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
208         uint oldValue = allowed[msg.sender][_spender];
209         if (_subtractedValue > oldValue) {
210             allowed[msg.sender][_spender] = 0;
211         } else {
212             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213         }
214         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218 }
219 
220 
221 /**
222  * @title Pausable
223  * @dev Base contract which allows children to implement an emergency stop mechanism.
224  */
225 contract Pausable is Ownable {
226     event Pause();
227     event Unpause();
228 
229     bool public paused = false;
230 
231     /**
232     * @dev Modifier to make a function callable only when the contract is not paused.
233     */
234     modifier whenNotPaused() {
235         require(!paused,"No Paused");
236         _;
237     }
238 
239     /**
240     * @dev Modifier to make a function callable only when the contract is paused.
241     */
242     modifier whenPaused() {
243         require(paused,"Paused");
244         _;
245     }
246 
247     /**
248     * @dev called by the owner to pause, triggers stopped state
249     */
250     function pause() public onlyOwner whenNotPaused  {
251         paused = true;
252         emit Pause();
253     }
254 
255   
256     /**
257     * @dev called by the owner to unpause, returns to normal state
258     */
259     function unpause() public onlyOwner whenPaused  {
260         paused = false;
261         emit Unpause();
262     }
263 }
264 
265 
266 
267 /**
268  * @title TRToken
269  * @dev ERC20 TR Token
270  *
271  * TR Tokens are divisible by 1e18 base
272  *
273  * TR are displayed using 18 decimal places of precision.
274  *
275  * All initial TR Token are assigned to the creator of
276  * this contract.
277  */
278 contract TRToken is StandardToken, Pausable {
279 
280     string public constant name = "TR Coin";                    // Set the token name for display
281     string public constant symbol = "TR";                                  // Set the token symbol for display
282     uint8 public constant decimals = 18;                                     // Set the number of decimals for display
283     uint256 public constant INITIAL_SUPPLY =  10000000000 * 10**uint256(decimals);
284 
285     /**
286     * @dev Modifier to make a function callable only when the contract is not paused.
287     */
288     modifier rejectTokensToContract(address _to) {
289         require(_to != address(this),"reject Token To Contract");
290         _;
291     }
292 
293     /**
294     * @dev TRToken Constructor
295     * Runs only on initial contract creation.
296     */
297     constructor() public {
298         totalSupply = INITIAL_SUPPLY;                               // Set the total supply
299         balances[msg.sender] = INITIAL_SUPPLY;                      // Creator address is assigned all
300         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
301     }
302 
303     /**
304     * @dev Transfer token for a specified address when not paused
305     * @param _to The address to transfer to.
306     * @param _value The amount to be transferred.
307     */
308     function transfer(address _to, uint256 _value) public rejectTokensToContract(_to) whenNotPaused returns (bool) {
309         return super.transfer(_to, _value);
310     }
311 
312     /**
313     * @dev Transfer tokens from one address to another when not paused
314     * @param _from address The address which you want to send tokens from
315     * @param _to address The address which you want to transfer to
316     * @param _value uint256 the amount of tokens to be transferred
317     */
318     function transferFrom(address _from, address _to, uint256 _value) public rejectTokensToContract(_to)  whenNotPaused returns (bool) {
319         return super.transferFrom(_from, _to, _value);
320     }
321 
322     /**
323     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
324     * @param _spender The address which will spend the funds.
325     * @param _value The amount of tokens to be spent.
326     */
327     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
328         return super.approve(_spender, _value);
329     }
330 
331     /**
332     * Adding whenNotPaused
333     */
334     function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
335         return super.increaseApproval(_spender, _addedValue);
336     }
337 
338     /**
339     * Adding whenNotPaused
340     */
341     function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
342         return super.decreaseApproval(_spender, _subtractedValue);
343     }
344 
345     //=====================================================================================
346     // Burning:
347     //=====================================================================================
348     address public destroyer;
349     event Burn(uint256 amount);
350 
351     modifier onlyDestroyer() {
352         require(msg.sender == destroyer,"The destroyer must be equal to the sender");
353         _;
354     }
355 
356     function setDestroyer(address _destroyer) public whenNotPaused onlyOwner  returns( bool success) {
357         destroyer = _destroyer;
358         return true;
359     }
360 
361     function burn(uint256 _amount) public  whenNotPaused onlyDestroyer  returns (bool success) {
362         require(balances[destroyer] >= _amount && _amount > 0,"balance is not enough and destroy value must greater than 0");
363         balances[destroyer] = balances[destroyer].sub(_amount);
364         totalSupply = totalSupply.sub(_amount);
365         emit Burn(_amount);
366         return true;
367     }
368 
369 }