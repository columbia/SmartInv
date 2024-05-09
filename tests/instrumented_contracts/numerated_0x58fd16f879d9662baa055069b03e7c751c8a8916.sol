1 pragma solidity ^0.4.24;
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
34     function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
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
90  * @title Basic token
91  * @dev Basic version of StandardToken, with no allowances.
92  */
93 contract BasicToken is ERC20Basic {
94     using SafeMath for uint256;
95 
96     mapping(address => uint256) balances;
97 
98     uint256 totalSupply_;
99 
100     /**
101     * @dev total number of tokens in existence
102     */
103     function totalSupply() public view returns (uint256) {
104         return totalSupply_;
105     }
106 
107     /**
108     * @dev transfer token for a specified address
109     * @param _to The address to transfer to.
110     * @param _value The amount to be transferred.
111     */
112     function transfer(address _to, uint256 _value) public returns (bool) {
113         require(_to != address(0));
114         require(_value <= balances[msg.sender]);
115 
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         emit Transfer(msg.sender, _to, _value);
119         return true;
120     }
121 
122     /**
123     * @dev Gets the balance of the specified address.
124     * @param _owner The address to query the the balance of.
125     * @return An uint256 representing the amount owned by the passed address.
126     */
127     function balanceOf(address _owner) public view returns (uint256) {
128         return balances[_owner];
129     }
130 
131 }
132 
133 
134 /**
135  * @title Burnable Token
136  * @dev Token that can be irreversibly burned (destroyed).
137  */
138 contract BurnableToken is BasicToken {
139 
140     event Burn(address indexed burner, uint256 value);
141 
142     /**
143      * @dev Burns a specific amount of tokens.
144      * @param _value The amount of token to be burned.
145      */
146     function burn(uint256 _value) public {
147         _burn(msg.sender, _value);
148     }
149 
150     function _burn(address _who, uint256 _value) internal {
151         require(_value <= balances[_who]);
152         // no need to require value <= totalSupply, since that would imply the
153         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
154 
155         balances[_who] = balances[_who].sub(_value);
156         totalSupply_ = totalSupply_.sub(_value);
157         emit Burn(_who, _value);
158         emit Transfer(_who, address(0), _value);
159     }
160 }
161 
162 
163 /**
164  * @title Standard ERC20 token
165  *
166  * @dev Implementation of the basic standard token.
167  * @dev https://github.com/ethereum/EIPs/issues/20
168  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
169  */
170 contract StandardToken is ERC20, BasicToken {
171 
172     mapping (address => mapping (address => uint256)) internal allowed;
173 
174 
175     /**
176      * @dev Transfer tokens from one address to another
177      * @param _from address The address which you want to send tokens from
178      * @param _to address The address which you want to transfer to
179      * @param _value uint256 the amount of tokens to be transferred
180      */
181     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
182         require(_to != address(0));
183         require(_value <= balances[_from]);
184         require(_value <= allowed[_from][msg.sender]);
185 
186         balances[_from] = balances[_from].sub(_value);
187         balances[_to] = balances[_to].add(_value);
188         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189         emit Transfer(_from, _to, _value);
190         return true;
191     }
192 
193     /**
194      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195      *
196      * Beware that changing an allowance with this method brings the risk that someone may use both the old
197      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
198      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
199      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200      * @param _spender The address which will spend the funds.
201      * @param _value The amount of tokens to be spent.
202      */
203     function approve(address _spender, uint256 _value) public returns (bool) {
204         allowed[msg.sender][_spender] = _value;
205         emit Approval(msg.sender, _spender, _value);
206         return true;
207     }
208 
209     /**
210      * @dev Function to check the amount of tokens that an owner allowed to a spender.
211      * @param _owner address The address which owns the funds.
212      * @param _spender address The address which will spend the funds.
213      * @return A uint256 specifying the amount of tokens still available for the spender.
214      */
215     function allowance(address _owner, address _spender) public view returns (uint256) {
216         return allowed[_owner][_spender];
217     }
218 
219     /**
220      * @dev Increase the amount of tokens that an owner allowed to a spender.
221      *
222      * approve should be called when allowed[_spender] == 0. To increment
223      * allowed value is better to use this function to avoid 2 calls (and wait until
224      * the first transaction is mined)
225      * From MonolithDAO Token.sol
226      * @param _spender The address which will spend the funds.
227      * @param _addedValue The amount of tokens to increase the allowance by.
228      */
229     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
230         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
231         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232         return true;
233     }
234 
235     /**
236      * @dev Decrease the amount of tokens that an owner allowed to a spender.
237      *
238      * approve should be called when allowed[_spender] == 0. To decrement
239      * allowed value is better to use this function to avoid 2 calls (and wait until
240      * the first transaction is mined)
241      * From MonolithDAO Token.sol
242      * @param _spender The address which will spend the funds.
243      * @param _subtractedValue The amount of tokens to decrease the allowance by.
244      */
245     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
246         uint oldValue = allowed[msg.sender][_spender];
247         if (_subtractedValue > oldValue) {
248             allowed[msg.sender][_spender] = 0;
249         } else {
250             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251         }
252         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253         return true;
254     }
255 
256 }
257 
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265     address public owner;
266 
267 
268     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
269 
270 
271     /**
272      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
273      * account.
274      */
275     function Ownable() public {
276         owner = msg.sender;
277     }
278 
279     /**
280      * @dev Throws if called by any account other than the owner.
281      */
282     modifier onlyOwner() {
283         require(msg.sender == owner);
284         _;
285     }
286 
287     /**
288      * @dev Allows the current owner to transfer control of the contract to a newOwner.
289      * @param newOwner The address to transfer ownership to.
290      */
291     function transferOwnership(address newOwner) public onlyOwner {
292         require(newOwner != address(0));
293         emit OwnershipTransferred(owner, newOwner);
294         owner = newOwner;
295     }
296 
297 }
298 
299 
300 /**
301  * @title Pausable
302  * @dev Base contract which allows children to implement an emergency stop mechanism.
303  */
304 contract Pausable is Ownable {
305     event Pause();
306     event Unpause();
307 
308     bool public paused = false;
309 
310 
311     /**
312      * @dev Modifier to make a function callable only when the contract is not paused.
313      */
314     modifier whenNotPaused() {
315         require(!paused);
316         _;
317     }
318 
319     /**
320      * @dev Modifier to make a function callable only when the contract is paused.
321      */
322     modifier whenPaused() {
323         require(paused);
324         _;
325     }
326 
327     /**
328      * @dev called by the owner to pause, triggers stopped state
329      */
330     function pause() onlyOwner whenNotPaused public {
331         paused = true;
332         emit Pause();
333     }
334 
335     /**
336      * @dev called by the owner to unpause, returns to normal state
337      */
338     function unpause() onlyOwner whenPaused public {
339         paused = false;
340         emit Unpause();
341     }
342 }
343 
344 
345 /**
346  * @title Pausable token
347  * @dev StandardToken modified with pausable transfers.
348  **/
349 contract PausableToken is StandardToken, Pausable {
350 
351     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
352         return super.transfer(_to, _value);
353     }
354 
355     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
356         return super.transferFrom(_from, _to, _value);
357     }
358 
359     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
360         return super.approve(_spender, _value);
361     }
362 
363     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
364         return super.increaseApproval(_spender, _addedValue);
365     }
366 
367     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
368         return super.decreaseApproval(_spender, _subtractedValue);
369     }
370 }
371 
372 
373 /**
374  * @title airdrops
375  * @dev airdrops Smart Contract
376  */
377 contract airdrops is DetailedERC20, StandardToken, BurnableToken, PausableToken {
378 
379     /**
380     * Init token by setting its total supply
381     *
382     * @param totalSupply total token supply
383     */
384     function airdrops(
385         uint256 totalSupply
386     ) DetailedERC20(
387         "airdrops",
388         "AIRS",
389         4
390     ) {
391         totalSupply_ = totalSupply;
392         balances[msg.sender] = totalSupply;
393     }
394 }