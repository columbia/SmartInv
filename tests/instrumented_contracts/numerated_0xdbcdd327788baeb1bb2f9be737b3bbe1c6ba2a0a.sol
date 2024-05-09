1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63     /**
64      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65      * account.
66      */
67     function Ownable() public {
68         owner = msg.sender;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     /**
80      * @dev Allows the current owner to transfer control of the contract to a newOwner.
81      * @param newOwner The address to transfer ownership to.
82      */
83     function transferOwnership(address newOwner) public onlyOwner {
84         require(newOwner != address(0));
85         OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87     }
88 
89 }
90 
91 
92 /**
93  * @title Pausable
94  * @dev Base contract which allows children to implement an emergency stop mechanism.
95  */
96 contract Pausable is Ownable {
97     event Pause();
98     event Unpause();
99 
100     bool public paused = false;
101 
102 
103     /**
104      * @dev Modifier to make a function callable only when the contract is not paused.
105      */
106     modifier whenNotPaused() {
107         require(!paused);
108         _;
109     }
110 
111     /**
112      * @dev Modifier to make a function callable only when the contract is paused.
113      */
114     modifier whenPaused() {
115         require(paused);
116         _;
117     }
118 
119     /**
120      * @dev called by the owner to pause, triggers stopped state
121      */
122     function pause() onlyOwner whenNotPaused public {
123         paused = true;
124         Pause();
125     }
126 
127     /**
128      * @dev called by the owner to unpause, returns to normal state
129      */
130     function unpause() onlyOwner whenPaused public {
131         paused = false;
132         Unpause();
133     }
134 }
135 
136 
137 /**
138  * @title ERC20Basic
139  * @dev Simpler version of ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/179
141  */
142 contract ERC20Basic {
143     function totalSupply() public view returns (uint256);
144     function balanceOf(address who) public view returns (uint256);
145     function transfer(address to, uint256 value) public returns (bool);
146     event Transfer(address indexed from, address indexed to, uint256 value);
147 }
148 
149 
150 /**
151  * @title ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/20
153  */
154 contract ERC20 is ERC20Basic {
155     function allowance(address owner, address spender) public view returns (uint256);
156     function transferFrom(address from, address to, uint256 value) public returns (bool);
157     function approve(address spender, uint256 value) public returns (bool);
158     event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 
162 /**
163  * @title Basic token
164  * @dev Basic version of StandardToken, with no allowances.
165  */
166 contract BasicToken is ERC20Basic {
167     using SafeMath for uint256;
168 
169     mapping(address => uint256) balances;
170 
171     uint256 totalSupply_;
172 
173     /**
174     * @dev total number of tokens in existence
175     */
176     function totalSupply() public view returns (uint256) {
177         return totalSupply_;
178     }
179 
180     /**
181     * @dev transfer token for a specified address
182     * @param _to The address to transfer to.
183     * @param _value The amount to be transferred.
184     */
185     function transfer(address _to, uint256 _value) public returns (bool) {
186         require(_to != address(0));
187         require(_value <= balances[msg.sender]);
188 
189         // SafeMath.sub will throw if there is not enough balance.
190         balances[msg.sender] = balances[msg.sender].sub(_value);
191         balances[_to] = balances[_to].add(_value);
192         Transfer(msg.sender, _to, _value);
193         return true;
194     }
195 
196     /**
197     * @dev Gets the balance of the specified address.
198     * @param _owner The address to query the the balance of.
199     * @return An uint256 representing the amount owned by the passed address.
200     */
201     function balanceOf(address _owner) public view returns (uint256 balance) {
202         return balances[_owner];
203     }
204 
205 }
206 
207 
208 /**
209  * @title Standard ERC20 token
210  *
211  * @dev Implementation of the basic standard token.
212  * @dev https://github.com/ethereum/EIPs/issues/20
213  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
214  */
215 contract StandardToken is ERC20, BasicToken {
216 
217     mapping (address => mapping (address => uint256)) internal allowed;
218 
219 
220     /**
221      * @dev Transfer tokens from one address to another
222      * @param _from address The address which you want to send tokens from
223      * @param _to address The address which you want to transfer to
224      * @param _value uint256 the amount of tokens to be transferred
225      */
226     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
227         require(_to != address(0));
228         require(_value <= balances[_from]);
229         require(_value <= allowed[_from][msg.sender]);
230 
231         balances[_from] = balances[_from].sub(_value);
232         balances[_to] = balances[_to].add(_value);
233         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
234         Transfer(_from, _to, _value);
235         return true;
236     }
237 
238     /**
239      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
240      *
241      * Beware that changing an allowance with this method brings the risk that someone may use both the old
242      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245      * @param _spender The address which will spend the funds.
246      * @param _value The amount of tokens to be spent.
247      */
248     function approve(address _spender, uint256 _value) public returns (bool) {
249         allowed[msg.sender][_spender] = _value;
250         Approval(msg.sender, _spender, _value);
251         return true;
252     }
253 
254     /**
255      * @dev Function to check the amount of tokens that an owner allowed to a spender.
256      * @param _owner address The address which owns the funds.
257      * @param _spender address The address which will spend the funds.
258      * @return A uint256 specifying the amount of tokens still available for the spender.
259      */
260     function allowance(address _owner, address _spender) public view returns (uint256) {
261         return allowed[_owner][_spender];
262     }
263 
264     /**
265      * @dev Increase the amount of tokens that an owner allowed to a spender.
266      *
267      * approve should be called when allowed[_spender] == 0. To increment
268      * allowed value is better to use this function to avoid 2 calls (and wait until
269      * the first transaction is mined)
270      * From MonolithDAO Token.sol
271      * @param _spender The address which will spend the funds.
272      * @param _addedValue The amount of tokens to increase the allowance by.
273      */
274     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
275         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
276         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277         return true;
278     }
279 
280     /**
281      * @dev Decrease the amount of tokens that an owner allowed to a spender.
282      *
283      * approve should be called when allowed[_spender] == 0. To decrement
284      * allowed value is better to use this function to avoid 2 calls (and wait until
285      * the first transaction is mined)
286      * From MonolithDAO Token.sol
287      * @param _spender The address which will spend the funds.
288      * @param _subtractedValue The amount of tokens to decrease the allowance by.
289      */
290     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
291         uint oldValue = allowed[msg.sender][_spender];
292         if (_subtractedValue > oldValue) {
293             allowed[msg.sender][_spender] = 0;
294         } else {
295             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
296         }
297         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298         return true;
299     }
300 
301 }
302 
303 
304 /**
305  * @title Pausable token
306  * @dev StandardToken modified with pausable transfers.
307  **/
308 contract PausableToken is StandardToken, Pausable {
309 
310     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
311         return super.transfer(_to, _value);
312     }
313 
314     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
315         return super.transferFrom(_from, _to, _value);
316     }
317 
318     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
319         return super.approve(_spender, _value);
320     }
321 
322     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
323         return super.increaseApproval(_spender, _addedValue);
324     }
325 
326     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
327         return super.decreaseApproval(_spender, _subtractedValue);
328     }
329 }
330 
331 
332 contract ETHERCToken is PausableToken {
333 
334     uint8 public constant decimals = 18;
335     string public constant name = "ETHERCToken";
336     string public constant symbol = "EET";
337     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
338     string public welcome;
339     address public admin;
340 
341     event Burn(address indexed burner, uint256 value);
342 
343     function ETHERCToken() public {
344         admin = owner;
345         totalSupply_ = INITIAL_SUPPLY;
346         balances[owner] = INITIAL_SUPPLY;
347         Transfer(address(0), msg.sender, INITIAL_SUPPLY);
348     }
349 
350     function changeAdmin(address _admin) public onlyOwner {
351         require(_admin != address(0));
352         admin = _admin;
353     }
354 
355     modifier onlyAdmin() {
356         require(msg.sender == owner || msg.sender == admin);
357         _;
358     }
359 
360     function changeWelcome(string _welcome) public onlyAdmin {
361         welcome = _welcome;
362     }
363 
364     /**
365      * @dev Burns a specific amount of tokens.
366      * @param _value The amount of token to be burned.
367      */
368     function burn(uint256 _value) public onlyAdmin {
369         require(_value <= balances[msg.sender]);
370         // no need to require value <= totalSupply, since that would imply the
371         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
372 
373         address burner = msg.sender;
374         balances[burner] = balances[burner].sub(_value);
375         totalSupply_ = totalSupply_.sub(_value);
376         Burn(burner, _value);
377         Transfer(burner, address(0), _value);
378     }
379 
380     /**
381      * @dev Transfer token in batch
382      * @param _recipients The addresses to transfer to.
383      * @param _values The amount to be transferred.
384      */
385     function batchTransfer(address[] _recipients, uint256[] _values) public onlyAdmin returns (bool) {
386         require(_recipients.length > 0 && _recipients.length == _values.length);
387 
388         uint256 total = 0;
389         for (uint256 i = 0; i < _values.length; i++) {
390             total = total.add(_values[i]);
391         }
392         require(total <= balances[msg.sender]);
393 
394         // SafeMath.sub will throw if there is not enough balance.
395         balances[msg.sender] = balances[msg.sender].sub(total);
396 
397         for (uint256 j = 0; j < _recipients.length; j++) {
398             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
399             Transfer(msg.sender, _recipients[j], _values[j]);
400         }
401         
402         return true;
403     }
404 }