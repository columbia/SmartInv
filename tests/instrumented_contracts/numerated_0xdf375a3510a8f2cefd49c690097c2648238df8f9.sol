1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0); // Solidity only automatically asserts when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 /**
67  * @title Roles
68  * @dev Library for managing addresses assigned to a Role.
69  */
70 library Roles {
71     struct Role {
72         mapping (address => bool) bearer;
73     }
74 
75     /**
76     * @dev give an account access to this role
77     */
78     function add(Role storage role, address account) internal {
79         require(account != address(0));
80         require(!has(role, account));
81 
82         role.bearer[account] = true;
83     }
84 
85     /**
86     * @dev remove an account's access to this role
87     */
88     function remove(Role storage role, address account) internal {
89         require(account != address(0));
90         require(has(role, account));
91 
92         role.bearer[account] = false;
93     }
94 
95     /**
96     * @dev check if an account has this role
97     * @return bool
98     */
99     function has(Role storage role, address account)
100       internal
101       view
102       returns (bool)
103     {
104         require(account != address(0));
105         return role.bearer[account];
106     }
107 }
108 
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
114  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 contract KvarkToken {
117 
118     string public name = "KVANTOR KVARK token";
119     string public symbol = "KVK";
120     uint public decimals = 18;
121 
122     constructor() public {
123         minters.add(msg.sender);
124         emit MinterAdded(msg.sender);
125         
126         owner = msg.sender;
127         emit OwnershipTransferred(address(0), owner);
128     }
129 
130     address private owner;
131 
132     event OwnershipTransferred(
133       address indexed previousOwner,
134       address indexed newOwner
135     );
136 
137     /**
138     * @return the address of the owner.
139     */
140     function getOwner() public view returns(address) {
141         return owner;  
142     }
143 
144     /**
145     * @dev Throws if called by any account other than the owner.
146     */
147     modifier onlyOwner() {
148         require(isOwner());
149         _;
150     }
151 
152     /**
153     * @return true if `msg.sender` is the owner of the contract.
154     */
155     function isOwner() public view returns(bool) {
156         return msg.sender == owner;
157     }
158 
159     /**
160     * @dev Allows the current owner to relinquish control of the contract.
161     * @notice Renouncing to ownership will leave the contract without an owner.
162     * It will not be possible to call the functions with the `onlyOwner`
163     * modifier anymore.
164     */
165     function renounceOwnership() public onlyOwner {
166         emit OwnershipTransferred(owner, address(0));
167         owner = address(0);
168     }
169 
170     /**
171     * @dev Allows the current owner to transfer control of the contract to a newOwner.
172     * @param newOwner The address to transfer ownership to.
173     */
174     function transferOwnership(address newOwner) public onlyOwner {
175         _transferOwnership(newOwner);
176     }
177 
178     /**
179     * @dev Transfers control of the contract to a newOwner.
180     * @param newOwner The address to transfer ownership to.
181     */
182     function _transferOwnership(address newOwner) internal {
183         require(newOwner != address(0));
184         emit OwnershipTransferred(owner, newOwner);
185         owner = newOwner;
186     }
187 
188     using SafeMath for uint256;
189 
190     mapping (address => uint256) private _balances;
191 
192     mapping (address => mapping (address => uint256)) private _allowed;
193 
194     uint256 private _totalSupply;
195 
196 
197     event Transfer(
198       address indexed from,
199       address indexed to,
200       uint256 value
201     );
202 
203     event Approval(
204       address indexed owner,
205       address indexed spender,
206       uint256 value
207     );
208 
209     /**
210     * @dev Total number of tokens in existence
211     */
212     function totalSupply() public view returns (uint256) {
213         return _totalSupply;
214     }
215 
216     /**
217     * @dev Gets the balance of the specified address.
218     * @param owner The address to query the balance of.
219     * @return An uint256 representing the amount owned by the passed address.
220     */
221     function balanceOf(address owner) public view returns (uint256) {
222         return _balances[owner];
223     }
224 
225     /**
226     * @dev Function to check the amount of tokens that an owner allowed to a spender.
227     * @param owner address The address which owns the funds.
228     * @param spender address The address which will spend the funds.
229     * @return A uint256 specifying the amount of tokens still available for the spender.
230     */
231     function allowance(address owner, address spender)
232       public
233       view
234       returns (uint256)
235     {
236         return _allowed[owner][spender];
237     }
238 
239     /**
240     * @dev Transfer token for a specified address
241     * @param to The address to transfer to.
242     * @param value The amount to be transferred.
243     */
244     function transfer(address to, uint256 value) public returns (bool) {
245         _transfer(msg.sender, to, value);
246         return true;
247     }
248 
249     /**
250     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251     * Beware that changing an allowance with this method brings the risk that someone may use both the old
252     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255     * @param spender The address which will spend the funds.
256     * @param value The amount of tokens to be spent.
257     */
258     function approve(address spender, uint256 value) public returns (bool) {
259         require(spender != address(0));
260 
261         _allowed[msg.sender][spender] = value;
262         emit Approval(msg.sender, spender, value);
263         return true;
264     }
265 
266     /**
267     * @dev Transfer tokens from one address to another
268     * @param from address The address which you want to send tokens from
269     * @param to address The address which you want to transfer to
270     * @param value uint256 the amount of tokens to be transferred
271     */
272     function transferFrom(address from, address to, uint256 value)
273       public
274       returns (bool)
275     {
276         require(value <= _allowed[from][msg.sender]);
277 
278         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
279         _transfer(from, to, value);
280         return true;
281     }
282 
283     /**
284     * @dev Increase the amount of tokens that an owner allowed to a spender.
285     * approve should be called when allowed_[_spender] == 0. To increment
286     * allowed value is better to use this function to avoid 2 calls (and wait until
287     * the first transaction is mined)
288     * From MonolithDAO Token.sol
289     * @param spender The address which will spend the funds.
290     * @param addedValue The amount of tokens to increase the allowance by.
291     */
292     function increaseAllowance(address spender, uint256 addedValue)
293       public
294       returns (bool)
295     {
296         require(spender != address(0));
297 
298         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
299         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
300         return true;
301     }
302 
303     /**
304     * @dev Decrease the amount of tokens that an owner allowed to a spender.
305     * approve should be called when allowed_[_spender] == 0. To decrement
306     * allowed value is better to use this function to avoid 2 calls (and wait until
307     * the first transaction is mined)
308     * From MonolithDAO Token.sol
309     * @param spender The address which will spend the funds.
310     * @param subtractedValue The amount of tokens to decrease the allowance by.
311     */
312     function decreaseAllowance(address spender,  uint256 subtractedValue)
313       public
314       returns (bool)
315     {
316         require(spender != address(0));
317 
318         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
319         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
320         return true;
321     }
322 
323     /**
324     * @dev Transfer token for a specified addresses
325     * @param from The address to transfer from.
326     * @param to The address to transfer to.
327     * @param value The amount to be transferred.
328     */
329     function _transfer(address from, address to, uint256 value) internal {
330         require(value <= _balances[from]);
331         require(to != address(0));
332 
333         _balances[from] = _balances[from].sub(value);
334         _balances[to] = _balances[to].add(value);
335         emit Transfer(from, to, value);
336     }
337 
338     /**
339     * @dev Function to mint tokens
340     * @param to The address that will receive the minted tokens.
341     * @param value The amount of tokens to mint.
342     * @return A boolean that indicates if the operation was successful.
343     */
344     function mint(address to, uint256 value) public returns (bool)
345     {
346         require(isMinter(msg.sender));
347         _mint(to, value);
348         return true;
349     }
350     /**
351     * @dev Internal function that mints an amount of the token and assigns it to
352     * an account. This encapsulates the modification of balances such that the
353     * proper events are emitted.
354     * @param account The account that will receive the created tokens.
355     * @param value The amount that will be created.
356     */
357     function _mint(address account, uint256 value) internal {
358         require(account != 0);
359         _totalSupply = _totalSupply.add(value);
360         _balances[account] = _balances[account].add(value);
361         emit Transfer(address(0), account, value);
362     }
363 
364       /**
365     * @dev Burns a specific amount of tokens.
366     * @param value The amount of token to be burned.
367     */
368     function burn(uint256 value) public {
369         _burn(msg.sender, value);
370     }
371 
372     /**
373     * @dev Burns a specific amount of tokens from the target address and decrements allowance
374     * @param from address The address which you want to send tokens from
375     * @param value uint256 The amount of token to be burned
376     */
377     function burnFrom(address from, uint256 value) public {
378         _burnFrom(from, value);
379     }
380 
381     /**
382     * @dev Internal function that burns an amount of the token of a given
383     * account.
384     * @param account The account whose tokens will be burnt.
385     * @param value The amount that will be burnt.
386     */
387     function _burn(address account, uint256 value) internal {
388         require(account != 0);
389         require(value <= _balances[account]);
390 
391         _totalSupply = _totalSupply.sub(value);
392         _balances[account] = _balances[account].sub(value);
393         emit Transfer(account, address(0), value);
394     }
395 
396     /**
397     * @dev Internal function that burns an amount of the token of a given
398     * account, deducting from the sender's allowance for said account. Uses the
399     * internal burn function.
400     * @param account The account whose tokens will be burnt.
401     * @param value The amount that will be burnt.
402     */
403     function _burnFrom(address account, uint256 value) internal {
404         require(value <= _allowed[account][msg.sender]);
405 
406         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
407         // this function needs to emit an event with the updated approval.
408         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
409         _burn(account, value);
410     }
411 
412     using Roles for Roles.Role;
413 
414     event MinterAdded(address indexed account);
415     event MinterRemoved(address indexed account);
416 
417     Roles.Role private minters;
418 
419     function isMinter(address account) public view returns (bool) {
420         return minters.has(account);
421     }
422 
423     function addMinter(address account) public onlyOwner {
424         minters.add(account);
425         emit MinterAdded(account);
426     }
427 
428     function renounceMinter(address account) public onlyOwner {
429         minters.remove(account);
430         emit MinterRemoved(account);
431     }
432 }