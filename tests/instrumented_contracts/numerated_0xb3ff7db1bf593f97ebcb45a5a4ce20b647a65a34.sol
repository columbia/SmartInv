1 pragma solidity ^0.4.21;
2 
3 // -----------------
4 //begin Ownable.sol
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12     address public owner;
13 
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18     /**
19      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20      * account.
21      */
22 //    function Ownable() public {
23 //        owner = msg.sender;
24 //    }
25 
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     /**
35      * @dev Allows the current owner to transfer control of the contract to a newOwner.
36      * @param newOwner The address to transfer ownership to.
37      */
38     function transferOwnership(address newOwner) public onlyOwner {
39         require(newOwner != address(0));
40         emit OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42     }
43 
44 }
45 
46 //end Ownable.sol
47 // -----------------
48 //begin ERC20Basic.sol
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56     function totalSupply() public view returns (uint256);
57     function balanceOf(address who) public view returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 //end ERC20Basic.sol
63 // -----------------
64 //begin SafeMath.sol
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72     /**
73     * @dev Multiplies two numbers, throws on overflow.
74     */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         if (a == 0) {
77             return 0;
78         }
79         uint256 c = a * b;
80         assert(c / a == b);
81         return c;
82     }
83 
84     /**
85     * @dev Integer division of two numbers, truncating the quotient.
86     */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         // assert(b > 0); // Solidity automatically throws when dividing by 0
89         // uint256 c = a / b;
90         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91         return a / b;
92     }
93 
94     /**
95     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96     */
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         assert(b <= a);
99         return a - b;
100     }
101 
102     /**
103     * @dev Adds two numbers, throws on overflow.
104     */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         assert(c >= a);
108         return c;
109     }
110 }
111 
112 //end SafeMath.sol
113 // -----------------
114 //begin Pausable.sol
115 
116 
117 
118 /**
119  * @title Pausable
120  * @dev Base contract which allows children to implement an emergency stop mechanism.
121  */
122 contract Pausable is Ownable {
123     event Pause();
124     event Unpause();
125 
126     bool public paused = false;
127 
128 
129     /**
130      * @dev Modifier to make a function callable only when the contract is not paused.
131      */
132     modifier whenNotPaused() {
133         require(!paused);
134         _;
135     }
136 
137     /**
138      * @dev Modifier to make a function callable only when the contract is paused.
139      */
140     modifier whenPaused() {
141         require(paused);
142         _;
143     }
144 
145     /**
146      * @dev called by the owner to pause, triggers stopped state
147      */
148     function pause() onlyOwner whenNotPaused public {
149         paused = true;
150         emit Pause();
151     }
152 
153     /**
154      * @dev called by the owner to unpause, returns to normal state
155      */
156     function unpause() onlyOwner whenPaused public {
157         paused = false;
158         emit Unpause();
159     }
160 }
161 
162 //end Pausable.sol
163 // -----------------
164 //begin BasicToken.sol
165 
166 
167 
168 /**
169  * @title Basic token
170  * @dev Basic version of StandardToken, with no allowances.
171  */
172 contract BasicToken is ERC20Basic {
173     using SafeMath for uint256;
174 
175     mapping(address => uint256) balances;
176 
177     uint256 totalSupply_;
178 
179     /**
180     * @dev total number of tokens in existence
181     */
182     function totalSupply() public view returns (uint256) {
183         return totalSupply_;
184     }
185 
186     /**
187     * @dev transfer token for a specified address
188     * @param _to The address to transfer to.
189     * @param _value The amount to be transferred.
190     */
191     function transfer(address _to, uint256 _value) public returns (bool) {
192         require(_to != address(0));
193         require(_value <= balances[msg.sender]);
194 
195         balances[msg.sender] = balances[msg.sender].sub(_value);
196         balances[_to] = balances[_to].add(_value);
197         emit Transfer(msg.sender, _to, _value);
198         return true;
199     }
200 
201     /**
202     * @dev Gets the balance of the specified address.
203     * @param _owner The address to query the the balance of.
204     * @return An uint256 representing the amount owned by the passed address.
205     */
206     function balanceOf(address _owner) public view returns (uint256 balance) {
207         return balances[_owner];
208     }
209 
210 }
211 
212 //end BasicToken.sol
213 // -----------------
214 //begin ERC20.sol
215 
216 
217 /**
218  * @title ERC20 interface
219  * @dev see https://github.com/ethereum/EIPs/issues/20
220  */
221 contract ERC20 is ERC20Basic {
222     function allowance(address owner, address spender) public view returns (uint256);
223     function transferFrom(address from, address to, uint256 value) public returns (bool);
224     function approve(address spender, uint256 value) public returns (bool);
225     event Approval(address indexed owner, address indexed spender, uint256 value);
226 }
227 
228 //end ERC20.sol
229 // -----------------
230 //begin StandardToken.sol
231 
232 
233 /**
234  * @title Standard ERC20 token
235  *
236  * @dev Implementation of the basic standard token.
237  * @dev https://github.com/ethereum/EIPs/issues/20
238  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
239  */
240 contract StandardToken is ERC20, BasicToken {
241 
242     mapping (address => mapping (address => uint256)) internal allowed;
243 
244 
245     /**
246      * @dev Transfer tokens from one address to another
247      * @param _from address The address which you want to send tokens from
248      * @param _to address The address which you want to transfer to
249      * @param _value uint256 the amount of tokens to be transferred
250      */
251     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
252         require(_to != address(0));
253         require(_value <= balances[_from]);
254         require(_value <= allowed[_from][msg.sender]);
255 
256         balances[_from] = balances[_from].sub(_value);
257         balances[_to] = balances[_to].add(_value);
258         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
259         emit Transfer(_from, _to, _value);
260         return true;
261     }
262 
263     /**
264      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
265      *
266      * Beware that changing an allowance with this method brings the risk that someone may use both the old
267      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
268      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
269      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270      * @param _spender The address which will spend the funds.
271      * @param _value The amount of tokens to be spent.
272      */
273     function approve(address _spender, uint256 _value) public returns (bool) {
274         allowed[msg.sender][_spender] = _value;
275         emit Approval(msg.sender, _spender, _value);
276         return true;
277     }
278 
279     /**
280      * @dev Function to check the amount of tokens that an owner allowed to a spender.
281      * @param _owner address The address which owns the funds.
282      * @param _spender address The address which will spend the funds.
283      * @return A uint256 specifying the amount of tokens still available for the spender.
284      */
285     function allowance(address _owner, address _spender) public view returns (uint256) {
286         return allowed[_owner][_spender];
287     }
288 
289     /**
290      * @dev Increase the amount of tokens that an owner allowed to a spender.
291      *
292      * approve should be called when allowed[_spender] == 0. To increment
293      * allowed value is better to use this function to avoid 2 calls (and wait until
294      * the first transaction is mined)
295      * From MonolithDAO Token.sol
296      * @param _spender The address which will spend the funds.
297      * @param _addedValue The amount of tokens to increase the allowance by.
298      */
299     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
300         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
301         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302         return true;
303     }
304 
305     /**
306      * @dev Decrease the amount of tokens that an owner allowed to a spender.
307      *
308      * approve should be called when allowed[_spender] == 0. To decrement
309      * allowed value is better to use this function to avoid 2 calls (and wait until
310      * the first transaction is mined)
311      * From MonolithDAO Token.sol
312      * @param _spender The address which will spend the funds.
313      * @param _subtractedValue The amount of tokens to decrease the allowance by.
314      */
315     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
316         uint oldValue = allowed[msg.sender][_spender];
317         if (_subtractedValue > oldValue) {
318             allowed[msg.sender][_spender] = 0;
319         } else {
320             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
321         }
322         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
323         return true;
324     }
325 
326 }
327 
328 
329 /**
330  * @title Pausable token
331  * @dev StandardToken modified with pausable transfers.
332  **/
333 contract PausableToken is StandardToken, Pausable {
334 
335     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
336         return super.transfer(_to, _value);
337     }
338 
339     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
340         return super.transferFrom(_from, _to, _value);
341     }
342 
343     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
344         return super.approve(_spender, _value);
345     }
346 
347     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
348         return super.increaseApproval(_spender, _addedValue);
349     }
350 
351     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
352         return super.decreaseApproval(_spender, _subtractedValue);
353     }
354 }
355 
356 
357 
358 
359 contract MBCToken is  PausableToken {
360     string public name = "MBC";
361     string public symbol = "MCOIN";
362     uint256 public decimals = 18;
363 
364     using SafeMath for uint256;
365 
366     function MBCToken() public {
367         totalSupply_ = 5000000000*1e18;
368         owner = 0x30A1017b1Fab6d84BcDbC78851B7562260Ff4046;
369         balances[owner] = totalSupply_;
370 
371     }
372 
373     function () public payable {
374         revert();
375     }
376 
377 }