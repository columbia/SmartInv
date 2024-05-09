1 pragma solidity 0.4.25;
2 
3 interface IERC20 {
4 	function balanceOf(address owner) external view returns (uint256 balance);
5 	function transfer(address to, uint256 value) external returns (bool success);
6 	function transferFrom(address from, address to, uint256 value) external returns (bool success);
7 	function approve(address spender, uint256 value) external returns (bool success);
8 	function allowance(address owner, address spender) external view returns (uint256 remaining);
9 
10 	event Transfer(address indexed from, address indexed to, uint256 value);
11 	event Approval(address indexed owner, address indexed spender, uint256 value);
12 	event Issuance(address indexed to, uint256 value);
13 }
14 
15 contract ERC20 is IERC20 {
16   using SafeMath for uint256;
17 
18   mapping (address => uint256) private _balances;
19 
20   mapping (address => mapping (address => uint256)) private _allowed;
21 
22   uint256 private _totalSupply;
23 
24   /**
25   * @dev Total number of tokens in existence
26   */
27   function totalSupply() public view returns (uint256) {
28     return _totalSupply;
29   }
30 
31   /**
32   * @dev Gets the balance of the specified address.
33   * @param owner The address to query the balance of.
34   * @return An uint256 representing the amount owned by the passed address.
35   */
36   function balanceOf(address owner) public view returns (uint256) {
37     return _balances[owner];
38   }
39 
40   /**
41    * @dev Function to check the amount of tokens that an owner allowed to a spender.
42    * @param owner address The address which owns the funds.
43    * @param spender address The address which will spend the funds.
44    * @return A uint256 specifying the amount of tokens still available for the spender.
45    */
46   function allowance(
47     address owner,
48     address spender
49    )
50     public
51     view
52     returns (uint256)
53   {
54     return _allowed[owner][spender];
55   }
56 
57   /**
58   * @dev Transfer token for a specified address
59   * @param to The address to transfer to.
60   * @param value The amount to be transferred.
61   */
62   function transfer(address to, uint256 value) public returns (bool) {
63     _transfer(msg.sender, to, value);
64     return true;
65   }
66 
67   /**
68    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
69    * Beware that changing an allowance with this method brings the risk that someone may use both the old
70    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
71    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
72    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73    * @param spender The address which will spend the funds.
74    * @param value The amount of tokens to be spent.
75    */
76   function approve(address spender, uint256 value) public returns (bool) {
77     require(spender != address(0));
78 
79     _allowed[msg.sender][spender] = value;
80     emit Approval(msg.sender, spender, value);
81     return true;
82   }
83 
84   /**
85    * @dev Transfer tokens from one address to another
86    * @param from address The address which you want to send tokens from
87    * @param to address The address which you want to transfer to
88    * @param value uint256 the amount of tokens to be transferred
89    */
90   function transferFrom(
91     address from,
92     address to,
93     uint256 value
94   )
95     public
96     returns (bool)
97   {
98     require(value <= _allowed[from][msg.sender]);
99 
100     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
101     _transfer(from, to, value);
102     return true;
103   }
104 
105   /**
106    * @dev Increase the amount of tokens that an owner allowed to a spender.
107    * approve should be called when allowed_[_spender] == 0. To increment
108    * allowed value is better to use this function to avoid 2 calls (and wait until
109    * the first transaction is mined)
110    * From MonolithDAO Token.sol
111    * @param spender The address which will spend the funds.
112    * @param addedValue The amount of tokens to increase the allowance by.
113    */
114   function increaseAllowance(
115     address spender,
116     uint256 addedValue
117   )
118     public
119     returns (bool)
120   {
121     require(spender != address(0));
122 
123     _allowed[msg.sender][spender] = (
124       _allowed[msg.sender][spender].add(addedValue));
125     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
126     return true;
127   }
128 
129   /**
130    * @dev Decrease the amount of tokens that an owner allowed to a spender.
131    * approve should be called when allowed_[_spender] == 0. To decrement
132    * allowed value is better to use this function to avoid 2 calls (and wait until
133    * the first transaction is mined)
134    * From MonolithDAO Token.sol
135    * @param spender The address which will spend the funds.
136    * @param subtractedValue The amount of tokens to decrease the allowance by.
137    */
138   function decreaseAllowance(
139     address spender,
140     uint256 subtractedValue
141   )
142     public
143     returns (bool)
144   {
145     require(spender != address(0));
146 
147     _allowed[msg.sender][spender] = (
148       _allowed[msg.sender][spender].sub(subtractedValue));
149     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
150     return true;
151   }
152 
153   /**
154   * @dev Transfer token for a specified addresses
155   * @param from The address to transfer from.
156   * @param to The address to transfer to.
157   * @param value The amount to be transferred.
158   */
159   function _transfer(address from, address to, uint256 value) internal {
160     require(value <= _balances[from]);
161     require(to != address(0));
162 
163     _balances[from] = _balances[from].sub(value);
164     _balances[to] = _balances[to].add(value);
165     emit Transfer(from, to, value);
166   }
167 
168   /**
169    * @dev Internal function that mints an amount of the token and assigns it to
170    * an account. This encapsulates the modification of balances such that the
171    * proper events are emitted.
172    * @param account The account that will receive the created tokens.
173    * @param value The amount that will be created.
174    */
175   function _mint(address account, uint256 value) internal {
176     require(account != 0);
177     _totalSupply = _totalSupply.add(value);
178     _balances[account] = _balances[account].add(value);
179     emit Transfer(address(0), account, value);
180   }
181 
182   /**
183    * @dev Internal function that burns an amount of the token of a given
184    * account.
185    * @param account The account whose tokens will be burnt.
186    * @param value The amount that will be burnt.
187    */
188   function _burn(address account, uint256 value) internal {
189     require(account != 0);
190     require(value <= _balances[account]);
191 
192     _totalSupply = _totalSupply.sub(value);
193     _balances[account] = _balances[account].sub(value);
194     emit Transfer(account, address(0), value);
195   }
196 
197   /**
198    * @dev Internal function that burns an amount of the token of a given
199    * account, deducting from the sender's allowance for said account. Uses the
200    * internal burn function.
201    * @param account The account whose tokens will be burnt.
202    * @param value The amount that will be burnt.
203    */
204   function _burnFrom(address account, uint256 value) internal {
205     require(value <= _allowed[account][msg.sender]);
206 
207     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
208     // this function needs to emit an event with the updated approval.
209     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
210       value);
211     _burn(account, value);
212   }
213 }
214 
215 contract ERC20Burnable is ERC20 {
216 
217   /**
218    * @dev Burns a specific amount of tokens.
219    * @param value The amount of token to be burned.
220    */
221   function burn(uint256 value) public {
222     _burn(msg.sender, value);
223   }
224 
225   /**
226    * @dev Burns a specific amount of tokens from the target address and decrements allowance
227    * @param from address The address which you want to send tokens from
228    * @param value uint256 The amount of token to be burned
229    */
230   function burnFrom(address from, uint256 value) public {
231     _burnFrom(from, value);
232   }
233 }
234 
235 interface IOldManager {
236     function released(address investor) external view returns (uint256);
237 }
238 
239 library SafeMath {
240 
241   /**
242   * @dev Multiplies two numbers, reverts on overflow.
243   */
244   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
245     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
246     // benefit is lost if 'b' is also tested.
247     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
248     if (a == 0) {
249       return 0;
250     }
251 
252     uint256 c = a * b;
253     require(c / a == b);
254 
255     return c;
256   }
257 
258   /**
259   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
260   */
261   function div(uint256 a, uint256 b) internal pure returns (uint256) {
262     require(b > 0); // Solidity only automatically asserts when dividing by 0
263     uint256 c = a / b;
264     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
265 
266     return c;
267   }
268 
269   /**
270   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
271   */
272   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
273     require(b <= a);
274     uint256 c = a - b;
275 
276     return c;
277   }
278 
279   /**
280   * @dev Adds two numbers, reverts on overflow.
281   */
282   function add(uint256 a, uint256 b) internal pure returns (uint256) {
283     uint256 c = a + b;
284     require(c >= a);
285 
286     return c;
287   }
288 
289   /**
290   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
291   * reverts when dividing by zero.
292   */
293   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
294     require(b != 0);
295     return a % b;
296   }
297 }
298 
299 contract Owned {
300 
301 	address public owner = msg.sender;
302 	address public potentialOwner;
303 
304 	modifier onlyOwner {
305 		require(msg.sender == owner);
306 		_;
307 	}
308 
309 	modifier onlyPotentialOwner {
310 		require(msg.sender == potentialOwner);
311 		_;
312 	}
313 
314 	event NewOwner(address old, address current);
315 	event NewPotentialOwner(address old, address potential);
316 
317 	function setOwner(address _new)
318 		public
319 		onlyOwner
320 	{
321 		emit NewPotentialOwner(owner, _new);
322 		potentialOwner = _new;
323 	}
324 
325 	function confirmOwnership()
326 		public
327 		onlyPotentialOwner
328 	{
329 		emit NewOwner(owner, potentialOwner);
330 		owner = potentialOwner;
331 		potentialOwner = address(0);
332 	}
333 }
334 
335 contract Manager is Owned {
336     using SafeMath for uint256;
337 
338     event InvestorVerified(address investor);
339     event VerificationRevoked(address investor);
340 
341     mapping (address => bool) public verified_investors;
342     mapping (address => uint256) public released;
343 
344     IOldManager public old_manager;
345     ERC20Burnable public old_token;
346     IERC20 public presale_token;
347     IERC20 public new_token;
348 
349     modifier onlyVerifiedInvestor {
350         require(verified_investors[msg.sender]);
351         _;
352     }
353 
354     constructor(IOldManager _old_manager, ERC20Burnable _old_token, IERC20 _presale_token, IERC20 _new_token) public {
355         old_manager = _old_manager;
356         old_token = _old_token;
357         presale_token = _presale_token;
358         new_token = _new_token;
359     }
360 
361     function updateVerificationStatus(address investor, bool is_verified) public onlyOwner {
362         require(verified_investors[investor] != is_verified);
363 
364         verified_investors[investor] = is_verified;
365         if (is_verified) emit InvestorVerified(investor);
366         if (!is_verified) emit VerificationRevoked(investor);
367     }
368 
369     function migrate() public onlyVerifiedInvestor {
370         uint256 tokens_to_transfer = old_token.allowance(msg.sender, address(this));
371         require(tokens_to_transfer > 0);
372         require(old_token.transferFrom(msg.sender, address(this), tokens_to_transfer));
373         old_token.burn(tokens_to_transfer);
374         _transferTokens(msg.sender, tokens_to_transfer);
375     }
376 
377     function release() public onlyVerifiedInvestor {
378         uint256 presale_tokens = presale_token.balanceOf(msg.sender);
379         uint256 tokens_to_release = presale_tokens - totalReleased(msg.sender);
380         require(tokens_to_release > 0);
381         _transferTokens(msg.sender, tokens_to_release);
382         released[msg.sender] = tokens_to_release;
383     }
384 
385     function totalReleased(address investor) public view returns (uint256) {
386         return released[investor] + old_manager.released(investor);
387     }
388 
389     function _transferTokens(address recipient, uint256 amount) internal {
390         uint256 initial_balance = new_token.balanceOf(recipient);
391         require(new_token.transfer(recipient, amount));
392         assert(new_token.balanceOf(recipient) == initial_balance + amount);
393     }
394 }