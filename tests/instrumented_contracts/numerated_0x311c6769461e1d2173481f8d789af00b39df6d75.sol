1 pragma solidity 0.5.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
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
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27     */
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
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 interface IERC20 {
72     function transfer(address to, uint256 value) external returns (bool);
73 
74     function approve(address spender, uint256 value) external returns (bool);
75 
76     function transferFrom(address from, address to, uint256 value) external returns (bool);
77 
78     function totalSupply() external view returns (uint256);
79 
80     function balanceOf(address who) external view returns (uint256);
81 
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * @title ERC20Detailed token
91  * @dev The decimals are only for visualization purposes.
92  * All the operations are done using the smallest and indivisible token unit,
93  * just as on Ethereum all the operations are done in wei.
94  */
95 contract ERC20Detailed is IERC20 {
96     string private _name;
97     string private _symbol;
98     uint8 private _decimals;
99 
100     constructor (string memory name, string memory symbol, uint8 decimals) public {
101         _name = name;
102         _symbol = symbol;
103         _decimals = decimals;
104     }
105 
106     /**
107      * @return the name of the token.
108      */
109     function name() public view returns (string memory) {
110         return _name;
111     }
112 
113     /**
114      * @return the symbol of the token.
115      */
116     function symbol() public view returns (string memory) {
117         return _symbol;
118     }
119 
120     /**
121      * @return the number of decimals of the token.
122      */
123     function decimals() public view returns (uint8) {
124         return _decimals;
125     }
126 }
127 
128 /**
129  * @title FreedomDividendCoin ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
133  * Originally based on code by FirstBlood:
134  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  *
136  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
137  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
138  * compliant implementations may not do it.
139  */
140 contract FreedomDividendCoin is IERC20,ERC20Detailed {
141     using SafeMath for uint256;
142 
143     mapping (address => uint256) private _balances;
144 
145     mapping (address => mapping (address => uint256)) private _allowed;
146 
147     uint256 private _totalSupply;
148 
149     string private _name="Freedom Dividend Coin";
150 
151     string private _symbol="FDC";
152 
153     uint8 private _decimals=2;
154 
155     /**
156     * @dev Total number of tokens in existence
157     */
158     function totalSupply() public view returns (uint256) {
159         return _totalSupply;
160     }
161 
162     /**
163     * @dev Gets the balance of the specified address.
164     * @param owner The address to query the balance of.
165     * @return An uint256 representing the amount owned by the passed address.
166     */
167     function balanceOf(address owner) public view returns (uint256) {
168         return _balances[owner];
169     }
170 
171     /**
172      * @dev Function to check the amount of tokens that an owner allowed to a spender.
173      * @param owner address The address which owns the funds.
174      * @param spender address The address which will spend the funds.
175      * @return A uint256 specifying the amount of tokens still available for the spender.
176      */
177     function allowance(address owner, address spender) public view returns (uint256) {
178         return _allowed[owner][spender];
179     }
180 
181     /**
182      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183      * Beware that changing an allowance with this method brings the risk that someone may use both the old
184      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
185      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
186      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187      * @param spender The address which will spend the funds.
188      * @param value The amount of tokens to be spent.
189      */
190     function approve(address spender, uint256 value) public returns (bool) {
191         require(spender != address(0));
192 
193         _allowed[msg.sender][spender] = value;
194         emit Approval(msg.sender, spender, value);
195         return true;
196     }
197 
198     /**
199      * @dev Increase the amount of tokens that an owner allowed to a spender.
200      * approve should be called when allowed_[_spender] == 0. To increment
201      * allowed value is better to use this function to avoid 2 calls (and wait until
202      * the first transaction is mined)
203      * From MonolithDAO Token.sol
204      * Emits an Approval event.
205      * @param spender The address which will spend the funds.
206      * @param addedValue The amount of tokens to increase the allowance by.
207      */
208     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
209         require(spender != address(0));
210 
211         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
212         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
213         return true;
214     }
215 
216     /**
217      * @dev Decrease the amount of tokens that an owner allowed to a spender.
218      * approve should be called when allowed_[_spender] == 0. To decrement
219      * allowed value is better to use this function to avoid 2 calls (and wait until
220      * the first transaction is mined)
221      * From MonolithDAO Token.sol
222      * Emits an Approval event.
223      * @param spender The address which will spend the funds.
224      * @param subtractedValue The amount of tokens to decrease the allowance by.
225      */
226     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
227         require(spender != address(0));
228 
229         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
230         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
231         return true;
232     }
233 
234     /**
235     * @dev Transfer token for a specified addresses
236     * @param from The address to transfer from.
237     * @param to The address to transfer to.
238     * @param value The amount to be transferred.
239     */
240     function _transfer(address from, address to, uint256 value) internal {
241         require(to != address(0));
242 
243         _balances[from] = _balances[from].sub(value);
244         _balances[to] = _balances[to].add(value);
245         emit Transfer(from, to, value);
246     }
247 
248     /**
249      * @dev Internal function that mints an amount of the token and assigns it to
250      * an account. This encapsulates the modification of balances such that the
251      * proper events are emitted.
252      * @param account The account that will receive the created tokens.
253      * @param value The amount that will be created.
254      */
255     function _mint(address account, uint256 value) internal {
256         require(account != address(0));
257 
258         _totalSupply = _totalSupply.add(value);
259         _balances[account] = _balances[account].add(value);
260         emit Transfer(address(0), account, value);
261     }
262 
263     /**
264      * @dev Internal function that burns an amount of the token of a given
265      * account.
266      * @param account The account whose tokens will be burnt.
267      * @param value The amount that will be burnt.
268      */
269     function _burn(address account, uint256 value) internal {
270         require(account != address(0));
271 
272         _totalSupply = _totalSupply.sub(value);
273         _balances[account] = _balances[account].sub(value);
274         emit Transfer(account, address(0), value);
275     }
276 
277     /**
278      * @dev Internal function that burns an amount of the token of a given
279      * account, deducting from the sender's allowance for said account. Uses the
280      * internal burn function.
281      * Emits an Approval event (reflecting the reduced allowance).
282      * @param account The account whose tokens will be burnt.
283      * @param value The amount that will be burnt.
284      */
285     function _burnFrom(address account, uint256 value) internal {
286         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
287         _burn(account, value);
288         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
289     }
290 
291     address private DividendDistributor = 0xa100E22A959D869137827D963cED87d4B545ce45;
292     uint256 private globalDistributionTimestamp;
293     uint256 private balanceOfDividendDistributorAtDistributionTimestamp;
294 
295     struct DividendAddresses {
296         address individualAddress;
297         uint256 lastDistributionTimestamp;
298     }
299 
300     mapping(address => DividendAddresses) private FreedomDividendAddresses;
301 
302     constructor ()
303     ERC20Detailed(_name, _symbol, _decimals)
304     public
305     {
306         _mint(msg.sender, 2500000000);
307         transfer(DividendDistributor, 10000000);
308         globalDistributionTimestamp = now;
309         balanceOfDividendDistributorAtDistributionTimestamp = balanceOf(DividendDistributor);
310     }
311 
312     function transferCoin(address _from, address _to, uint256 _value) internal {
313         uint256 transferRate = _value / 10;
314         require(transferRate > 0, "Transfer Rate needs to be higher than the minimum");
315         require(_value > transferRate, "Value sent needs to be higher than the Transfer Rate");
316         uint256 sendValue = _value - transferRate;
317         _transfer(_from, _to, sendValue);
318         _transfer(_from, DividendDistributor, transferRate);
319     }
320 
321     function transfer(address to, uint256 value) public returns (bool) {
322         transferCoin(msg.sender, to, value);
323         return true;
324     }
325 
326     function transferFrom(address from, address to, uint256 value) public returns (bool) {
327         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
328         transferCoin(from, to, value);
329         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
330         return true;
331     }
332 
333     function collectFreedomDividendFromSender() public returns (bool) {
334         collectFreedomDividend(msg.sender);
335         return true;
336     }
337 
338     function collectFreedomDividendWithAddress(address collectionAddress) public returns (bool) {
339         collectFreedomDividend(collectionAddress);
340         return true;
341     }
342 
343     function collectFreedomDividend(address collectionAddress) internal {
344 
345         require(collectionAddress != address(0), "Need to use a valid Address");
346         require(collectionAddress != DividendDistributor, "Dividend Distributor does not distribute a dividend to itself");
347 
348         if (FreedomDividendAddresses[collectionAddress].individualAddress != address(0)) {
349             if ((now - globalDistributionTimestamp) >= 30 days) {
350                 require(balanceOf(DividendDistributor) > 0, "Balance of Dividend Distributor needs to be greater than 0");
351                 globalDistributionTimestamp = now;
352                 balanceOfDividendDistributorAtDistributionTimestamp = balanceOf(DividendDistributor);
353             }
354             
355             if (FreedomDividendAddresses[collectionAddress].lastDistributionTimestamp > globalDistributionTimestamp) {
356                 require(1 == 0, "Freedom Dividend has already been collected in past 30 days or just signed up for Dividend and need to wait up to 30 days");
357             } else if ((now - FreedomDividendAddresses[collectionAddress].lastDistributionTimestamp) >= 30 days) {
358                 require(balanceOf(collectionAddress) > 0, "Balance of Collection Address needs to be greater than 0");
359                 uint256 percentageOfTotalSupply = balanceOf(collectionAddress) * totalSupply() / 625000000;
360                 require(percentageOfTotalSupply > 0, "Percentage of Total Supply needs to be higher than the minimum");
361                 uint256 distributionAmount = balanceOfDividendDistributorAtDistributionTimestamp * percentageOfTotalSupply / 10000000000;
362                 require(distributionAmount > 0, "Distribution amount needs to be higher than 0");
363                 _transfer(DividendDistributor, collectionAddress, distributionAmount);
364                 FreedomDividendAddresses[collectionAddress].lastDistributionTimestamp = now;
365             } else {
366                 require(1 == 0, "It has not been 30 days since last collection of the Freedom Dividend");
367             }
368         } else {
369             DividendAddresses memory newDividendAddresses;
370             newDividendAddresses.individualAddress = collectionAddress;
371             newDividendAddresses.lastDistributionTimestamp = now;
372             FreedomDividendAddresses[collectionAddress] = newDividendAddresses;
373         }
374 
375     }
376 
377     function getDividendAddress() public view returns(address) {
378         return FreedomDividendAddresses[msg.sender].individualAddress;
379     }
380 
381     function getDividendAddressWithAddress(address Address) public view returns(address) {
382         return FreedomDividendAddresses[Address].individualAddress;
383     }
384 
385     function getLastDistributionTimestamp() public view returns(uint256) {
386         return FreedomDividendAddresses[msg.sender].lastDistributionTimestamp;
387     }
388 
389     function getLastDistributionTimestampWithAddress(address Address) public view returns(uint256) {
390         return FreedomDividendAddresses[Address].lastDistributionTimestamp;
391     }
392 
393     function getGlobalDistributionTimestamp() public view returns(uint256) {
394         return globalDistributionTimestamp;
395     }
396 
397     function getbalanceOfDividendDistributorAtDistributionTimestamp() public view returns(uint256) {
398         return balanceOfDividendDistributorAtDistributionTimestamp;
399     }
400 
401 }