1 pragma solidity >= 0.4.5<0.60;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8   /**
9   * @dev Multiplies two unsigned integers, reverts on overflow.
10   * @notice source:
11   * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero,
15     // but the benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     require(c / a == b, "SafeMath: multiplication overflow");
22     return c;
23   }
24 
25   /**
26    * @dev Integer division of two unsigned integers truncating the quotient,
27    * reverts on division by zero.
28    */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // Solidity only automatically asserts when dividing by 0
31     require(b > 0, "SafeMath: division by zero");
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   /**
38    * @dev Subtracts two unsigned integers, reverts on overflow
39    * (i.e. if subtrahend is greater than minuend).
40    */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a, "SafeMath: subtraction overflow");
43     uint256 c = a - b;
44     return c;
45   }
46 
47   /**
48    * @dev Adds two unsigned integers, reverts on overflow.
49    */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a, "SafeMath: addition overflow");
53     return c;
54   }
55 
56   /**
57    * @dev Divides two unsigned integers and returns the remainder
58    *(unsigned integer modulo), reverts when dividing by zero.
59    */
60   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b != 0, "SafeMath: modulo by zero");
62     return a % b;
63   }
64 }
65 
66 /*
67 ERC-20 token
68 EIP-1132 locking functions
69 Burn function
70 */
71 contract InBitToken {
72 
73   using SafeMath for uint;
74 
75   string public name = 'InBit Token';
76   string public symbol = 'InBit';
77   string public standard = 'InBit Token v1.0';
78   uint256 public totalSupply;
79   uint8 public decimals;
80 
81   // @dev Records data of all the tokens transferred
82   // @param _from Address that sends tokens
83   // @param _to Address that receives tokens
84   // @param _value the amount that _spender can spend on behalf of _owner
85   event Transfer(
86     address indexed _from,
87     address indexed _to,
88     uint256 _value
89   );
90 
91   // @dev Records data of an Approval to spend the tokens on behalf of
92   // @param _owner address that approves to pay on its behalf
93   // @param _spender address to whom the approval is issued
94   // @param _value the amount that _spender can spend on behalf of _owner
95 
96   event Approval(
97     address indexed _owner,
98     address indexed _spender,
99     uint256 _value
100   );
101 
102   //@dev Records the burn of tokens from a specific address
103   // @param _from address that burns the tokens from its balance
104   // @param _value the number of tokens that are being burned
105   event Burn(
106     address indexed _from,
107     uint256 _value
108   );
109 
110   //@dev Records data of all the tokens locked
111   //@param _of address that has tokens locked
112   //@param _reason the reason explaining why these tokens are locked
113   //@param _amount the number of tokens being locked
114   //@param _validity time in seconds tokens will be locked for
115   event Locked(
116     address indexed _of,
117     bytes32 indexed _reason,
118     uint256 _amount,
119     uint256 _validity
120   );
121 
122   //@dev Records data of all the tokens unlocked
123   //@param _of address for whom the tokens are unlocked
124   //@param _reason the reason explaining why these tokens were locked
125   //@param _amount the number of tokens being unlocked
126   event Unlocked(
127     address indexed _of,
128     bytes32 indexed _reason,
129     uint256 _amount
130   );
131 
132   //@dev mapping array for keeping the balances of all the accounts
133   mapping(address => uint256) public balanceOf;
134 
135   //@dev amping array that keeps the allowance that is still allowed to withdraw from _owner
136   mapping(address => mapping(address => uint256)) public allowance;
137   //@notice account A approved account B to send C tokens (amount C is actually left )
138 
139   //@dev reasons why tokens have been locked
140   mapping(address => bytes32[]) public lockReason;
141 
142   //@dev holds number & validity of tokens locked for a given reason for a specified address
143   //@notice tokens locked for A account with B reason and C data: structure {ammount, valididty, claimed}
144   mapping(address => mapping(bytes32 => lockToken)) public locked;
145 
146   // @dev locked token structure
147   // @param amount - the amount of tokens lockedToken
148   // @param validity - timestamp until when the tokes are locked
149   // @param claimed - where the locked tokens already claimed
150   // (unlocked and transferred to the address)
151   struct lockToken {
152     uint256 amount;
153     uint256 validity;
154     bool claimed;
155   }
156 
157   constructor(uint256 _intialSupply, uint8 _intialDecimals)
158     public
159   {
160     balanceOf[msg.sender] = _intialSupply;
161     totalSupply = _intialSupply;
162     decimals = _intialDecimals;
163   }
164 
165 
166   // @dev Transfers tokens from sender account to
167   // @param _from Address that sends tokens
168   // @param _to Address that receives tokens
169   // @param _value the amount that _spender can spend on behalf of _owner
170   function transfer(address _to, uint256 _value)
171     public
172     returns(bool success)
173   {
174     require(balanceOf[msg.sender] >= _value);
175     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
176     balanceOf[_to] = balanceOf[_to].add(_value);
177     emit Transfer(msg.sender, _to, _value);
178     return true;
179   }
180 
181   // @dev Allows _spender to withdraw from [msg.sender] account multiple times,
182   // up to the _value amount.
183   // @param _spender address to whom the approval is issued
184   // @param _value the amount that _spender can spend on behalf of _owner
185   // @notice If this function is called again it overwrites the current allowance
186   // with _value.
187   function approve(address _spender, uint256 _value)
188     public
189     returns(bool success)
190   {
191     allowance[msg.sender][_spender] = _value;
192     emit Approval(msg.sender, _spender, _value);
193     return true;
194   }
195 
196   // @dev Transfers tokens on behalf of _form account to _to account. [msg.sender]
197   // should have an allowance from _from account to transfer the number of tokens.
198   // @param _from address tokens are transferred from
199   // @param _to address tokens are transferred to
200   // @parram _value the number of tokens transferred
201   // @notice _from account should have enough tokens and allowance should be equal
202   // or greater than the amount transferred
203   function transferFrom(address _from, address _to, uint256 _value)
204     public
205     returns(bool success)
206   {
207     require(balanceOf[_from] >= _value);
208     require(allowance[_from][msg.sender] >= _value);
209     balanceOf[_from] = balanceOf[_from].sub(_value);
210     balanceOf[_to] = balanceOf[_to].add(_value);
211     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
212     emit Transfer(_from, _to, _value);
213     return true;
214   }
215 
216   // @notice Functions used for locking the tokens go next
217   // @dev Locks a specified amount of tokens against an [msg.sender] address,
218   // for a specified reason and time
219   // @param _reason The reason to lock tokens
220   // @param _amount Number of tokens to be locked
221   // @param _time Lock time in seconds
222   function lock(bytes32 _reason, uint256 _amount, uint256 _time)
223   public
224   returns (bool)
225   {
226     uint256 validUntil = now.add(_time);
227     require(tokensLocked(msg.sender, _reason) == 0, 'Tokens already locked');
228     // If tokens are already locked, then functions extendLock or
229     // increaseLockAmount should be used to make any changes
230     require(_amount != 0, 'Amount can not be 0');
231     if (locked[msg.sender][_reason].amount == 0)
232       lockReason[msg.sender].push(_reason);
233     transfer(address(this), _amount);
234     locked[msg.sender][_reason] = lockToken(_amount, validUntil, false);
235     emit Locked(msg.sender, _reason, _amount, validUntil);
236     return true;
237   }
238 
239   // @dev Transfers from [msg.sender] account and locks against specified address
240   // a specified amount of tokens, for a specified reason and time
241   // @param _to Address against which tokens have to be locked (to which address
242   // should be transferred after unlocking and claiming)
243   // @param _reason The reason to lock tokens
244   // @param _amount Number of tokens to be transferred and locked
245   // @param _time Lock time in seconds
246   function transferWithLock(
247     address _to,
248     bytes32 _reason,
249     uint256 _amount,
250     uint256 _time
251   )
252     public
253     returns (bool)
254   {
255     uint256 validUntil = now.add(_time);
256     require(tokensLocked(_to, _reason) == 0, 'Tokens already locked');
257     require(_amount != 0, 'Amount can not be 0');
258     if (locked[_to][_reason].amount == 0)
259       lockReason[_to].push(_reason);
260     transfer(address(this), _amount);
261     locked[_to][_reason] = lockToken(_amount, validUntil, false);
262     emit Locked(_to, _reason, _amount, validUntil);
263     return true;
264   }
265 
266   // @notice Functions used for increasing the number or time of locked tokens go next
267   // @dev Extends the time of lock for tokens already locked for a specific reason
268   // @param _reason The reason tokens are locked for.
269   // @param _time Desirable lock extension time in seconds
270   function extendLock(bytes32 _reason, uint256 _time)
271     public
272     returns (bool)
273   {
274     require(tokensLocked(msg.sender, _reason) > 0, 'There are no tokens locked for specified reason');
275     locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);
276     emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
277     return true;
278   }
279 
280   // @dev Increase number of tokens already locked for a specified reason
281   // @param _reason The reason tokens are locked for.
282   // @param _amount Number of tokens to be increased
283   function increaseLockAmount(bytes32 _reason, uint256 _amount) public returns (bool)
284   {
285     require(tokensLocked(msg.sender, _reason) > 0, 'There are no tokens locked for specified reason');
286     transfer(address(this), _amount);
287     locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
288     emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
289     return true;
290   }
291 
292   // @notice Function used for unlocking tokens goes next
293   // @dev Unlocks the unlockable tokens of a specified address
294   // @param _of Address of user, claiming back unlockable tokens
295   function unlock(address _of) public returns (uint256 unlockableTokens) {
296     uint256 lockedTokens;
297     for (uint256 i = 0; i < lockReason[_of].length; i++) {
298       lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
299       if (lockedTokens > 0) {
300         unlockableTokens = unlockableTokens.add(lockedTokens);
301         locked[_of][lockReason[_of][i]].claimed = true;
302         emit Unlocked(_of, lockReason[_of][i], lockedTokens);
303       }
304     }
305     if (unlockableTokens > 0)
306       this.transfer(_of, unlockableTokens);
307   }
308 
309   // @dev Burns the tokens form the [msg.sender] account and reduces the TotalSupply
310   // @parram _value the number of tokens to be burned
311   function burn(uint256 _value) public returns (bool success)
312   {
313     require(balanceOf[msg.sender] >= _value);
314     require(_value >= 0);
315     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
316     totalSupply = totalSupply.sub(_value);
317     emit Burn(msg.sender, _value);
318     return true;
319   }
320 
321   //@notice The end of standard ERC-20 functions
322   //@noitce Further goes additional function from ERC1132 and burn function
323   //@dev Returns tokens locked for a specified address for a specified reason
324   //@param _of the address being checked
325   //@param _reason the reason balance of locked tokens is checked for (how many tokens are locked for a specified reason)
326   //@noitce this function shows the number of unclaimed tokens for the _of address at the moment. It shows as locked as well as unlockable but not yet claimed tokens
327   function tokensLocked(address _of, bytes32 _reason)
328     public
329     view
330     returns (uint256 amount)
331   {
332     if (!locked[_of][_reason].claimed)
333     amount = locked[_of][_reason].amount;
334   }
335 
336   // @dev Returns tokens locked for a specified address for a specified reason at a specific time
337   // @param _of the address being checked
338   // @param _reason the reason balance of locked tokens is checked for (how many tokens will be locked for a specified reason)
339   // @param _time the future timestamp balance of locked tokens is checked for (how many tokens will be locked for a specified reason at a specified timestamp)
340   // @noitce this function shows the number of unclaimed tokens for the _of address at the moment in future defined in a _time parameter. It shows only locked tokens.
341   // The difference with tokensLocked is because of tokensLocked shows the amount at the current moment and calculates both locked and unlockable but not yet claimed tokes at the moment.
342   // In the future, we cannot predict the behavior of the user and can show only locked ones.
343   function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
344     public
345     view
346     returns (uint256 amount)
347   {
348     if (locked[_of][_reason].validity > _time)
349     amount = locked[_of][_reason].amount;
350   }
351 
352   // @dev Returns total number of tokens held by an address (locked + unlockable but not yet claimed + transferable)
353   // @param _of The address to query the total balance of
354   function totalBalanceOf(address _of)
355     public
356     view
357     returns (uint256 amount)
358   {
359     amount = balanceOf[_of];
360     for (uint256 i = 0; i < lockReason[_of].length; i++) {
361       amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
362     }
363   }
364 
365   // @dev Returns the amount of unlockable tokens for a specified address for a specified reason
366   // @param _of The address being checked
367   // @param _reason The reason number of unlockable tokens is checked for
368   // @notice How many tokens are unlockable for a specified reason for a specified address
369   function tokensUnlockable(address _of, bytes32 _reason)
370     public
371     view
372     returns (uint256 amount)
373   {
374     if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed){
375       amount = locked[_of][_reason].amount;
376     }
377   }
378 
379   // @dev Returns the total amount of all unlockable tokens for a specified address.
380   // @param _of The address to query the unlockable token count of
381   function getUnlockableTokens(address _of)
382     public
383     view
384     returns (uint256 unlockableTokens)
385   {
386     for (uint256 i = 0; i < lockReason[_of].length; i++) {
387       unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
388     }
389   }
390 }