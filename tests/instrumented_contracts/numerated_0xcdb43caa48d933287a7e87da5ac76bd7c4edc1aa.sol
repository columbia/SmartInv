1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
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
25 /**
26  * @title SafeMath
27  * @dev Unsigned math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     /**
31     * @dev Multiplies two unsigned integers, reverts on overflow.
32     */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61     */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70     * @dev Adds two unsigned integers, reverts on overflow.
71     */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
81     * reverts when dividing by zero.
82     */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
95  * Originally based on code by FirstBlood:
96  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  *
98  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
99  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
100  * compliant implementations may not do it.
101  */
102 contract ERC20 is IERC20 {
103     using SafeMath for uint256;
104 
105     mapping (address => uint256) private _balances;
106 
107     mapping (address => mapping (address => uint256)) private _allowed;
108 
109     uint256 private _totalSupply;
110 
111     /**
112     * @dev Total number of tokens in existence
113     */
114     function totalSupply() public view returns (uint256) {
115         return _totalSupply;
116     }
117 
118     /**
119     * @dev Gets the balance of the specified address.
120     * @param owner The address to query the balance of.
121     * @return An uint256 representing the amount owned by the passed address.
122     */
123     function balanceOf(address owner) public view returns (uint256) {
124         return _balances[owner];
125     }
126 
127     /**
128      * @dev Function to check the amount of tokens that an owner allowed to a spender.
129      * @param owner address The address which owns the funds.
130      * @param spender address The address which will spend the funds.
131      * @return A uint256 specifying the amount of tokens still available for the spender.
132      */
133     function allowance(address owner, address spender) public view returns (uint256) {
134         return _allowed[owner][spender];
135     }
136 
137     /**
138     * @dev Transfer token for a specified address
139     * @param to The address to transfer to.
140     * @param value The amount to be transferred.
141     */
142     function transfer(address to, uint256 value) public returns (bool) {
143         _transfer(msg.sender, to, value);
144         return true;
145     }
146 
147     /**
148      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param spender The address which will spend the funds.
154      * @param value The amount of tokens to be spent.
155      */
156     function approve(address spender, uint256 value) public returns (bool) {
157         require(spender != address(0));
158 
159         _allowed[msg.sender][spender] = value;
160         emit Approval(msg.sender, spender, value);
161         return true;
162     }
163 
164     /**
165      * @dev Transfer tokens from one address to another.
166      * Note that while this function emits an Approval event, this is not required as per the specification,
167      * and other compliant implementations may not emit the event.
168      * @param from address The address which you want to send tokens from
169      * @param to address The address which you want to transfer to
170      * @param value uint256 the amount of tokens to be transferred
171      */
172     function transferFrom(address from, address to, uint256 value) public returns (bool) {
173         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
174         _transfer(from, to, value);
175         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
176         return true;
177     }
178 
179     /**
180      * @dev Increase the amount of tokens that an owner allowed to a spender.
181      * approve should be called when allowed_[_spender] == 0. To increment
182      * allowed value is better to use this function to avoid 2 calls (and wait until
183      * the first transaction is mined)
184      * From MonolithDAO Token.sol
185      * Emits an Approval event.
186      * @param spender The address which will spend the funds.
187      * @param addedValue The amount of tokens to increase the allowance by.
188      */
189     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
190         require(spender != address(0));
191 
192         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
193         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
194         return true;
195     }
196 
197     /**
198      * @dev Decrease the amount of tokens that an owner allowed to a spender.
199      * approve should be called when allowed_[_spender] == 0. To decrement
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * Emits an Approval event.
204      * @param spender The address which will spend the funds.
205      * @param subtractedValue The amount of tokens to decrease the allowance by.
206      */
207     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
208         require(spender != address(0));
209 
210         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
211         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
212         return true;
213     }
214 
215     /**
216     * @dev Transfer token for a specified addresses
217     * @param from The address to transfer from.
218     * @param to The address to transfer to.
219     * @param value The amount to be transferred.
220     */
221     function _transfer(address from, address to, uint256 value) internal {
222         require(to != address(0));
223 
224         _balances[from] = _balances[from].sub(value);
225         _balances[to] = _balances[to].add(value);
226         emit Transfer(from, to, value);
227     }
228 
229     /**
230      * @dev Internal function that mints an amount of the token and assigns it to
231      * an account. This encapsulates the modification of balances such that the
232      * proper events are emitted.
233      * @param account The account that will receive the created tokens.
234      * @param value The amount that will be created.
235      */
236     function _mint(address account, uint256 value) internal {
237         require(account != address(0));
238 
239         _totalSupply = _totalSupply.add(value);
240         _balances[account] = _balances[account].add(value);
241         emit Transfer(address(0), account, value);
242     }
243 
244     /**
245      * @dev Internal function that burns an amount of the token of a given
246      * account.
247      * @param account The account whose tokens will be burnt.
248      * @param value The amount that will be burnt.
249      */
250     function _burn(address account, uint256 value) internal {
251         require(account != address(0));
252 
253         _totalSupply = _totalSupply.sub(value);
254         _balances[account] = _balances[account].sub(value);
255         emit Transfer(account, address(0), value);
256     }
257 
258     /**
259      * @dev Internal function that burns an amount of the token of a given
260      * account, deducting from the sender's allowance for said account. Uses the
261      * internal burn function.
262      * Emits an Approval event (reflecting the reduced allowance).
263      * @param account The account whose tokens will be burnt.
264      * @param value The amount that will be burnt.
265      */
266     function _burnFrom(address account, uint256 value) internal {
267         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
268         _burn(account, value);
269         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
270     }
271 }
272 
273 
274 /**
275  * @title ERC20Detailed token
276  * @dev The decimals are only for visualization purposes.
277  * All the operations are done using the smallest and indivisible token unit,
278  * just as on Ethereum all the operations are done in wei.
279  */
280 contract ERC20Detailed is IERC20 {
281     string private _name;
282     string private _symbol;
283     uint8 private _decimals;
284 
285     constructor (string memory name, string memory symbol, uint8 decimals) public {
286         _name = name;
287         _symbol = symbol;
288         _decimals = decimals;
289     }
290 
291     /**
292      * @return the name of the token.
293      */
294     function name() public view returns (string memory) {
295         return _name;
296     }
297 
298     /**
299      * @return the symbol of the token.
300      */
301     function symbol() public view returns (string memory) {
302         return _symbol;
303     }
304 
305     /**
306      * @return the number of decimals of the token.
307      */
308     function decimals() public view returns (uint8) {
309         return _decimals;
310     }
311 }
312 
313 contract BiecologyToken is ERC20, ERC20Detailed {
314     using SafeMath for uint256;
315     uint256 private constant totalBIB= 390000000 * (10 ** 18); // Total amount of BIB tokens
316     uint256 private constant INITIAL_SUPPLY = 30000000 * (10 ** 18); // Initial circulation quantity
317     uint private constant FIRST_YEAR_PERCENTAGE = 110; // Monthly Increase Percentage in the First Year
318     uint private constant SECOND_YEAR_PERCENTAGE = 106; // Monthly Increase Percentage in the Second Year
319     uint private constant THIRD_YEAR_PERCENTAGE = 103;  // Monthly Increase Percentage in the Third Year
320     uint private constant FOURTH_YEAR_PERCENTAGE = 103; // Monthly Increase Percentage in the Fourth Year
321     uint private constant FIFTH_YEAR_PERCENTAGE = 103;  // Monthly Increase Percentage in the Fifth Year
322     uint256 public quantity = 0; // Current circulation
323     
324     mapping(address => uint256) balances;
325     // Owner of this contract
326     address public owner;
327 
328     uint public startTime;
329 
330     mapping(uint=>uint) monthsTimestamp;
331 
332     uint[] fibseries;
333 
334     uint operatingTime;
335 
336     constructor () public ERC20Detailed("Bi ecology Token", "BIB", 18) {
337         _mint(msg.sender, totalBIB);
338         owner = msg.sender;
339         balances[owner] = totalBIB;
340         quantity = 0;
341         startTime = 1556647200;  // 2019.5.1 02:00:00 
342     }
343 
344 
345 
346     function runQuantityBIB(address _to) public {
347         require(msg.sender == owner, "Not contract owner");
348         require(totalBIB > quantity, "Release stop");
349 
350         if(quantity == 0){
351             transfer(_to, INITIAL_SUPPLY);
352             quantity = INITIAL_SUPPLY;
353             balances[owner] = balances[owner] - INITIAL_SUPPLY;
354             balances[_to] = INITIAL_SUPPLY;
355         }
356         if(block.timestamp > startTime) {
357             operatingTime = block.timestamp - startTime;
358             uint256 CURRENCY_BIB = 0;
359             uint256 currentPrecentage = 100;
360             uint256 lastMonthCoin = 0;
361             for (uint i = 1; i <= 50; i++){ // Circular month
362                     if(i<=12) { 
363                         currentPrecentage = FIRST_YEAR_PERCENTAGE; 
364                     }
365                     else if(i>12 && i<=24){
366                         currentPrecentage = SECOND_YEAR_PERCENTAGE;
367                     }
368                     else if(i>24 && i<=36){
369                         currentPrecentage = THIRD_YEAR_PERCENTAGE;
370                     }
371                     else if(i>36 && i<=48){
372                         currentPrecentage = FOURTH_YEAR_PERCENTAGE;
373                     }
374                     else{
375                         currentPrecentage = FIFTH_YEAR_PERCENTAGE;
376                     }
377                 
378                 
379                     if(i * 30 * (60*60*24) > operatingTime){
380                         uint256 diffDays = 0;
381                         uint256 diffTime = operatingTime - ((i-1) * 30 * (60*60*24));
382                         for (uint256 j = 1; j <= 30; j++){
383                             if(diffTime < j * (60*60*24)){
384                                 diffDays = j;
385                                 break;
386                             }
387                         }
388                         if(i == 1){
389                             lastMonthCoin = INITIAL_SUPPLY;
390                             if(operatingTime>0 && diffDays != 0){
391                                 CURRENCY_BIB = (lastMonthCoin * currentPrecentage / 100 - lastMonthCoin) * diffDays / 30;
392                                 CURRENCY_BIB = lastMonthCoin + CURRENCY_BIB;
393                             }
394                             else {
395                                 CURRENCY_BIB = INITIAL_SUPPLY;
396                             }
397                             lastMonthCoin = lastMonthCoin * currentPrecentage / 100;
398                         }
399                         else{
400                             CURRENCY_BIB = (lastMonthCoin * currentPrecentage / 100 - lastMonthCoin) * diffDays / 30;
401                             CURRENCY_BIB = lastMonthCoin + CURRENCY_BIB;
402                             lastMonthCoin = lastMonthCoin * currentPrecentage / 100;
403                         }
404                         // Cycle to less than the release date to the present day to get circulation
405                         break;
406                     }
407                     else {
408                         if(lastMonthCoin == 0){
409                             lastMonthCoin = INITIAL_SUPPLY;
410                         }
411                         lastMonthCoin = lastMonthCoin * currentPrecentage / 100;
412                     }
413                 // }
414             }
415             if(totalBIB >= CURRENCY_BIB){
416                 uint256 bib = CURRENCY_BIB - quantity;
417                 quantity = CURRENCY_BIB;
418                 if(bib > 0){
419                     transfer(_to, bib);
420                     balances[owner] = balances[owner].sub(bib);
421                     balances[_to] = balances[_to].add(bib);
422                 }
423             }
424             else {
425                 uint256 bib = totalBIB - quantity;
426                 if(bib > 0)
427                 {
428                     quantity = totalBIB;
429                     transfer(_to, bib);
430                     balances[owner] = balances[owner] - bib;
431                     balances[_to] =   balances[_to] + bib;
432                 }
433                 
434             }
435         }
436         
437     }
438 
439 }