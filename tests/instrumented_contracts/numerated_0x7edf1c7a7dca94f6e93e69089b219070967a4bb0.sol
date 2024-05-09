1 pragma solidity 0.5.9;
2 
3 /**
4  * @title SafeMath 
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplie two unsigned integers, revert on overflow.
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
26      * @dev Integer division of two unsigned integers truncating the quotient, revert on division by zero.
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
38      * @dev Subtract two unsigned integers, revert on underflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Add two unsigned integers, revert on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 
58 /*
59  * @dev Provides information about the current execution context, including the
60  * sender of the transaction and its data. While these are generally available
61  * via msg.sender and msg.data, they should not be accessed in such a direct
62  * manner, since when dealing with GSN meta-transactions the account sending and
63  * paying for execution may not be the actual sender (as far as an application
64  * is concerned).
65  *
66  * This contract is only required for intermediate, library-like contracts.
67  */
68 contract Context {
69     // Empty internal constructor, to prevent people from mistakenly deploying
70     // an instance of this contract, which should be used via inheritance.
71     constructor () internal { }
72 
73     function _msgSender() internal view returns (address payable) {
74         return msg.sender;
75     }
76 }
77 
78 /**
79  * @title ERC20 interface
80  * @dev See https://eips.ethereum.org/EIPS/eip-20
81  */
82 interface IERC20 {
83     function transfer(address to, uint256 value) external returns (bool); 
84 
85     function approve(address spender, uint256 value) external returns (bool); 
86 
87     function transferFrom(address from, address to, uint256 value) external returns (bool); 
88 
89     function totalSupply() external view returns (uint256); 
90 
91     function balanceOf(address who) external view returns (uint256);
92 
93     function allowance(address owner, address spender) external view returns (uint256); 
94 
95     event Transfer(address indexed from, address indexed to, uint256 value); 
96 
97     event Approval(address indexed owner, address indexed spender, uint256 value); 
98 }
99 
100 
101 /**
102  * @title Standard ERC20 token
103  * @dev Implementation of the basic standard token.
104  */
105 contract StandardToken is IERC20, Context {
106     using SafeMath for uint256; 
107     
108     mapping (address => uint256) internal _balances; 
109     mapping (address => mapping (address => uint256)) internal _allowed; 
110     
111     uint256 internal _totalSupply; 
112     
113     /**
114      * @dev Total number of tokens in existence.
115      */
116     function totalSupply() public view returns (uint256) {
117         return _totalSupply; 
118     }
119 
120     /**
121      * @dev Get the balance of the specified address.
122      * @param owner The address to query the balance of.
123      * @return A uint256 representing the amount owned by the passed address.
124      */
125     function balanceOf(address owner) public view  returns (uint256) {
126         return _balances[owner];
127     }
128 
129     /**
130      * @dev Function to check the amount of tokens that an owner allowed to a spender.
131      * @param owner The address which owns the funds.
132      * @param spender The address which will spend the funds.
133      * @return A uint256 specifying the amount of tokens still available for the spender.
134      */
135     function allowance(address owner, address spender) public view returns (uint256) {
136         return _allowed[owner][spender];
137     }
138 
139     /**
140      * @dev Transfer tokens to a specified address.
141      * @param to The address to transfer to.
142      * @param value The amount to be transferred.
143      */
144     function transfer(address to, uint256 value) public returns (bool) {
145         _transfer(_msgSender(), to, value);
146         return true;
147     }
148 
149     /**
150      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151      * Beware that changing an allowance with this method brings the risk that someone may use both the old
152      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      * @param spender The address which will spend the funds.
156      * @param value The amount of tokens to be spent.
157      */
158     function approve(address spender, uint256 value) public returns (bool) {
159         _approve(_msgSender(), spender, value); 
160         return true;
161     }
162 
163     /**
164      * @dev Transfer tokens from one address to another.
165      * Note that while this function emits an Approval event, this is not required as per the specification,
166      * and other compliant implementations may not emit the event.
167      * @param from The address which you want to send tokens from.
168      * @param to The address which you want to transfer to.
169      * @param value The amount of tokens to be transferred.
170      */
171     function transferFrom(address from, address to, uint256 value) public returns (bool) {
172         _transfer(from, to, value); 
173         _approve(from, _msgSender(), _allowed[from][_msgSender()].sub(value)); 
174         return true;
175     }
176 
177     /**
178      * @dev Increase the amount of tokens that an owner allowed to a spender.
179      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
180      * allowed value is better to use this function to avoid 2 calls (and wait until
181      * the first transaction is mined)
182      * From MonolithDAO Token.sol
183      * Emits an Approval event.
184      * @param spender The address which will spend the funds.
185      * @param addedValue The amount of tokens to increase the allowance by.
186      */
187     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
188         _approve(_msgSender(), spender, _allowed[_msgSender()][spender].add(addedValue)); 
189         return true;
190     }
191 
192     /**
193      * @dev Decrease the amount of tokens that an owner allowed to a spender.
194      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
195      * allowed value is better to use this function to avoid 2 calls (and wait until
196      * the first transaction is mined)
197      * From MonolithDAO Token.sol
198      * Emits an Approval event.
199      * @param spender The address which will spend the funds.
200      * @param subtractedValue The amount of tokens to decrease the allowance by.
201      */
202     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
203         _approve(_msgSender(), spender, _allowed[_msgSender()][spender].sub(subtractedValue));
204         return true;
205     }
206 
207     /**
208      * @dev Transfer tokens for a specified address.
209      * @param from The address to transfer from.
210      * @param to The address to transfer to.
211      * @param value The amount to be transferred.
212      */
213     function _transfer(address from, address to, uint256 value) internal {
214         require(to != address(0), "Cannot transfer to the zero address"); 
215         _balances[from] = _balances[from].sub(value); 
216         _balances[to] = _balances[to].add(value); 
217         emit Transfer(from, to, value); 
218     }
219 
220     /**
221      * @dev Approve an address to spend another addresses' tokens.
222      * @param owner The address that owns the tokens.
223      * @param spender The address that will spend the tokens.
224      * @param value The number of tokens that can be spent.
225      */
226     function _approve(address owner, address spender, uint256 value) internal {
227         require(spender != address(0), "Cannot approve to the zero address"); 
228         require(owner != address(0), "Setter cannot be the zero address"); 
229 	    _allowed[owner][spender] = value;
230         emit Approval(owner, spender, value); 
231     }
232 
233     /**
234      * @dev Destroys `amount` tokens from `account`, reducing the
235      * total supply.
236      *
237      * Emits a {Transfer} event with `to` set to the zero address.
238      *
239      * Requirements
240      *
241      * - `account` cannot be the zero address.
242      * - `account` must have at least `amount` tokens.
243      */
244     function _burn(address account, uint256 amount) internal {
245         require(account != address(0), "ERC20: burn from the zero address");
246         _balances[account] = _balances[account].sub(amount);
247         _totalSupply = _totalSupply.sub(amount);
248         emit Transfer(account, address(0), amount);
249     }
250 
251     /**
252      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
253      * from the caller's allowance.
254      *
255      * See {_burn} and {_approve}.
256      */
257     function _burnFrom(address account, uint256 amount) internal {
258         _burn(account, amount);
259         _approve(account, _msgSender(), _allowed[account][_msgSender()].sub(amount));
260     }
261 
262 }
263 
264 /**
265  * @dev Contract module which provides a basic access control mechanism, where
266  * there is an account (an owner) that can be granted exclusive access to
267  * specific functions.
268  *
269  * This module is used through inheritance. It will make available the modifier
270  * `onlyOwner`, which can be applied to your functions to restrict their use to
271  * the owner.
272  */
273 contract Ownable is Context {
274     address internal _owner;
275 
276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
277 
278     /**
279      * @dev Returns the address of the current owner.
280      */
281     function owner() public view returns (address) {
282         return _owner;
283     }
284 
285     /**
286      * @dev Throws if called by any account other than the owner.
287      */
288     modifier onlyOwner() {
289         require(isOwner(), "Ownable: caller is not the owner");
290         _;
291     }
292 
293     /**
294      * @dev Returns true if the caller is the current owner.
295      */
296     function isOwner() public view returns (bool) {
297         return _msgSender() == _owner;
298     }
299 
300     /**
301      * @dev Transfers ownership of the contract to a new account (`newOwner`).
302      * Can only be called by the current owner.
303      */
304     function transferOwnership(address newOwner) public onlyOwner {
305         _transferOwnership(newOwner);
306     }
307 
308     /**
309      * @dev Transfers ownership of the contract to a new account (`newOwner`).
310      */
311     function _transferOwnership(address newOwner) internal {
312         require(newOwner != address(0), "Ownable: new owner is the zero address");
313         emit OwnershipTransferred(_owner, newOwner);
314         _owner = newOwner;
315     }
316 }
317 
318 contract GCToken is StandardToken, Ownable {
319     string public constant name = "GameChain";
320     string public constant symbol = "GC";
321     uint8 public constant decimals = 18;
322     
323     uint256 internal constant INITIAL_SUPPLY = 5000000000 ether;
324     uint256 internal constant lock_total = 250000000 ether;            
325     uint256 private start_time;
326     uint256 private one_year = 31536000;    
327 
328     uint256 private release_value = 50000000 ether;
329     address private constant tokenWallet = 0x0F8526f916f6CeCafF32ECbb52D9Cc17007D5BDF;
330     address private constant team_address = 0x815e727a5741fF2eeFDf3A373D42F68AE71691FC;
331     address private constant foundation_address = 0xA48EA7cFfC41bf0161E23ecc25CA72FC871B68D7;
332     event Lock(address account, uint lock_total);
333     
334     /**
335      * @dev Constructor, initialize the basic information of contract.
336      */
337     constructor() public {
338         _totalSupply = INITIAL_SUPPLY;
339         _owner = tokenWallet;
340         _balances[_owner] = 4500000000 * 10 ** uint(decimals);
341         start_time = now.add(one_year*2);
342         _lock(team_address);
343         _lock(foundation_address);
344         emit Transfer(address(0), _owner, 4500000000 * 10 ** uint(decimals));
345     }
346     function _lock(address account) internal {
347         _balances[account] = _balances[account].add(lock_total);
348         emit Transfer(address(0), account, lock_total);
349     }
350 
351     function transfer(address _to, uint256 _value) public returns (bool) {
352         if (msg.sender == team_address || msg.sender == foundation_address) {
353             uint256 extra = getLockBalance();
354             require(_balances[_msgSender()].sub(_value) >= extra);
355         }
356         return super.transfer(_to, _value);
357         
358     }
359     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
360         if (_from == team_address || _from == foundation_address) {
361         uint256 extra = getLockBalance();
362         require(_balances[_from].sub(_value) >= extra);
363         }
364         return super.transferFrom(_from, _to, _value);
365     }
366      function getLockBalance() public view returns(uint) {
367          if (now < start_time) {
368              return lock_total;
369          }
370         uint256 value = release_value.mul(((now.sub(start_time)).div(31536000)).add(1));
371         if (value >= lock_total) {
372             return 0;
373         } 
374         return lock_total.sub(value);   
375     }
376 
377     function burn(uint256 amount) public onlyOwner {
378         _burn(msg.sender, amount); 
379     }
380 
381     /**
382      * @dev See {ERC20-_burnFrom}.
383      */
384     function burnFrom(address account, uint256 amount) public onlyOwner {
385         _burnFrom(account, amount); 
386     }
387 }