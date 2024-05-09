1 pragma solidity 0.5.7;
2 
3 /**
4  * @dev SafeMath library, provides math operations with safety checks that throw on error.
5  */
6 library SafeMath {
7     /**
8      * @dev Multiplies two unsigned integers, reverts on overflow.
9      */
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
12         // benefit is lost if 'b' is also tested.
13         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14         if (a == 0) {
15           return 0;
16         }
17         uint256 c = a * b;
18         require(c / a == b);
19         return c;
20     }
21 
22     /**
23      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
24      */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Solidity only automatically asserts when dividing by 0
27         require(b > 0);
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     /**
34      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35      */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     /**
43      * @dev Adds two unsigned integers, reverts on overflow.
44      */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a);
48         return c;
49     }
50 }
51 
52 contract Ownable {
53     address public owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59      * account.
60      */
61     constructor() public {
62         owner = msg.sender;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     /**
74      * @dev Allows the current owner to transfer control of the contract to a newOwner.
75      * @param _newOwner The address to transfer ownership to.
76      */
77     function transferOwnership(address _newOwner) public onlyOwner {
78         _transferOwnership(_newOwner);
79     }
80 
81     /**
82      * @dev Transfers control of the contract to a newOwner.
83      * @param _newOwner The address to transfer ownership to.
84      */
85     function _transferOwnership(address _newOwner) internal {
86         require(_newOwner != address(0));
87         emit OwnershipTransferred(owner, _newOwner);
88         owner = _newOwner;
89     }
90 }
91 
92 contract Pausable is Ownable {
93     event Pause();
94     event Unpause();
95 
96     bool public paused = false;
97 
98     /**
99      * @dev Modifier to make a function callable only when the contract is not paused.
100      */
101     modifier whenNotPaused() {
102         require(!paused);
103         _;
104     }
105 
106     /**
107      * @dev Modifier to make a function callable only when the contract is paused.
108      */
109     modifier whenPaused() {
110         require(paused);
111         _;
112     }
113 
114     /**
115      * @dev called by the founder to pause, triggers stopped state
116      */
117     function pause() public onlyOwner whenNotPaused {
118         paused = true;
119         emit Pause();
120     }
121 
122     /**
123      * @dev called by the founder to unpause, returns to normal state
124      */
125     function unpause() public onlyOwner whenPaused {
126         paused = false;
127         emit Unpause();
128     }
129 }
130 
131 /**
132  * @title Standard ERC20 token
133  */
134 contract StandardToken {
135     using SafeMath for uint256;
136     uint256 public totalSupply;
137 
138     mapping(address => uint256) internal balances;
139     mapping (address => mapping (address => uint256)) internal allowed;
140 
141     event Transfer(address indexed from, address indexed to, uint256 value);
142     event Approval(address indexed owner, address indexed spender, uint256 value);
143 
144 
145     /**
146      * @dev Gets the balance of the specified address.
147      * @param _owner The address to query the the balance of.
148      * @return An uint256 representing the amount owned by the passed address.
149      */
150     function balanceOf(address _owner) public view returns (uint256) {
151         return balances[_owner];
152     }
153 
154     /**
155      * @dev Function to check the amount of tokens that an owner allowed to a spender.
156      * @param _owner address The address which owns the funds.
157      * @param _spender address The address which will spend the funds.
158      * @return A uint256 specifying the amount of tokens still available for the spender.
159      */
160     function allowance(address _owner, address _spender) public view returns (uint256) {
161         return allowed[_owner][_spender];
162     }
163 
164     /**
165      * @dev Transfer token for a specified address
166      * @param _to The address to transfer to.
167      * @param _value The amount to be transferred.
168      */
169     function transfer(address _to, uint256 _value) public returns (bool) {
170         require(_to != address(0));
171         require(_value <= balances[msg.sender]);
172 
173         balances[msg.sender] = balances[msg.sender].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         emit Transfer(msg.sender, _to, _value);
176         return true;
177     }
178 
179     /**
180      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181      * Beware that changing an allowance with this method brings the risk that someone may use both the old
182      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185      * @param _spender The address which will spend the funds.
186      * @param _value The amount of tokens to be spent.
187      */
188     function approve(address _spender, uint256 _value) public returns (bool) {
189         allowed[msg.sender][_spender] = _value;
190         emit Approval(msg.sender, _spender, _value);
191         return true;
192     }
193 
194     /**
195      * @dev Transfer tokens from one address to another
196      * @param _from address The address which you want to send tokens from
197      * @param _to address The address which you want to transfer to
198      * @param _value uint256 the amount of tokens to be transferred
199      */
200     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201         require(_to != address(0));
202         require(_value <= balances[_from]);
203         require(_value <= allowed[_from][msg.sender]);
204 
205         balances[_from] = balances[_from].sub(_value);
206         balances[_to] = balances[_to].add(_value);
207         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
208         emit Transfer(_from, _to, _value);
209         return true;
210     }
211 
212     /**
213      * @dev Increase the amount of tokens that an owner allowed to a spender.
214      * approve should be called when allowed[_spender] == 0. To increment
215      * allowed value is better to use this function to avoid 2 calls (and wait until
216      * the first transaction is mined)
217      * From MonolithDAO Token.sol
218      * @param _spender The address which will spend the funds.
219      * @param _addedValue The amount of tokens to increase the allowance by.
220      */
221     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
222         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
223         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224         return true;
225     }
226 
227     /**
228      * @dev Decrease the amount of tokens that an owner allowed to a spender.
229      * approve should be called when allowed[_spender] == 0. To decrement
230      * allowed value is better to use this function to avoid 2 calls (and wait until
231      * the first transaction is mined)
232      * From MonolithDAO Token.sol
233      * @param _spender The address which will spend the funds.
234      * @param _subtractedValue The amount of tokens to decrease the allowance by.
235      */
236     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
237         uint256 oldValue = allowed[msg.sender][_spender];
238         if (_subtractedValue >= oldValue) {
239             allowed[msg.sender][_spender] = 0;
240         } else {
241             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242         }
243         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244         return true;
245     }
246 }
247 
248 /**
249  * Overriding ERC-20 specification that lets owner pause all trading.
250  */
251 contract PausableToken is StandardToken, Pausable {
252 
253     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
254         return super.transfer(_to, _value);
255     }
256 
257     function transferFrom(address _from, address _to, uint256 _value ) public whenNotPaused returns (bool) {
258         return super.transferFrom(_from, _to, _value);
259     }
260 
261     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
262         return super.approve(_spender, _value);
263     }
264 
265     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
266         return super.increaseApproval(_spender, _addedValue);
267     }
268 
269     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
270         return super.decreaseApproval(_spender, _subtractedValue);
271     }
272 }
273 
274 contract FreezeToken is PausableToken {
275     mapping(address=>bool) public frozenAccount;
276 
277     event FrozenAccount(address indexed target, bool frozen);
278 
279     function frozenCheck(address target) internal view {
280         require(!frozenAccount[target]);
281     }
282 
283     function freezeAccount(address target, bool frozen) public onlyOwner {
284   	    frozenAccount[target] = frozen;
285   	    emit FrozenAccount(target, frozen);
286     }
287 
288     function transfer(address _to, uint256 _value) public returns (bool) {
289         frozenCheck(msg.sender);
290         frozenCheck(_to);
291         return super.transfer(_to, _value);
292     }
293 
294     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
295         frozenCheck(_from);
296         frozenCheck(_to);
297         frozenCheck(msg.sender);
298         return super.transferFrom(_from, _to, _value);
299     }
300 }
301 
302 contract _0xLitecoin is FreezeToken { 
303     string public constant name = "0xLitecoin";
304     string public constant symbol = "0xLTC";
305     uint8 public constant decimals = 18;
306     uint256 private constant initialSupply = 84000000;
307     address public constant wallet = 0xE45eDa12fb564C5528c3f1542EFA6fD50Fe37c47;
308 
309     /**
310      * @dev Constructor.
311      */
312     constructor() public {
313         totalSupply = initialSupply * 10 ** uint256(decimals);
314         balances[wallet] = totalSupply;
315         emit Transfer(address(0), wallet, totalSupply);
316     }
317 }