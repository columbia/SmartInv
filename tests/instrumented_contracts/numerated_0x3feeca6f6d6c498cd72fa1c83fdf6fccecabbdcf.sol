1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 
26 
27 
28 //import "./IERC20.sol";
29 //import "../../math/SafeMath.sol";
30 
31 
32 
33 /**
34  * @title SafeMath
35  * @dev Unsigned math operations with safety checks that revert on error
36  */
37 library SafeMath {
38     /**
39      * @dev Multiplies two unsigned integers, reverts on overflow.
40      */
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43         // benefit is lost if 'b' is also tested.
44         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b);
51 
52         return c;
53     }
54 
55     /**
56      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
57      */
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Solidity only automatically asserts when dividing by 0
60         require(b > 0);
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63 
64         return c;
65     }
66 
67     /**
68      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
69      */
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b <= a);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78      * @dev Adds two unsigned integers, reverts on overflow.
79      */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a);
83 
84         return c;
85     }
86 
87     /**
88      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
89      * reverts when dividing by zero.
90      */
91     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b != 0);
93         return a % b;
94     }
95 }
96 
97 
98 /**
99  * @title Standard ERC20 token
100  *
101  * @dev Implementation of the basic standard token.
102  * https://eips.ethereum.org/EIPS/eip-20
103  * Originally based on code by FirstBlood:
104  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
105  *
106  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
107  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
108  * compliant implementations may not do it.
109  */
110 contract ERC20 is IERC20 {
111     using SafeMath for uint256;
112 
113     mapping (address => uint256) private _balances;
114 
115     mapping (address => mapping (address => uint256)) private _allowed;
116 
117     uint256 private _totalSupply;
118 
119     /**
120      * @dev Total number of tokens in existence
121      */
122     function totalSupply() public view returns (uint256) {
123         return _totalSupply;
124     }
125 
126     /**
127      * @dev Gets the balance of the specified address.
128      * @param owner The address to query the balance of.
129      * @return A uint256 representing the amount owned by the passed address.
130      */
131     function balanceOf(address owner) public view returns (uint256) {
132         return _balances[owner];
133     }
134 
135     /**
136      * @dev Function to check the amount of tokens that an owner allowed to a spender.
137      * @param owner address The address which owns the funds.
138      * @param spender address The address which will spend the funds.
139      * @return A uint256 specifying the amount of tokens still available for the spender.
140      */
141     function allowance(address owner, address spender) public view returns (uint256) {
142         return _allowed[owner][spender];
143     }
144 
145     /**
146      * @dev Transfer token to a specified address
147      * @param to The address to transfer to.
148      * @param value The amount to be transferred.
149      */
150     function transfer(address to, uint256 value) public returns (bool) {
151         _transfer(msg.sender, to, value);
152         return true;
153     }
154 
155     /**
156      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157      * Beware that changing an allowance with this method brings the risk that someone may use both the old
158      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161      * @param spender The address which will spend the funds.
162      * @param value The amount of tokens to be spent.
163      */
164     function approve(address spender, uint256 value) public returns (bool) {
165         _approve(msg.sender, spender, value);
166         return true;
167     }
168 
169     /**
170      * @dev Transfer tokens from one address to another.
171      * Note that while this function emits an Approval event, this is not required as per the specification,
172      * and other compliant implementations may not emit the event.
173      * @param from address The address which you want to send tokens from
174      * @param to address The address which you want to transfer to
175      * @param value uint256 the amount of tokens to be transferred
176      */
177     function transferFrom(address from, address to, uint256 value) public returns (bool) {
178         _transfer(from, to, value);
179         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
180         return true;
181     }
182 
183     /**
184      * @dev Increase the amount of tokens that an owner allowed to a spender.
185      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
186      * allowed value is better to use this function to avoid 2 calls (and wait until
187      * the first transaction is mined)
188      * From MonolithDAO Token.sol
189      * Emits an Approval event.
190      * @param spender The address which will spend the funds.
191      * @param addedValue The amount of tokens to increase the allowance by.
192      */
193     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
194         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
195         return true;
196     }
197 
198     /**
199      * @dev Decrease the amount of tokens that an owner allowed to a spender.
200      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
201      * allowed value is better to use this function to avoid 2 calls (and wait until
202      * the first transaction is mined)
203      * From MonolithDAO Token.sol
204      * Emits an Approval event.
205      * @param spender The address which will spend the funds.
206      * @param subtractedValue The amount of tokens to decrease the allowance by.
207      */
208     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
209         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
210         return true;
211     }
212 
213     /**
214      * @dev Transfer token for a specified addresses
215      * @param from The address to transfer from.
216      * @param to The address to transfer to.
217      * @param value The amount to be transferred.
218      */
219     function _transfer(address from, address to, uint256 value) internal {
220         require(to != address(0));
221 
222         _balances[from] = _balances[from].sub(value);
223         _balances[to] = _balances[to].add(value);
224         emit Transfer(from, to, value);
225     }
226 
227     /**
228      * @dev Internal function that mints an amount of the token and assigns it to
229      * an account. This encapsulates the modification of balances such that the
230      * proper events are emitted.
231      * @param account The account that will receive the created tokens.
232      * @param value The amount that will be created.
233      */
234     function _mint(address account, uint256 value) internal {
235         require(account != address(0));
236 
237         _totalSupply = _totalSupply.add(value);
238         _balances[account] = _balances[account].add(value);
239         emit Transfer(address(0), account, value);
240     }
241 
242     /**
243      * @dev Internal function that burns an amount of the token of a given
244      * account.
245      * @param account The account whose tokens will be burnt.
246      * @param value The amount that will be burnt.
247      */
248     function _burn(address account, uint256 value) internal {
249         require(account != address(0));
250 
251         _totalSupply = _totalSupply.sub(value);
252         _balances[account] = _balances[account].sub(value);
253         emit Transfer(account, address(0), value);
254     }
255 
256     /**
257      * @dev Approve an address to spend another addresses' tokens.
258      * @param owner The address that owns the tokens.
259      * @param spender The address that will spend the tokens.
260      * @param value The number of tokens that can be spent.
261      */
262     function _approve(address owner, address spender, uint256 value) internal {
263         require(spender != address(0));
264         require(owner != address(0));
265 
266         _allowed[owner][spender] = value;
267         emit Approval(owner, spender, value);
268     }
269 
270     /**
271      * @dev Internal function that burns an amount of the token of a given
272      * account, deducting from the sender's allowance for said account. Uses the
273      * internal burn function.
274      * Emits an Approval event (reflecting the reduced allowance).
275      * @param account The account whose tokens will be burnt.
276      * @param value The amount that will be burnt.
277      */
278     function _burnFrom(address account, uint256 value) internal {
279         _burn(account, value);
280         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
281     }
282 }
283 
284 
285 
286 /**
287  * @title Ownable
288  * @dev The Ownable contract has an owner address, and provides basic authorization control
289  * functions, this simplifies the implementation of "user permissions".
290  */
291 contract Ownable {
292     address private _owner;
293 
294     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
295 
296     /**
297      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
298      * account.
299      */
300     constructor () internal {
301         _owner = msg.sender;
302         emit OwnershipTransferred(address(0), _owner);
303     }
304 
305     /**
306      * @return the address of the owner.
307      */
308     function owner() public view returns (address) {
309         return _owner;
310     }
311 
312     /**
313      * @dev Throws if called by any account other than the owner.
314      */
315     modifier onlyOwner() {
316         require(isOwner());
317         _;
318     }
319 
320     /**
321      * @return true if `msg.sender` is the owner of the contract.
322      */
323     function isOwner() public view returns (bool) {
324         return msg.sender == _owner;
325     }
326 
327     /**
328      * @dev Allows the current owner to relinquish control of the contract.
329      * It will not be possible to call the functions with the `onlyOwner`
330      * modifier anymore.
331      * @notice Renouncing ownership will leave the contract without an owner,
332      * thereby removing any functionality that is only available to the owner.
333      */
334     function renounceOwnership() public onlyOwner {
335         emit OwnershipTransferred(_owner, address(0));
336         _owner = address(0);
337     }
338 
339     /**
340      * @dev Allows the current owner to transfer control of the contract to a newOwner.
341      * @param newOwner The address to transfer ownership to.
342      */
343     function transferOwnership(address newOwner) public onlyOwner {
344         _transferOwnership(newOwner);
345     }
346 
347     /**
348      * @dev Transfers control of the contract to a newOwner.
349      * @param newOwner The address to transfer ownership to.
350      */
351     function _transferOwnership(address newOwner) internal {
352         require(newOwner != address(0));
353         emit OwnershipTransferred(_owner, newOwner);
354         _owner = newOwner;
355     }
356 }
357 
358 
359 //import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
360 //import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
361 
362 //import 'https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/master/contracts/token/ERC20/ERC20.sol';
363 //import 'https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/master/contracts/ownership/Ownable.sol';
364 
365 contract Famecoin is ERC20, Ownable {
366     
367   string public name;
368   string public symbol;
369   uint32 public decimals;
370   uint256 public _totalSupply;
371 
372   constructor() public {
373       
374     _totalSupply = 400000000000000000000000000;
375     decimals = 18;
376     symbol = "FMCO";
377     name = "Famecoin";
378     _mint(msg.sender, _totalSupply);
379   }
380 
381   function burnRemaining(uint256 _amount) external onlyOwner {
382   	_burn(msg.sender, _amount);
383   }
384 
385 }