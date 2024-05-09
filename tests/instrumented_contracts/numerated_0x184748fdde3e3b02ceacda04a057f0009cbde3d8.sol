1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @author OpenZeppelin math/SafeMath.sol
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10     /**
11      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is
12      * greater than minuend).
13      */
14     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
15         assert(_b <= _a);
16         return _a - _b;
17     }
18 
19     /**
20      * @dev Adds two numbers, throws on overflow.
21      */
22     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
23         c = _a + _b;
24         assert(c >= _a);
25         return c;
26     }
27 }
28 
29 
30 /**
31  * @title Ownable
32  * @author OpenZeppelin ownership/Ownable.sol
33  * @dev The Ownable contract has an owner address, and provides basic
34  * authorization control functions, this simplifies the implementation of
35  * "user permissions".
36  */
37 contract Ownable {
38     address public owner;
39 
40     event OwnershipTransferred(
41         address indexed previousOwner,
42         address indexed newOwner
43     );
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract
47      * to the sender account.
48      */
49     constructor() public {
50         owner = msg.sender;
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     /**
62      * @dev Allows the current owner to transfer control of the contract to a
63      * newOwner.
64      * @param _newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address _newOwner) public onlyOwner {
67         require(_newOwner != address(0));
68         emit OwnershipTransferred(owner, _newOwner);
69         owner = _newOwner;
70     }
71 }
72 
73 
74 /**
75  * @title Pausable
76  * @author OpenZeppelin lifecycle/Pausable.sol
77  * @dev Base contract which allows children to implement an emergency stop
78  * mechanism.
79  */
80 contract Pausable is Ownable {
81     bool public paused = false;
82 
83     event Pause();
84     event Unpause();
85 
86     /**
87      * @dev Modifier to make a function callable only when the contract is not
88      * paused.
89      */
90     modifier whenNotPaused() {
91         require(!paused);
92         _;
93     }
94 
95     /**
96      * @dev Modifier to make a function callable only when the contract is
97      * paused.
98      */
99     modifier whenPaused() {
100         require(paused);
101         _;
102     }
103 
104     /**
105      * @dev called by the owner to pause, triggers stopped state
106      */
107     function pause() public onlyOwner whenNotPaused {
108         paused = true;
109         emit Pause();
110     }
111 
112     /**
113      * @dev called by the owner to unpause, returns to normal state
114      */
115     function unpause() public onlyOwner whenPaused {
116         paused = false;
117         emit Unpause();
118     }
119 }
120 
121 
122 /**
123  * @title Freezable
124  * @dev Base contract which allows children to freeze account.
125  */
126 contract Freezable is Ownable {
127     mapping (address => bool) public frozenAccount;
128 
129     event Frozen(address target, bool frozen);
130 
131     /**
132      * @dev Modifier to make a function callable only when the target is not
133      * frozen.
134      */
135     modifier whenNotFrozen(address target) {
136         require(!frozenAccount[target]);
137         _;
138     }
139 
140     /**
141      * @notice `freeze? Prevent | Allow` `target` from sending & receiving
142      * tokens
143      * @param target Address to be frozen
144      * @param freeze either to freeze it or not
145      */
146     function freezeAccount(address target, bool freeze) public onlyOwner {
147         frozenAccount[target] = freeze;
148         emit Frozen(target, freeze);
149     }
150 }
151 
152 
153 /**
154  * @title ERC20 interface
155  * @author OpenZeppelin token/ERC20/ERC20.sol
156  * @dev see https://github.com/ethereum/EIPs/issues/20
157  */
158 contract ERC20 {
159     function totalSupply() public view returns (uint256);
160 
161     function balanceOf(address _who) public view returns (uint256);
162 
163     function allowance(address _owner, address _spender)
164         public view returns (uint256);
165 
166     function transfer(address _to, uint256 _value) public returns (bool);
167 
168     function approve(address _spender, uint256 _value)
169         public returns (bool);
170 
171     function transferFrom(address _from, address _to, uint256 _value)
172         public returns (bool);
173 
174     event Transfer(
175         address indexed from,
176         address indexed to,
177         uint256 value
178     );
179 
180     event Approval(
181         address indexed owner,
182         address indexed spender,
183         uint256 value
184     );
185 }
186 
187 
188 /**
189  * @title Standard ERC20 token
190  * @author OpenZeppelin token/ERC20/StandardToken.sol
191  * @dev Implementation of the basic standard token.
192  * https://github.com/ethereum/EIPs/issues/20
193  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/
194  * master/smart_contract/FirstBloodToken.sol
195  */
196 contract StandardToken is ERC20 {
197     using SafeMath for uint256;
198 
199     mapping (address => uint256) balances;
200 
201     mapping (address => mapping (address => uint256)) internal allowed;
202 
203     uint256 totalSupply_;
204 
205     /**
206      * @dev Total number of tokens in existence
207      */
208     function totalSupply() public view returns (uint256) {
209         return totalSupply_;
210     }
211 
212     /**
213      * @dev Gets the balance of the specified address.
214      * @param _owner The address to query the the balance of.
215      * @return An uint256 representing the amount owned by the passed address.
216      */
217     function balanceOf(address _owner) public view returns (uint256) {
218         return balances[_owner];
219     }
220 
221     /**
222      * @dev Function to check the amount of tokens that an owner allowed to a
223      * spender.
224      * @param _owner address The address which owns the funds.
225      * @param _spender address The address which will spend the funds.
226      * @return A uint256 specifying the amount of tokens still available for
227      * the spender.
228      */
229     function allowance(
230         address _owner,
231         address _spender
232     )
233         public
234         view
235         returns (uint256)
236     {
237         return allowed[_owner][_spender];
238     }
239 
240     /**
241      * @dev Transfer token for a specified address
242      * @param _to The address to transfer to.
243      * @param _value The amount to be transferred.
244      */
245     function transfer(address _to, uint256 _value) public returns (bool) {
246         require(_value <= balances[msg.sender]);
247         require(_to != address(0));
248 
249         balances[msg.sender] = balances[msg.sender].sub(_value);
250         balances[_to] = balances[_to].add(_value);
251         emit Transfer(msg.sender, _to, _value);
252         return true;
253     }
254 
255     /**
256      * @dev Approve the passed address to spend the specified amount of tokens
257      * on behalf of msg.sender. Beware that changing an allowance with this
258      * method brings the risk that someone may use both the old and the new
259      * allowance by unfortunate transaction ordering. One possible solution to
260      * mitigate this race condition is to first reduce the spender's allowance
261      * to 0 and set the desired value afterwards:
262      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263      * @param _spender The address which will spend the funds.
264      * @param _value The amount of tokens to be spent.
265      */
266     function approve(address _spender, uint256 _value) public returns (bool) {
267         allowed[msg.sender][_spender] = _value;
268         emit Approval(msg.sender, _spender, _value);
269         return true;
270     }
271 
272     /**
273      * @dev Transfer tokens from one address to another
274      * @param _from address The address which you want to send tokens from
275      * @param _to address The address which you want to transfer to
276      * @param _value uint256 the amount of tokens to be transferred
277      */
278     function transferFrom(
279         address _from,
280         address _to,
281         uint256 _value
282     )
283         public
284         returns (bool)
285     {
286         require(_value <= balances[_from]);
287         require(_value <= allowed[_from][msg.sender]);
288         require(_to != address(0));
289 
290         balances[_from] = balances[_from].sub(_value);
291         balances[_to] = balances[_to].add(_value);
292         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
293         emit Transfer(_from, _to, _value);
294         return true;
295     }
296 }
297 
298 
299 /**
300  * @title Pausable, Freezable & Burnable Token
301  * @author OpenZeppelin token/ERC20/PausableToken.sol
302  * @author OpenZeppelin token/ERC20/BurnableToken.sol
303  * @dev StandardToken modified with pausable transfers.
304  * @dev Token that can be irreversibly burned (destroyed).
305  */
306 contract Token is StandardToken, Pausable, Freezable {
307     // Public variables of the token
308     string public name;
309     string public symbol;
310     // 18 decimals is the strongly suggested default, avoid changing it
311     uint8 public decimals = 18;
312 
313     event Burn(address indexed burner, uint256 value);
314 
315     function transfer(
316         address _to,
317         uint256 _value
318     )
319         public
320         whenNotPaused
321         whenNotFrozen(msg.sender)
322         whenNotFrozen(_to)
323         returns (bool)
324     {
325         return super.transfer(_to, _value);
326     }
327 
328     function approve(
329         address _spender,
330         uint256 _value
331     )
332         public
333         whenNotPaused
334         whenNotFrozen(msg.sender)
335         returns (bool)
336     {
337         return super.approve(_spender, _value);
338     }
339 
340     function transferFrom(
341         address _from,
342         address _to,
343         uint256 _value
344     )
345         public
346         whenNotPaused
347         whenNotFrozen(msg.sender)
348         whenNotFrozen(_from)
349         whenNotFrozen(_to)
350         returns (bool)
351     {
352         return super.transferFrom(_from, _to, _value);
353     }
354 
355     /**
356      * @dev Burns a specific amount of tokens.
357      * @param _value The amount of token to be burned.
358      */
359     function burn(uint256 _value) public onlyOwner whenNotPaused {
360         require(_value <= balances[msg.sender]);
361         // no need to require value <= totalSupply, since that would imply the
362         // sender's balance is greater than the totalSupply, which *should* be
363         // an assertion failure
364 
365         balances[msg.sender] = balances[msg.sender].sub(_value);
366         totalSupply_ = totalSupply_.sub(_value);
367         emit Burn(msg.sender, _value);
368         emit Transfer(msg.sender, address(0), _value);
369     }
370 }
371 
372 
373 contract BIANGToken is Token {
374     constructor() public {
375         // Set the name for display purposes
376         name = "Biang Biang Mian";
377         // Set the symbol for display purposes
378         symbol = "BIANG";
379         // Update total supply with the decimal amount
380         totalSupply_ = 100000000 * 10 ** uint256(decimals);
381         // Give the creator all initial tokens
382         balances[msg.sender] = totalSupply_;
383     }
384 }