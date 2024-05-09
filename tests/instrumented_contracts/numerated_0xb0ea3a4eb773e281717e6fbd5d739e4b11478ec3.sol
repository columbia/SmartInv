1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20TokenInterface
6  * @dev Token contract interface for external use
7  */
8 contract ERC20TokenInterface {
9 
10     function balanceOf(address _owner) public view returns (uint256 balance);
11     function transfer(address _to, uint256 _value) public returns (bool success);
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13     function approve(address _spender, uint256 _value) public returns (bool success);
14     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
15 }
16 /**
17 * @title Admin parameters
18 * @dev Define administration parameters for this contract
19 */
20 contract Admined { //This token contract is administered
21     address public admin; //Admin address is public
22 
23     /**
24     * @dev Contract constructor, define initial administrator
25     */
26     constructor() internal {
27         admin = msg.sender; //Set initial admin to contract creator
28         emit AdminedEvent(admin);
29     }
30 
31     modifier onlyAdmin() { //A modifier to define admin-only functions
32         require(msg.sender == admin);
33         _;
34     }
35 
36     /**
37     * @dev Function to set new admin address
38     * @param _newAdmin The address to transfer administration to
39     */
40     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
41         require(_newAdmin != address(0));
42         admin = _newAdmin;
43         emit TransferAdminship(admin);
44     }
45 
46     //All admin actions have a log for public review
47     event TransferAdminship(address newAdminister);
48     event AdminedEvent(address administer);
49 
50 }
51 
52 contract LockableToken is Admined {
53 
54     event LockStatus(address _target, uint _timeStamp);
55 
56     mapping (address => uint) internal locked; //public need to be reviewed
57     bool internal globalLock = true;
58 
59     /**
60     * @notice _target - address you want to lock until _timeStamp - unix time
61     */
62     function setLocked(address _target, uint _timeStamp) public onlyAdmin returns (bool) {
63         locked[_target]=_timeStamp;
64         emit LockStatus(_target, _timeStamp);
65         return true;
66     }
67 
68     /**
69     * @notice function allows admin to unlock tokens on _target address
70     */
71     function unLock(address _target) public onlyAdmin returns (bool) {
72         locked[_target] = 0;
73         return true;
74     }
75 
76     /**
77     * Allow admin to unlock everything
78     */
79     function AllUnLock() public onlyAdmin returns (bool) {
80         globalLock = false;
81         return true;
82     }
83 
84     /**
85     * Allow admin to lock everything
86     */
87     function AllLock() public onlyAdmin returns (bool) {
88         globalLock = true;
89         return true;
90     }
91 
92     /**
93     * Return state of globalLock
94     */
95     function isGlobalLock() public view returns (bool) {
96         return globalLock;
97     }
98 
99     /**
100     * @notice Getter returns false if tokens are available and true if
101     *               unavailable
102     */
103     function isLocked(address _target) public view returns (bool) {
104         if(locked[_target] > now){
105             return true;
106         } else {
107             return false;
108         }
109     }
110 }
111 
112 /**
113  * @title Pausable
114  * @dev Base contract which allows children to implement an emergency stop mechanism.
115  */
116 contract Pausable is LockableToken {
117   event Pause();
118   event Unpause();
119 
120   bool public paused = false;
121 
122   constructor() internal {
123     emit Unpause();
124   }
125 
126   /**
127    * @dev Modifier to make a function callable only when the contract is not paused.
128    */
129   modifier whenNotPaused() {
130     require(!paused);
131     _;
132   }
133 
134   /**
135    * @dev Modifier to make a function callable only when the contract is paused.
136    */
137   modifier whenPaused() {
138     require(paused);
139     _;
140   }
141 
142   /**
143    * @dev called by the owner to pause, triggers stopped state
144    */
145    function pause() onlyAdmin whenNotPaused public {
146      paused = true;
147      emit Pause();
148    }
149 
150   /**
151    * @dev called by the owner to unpause, returns to normal state
152    */
153   function unpause() onlyAdmin whenPaused public {
154     paused = false;
155     emit Unpause();
156   }
157 }
158 /**
159  * @title SafeMath by OpenZeppelin (partially)
160  * @dev Math operations with safety checks that throw on error
161  */
162 library SafeMath {
163 
164     /**
165     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
166     */
167     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168         assert(b <= a);
169         return a - b;
170     }
171 
172     /**
173     * @dev Adds two numbers, throws on overflow.
174     */
175     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
176         c = a + b;
177         assert(c >= a);
178         return c;
179     }
180 }
181 
182 /**
183 * @title ERC20Token
184 * @notice Token definition contract
185 */
186 contract ERC20Token is ERC20TokenInterface,  Admined, Pausable { //Standard definition of an ERC20Token
187     using SafeMath for uint256;
188     uint256 public totalSupply;
189     mapping (address => uint256) balances; //A mapping of all balances per address
190     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
191     mapping (address => bool) frozen; //A mapping of all frozen status
192 
193     /**
194     * @dev Get the balance of an specified address.
195     * @param _owner The address to be query.
196     */
197     function balanceOf(address _owner) public constant returns (uint256 value) {
198         return balances[_owner];
199     }
200 
201     /**
202     * @dev transfer token to a specified address
203     * @param _to The address to transfer to.
204     * @param _value The amount to be transferred.
205     */
206     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool success) {
207         require(_to != address(0)); //If you dont want that people destroy token
208         require(frozen[msg.sender]==false);
209         if (globalLock == true) {
210             require(locked[msg.sender] <= now, 'Tokens locked as single');
211         }
212         balances[msg.sender] = balances[msg.sender].sub(_value);
213         balances[_to] = balances[_to].add(_value);
214         emit Transfer(msg.sender, _to, _value);
215         return true;
216     }
217 
218     /**
219     * @dev transfer token from an address to another specified address using allowance
220     * @param _from The address where token comes.
221     * @param _to The address to transfer to.
222     * @param _value The amount to be transferred.
223     */
224     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool success) {
225         require(_to != address(0)); //If you dont want that people destroy token
226         require(frozen[_from]==false);
227         if (globalLock == true) {
228             require(locked[msg.sender] <= now, 'Tokens locked as single');
229         }
230         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231         balances[_from] = balances[_from].sub(_value);
232         balances[_to] = balances[_to].add(_value);
233         emit Transfer(_from, _to, _value);
234         return true;
235     }
236 
237     /**
238     * @dev Assign allowance to an specified address to use the owner balance
239     * @param _spender The address to be allowed to spend.
240     * @param _value The amount to be allowed.
241     */
242     function approve(address _spender, uint256 _value) public returns (bool success) {
243         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
244         allowed[msg.sender][_spender] = _value;
245         emit Approval(msg.sender, _spender, _value);
246         return true;
247     }
248 
249     /**
250     * @dev Get the allowance of an specified address to use another address balance.
251     * @param _owner The address of the owner of the tokens.
252     * @param _spender The address of the allowed spender.
253     */
254     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
255         return allowed[_owner][_spender];
256     }
257 
258     /**
259     * @dev Frozen account.
260     * @param _target The address to being frozen.
261     * @param _flag The frozen status to set.
262     */
263     function setFrozen(address _target,bool _flag) onlyAdmin whenNotPaused public {
264         frozen[_target]=_flag;
265         emit FrozenStatus(_target,_flag);
266     }
267 
268     /**
269     * @dev Log Events
270     */
271     event Transfer(address indexed _from, address indexed _to, uint256 _value);
272     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
273     event FrozenStatus(address _target,bool _flag);
274 
275 }
276 /**
277 * @title ERC20 Token minimal interface for external tokens handle
278 */
279 contract Token {
280     function balanceOf(address _owner) public constant returns (uint256 balance);
281     function transfer(address _to, uint256 _value) public returns (bool success);
282 }
283 
284 /**
285 * @title AEXL Token
286 * @notice AEXL Token creation.
287 * @dev ERC20 Token compliant
288 */
289 contract AEXLToken is ERC20Token {
290 
291     string public name = 'AEXL';
292     uint8 public decimals = 18;
293     string public symbol = 'AEXL';
294     string public version = '1';
295 
296     /**
297     * @notice token contructor.
298     */
299     constructor() public {
300         totalSupply = 49883398300 * 10 ** uint256(decimals); // 49883398300 coins
301         balances[msg.sender] = totalSupply;
302         emit Transfer(0, msg.sender, totalSupply);
303     }
304 
305     /**
306     * @notice Function to claim any token stuck on contract
307     */
308     function externalTokensRecovery(Token _address) onlyAdmin public {
309         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
310         _address.transfer(msg.sender,remainder); //Transfer tokens to admin
311     }
312 
313     /**
314       Allow transfers of tokens in groups of addresses
315     */
316     function sendBatches(address[] _addrs, uint256[] tokensValue) onlyAdmin public {
317       require(_addrs.length == tokensValue.length);
318       for(uint256 i = 0; i < _addrs.length; i++) {
319         require(transfer(_addrs[i], tokensValue[i]));
320         require(setLocked(_addrs[i], 4708628725000)); // Locked for Tue, 19 Mar 2119 00:25:25 GMT
321       }
322     }
323 
324     /**
325       Allow the admin to burn tokens
326     */
327     function burn(uint256 _value) onlyAdmin whenNotPaused public {
328       require(_value <= balances[msg.sender]);
329 
330       balances[msg.sender] = balances[msg.sender].sub(_value);
331       totalSupply = totalSupply.sub(_value);
332 
333       emit Burn(msg.sender, _value);
334       emit Transfer(msg.sender, address(0), _value);
335     }
336 
337     /**
338     * @notice this contract will revert on direct non-function calls, also it's not payable
339     * @dev Function to handle callback calls to contract
340     */
341     function() public {
342         revert();
343     }
344 
345     event Burn(address indexed burner, uint256 value);
346 }