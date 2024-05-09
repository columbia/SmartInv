1 // @dev ERC20 compliance requires syntax of solidity 0.4.17 or above (previous token contract is at ^0.4.8). 
2 pragma solidity 0.4.24;
3 
4 // @dev unchanged
5 contract Owned {
6     address public owner;
7 
8     function changeOwner(address _addr) onlyOwner {
9         if (_addr == 0x0) throw;
10         owner = _addr;
11     }
12 
13     modifier onlyOwner {
14         if (msg.sender != owner) throw;
15         _;
16     }
17 }
18 
19 // @dev unchanged
20 contract Mutex is Owned {
21     bool locked = false;
22     modifier mutexed {
23         if (locked) throw;
24         locked = true;
25         _;
26         locked = false;
27     }
28 
29     function unMutex() onlyOwner {
30         locked = false;
31     }
32 }
33 
34 /**
35  * @title SafeMath
36  * @author OpenZeppelin
37  * @dev Math operations with safety checks that revert on error
38  */
39 library SafeMath {
40 
41   /**
42   * @dev Multiplies two numbers, reverts on overflow.
43   */
44   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46     // benefit is lost if 'b' is also tested.
47     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48     if (a == 0) {
49       return 0;
50     }
51 
52     uint256 c = a * b;
53     require(c / a == b);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
60   */
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b > 0); // Solidity only automatically asserts when dividing by 0
63     uint256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65 
66     return c;
67   }
68 
69   /**
70   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
71   */
72   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73     require(b <= a);
74     uint256 c = a - b;
75 
76     return c;
77   }
78 
79   /**
80   * @dev Adds two numbers, reverts on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     require(c >= a);
85 
86     return c;
87   }
88 
89   /**
90   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
91   * reverts when dividing by zero.
92   */
93   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
94     require(b != 0);
95     return a % b;
96   }
97 }
98 
99 contract Token is Owned, Mutex {
100     // @dev using OpenZeppelin's SafeMath library
101     using SafeMath for uint256;
102 
103     Ledger public ledger;
104 
105     uint256 public lockedSupply = 0;
106 
107     string public name;
108     uint8 public decimals; 
109     string public symbol;
110 
111     string public version = '0.2'; 
112     bool public transfersOn = true;
113 
114     // @notice Constructs a Token
115     // @dev changed to comply with 0.4.17 and above syntax,
116     // but later versions could use 'constructor(...)' syntax
117     // @param _owner Intended owner of the Token contract
118     // @param _tokenName Intended name of the Token
119     // @param _decimals Intended precision of the Token
120     // @param _symbol Intended symbol of the Token
121     // @param _ledger Intended address of the Ledger
122     constructor(address _owner, string _tokenName, uint8 _decimals,
123                 string _symbol, address _ledger) public {
124         require(_owner != address(0), "address cannot be null");
125         owner = _owner;
126 
127         name = _tokenName;
128         decimals = _decimals;
129         symbol = _symbol;
130 
131         ledger = Ledger(_ledger);
132     }
133 
134     /*
135     *   Bookkeeping and Admin Functions
136     */
137 
138     // @notice Event emitted when the Ledger is updated
139     // @param _from Address that updates the Ledger
140     // @param _ledger Address of the Ledger
141     event LedgerUpdated(address _from, address _ledger);
142 
143 
144 
145     // @notice Allow the owner to change the address of the Ledger
146     // @param _addr Intended new address of the Ledger
147     function changeLedger(address _addr) onlyOwner public {
148         require(_addr != address(0), "address cannot be null");
149         ledger = Ledger(_addr);
150     
151         emit LedgerUpdated(msg.sender, _addr);
152     }
153 
154     /*
155     * Locking is a feature that turns a user's balances into
156     * un-issued tokens, taking them out of an account and reducing the supply.
157     * Diluting is so named to remind the caller that they are changing the money supply.
158     */
159 
160     // @notice Allows owner to lock the balance of an address,
161     // reducing the total circulating supply by the balance of that address
162     // and increasing the locked supply of Tokens
163     // @param _seizeAddr Intended address whose account balance is to be frozen
164     function lock(address _seizeAddr) onlyOwner mutexed public {
165         require(_seizeAddr != address(0), "address cannot be null");
166 
167         uint256 myBalance = ledger.balanceOf(_seizeAddr);
168         lockedSupply = lockedSupply.add(myBalance);
169         ledger.setBalance(_seizeAddr, 0);
170     }
171 
172     // @notice Event that marks a "dilution" to a target address and the amount
173     // @param _destAddr Intended address of the Token "dilution"
174     // @param _amount Intended amount to be given to _destAddr
175     event Dilution(address _destAddr, uint256 _amount);
176 
177     // @notice Allows the owner to unlock some of the locked supply
178     // and give it to another address, increasing the circulating Token supply
179     // (not exactly a true dilution of the current Token supply)
180     // @param _destAddr Intended address of the recipient of the unlocked amount
181     // @param amount Intended amount to be given to _destAddr
182     function dilute(address _destAddr, uint256 amount) onlyOwner public {
183         require(amount <= lockedSupply, "amount greater than lockedSupply");
184 
185         lockedSupply = lockedSupply.sub(amount);
186 
187         uint256 curBalance = ledger.balanceOf(_destAddr);
188         curBalance = curBalance.add(amount);
189         ledger.setBalance(_destAddr, curBalance);
190 
191         emit Dilution(_destAddr, amount);
192     }
193 
194     // @notice Allow the owner to pause arbitrary transfers of Tokens
195     function pauseTransfers() onlyOwner public {
196         transfersOn = false;
197     }
198 
199     // @notice Allow the owner to resume arbitrary transfers of Tokens
200     function resumeTransfers() onlyOwner public {
201         transfersOn = true;
202     }
203 
204     /*
205     * Burning -- We allow any user to burn tokens.
206     *
207      */
208 
209     // @notice Allows any arbitrary user to burn their Tokens
210     // @param _amount Number of Tokens a user wants to burn
211     function burn(uint256 _amount) public {
212         uint256 balance = ledger.balanceOf(msg.sender);
213         require(_amount <= balance, "not enough balance");
214         ledger.setBalance(msg.sender, balance.sub(_amount));
215         emit Transfer(msg.sender, 0, _amount);
216     }
217 
218     /*
219     Entry
220     */
221 
222     // @notice Event for transfer of Tokens
223     // @param _from Address from which the Tokens were transferred
224     // @param _to Address to which the Tokens were transferred
225     // @param _value Amount of Tokens transferred
226     event Transfer(address indexed _from, address indexed _to, uint256 _value);
227     // @notice Event for approval of Tokens for some other user
228     // @param _owner Owner of the Tokens
229     // @param _spender Address that the owner approved for spending Tokens
230     // @param _value Amount of Tokens allocated for spending
231     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
232 
233     // @notice Function to view the total circulating supply of Token
234     // @dev Needs to interact with Ledger
235     function totalSupply() public view returns(uint256) {
236         return ledger.totalSupply();
237     }
238 
239     // @notice Transfers Tokens to another user
240     // @dev Needs to interact with Ledger
241     function transfer(address _to, uint256 _value) public returns(bool) {
242         require(transfersOn || msg.sender == owner, "transferring disabled");
243         require(ledger.tokenTransfer(msg.sender, _to, _value), "transfer failed");
244 
245         emit Transfer(msg.sender, _to, _value);
246         return true;
247     }
248 
249     // @notice Transfers Tokens from one user to another via an approved third party
250     // @dev Needs to interact with Ledger
251     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
252         require(transfersOn || msg.sender == owner, "transferring disabled");
253         require(ledger.tokenTransferFrom(msg.sender, _from, _to, _value), "transferFrom failed");
254 
255         emit Transfer(_from, _to, _value);
256         uint256 allowed = allowance(_from, msg.sender);
257         emit Approval(_from, msg.sender, allowed);
258         return true;
259     }
260 
261     // @notice Views the allowance of a third party given by an owner of Tokens
262     // @dev Needs to interact with Ledger
263     function allowance(address _owner, address _spender) public view returns(uint256) {
264         return ledger.allowance(_owner, _spender); 
265     }
266 
267     // @notice Allows a user to approve another user to spend an amount of Tokens on their behalf
268     // @dev Needs to interact with Ledger
269     function approve(address _spender, uint256 _value) public returns (bool) {
270         require(ledger.tokenApprove(msg.sender, _spender, _value), "approve failed");
271         emit Approval(msg.sender, _spender, _value);
272         return true;
273     }
274 
275     // @notice Views the Token balance of a user
276     // @dev Needs to interact with Ledger
277     function balanceOf(address _addr) public view returns(uint256) {
278         return ledger.balanceOf(_addr);
279     }
280 }
281 
282 contract Ledger is Owned {
283     mapping (address => uint) balances;
284     mapping (address => uint) usedToday;
285 
286     mapping (address => bool) seenHere;
287     address[] public seenHereA;
288 
289     mapping (address => mapping (address => uint256)) allowed;
290     address token;
291     uint public totalSupply = 0;
292 
293     function Ledger(address _owner, uint _preMined, uint ONE) {
294         if (_owner == 0x0) throw;
295         owner = _owner;
296 
297         seenHere[_owner] = true;
298         seenHereA.push(_owner);
299 
300         totalSupply = _preMined *ONE;
301         balances[_owner] = totalSupply;
302     }
303 
304     modifier onlyToken {
305         if (msg.sender != token) throw;
306         _;
307     }
308 
309     modifier onlyTokenOrOwner {
310         if (msg.sender != token && msg.sender != owner) throw;
311         _;
312     }
313 
314 
315     function tokenTransfer(address _from, address _to, uint amount) onlyToken returns(bool) {
316         if (amount > balances[_from]) return false;
317         if ((balances[_to] + amount) < balances[_to]) return false;
318         if (amount == 0) { return false; }
319 
320         balances[_from] -= amount;
321         balances[_to] += amount;
322 
323         if (seenHere[_to] == false) {
324             seenHereA.push(_to);
325             seenHere[_to] = true;
326         }
327 
328         return true;
329     }
330 
331     function tokenTransferFrom(address _sender, address _from, address _to, uint amount) onlyToken returns(bool) {
332         if (allowed[_from][_sender] <= amount) return false;
333         if (amount > balanceOf(_from)) return false;
334         if (amount == 0) return false;
335 
336         if ((balances[_to] + amount) < amount) return false;
337 
338         balances[_from] -= amount;
339         balances[_to] += amount;
340         allowed[_from][_sender] -= amount;
341 
342         if (seenHere[_to] == false) {
343             seenHereA.push(_to);
344             seenHere[_to] = true;
345         }
346 
347         return true;
348     }
349 
350 
351     function changeUsed(address _addr, int amount) onlyToken {
352         int myToday = int(usedToday[_addr]) + amount;
353         usedToday[_addr] = uint(myToday);
354     }
355 
356     function resetUsedToday(uint8 startI, uint8 numTimes) onlyTokenOrOwner returns(uint8) {
357         uint8 numDeleted;
358         for (uint i = 0; i < numTimes && i + startI < seenHereA.length; i++) {
359             if (usedToday[seenHereA[i+startI]] != 0) { 
360                 delete usedToday[seenHereA[i+startI]];
361                 numDeleted++;
362             }
363         }
364         return numDeleted;
365     }
366 
367     function balanceOf(address _addr) constant returns (uint) {
368         // don't forget to subtract usedToday
369         if (usedToday[_addr] >= balances[_addr]) { return 0;}
370         return balances[_addr] - usedToday[_addr];
371     }
372 
373     event Approval(address, address, uint);
374 
375     function tokenApprove(address _from, address _spender, uint256 _value) onlyToken returns (bool) {
376         allowed[_from][_spender] = _value;
377         Approval(_from, _spender, _value);
378         return true;
379     }
380 
381     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
382         return allowed[_owner][_spender];
383     }
384 
385     function changeToken(address _token) onlyOwner {
386         token = Token(_token);
387     }
388 
389     function reduceTotalSupply(uint amount) onlyToken {
390         if (amount > totalSupply) throw;
391 
392         totalSupply -= amount;
393     }
394 
395     function setBalance(address _addr, uint amount) onlyTokenOrOwner {
396         if (balances[_addr] == amount) { return; }
397         if (balances[_addr] < amount) {
398             // increasing totalSupply
399             uint increase = amount - balances[_addr];
400             totalSupply += increase;
401         } else {
402             // decreasing totalSupply
403             uint decrease = balances[_addr] - amount;
404             //TODO: safeSub
405             totalSupply -= decrease;
406         }
407         balances[_addr] = amount;
408     }
409 
410 }