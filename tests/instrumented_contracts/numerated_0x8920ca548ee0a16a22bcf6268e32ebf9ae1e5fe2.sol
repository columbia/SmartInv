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
11 
12     function balanceOf(address who) public view returns (uint256);
13 
14     function transfer(address to, uint256 value) public returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27     address public owner;
28 
29 
30     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32 
33     /**
34      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35      * account.
36      */
37     function Ownable() public {
38         owner = msg.sender;
39     }
40 
41     /**
42      * @dev Throws if called by any account other than the owner.
43      */
44     modifier onlyOwner() {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     /**
50      * @dev Allows the current owner to transfer control of the contract to a newOwner.
51      * @param newOwner The address to transfer ownership to.
52      */
53     function transferOwnership(address newOwner) public onlyOwner {
54         require(newOwner != address(0));
55         emit OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57     }
58 
59 }
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78 
79     /**
80     * @dev Multiplies two numbers, throws on overflow.
81     */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
83         if (a == 0) {
84             return 0;
85         }
86         c = a * b;
87         assert(c / a == b);
88         return c;
89     }
90 
91     /**
92     * @dev Integer division of two numbers, truncating the quotient.
93     */
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         // assert(b > 0); // Solidity automatically throws when dividing by 0
96         // uint256 c = a / b;
97         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98         return a / b;
99     }
100 
101     /**
102     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103     */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         assert(b <= a);
106         return a - b;
107     }
108 
109     /**
110     * @dev Adds two numbers, throws on overflow.
111     */
112     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
113         c = a + b;
114         assert(c >= a);
115         return c;
116     }
117 }
118 
119 
120 
121 /**
122  * @title Basic token
123  * @dev Basic version of StandardToken, with no allowances.
124  */
125 contract BasicToken is ERC20Basic {
126     using SafeMath for uint256;
127 
128     mapping(address => uint256) balances;
129 
130     uint256 totalSupply_;
131 
132     /**
133     * @dev total number of tokens in existence
134     */
135     function totalSupply() public view returns (uint256) {
136         return totalSupply_;
137     }
138 
139     /**
140     * @dev transfer token for a specified address
141     * @param _to The address to transfer to.
142     * @param _value The amount to be transferred.
143     */
144     function transfer(address _to, uint256 _value) public returns (bool) {
145         require(_to != address(0));
146         require(_value <= balances[msg.sender]);
147 
148         balances[msg.sender] = balances[msg.sender].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         emit Transfer(msg.sender, _to, _value);
151         return true;
152     }
153 
154     /**
155     * @dev Gets the balance of the specified address.
156     * @param _owner The address to query the the balance of.
157     * @return An uint256 representing the amount owned by the passed address.
158     */
159     function balanceOf(address _owner) public view returns (uint256) {
160         return balances[_owner];
161     }
162 
163 }
164 
165 
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 is ERC20Basic {
171     function allowance(address owner, address spender) public view returns (uint256);
172 
173     function transferFrom(address from, address to, uint256 value) public returns (bool);
174 
175     function approve(address spender, uint256 value) public returns (bool);
176 
177     event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 
181 /**
182  * @title Standard ERC20 token
183  *
184  * @dev Implementation of the basic standard token.
185  * @dev https://github.com/ethereum/EIPs/issues/20
186  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
187  */
188 contract StandardToken is ERC20, BasicToken {
189 
190     mapping(address => mapping(address => uint256)) internal allowed;
191 
192 
193     /**
194      * @dev Transfer tokens from one address to another
195      * @param _from address The address which you want to send tokens from
196      * @param _to address The address which you want to transfer to
197      * @param _value uint256 the amount of tokens to be transferred
198      */
199     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
200         require(_to != address(0));
201         require(_value <= balances[_from]);
202         require(_value <= allowed[_from][msg.sender]);
203 
204         balances[_from] = balances[_from].sub(_value);
205         balances[_to] = balances[_to].add(_value);
206         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207         emit Transfer(_from, _to, _value);
208         return true;
209     }
210 
211     /**
212      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213      *
214      * Beware that changing an allowance with this method brings the risk that someone may use both the old
215      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218      * @param _spender The address which will spend the funds.
219      * @param _value The amount of tokens to be spent.
220      */
221     function approve(address _spender, uint256 _value) public returns (bool) {
222         allowed[msg.sender][_spender] = _value;
223         emit Approval(msg.sender, _spender, _value);
224         return true;
225     }
226 
227     /**
228      * @dev Function to check the amount of tokens that an owner allowed to a spender.
229      * @param _owner address The address which owns the funds.
230      * @param _spender address The address which will spend the funds.
231      * @return A uint256 specifying the amount of tokens still available for the spender.
232      */
233     function allowance(address _owner, address _spender) public view returns (uint256) {
234         return allowed[_owner][_spender];
235     }
236 
237     /**
238      * @dev Increase the amount of tokens that an owner allowed to a spender.
239      *
240      * approve should be called when allowed[_spender] == 0. To increment
241      * allowed value is better to use this function to avoid 2 calls (and wait until
242      * the first transaction is mined)
243      * From MonolithDAO Token.sol
244      * @param _spender The address which will spend the funds.
245      * @param _addedValue The amount of tokens to increase the allowance by.
246      */
247     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
248         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250         return true;
251     }
252 
253     /**
254      * @dev Decrease the amount of tokens that an owner allowed to a spender.
255      *
256      * approve should be called when allowed[_spender] == 0. To decrement
257      * allowed value is better to use this function to avoid 2 calls (and wait until
258      * the first transaction is mined)
259      * From MonolithDAO Token.sol
260      * @param _spender The address which will spend the funds.
261      * @param _subtractedValue The amount of tokens to decrease the allowance by.
262      */
263     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
264         uint oldValue = allowed[msg.sender][_spender];
265         if (_subtractedValue > oldValue) {
266             allowed[msg.sender][_spender] = 0;
267         } else {
268             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
269         }
270         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271         return true;
272     }
273 
274 }
275 
276 
277 
278 
279 
280 
281 
282 /**
283  * @title Pausable
284  * @dev Base contract which allows children to implement an emergency stop mechanism.
285  */
286 contract Pausable is Ownable {
287     event Pause();
288     event Unpause();
289 
290     bool public paused = false;
291 
292 
293     /**
294      * @dev Modifier to make a function callable only when the contract is not paused.
295      */
296     modifier whenNotPaused() {
297         require(!paused);
298         _;
299     }
300 
301     /**
302      * @dev Modifier to make a function callable only when the contract is paused.
303      */
304     modifier whenPaused() {
305         require(paused);
306         _;
307     }
308 
309     /**
310      * @dev called by the owner to pause, triggers stopped state
311      */
312     function pause() onlyOwner whenNotPaused public {
313         paused = true;
314         emit Pause();
315     }
316 
317     /**
318      * @dev called by the owner to unpause, returns to normal state
319      */
320     function unpause() onlyOwner whenPaused public {
321         paused = false;
322         emit Unpause();
323     }
324 }
325 
326 
327 
328 /**
329  * @title Pausable token
330  * @dev StandardToken modified with pausable transfers.
331  **/
332 contract PausableToken is StandardToken, Pausable {
333 
334     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
335         return super.transfer(_to, _value);
336     }
337 
338     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
339         return super.transferFrom(_from, _to, _value);
340     }
341 
342     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
343         return super.approve(_spender, _value);
344     }
345 
346     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
347         return super.increaseApproval(_spender, _addedValue);
348     }
349 
350     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
351         return super.decreaseApproval(_spender, _subtractedValue);
352     }
353 }
354 
355 
356 contract DetailedERC20 is ERC20 {
357     string public name;
358     string public symbol;
359     uint8 public decimals;
360 
361     function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
362         name = _name;
363         symbol = _symbol;
364         decimals = _decimals;
365     }
366 }
367 
368 
369 contract TokenallCoin is PausableToken, DetailedERC20 {
370 
371     constructor() DetailedERC20("TokenallCoin", "TALL", 18){
372         totalSupply_ = 10000000000 * 10 ** 18;
373         balances[msg.sender] = totalSupply();
374     }
375 
376 }