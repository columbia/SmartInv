1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     function totalSupply() public view returns (uint256);
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22     function allowance(address owner, address spender) public view returns (uint256);
23     function transferFrom(address from, address to, uint256 value) public returns (bool);
24     function approve(address spender, uint256 value) public returns (bool);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 contract DetailedERC20 is ERC20 {
30     string public name;
31     string public symbol;
32     uint8 public decimals;
33 
34     constructor(string _name, string _symbol, uint8 _decimals) public {
35         name = _name;
36         symbol = _symbol;
37         decimals = _decimals;
38     }
39 }
40 
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47 
48     /**
49     * @dev Multiplies two numbers, throws on overflow.
50     */
51     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
52         if (a == 0) {
53             return 0;
54         }
55         c = a * b;
56         assert(c / a == b);
57         return c;
58     }
59 
60     /**
61     * @dev Integer division of two numbers, truncating the quotient.
62     */
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         // assert(b > 0); // Solidity automatically throws when dividing by 0
65         // uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67         return a / b;
68     }
69 
70     /**
71     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
72     */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         assert(b <= a);
75         return a - b;
76     }
77 
78     /**
79     * @dev Adds two numbers, throws on overflow.
80     */
81     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
82         c = a + b;
83         assert(c >= a);
84         return c;
85     }
86 }
87 
88 
89 /**
90  * @title Ownable
91  * @dev The Ownable contract has an owner address, and provides basic authorization control
92  * functions, this simplifies the implementation of "user permissions".
93  */
94 contract Ownable {
95     address public owner;
96 
97     /**
98      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
99      * account.
100      */
101     constructor() public {
102         owner = msg.sender;
103     }
104 
105     /**
106      * @dev Throws if called by any account other than the owner.
107      */
108     modifier onlyOwner() {
109         require(msg.sender == owner);
110         _;
111     }
112 
113     /**
114      * @dev Allows the current owner to transfer control of the contract to a newOwner.
115      * @param newOwner The address to transfer ownership to.
116      */
117     function transferOwnership(address newOwner) public onlyOwner {
118         require(newOwner != address(0));
119         owner = newOwner;
120     }
121 }
122 
123 
124 /**
125  * @title Basic token
126  * @dev Basic version of StandardToken, with no allowances.
127  */
128 contract BasicToken is ERC20Basic {
129     using SafeMath for uint256;
130 
131     mapping(address => uint256) balances;
132     mapping(address => bool) _frozenAccount;   // FreezableToken
133 
134     uint256 totalSupply_;
135 
136     /**
137     * @dev total number of tokens in existence
138     */
139     function totalSupply() public view returns (uint256) {
140         return totalSupply_;
141     }
142 
143     /**
144     * @dev transfer token for a specified address
145     * @param _to The address to transfer to.
146     * @param _value The amount to be transferred.
147     */
148     function transfer(address _to, uint256 _value) public returns (bool) {
149         require(_to != address(0));
150         require(_value <= balances[msg.sender]);
151         require(balances[_to].add(_value) >= balances[_to]);  // Check for overflows
152         require(!_frozenAccount[msg.sender]);
153         require(!_frozenAccount[_to]);
154 
155         balances[msg.sender] = balances[msg.sender].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157         emit Transfer(msg.sender, _to, _value);
158         return true;
159     }
160 
161     /**
162     * @dev Gets the balance of the specified address.
163     * @param _owner The address to query the balance of.
164     * @return An uint256 representing the amount owned by the passed address.
165     */
166     function balanceOf(address _owner) public view returns (uint256) {
167         return balances[_owner];
168     }
169 
170 }
171 
172 
173 /**
174  * @title Burnable Token
175  * @dev Token that can be irreversibly burned (destroyed).
176  */
177 contract BurnableToken is BasicToken, Ownable {
178     
179     event Burn(address indexed burner, uint256 value);
180 
181     /**
182      * @dev Burns a specific amount of tokens.
183      * @param target address
184      * @param value The amount of token to be burned.
185      */
186     function burn(address target, uint256 value) onlyOwner public {
187         require(value <= balances[target]);
188         // no need to require value <= totalSupply, since that would imply the
189         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
190 
191         balances[target] = balances[target].sub(value);
192         totalSupply_ = totalSupply_.sub(value);
193         emit Burn(target, value);
194         emit Transfer(target, address(0), value);
195     }
196 }
197 
198 /**
199  * @title Freezable Token
200  * @dev Token that can be frozen and unfrozen.
201  */
202 contract FreezableToken is BasicToken, Ownable {
203     
204     event FrozenFunds(address target, bool frozen);
205 
206     /**
207      * @dev Freeze or unfreeze specified account
208      * @param target Address to be frozen
209      * @param freeze either to freeze it or not
210      */
211     function freezeAccount(address target, bool freeze) onlyOwner public {
212         _frozenAccount[target] = freeze;
213         emit FrozenFunds(target, freeze);
214     }
215     
216     /**
217     * @dev Gets account frozen status.
218     * @param _owner The address to query the frozen status.
219     * @return Boolean status: frozen - true or 1, unfrozen - false or 0.
220     */
221     function frozenAccount(address _owner) public view returns (bool) {
222         return _frozenAccount[_owner];
223     }
224 }
225 
226 
227 /**
228  * @title Standard ERC20 token
229  *
230  * @dev Implementation of the basic standard token.
231  * @dev https://github.com/ethereum/EIPs/issues/20
232  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
233  */
234 contract StandardToken is ERC20, BasicToken {
235 
236     mapping (address => mapping (address => uint256)) internal allowed;
237 
238 
239     /**
240      * @dev Transfer tokens from one address to another
241      * @param _from address The address which you want to send tokens from
242      * @param _to address The address which you want to transfer to
243      * @param _value uint256 the amount of tokens to be transferred
244      */
245     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
246         require(_to != address(0));
247         require(_value <= balances[_from]);
248         require(_value <= allowed[_from][msg.sender]);
249         require(balances[_to].add(_value) >= balances[_to]);  // Check for overflows
250         require(!_frozenAccount[_from]);
251         require(!_frozenAccount[_to]);
252 
253         balances[_from] = balances[_from].sub(_value);
254         balances[_to] = balances[_to].add(_value);
255         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
256         emit Transfer(_from, _to, _value);
257         return true;
258     }
259 
260     /**
261      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
262      *
263      * Beware that changing an allowance with this method brings the risk that someone may use both the old
264      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
265      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
266      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267      * @param _spender The address which will spend the funds.
268      * @param _value The amount of tokens to be spent.
269      */
270     function approve(address _spender, uint256 _value) public returns (bool) {
271         allowed[msg.sender][_spender] = _value;
272         emit Approval(msg.sender, _spender, _value);
273         return true;
274     }
275 
276     /**
277      * @dev Function to check the amount of tokens that an owner allowed to a spender.
278      * @param _owner address The address which owns the funds.
279      * @param _spender address The address which will spend the funds.
280      * @return A uint256 specifying the amount of tokens still available for the spender.
281      */
282     function allowance(address _owner, address _spender) public view returns (uint256) {
283         return allowed[_owner][_spender];
284     }
285 
286     /**
287      * @dev Increase the amount of tokens that an owner allowed to a spender.
288      *
289      * approve should be called when allowed[_spender] == 0. To increment
290      * allowed value is better to use this function to avoid 2 calls (and wait until
291      * the first transaction is mined)
292      * From MonolithDAO Token.sol
293      * @param _spender The address which will spend the funds.
294      * @param _addedValue The amount of tokens to increase the allowance by.
295      */
296     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
297         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
298         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299         return true;
300     }
301 
302     /**
303      * @dev Decrease the amount of tokens that an owner allowed to a spender.
304      *
305      * approve should be called when allowed[_spender] == 0. To decrement
306      * allowed value is better to use this function to avoid 2 calls (and wait until
307      * the first transaction is mined)
308      * From MonolithDAO Token.sol
309      * @param _spender The address which will spend the funds.
310      * @param _subtractedValue The amount of tokens to decrease the allowance by.
311      */
312     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
313         uint oldValue = allowed[msg.sender][_spender];
314         if (_subtractedValue > oldValue) {
315             allowed[msg.sender][_spender] = 0;
316         } else {
317             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
318         }
319         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320         return true;
321     }
322 
323 }
324 
325 
326 /**
327  * @title Pausable
328  * @dev Base contract which allows children to implement an emergency stop mechanism.
329  */
330 contract Pausable is Ownable {
331     event Pause();
332     event Unpause();
333 
334     bool public paused = false;
335 
336 
337     /**
338      * @dev Modifier to make a function callable only when the contract is not paused.
339      */
340     modifier whenNotPaused() {
341         require(!paused);
342         _;
343     }
344 
345     /**
346      * @dev Modifier to make a function callable only when the contract is paused.
347      */
348     modifier whenPaused() {
349         require(paused);
350         _;
351     }
352 
353     /**
354      * @dev called by the owner to pause, triggers stopped state
355      */
356     function pause() onlyOwner whenNotPaused public {
357         paused = true;
358         emit Pause();
359     }
360 
361     /**
362      * @dev called by the owner to unpause, returns to normal state
363      */
364     function unpause() onlyOwner whenPaused public {
365         paused = false;
366         emit Unpause();
367     }
368 }
369 
370 
371 /**
372  * @title Pausable token
373  * @dev StandardToken modified with pausable transfers.
374  **/
375 contract PausableToken is StandardToken, Pausable {
376 
377     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
378         return super.transfer(_to, _value);
379     }
380 
381     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
382         return super.transferFrom(_from, _to, _value);
383     }
384 
385     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
386         return super.approve(_spender, _value);
387     }
388 
389     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
390         return super.increaseApproval(_spender, _addedValue);
391     }
392 
393     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
394         return super.decreaseApproval(_spender, _subtractedValue);
395     }
396 }
397 
398 
399 /**
400  * @title GetAchieve Token
401  * @dev GAT Smart Contract
402  */
403 contract GAToken is DetailedERC20, StandardToken, BurnableToken, FreezableToken, PausableToken {
404     /**
405     * Init token by setting its total supply
406     *
407     * @param totalSupply total token supply
408     */
409     constructor(
410         uint256 totalSupply
411     ) DetailedERC20(
412         "GetAchieve Token",
413         "GAT",
414         18
415     ) public {
416         totalSupply_ = totalSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
417         balances[msg.sender] = totalSupply_;
418         emit Transfer(0x0, msg.sender, totalSupply_);
419     }
420     
421     /**
422     * Refund if someone sent ETH to this contract (GAS also will be refunded)
423     */
424     function() public payable {
425         revert();
426     }
427 }