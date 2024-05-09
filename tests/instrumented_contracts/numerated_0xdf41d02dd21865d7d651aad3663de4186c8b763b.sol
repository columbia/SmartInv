1 pragma solidity ^0.4.18;
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
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22             return 0;
23         }
24         uint256 c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 
49 
50 /**
51  * @title Basic contracts
52  * @dev Basic version of StandardToken, with no allowances.
53  */
54 contract BasicToken is ERC20Basic {
55     using SafeMath for uint256;
56 
57     mapping(address => uint256) balances;
58 
59     /**
60     * @dev transfer contracts for a specified address
61     * @param _to The address to transfer to.
62     * @param _value The amount to be transferred.
63     */
64     function transfer(address _to, uint256 _value) public returns (bool) {
65         require(_to != address(0));
66         require(_value <= balances[msg.sender]);
67 
68         // SafeMath.sub will throw if there is not enough balance.
69         balances[msg.sender] = balances[msg.sender].sub(_value);
70         balances[_to] = balances[_to].add(_value);
71         emit Transfer(msg.sender, _to, _value);
72         return true;
73     }
74 
75     /**
76     * @dev Gets the balance of the specified address.
77     * @param _owner The address to query the the balance of.
78     * @return An uint256 representing the amount owned by the passed address.
79     */
80     function balanceOf(address _owner) public view returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84 }
85 
86 
87 /**
88  * @title Burnable Token
89  * @dev Token that can be irreversibly burned (destroyed).
90  */
91 contract BurnableToken is BasicToken {
92 
93     event Burn(address indexed burner, uint256 value);
94 
95     /**
96      * @dev Burns a specific amount of tokens.
97      * @param _value The amount of contracts to be burned.
98      */
99     function burn(uint256 _value) public {
100         require(_value <= balances[msg.sender]);
101         // no need to require value <= totalSupply, since that would imply the
102         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
103 
104         address burner = msg.sender;
105         balances[burner] = balances[burner].sub(_value);
106         totalSupply = totalSupply.sub(_value);
107         emit Burn(burner, _value);
108     }
109 }
110 
111 
112 /**
113  * @title ERC20 interface
114  * @dev see https://github.com/ethereum/EIPs/issues/20
115  */
116 contract ERC20 is ERC20Basic {
117     function allowance(address owner, address spender) public view returns (uint256);
118     function transferFrom(address from, address to, uint256 value) public returns (bool);
119     function approve(address spender, uint256 value) public returns (bool);
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 
124 
125 /**
126  * @title Standard ERC20 contracts
127  *
128  * @dev Implementation of the basic standard contracts.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134     mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137     /**
138      * @dev Transfer tokens from one address to another
139      * @param _from address The address which you want to send tokens from
140      * @param _to address The address which you want to transfer to
141      * @param _value uint256 the amount of tokens to be transferred
142      */
143     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144         require(_to != address(0));
145         require(_value <= balances[_from]);
146         require(_value <= allowed[_from][msg.sender]);
147 
148         balances[_from] = balances[_from].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151         emit Transfer(_from, _to, _value);
152         return true;
153     }
154 
155     /**
156      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157      *
158      * Beware that changing an allowance with this method brings the risk that someone may use both the old
159      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      * @param _spender The address which will spend the funds.
163      * @param _value The amount of tokens to be spent.
164      */
165     function approve(address _spender, uint256 _value) public returns (bool) {
166         allowed[msg.sender][_spender] = _value;
167         emit Approval(msg.sender, _spender, _value);
168         return true;
169     }
170 
171     /**
172      * @dev Function to check the amount of tokens that an owner allowed to a spender.
173      * @param _owner address The address which owns the funds.
174      * @param _spender address The address which will spend the funds.
175      * @return A uint256 specifying the amount of tokens still available for the spender.
176      */
177     function allowance(address _owner, address _spender) public view returns (uint256) {
178         return allowed[_owner][_spender];
179     }
180 
181     /**
182      * @dev Increase the amount of tokens that an owner allowed to a spender.
183      *
184      * approve should be called when allowed[_spender] == 0. To increment
185      * allowed value is better to use this function to avoid 2 calls (and wait until
186      * the first transaction is mined)
187      * From MonolithDAO Token.sol
188      * @param _spender The address which will spend the funds.
189      * @param _addedValue The amount of tokens to increase the allowance by.
190      */
191     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
192         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
193         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194         return true;
195     }
196 
197     /**
198      * @dev Decrease the amount of tokens that an owner allowed to a spender.
199      *
200      * approve should be called when allowed[_spender] == 0. To decrement
201      * allowed value is better to use this function to avoid 2 calls (and wait until
202      * the first transaction is mined)
203      * From MonolithDAO Token.sol
204      * @param _spender The address which will spend the funds.
205      * @param _subtractedValue The amount of tokens to decrease the allowance by.
206      */
207     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
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
220 /**
221  * @title Ownable
222  * @dev The Ownable contract has an owner address, and provides basic authorization control
223  * functions, this simplifies the implementation of "user permissions".
224  */
225 contract Ownable {
226     address public owner;
227 
228 
229     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
230 
231 
232     /**
233      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
234      * account.
235      */
236     function Ownable() public {
237         owner = msg.sender;
238     }
239 
240 
241     /**
242      * @dev Throws if called by any account other than the owner.
243      */
244     modifier onlyOwner() {
245         require(msg.sender == owner);
246         _;
247     }
248 
249 
250     /**
251      * @dev Allows the current owner to transfer control of the contract to a newOwner.
252      * @param newOwner The address to transfer ownership to.
253      */
254     function transferOwnership(address newOwner) public onlyOwner {
255         require(newOwner != address(0));
256         emit OwnershipTransferred(owner, newOwner);
257         owner = newOwner;
258     }
259 
260 }
261 
262 
263 
264 /**
265  * @title Pausable
266  * @dev Base contract which allows children to implement an emergency stop mechanism.
267  */
268 contract Pausable is Ownable {
269     event Pause();
270     event Unpause();
271 
272     bool public paused = false;
273 
274 
275     /**
276      * @dev Modifier to make a function callable only when the contract is not paused.
277      */
278     modifier whenNotPaused() {
279         require(!paused);
280         _;
281     }
282 
283     /**
284      * @dev Modifier to make a function callable only when the contract is paused.
285      */
286     modifier whenPaused() {
287         require(paused);
288         _;
289     }
290 
291     /**
292      * @dev called by the owner to pause, triggers stopped state
293      */
294     function pause() onlyOwner whenNotPaused public {
295         paused = true;
296         emit Pause();
297     }
298 
299     /**
300      * @dev called by the owner to unpause, returns to normal state
301      */
302     function unpause() onlyOwner whenPaused public {
303         paused = false;
304         emit Unpause();
305     }
306 }
307 
308 
309 /**
310  * @title Pausable token
311  *
312  * @dev StandardToken modified with pausable transfers.
313  **/
314 
315 contract PausableToken is StandardToken, Pausable {
316 
317     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
318         return super.transfer(_to, _value);
319     }
320 
321     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
322         return super.transferFrom(_from, _to, _value);
323     }
324 
325     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
326         return super.approve(_spender, _value);
327     }
328 
329     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
330         return super.increaseApproval(_spender, _addedValue);
331     }
332 
333     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
334         return super.decreaseApproval(_spender, _subtractedValue);
335     }
336 
337 }
338 
339 contract PAXToken is BurnableToken, PausableToken {
340 
341     using SafeMath for uint;
342 
343     string public constant name = "Pax Token";
344 
345     string public constant symbol = "PAX";
346 
347     uint32 public constant decimals = 10;
348 
349     uint256 public constant INITIAL_SUPPLY = 999500000 * (10 ** uint256(decimals));
350 
351     /**
352      * @dev Constructor that gives msg.sender all of existing tokens.
353      * @param _isPause bool (pause === true)
354      */
355     function PAXToken(bool _isPause) public {
356         paused = _isPause;
357         totalSupply = INITIAL_SUPPLY;
358         balances[msg.sender] = INITIAL_SUPPLY;
359         emit Transfer(0x0, msg.sender, balances[msg.sender]);
360 
361     }
362 
363     /**
364     * @dev transfer contracts for a specified address, despite the pause state
365     * @param _to The address to transfer to.
366     * @param _value The amount to be transferred.
367     */
368     function ownersTransfer(address _to, uint256 _value) public onlyOwner returns (bool) {
369         return BasicToken.transfer(_to, _value);
370     }
371 }