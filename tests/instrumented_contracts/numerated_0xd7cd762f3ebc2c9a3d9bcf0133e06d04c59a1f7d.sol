1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title Roles
69  * @dev Library for managing addresses assigned to a Role.
70  */
71 library Roles {
72     struct Role {
73         mapping (address => bool) bearer;
74     }
75 
76     /**
77      * @dev give an account access to this role
78      */
79     function add(Role storage role, address account) internal {
80         require(account != address(0));
81         require(!has(role, account));
82 
83         role.bearer[account] = true;
84     }
85 
86     /**
87      * @dev remove an account's access to this role
88      */
89     function remove(Role storage role, address account) internal {
90         require(account != address(0));
91         require(has(role, account));
92 
93         role.bearer[account] = false;
94     }
95 
96     /**
97      * @dev check if an account has this role
98      * @return bool
99      */
100     function has(Role storage role, address account) internal view returns (bool) {
101         require(account != address(0));
102         return role.bearer[account];
103     }
104 }
105 
106 /**
107  * @title Ownable
108  * @dev The Ownable contract has an owner address, and provides basic authorization control
109  * functions, this simplifies the implementation of "user permissions".
110  */
111 contract Ownable {
112     address private _owner;
113 
114     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115 
116     /**
117      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
118      * account.
119      */
120     constructor () internal {
121         _owner = msg.sender;
122         emit OwnershipTransferred(address(0), _owner);
123     }
124 
125     /**
126      * @return the address of the owner.
127      */
128     function owner() public view returns (address) {
129         return _owner;
130     }
131 
132     /**
133      * @dev Throws if called by any account other than the owner.
134      */
135     modifier onlyOwner() {
136         require(isOwner());
137         _;
138     }
139 
140     /**
141      * @return true if `msg.sender` is the owner of the contract.
142      */
143     function isOwner() public view returns (bool) {
144         return msg.sender == _owner;
145     }
146 
147     /**
148      * @dev Allows the current owner to relinquish control of the contract.
149      * It will not be possible to call the functions with the `onlyOwner`
150      * modifier anymore.
151      * @notice Renouncing ownership will leave the contract without an owner,
152      * thereby removing any functionality that is only available to the owner.
153      */
154     function renounceOwnership() public onlyOwner {
155         emit OwnershipTransferred(_owner, address(0));
156         _owner = address(0);
157     }
158 
159     /**
160      * @dev Allows the current owner to transfer control of the contract to a newOwner.
161      * @param newOwner The address to transfer ownership to.
162      */
163     function transferOwnership(address newOwner) public onlyOwner {
164         _transferOwnership(newOwner);
165     }
166 
167     /**
168      * @dev Transfers control of the contract to a newOwner.
169      * @param newOwner The address to transfer ownership to.
170      */
171     function _transferOwnership(address newOwner) internal {
172         require(newOwner != address(0));
173         emit OwnershipTransferred(_owner, newOwner);
174         _owner = newOwner;
175     }
176 }
177 
178 contract MinterRole {
179     using Roles for Roles.Role;
180 
181     event MinterAdded(address indexed account);
182     event MinterRemoved(address indexed account);
183 
184     Roles.Role private _minters;
185 
186     constructor () internal {
187         _addMinter(msg.sender);
188     }
189 
190     modifier onlyMinter() {
191         require(isMinter(msg.sender));
192         _;
193     }
194 
195     function isMinter(address account) public view returns (bool) {
196         return _minters.has(account);
197     }
198 
199     function addMinter(address account) public onlyMinter {
200         _addMinter(account);
201     }
202 
203     function renounceMinter() public {
204         _removeMinter(msg.sender);
205     }
206 
207     function _addMinter(address account) internal {
208         _minters.add(account);
209         emit MinterAdded(account);
210     }
211 
212     function _removeMinter(address account) internal {
213         _minters.remove(account);
214         emit MinterRemoved(account);
215     }
216 }
217 
218 contract ERC20Interface {
219      function totalSupply() public view returns (uint256);
220      function balanceOf(address tokenOwner) public view returns (uint256 balance);
221      function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
222      function transfer(address to, uint256 tokens) public returns (bool success);
223      function approve(address spender, uint256 tokens) public returns (bool success);
224      function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
225 
226      event Transfer(address indexed from, address indexed to, uint256 tokens);
227      event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
228 }
229 
230 contract Simmitri is ERC20Interface, Ownable, MinterRole{
231      using SafeMath for uint256;
232 
233      uint256 private _totalSupply;
234      mapping(address => uint256) private _balances;
235      mapping(address => mapping (address => uint256)) private _allowed;
236 
237      string public constant symbol = "SIM";
238      string public constant name = "Simmitri";
239      uint public constant decimals = 18;
240      
241      constructor () public {
242           _totalSupply = 500000000 * (10 ** decimals);
243           _balances[msg.sender] = _totalSupply;
244             
245           emit Transfer(address(0), msg.sender, _totalSupply);
246      }
247 
248      /**
249      * @dev Total number of tokens in existence
250      */
251      function totalSupply() public view returns (uint256) {
252           return _totalSupply;
253      }
254 
255      /**
256      * @dev Gets the balance of the specified address.
257      * @param owner The address to query the balance of.
258      * @return A uint256 representing the amount owned by the passed address.
259      */
260      function balanceOf(address owner) public view returns (uint256) {
261           return _balances[owner];
262      }
263 
264      /**
265      * @dev Transfer token to a specified address
266      * @param to The address to transfer to.
267      * @param value The amount to be transferred.
268      */
269      function transfer(address to, uint256 value) public returns (bool) {
270           _transfer(msg.sender, to, value);
271           return true;
272      }
273 
274      /**
275      * @dev Function to mint tokens
276      * @param to The address that will receive the minted tokens.
277      * @param value The amount of tokens to mint.
278      * @return A boolean that indicates if the operation was successful.
279      */
280      function mint(address to, uint256 value) public onlyMinter returns (bool) {
281           _mint(to, value);
282           return true;
283      }
284 
285      /**
286      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
287      * @param spender The address which will spend the funds.
288      * @param value The amount of tokens to be spent.
289      */
290      function approve(address spender, uint256 value) public returns (bool) {
291           _approve(msg.sender, spender, value);
292           return true;
293      }
294 
295      /**
296      * @dev Transfer tokens from one address to another.
297      * @param from address The address which you want to send tokens from
298      * @param to address The address which you want to transfer to
299      * @param value uint256 the amount of tokens to be transferred
300      */
301      function transferFrom(address from, address to, uint256 value) public returns (bool) {
302           _transfer(from, to, value);
303           _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
304           return true;
305      }
306 
307      /**
308      * @dev Function to check the amount of tokens that an owner allowed to a spender.
309      * @param owner address The address which owns the funds.
310      * @param spender address The address which will spend the funds.
311      * @return A uint256 specifying the amount of tokens still available for the spender.
312      */
313      function allowance(address owner, address spender) public view returns (uint256) {
314           return _allowed[owner][spender];
315      }
316 
317      /**
318      * @dev Increase the amount of tokens that an owner allowed to a spender.
319      * @param spender The address which will spend the funds.
320      * @param addedValue The amount of tokens to increase the allowance by.
321      */
322      function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
323           _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
324           return true;
325      }
326 
327      /**
328      * @dev Decrease the amount of tokens that an owner allowed to a spender.
329      * @param spender The address which will spend the funds.
330      * @param subtractedValue The amount of tokens to decrease the allowance by.
331      */
332      function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
333           _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
334           return true;
335      }
336 
337      /**
338      * @dev Transfer token for a specified addresses
339      * @param from The address to transfer from.
340      * @param to The address to transfer to.
341      * @param value The amount to be transferred.
342      */
343      function _transfer(address from, address to, uint256 value) internal {
344           require(to != address(0));
345 
346           _balances[from] = _balances[from].sub(value);
347           _balances[to] = _balances[to].add(value);
348           emit Transfer(from, to, value);
349      }
350 
351      /**
352      * @dev Internal function that mints an amount of the token and assigns it to
353      * an account. This encapsulates the modification of balances such that the
354      * proper events are emitted.
355      * @param account The account that will receive the created tokens.
356      * @param value The amount that will be created.
357      */
358      function _mint(address account, uint256 value) internal {
359           require(account != address(0));
360           
361           _totalSupply = _totalSupply.add(value);
362           _balances[account] = _balances[account].add(value);
363           emit Transfer(address(0), account, value);
364      }
365 
366      /**
367      * @dev Approve an address to spend another addresses' tokens.
368      * @param owner The address that owns the tokens.
369      * @param spender The address that will spend the tokens.
370      * @param value The number of tokens that can be spent.
371      */
372      function _approve(address owner, address spender, uint256 value) internal {
373           require(spender != address(0));
374           require(owner != address(0));
375 
376           _allowed[owner][spender] = value;
377           emit Approval(owner, spender, value);
378      }
379 
380      function () external payable {
381           revert();
382      }
383 }