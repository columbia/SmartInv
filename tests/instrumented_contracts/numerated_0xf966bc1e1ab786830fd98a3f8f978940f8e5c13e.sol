1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11     address public pendingOwner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16     * @dev Throws if called by any account other than the owner.
17     */
18     modifier onlyOwner() {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     /**
24     * @dev Modifier throws if called by any account other than the pendingOwner.
25     */
26     modifier onlyPendingOwner() {
27         require(msg.sender == pendingOwner);
28         _;
29     }
30 
31     constructor() public {
32         owner = msg.sender;
33     }
34 
35     /**
36     * @dev Allows the current owner to set the pendingOwner address.
37     * @param newOwner The address to transfer ownership to.
38     */
39     function transferOwnership(address newOwner) public onlyOwner {
40         pendingOwner = newOwner;
41     }
42 
43     /**
44     * @dev Allows the pendingOwner address to finalize the transfer.
45     */
46     function claimOwnership() public onlyPendingOwner {
47         emit OwnershipTransferred(owner, pendingOwner);
48         owner = pendingOwner;
49         pendingOwner = address(0);
50     }
51 }
52 
53 
54 /*
55  * @title Manageable
56  * @dev The Manageable contract has an manager addresses, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Manageable is Ownable {
60     mapping(address => bool) public listOfManagers;
61 
62     event ManagerAdded(address manager);
63     event ManagerRemoved(address manager);
64 
65     modifier onlyManager() {
66         require(listOfManagers[msg.sender]);
67         _;
68     }
69 
70     function addManager(address _manager) public onlyOwner returns (bool success) {
71         require(_manager != address(0));
72         require(!listOfManagers[_manager]);
73 
74         listOfManagers[_manager] = true;
75         emit ManagerAdded(_manager);
76 
77         return true;
78     }
79 
80     function removeManager(address _manager) public onlyOwner returns (bool) {
81         require(listOfManagers[_manager]);
82 
83         listOfManagers[_manager] = false;
84         emit ManagerRemoved(_manager);
85 
86         return true;
87     }
88 }
89 
90 
91 /*
92  * @title Freezable
93  * @dev The Freezable contract allows managers to freeze entire balance on accounts.
94  */
95 contract Freezable is Manageable {
96     mapping(address => bool) public freeze;
97 
98     event AccountFrozen(address account);
99     event AccountUnfrozen(address account);
100 
101     modifier whenNotFrozen() {
102         require(!freeze[msg.sender]);
103         _;
104     }
105 
106     function freezeAccount(address _account) public onlyManager returns (bool) {
107         require(!freeze[_account]);
108 
109         freeze[_account] = true;
110         emit AccountFrozen(_account);
111 
112         return true;
113     }
114 
115     function freezeAccounts(address[] _accounts) public onlyManager returns (bool) {
116 
117         for (uint i = 0; i < _accounts.length; i++) {
118             if (!freeze[_accounts[i]]) {
119                 freeze[_accounts[i]] = true;
120                 emit AccountFrozen(_accounts[i]);
121             }
122         }
123 
124         return true;
125     }
126 
127     function unfreezeAccount (address _account) public onlyManager returns (bool) {
128         require(freeze[_account]);
129 
130         freeze[_account] = false;
131         emit AccountUnfrozen(_account);
132 
133         return true;
134     }
135 
136 
137 
138     function unfreezeAccounts(address[] _accounts) public onlyManager returns (bool) {
139 
140         for (uint i = 0; i < _accounts.length; i++) {
141             if (freeze[_accounts[i]]) {
142                 freeze[_accounts[i]] = false;
143                 emit AccountUnfrozen(_accounts[i]);
144             }
145         }
146 
147         return true;
148     }
149 }
150 
151 
152 contract ERC20 {
153     function totalSupply() public view returns (uint256);
154     function balanceOf(address who) public view returns (uint256);
155     function transfer(address to, uint256 value) public returns (bool);
156     function transferFrom(address from, address to, uint256 value) public returns (bool);
157     function approve(address spender, uint256 value) public returns (bool);
158     function allowance(address who, address spender) public view returns (uint256);
159     event Transfer(address indexed from, address indexed to, uint256 value);
160     event Approval(address indexed who, address indexed spender, uint256 value);
161 }
162 
163 
164 contract Hearts is ERC20, Freezable {
165     using SafeMath for uint256;
166 
167     mapping(address => uint256) public balances;
168     mapping(address => mapping (address => uint256)) public allowed;
169     uint256 totalSupply_;
170 
171     string public name = hex"F09F929A";
172     string public symbol = hex"F09F929A";
173     uint8 public decimals = 18;
174 
175     constructor() public { }
176 
177     /**
178      * @dev Function that mints an amount of the token and assigns it to
179      * an account. This encapsulates the modification of balances such that the
180      * proper events are emitted.
181      * @param _account The account that will receive the created tokens.
182      * @param _amount The amount that will be created.
183      */
184     function mint(address _account, uint256 _amount) external onlyManager {
185         require(_account != address(0));
186         totalSupply_ = totalSupply_.add(_amount);
187         balances[_account] = balances[_account].add(_amount);
188         emit Transfer(address(0), _account, _amount);
189     }
190 
191     /**
192      * @dev Function that mints an amount of the token and assigns it to
193      * an accounts. This encapsulates the modification of balances such that the
194      * proper events are emitted.
195      * @param _accounts The accounts that will receive the created tokens.
196      * @param _amounts The amounts that will be created.
197      */
198     function multiMint(address[] _accounts, uint256[] _amounts) external onlyManager {
199         require(_accounts.length > 0);
200         for (uint i = 0; i < _accounts.length; i++) {
201             totalSupply_ = totalSupply_.add(_amounts[i]);
202             balances[_accounts[i]] = balances[_accounts[i]].add(_amounts[i]);
203             emit Transfer(address(0), _accounts[i], _amounts[i]);
204         }
205     }
206 
207     /**
208      * @dev Reclaim all ERC20Basic compatible tokens
209      * @param token ERC20B The address of the token contract
210      */
211     function reclaimToken(ERC20 token) external onlyOwner {
212         uint256 balance = token.balanceOf(this);
213         token.transfer(owner, balance);
214     }
215 
216     /**
217     * @dev total number of tokens in existence
218     */
219     function totalSupply() public view returns (uint256) {
220         return totalSupply_;
221     }
222 
223     /**
224     * @dev Gets the balance of the specified address.
225     * @param _who The address to query the the balance of.
226     * @return An uint256 representing the amount owned by the passed address.
227     */
228     function balanceOf(address _who) public view returns (uint256 balance) {
229         return balances[_who];
230     }
231 
232     /**
233     * @dev transfer token for a specified address
234     * @param _to The address to transfer to.
235     * @param _value The amount to be transferred.
236     */
237     function transfer(address _to, uint256 _value) public whenNotFrozen returns (bool) {
238         require(_to != address(0));
239         require(_value <= balances[msg.sender]);
240 
241         // SafeMath.sub will throw if there is not enough balance.
242         balances[msg.sender] = balances[msg.sender].sub(_value);
243         balances[_to] = balances[_to].add(_value);
244         emit Transfer(msg.sender, _to, _value);
245         return true;
246     }
247 
248     /**
249      * @dev Transfer tokens from one address to another
250      * @param _from address The address which you want to send tokens from
251      * @param _to address The address which you want to transfer to
252      * @param _value uint256 the amount of tokens to be transferred
253      */
254     function transferFrom(address _from, address _to, uint256 _value) public whenNotFrozen returns (bool) {
255         require(_to != address(0));
256         require(_value <= balances[_from]);
257         require(_value <= allowed[_from][msg.sender]);
258 
259         balances[_from] = balances[_from].sub(_value);
260         balances[_to] = balances[_to].add(_value);
261         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
262         emit Transfer(_from, _to, _value);
263         return true;
264     }
265 
266     /**
267      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
268      *
269      * Beware that changing an allowance with this method brings the risk that someone may use both the old
270      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
271      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
272      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
273      * @param _spender The address which will spend the funds.
274      * @param _value The amount of tokens to be spent.
275      */
276     function approve(address _spender, uint256 _value) public whenNotFrozen returns (bool) {
277         allowed[msg.sender][_spender] = _value;
278         emit Approval(msg.sender, _spender, _value);
279         return true;
280     }
281 
282     /**
283      * @dev Function to check the amount of tokens that an owner allowed to a spender.
284      * @param _who address The address which owns the funds.
285      * @param _spender address The address which will spend the funds.
286      * @return A uint256 specifying the amount of tokens still available for the spender.
287      */
288     function allowance(address _who, address _spender) public view returns (uint256) {
289         return allowed[_who][_spender];
290     }
291 
292     /**
293      * @dev Increase the amount of tokens that an owner allowed to a spender.
294      *
295      * approve should be called when allowed[_spender] == 0. To increment
296      * allowed value is better to use this function to avoid 2 calls (and wait until
297      * the first transaction is mined)
298      * From MonolithDAO Token.sol
299      * @param _spender The address which will spend the funds.
300      * @param _addedValue The amount of tokens to increase the allowance by.
301      */
302     function increaseApproval(address _spender, uint _addedValue) public whenNotFrozen returns (bool) {
303         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
304         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305         return true;
306     }
307 
308     /**
309      * @dev Decrease the amount of tokens that an owner allowed to a spender.
310      *
311      * approve should be called when allowed[_spender] == 0. To decrement
312      * allowed value is better to use this function to avoid 2 calls (and wait until
313      * the first transaction is mined)
314      * From MonolithDAO Token.sol
315      * @param _spender The address which will spend the funds.
316      * @param _subtractedValue The amount of tokens to decrease the allowance by.
317      */
318     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotFrozen returns (bool) {
319         uint oldValue = allowed[msg.sender][_spender];
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
333  * @title SafeMath
334  * @dev Math operations with safety checks that throw on error
335  */
336 library SafeMath {
337 
338     /**
339     * @dev Multiplies two numbers, throws on overflow.
340     */
341     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
342         if (a == 0) {
343             return 0;
344         }
345         uint256 c = a * b;
346         assert(c / a == b);
347         return c;
348     }
349 
350     /**
351     * @dev Integer division of two numbers, truncating the quotient.
352     */
353     function div(uint256 a, uint256 b) internal pure returns (uint256) {
354         // assert(b > 0); // Solidity automatically throws when dividing by 0
355         uint256 c = a / b;
356         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
357         return c;
358     }
359 
360     /**
361     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
362     */
363     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
364         assert(b <= a);
365         return a - b;
366     }
367 
368     /**
369     * @dev Adds two numbers, throws on overflow.
370     */
371     function add(uint256 a, uint256 b) internal pure returns (uint256) {
372         uint256 c = a + b;
373         assert(c >= a);
374         return c;
375     }
376 }