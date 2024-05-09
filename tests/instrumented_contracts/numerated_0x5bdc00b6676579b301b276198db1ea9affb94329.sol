1 pragma solidity ^0.5.7;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address who) external view returns (uint256);
6     function allowance(address owner, address spender) external view returns (uint256);
7 
8     function transfer(address to, uint256 value) external returns (bool);
9     function approve(address spender, uint256 value) external returns (bool);
10     function transferFrom(address from, address to, uint256 value) external returns (bool);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 /**
17  * @title SafeMath
18  * @dev Unsigned math operations with safety checks that revert on error.
19  */
20 library SafeMath {
21     /**
22       * @dev Multiplies two unsigned integers, reverts on overflow.
23       */
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
26         // benefit is lost if 'b' is also tested.
27         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b);
34 
35         return c;
36     }
37 
38     /**
39       * @dev Integer division of two unsigned integers truncating the quotient,
40       * reverts on division by zero.
41       */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Solidity only automatically asserts when dividing by 0
44         require(b > 0);
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50 
51     /**
52       * @dev Subtracts two unsigned integers, reverts on overflow
53       * (i.e. if subtrahend is greater than minuend).
54       */
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b <= a);
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63       * @dev Adds two unsigned integers, reverts on overflow.
64       */
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a);
68 
69         return c;
70     }
71 
72     /**
73       * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
74       * reverts when dividing by zero.
75       */
76     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b != 0);
78         return a % b;
79     }
80 }
81 
82 /**
83  * @title Ownable
84  * @dev The Ownable contract has an owner address, and provides basic authorization control
85  * functions, this simplifies the implementation of "user permissions".
86  */
87 contract Ownable {
88     address public owner;
89 
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93 
94     /**
95      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
96      * account.
97      */
98     constructor() public {
99         owner = msg.sender;
100     }
101 
102 
103     /**
104      * @dev Throws if called by any account other than the owner.
105      */
106     modifier onlyOwner() {
107         require(msg.sender == owner);
108         _;
109     }
110 
111 
112     /**
113      * @dev Allows the current owner to transfer control of the contract to a newOwner.
114      * @param newOwner The address to transfer ownership to.
115      */
116     function transferOwnership(address newOwner) onlyOwner public {
117         require(newOwner != address(0));
118         emit OwnershipTransferred(owner, newOwner);
119         owner = newOwner;
120     }
121 
122 }
123 
124 /**
125  * @title Pausable
126  * @dev Base contract which allows children to implement an emergency stop mechanism.
127  */
128 contract Pausable is Ownable {
129     event Pause();
130     event Unpause();
131 
132     bool public paused = false;
133 
134 
135     /**
136     * @dev Modifier to make a function callable only when the contract is not paused.
137     */
138     modifier whenNotPaused() {
139         require(!paused);
140         _;
141     }
142 
143     /**
144     * @dev Modifier to make a function callable only when the contract is paused.
145     */
146     modifier whenPaused() {
147         require(paused);
148         _;
149     }
150 
151     /**
152     * @dev called by the owner to pause, triggers stopped state
153     */
154     function pause() public onlyOwner whenNotPaused {
155         paused = true;
156         emit Pause();
157     }
158 
159     /**
160     * @dev called by the owner to unpause, returns to normal state
161     */
162     function unpause() public onlyOwner whenPaused {
163         paused = false;
164         emit Unpause();
165     }
166 }
167 
168 /**
169  * @title Blacklistable Token
170  * @dev Allows accounts to be blacklisted by a "blacklister" role
171 */
172 contract Blacklistable is Pausable {
173 
174     address public blacklister;
175     mapping(address => bool) internal blacklisted;
176 
177     event Blacklisted(address indexed _account);
178     event UnBlacklisted(address indexed _account);
179     event BlacklisterChanged(address indexed newBlacklister);
180 
181     constructor() public {
182         blacklister = msg.sender;
183     }
184 
185     /**
186      * @dev Throws if called by any account other than the blacklister
187     */
188     modifier onlyBlacklister() {
189         require(msg.sender == blacklister);
190         _;
191     }
192 
193     /**
194      * @dev Throws if argument account is blacklisted
195      * @param _account The address to check
196     */
197     modifier notBlacklisted(address _account) {
198         require(blacklisted[_account] == false);
199         _;
200     }
201 
202     /**
203      * @dev Checks if account is blacklisted
204      * @param _account The address to check
205     */
206     function isBlacklisted(address _account) public view returns (bool) {
207         return blacklisted[_account];
208     }
209 
210     /**
211      * @dev Adds account to blacklist
212      * @param _account The address to blacklist
213     */
214     function blacklist(address _account) public onlyBlacklister {
215         blacklisted[_account] = true;
216         emit Blacklisted(_account);
217     }
218 
219     /**
220      * @dev Removes account from blacklist
221      * @param _account The address to remove from the blacklist
222     */
223     function unBlacklist(address _account) public onlyBlacklister {
224         blacklisted[_account] = false;
225         emit UnBlacklisted(_account);
226     }
227 
228     function updateBlacklister(address _newBlacklister) public onlyOwner {
229         require(_newBlacklister != address(0));
230         blacklister = _newBlacklister;
231         emit BlacklisterChanged(blacklister);
232     }
233 }
234 
235 
236 contract StandardToken is IERC20, Pausable, Blacklistable {
237     uint256 public totalSupply;
238 
239     using SafeMath for uint;
240 
241     mapping (address => uint256) internal balances;
242     mapping (address => mapping (address => uint256)) internal allowed;
243 
244     function balanceOf(address _owner) public view returns (uint256 balance) {
245         return balances[_owner];
246     }
247 
248     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused notBlacklisted(_to) notBlacklisted(msg.sender) notBlacklisted(_from) public returns (bool) {
249         require(_to != address(0));
250         require(_value <= balances[_from]);
251         require(_value <= allowed[_from][msg.sender]);
252         balances[_from] = balances[_from].sub(_value);
253         balances[_to] = balances[_to].add(_value);
254         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
255         emit Transfer(_from, _to, _value);
256         return true;
257     }
258 
259     function approve(address _spender, uint256 _value) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_spender) public returns (bool) {
260         allowed[msg.sender][_spender] = _value;
261         emit Approval(msg.sender, _spender, _value);
262         return true;
263     }
264 
265     function allowance(address _owner, address _spender) public view returns (uint256) {
266         return allowed[_owner][_spender];
267     }
268 
269     function increaseApproval(address _spender, uint _addedValue) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_spender) public returns (bool) {
270         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
271         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272         return true;
273     }
274 
275     function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_spender) public returns (bool) {
276         uint oldValue = allowed[msg.sender][_spender];
277         if (_subtractedValue > oldValue) {
278             allowed[msg.sender][_spender] = 0;
279         } else {
280             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
281         }
282         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283         return true;
284     }
285 
286     function transfer(address _to, uint _value) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_to) public returns (bool success) {
287         require(_to != address(0));
288         require(balances[msg.sender] >= _value);
289         balances[msg.sender] = balances[msg.sender].sub(_value);
290         balances[_to] = balances[_to].add(_value);
291         emit Transfer(msg.sender, _to, _value);
292         return true;
293     }
294 }
295 
296 /**
297  * @title Burnable Token
298  * @dev Token that can be irreversibly burned (destroyed).
299  */
300 contract BurnableToken is StandardToken {
301 
302   event Burn(address indexed burner, uint256 value);
303 
304   /**
305    * @dev Burns a specific amount of tokens.
306    * @param _value The amount of token to be burned.
307    */
308   function burn(uint256 _value) public {
309     _burn(msg.sender, _value);
310   }
311 
312   function _burn(address _who, uint256 _value) internal {
313     require(_value <= balances[_who]);
314     // no need to require value <= totalSupply, since that would imply the
315     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
316 
317     balances[_who] = balances[_who].sub(_value);
318     totalSupply = totalSupply.sub(_value);
319     emit Burn(_who, _value);
320     emit Transfer(_who, address(0), _value);
321   }
322 }
323 
324 contract XBASE is BurnableToken {
325     string public constant name = "Eterbase Utility Token";
326     string public constant symbol = "XBASE";
327     uint8 public constant decimals = 18;
328     uint256 public constant initialSupply = 1000000 * 10 ** uint256(decimals);
329 
330     constructor () public {
331         totalSupply = initialSupply;
332         balances[msg.sender] = initialSupply;
333     }
334 }