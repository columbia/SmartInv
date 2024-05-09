1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40 
41     event OwnershipRenounced(address indexed previousOwner);
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46 
47     /**
48      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49      * account.
50      */
51     constructor() public {
52         owner = msg.sender;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     /**
64      * @dev Allows the current owner to relinquish control of the contract.
65      * @notice Renouncing to ownership will leave the contract without an owner.
66      * It will not be possible to call the functions with the `onlyOwner`
67      * modifier anymore.
68      */
69     function renounceOwnership() public onlyOwner {
70         emit OwnershipRenounced(owner);
71         owner = address(0);
72     }
73 
74     /**
75      * @dev Allows the current owner to transfer control of the contract to a newOwner.
76      * @param _newOwner The address to transfer ownership to.
77      */
78     function transferOwnership(address _newOwner) public onlyOwner {
79         _transferOwnership(_newOwner);
80     }
81 
82     /**
83      * @dev Transfers control of the contract to a newOwner.
84      * @param _newOwner The address to transfer ownership to.
85      */
86     function _transferOwnership(address _newOwner) internal {
87         require(_newOwner != address(0));
88         emit OwnershipTransferred(owner, _newOwner);
89         owner = _newOwner;
90     }
91 }
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * See https://github.com/ethereum/EIPs/issues/179
97  */
98 contract ERC20Basic {
99     function totalSupply() public view returns (uint256);
100     function balanceOf(address who) public view returns (uint256);
101     function transfer(address to, uint256 value) public returns (bool);
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110     function allowance(address owner, address spender)
111         public view returns (uint256);
112 
113     function transferFrom(address from, address to, uint256 value)
114         public returns (bool);
115 
116     function approve(address spender, uint256 value) public returns (bool);
117     event Approval(
118         address indexed owner,
119         address indexed spender,
120         uint256 value
121     );
122 }
123 
124 /**
125  * @title Basic token
126  * @dev Basic version of StandardToken, with no allowances.
127  */
128 contract BasicToken is ERC20Basic {
129     using SafeMath for uint256;
130 
131     mapping(address => uint256) balances;
132 
133     uint256 totalSupply_;
134 
135     /**
136     * @dev Total number of tokens in existence
137     */
138     function totalSupply() public view returns (uint256) {
139         return totalSupply_;
140     }
141 
142     /**
143     * @dev Transfer token for a specified address
144     * @param _to The address to transfer to.
145     * @param _value The amount to be transferred.
146     */
147     function transfer(address _to, uint256 _value) public returns (bool) {
148         require(_to != address(0));
149         require(_value <= balances[msg.sender]);
150 
151         balances[msg.sender] = balances[msg.sender].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153         emit Transfer(msg.sender, _to, _value);
154         return true;
155     }
156 
157     /**
158     * @dev Gets the balance of the specified address.
159     * @param _owner The address to query the the balance of.
160     * @return An uint256 representing the amount owned by the passed address.
161     */
162     function balanceOf(address _owner) public view returns (uint256) {
163         return balances[_owner];
164     }
165 }
166 
167 /**
168  * @title Standard ERC20 token
169  *
170  * @dev Implementation of the basic standard token.
171  * https://github.com/ethereum/EIPs/issues/20
172  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
173  */
174 contract StandardToken is ERC20, BasicToken {
175 
176     mapping (address => mapping (address => uint256)) internal allowed;
177 
178     /**
179     * @dev Transfer tokens from one address to another
180     * @param _from address The address which you want to send tokens from
181     * @param _to address The address which you want to transfer to
182     * @param _value uint256 the amount of tokens to be transferred
183     */
184     function transferFrom(
185         address _from,
186         address _to,
187         uint256 _value
188     ) public returns (bool) {
189         require(_to != address(0));
190         require(_value <= balances[_from]);
191         require(_value <= allowed[_from][msg.sender]);
192 
193         balances[_from] = balances[_from].sub(_value);
194         balances[_to] = balances[_to].add(_value);
195         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196         emit Transfer(_from, _to, _value);
197         return true;
198     }
199 
200     /**
201     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202     * Beware that changing an allowance with this method brings the risk that someone may use both the old
203     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206     * @param _spender The address which will spend the funds.
207     * @param _value The amount of tokens to be spent.
208     */
209     function approve(address _spender, uint256 _value) public returns (bool) {
210         allowed[msg.sender][_spender] = _value;
211         emit Approval(msg.sender, _spender, _value);
212         return true;
213     }
214 
215     /**
216     * @dev Function to check the amount of tokens that an owner allowed to a spender.
217     * @param _owner address The address which owns the funds.
218     * @param _spender address The address which will spend the funds.
219     * @return A uint256 specifying the amount of tokens still available for the spender.
220     */
221     function allowance(
222         address _owner,
223         address _spender
224     ) public view returns (uint256) {
225         return allowed[_owner][_spender];
226     }
227 
228     /**
229     * @dev Increase the amount of tokens that an owner allowed to a spender.
230     * approve should be called when allowed[_spender] == 0. To increment
231     * allowed value is better to use this function to avoid 2 calls (and wait until
232     * the first transaction is mined)
233     * From MonolithDAO Token.sol
234     * @param _spender The address which will spend the funds.
235     * @param _addedValue The amount of tokens to increase the allowance by.
236     */
237     function increaseApproval(
238         address _spender,
239         uint256 _addedValue
240     ) public returns (bool) {
241         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
242         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243         return true;
244     }
245 
246     /**
247     * @dev Decrease the amount of tokens that an owner allowed to a spender.
248     * approve should be called when allowed[_spender] == 0. To decrement
249     * allowed value is better to use this function to avoid 2 calls (and wait until
250     * the first transaction is mined)
251     * From MonolithDAO Token.sol
252     * @param _spender The address which will spend the funds.
253     * @param _subtractedValue The amount of tokens to decrease the allowance by.
254     */
255     function decreaseApproval(
256         address _spender,
257         uint256 _subtractedValue
258     ) public returns (bool) {
259         uint256 oldValue = allowed[msg.sender][_spender];
260         if (_subtractedValue > oldValue) {
261             allowed[msg.sender][_spender] = 0;
262         } else {
263             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264         }
265         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266         return true;
267     }
268 }
269 
270 /**
271  * @title Pausable
272  * @dev Base contract which allows children to implement an emergency stop mechanism.
273  */
274 contract Pausable is Ownable {
275     event Pause();
276     event Unpause();
277 
278     bool public paused = false;
279 
280     /**
281     * @dev Modifier to make a function callable only when the contract is not paused.
282     */
283     modifier whenNotPaused() {
284         require(!paused);
285         _;
286     }
287 
288     /**
289     * @dev Modifier to make a function callable only when the contract is paused.
290     */
291     modifier whenPaused() {
292         require(paused);
293         _;
294     }
295 
296     /**
297     * @dev called by the owner to pause, triggers stopped state
298     */
299     function pause() onlyOwner whenNotPaused public {
300         paused = true;
301         emit Pause();
302     }
303 
304     /**
305     * @dev called by the owner to unpause, returns to normal state
306     */
307     function unpause() onlyOwner whenPaused public {
308         paused = false;
309         emit Unpause();
310     }
311 }
312 
313 /**
314  * @title Pausable token
315  * @dev StandardToken modified with pausable transfers.
316  **/
317 contract PausableToken is StandardToken, Pausable {
318 
319     function transfer(
320         address _to,
321         uint256 _value
322     ) public whenNotPaused returns (bool) {
323         return super.transfer(_to, _value);
324     }
325 
326     function transferFrom(
327         address _from,
328         address _to,
329         uint256 _value
330     ) public whenNotPaused returns (bool) {
331         return super.transferFrom(_from, _to, _value);
332     }
333 
334     function approve(
335         address _spender,
336         uint256 _value
337     ) public whenNotPaused returns (bool) {
338         return super.approve(_spender, _value);
339     }
340 
341     function increaseApproval(
342         address _spender,
343         uint _addedValue
344     ) public whenNotPaused returns (bool success) {
345         return super.increaseApproval(_spender, _addedValue);
346     }
347 
348     function decreaseApproval(
349         address _spender,
350         uint _subtractedValue
351     ) public whenNotPaused returns (bool success) {
352         return super.decreaseApproval(_spender, _subtractedValue);
353     }
354 }
355 
356 /**
357  * @title DCoinFax Token
358  */
359 contract DCoinFaxToken is PausableToken {
360     string public constant name = "DCoinFax Token";
361     string public constant symbol = "DFXT";
362     uint8 public constant decimals = 18;
363     uint256 public totalSupply = 50 * 10000 * 10000 * (10 ** uint256(decimals));
364 
365     /**
366      * Constructor function
367      *
368      * Initializes contract with initial supply tokens to the initialTokenOwner
369      */
370     constructor (
371         address initialTokenOwner
372     ) public {
373         balances[initialTokenOwner] = totalSupply;             // Give the initialTokenOwner all initial tokens
374         emit Transfer(0x0, initialTokenOwner, totalSupply);
375     }
376 
377     /**
378      * Allows the current owner to transfer control of the contract to a newOwner.
379      * @param newOwner The address to transfer ownership to.
380      */
381     function transferOwnership(address newOwner) onlyOwner whenNotPaused public {
382         super.transferOwnership(newOwner);
383     }
384 }