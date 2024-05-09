1 contract ERC20Basic {
2   uint256 public totalSupply;
3   function balanceOf(address who) constant returns (uint256);
4   function transfer(address to, uint256 value) returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 
8 contract BasicToken is ERC20Basic {
9   using SafeMath for uint256;
10 
11   mapping(address => uint256) balances;
12 
13   /**
14   * @dev transfer token for a specified address
15   * @param _to The address to transfer to.
16   * @param _value The amount to be transferred.
17   */
18   function transfer(address _to, uint256 _value) returns (bool) {
19     require(_to != address(0));
20 
21     // SafeMath.sub will throw if there is not enough balance.
22     balances[msg.sender] = balances[msg.sender].sub(_value);
23     balances[_to] = balances[_to].add(_value);
24     Transfer(msg.sender, _to, _value);
25     return true;
26   }
27 
28   /**
29   * @dev Gets the balance of the specified address.
30   * @param _owner The address to query the the balance of.
31   * @return An uint256 representing the amount owned by the passed address.
32   */
33   function balanceOf(address _owner) constant returns (uint256 balance) {
34     return balances[_owner];
35   }
36 
37 }
38 
39 contract ERC20 is ERC20Basic {
40   function allowance(address owner, address spender) constant returns (uint256);
41   function transferFrom(address from, address to, uint256 value) returns (bool);
42   function approve(address spender, uint256 value) returns (bool);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract Ownable {
47   address public owner;
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original owner of the contract to the sender
52    * account.
53    */
54   function Ownable() {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) onlyOwner {
73     require(newOwner != address(0));
74     owner = newOwner;
75   }
76 
77 }
78 
79 library SafeMath {
80   function mul(uint256 a, uint256 b) internal returns (uint256) {
81     uint256 c = a * b;
82     assert(a == 0 || c / a == b);
83     return c;
84   }
85 
86   function div(uint256 a, uint256 b) internal returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92 
93   function sub(uint256 a, uint256 b) internal returns (uint256) {
94     assert(b <= a);
95     return a - b;
96   }
97 
98   function add(uint256 a, uint256 b) internal returns (uint256) {
99     uint256 c = a + b;
100     assert(c >= a);
101     return c;
102   }
103 
104   function minimum( uint a, uint b) internal returns ( uint result) {
105     if ( a <= b ) {
106       result = a;
107     }
108     else {
109       result = b;
110     }
111   }
112 
113 }
114 
115 contract StandardToken is ERC20, BasicToken {
116 
117   mapping (address => mapping (address => uint256)) allowed;
118 
119 
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amount of tokens to be transferred
125    */
126   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
127     require(_to != address(0));
128 
129     var _allowance = allowed[_from][msg.sender];
130 
131     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
132     // require (_value <= _allowance);
133 
134     balances[_from] = balances[_from].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     allowed[_from][msg.sender] = _allowance.sub(_value);
137     Transfer(_from, _to, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143    * @param _spender The address which will spend the funds.
144    * @param _value The amount of tokens to be spent.
145    */
146    
147    function approve(address _spender, uint256 _value) returns (bool) {
148 
149     // To change the approve amount you first have to reduce the addresses`
150     //  allowance to zero by calling approve(_spender, 0) if it is not
151     //  already 0 to mitigate the race condition described here:
152     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
154 
155     allowed[msg.sender][_spender] = _value;
156     Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
167     return allowed[_owner][_spender];
168   }
169 
170   /**
171    * approve should be called when allowed[_spender] == 0. To increment
172    * allowed value is better to use this function to avoid 2 calls (and wait until
173    * the first transaction is mined)
174    * From MonolithDAO Token.sol
175    */
176   function increaseApproval (address _spender, uint _addedValue)
177     returns (bool success) {
178     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
179     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 
183   function decreaseApproval (address _spender, uint _subtractedValue)
184     returns (bool success) {
185     uint oldValue = allowed[msg.sender][_spender];
186     if (_subtractedValue > oldValue) {
187       allowed[msg.sender][_spender] = 0;
188     } else {
189       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
190     }
191     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194 
195 }
196 
197 contract OZTGToken is StandardToken, Ownable {
198 
199  /* Overriding some ERC20 variables */
200  string public constant name      = "OZTGToken";
201  string public constant symbol    = "OZTG";
202  uint256 public constant decimals = 18;
203 
204  uint256 public constant MAX_NUM_OZTG_TOKENS    =  730000000 * 10 ** decimals;
205 
206  // Freeze duration for Advisors accounts
207  uint256 public constant START_ICO_TIMESTAMP   = 1526565600;  // ICO starts at 17.05.2018 @ 2PM UTC
208  int public constant DEFROST_MONTH_IN_MINUTES = 43200; // month in minutes
209  int public constant DEFROST_MONTHS = 3;
210 
211  /*
212   modalités de sorties des advisors investisseurs ou des earlybirds j’opte pour
213   - un Freeze à 6 mois puis au bout du 6ème mois
214   - possible de sortir du capital de 50% du montant investi
215   - puis par la suite 5% tous les mois ce qui nous donnera une sortie effective au bout de 10 mois et au total ça fera donc 16 mois
216  */
217 
218  uint public constant DEFROST_FACTOR = 20;
219 
220  // Fields that can be changed by functions
221  address[] public vIcedBalances;
222  mapping (address => uint256) public icedBalances_frosted;
223     mapping (address => uint256) public icedBalances_defrosted;
224 
225  // Variable usefull for verifying that the assignedSupply matches that totalSupply
226  uint256 public assignedSupply;
227  //Boolean to allow or not the initial assignement of token (batch)
228  bool public batchAssignStopped = false;
229  bool public stopDefrost = false;
230 
231  uint oneTokenWeiPrice;
232  address defroster;
233 
234  function OZTGToken() {
235   owner                 = msg.sender;
236   assignedSupply = 0;
237 
238   // mint all tokens
239   totalSupply = MAX_NUM_OZTG_TOKENS;
240         balances[msg.sender] = MAX_NUM_OZTG_TOKENS;
241         Transfer(address(0x0), msg.sender, MAX_NUM_OZTG_TOKENS);
242  }
243 
244  function setDefroster(address addr) onlyOwner {
245   defroster = addr;
246  }
247 
248   modifier onlyDefrosterOrOwner() {
249         require(msg.sender == defroster || msg.sender == owner);
250         _;
251     }
252 
253  /**
254    * @dev Transfer tokens in batches (of adresses)
255    * @param _vaddr address The address which you want to send tokens from
256    * @param _vamounts address The address which you want to transfer to
257    */
258   function batchAssignTokens(address[] _vaddr, uint[] _vamounts, uint[] _vDefrostClass )
259   
260   onlyOwner {
261 
262    require ( batchAssignStopped == false );
263    require ( _vaddr.length == _vamounts.length && _vaddr.length == _vDefrostClass.length);
264    //Looping into input arrays to assign target amount to each given address
265    for (uint index=0; index<_vaddr.length; index++) {
266 
267     address toAddress = _vaddr[index];
268     uint amount = SafeMath.mul(_vamounts[index], 10 ** decimals);
269     uint defrostClass = _vDefrostClass[index]; // 0=ico investor, 1=reserveandteam/advisors
270 
271     if (  defrostClass == 0 ) {
272      // investor account
273      transfer(toAddress, amount);
274      assignedSupply = SafeMath.add(assignedSupply, amount);
275     }
276     else if(defrostClass == 1){
277 
278      // Iced account. The balance is not affected here
279                     vIcedBalances.push(toAddress);
280                     icedBalances_frosted[toAddress] = amount;
281      icedBalances_defrosted[toAddress] = 0;
282      assignedSupply = SafeMath.add(assignedSupply, amount);
283     }
284    }
285  }
286 
287  function getBlockTimestamp() constant returns (uint256){
288   return now;
289  }
290 
291  function getAssignedSupply() constant returns (uint256){
292   return assignedSupply;
293  }
294 
295  function elapsedMonthsFromICOStart() constant returns (int elapsed) {
296   elapsed = (int(now-START_ICO_TIMESTAMP)/60)/DEFROST_MONTH_IN_MINUTES;
297  }
298 
299  function getDefrostFactor()constant returns (uint){
300   return DEFROST_FACTOR;
301  }
302 
303  function lagDefrost()constant returns (int){
304   return DEFROST_MONTHS;
305  }
306 
307  function canDefrost() constant returns (bool){
308   int numMonths = elapsedMonthsFromICOStart();
309   return  numMonths > DEFROST_MONTHS &&
310        uint(numMonths) <= SafeMath.add(uint(DEFROST_MONTHS),  DEFROST_FACTOR/2+1);
311  }
312 
313  function defrostTokens(uint fromIdx, uint toIdx) onlyDefrosterOrOwner {
314 
315   require(now>START_ICO_TIMESTAMP);
316   require(stopDefrost == false);
317   require(fromIdx>=0 && toIdx<=vIcedBalances.length);
318   if(fromIdx==0 && toIdx==0){
319    fromIdx = 0;
320    toIdx = vIcedBalances.length;
321   }
322 
323   int monthsElapsedFromFirstDefrost = elapsedMonthsFromICOStart() - DEFROST_MONTHS;
324   require(monthsElapsedFromFirstDefrost>0);
325   uint monthsIndex = uint(monthsElapsedFromFirstDefrost);
326   //require(monthsIndex<=DEFROST_FACTOR);
327   require(canDefrost() == true);
328 
329   /*
330    if monthsIndex == 1 => defrost 50%
331    else if monthsIndex <= 10  defrost 5%
332   */
333 
334   // Looping into the iced accounts
335         for (uint index = fromIdx; index < toIdx; index++) {
336 
337    address currentAddress = vIcedBalances[index];
338             uint256 amountTotal = SafeMath.add(icedBalances_frosted[currentAddress], icedBalances_defrosted[currentAddress]);
339             uint256 targetDeFrosted = 0;
340    uint256 fivePercAmount = SafeMath.div(amountTotal, DEFROST_FACTOR);
341    if(monthsIndex==1){
342     targetDeFrosted = SafeMath.mul(fivePercAmount, 10);  //  10 times 5% = 50%
343    }else{
344     targetDeFrosted = SafeMath.mul(fivePercAmount, 10) + SafeMath.div(SafeMath.mul(monthsIndex-1, amountTotal), DEFROST_FACTOR);
345    }
346             uint256 amountToRelease = SafeMath.sub(targetDeFrosted, icedBalances_defrosted[currentAddress]);
347 
348       if (amountToRelease > 0 && targetDeFrosted > 0) {
349                 icedBalances_frosted[currentAddress] = SafeMath.sub(icedBalances_frosted[currentAddress], amountToRelease);
350                 icedBalances_defrosted[currentAddress] = SafeMath.add(icedBalances_defrosted[currentAddress], amountToRelease);
351     transfer(currentAddress, amountToRelease);
352          }
353         }
354  }
355 
356  function getStartIcoTimestamp() constant returns (uint) {
357   return START_ICO_TIMESTAMP;
358  }
359 
360  function stopBatchAssign() onlyOwner {
361    require ( batchAssignStopped == false);
362    batchAssignStopped = true;
363  }
364 
365  function getAddressBalance(address addr) constant returns (uint256 balance)  {
366    balance = balances[addr];
367  }
368 
369  function getAddressAndBalance(address addr) constant returns (address _address, uint256 _amount)  {
370    _address = addr;
371    _amount = balances[addr];
372  }
373 
374  function setStopDefrost() onlyOwner {
375    stopDefrost = true;
376  }
377 
378  function killContract() onlyOwner {
379   selfdestruct(owner);
380  }
381 
382 
383 }