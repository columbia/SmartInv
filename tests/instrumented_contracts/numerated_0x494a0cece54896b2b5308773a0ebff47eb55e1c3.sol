1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, reverts on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     uint256 c = a * b;
17     require(c / a == b);
18 
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     require(b > 0); // Solidity only automatically asserts when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b <= a);
38     uint256 c = a - b;
39 
40     return c;
41   }
42 
43   /**
44   * @dev Adds two numbers, reverts on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     require(c >= a);
49 
50     return c;
51   }
52 
53   /**
54   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
55   * reverts when dividing by zero.
56   */
57   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b != 0);
59     return a % b;
60   }
61 }
62 
63 contract owned {
64     address public owner;
65     event OwnershipTransferred(
66         address indexed previousOwner,
67         address indexed newOwner
68     );
69 
70     constructor() public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function transferOwnership(address newOwner) public onlyOwner {
80         require(newOwner != address(0));
81         emit OwnershipTransferred(owner, newOwner);
82         owner = newOwner;
83     }
84 }
85 
86 
87 contract ERC20 {
88     function totalSupply() public view returns (uint256);
89 
90     function balanceOf(address _who) public view returns (uint256);
91 
92     function transfer(address _to, uint256 _value) public returns (bool);
93 
94     event Transfer(
95         address indexed from,
96         address indexed to,
97         uint256 value
98     );
99 }
100 
101 
102 contract StandardToken is ERC20 {
103     using SafeMath for uint256;
104 
105     mapping(address => uint256) internal balances;
106 
107     uint256 internal totalSupply_;
108 
109     /**
110      * @dev Total number of tokens in existence
111      */
112     function totalSupply() public view returns (uint256) {
113         return totalSupply_;
114     }
115 
116     /**
117      * @dev Gets the balance of the specified address.
118      * @param _owner The address to query the the balance of.
119      * @return An uint256 representing the amount owned by the passed address.
120      */
121     function balanceOf(address _owner) public view returns (uint256) {
122         return balances[_owner];
123     }
124 
125     /**
126      * @dev Transfer token for a specified address
127      * @param _to The address to transfer to.
128      * @param _value The amount to be transferred.
129      */
130     function transfer(address _to, uint256 _value) public returns (bool) {
131         require(_value <= balances[msg.sender]);
132         require(_to != address(0));
133 
134         balances[msg.sender] = balances[msg.sender].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         emit Transfer(msg.sender, _to, _value);
137         return true;
138     }
139 }
140 
141 
142 contract ioeXTokenERC20 is StandardToken, owned {
143     using SafeMath for uint256;
144 
145     // Public variables of the token
146     bytes internal name_ = "Internet of Everything X";
147 
148     bytes internal symbol_ = "IOEX";
149 
150     uint256 public decimals = 8;
151 
152     uint256 private constant LOCK_TYPE_MAX = 3;
153     uint256 private constant LOCK_STAGE_MAX = 4;
154 
155     mapping (address => bool) public frozenAccount;
156 
157     //Save lock type and amount of init tokens
158     struct StructLockAccountInfo {
159         uint256 lockType;
160         uint256 initBalance;
161         uint256 startTime;
162     }
163 
164     mapping (address => StructLockAccountInfo) public lockAccountInfo;
165  
166     //Save 4 set of time and percent of unlocked tokens
167     struct StructLockType {
168         uint256[LOCK_STAGE_MAX] time;
169         uint256[LOCK_STAGE_MAX] freePercent;
170     }
171 
172     StructLockType[LOCK_TYPE_MAX] private lockType;
173 
174     // This generates a public event on the blockchain that will notify clients
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     // This notifies clients about the amount burnt
178     event Burn(address indexed from, uint256 value);
179 
180     // This generates a public event that record info about locked account,
181     // including amount of init tokens and lock type
182     event SetLockData(address indexed account, uint256 initBalance, uint256 lockType, uint256 startDate);
183 
184     /* This generates a public event on the blockchain that will notify clients */
185     event FrozenFunds(address target, bool frozen);
186 
187     /**
188      * Constructor function
189      *
190      * Initializes contract with initial supply tokens to the creator of the contract
191      */
192     constructor() public {
193         totalSupply_ = 20000000000000000;
194         balances[msg.sender] = totalSupply_;  // Give the creator all initial tokens
195 
196         //init all lock data
197         //Lock type 1
198         lockType[0].time[0] = 30;
199         lockType[0].freePercent[0] = 40;     //40%
200         lockType[0].time[1] = 60;
201         lockType[0].freePercent[1] = 20;     //20%
202         lockType[0].time[2] = 120;
203         lockType[0].freePercent[2] = 20;     //20%
204         lockType[0].time[3] = 180;
205         lockType[0].freePercent[3] = 20;     //20%
206 
207         //Lock type 2
208         lockType[1].time[0] = 30;
209         lockType[1].freePercent[0] = 25;     //25%
210         lockType[1].time[1] = 60;
211         lockType[1].freePercent[1] = 25;     //25%
212         lockType[1].time[2] = 120;
213         lockType[1].freePercent[2] = 25;     //25%
214         lockType[1].time[3] = 180;
215         lockType[1].freePercent[3] = 25;     //25%
216 
217         //Lock type 3
218         lockType[2].time[0] = 180;
219         lockType[2].freePercent[0] = 25;     //25%
220         lockType[2].time[1] = 360;
221         lockType[2].freePercent[1] = 25;     //25%
222         lockType[2].time[2] = 540;
223         lockType[2].freePercent[2] = 25;     //25%
224         lockType[2].time[3] = 720;
225         lockType[2].freePercent[3] = 25;     //25%
226 
227         //init all lock data
228     }
229 
230     /**
231     * @dev Gets the token name
232     * @return string representing the token name
233     */
234     function name() external view returns (string) {
235         return string(name_);
236     }
237 
238     /**
239     * @dev Gets the token symbol
240     * @return string representing the token symbol
241     */
242     function symbol() external view returns (string) {
243         return string(symbol_);
244     }
245 
246     /**
247      * Calculate how much tokens must be locked
248      * return the amount of locked tokens
249      */
250     function getLockBalance(address account) internal returns (uint256) {
251         uint256 lockTypeIndex;
252         uint256 amountLockedTokens = 0;
253         uint256 resultFreePercent = 0;
254         uint256 duration = 0;
255         uint256 i;
256 
257         lockTypeIndex = lockAccountInfo[account].lockType;
258 
259         if (lockTypeIndex >= 1) {
260             if (lockTypeIndex <= LOCK_TYPE_MAX) {
261                 lockTypeIndex = lockTypeIndex.sub(1);
262                 for (i = 0; i < LOCK_STAGE_MAX; i++) {
263                     duration = (lockType[lockTypeIndex].time[i]).mul(1 days);
264                     if (lockAccountInfo[account].startTime.add(duration) >= now) {
265                         resultFreePercent = resultFreePercent.add(lockType[lockTypeIndex].freePercent[i]);
266                     }
267                 }
268             }
269 
270             amountLockedTokens = (lockAccountInfo[account].initBalance.mul(resultFreePercent)).div(100);
271 
272             if (amountLockedTokens == 0){
273                 lockAccountInfo[account].lockType = 0;
274             }
275         }
276 
277         return amountLockedTokens;
278     }
279 
280     /**
281      * Internal transfer, only can be called by this contract
282      * Transfer toekns, and lock time and balance by selectType
283      */
284     function _transferForLock(address _to, uint256 _value, uint256 selectType) internal {
285         require(selectType >= 1);
286         require(selectType <= LOCK_TYPE_MAX);
287 
288         if ((lockAccountInfo[_to].lockType == 0) && 
289             (lockAccountInfo[_to].initBalance == 0)) {
290             require(_value <= balances[msg.sender]);
291             require(_to != address(0));
292 
293             //write data
294             lockAccountInfo[_to].lockType = selectType;
295             lockAccountInfo[_to].initBalance = _value;
296             lockAccountInfo[_to].startTime = now;
297             emit SetLockData(_to,_value, lockAccountInfo[_to].lockType, lockAccountInfo[_to].startTime);
298             //write data
299 
300             balances[msg.sender] = balances[msg.sender].sub(_value);
301             balances[_to] = balances[_to].add(_value);
302             emit Transfer(msg.sender, _to, _value);
303         } else {
304             revert();
305         }
306     }
307 
308     /**
309      * Transfer tokens
310      *
311      * Send `_value` tokens to `_to` from your account
312      *
313      * @param _to The address of the recipient
314      * @param _value the amount to send
315      */
316     function transfer(address _to, uint256 _value) public returns (bool) {
317         //check
318         uint256 freeBalance;
319 
320         if (lockAccountInfo[msg.sender].lockType > 0) {
321             freeBalance = balances[msg.sender].sub(getLockBalance(msg.sender));
322             require(freeBalance >=_value);
323         }
324         //check
325 
326         require(_value <= balances[msg.sender]);
327         require(_to != address(0));
328         require(!frozenAccount[msg.sender]);        // Check if sender is frozen
329         require(!frozenAccount[_to]);               // Check if recipient is frozen
330 
331         balances[msg.sender] = balances[msg.sender].sub(_value);
332         balances[_to] = balances[_to].add(_value);
333         emit Transfer(msg.sender, _to, _value);
334         return true;
335     }
336 
337     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
338     /// @param target Address to be frozen
339     /// @param freeze either to freeze it or not
340     function freezeAccount(address target, bool freeze) public onlyOwner {
341         frozenAccount[target] = freeze;
342         emit FrozenFunds(target, freeze);
343     }
344 
345     /**
346      * Transfer tokens
347      * Lock time and token by lock_type 1
348      *
349      * Send `_value` tokens to `_to` from your account
350      *
351      * @param _to The address of the recipient
352      * @param _value the amount to send
353      */
354     function transferLockBalance_1(address _to, uint256 _value) public onlyOwner {
355         _transferForLock(_to, _value, 1);
356     }
357 
358     /**
359      * Transfer tokens
360      * Lock time and token by lock_type 2
361      *
362      * Send `_value` tokens to `_to` from your account
363      *
364      * @param _to The address of the recipient
365      * @param _value the amount to send
366      */
367     function transferLockBalance_2(address _to, uint256 _value) public onlyOwner {
368         _transferForLock(_to, _value, 2);
369     }
370 
371     /**
372      * Transfer tokens
373      * Lock time and token by lock_type 3
374      *
375      * Send `_value` tokens to `_to` from your account
376      *
377      * @param _to The address of the recipient
378      * @param _value the amount to send
379      */
380     function transferLockBalance_3(address _to, uint256 _value) public onlyOwner {
381         _transferForLock(_to, _value, 3);
382     }
383 
384     /**
385      * Destroy tokens
386      *
387      * Remove `_value` tokens from the system irreversibly
388      *
389      * @param _value the amount of money to burn
390      */
391     function burn(uint256 _value) public onlyOwner {
392         _burn(msg.sender, _value);
393     }
394 
395     function _burn(address _who, uint256 _value) internal {
396         require(_value <= balances[_who]);
397         // no need to require value <= totalSupply, since that would imply the
398         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
399 
400         balances[_who] = balances[_who].sub(_value);
401         totalSupply_ = totalSupply_.sub(_value);
402         emit Burn(_who, _value);
403     }
404 }