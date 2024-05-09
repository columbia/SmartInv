1 pragma solidity ^0.4.15;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) returns (bool);
13   function approve(address spender, uint256 value) returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18   address public owner;
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() {
26     owner = msg.sender;
27   }
28 
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) onlyOwner {
44     require(newOwner != address(0));
45     owner = newOwner;
46   }
47 
48 }
49 
50 library SafeMath {
51   function mul(uint256 a, uint256 b) internal returns (uint256) {
52     uint256 c = a * b;
53     assert(a == 0 || c / a == b);
54     return c;
55   }
56 
57   function div(uint256 a, uint256 b) internal returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64   function sub(uint256 a, uint256 b) internal returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   function add(uint256 a, uint256 b) internal returns (uint256) {
70     uint256 c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 
75   function minimum( uint a, uint b) internal returns ( uint result) {
76     if ( a <= b ) {
77       result = a;
78     }
79     else {
80       result = b;
81     }
82   }
83 
84 }
85 
86 contract BasicToken is ERC20Basic {
87   using SafeMath for uint256;
88 
89   mapping(address => uint256) balances;
90 
91   /**
92   * @dev transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint256 _value) returns (bool) {
97     require(_to != address(0));
98 
99     // SafeMath.sub will throw if there is not enough balance.
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) constant returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 contract StandardToken is ERC20, BasicToken {
118 
119   mapping (address => mapping (address => uint256)) allowed;
120 
121 
122   /**
123    * @dev Transfer tokens from one address to another
124    * @param _from address The address which you want to send tokens from
125    * @param _to address The address which you want to transfer to
126    * @param _value uint256 the amount of tokens to be transferred
127    */
128   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
129     require(_to != address(0));
130 
131     var _allowance = allowed[_from][msg.sender];
132 
133     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
134     // require (_value <= _allowance);
135 
136     balances[_from] = balances[_from].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     allowed[_from][msg.sender] = _allowance.sub(_value);
139     Transfer(_from, _to, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
145    * @param _spender The address which will spend the funds.
146    * @param _value The amount of tokens to be spent.
147    */
148   function approve(address _spender, uint256 _value) returns (bool) {
149 
150     // To change the approve amount you first have to reduce the addresses`
151     //  allowance to zero by calling `approve(_spender, 0)` if it is not
152     //  already 0 to mitigate the race condition described here:
153     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
155 
156     allowed[msg.sender][_spender] = _value;
157     Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Function to check the amount of tokens that an owner allowed to a spender.
163    * @param _owner address The address which owns the funds.
164    * @param _spender address The address which will spend the funds.
165    * @return A uint256 specifying the amount of tokens still available for the spender.
166    */
167   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
168     return allowed[_owner][_spender];
169   }
170 
171   /**
172    * approve should be called when allowed[_spender] == 0. To increment
173    * allowed value is better to use this function to avoid 2 calls (and wait until
174    * the first transaction is mined)
175    * From MonolithDAO Token.sol
176    */
177   function increaseApproval (address _spender, uint _addedValue)
178     returns (bool success) {
179     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181     return true;
182   }
183 
184   function decreaseApproval (address _spender, uint _subtractedValue)
185     returns (bool success) {
186     uint oldValue = allowed[msg.sender][_spender];
187     if (_subtractedValue > oldValue) {
188       allowed[msg.sender][_spender] = 0;
189     } else {
190       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191     }
192     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196 }
197 
198 contract DRTCoin is StandardToken, Ownable {
199     /* Overriding some ERC20 variables */
200     string public constant name = "DomRaiderToken";
201     string public constant symbol = "DRT";
202     uint256 public constant decimals = 8;
203 
204     /* DRT specific variables */
205     // Max amount of tokens minted - Exact value input with stretch goals and before deploying contract
206     uint256 public constant MAX_SUPPLY_OF_TOKEN = 1300000000 * 10 ** decimals;
207 
208     // Freeze duration for advisors accounts
209     uint public constant START_ICO_TIMESTAMP = 1507622400;
210     uint public constant DEFROST_PERIOD = 43200; // month in minutes  (1 month = 43200 min)
211     uint public constant DEFROST_MONTHLY_PERCENT_OWNER = 5; // 5% per month is automatically defrosted
212     uint public constant DEFROST_INITIAL_PERCENT_OWNER = 10; // 90% locked
213     uint public constant DEFROST_MONTHLY_PERCENT = 10; // 10% per month is automatically defrosted
214     uint public constant DEFROST_INITIAL_PERCENT = 20; // 80% locked
215 
216     // Fields that can be changed by functions
217     address[] icedBalances;
218     mapping (address => uint256) icedBalances_frosted;
219     mapping (address => uint256) icedBalances_defrosted;
220 
221     uint256 ownerFrosted;
222     uint256 ownerDefrosted;
223 
224     // Variable useful for verifying that the assignedSupply matches that totalSupply
225     uint256 public assignedSupply;
226     //Boolean to allow or not the initial assignment of token (batch)
227     bool public batchAssignStopped = false;
228 
229     /**
230      * @dev Constructor that gives msg.sender all of existing tokens.
231      */
232     function DRTCoin() {
233         owner = msg.sender;
234         uint256 amount = 545000000 * 10 ** decimals;
235         uint256 amount2assign = amount * DEFROST_INITIAL_PERCENT_OWNER / 100;
236         balances[owner] = amount2assign;
237         ownerDefrosted = amount2assign;
238         ownerFrosted = amount - amount2assign;
239         totalSupply = MAX_SUPPLY_OF_TOKEN;
240         assignedSupply = amount;
241     }
242 
243     /**
244      * @dev Transfer tokens in batches (of addresses)
245      * @param _vaddr address The address which you want to send tokens from
246      * @param _vamounts address The address which you want to transfer to
247      */
248     function batchAssignTokens(address[] _vaddr, uint[] _vamounts, bool[] _vIcedBalance) onlyOwner {
249         require(batchAssignStopped == false);
250         require(_vaddr.length == _vamounts.length);
251         //Looping into input arrays to assign target amount to each given address
252         for (uint index = 0; index < _vaddr.length; index++) {
253             address toAddress = _vaddr[index];
254             uint amount = _vamounts[index] * 10 ** decimals;
255             bool isIced = _vIcedBalance[index];
256             if (balances[toAddress] == 0) {
257                 // In case it's filled two times, it only increments once
258                 // Assigns the balance
259                 assignedSupply += amount;
260                 if (isIced == false) {
261                     // Normal account
262                     balances[toAddress] = amount;
263                 }
264                 else {
265                     // Iced account. The balance is not affected here
266                     icedBalances.push(toAddress);
267                     uint256 amount2assign = amount * DEFROST_INITIAL_PERCENT / 100;
268                     balances[toAddress] = amount2assign;
269                     icedBalances_defrosted[toAddress] = amount2assign;
270                     icedBalances_frosted[toAddress] = amount - amount2assign;
271                 }
272             }
273         }
274     }
275 
276     function canDefrost() onlyOwner constant returns (bool bCanDefrost){
277         bCanDefrost = now > START_ICO_TIMESTAMP;
278     }
279 
280     function getBlockTimestamp() constant returns (uint256){
281         return now;
282     }
283 
284 
285     /**
286      * @dev Defrost token (for advisors)
287      * Method called by the owner once per defrost period (1 month)
288      */
289     function defrostToken() onlyOwner {
290         require(now > START_ICO_TIMESTAMP);
291         // Looping into the iced accounts
292         for (uint index = 0; index < icedBalances.length; index++) {
293             address currentAddress = icedBalances[index];
294             uint256 amountTotal = icedBalances_frosted[currentAddress] + icedBalances_defrosted[currentAddress];
295             uint256 targetDeFrosted = (SafeMath.minimum(100, DEFROST_INITIAL_PERCENT + elapsedMonthsFromICOStart() * DEFROST_MONTHLY_PERCENT)) * amountTotal / 100;
296             uint256 amountToRelease = targetDeFrosted - icedBalances_defrosted[currentAddress];
297             if (amountToRelease > 0) {
298                 icedBalances_frosted[currentAddress] = icedBalances_frosted[currentAddress] - amountToRelease;
299                 icedBalances_defrosted[currentAddress] = icedBalances_defrosted[currentAddress] + amountToRelease;
300                 balances[currentAddress] = balances[currentAddress] + amountToRelease;
301             }
302         }
303 
304     }
305     /**
306      * Defrost for the owner of the contract
307      */
308     function defrostOwner() onlyOwner {
309         if (now < START_ICO_TIMESTAMP) {
310             return;
311         }
312         uint256 amountTotal = ownerFrosted + ownerDefrosted;
313         uint256 targetDeFrosted = (SafeMath.minimum(100, DEFROST_INITIAL_PERCENT_OWNER + elapsedMonthsFromICOStart() * DEFROST_MONTHLY_PERCENT_OWNER)) * amountTotal / 100;
314         uint256 amountToRelease = targetDeFrosted - ownerDefrosted;
315         if (amountToRelease > 0) {
316             ownerFrosted = ownerFrosted - amountToRelease;
317             ownerDefrosted = ownerDefrosted + amountToRelease;
318             balances[owner] = balances[owner] + amountToRelease;
319         }
320     }
321 
322     function elapsedMonthsFromICOStart() constant returns (uint elapsed) {
323         elapsed = ((now - START_ICO_TIMESTAMP) / 60) / DEFROST_PERIOD;
324     }
325 
326     function stopBatchAssign() onlyOwner {
327         require(batchAssignStopped == false);
328         batchAssignStopped = true;
329     }
330 
331     function getAddressBalance(address addr) constant returns (uint256 balance)  {
332         balance = balances[addr];
333     }
334 
335     function getAddressAndBalance(address addr) constant returns (address _address, uint256 _amount)  {
336         _address = addr;
337         _amount = balances[addr];
338     }
339 
340     function getIcedAddresses() constant returns (address[] vaddr)  {
341         vaddr = icedBalances;
342     }
343 
344     function getIcedInfos(address addr) constant returns (address icedaddr, uint256 balance, uint256 frosted, uint256 defrosted)  {
345         icedaddr = addr;
346         balance = balances[addr];
347         frosted = icedBalances_frosted[addr];
348         defrosted = icedBalances_defrosted[addr];
349     }
350 
351     function getOwnerInfos() constant returns (address owneraddr, uint256 balance, uint256 frosted, uint256 defrosted)  {
352         owneraddr = owner;
353         balance = balances[owneraddr];
354         frosted = ownerFrosted;
355         defrosted = ownerDefrosted;
356     }
357 
358 }