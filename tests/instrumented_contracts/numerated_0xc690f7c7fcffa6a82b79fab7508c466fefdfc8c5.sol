1 pragma solidity 0.5.4;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
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
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
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
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
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
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  * Updated for required architecture.
72  */
73 contract Ownable {
74     address private _owner;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     /**
79      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80      * account.
81      */
82     constructor (address owner) internal {
83         _owner = owner;
84         emit OwnershipTransferred(address(0), _owner);
85     }
86 
87     /**
88      * @return the address of the owner.
89      */
90     function owner() public view returns (address) {
91         return _owner;
92     }
93 
94     /**
95      * @dev Throws if called by any account other than the owner.
96      */
97     modifier onlyOwner() {
98         require(isOwner());
99         _;
100     }
101 
102     /**
103      * @return true if `msg.sender` is the owner of the contract.
104      */
105     function isOwner() public view returns (bool) {
106         return msg.sender == _owner;
107     }
108 }
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 interface IERC20 {
115     function transfer(address to, uint256 value) external returns (bool);
116 
117     function approve(address spender, uint256 value) external returns (bool);
118 
119     function transferFrom(address from, address to, uint256 value) external returns (bool);
120 
121     function totalSupply() external view returns (uint256);
122 
123     function balanceOf(address who) external view returns (uint256);
124 
125     function allowance(address owner, address spender) external view returns (uint256);
126 
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
137  * Originally based on code by FirstBlood:
138  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  *
140  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
141  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
142  * compliant implementations may not do it.
143  */
144 contract ERC20 is IERC20 {
145     using SafeMath for uint256;
146 
147     mapping (address => uint256) private _balances;
148 
149     mapping (address => mapping (address => uint256)) private _allowed;
150 
151     uint256 private _totalSupply;
152 
153     /**
154      * @dev Total number of tokens in existence
155      */
156     function totalSupply() public view returns (uint256) {
157         return _totalSupply;
158     }
159 
160     /**
161      * @dev Gets the balance of the specified address.
162      * @param owner The address to query the balance of.
163      * @return An uint256 representing the amount owned by the passed address.
164      */
165     function balanceOf(address owner) public view returns (uint256) {
166         return _balances[owner];
167     }
168 
169     /**
170      * @dev Function to check the amount of tokens that an owner allowed to a spender.
171      * @param owner address The address which owns the funds.
172      * @param spender address The address which will spend the funds.
173      * @return A uint256 specifying the amount of tokens still available for the spender.
174      */
175     function allowance(address owner, address spender) public view returns (uint256) {
176         return _allowed[owner][spender];
177     }
178 
179     /**
180      * @dev Transfer token for a specified address
181      * @param to The address to transfer to.
182      * @param value The amount to be transferred.
183      */
184     function transfer(address to, uint256 value) public returns (bool) {
185         _transfer(msg.sender, to, value);
186         return true;
187     }
188 
189     /**
190      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191      * Beware that changing an allowance with this method brings the risk that someone may use both the old
192      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      * @param spender The address which will spend the funds.
196      * @param value The amount of tokens to be spent.
197      */
198     function approve(address spender, uint256 value) public returns (bool) {
199         _approve(msg.sender, spender, value);
200         return true;
201     }
202 
203     /**
204      * @dev Transfer tokens from one address to another.
205      * Note that while this function emits an Approval event, this is not required as per the specification,
206      * and other compliant implementations may not emit the event.
207      * @param from address The address which you want to send tokens from
208      * @param to address The address which you want to transfer to
209      * @param value uint256 the amount of tokens to be transferred
210      */
211     function transferFrom(address from, address to, uint256 value) public returns (bool) {
212         _transfer(from, to, value);
213         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
214         return true;
215     }
216 
217     /**
218      * @dev Increase the amount of tokens that an owner allowed to a spender.
219      * approve should be called when allowed_[_spender] == 0. To increment
220      * allowed value is better to use this function to avoid 2 calls (and wait until
221      * the first transaction is mined)
222      * From MonolithDAO Token.sol
223      * Emits an Approval event.
224      * @param spender The address which will spend the funds.
225      * @param addedValue The amount of tokens to increase the allowance by.
226      */
227     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
228         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
229         return true;
230     }
231 
232     /**
233      * @dev Decrease the amount of tokens that an owner allowed to a spender.
234      * approve should be called when allowed_[_spender] == 0. To decrement
235      * allowed value is better to use this function to avoid 2 calls (and wait until
236      * the first transaction is mined)
237      * From MonolithDAO Token.sol
238      * Emits an Approval event.
239      * @param spender The address which will spend the funds.
240      * @param subtractedValue The amount of tokens to decrease the allowance by.
241      */
242     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
243         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
244         return true;
245     }
246 
247     /**
248      * @dev Transfer token for a specified addresses
249      * @param from The address to transfer from.
250      * @param to The address to transfer to.
251      * @param value The amount to be transferred.
252      */
253     function _transfer(address from, address to, uint256 value) internal {
254         require(to != address(0));
255 
256         _balances[from] = _balances[from].sub(value);
257         _balances[to] = _balances[to].add(value);
258         emit Transfer(from, to, value);
259     }
260 
261     /**
262      * @dev Internal function that mints an amount of the token and assigns it to
263      * an account. This encapsulates the modification of balances such that the
264      * proper events are emitted.
265      * @param account The account that will receive the created tokens.
266      * @param value The amount that will be created.
267      */
268     function _mint(address account, uint256 value) internal {
269         require(account != address(0));
270 
271         _totalSupply = _totalSupply.add(value);
272         _balances[account] = _balances[account].add(value);
273         emit Transfer(address(0), account, value);
274     }
275 
276     /**
277      * @dev Approve an address to spend another addresses' tokens.
278      * @param owner The address that owns the tokens.
279      * @param spender The address that will spend the tokens.
280      * @param value The number of tokens that can be spent.
281      */
282     function _approve(address owner, address spender, uint256 value) internal {
283         require(spender != address(0));
284         require(owner != address(0));
285 
286         _allowed[owner][spender] = value;
287         emit Approval(owner, spender, value);
288     }
289 }
290 
291 /**
292  *  @title The Lympo Token contract complies with the ERC20 standard (see https://github.com/ethereum/EIPs/issues/20).
293  *  @dev All tokens not being sold during the crowdsale but the reserved token
294  *  for tournaments future financing are burned.
295  *  @author Roman Holovay
296  */
297 contract LympoToken is ERC20, Ownable {
298     using SafeMath for uint;
299     
300     string constant public name = "Lympo tokens";
301     string constant public symbol = "LYM";
302     uint8 constant public decimals = 18;
303     
304     uint constant public TOKENS_PRE_ICO = 265000000e18; // 26.5%
305     uint constant public TOKENS_ICO = 385000000e18; // 38.5%
306     uint constant public TEAM_RESERVE = 100000000e18; // 10%
307     uint constant public ECO_LOCK_13 = 73326000e18; // 1/3 of ecosystem reserve
308     uint constant public START_TIME = 1519815600; // Time after ICO, when tokens became transferable. Wednesday, 28 February 2018 11:00:00 GMT
309     uint constant public LOCK_RELEASE_DATE_1_YEAR = START_TIME + 365 days; // 2019
310     uint constant public LOCK_RELEASE_DATE_2_YEARS = START_TIME + 730 days; // 2020
311 
312     address public ecosystemAddr;
313     address public advisersAddr;
314 
315     bool public reserveClaimed;
316     bool public ecosystemPart1Claimed;
317     bool public ecosystemPart2Claimed;
318     
319     address public airdropAddress;
320     uint public airdropBalance;
321     
322     uint private _initialSupply = 1000000000e18; // Initial supply of 1 billion Lympo Tokens
323     
324     constructor(address _ownerAddr, address _advisersAddr, address _ecosystemAddr, address _airdropAddr, uint _airdropBalance) public Ownable(_ownerAddr){
325         advisersAddr = _advisersAddr;
326         ecosystemAddr = _ecosystemAddr;
327         
328         _mint(owner(), _initialSupply); // Give the owner all initial tokens
329         
330         //lock tokens in token contract
331         _transfer(owner(), address(this), TEAM_RESERVE.add(ECO_LOCK_13).add(ECO_LOCK_13));
332         
333         //transfer tokens for airdrop
334         airdropAddress = _airdropAddr;
335         airdropBalance = _airdropBalance;
336         
337         if (airdropBalance != 0) {
338              _transfer(owner(), airdropAddress, airdropBalance);
339         }
340     }
341     
342     /**
343      * @dev claimTeamReserve allow owner to withdraw team reserve 
344      * tokens from token contract.
345      */
346     function claimTeamReserve() public onlyOwner {
347         require (now > LOCK_RELEASE_DATE_2_YEARS && !reserveClaimed);
348         reserveClaimed = true;
349         _transfer(address(this), owner(), TEAM_RESERVE);
350     }
351     
352     /**
353      * @dev claimEcoSystemReservePart1 allow ecosystemAddr 
354      * to withdraw locked for 1 year tokens from token contract
355      */
356     function claimEcoSystemReservePart1() public {
357         require (msg.sender == ecosystemAddr && !ecosystemPart1Claimed);
358         require (now > LOCK_RELEASE_DATE_1_YEAR);
359         ecosystemPart1Claimed = true;
360         _transfer(address(this), ecosystemAddr, ECO_LOCK_13);
361     }
362     
363     /**
364      * @dev claimEcoSystemReservePart2 allow ecosystemAddr 
365      * to withdraw locked for 2 year tokens from token contract.
366      */
367     function claimEcoSystemReservePart2() public {
368         require (msg.sender == ecosystemAddr && !ecosystemPart2Claimed);
369         require (now > LOCK_RELEASE_DATE_2_YEARS);
370         ecosystemPart2Claimed = true;
371         _transfer(address(this), ecosystemAddr, ECO_LOCK_13);
372     }
373     
374     /**
375      * @dev recoverToken allow owner withdraw tokens
376      * that collected in this contract.
377      * @param _token means token address
378      */
379     function recoverToken(address _token) public onlyOwner {
380         require (now > LOCK_RELEASE_DATE_2_YEARS + 30 days);
381         IERC20 token = IERC20(_token);
382         uint256 balance = token.balanceOf(address(this));
383         token.transfer(msg.sender, balance);
384     }
385     
386     /**
387      * @dev airdrop an address to send tokens to required addresses.
388      * @param addresses The addresses that will receive tokens.
389      * @param values The number of tokens that can be received.
390      */
391     function airdrop(address[] memory addresses, uint[] memory values) public {
392         require(msg.sender == airdropAddress);
393         
394         for (uint i = 0; i < addresses.length; i ++){
395             _transfer(msg.sender, addresses[i], values[i]);
396         }
397     }
398 }