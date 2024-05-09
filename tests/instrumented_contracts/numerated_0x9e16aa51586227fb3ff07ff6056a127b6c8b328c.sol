1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11      * @dev Multiplies two numbers, throws on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23      * @dev Integer division of two numbers, truncating the quotient.
24      */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32     /**
33      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34      */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41      * @dev Adds two numbers, throws on overflow.
42      */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }   
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address public owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62      * account.
63      */
64     constructor() public {
65         owner = msg.sender;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      * @param newOwner The address to transfer ownership to.
79      */
80     function transferOwnership(address newOwner) public onlyOwner {
81         require(newOwner != address(0));
82         emit OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84     }
85 }
86 
87 /** 
88  * @title Based on the 'final' ERC20 token standard as specified at:
89  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md 
90  */
91 contract ERC20Interface {
92     event Transfer(address indexed _from, address indexed _to, uint256 _value);
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94 
95     function name() public view returns (string);
96     function symbol() public view returns (string);
97     function decimals() public view returns (uint8);
98     function totalSupply() public view returns (uint256);
99     function balanceOf(address _owner) public view returns (uint256);
100     function allowance(address _owner, address _spender) public view returns (uint256);
101     function transfer(address _to, uint256 _value) public returns (bool);
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
103     function approve(address _spender, uint256 _value) public returns (bool);
104 }
105 
106 /**
107  * @title TestToken
108  * @dev The TestToken contract provides the token functionality of the IPT Global token
109  * and allows the admin to distribute frozen tokens which requires defrosting to become transferable.
110  */
111 contract IPTGlobal is ERC20Interface, Ownable {
112     using SafeMath for uint256;
113     
114     //Name of the token.
115     string  internal constant NAME = "IPT Global";
116     
117     //Symbol of the token.
118     string  internal constant SYMBOL = "IPT";     
119     
120     //Granularity of the token.
121     uint8   internal constant DECIMALS = 8;        
122     
123     //Factor for numerical calculations.
124     uint256 internal constant DECIMALFACTOR = 10 ** uint(DECIMALS); 
125     
126     //Total supply of IPT Global tokens.
127     uint256 internal constant TOTAL_SUPPLY = 300000000 * uint256(DECIMALFACTOR);  
128     
129     //Base unlocking value used to calculate fractional percentage of 0.2 %
130     uint8   internal constant unlockingValue = 2;
131     
132     //Base unlocking numerator used to calculate fractional percentage of 0.2 %
133     uint8   internal constant unlockingNumerator = 10;
134     
135     //Allows admin to call a getter which tracks latest/daily unlocked tokens
136     uint256 private unlockedTokensDaily;
137     //Allows admin to call a getter which tracks total unlocked tokens
138     uint256 private unlockedTokensTotal;
139     
140     address[] uniqueLockedTokenReceivers; 
141     
142     //Stores uniqueness of all locked token recipients.
143     mapping(address => bool)    internal uniqueLockedTokenReceiver;
144     
145     //Stores all locked IPT Global token holders.
146     mapping(address => bool)    internal isHoldingLockedTokens;
147     
148     //Stores excluded recipients who will not be effected by token unlocking.
149     mapping(address => bool)    internal excludedFromTokenUnlock;
150     
151     //Stores and tracks locked IPT Global token balances.
152     mapping(address => uint256) internal lockedTokenBalance;
153     
154     //Stores the balance of IPT Global holders (complies with ERC-Standard).
155     mapping(address => uint256) internal balances; 
156     
157     //Stores any allowances given to other IPT Global holders.
158     mapping(address => mapping(address => uint256)) internal allowed; 
159     
160     
161     event HoldingLockedTokens(
162         address recipient, 
163         uint256 lockedTokenBalance,
164         bool    isHoldingLockedTokens);
165     
166     event LockedTokensTransferred(
167         address recipient, 
168         uint256 lockedTokens,
169         uint256 lockedTokenBalance);
170         
171     event TokensUnlocked(
172         address recipient,
173         uint256 unlockedTokens,
174         uint256 lockedTokenBalance);
175         
176     event LockedTokenBalanceChanged(
177         address recipient, 
178         uint256 unlockedTokens,
179         uint256 lockedTokenBalance);
180         
181     event ExcludedFromTokenUnlocks(
182         address recipient,
183         bool    excludedFromTokenUnlocks);
184     
185     event CompleteTokenBalanceUnlocked(
186         address recipient,
187         uint256 lockedTokenBalance,
188         bool    isHoldingLockedTokens,
189         bool    completeTokenBalanceUnlocked);
190     
191     
192     /**
193      * @dev constructor sets initialises and configurates the smart contract.
194      * More specifically, it grants the smart contract owner the total supply
195      * of IPT Global tokens.
196      */
197     constructor() public {
198         balances[msg.sender] = TOTAL_SUPPLY;
199     }
200 
201     /**
202      * @dev allows owner to transfer tokens which are locked by default.
203      * @param _recipient is the addresses which will receive locked tokens.
204      * @param _lockedTokens is the amount of locked tokens to distribute.
205      * and therefore requires unlocking to be transferable.
206      */
207     function lockedTokenTransfer(address[] _recipient, uint256[] _lockedTokens) external onlyOwner {
208        
209         for (uint256 i = 0; i < _recipient.length; i++) {
210             if (!uniqueLockedTokenReceiver[_recipient[i]]) {
211                 uniqueLockedTokenReceiver[_recipient[i]] = true;
212                 uniqueLockedTokenReceivers.push(_recipient[i]);
213                 }
214                 
215             isHoldingLockedTokens[_recipient[i]] = true;
216             
217             lockedTokenBalance[_recipient[i]] = lockedTokenBalance[_recipient[i]].add(_lockedTokens[i]);
218             
219             transfer(_recipient[i], _lockedTokens[i]);
220             
221             emit HoldingLockedTokens(_recipient[i], _lockedTokens[i], isHoldingLockedTokens[_recipient[i]]);
222             emit LockedTokensTransferred(_recipient[i], _lockedTokens[i], lockedTokenBalance[_recipient[i]]);
223         }
224     }
225 
226     /**
227      * @dev allows owner to change the locked balance of a recipient manually.
228      * @param _owner is the address of the locked token balance to unlock.
229      * @param _unlockedTokens is the amount of locked tokens to unlock.
230      */
231     function changeLockedBalanceManually(address _owner, uint256 _unlockedTokens) external onlyOwner {
232         require(_owner != address(0));
233         require(_unlockedTokens <= lockedTokenBalance[_owner]);
234         require(isHoldingLockedTokens[_owner]);
235         require(!excludedFromTokenUnlock[_owner]);
236         
237         lockedTokenBalance[_owner] = lockedTokenBalance[_owner].sub(_unlockedTokens);
238         emit LockedTokenBalanceChanged(_owner, _unlockedTokens, lockedTokenBalance[_owner]);
239         
240         unlockedTokensDaily  = unlockedTokensDaily.add(_unlockedTokens);
241         unlockedTokensTotal  = unlockedTokensTotal.add(_unlockedTokens);
242         
243         if (lockedTokenBalance[_owner] == 0) {
244            isHoldingLockedTokens[_owner] = false;
245            emit CompleteTokenBalanceUnlocked(_owner, lockedTokenBalance[_owner], isHoldingLockedTokens[_owner], true);
246         }
247     }
248 
249     /**
250      * @dev allows owner to unlock 0.2% of locked token balances, be careful with implementation of 
251      * loops over large arrays, could result in block limit issues.
252      * should be called once a day as per specifications.
253      */
254     function unlockTokens() external onlyOwner {
255 
256         for (uint256 i = 0; i < uniqueLockedTokenReceivers.length; i++) {
257             if (isHoldingLockedTokens[uniqueLockedTokenReceivers[i]] && 
258                 !excludedFromTokenUnlock[uniqueLockedTokenReceivers[i]]) {
259                 
260                 uint256 unlockedTokens = (lockedTokenBalance[uniqueLockedTokenReceivers[i]].mul(unlockingValue).div(unlockingNumerator)).div(100);
261                 lockedTokenBalance[uniqueLockedTokenReceivers[i]] = lockedTokenBalance[uniqueLockedTokenReceivers[i]].sub(unlockedTokens);
262                 uint256 unlockedTokensToday = unlockedTokensToday.add(unlockedTokens);
263                 
264                 emit TokensUnlocked(uniqueLockedTokenReceivers[i], unlockedTokens, lockedTokenBalance[uniqueLockedTokenReceivers[i]]);
265             }
266             if (lockedTokenBalance[uniqueLockedTokenReceivers[i]] == 0) {
267                 isHoldingLockedTokens[uniqueLockedTokenReceivers[i]] = false;
268                 
269                 emit CompleteTokenBalanceUnlocked(uniqueLockedTokenReceivers[i], lockedTokenBalance[uniqueLockedTokenReceivers[i]], isHoldingLockedTokens[uniqueLockedTokenReceivers[i]], true);
270             }  
271         }    
272         unlockedTokensDaily  = unlockedTokensToday;
273         unlockedTokensTotal  = unlockedTokensTotal.add(unlockedTokensDaily);
274     }
275     
276     /**
277      * @dev allows owner to exclude certain recipients from having their locked token balance unlocked.
278      * @param _excludedRecipients is the addresses to add token unlock exclusion for.
279      * @return a boolean representing whether the function was executed succesfully.
280      */
281     function addExclusionFromTokenUnlocks(address[] _excludedRecipients) external onlyOwner returns (bool) {
282         for (uint256 i = 0; i < _excludedRecipients.length; i++) {
283             excludedFromTokenUnlock[_excludedRecipients[i]] = true;
284             emit ExcludedFromTokenUnlocks(_excludedRecipients[i], excludedFromTokenUnlock[_excludedRecipients[i]]);
285         }
286         return true;
287     }
288     
289     /**
290      * @dev allows owner to remove any exclusion from certain recipients, allowing their locked token balance to be unlockable again.
291      * @param _excludedRecipients is the addresses to remove unlock token exclusion from.
292      * @return a boolean representing whether the function was executed succesfully.
293      */
294     function removeExclusionFromTokenUnlocks(address[] _excludedRecipients) external onlyOwner returns (bool) {
295         for (uint256 i = 0; i < _excludedRecipients.length; i++) {
296             excludedFromTokenUnlock[_excludedRecipients[i]] = false;
297             emit ExcludedFromTokenUnlocks(_excludedRecipients[i], excludedFromTokenUnlock[_excludedRecipients[i]]);
298         }
299         return true;
300     }
301     
302     /**
303      * @dev allows anyone to check the unlocked and locked token balance of a recipient. 
304      * @param _owner is the address of the locked token balance to check.
305      * @return a uint256 representing the locked and unlocked token balances.
306      */
307     function checkTokenBalanceState(address _owner) external view returns(uint256 unlockedBalance, uint256 lockedBalance) {
308     return (balanceOf(_owner).sub(lockedTokenBalance[_owner]), lockedTokenBalance[_owner]);
309     }
310     
311     /**
312      * @dev allows anyone to check the a list of all locked token recipients. 
313      * @return an address array representing the list of recipients.
314      */
315     function checkUniqueLockedTokenReceivers() external view returns (address[]) {
316         return uniqueLockedTokenReceivers;
317     }
318     
319      /**
320      * @dev allows checking of the daily and total amount of unlocked tokens. 
321      * @return an uint representing the daily and total unlocked value.
322      */
323     function checkUnlockedTokensData() external view returns (uint256 unlockedDaily, uint256 unlockedTotal) {
324         return (unlockedTokensDaily, unlockedTokensTotal);
325     }
326 
327     /**
328      * @param _to The address to transfer to.
329      * @param _value The amount to be transferred.
330      * @return a boolean representing whether the function was executed succesfully.
331      */
332     function transfer(address _to, uint256 _value) public returns (bool) {
333         require(_to != address(0));
334         require(_value <= balances[msg.sender]);
335         
336         if (isHoldingLockedTokens[msg.sender]) {
337             require(_value <= balances[msg.sender].sub(lockedTokenBalance[msg.sender]));
338         }
339         
340         balances[msg.sender] = balances[msg.sender].sub(_value);
341         balances[_to] = balances[_to].add(_value);
342         emit Transfer(msg.sender, _to, _value);
343         return true;
344          
345     }
346     
347     /**
348      * @dev Transfer tokens from one address to another
349      * @param _from address The address which you want to send tokens from
350      * @param _to address The address which you want to transfer to
351      * @param _value uint256 the amount of tokens to be transferred
352      * @return a boolean representing whether the function was executed succesfully.
353      */
354     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
355         require(_to != address(0));
356         require(_value <= balances[_from]);
357         require(_value <= allowed[_from][msg.sender]);
358         
359         if (isHoldingLockedTokens[_from]) {
360             require(_value <= balances[_from].sub(lockedTokenBalance[_from]));
361             require(_value <= allowed[_from][msg.sender]);
362         }
363 
364         balances[_from] = balances[_from].sub(_value);
365         balances[_to] = balances[_to].add(_value);
366         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
367         emit Transfer(_from, _to, _value);
368         return true;
369     }
370 
371     /**
372      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
373      * Beware that changing an allowance with this method brings the risk that someone may use both the old
374      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
375      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
376      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
377      * @param _spender The address which will spend the funds.
378      * @param _value The amount of tokens to be spent.
379      * @return a boolean representing whether the function was executed succesfully.
380      */
381     function approve(address _spender, uint256 _value) public returns (bool) {
382         allowed[msg.sender][_spender] = _value;
383         emit Approval(msg.sender, _spender, _value);
384         return true;
385     }
386     
387     /**
388      * @dev balanceOf function gets the balance of the specified address.
389      * @param _owner The address to query the balance of.
390      * @return An uint256 representing the token balance of the passed address.
391      */
392     function balanceOf(address _owner) public view returns (uint256 balance) {
393         return balances[_owner];
394     }
395         
396     /**
397      * @dev allowance function checks the amount of tokens allowed by an owner for a spender to spend.
398      * @param _owner address is the address which owns the spendable funds.
399      * @param _spender address is the address which will spend the owned funds.
400      * @return A uint256 specifying the amount of tokens which are still available for the spender.
401      */
402     function allowance(address _owner, address _spender) public view returns (uint256) {
403         return allowed[_owner][_spender];
404     }
405     
406     /**
407      * @dev totalSupply function returns the total supply of tokens.
408      */
409     function totalSupply() public view returns (uint256) {
410         return TOTAL_SUPPLY;
411     }
412     
413     /** 
414      * @dev decimals function returns the decimal units of the token. 
415      */
416     function decimals() public view returns (uint8) {
417         return DECIMALS;
418     }
419             
420     /** 
421      * @dev symbol function returns the symbol ticker of the token. 
422      */
423     function symbol() public view returns (string) {
424         return SYMBOL;
425     }
426     
427     /** 
428      * @dev name function returns the name of the token. 
429      */
430     function name() public view returns (string) {
431         return NAME;
432     }
433 }