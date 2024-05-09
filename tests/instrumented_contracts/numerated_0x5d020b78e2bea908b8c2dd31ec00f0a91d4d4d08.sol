1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13    /**
14     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15     * account.
16     */
17     constructor() public {
18         owner = msg.sender;
19     }
20 
21    /**
22     * @dev Throws if called by any account other than the owner.
23     */
24     modifier onlyOwner {
25         require(msg.sender == owner);
26         _;
27     }
28     
29    /**
30     * @dev Allows the current owner to transfer control of the contract to a newOwner.
31     * @param _newOwner The address to transfer ownership to.
32     */
33     function transferOwnership(address _newOwner) public onlyOwner {
34         _transferOwnership(_newOwner);
35     }
36 
37    /**
38     * @dev Transfers control of the contract to a newOwner.
39     * @param _newOwner The address to transfer ownership to.
40     */
41     function _transferOwnership(address _newOwner) internal {
42         require(_newOwner != address(0));
43         emit OwnershipTransferred(owner, _newOwner);
44         owner = _newOwner;
45     }
46 }
47 
48 
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 
55 
56 
57 /**
58  * @title SafeMath
59  * @dev Math operations with safety checks that revert on error
60  */
61 library SafeMath {
62 
63     /**
64     * @dev Multiplies two numbers, reverts on overflow.
65     */
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67       // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
68       // benefit is lost if 'b' is also tested.
69       // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
70         if (a == 0) {
71             return 0;
72         }
73 
74         uint256 c = a * b;
75         require(c / a == b);
76 
77         return c;
78     }
79 
80     /**
81     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
82     */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b > 0); // Solidity only automatically asserts when dividing by 0
85         uint256 c = a / b;
86         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87 
88         return c;
89     }
90 
91     /**
92     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
93     */
94     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95         require(b <= a);
96         uint256 c = a - b;
97 
98         return c;
99     }
100 
101     /**
102     * @dev Adds two numbers, reverts on overflow.
103     */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a);
107 
108         return c;
109     }
110 
111     /**
112     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
113     * reverts when dividing by zero.
114     */
115     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
116         require(b != 0);
117         return a % b;
118     }
119 }
120 
121 interface IERC20 {
122   function totalSupply() external view returns (uint256);
123   function balanceOf(address owner) external view returns (uint256);
124   function allowance(address owner, address spender)
125     external view returns (uint256);
126   function transfer(address to, uint256 value) external returns (bool);
127   function approve(address spender, uint256 value)
128     external returns (bool);
129   function transferFrom(address from, address to, uint256 value)
130     external returns (bool);
131 
132   event Transfer(
133     address indexed from,
134     address indexed to,
135     uint256 value
136   );
137   event Approval(
138     address indexed owner,
139     address indexed spender,
140     uint256 value
141   );
142 }
143 
144 contract ERC20Token is IERC20 {
145     using SafeMath for uint256;
146 
147    /**
148     * @dev ERC20 token with the addition properties name, symbol, and decimals. 
149     * Added mint, burn, burnFrom methods
150     */
151     mapping (address => uint256) internal _balances;
152     mapping (address => mapping (address => uint256)) private _allowed;
153     uint256 internal _totalSupply;
154     string public name;
155     string public symbol;
156     uint8 public decimals;
157 
158    /**
159     * @dev Total number of tokens in existence
160     */
161     function totalSupply() public view returns (uint256) {
162         return _totalSupply;
163     }
164 
165    /**
166     * @dev Gets the balance of the specified address.
167     * @param owner The address to query the balance of.
168     * @return An uint256 representing the amount owned by the passed address.
169     */
170     function balanceOf(address owner) public view returns (uint256) {
171         return _balances[owner];
172     }
173 
174    /**
175     * @dev Function to check the amount of tokens that an owner allowed to a spender.
176     * @param owner address The address which owns the funds.
177     * @param spender address The address which will spend the funds.
178     * @return A uint256 specifying the amount of tokens still available for the spender.
179     */
180     function allowance(address owner, address spender) public view returns (uint256) {
181         return _allowed[owner][spender];
182     }
183 
184    /**
185     * @dev Transfer token for a specified address
186     * @param to The address to transfer to.
187     * @param value The amount to be transferred.
188     */
189     function transfer(address to, uint256 value) public returns (bool) {
190         require(value <= _balances[msg.sender]);
191         require(to != address(0));
192 
193         _balances[msg.sender] = _balances[msg.sender].sub(value);
194         _balances[to] = _balances[to].add(value);
195         emit Transfer(msg.sender, to, value);
196         return true;
197     }
198 
199    /**
200     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201     * Beware that changing an allowance with this method brings the risk that someone may use both the old
202     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205     * @param spender The address which will spend the funds.
206     * @param value The amount of tokens to be spent.
207     */
208     function approve(address spender, uint256 value) public returns (bool) {
209         require(spender != address(0));
210 
211         _allowed[msg.sender][spender] = value;
212         emit Approval(msg.sender, spender, value);
213         return true;
214     }
215 
216    /**
217     * @dev Transfer tokens from one address to another
218     * @param from address The address which you want to send tokens from
219     * @param to address The address which you want to transfer to
220     * @param value uint256 the amount of tokens to be transferred
221     */
222     function transferFrom(address from, address to, uint256 value) public returns (bool) {
223         require(value <= _balances[from]);
224         require(value <= _allowed[from][msg.sender]);
225         require(to != address(0));
226 
227         _balances[from] = _balances[from].sub(value);
228         _balances[to] = _balances[to].add(value);
229         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
230         emit Transfer(from, to, value);
231         return true;
232     }
233 
234    /**
235     * @dev Internal function that forces a token transfer from one address to another
236     * @param from address The address which you want to send tokens from
237     * @param to address The address which you want to transfer to
238     * @param value uint256 the amount of tokens to be transferred
239     */
240     function _forceTransfer(address from, address to, uint256 value) internal returns (bool) {
241         require(value <= _balances[from]);
242         require(to != address(0));
243 
244         _balances[from] = _balances[from].sub(value);
245         _balances[to] = _balances[to].add(value);
246         emit Transfer(from, to, value);
247         return true;
248     }
249 
250    /**
251     * @dev Internal function that mints an amount of the token and assigns it to
252     * an account. This encapsulates the modification of balances such that the
253     * proper events are emitted.
254     * @param account The account that will receive the created tokens.
255     * @param amount The amount that will be created.
256     */
257     function _mint(address account, uint256 amount) internal returns (bool) {
258         require(account != 0);
259         _totalSupply = _totalSupply.add(amount);
260         _balances[account] = _balances[account].add(amount);
261         emit Transfer(address(0), account, amount);
262         return true;
263     }
264 
265    /**
266     * @dev Internal function that burns an amount of the token of a given
267     * account.
268     * @param account The account whose tokens will be burnt.
269     * @param amount The amount that will be burnt.
270     */
271     function _burn(address account, uint256 amount) internal returns (bool) {
272         require(account != 0);
273         require(amount <= _balances[account]);
274 
275         _totalSupply = _totalSupply.sub(amount);
276         _balances[account] = _balances[account].sub(amount);
277         emit Transfer(account, address(0), amount);
278         return true;
279     }
280 }
281 
282 
283 
284 contract RegulatorService {
285 
286     function verify(address _token, address _spender, address _from, address _to, uint256 _amount) 
287         public 
288         view 
289         returns (byte) 
290     {
291         return hex"A3";
292     }
293 
294     function restrictionMessage(byte restrictionCode)
295         public
296         view
297         returns (string)
298     {
299     	if(restrictionCode == hex"01") {
300     		return "No restrictions detected";
301         }
302         if(restrictionCode == hex"10") {
303             return "One of the accounts is not on the whitelist";
304         }
305         if(restrictionCode == hex"A3") {
306             return "The lockup period is in progress";
307         }
308     }
309 }
310 
311 
312 contract AtomicDSS is ERC20Token, Ownable {
313     byte public constant SUCCESS_CODE = hex"01";
314     string public constant SUCCESS_MESSAGE = "SUCCESS";
315     RegulatorService public regulator;
316   
317     event ReplaceRegulator(address oldRegulator, address newRegulator);
318 
319     modifier notRestricted (address from, address to, uint256 value) {
320         byte restrictionCode = regulator.verify(this, msg.sender, from, to, value);
321         require(restrictionCode == SUCCESS_CODE, regulator.restrictionMessage(restrictionCode));
322         _;
323     }
324 
325     constructor(RegulatorService _regulator, address[] wallets, uint256[] amounts, address owner) public {
326             regulator = _regulator;
327             symbol = "ATOM";
328             name = "Atomic Capital, Inc.C-Corp.Delaware.Equity.1.Common.";
329             decimals = 18;
330             for (uint256 i = 0; i < wallets.length; i++){
331                 mint(wallets[i], amounts[i]);
332                 if(i == 10){
333                     break;
334                 }
335             }
336             transferOwnership(owner);
337     }
338 
339   /**
340    * @dev Validate contract address
341    * Credit: https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol#L107-L114
342    *
343    * @param _addr The address of a smart contract
344    */
345     modifier isContract (address _addr) {
346         uint length;
347         assembly { length := extcodesize(_addr) }
348         require(length > 0);
349         _;
350     }
351 
352     function replaceRegulator(RegulatorService _regulator) 
353         public 
354         onlyOwner 
355         isContract(_regulator) 
356     {
357         address oldRegulator = regulator;
358         regulator = _regulator;
359         emit ReplaceRegulator(oldRegulator, regulator);
360     }
361 
362     function transfer(address to, uint256 value)
363         public
364         notRestricted(msg.sender, to, value)
365         returns (bool)
366     {
367         return super.transfer(to, value);
368     }
369 
370     function transferFrom(address from, address to, uint256 value)
371         public
372         notRestricted(from, to, value)
373         returns (bool)
374     {
375         return super.transferFrom(from, to, value);
376     }
377 
378     function forceTransfer(address from, address to, uint256 value)
379         public
380         onlyOwner
381         returns (bool)
382     {
383         return super._forceTransfer(from, to, value);
384     }
385 
386     function mint(address account, uint256 amount) 
387         public
388         onlyOwner
389         returns (bool)
390     {
391         return super._mint(account, amount);
392     }
393 
394     function burn(address account, uint256 amount) 
395         public
396         onlyOwner
397         returns (bool)
398     {
399         return super._burn(account, amount);
400     }
401 }