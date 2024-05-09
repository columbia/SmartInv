1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 contract Ownable {
54     address public owner;
55     address public ICOAddress;
56 
57     event OwnershipTransferred(
58         address indexed previousOwner,
59         address indexed newOwner
60     );
61 
62 
63     /**
64      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65      * account.
66      */
67     constructor() public {
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
79 
80     /**
81      * @dev Throws if called by any account other than the ico.
82      */
83     modifier onlyICO() {
84         require(msg.sender == ICOAddress);
85         _;
86     }
87 
88 
89     modifier onlyOwnerOrICO() {
90         require(msg.sender == ICOAddress || msg.sender == owner);
91         _;
92     }
93 
94      /**
95      * @dev Allows the current owner to transfer control of the contract to a newOwner.
96      * @param _newOwner The address to transfer ownership to.
97      */
98     function transferOwnership(address _newOwner) public onlyOwner {
99         require(_newOwner != address(0));
100         emit OwnershipTransferred(owner, _newOwner);
101         owner = _newOwner;
102     }
103 
104     function setICOAddress(address _icoAddress) public onlyOwner {
105         require(_icoAddress != address(0));
106         ICOAddress = _icoAddress;
107     }
108 }
109 
110 
111 /**
112  * @title Pausable
113  * @dev Base contract which allows children to implement an emergency stop mechanism.
114  */
115 contract Pausable is Ownable {
116     event Pause();
117     event Unpause();
118 
119     bool public paused = true;
120 
121 
122     /**
123      * @dev Modifier to make a function callable only when the contract is not paused.
124      */
125     modifier whenNotPaused() {
126         require(!paused);
127         _;
128     }
129 
130     /**
131      * @dev Modifier to make a function callable only when the contract is paused.
132      */
133     modifier whenPaused() {
134         require(paused);
135         _;
136     }
137 
138     /**
139      * @dev called by the owner to pause, triggers stopped state
140      */
141     function pause() onlyOwner whenNotPaused public {
142         paused = true;
143         emit Pause();
144     }
145 
146     /**
147      * @dev called by the owner to unpause, returns to normal state
148      */
149     function unpause() onlyOwnerOrICO whenPaused public returns (bool) {
150         paused = false;
151         emit Unpause();
152         return true;
153     }
154 }
155 
156 
157 
158 /**
159  * @title ERC20 interface
160  * @dev see https://github.com/ethereum/EIPs/issues/20
161  */
162 contract ERC20 {
163     function allowance(address owner, address spender) public view returns (uint256);
164     function transferFrom(address from, address to, uint256 value) public returns (bool);
165     function totalSupply() public view returns (uint256);
166     function balanceOf(address who) public view returns (uint256);
167     function transfer(address to, uint256 value) public returns (bool);
168     event Transfer(address indexed from, address indexed to, uint256 value);
169 
170     function approve(address spender, uint256 value) public returns (bool);
171     event Approval(address indexed owner, address indexed spender, uint256 value);
172 }
173 
174 
175 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
176 /**
177  * @title Standard ERC20 token
178  *
179  * @dev Implementation of the basic standard token.
180  * https://github.com/ethereum/EIPs/issues/20
181  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
182  */
183 contract StandardToken is ERC20, Pausable{
184     using SafeMath for uint256;
185 
186     mapping (address => mapping (address => uint256)) internal allowed;
187     mapping(address => uint256) balances;
188 
189     uint256 totalSupply_;
190 
191 
192     /**
193     * @dev Total number of tokens in existence
194     */
195     function totalSupply() public view returns (uint256) {
196         return totalSupply_;
197     }
198 
199     /**
200     * @dev Transfer token for a specified address
201     * @param _to The address to transfer to.
202     * @param _value The amount to be transferred.
203     */
204     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
205         return _transfer(_to, _value);
206     }
207 
208     function ownerTransfer(address _to, uint256 _value) onlyOwnerOrICO public returns (bool) {
209         return _transfer(_to, _value);
210     }
211 
212     function _transfer(address _to, uint256 _value) internal returns (bool) {
213         require(_to != address(0));
214         require(_value <= balances[msg.sender]);
215 
216         balances[msg.sender] = balances[msg.sender].sub(_value);
217         balances[_to] = balances[_to].add(_value);
218         emit Transfer(msg.sender, _to, _value);
219         return true;
220     }
221 
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
232 
233     /**
234      * @dev Transfer tokens from one address to another
235      * @param _from address The address which you want to send tokens from
236      * @param _to address The address which you want to transfer to
237      * @param _value uint256 the amount of tokens to be transferred
238      */
239     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
240         require(_to != address(0));
241         require(_value <= balances[_from]);
242         require(_value <= allowed[_from][msg.sender]);
243 
244         balances[_from] = balances[_from].sub(_value);
245         balances[_to] = balances[_to].add(_value);
246         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
247         emit Transfer(_from, _to, _value);
248         return true;
249     }
250 
251     /**
252      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253      * Beware that changing an allowance with this method brings the risk that someone may use both the old
254      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257      * @param _spender The address which will spend the funds.
258      * @param _value The amount of tokens to be spent.
259      */
260     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
261         allowed[msg.sender][_spender] = _value;
262         emit Approval(msg.sender, _spender, _value);
263         return true;
264     }
265 
266     /**
267      * Set allowance for other address and notify
268      *
269      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
270      *
271      * @param _spender The address authorized to spend
272      * @param _value the max amount they can spend
273      * @param _extraData some extra information to send to the approved contract
274      */
275     function approveAndCall(address _spender, uint256 _value, bytes _extraData) whenNotPaused public returns (bool success) {
276         tokenRecipient spender = tokenRecipient(_spender);
277         if (approve(_spender, _value)) {
278             spender.receiveApproval(msg.sender, _value, this, _extraData);
279             return true;
280         }
281     }
282 
283     /**
284      * @dev Function to check the amount of tokens that an owner allowed to a spender.
285      * @param _owner address The address which owns the funds.
286      * @param _spender address The address which will spend the funds.
287      * @return A uint256 specifying the amount of tokens still available for the spender.
288      */
289     function allowance(address _owner, address _spender) public view returns (uint256) {
290         return allowed[_owner][_spender];
291     }
292 
293     /**
294      * @dev Increase the amount of tokens that an owner allowed to a spender.
295      * approve should be called when allowed[_spender] == 0. To increment
296      * allowed value is better to use this function to avoid 2 calls (and wait until
297      * the first transaction is mined)
298      * From MonolithDAO Token.sol
299      * @param _spender The address which will spend the funds.
300      * @param _addedValue The amount of tokens to increase the allowance by.
301      */
302     function increaseApproval(address _spender, uint256 _addedValue) whenNotPaused public returns (bool) {
303         allowed[msg.sender][_spender] = (
304         allowed[msg.sender][_spender].add(_addedValue));
305         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306         return true;
307     }
308 
309     /**
310      * @dev Decrease the amount of tokens that an owner allowed to a spender.
311      * approve should be called when allowed[_spender] == 0. To decrement
312      * allowed value is better to use this function to avoid 2 calls (and wait until
313      * the first transaction is mined)
314      * From MonolithDAO Token.sol
315      * @param _spender The address which will spend the funds.
316      * @param _subtractedValue The amount of tokens to decrease the allowance by.
317      */
318     function decreaseApproval(address _spender, uint256 _subtractedValue) whenNotPaused public returns (bool) {
319         uint256 oldValue = allowed[msg.sender][_spender];
320         if (_subtractedValue > oldValue) {
321             allowed[msg.sender][_spender] = 0;
322         } else {
323             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
324         }
325         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
326         return true;
327     }
328 
329 }
330 
331 
332 /**
333  * @title SimpleToken
334  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
335  * Note they can later distribute these tokens as they wish using `transfer` and other
336  * `StandardToken` functions.
337  */
338 contract OPKToken is StandardToken {
339     address public teamAddress;
340     address public advisorsAddress;
341     address public reserveAddress;
342 
343     string public constant name = "OPK"; // solium-disable-line uppercase
344     string public constant symbol = "OPK"; // solium-disable-line uppercase
345     uint8 public constant decimals = 18; // solium-disable-line uppercase
346 
347     uint256 public constant INITIAL_SUPPLY = 50000000 * (10 ** uint256(decimals));
348 
349 
350     constructor() public {
351         totalSupply_ = INITIAL_SUPPLY;
352         balances[msg.sender] = INITIAL_SUPPLY;
353         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
354     }
355 
356 }