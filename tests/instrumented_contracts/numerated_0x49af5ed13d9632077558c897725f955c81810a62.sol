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
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20     function allowance(address owner, address spender) public view returns (uint256);
21     function transferFrom(address from, address to, uint256 value) public returns (bool);
22     function approve(address spender, uint256 value) public returns (bool);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36         uint256 c = a * b;
37         assert(c / a == b);
38         return c;
39     }
40 
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         // assert(b > 0); // Solidity automatically throws when dividing by 0
43         uint256 c = a / b;
44         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         assert(b <= a);
50         return a - b;
51     }
52 
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         assert(c >= a);
56         return c;
57     }
58 }
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65     using SafeMath for uint256;
66 
67     mapping(address => uint256) balances;
68 
69     /**
70     * @dev transfer token for a specified address
71     * @param _to The address to transfer to.
72     * @param _value The amount to be transferred.
73     */
74     function transfer(address _to, uint256 _value) public returns (bool) {
75         require(_to != address(0));
76         require(_value <= balances[msg.sender]);
77 
78         // SafeMath.sub will throw if there is not enough balance.
79         balances[msg.sender] = balances[msg.sender].sub(_value);
80         balances[_to] = balances[_to].add(_value);
81         Transfer(msg.sender, _to, _value);
82         return true;
83     }
84 
85     /**
86     * @dev Gets the balance of the specified address.
87     * @param _owner The address to query the the balance of.
88     * @return An uint256 representing the amount owned by the passed address.
89     */
90     function balanceOf(address _owner) public view returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94 }
95 
96 /**
97  * @title Burnable Token
98  * @dev Token that can be irreversibly burned (destroyed).
99  */
100 contract BurnableToken is BasicToken {
101 
102     event Burn(address indexed burner, uint256 value);
103 
104     /**
105     * @dev Burns a specific amount of tokens.
106     * @param _value The amount of token to be burned.
107     */
108     function burn(uint256 _value) public {
109         require(_value <= balances[msg.sender]);
110         // no need to require value <= totalSupply, since that would imply the
111         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
112 
113         address burner = msg.sender;
114         balances[burner] = balances[burner].sub(_value);
115         totalSupply = totalSupply.sub(_value);
116         Burn(burner, _value);
117     }
118 }
119 
120 /**
121  * @title Ownable
122  * @dev The Ownable contract has an owner address, and provides basic authorization control
123  * functions, this simplifies the implementation of "user permissions".
124  */
125 contract Ownable {
126     address public owner;
127 
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131 
132     /**
133     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
134     * account.
135     */
136     function Ownable() public {
137         owner = msg.sender;
138     }
139 
140 
141     /**
142     * @dev Throws if called by any account other than the owner.
143     */
144     modifier onlyOwner() {
145         require(msg.sender == owner);
146         _;
147     }
148 
149 
150     /**
151     * @dev Allows the current owner to transfer control of the contract to a newOwner.
152     * @param newOwner The address to transfer ownership to.
153     */
154     function transferOwnership(address newOwner) public onlyOwner {
155         require(newOwner != address(0));
156         OwnershipTransferred(owner, newOwner);
157         owner = newOwner;
158     }
159 
160 }
161 
162 
163 /**
164  * @title Pausable
165  * @dev Base contract which allows children to implement an emergency stop mechanism.
166  */
167 contract Pausable is Ownable {
168     event Pause();
169     event Unpause();
170 
171     bool public paused = false;
172 
173 
174     /**
175      * @dev Modifier to make a function callable only when the contract is not paused.
176      */
177     modifier whenNotPaused() {
178         require(!paused);
179         _;
180     }
181 
182     /**
183      * @dev Modifier to make a function callable only when the contract is paused.
184      */
185     modifier whenPaused() {
186         require(paused);
187         _;
188     }
189 
190     /**
191      * @dev called by the owner to pause, triggers stopped state
192      */
193     function pause() onlyOwner whenNotPaused public {
194         paused = true;
195         Pause();
196     }
197 
198     /**
199      * @dev called by the owner to unpause, returns to normal state
200      */
201     function unpause() onlyOwner whenPaused public {
202         paused = false;
203         Unpause();
204     }
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
303 /*
304  * CardiumToken is a standard ERC20 token with some additional functionalities:
305  * - Transfers are only enabled after contract owner enables it (after the ICO)
306  *
307  * Note: Token Offering == Initial Coin Offering(ICO)
308  */
309 
310 contract CardiumToken is StandardToken, BurnableToken, Ownable, Pausable {
311     string public constant symbol = "CAD";
312     string public constant name = "Cardium Token";
313     uint8 public constant decimals = 2;
314     uint256 public constant INITIAL_SUPPLY = 475372000000 * (10 ** uint256(decimals));
315 
316     /**
317      * Check if address is a valid destination to transfer tokens to
318      * - must not be zero address
319      * - must not be the token address
320      */
321     modifier validDestination(address to) {
322         require(to != address(0x0));
323         require(to != address(this));
324         _;
325     }
326 
327     /**
328      * Token contract constructor
329      */
330     function CardiumToken() public {
331         totalSupply = INITIAL_SUPPLY;
332 
333         // Mint tokens
334         balances[msg.sender] = totalSupply;
335         Transfer(address(0x0), msg.sender, totalSupply);
336     }
337 
338     /**
339      * Transfer from sender to another account
340      *
341      * @param to Destination address
342      * @param value Amount of tokens to send
343      */
344     function transfer(address to, uint256 value) public validDestination(to) whenNotPaused returns (bool) {
345         return super.transfer(to, value);
346     }
347 
348     /**
349      * Transfer from `from` account to `to` account using allowance in `from` account to the sender
350      *
351      * @param from Origin address
352      * @param to Destination address
353      * @param value Amount of tokens to send
354      */
355     function transferFrom(address from, address to, uint256 value) public validDestination(to) whenNotPaused returns (bool) {
356         return super.transferFrom(from, to, value);
357     }
358 
359     /**
360      * Burn token, only owner is allowed to do this
361      *
362      * @param value Amount of tokens to burn
363      */
364     function burn(uint256 value) public onlyOwner {
365         super.burn(value);
366     }
367 }