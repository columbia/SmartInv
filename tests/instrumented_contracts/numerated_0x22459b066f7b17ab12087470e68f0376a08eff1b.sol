1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address _who) public view returns (uint256);
11     function allowance(address _owner, address _spender) public view returns (uint256);
12     function transfer(address _to, uint256 _value) public returns (bool);
13     function approve(address _spender, uint256 _value) public returns (bool);
14     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that revert on error
24  */
25 library SafeMath {
26     /**
27     * @dev Multiplies two numbers, reverts on overflow.
28     */
29     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
30         uint256 c = _a * _b;
31         assert(_a == 0 || c / _a == _b);
32 
33         return c;
34     }
35 
36     /**
37     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
38     */
39     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
40         uint256 c = _a / _b;
41         return c;
42     }
43 
44     /**
45     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
46     */
47     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
48         assert(_b <= _a);
49         uint256 c = _a - _b;
50 
51         return c;
52     }
53 
54     /**
55     * @dev Adds two numbers, reverts on overflow.
56     */
57     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
58         uint256 c = _a + _b;
59         assert(c >= _a);
60 
61         return c;
62     }
63 }
64 
65 
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72     address public owner;
73 
74     event OwnershipRenounced(address indexed previousOwner);
75     event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
76 
77     /**
78     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79     * account.
80     */
81     constructor() public {
82         owner = msg.sender;
83     }
84 
85     /**
86     * @dev Throws if called by any account other than the owner.
87     */
88     modifier onlyOwner() {
89         require(msg.sender == owner);
90         _;
91     }
92 
93     /**
94     * @dev Allows the current owner to relinquish control of the contract.
95     * @notice Renouncing to ownership will leave the contract without an owner.
96     * It will not be possible to call the functions with the `onlyOwner`
97     * modifier anymore.
98     */
99     function renounceOwnership() public onlyOwner {
100         emit OwnershipRenounced(owner);
101         owner = address(0);
102     }
103 
104     /**
105     * @dev Allows the current owner to transfer control of the contract to a newOwner.
106     * @param _newOwner The address to transfer ownership to.
107     */
108     function transferOwnership(address _newOwner) public onlyOwner {
109         require(_newOwner != address(0));
110         emit OwnershipTransferred(owner, _newOwner);
111         owner = _newOwner;
112     }
113 }
114 
115 
116 /**
117 * @title Blacklisted
118 * @dev allow contract owner to add/remove address(es) to/from the blacklist
119 */
120 contract Blacklisted is Ownable {
121     mapping (address => bool) public blacklist;
122 
123     event SetBlacklist(address indexed _address, bool _bool);
124 
125     /**
126     * @dev Modifier: throw if _address is in the blacklist
127     */
128     modifier notInBlacklist(address _address) {
129         require(blacklist[_address] == false);
130         _;
131     }
132 
133     /**
134     * @dev call by the owner, set/unset single _address into the blacklist
135     */
136     function setBlacklist(address _address, bool _bool) public onlyOwner {
137         require(_address != address(0));
138 
139         blacklist[_address] = _bool;
140         emit SetBlacklist(_address, _bool);
141     }
142 
143     /**
144     * @dev call by the owner, set/unset bulk _addresses into the blacklist
145     */
146     function setBlacklistBulk(address[] _addresses, bool _bool) public onlyOwner {
147         require(_addresses.length != 0);
148 
149         for(uint256 i = 0; i < _addresses.length; i++)
150         {
151             setBlacklist(_addresses[i], _bool);
152         }
153     }
154 }
155 
156 /**
157  * @title Pausable
158  * @dev Base contract which allows children to implement an emergency stop mechanism.
159  */
160 contract Pausable is Ownable {
161     event Pause();
162     event Unpause();
163 
164     bool public paused = false;
165 
166     /**
167     * @dev Modifier to make a function callable only when the contract is not paused.
168     */
169     modifier whenNotPaused() {
170         require(!paused);
171         _;
172     }
173 
174     /**
175     * @dev Modifier to make a function callable only when the contract is paused.
176     */
177     modifier whenPaused() {
178         require(paused);
179         _;
180     }
181 
182     /**
183     * @dev called by the owner to pause, triggers stopped state
184     */
185     function pause() public onlyOwner whenNotPaused {
186         paused = true;
187         emit Pause();
188     }
189 
190     /**
191     * @dev called by the owner to unpause, returns to normal state
192     */
193     function unpause() public onlyOwner whenPaused {
194         paused = false;
195         emit Unpause();
196     }
197 }
198 
199 
200 /**
201  * @title Standard ERC20 token
202  *
203  * @dev Implementation of the basic standard token.
204  * https://github.com/ethereum/EIPs/issues/20
205  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
206  */
207 contract StandardToken is ERC20,Pausable,Blacklisted {
208     using SafeMath for uint256;
209 
210     mapping(address => uint256) balances;
211 
212     mapping (address => mapping (address => uint256)) internal allowed;
213 
214     uint256 totalSupply_;
215 
216     /**
217     * @dev Total number of tokens in existence
218     */
219     function totalSupply() public view returns (uint256) {
220         return totalSupply_;
221     }
222 
223     /**
224     * @dev Gets the balance of the specified address.
225     * @param _owner The address to query the the balance of.
226     * @return An uint256 representing the amount owned by the passed address.
227     */
228     function balanceOf(address _owner) public view returns (uint256) {
229         return balances[_owner];
230     }
231 
232     /**
233     * @dev Function to check the amount of tokens that an owner allowed to a spender.
234     * @param _owner address The address which owns the funds.
235     * @param _spender address The address which will spend the funds.
236     * @return A uint256 specifying the amount of tokens still available for the spender.
237     */
238     function allowance(address _owner, address _spender) public view returns (uint256) {
239         return allowed[_owner][_spender];
240     }
241 
242     /**
243     * @dev Transfer token for a specified address
244     * @param _to The address to transfer to.
245     * @param _value The amount to be transferred.
246     */
247     function transfer(address _to, uint256 _value) whenNotPaused notInBlacklist(msg.sender) notInBlacklist(_to) public returns (bool) {
248         require(_to != address(0));
249 
250         balances[msg.sender] = balances[msg.sender].sub(_value);
251         balances[_to] = balances[_to].add(_value);
252 
253         emit Transfer(msg.sender, _to, _value);
254         return true;
255     }
256 
257 
258     /**
259     * @dev Transfer tokens from one address to another
260     * @param _from address The address which you want to send tokens from
261     * @param _to address The address which you want to transfer to
262     * @param _value uint256 the amount of tokens to be transferred
263     */
264     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused notInBlacklist(msg.sender) notInBlacklist(_from) notInBlacklist(_to) public returns (bool) {
265         require(_to != address(0));
266 
267         balances[_from] = balances[_from].sub(_value);
268         balances[_to] = balances[_to].add(_value);
269         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
270 
271         emit Transfer(_from, _to, _value);
272         return true;
273     }
274 
275 
276     /**
277     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
278     * @param _spender The address which will spend the funds.
279     * @param _value The amount of tokens to be spent.
280     */
281     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
282         require(_value == 0 || allowed[msg.sender][_spender] == 0 );
283         allowed[msg.sender][_spender] = _value;
284 
285         emit Approval(msg.sender, _spender, _value);
286         return true;
287     }
288 
289 
290     /**
291     * @dev Increase the amount of tokens that an owner allowed to a spender.
292     * approve should be called when allowed[_spender] == 0. To increment
293     * allowed value is better to use this function to avoid 2 calls (and wait until
294     * the first transaction is mined)
295     * From MonolithDAO Token.sol
296     * @param _spender The address which will spend the funds.
297     * @param _addedValue The amount of tokens to increase the allowance by.
298     */
299     function increaseApproval(address _spender, uint256 _addedValue) whenNotPaused public returns (bool) {
300         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
301 
302         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303         return true;
304     }
305 
306     /**
307     * @dev Decrease the amount of tokens that an owner allowed to a spender.
308     * approve should be called when allowed[_spender] == 0. To decrement
309     * allowed value is better to use this function to avoid 2 calls (and wait until
310     * the first transaction is mined)
311     * From MonolithDAO Token.sol
312     * @param _spender The address which will spend the funds.
313     * @param _subtractedValue The amount of tokens to decrease the allowance by.
314     */
315     function decreaseApproval(address _spender, uint256 _subtractedValue) whenNotPaused public returns (bool) {
316         uint256 oldValue = allowed[msg.sender][_spender];
317         if (_subtractedValue >= oldValue) {
318             allowed[msg.sender][_spender] = 0;
319         } else {
320             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
321         }
322 
323         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324         return true;
325     }
326 }
327 
328 
329 /**
330  * @title Burnable Token
331  * @dev Token that can be irreversibly burned (destroyed).
332  */
333 contract BurnableToken is StandardToken {
334 
335     event Burn(address indexed burner, uint256 value);
336 
337     /**
338     * @dev Burns a specific amount of tokens.
339     * @param _value The amount of token to be burned.
340     */
341     function burn(uint256 _value) whenNotPaused public {
342         _burn(msg.sender, _value);
343     }
344 
345     /**
346     * @dev Burns a specific amount of tokens from the target address and decrements allowance
347     * @param _from address The address which you want to send tokens from
348     * @param _value uint256 The amount of token to be burned
349     */
350     function burnFrom(address _from, uint256 _value) whenNotPaused public {
351         require(_value <= allowed[_from][msg.sender]);
352 
353         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
354         _burn(_from, _value);
355     }
356 
357     function _burn(address _who, uint256 _value) internal {
358         require(_value <= balances[_who]);
359 
360         balances[_who] = balances[_who].sub(_value);
361         totalSupply_ = totalSupply_.sub(_value);
362 
363         emit Burn(_who, _value);
364         emit Transfer(_who, address(0), _value);
365     }
366 }
367 
368 
369 /**
370 * @title UPToken
371 * @dev	main contract UP Token
372 */
373 contract UPToken is BurnableToken {
374     string public constant name = "UPT";
375     string public constant symbol = "UPT";
376     uint8 public constant decimals = 18;
377     uint256 public constant INITIAL_SUPPLY = 100000000;
378 
379     mapping(address => string) public keys;
380 
381     constructor() public {
382         totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
383         balances[msg.sender] = totalSupply_;
384         emit Transfer(address(0), msg.sender, totalSupply_);
385     }
386 
387     event Register(address _address, string _key);
388     function register(string _key) whenNotPaused notInBlacklist(msg.sender) public
389     {
390         require(bytes(_key).length <= 64);
391 
392         keys[msg.sender] = _key;
393         emit Register(msg.sender, _key);
394     }
395 }