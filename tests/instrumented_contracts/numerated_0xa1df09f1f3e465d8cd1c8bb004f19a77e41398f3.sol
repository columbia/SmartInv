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
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
88 }
89 
90 /**
91  * @title Pausable
92  * @dev Base contract which allows children to implement an emergency stop mechanism.
93  */
94 contract Pausable is Ownable {
95     event Pause();
96     event Unpause();
97 
98     bool public paused = false;
99 
100 
101     /**
102      * @dev Modifier to make a function callable only when the contract is not paused.
103      */
104     modifier whenNotPaused() {
105         require(!paused);
106         _;
107     }
108 
109     /**
110      * @dev Modifier to make a function callable only when the contract is paused.
111      */
112     modifier whenPaused() {
113         require(paused);
114         _;
115     }
116 
117     /**
118      * @dev called by the owner to pause, triggers stopped state
119      */
120     function pause() onlyOwner whenNotPaused public {
121         paused = true;
122         Pause();
123     }
124 
125     /**
126      * @dev called by the owner to unpause, returns to normal state
127      */
128     function unpause() onlyOwner whenPaused public {
129         paused = false;
130         Unpause();
131     }
132 }
133 
134 
135 
136 
137 
138 /**
139  * @title ERC20Basic
140  * @dev Simpler version of ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/179
142  */
143 contract ERC20Basic {
144     function totalSupply() public view returns (uint256);
145     function balanceOf(address who) public view returns (uint256);
146     function transfer(address to, uint256 value) public returns (bool);
147     event Transfer(address indexed from, address indexed to, uint256 value);
148 }
149 
150 
151 
152 /**
153  * @title ERC20 interface
154  * @dev see https://github.com/ethereum/EIPs/issues/20
155  */
156 contract ERC20 is ERC20Basic {
157     function allowance(address owner, address spender) public view returns (uint256);
158     function transferFrom(address from, address to, uint256 value) public returns (bool);
159     function approve(address spender, uint256 value) public returns (bool);
160     event Approval(address indexed owner, address indexed spender, uint256 value);
161 }
162 
163 
164 contract DetailedERC20 is ERC20 {
165     string public name;
166     string public symbol;
167     uint8 public decimals;
168 
169     function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
170         name = _name;
171         symbol = _symbol;
172         decimals = _decimals;
173     }
174 }
175 
176 
177 
178 
179 /**
180  * @title Basic token
181  * @dev Basic version of StandardToken, with no allowances.
182  */
183 contract BasicToken is ERC20Basic {
184     using SafeMath for uint256;
185 
186     mapping(address => uint256) balances;
187 
188     uint256 totalSupply_;
189 
190     /**
191     * @dev total number of tokens in existence
192     */
193     function totalSupply() public view returns (uint256) {
194         return totalSupply_;
195     }
196 
197     /**
198     * @dev transfer token for a specified address
199     * @param _to The address to transfer to.
200     * @param _value The amount to be transferred.
201     */
202     function transfer(address _to, uint256 _value) public returns (bool) {
203         require(_to != address(0));
204         require(_value <= balances[msg.sender]);
205 
206         // SafeMath.sub will throw if there is not enough balance.
207         balances[msg.sender] = balances[msg.sender].sub(_value);
208         balances[_to] = balances[_to].add(_value);
209         Transfer(msg.sender, _to, _value);
210         return true;
211     }
212 
213     /**
214     * @dev Gets the balance of the specified address.
215     * @param _owner The address to query the the balance of.
216     * @return An uint256 representing the amount owned by the passed address.
217     */
218     function balanceOf(address _owner) public view returns (uint256 balance) {
219         return balances[_owner];
220     }
221 
222 }
223 
224 /**
225  * @title Standard ERC20 token
226  *
227  * @dev Implementation of the basic standard token.
228  * @dev https://github.com/ethereum/EIPs/issues/20
229  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
230  */
231 contract StandardToken is ERC20, BasicToken {
232 
233     mapping (address => mapping (address => uint256)) internal allowed;
234 
235 
236     /**
237      * @dev Transfer tokens from one address to another
238      * @param _from address The address which you want to send tokens from
239      * @param _to address The address which you want to transfer to
240      * @param _value uint256 the amount of tokens to be transferred
241      */
242     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
243         require(_to != address(0));
244         require(_value <= balances[_from]);
245         require(_value <= allowed[_from][msg.sender]);
246 
247         balances[_from] = balances[_from].sub(_value);
248         balances[_to] = balances[_to].add(_value);
249         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
250         Transfer(_from, _to, _value);
251         return true;
252     }
253 
254     /**
255      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
256      *
257      * Beware that changing an allowance with this method brings the risk that someone may use both the old
258      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
259      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
260      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261      * @param _spender The address which will spend the funds.
262      * @param _value The amount of tokens to be spent.
263      */
264     function approve(address _spender, uint256 _value) public returns (bool) {
265         allowed[msg.sender][_spender] = _value;
266         Approval(msg.sender, _spender, _value);
267         return true;
268     }
269 
270     /**
271      * @dev Function to check the amount of tokens that an owner allowed to a spender.
272      * @param _owner address The address which owns the funds.
273      * @param _spender address The address which will spend the funds.
274      * @return A uint256 specifying the amount of tokens still available for the spender.
275      */
276     function allowance(address _owner, address _spender) public view returns (uint256) {
277         return allowed[_owner][_spender];
278     }
279 
280     /**
281      * @dev Increase the amount of tokens that an owner allowed to a spender.
282      *
283      * approve should be called when allowed[_spender] == 0. To increment
284      * allowed value is better to use this function to avoid 2 calls (and wait until
285      * the first transaction is mined)
286      * From MonolithDAO Token.sol
287      * @param _spender The address which will spend the funds.
288      * @param _addedValue The amount of tokens to increase the allowance by.
289      */
290     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
291         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
292         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
293         return true;
294     }
295 
296     /**
297      * @dev Decrease the amount of tokens that an owner allowed to a spender.
298      *
299      * approve should be called when allowed[_spender] == 0. To decrement
300      * allowed value is better to use this function to avoid 2 calls (and wait until
301      * the first transaction is mined)
302      * From MonolithDAO Token.sol
303      * @param _spender The address which will spend the funds.
304      * @param _subtractedValue The amount of tokens to decrease the allowance by.
305      */
306     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
307         uint oldValue = allowed[msg.sender][_spender];
308         if (_subtractedValue > oldValue) {
309             allowed[msg.sender][_spender] = 0;
310         } else {
311             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
312         }
313         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314         return true;
315     }
316 
317 }
318 
319 
320 
321 
322 contract PausableToken is StandardToken, Pausable {
323 
324     modifier whenNotPausedOrOnlyOwner() {
325         require(!paused || msg.sender == owner);
326         _;
327     }
328 
329     /**
330     * @dev Transfer token for a specified address with pause feature for owner.
331     * @dev Only applies when the transfer is allowed by the owner.
332     * @param _to The address to transfer to.
333     * @param _value The amount to be transferred.
334     */
335     function transfer(address _to, uint256 _value) public whenNotPausedOrOnlyOwner returns (bool) {
336         return super.transfer(_to, _value);
337     }
338 
339     /**
340     * @dev Transfer tokens from one address to another with pause feature for owner.
341     * @dev Only applies when the transfer is allowed by the owner.
342     * @param _from address The address which you want to send tokens from
343     * @param _to address The address which you want to transfer to
344     * @param _value uint256 the amount of tokens to be transferred
345     */
346     function transferFrom(address _from, address _to, uint256 _value) public whenNotPausedOrOnlyOwner returns (bool) {
347         return super.transferFrom(_from, _to, _value);
348     }
349 }
350 
351 
352 
353 contract ClassicToken is DetailedERC20, PausableToken {
354 
355     uint256 public initialTotalSupply;
356 
357     function ClassicToken(string name, string symbol, uint8 decimals, uint tokens) DetailedERC20(name, symbol, decimals) public {
358         pause();
359 
360         initialTotalSupply = tokens * (uint256(10) ** decimals);
361         totalSupply_ = initialTotalSupply;
362         balances[msg.sender] = initialTotalSupply;
363         Transfer(address(0), msg.sender, initialTotalSupply);
364     }
365 }
366 
367 
368 
369 
370 contract DTToken is ClassicToken {
371 
372     function DTToken() ClassicToken("DTToken", "DTT", 18, 3e6) public {}
373 }