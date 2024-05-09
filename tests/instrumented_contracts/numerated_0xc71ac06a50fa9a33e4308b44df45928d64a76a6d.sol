1 pragma solidity ^0.5.2;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  E:\OneDrive\00.애니팬\00.CRYPTO_CURRENCY\NFRD\Contract_Solidity\contract\NFRD.sol
6 // flattened :  Friday, 08-Mar-19 05:11:59 UTC
7 contract Ownable {
8     address private _owner;
9 
10     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12     /**
13      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14      * account.
15      */
16     constructor () internal {
17         _owner = msg.sender;
18         emit OwnershipTransferred(address(0), _owner);
19     }
20 
21     /**
22      * @return the address of the owner.
23      */
24     function owner() public view returns (address) {
25         return _owner;
26     }
27 
28     /**
29      * @dev Throws if called by any account other than the owner.
30      */
31     modifier onlyOwner() {
32         require(isOwner());
33         _;
34     }
35 
36     /**
37      * @return true if `msg.sender` is the owner of the contract.
38      */
39     function isOwner() public view returns (bool) {
40         return msg.sender == _owner;
41     }
42 
43     /**
44      * @dev Allows the current owner to relinquish control of the contract.
45      * It will not be possible to call the functions with the `onlyOwner`
46      * modifier anymore.
47      * @notice Renouncing ownership will leave the contract without an owner,
48      * thereby removing any functionality that is only available to the owner.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 interface IERC20 {
74     function transfer(address to, uint256 value) external returns (bool);
75 
76     function approve(address spender, uint256 value) external returns (bool);
77 
78     function transferFrom(address from, address to, uint256 value) external returns (bool);
79 
80     function totalSupply() external view returns (uint256);
81 
82     function balanceOf(address who) external view returns (uint256);
83 
84     function allowance(address owner, address spender) external view returns (uint256);
85 
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 library SafeMath {
91     /**
92      * @dev Multiplies two unsigned integers, reverts on overflow.
93      */
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
96         // benefit is lost if 'b' is also tested.
97         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
98         if (a == 0) {
99             return 0;
100         }
101 
102         uint256 c = a * b;
103         require(c / a == b);
104 
105         return c;
106     }
107 
108     /**
109      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
110      */
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         // Solidity only automatically asserts when dividing by 0
113         require(b > 0);
114         uint256 c = a / b;
115         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117         return c;
118     }
119 
120     /**
121      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b <= a);
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Adds two unsigned integers, reverts on overflow.
132      */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         uint256 c = a + b;
135         require(c >= a);
136 
137         return c;
138     }
139 
140     /**
141      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
142      * reverts when dividing by zero.
143      */
144     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145         require(b != 0);
146         return a % b;
147     }
148 }
149 contract ERC20Detailed is IERC20 {
150     string private _name;
151     string private _symbol;
152     uint8 private _decimals;
153 
154     constructor (string memory name, string memory symbol, uint8 decimals) public {
155         _name = name;
156         _symbol = symbol;
157         _decimals = decimals;
158     }
159 
160     /**
161      * @return the name of the token.
162      */
163     function name() public view returns (string memory) {
164         return _name;
165     }
166 
167     /**
168      * @return the symbol of the token.
169      */
170     function symbol() public view returns (string memory) {
171         return _symbol;
172     }
173 
174     /**
175      * @return the number of decimals of the token.
176      */
177     function decimals() public view returns (uint8) {
178         return _decimals;
179     }
180 }
181 contract ERC20 is IERC20 {
182     using SafeMath for uint256;
183 
184     mapping (address => uint256) private _balances;
185 
186     mapping (address => mapping (address => uint256)) private _allowed;
187 
188     uint256 private _totalSupply;
189 
190     /**
191      * @dev Total number of tokens in existence
192      */
193     function totalSupply() public view returns (uint256) {
194         return _totalSupply;
195     }
196 
197     /**
198      * @dev Gets the balance of the specified address.
199      * @param owner The address to query the balance of.
200      * @return A uint256 representing the amount owned by the passed address.
201      */
202     function balanceOf(address owner) public view returns (uint256) {
203         return _balances[owner];
204     }
205 
206     /**
207      * @dev Function to check the amount of tokens that an owner allowed to a spender.
208      * @param owner address The address which owns the funds.
209      * @param spender address The address which will spend the funds.
210      * @return A uint256 specifying the amount of tokens still available for the spender.
211      */
212     function allowance(address owner, address spender) public view returns (uint256) {
213         return _allowed[owner][spender];
214     }
215 
216     /**
217      * @dev Transfer token to a specified address
218      * @param to The address to transfer to.
219      * @param value The amount to be transferred.
220      */
221     function transfer(address to, uint256 value) public returns (bool) {
222         _transfer(msg.sender, to, value);
223         return true;
224     }
225 
226     /**
227      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228      * Beware that changing an allowance with this method brings the risk that someone may use both the old
229      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232      * @param spender The address which will spend the funds.
233      * @param value The amount of tokens to be spent.
234      */
235     function approve(address spender, uint256 value) public returns (bool) {
236         _approve(msg.sender, spender, value);
237         return true;
238     }
239 
240     /**
241      * @dev Transfer tokens from one address to another.
242      * Note that while this function emits an Approval event, this is not required as per the specification,
243      * and other compliant implementations may not emit the event.
244      * @param from address The address which you want to send tokens from
245      * @param to address The address which you want to transfer to
246      * @param value uint256 the amount of tokens to be transferred
247      */
248     function transferFrom(address from, address to, uint256 value) public returns (bool) {
249         _transfer(from, to, value);
250         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
251         return true;
252     }
253 
254     /**
255      * @dev Increase the amount of tokens that an owner allowed to a spender.
256      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
257      * allowed value is better to use this function to avoid 2 calls (and wait until
258      * the first transaction is mined)
259      * From MonolithDAO Token.sol
260      * Emits an Approval event.
261      * @param spender The address which will spend the funds.
262      * @param addedValue The amount of tokens to increase the allowance by.
263      */
264     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
265         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
266         return true;
267     }
268 
269     /**
270      * @dev Decrease the amount of tokens that an owner allowed to a spender.
271      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
272      * allowed value is better to use this function to avoid 2 calls (and wait until
273      * the first transaction is mined)
274      * From MonolithDAO Token.sol
275      * Emits an Approval event.
276      * @param spender The address which will spend the funds.
277      * @param subtractedValue The amount of tokens to decrease the allowance by.
278      */
279     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
280         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
281         return true;
282     }
283 
284     /**
285      * @dev Transfer token for a specified addresses
286      * @param from The address to transfer from.
287      * @param to The address to transfer to.
288      * @param value The amount to be transferred.
289      */
290     function _transfer(address from, address to, uint256 value) internal {
291         require(to != address(0));
292 
293         _balances[from] = _balances[from].sub(value);
294         _balances[to] = _balances[to].add(value);
295         emit Transfer(from, to, value);
296     }
297 
298     /**
299      * @dev Internal function that mints an amount of the token and assigns it to
300      * an account. This encapsulates the modification of balances such that the
301      * proper events are emitted.
302      * @param account The account that will receive the created tokens.
303      * @param value The amount that will be created.
304      */
305     function _mint(address account, uint256 value) internal {
306         require(account != address(0));
307 
308         _totalSupply = _totalSupply.add(value);
309         _balances[account] = _balances[account].add(value);
310         emit Transfer(address(0), account, value);
311     }
312 
313     /**
314      * @dev Internal function that burns an amount of the token of a given
315      * account.
316      * @param account The account whose tokens will be burnt.
317      * @param value The amount that will be burnt.
318      */
319     function _burn(address account, uint256 value) internal {
320         require(account != address(0));
321 
322         _totalSupply = _totalSupply.sub(value);
323         _balances[account] = _balances[account].sub(value);
324         emit Transfer(account, address(0), value);
325     }
326 
327     /**
328      * @dev Approve an address to spend another addresses' tokens.
329      * @param owner The address that owns the tokens.
330      * @param spender The address that will spend the tokens.
331      * @param value The number of tokens that can be spent.
332      */
333     function _approve(address owner, address spender, uint256 value) internal {
334         require(spender != address(0));
335         require(owner != address(0));
336 
337         _allowed[owner][spender] = value;
338         emit Approval(owner, spender, value);
339     }
340 
341     /**
342      * @dev Internal function that burns an amount of the token of a given
343      * account, deducting from the sender's allowance for said account. Uses the
344      * internal burn function.
345      * Emits an Approval event (reflecting the reduced allowance).
346      * @param account The account whose tokens will be burnt.
347      * @param value The amount that will be burnt.
348      */
349     function _burnFrom(address account, uint256 value) internal {
350         _burn(account, value);
351         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
352     }
353 }
354 
355 contract NFRD is ERC20, ERC20Detailed {
356     uint8 public constant DECIMALS = 3;
357     uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(DECIMALS));
358 
359     /**
360      * @dev Constructor that gives msg.sender all of existing tokens.
361      */
362     constructor () public ERC20Detailed("New Friendscoin Token", "NFRD", DECIMALS) {
363         _mint(msg.sender, INITIAL_SUPPLY);
364     }
365 }