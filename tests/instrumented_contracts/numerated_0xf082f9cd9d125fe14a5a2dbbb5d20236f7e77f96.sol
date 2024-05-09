1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
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
20         require(c / a == b, "SafeMath: multiplication overflow");
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0, "SafeMath: division by zero");
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
41         require(b <= a, "SafeMath: subtraction overflow");
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
52         require(c >= a, "SafeMath: addition overflow");
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0, "SafeMath: modulo by zero");
63         return a % b;
64     }
65 }
66 /**
67  * @title ERC20 interface
68  * @dev see https://eips.ethereum.org/EIPS/eip-20
69  */
70 interface IERC20 {
71     function transfer(address to, uint256 value) external returns (bool);
72 
73     function approve(address spender, uint256 value) external returns (bool);
74 
75     function transferFrom(address from, address to, uint256 value) external returns (bool);
76 
77     function totalSupply() external view returns (uint256);
78 
79     function balanceOf(address who) external view returns (uint256);
80 
81     function allowance(address owner, address spender) external view returns (uint256);
82 
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 /**
88  * @title Standard ERC20 token
89  *
90  * @dev Implementation of the basic standard token.
91  * https://eips.ethereum.org/EIPS/eip-20
92  * Originally based on code by FirstBlood:
93  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  *
95  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
96  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
97  * compliant implementations may not do it.
98  */
99 contract ERC20 is IERC20 {
100     using SafeMath for uint256;
101 
102     mapping (address => uint256) private _balances;
103 
104     mapping (address => mapping (address => uint256)) private _allowed;
105 
106     uint256 private _totalSupply;
107 
108     /**
109      * @dev Total number of tokens in existence.
110      */
111     function totalSupply() public view returns (uint256) {
112         return _totalSupply;
113     }
114 
115     /**
116      * @dev Gets the balance of the specified address.
117      * @param owner The address to query the balance of.
118      * @return A uint256 representing the amount owned by the passed address.
119      */
120     function balanceOf(address owner) public view returns (uint256) {
121         return _balances[owner];
122     }
123 
124     /**
125      * @dev Function to check the amount of tokens that an owner allowed to a spender.
126      * @param owner address The address which owns the funds.
127      * @param spender address The address which will spend the funds.
128      * @return A uint256 specifying the amount of tokens still available for the spender.
129      */
130     function allowance(address owner, address spender) public view returns (uint256) {
131         return _allowed[owner][spender];
132     }
133 
134     /**
135      * @dev Transfer token to a specified address.
136      * @param to The address to transfer to.
137      * @param value The amount to be transferred.
138      */
139     function transfer(address to, uint256 value) public returns (bool) {
140         _transfer(msg.sender, to, value);
141         return true;
142     }
143 
144     /**
145      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146      * Beware that changing an allowance with this method brings the risk that someone may use both the old
147      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
148      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
149      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150      * @param spender The address which will spend the funds.
151      * @param value The amount of tokens to be spent.
152      */
153     function approve(address spender, uint256 value) public returns (bool) {
154         _approve(msg.sender, spender, value);
155         return true;
156     }
157 
158     /**
159      * @dev Transfer tokens from one address to another.
160      * Note that while this function emits an Approval event, this is not required as per the specification,
161      * and other compliant implementations may not emit the event.
162      * @param from address The address which you want to send tokens from
163      * @param to address The address which you want to transfer to
164      * @param value uint256 the amount of tokens to be transferred
165      */
166     function transferFrom(address from, address to, uint256 value) public returns (bool) {
167         _transfer(from, to, value);
168         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
169         return true;
170     }
171 
172     /**
173      * @dev Increase the amount of tokens that an owner allowed to a spender.
174      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
175      * allowed value is better to use this function to avoid 2 calls (and wait until
176      * the first transaction is mined)
177      * From MonolithDAO Token.sol
178      * Emits an Approval event.
179      * @param spender The address which will spend the funds.
180      * @param addedValue The amount of tokens to increase the allowance by.
181      */
182     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
183         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
184         return true;
185     }
186 
187     /**
188      * @dev Decrease the amount of tokens that an owner allowed to a spender.
189      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
190      * allowed value is better to use this function to avoid 2 calls (and wait until
191      * the first transaction is mined)
192      * From MonolithDAO Token.sol
193      * Emits an Approval event.
194      * @param spender The address which will spend the funds.
195      * @param subtractedValue The amount of tokens to decrease the allowance by.
196      */
197     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
198         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
199         return true;
200     }
201 
202     /**
203      * @dev Transfer token for a specified addresses.
204      * @param from The address to transfer from.
205      * @param to The address to transfer to.
206      * @param value The amount to be transferred.
207      */
208     function _transfer(address from, address to, uint256 value) internal {
209         require(to != address(0), "ERC20: transfer to the zero address");
210 
211         _balances[from] = _balances[from].sub(value);
212         _balances[to] = _balances[to].add(value);
213         emit Transfer(from, to, value);
214     }
215 
216     /**
217      * @dev Internal function that mints an amount of the token and assigns it to
218      * an account. This encapsulates the modification of balances such that the
219      * proper events are emitted.
220      * @param account The account that will receive the created tokens.
221      * @param value The amount that will be created.
222      */
223     function _mint(address account, uint256 value) internal {
224         require(account != address(0), "ERC20: mint to the zero address");
225 
226         _totalSupply = _totalSupply.add(value);
227         _balances[account] = _balances[account].add(value);
228         emit Transfer(address(0), account, value);
229     }
230 
231     /**
232      * @dev Internal function that burns an amount of the token of a given
233      * account.
234      * @param account The account whose tokens will be burnt.
235      * @param value The amount that will be burnt.
236      */
237     function _burn(address account, uint256 value) internal {
238         require(account != address(0), "ERC20: burn from the zero address");
239 
240         _totalSupply = _totalSupply.sub(value);
241         _balances[account] = _balances[account].sub(value);
242         emit Transfer(account, address(0), value);
243     }
244 
245     /**
246      * @dev Approve an address to spend another addresses' tokens.
247      * @param owner The address that owns the tokens.
248      * @param spender The address that will spend the tokens.
249      * @param value The number of tokens that can be spent.
250      */
251     function _approve(address owner, address spender, uint256 value) internal {
252         require(owner != address(0), "ERC20: approve from the zero address");
253         require(spender != address(0), "ERC20: approve to the zero address");
254 
255         _allowed[owner][spender] = value;
256         emit Approval(owner, spender, value);
257     }
258 
259     /**
260      * @dev Internal function that burns an amount of the token of a given
261      * account, deducting from the sender's allowance for said account. Uses the
262      * internal burn function.
263      * Emits an Approval event (reflecting the reduced allowance).
264      * @param account The account whose tokens will be burnt.
265      * @param value The amount that will be burnt.
266      */
267     function _burnFrom(address account, uint256 value) internal {
268         _burn(account, value);
269         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
270     }
271 }
272 
273 
274 contract Coinerium is ERC20{
275   using SafeMath for uint256;
276   
277   OracleInterface oracle;
278   string public constant symbol = "CONM";
279   string public constant name = "Coinerium";
280   uint8 public constant decimals = 18;
281   uint256 internal _reserveOwnerSupply;
282   address owner;
283   
284   
285   constructor(address oracleAddress) public {
286     oracle = OracleInterface(oracleAddress);
287     _reserveOwnerSupply = 300000000 * 10**uint(decimals); //300 million
288     owner = msg.sender;
289     _mint(owner,_reserveOwnerSupply);
290   }
291 
292   function donate() public payable {}
293 
294   function flush() public payable {
295     //amount in cents
296     uint256 amount = msg.value.mul(oracle.price());
297     uint256 finalAmount= amount.div(1 ether);
298     _mint(msg.sender,finalAmount);
299   }
300 
301   function getPrice() public view returns (uint256) {
302     return oracle.price();
303   }
304 
305   function withdraw(uint256 amountCent) public returns (uint256 amountWei){
306     require(amountCent <= balanceOf(msg.sender));
307     amountWei = (amountCent.mul(1 ether)).div(oracle.price());
308 
309     // If we don't have enough Ether in the contract to pay out the full amount
310     // pay an amount proportinal to what we have left.
311     // this way user's net worth will never drop at a rate quicker than
312     // the collateral itself.
313 
314     // For Example:
315     // A user deposits 1 Ether when the price of Ether is $300
316     // the price then falls to $150.
317     // If we have enough Ether in the contract we cover ther losses
318     // and pay them back 2 ether (the same amount in USD).
319     // if we don't have enough money to pay them back we pay out
320     // proportonailly to what we have left. In this case they'd
321     // get back their original deposit of 1 Ether.
322     if(balanceOf(msg.sender) <= amountWei) {
323       amountWei = amountWei.mul(balanceOf(msg.sender));
324       amountWei = amountWei.mul(oracle.price());
325       amountWei = amountWei.div(1 ether);
326       amountWei = amountWei.mul(totalSupply());
327     }
328     _burn(msg.sender,amountCent);
329     msg.sender.transfer(amountWei);
330   }
331 }
332 
333 interface OracleInterface {
334 
335   function price() external view returns (uint256);
336 
337 }
338 contract MockOracle is OracleInterface {
339 
340     uint256 public price_;
341     address owner;
342     
343     // functions with this modifier can only be executed by the owner
344     modifier onlyOwner() {
345         if (msg.sender != owner) {
346             revert();
347         }
348          _;
349     }
350     
351     constructor() public {
352         owner = msg.sender;
353     }
354 
355     function setPrice(uint256 price) public onlyOwner {
356     
357       price_ = price;
358 
359     }
360 
361     function price() public view returns (uint256){
362 
363       return price_;
364 
365     }
366 
367 }