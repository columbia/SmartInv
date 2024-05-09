1 pragma solidity ^0.5.2;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 
33 library SafeMath {
34     /**
35      * @dev Multiplies two unsigned integers, reverts on overflow.
36      */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53      */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Adds two unsigned integers, reverts on overflow.
75      */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85      * reverts when dividing by zero.
86      */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 library Roles {
94     struct Role {
95         mapping (address => bool) bearer;
96     }
97 
98     /**
99      * @dev Give an account access to this role.
100      */
101     function add(Role storage role, address account) internal {
102         require(!has(role, account));
103 
104         role.bearer[account] = true;
105     }
106 
107     /**
108      * @dev Remove an account's access to this role.
109      */
110     function remove(Role storage role, address account) internal {
111         require(has(role, account));
112 
113         role.bearer[account] = false;
114     }
115 
116     /**
117      * @dev Check if an account has this role.
118      * @return bool
119      */
120     function has(Role storage role, address account) internal view returns (bool) {
121         require(account != address(0));
122         return role.bearer[account];
123     }
124 }
125 
126 contract MinterRole {
127     using Roles for Roles.Role;
128 
129     event MinterAdded(address indexed account);
130     event MinterRemoved(address indexed account);
131 
132     Roles.Role private _minters;
133 
134     constructor () internal {
135         _addMinter(msg.sender);
136     }
137 
138     modifier onlyMinter() {
139         require(isMinter(msg.sender));
140         _;
141     }
142 
143     function isMinter(address account) public view returns (bool) {
144         return _minters.has(account);
145     }
146 
147     function addMinter(address account) public onlyMinter {
148         _addMinter(account);
149     }
150 
151     function renounceMinter() public {
152         _removeMinter(msg.sender);
153     }
154 
155     function _addMinter(address account) internal {
156         _minters.add(account);
157         emit MinterAdded(account);
158     }
159 
160     function _removeMinter(address account) internal {
161         _minters.remove(account);
162         emit MinterRemoved(account);
163     }
164 }
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * https://eips.ethereum.org/EIPS/eip-20
171  * Originally based on code by FirstBlood:
172  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
173  *
174  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
175  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
176  * compliant implementations may not do it.
177  */
178 contract ERC20 is IERC20 {
179     using SafeMath for uint256;
180 
181     mapping (address => uint256) private _balances;
182 
183     mapping (address => mapping (address => uint256)) private _allowed;
184 
185     uint256 private _totalSupply;
186 
187     /**
188      * @dev Total number of tokens in existence.
189      */
190     function totalSupply() public view returns (uint256) {
191         return _totalSupply;
192     }
193 
194     /**
195      * @dev Gets the balance of the specified address.
196      * @param owner The address to query the balance of.
197      * @return A uint256 representing the amount owned by the passed address.
198      */
199     function balanceOf(address owner) public view returns (uint256) {
200         return _balances[owner];
201     }
202 
203     /**
204      * @dev Function to check the amount of tokens that an owner allowed to a spender.
205      * @param owner address The address which owns the funds.
206      * @param spender address The address which will spend the funds.
207      * @return A uint256 specifying the amount of tokens still available for the spender.
208      */
209     function allowance(address owner, address spender) public view returns (uint256) {
210         return _allowed[owner][spender];
211     }
212 
213     /**
214      * @dev Transfer token to a specified address.
215      * @param to The address to transfer to.
216      * @param value The amount to be transferred.
217      */
218     function transfer(address to, uint256 value) public returns (bool) {
219         _transfer(msg.sender, to, value);
220         return true;
221     }
222 
223     /**
224      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
225      * Beware that changing an allowance with this method brings the risk that someone may use both the old
226      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
227      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
228      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229      * @param spender The address which will spend the funds.
230      * @param value The amount of tokens to be spent.
231      */
232     function approve(address spender, uint256 value) public returns (bool) {
233         _approve(msg.sender, spender, value);
234         return true;
235     }
236 
237     /**
238      * @dev Transfer tokens from one address to another.
239      * Note that while this function emits an Approval event, this is not required as per the specification,
240      * and other compliant implementations may not emit the event.
241      * @param from address The address which you want to send tokens from
242      * @param to address The address which you want to transfer to
243      * @param value uint256 the amount of tokens to be transferred
244      */
245     function transferFrom(address from, address to, uint256 value) public returns (bool) {
246         _transfer(from, to, value);
247         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
248         return true;
249     }
250 
251     /**
252      * @dev Increase the amount of tokens that an owner allowed to a spender.
253      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
254      * allowed value is better to use this function to avoid 2 calls (and wait until
255      * the first transaction is mined)
256      * From MonolithDAO Token.sol
257      * Emits an Approval event.
258      * @param spender The address which will spend the funds.
259      * @param addedValue The amount of tokens to increase the allowance by.
260      */
261     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
262         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
263         return true;
264     }
265 
266     /**
267      * @dev Decrease the amount of tokens that an owner allowed to a spender.
268      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
269      * allowed value is better to use this function to avoid 2 calls (and wait until
270      * the first transaction is mined)
271      * From MonolithDAO Token.sol
272      * Emits an Approval event.
273      * @param spender The address which will spend the funds.
274      * @param subtractedValue The amount of tokens to decrease the allowance by.
275      */
276     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
277         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
278         return true;
279     }
280 
281     /**
282      * @dev Transfer token for a specified addresses.
283      * @param from The address to transfer from.
284      * @param to The address to transfer to.
285      * @param value The amount to be transferred.
286      */
287     function _transfer(address from, address to, uint256 value) internal {
288         require(to != address(0));
289 
290         _balances[from] = _balances[from].sub(value);
291         _balances[to] = _balances[to].add(value);
292         emit Transfer(from, to, value);
293     }
294 
295     /**
296      * @dev Internal function that mints an amount of the token and assigns it to
297      * an account. This encapsulates the modification of balances such that the
298      * proper events are emitted.
299      * @param account The account that will receive the created tokens.
300      * @param value The amount that will be created.
301      */
302     function _mint(address account, uint256 value) internal {
303         require(account != address(0));
304 
305         _totalSupply = _totalSupply.add(value);
306         _balances[account] = _balances[account].add(value);
307         emit Transfer(address(0), account, value);
308     }
309 
310     /**
311      * @dev Internal function that burns an amount of the token of a given
312      * account.
313      * @param account The account whose tokens will be burnt.
314      * @param value The amount that will be burnt.
315      */
316     function _burn(address account, uint256 value) internal {
317         require(account != address(0));
318 
319         _totalSupply = _totalSupply.sub(value);
320         _balances[account] = _balances[account].sub(value);
321         emit Transfer(account, address(0), value);
322     }
323 
324     /**
325      * @dev Approve an address to spend another addresses' tokens.
326      * @param owner The address that owns the tokens.
327      * @param spender The address that will spend the tokens.
328      * @param value The number of tokens that can be spent.
329      */
330     function _approve(address owner, address spender, uint256 value) internal {
331         require(spender != address(0));
332         require(owner != address(0));
333 
334         _allowed[owner][spender] = value;
335         emit Approval(owner, spender, value);
336     }
337 
338     /**
339      * @dev Internal function that burns an amount of the token of a given
340      * account, deducting from the sender's allowance for said account. Uses the
341      * internal burn function.
342      * Emits an Approval event (reflecting the reduced allowance).
343      * @param account The account whose tokens will be burnt.
344      * @param value The amount that will be burnt.
345      */
346     function _burnFrom(address account, uint256 value) internal {
347         _burn(account, value);
348         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
349     }
350 }
351 
352 
353 contract ERC20Mintable is ERC20, MinterRole {
354     /**
355      * @dev Function to mint tokens
356      * @param to The address that will receive the minted tokens.
357      * @param value The amount of tokens to mint.
358      * @return A boolean that indicates if the operation was successful.
359      */
360     function mint(address to, uint256 value) public onlyMinter returns (bool) {
361         _mint(to, value);
362         return true;
363     }
364 }