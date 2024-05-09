1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65   
66 }
67 
68 contract Token {
69 
70     /// @return total amount of tokens
71     function totalSupply() public view returns (uint256);
72 
73     /// @param owner The address from which the balance will be retrieved
74     /// @return The balance
75     function balanceOf(address owner) public view returns (uint256);
76 
77     /// @notice send `_value` token to `_to` from `msg.sender`
78     /// @param to The address of the recipient
79     /// @param value The amount of token to be transferred
80     /// @return Whether the transfer was successful or not
81     function transfer(address to, uint256 value) public returns (bool);
82 
83     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
84     /// @param from The address of the sender
85     /// @param to The address of the recipient
86     /// @param value The amount of token to be transferred
87     /// @return Whether the transfer was successful or not
88     function transferFrom(address from, address to, uint256 value) public returns (bool);
89 
90     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
91     /// @param spender The address of the account able to transfer the tokens
92     /// @param value The amount of wei to be approved for transfer
93     /// @return Whether the approval was successful or not
94     function approve(address spender, uint256 value) public returns (bool);
95 
96     /// @param owner The address of the account owning tokens
97     /// @param spender The address of the account able to transfer the tokens
98     /// @return Amount of remaining tokens allowed to spent
99     function allowance(address owner, address spender) public view returns (uint256);
100 
101     event Transfer(address indexed from, address indexed to, uint256 value);
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103     
104 }
105 
106 contract StandardToken is Token {
107     using SafeMath for uint256;
108     
109     mapping (address => uint256) balances;
110     
111     mapping (address => mapping (address => uint256)) allowed;
112     
113     uint256 public totalSupply;
114     
115     /**
116     * @dev Transfer token for a specified address
117     * @param to The address to transfer to.
118     * @param value The amount to be transferred.
119     */
120     function transfer(address to, uint256 value) public returns (bool) {
121         require(value <= balances[msg.sender]);
122         require(to != address(0));
123 
124         balances[msg.sender] = balances[msg.sender].sub(value);
125         balances[to] = balances[to].add(value);
126         emit Transfer(msg.sender, to, value);
127         return true;
128     }
129     
130     /**
131     * @dev Transfer tokens from one address to another
132     * @param from address The address which you want to send tokens from
133     * @param to address The address which you want to transfer to
134     * @param value uint256 the amount of tokens to be transferred
135     */
136     function transferFrom(address from, address to, uint256 value) public returns (bool) {
137         require(value <= balances[from]);
138         require(value <= allowed[from][msg.sender]);
139         require(to != address(0));
140         
141         balances[from] = balances[from].sub(value);
142         balances[to] = balances[to].add(value);
143         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
144         emit Transfer(from, to, value);
145         return true;
146     }
147     
148     /**
149     * @dev Total number of tokens in existence
150     */
151     function totalSupply() public view returns (uint256) {
152         return totalSupply;
153     }
154     
155     /**
156     * @dev Gets the balance of the specified address.
157     * @param owner The address to query the balance of.
158     * @return An uint256 representing the amount owned by the passed address.
159     */
160     function balanceOf(address owner) public view returns (uint256) {
161         return balances[owner];
162     }
163     
164     /**
165     * @dev Function to check the amount of tokens that an owner allowed to a spender.
166     * @param owner address The address which owns the funds.
167     * @param spender address The address which will spend the funds.
168     * @return A uint256 specifying the amount of tokens still available for the spender.
169     */
170     function allowance(address owner, address spender) public view returns (uint256 remaining) {
171       return allowed[owner][spender];
172     }
173     
174     /**
175     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176     * Beware that changing an allowance with this method brings the risk that someone may use both the old
177     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179     * @param spender The address which will spend the funds.
180     * @param value The amount of tokens to be spent.
181     */
182     function approve(address spender, uint256 value) public returns (bool success) {
183         require(spender != address(0));
184         
185         allowed[msg.sender][spender] = value;
186         emit Approval(msg.sender, spender, value);
187         return true;
188     }
189     
190 }
191 
192 contract Ownable {
193     address public owner;
194     
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196     
197     constructor() public {
198         owner = msg.sender;
199     }
200     
201     modifier onlyOwner() {
202         require(msg.sender == owner);
203         _;
204     }
205     
206     function transferOwnership(address newOwner) public onlyOwner {
207         require(newOwner != address(0));
208         
209         emit OwnershipTransferred(owner, newOwner);
210         owner = newOwner;
211     }
212     
213 }
214 
215 contract NNBToken is StandardToken, Ownable {
216     string public constant name = "NNB Token";    //fancy name: eg Simon Bucks
217     string public constant symbol = "NNB";           //An identifier: eg SBX
218     uint8 public constant decimals = 18;            //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
219     string public constant version = "H1.0";        //human 0.1 standard. Just an arbitrary versioning scheme.
220     
221     mapping (address => uint256) lockedBalance;
222     mapping (address => uint256) releasedBalance;
223     mapping (address => TimeLock[]) public allocations;
224     
225     struct TimeLock {
226         uint time;
227         uint256 balance;
228     }
229     
230     uint256 public constant BASE_SUPPLY = 10 ** uint256(decimals);
231     uint256 public constant INITIAL_SUPPLY = 6 * (10 ** 9) * BASE_SUPPLY;    //initial total supply for six billion
232     
233     uint256 public constant noLockedOperatorSupply = INITIAL_SUPPLY / 100 * 2;  // no locked operator 2%
234     
235     uint256 public constant lockedOperatorSupply = INITIAL_SUPPLY / 100 * 18;  // locked operator 18%
236     uint256 public constant lockedInvestorSupply = INITIAL_SUPPLY / 100 * 10;  // locked investor 10%
237     uint256 public constant lockedTeamSupply = INITIAL_SUPPLY / 100 * 10;  // locked team 10%
238 
239     uint256 public constant lockedPrivatorForBaseSupply = INITIAL_SUPPLY / 100 * 11;  // locked privator base 11%
240     uint256 public constant lockedPrivatorForEcologyPartOneSupply = INITIAL_SUPPLY / 100 * 8;  // locked privator ecology part one for 8%
241     uint256 public constant lockedPrivatorForEcologyPartTwoSupply = INITIAL_SUPPLY / 100 * 4;  // locked privator ecology part one for 4%
242     
243     uint256 public constant lockedPrivatorForFaithSupply = INITIAL_SUPPLY / 1000 * 11;  // locked privator faith 1.1%
244     uint256 public constant lockedPrivatorForDevelopSupply = INITIAL_SUPPLY / 1000 * 19;  // locked privator develop 1.9%
245     
246     uint256 public constant lockedLabSupply = INITIAL_SUPPLY / 100 * 10;  // locked lab 10%
247     
248     uint public constant operatorUnlockTimes = 24;  // operator unlock times
249     uint public constant investorUnlockTimes = 3;   // investor unlock times
250     uint public constant teamUnlockTimes = 24;      // team unlock times
251     uint public constant privatorForBaseUnlockTimes = 6;   // privator base unlock times
252     uint public constant privatorForEcologyUnlockTimes = 9;  // privator ecology unlock times
253     uint public constant privatorForFaithUnlockTimes = 6;   // privator faith unlock times
254     uint public constant privatorForDevelopUnlockTimes = 3;  // privator develop unlock times
255     uint public constant labUnlockTimes = 12;       // lab unlock times
256     
257     event Lock(address indexed locker, uint256 value, uint releaseTime);
258     event UnLock(address indexed unlocker, uint256 value);
259     
260     constructor(address operator, address investor, address team, address privatorBase,
261                 address privatorEcology, address privatorFaith, address privatorDevelop, address lab) public {
262         totalSupply = INITIAL_SUPPLY;
263         balances[msg.sender] = INITIAL_SUPPLY;
264         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
265         
266         initialLockedValues(operator, investor, team, privatorBase, privatorEcology, privatorFaith, privatorDevelop, lab);
267     }
268     
269     /**
270      * init the locked total value, and the first release time
271      */ 
272     function initialLockedValues(address operator, address investor, address team, address privatorBase,
273                                  address privatorEcology, address privatorFaith, address privatorDevelop, address lab) internal onlyOwner returns (bool success) {
274         
275         // init operator address value and locked value. every month can unlock operator value for 1/24 since next month
276         uint unlockTime = now + 30 days;
277         lockedValuesAndTime(operator, lockedOperatorSupply, operatorUnlockTimes, unlockTime);
278         
279         //init investor address value and locked value. unlocked investor value, at six month for 30%, nine month for 30%, twelve month for the others ,40%
280         require(0x0 != investor);
281         lockedBalance[investor] = lockedInvestorSupply;
282         releasedBalance[investor] = 0;
283         
284         unlockTime = now;
285         allocations[investor].push(TimeLock(unlockTime + 180 days, lockedInvestorSupply.div(10).mul(3)));
286         allocations[investor].push(TimeLock(unlockTime + 270 days, lockedInvestorSupply.div(10).mul(3)));
287         allocations[investor].push(TimeLock(unlockTime + 360 days, lockedInvestorSupply.div(10).mul(4)));
288         
289         //init team address value and locked value. every month can unlock team value for 1/24 since next 6 months
290         unlockTime = now + 180 days;
291         lockedValuesAndTime(team, lockedTeamSupply, teamUnlockTimes, unlockTime);
292         
293         //init privator base address value and locked value
294         unlockTime = now;
295         lockedValuesAndTime(privatorBase, lockedPrivatorForBaseSupply, privatorForBaseUnlockTimes, unlockTime);
296         
297         //init privator ecology address value and locked value
298         //this values will divide into two parts, part one for 8% of all inital supply, part two for 4% of all inital supply
299         //the part one will unlock for 9 times, part two will unlock for 6 times
300         //so, from 1 to 6 unlock times, the unlock values = part one / 9 + part two / 6,  from 7 to 9, the unlock values = part one / 9
301         require(0x0 != privatorEcology);
302         releasedBalance[privatorEcology] = 0;
303         lockedBalance[privatorEcology] = lockedPrivatorForEcologyPartOneSupply.add(lockedPrivatorForEcologyPartTwoSupply);
304 
305         unlockTime = now;
306         for (uint i = 0; i < privatorForEcologyUnlockTimes; i++) {
307             if (i > 0) {
308                 unlockTime = unlockTime + 30 days;
309             }
310             
311             uint256 lockedValue = lockedPrivatorForEcologyPartOneSupply.div(privatorForEcologyUnlockTimes);
312             if (i == privatorForEcologyUnlockTimes - 1) {  // the last unlock time
313                 lockedValue = lockedPrivatorForEcologyPartOneSupply.div(privatorForEcologyUnlockTimes).add(lockedPrivatorForEcologyPartOneSupply.mod(privatorForEcologyUnlockTimes));
314             }
315             if (i < 6) {
316                 uint256 partTwoValue = lockedPrivatorForEcologyPartTwoSupply.div(6);
317                 if (i == 5) {  //the last unlock time
318                     partTwoValue = lockedPrivatorForEcologyPartTwoSupply.div(6).add(lockedPrivatorForEcologyPartTwoSupply.mod(6));
319                 }
320                 lockedValue = lockedValue.add(partTwoValue);
321             }
322             
323             allocations[privatorEcology].push(TimeLock(unlockTime, lockedValue));
324         }
325         
326         //init privator faith address value and locked value
327         unlockTime = now;
328         lockedValuesAndTime(privatorFaith, lockedPrivatorForFaithSupply, privatorForFaithUnlockTimes, unlockTime);
329         
330         //init privator develop address value and locked value
331         unlockTime = now;
332         lockedValuesAndTime(privatorDevelop, lockedPrivatorForDevelopSupply, privatorForDevelopUnlockTimes, unlockTime);
333         
334         //init lab address value and locked value. every month can unlock lab value for 1/12 since next year
335         unlockTime = now + 365 days;
336         lockedValuesAndTime(lab, lockedLabSupply, labUnlockTimes, unlockTime);
337         
338         return true;
339     }
340     
341     /**
342      * lock the address value, set the unlock time
343      */ 
344     function lockedValuesAndTime(address target, uint256 lockedSupply, uint lockedTimes, uint unlockTime) internal onlyOwner returns (bool success) {
345         require(0x0 != target);
346         releasedBalance[target] = 0;
347         lockedBalance[target] = lockedSupply;
348         
349         for (uint i = 0; i < lockedTimes; i++) {
350             if (i > 0) {
351                 unlockTime = unlockTime + 30 days;
352             }
353             uint256 lockedValue = lockedSupply.div(lockedTimes);
354             if (i == lockedTimes - 1) {  //the last unlock time
355                 lockedValue = lockedSupply.div(lockedTimes).add(lockedSupply.mod(lockedTimes));
356             }
357             allocations[target].push(TimeLock(unlockTime, lockedValue));
358         }
359         
360         return true;
361     }
362     
363     /**
364      * unlock the address values
365      */ 
366     function unlock(address target) public onlyOwner returns(bool success) {
367         require(0x0 != target);
368         
369         uint256 value = 0;
370         for(uint i = 0; i < allocations[target].length; i++) {
371             if(now >= allocations[target][i].time) {
372                 value = value.add(allocations[target][i].balance);
373                 allocations[target][i].balance = 0;
374             }
375         }
376         lockedBalance[target] = lockedBalance[target].sub(value);
377         releasedBalance[target] = releasedBalance[target].add(value);
378         
379         transfer(target, value);
380         emit UnLock(target, value);
381         
382         return true;
383     }
384     
385     /**
386      * operator address has 2% for no locked.
387      */ 
388     function initialOperatorValue(address operator) public onlyOwner {
389         transfer(operator, noLockedOperatorSupply);
390     }
391     
392     /**
393      * this function can get the locked value
394      */
395     function lockedOf(address owner) public constant returns (uint256 balance) {
396         return lockedBalance[owner];
397     }
398     
399     /**
400      * get the next unlock time
401      */ 
402     function unlockTimeOf(address owner) public constant returns (uint time) {
403         for(uint i = 0; i < allocations[owner].length; i++) {
404             if(allocations[owner][i].time >= now) {
405                 return allocations[owner][i].time;
406             }
407         }
408     }
409     
410     /**
411      * get the next unlock value
412      */ 
413     function unlockValueOf(address owner) public constant returns (uint256 balance) {
414         for(uint i = 0; i < allocations[owner].length; i++) {
415             if(allocations[owner][i].time >= now) {
416                 return allocations[owner][i].balance;
417             }
418         }
419     }
420     
421     /**
422      * this function can get the released value
423      */
424     function releasedOf(address owner) public constant returns (uint256 balance) {
425         return releasedBalance[owner];
426     }
427     
428     /**
429      * this function can be used when you want to send same number of tokens to all the recipients
430      */
431     function batchTransferForSingleValue(address[] dests, uint256 value) public onlyOwner {
432         uint256 i = 0;
433         uint256 sendValue = value * BASE_SUPPLY;
434         while (i < dests.length) {
435             transfer(dests[i], sendValue);
436             i++;
437         }
438     }
439     
440     /**
441      * this function can be used when you want to send every recipeint with different number of tokens
442      */
443     function batchTransferForDifferentValues(address[] dests, uint256[] values) public onlyOwner {
444         if(dests.length != values.length) return;
445         uint256 i = 0;
446         while (i < dests.length) {
447             uint256 sendValue = values[i] * BASE_SUPPLY;
448             transfer(dests[i], sendValue);
449             i++;
450         }
451     }
452     
453 }