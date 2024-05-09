1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   /**
16   * @dev transfer token for a specified address
17   * @param _to The address to transfer to.
18   * @param _value The amount to be transferred.
19   */
20   function transfer(address _to, uint256 _value) returns (bool) {
21     require(_to != address(0));
22 
23     // SafeMath.sub will throw if there is not enough balance.
24     balances[msg.sender] = balances[msg.sender].sub(_value);
25     balances[_to] = balances[_to].add(_value);
26     Transfer(msg.sender, _to, _value);
27     return true;
28   }
29 
30   /**
31   * @dev Gets the balance of the specified address.
32   * @param _owner The address to query the the balance of.
33   * @return An uint256 representing the amount owned by the passed address.
34   */
35   function balanceOf(address _owner) constant returns (uint256 balance) {
36     return balances[_owner];
37   }
38 
39 }
40 
41 contract ERC20 is ERC20Basic {
42   function allowance(address owner, address spender) constant returns (uint256);
43   function transferFrom(address from, address to, uint256 value) returns (bool);
44   function approve(address spender, uint256 value) returns (bool);
45   event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 contract Ownable {
49   address public owner;
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) onlyOwner {
75     require(newOwner != address(0));
76     owner = newOwner;
77   }
78 
79 }
80 
81 library SafeMath {
82   function mul(uint256 a, uint256 b) internal returns (uint256) {
83     uint256 c = a * b;
84     assert(a == 0 || c / a == b);
85     return c;
86   }
87 
88   function div(uint256 a, uint256 b) internal returns (uint256) {
89     // assert(b > 0); // Solidity automatically throws when dividing by 0
90     uint256 c = a / b;
91     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92     return c;
93   }
94 
95   function sub(uint256 a, uint256 b) internal returns (uint256) {
96     assert(b <= a);
97     return a - b;
98   }
99 
100   function add(uint256 a, uint256 b) internal returns (uint256) {
101     uint256 c = a + b;
102     assert(c >= a);
103     return c;
104   }
105 
106   function minimum( uint a, uint b) internal returns ( uint result) {
107     if ( a <= b ) {
108       result = a;
109     }
110     else {
111       result = b;
112     }
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
198 contract OZTToken is StandardToken, Ownable {
199 
200 	/* Overriding some ERC20 variables */
201 	string public constant name      = "OZTToken";
202 	string public constant symbol    = "OZT";
203 	uint256 public constant decimals = 18;
204 
205 	uint256 public constant MAX_NUM_OZT_TOKENS    =  730000000 * 10 ** decimals;
206 
207 	// Freeze duration for Advisors accounts
208 	uint256 public constant START_ICO_TIMESTAMP   = 1526565600;  // ICO starts at 17.05.2018 @ 2PM UTC
209 	int public constant DEFROST_MONTH_IN_MINUTES = 43200; // month in minutes
210 	int public constant DEFROST_MONTHS = 3;
211 
212 	/*
213 		modalités de sorties des advisors investisseurs ou des earlybirds j’opte pour
214 		- un Freeze à 6 mois puis au bout du 6ème mois
215 		- possible de sortir du capital de 50% du montant investi
216 		- puis par la suite 5% tous les mois ce qui nous donnera une sortie effective au bout de 10 mois et au total ça fera donc 16 mois
217 	*/
218 
219 	uint public constant DEFROST_FACTOR = 20;
220 
221 	// Fields that can be changed by functions
222 	address[] public vIcedBalances;
223 	mapping (address => uint256) public icedBalances_frosted;
224     mapping (address => uint256) public icedBalances_defrosted;
225 
226 	// Variable usefull for verifying that the assignedSupply matches that totalSupply
227 	uint256 public assignedSupply;
228 	//Boolean to allow or not the initial assignement of token (batch)
229 	bool public batchAssignStopped = false;
230 	bool public stopDefrost = false;
231 
232 	uint oneTokenWeiPrice;
233 	address defroster;
234 
235 	function OZTToken() {
236 		owner                	= msg.sender;
237 		assignedSupply = 0;
238 
239 		// mint all tokens
240 		totalSupply = MAX_NUM_OZT_TOKENS;
241         balances[msg.sender] = MAX_NUM_OZT_TOKENS;
242         Transfer(address(0x0), msg.sender, MAX_NUM_OZT_TOKENS);
243 	}
244 
245 	function setDefroster(address addr) onlyOwner {
246 		defroster = addr;
247 	}
248 
249  	modifier onlyDefrosterOrOwner() {
250         require(msg.sender == defroster || msg.sender == owner);
251         _;
252     }
253 
254 	/**
255    * @dev Transfer tokens in batches (of adresses)
256    * @param _vaddr address The address which you want to send tokens from
257    * @param _vamounts address The address which you want to transfer to
258    */
259   function batchAssignTokens(address[] _vaddr, uint[] _vamounts, uint[] _vDefrostClass ) onlyOwner {
260 
261 			require ( batchAssignStopped == false );
262 			require ( _vaddr.length == _vamounts.length && _vaddr.length == _vDefrostClass.length);
263 			//Looping into input arrays to assign target amount to each given address
264 			for (uint index=0; index<_vaddr.length; index++) {
265 
266 				address toAddress = _vaddr[index];
267 				uint amount = SafeMath.mul(_vamounts[index], 10 ** decimals);
268 				uint defrostClass = _vDefrostClass[index]; // 0=ico investor, 1=reserveandteam/advisors
269 
270 				if (  defrostClass == 0 ) {
271 					// investor account
272 					transfer(toAddress, amount);
273 					assignedSupply = SafeMath.add(assignedSupply, amount);
274 				}
275 				else if(defrostClass == 1){
276 
277 					// Iced account. The balance is not affected here
278                     vIcedBalances.push(toAddress);
279                     icedBalances_frosted[toAddress] = amount;
280 					icedBalances_defrosted[toAddress] = 0;
281 					assignedSupply = SafeMath.add(assignedSupply, amount);
282 				}
283 			}
284 	}
285 
286 	function getBlockTimestamp() constant returns (uint256){
287 		return now;
288 	}
289 
290 	function getAssignedSupply() constant returns (uint256){
291 		return assignedSupply;
292 	}
293 
294 	function elapsedMonthsFromICOStart() constant returns (int elapsed) {
295 		elapsed = (int(now-START_ICO_TIMESTAMP)/60)/DEFROST_MONTH_IN_MINUTES;
296 	}
297 
298 	function getDefrostFactor()constant returns (uint){
299 		return DEFROST_FACTOR;
300 	}
301 
302 	function lagDefrost()constant returns (int){
303 		return DEFROST_MONTHS;
304 	}
305 
306 	function canDefrost() constant returns (bool){
307 		int numMonths = elapsedMonthsFromICOStart();
308 		return  numMonths > DEFROST_MONTHS &&
309 							uint(numMonths) <= SafeMath.add(uint(DEFROST_MONTHS),  DEFROST_FACTOR/2+1);
310 	}
311 
312 	function defrostTokens(uint fromIdx, uint toIdx) onlyDefrosterOrOwner {
313 
314 		require(now>START_ICO_TIMESTAMP);
315 		require(stopDefrost == false);
316 		require(fromIdx>=0 && toIdx<=vIcedBalances.length);
317 		if(fromIdx==0 && toIdx==0){
318 			fromIdx = 0;
319 			toIdx = vIcedBalances.length;
320 		}
321 
322 		int monthsElapsedFromFirstDefrost = elapsedMonthsFromICOStart() - DEFROST_MONTHS;
323 		require(monthsElapsedFromFirstDefrost>0);
324 		uint monthsIndex = uint(monthsElapsedFromFirstDefrost);
325 		//require(monthsIndex<=DEFROST_FACTOR);
326 		require(canDefrost() == true);
327 
328 		/*
329 			if monthsIndex == 1 => defrost 50%
330 			else if monthsIndex <= 10  defrost 5%
331 		*/
332 
333 		// Looping into the iced accounts
334         for (uint index = fromIdx; index < toIdx; index++) {
335 
336 			address currentAddress = vIcedBalances[index];
337             uint256 amountTotal = SafeMath.add(icedBalances_frosted[currentAddress], icedBalances_defrosted[currentAddress]);
338             uint256 targetDeFrosted = 0;
339 			uint256 fivePercAmount = SafeMath.div(amountTotal, DEFROST_FACTOR);
340 			if(monthsIndex==1){
341 				targetDeFrosted = SafeMath.mul(fivePercAmount, 10);  //  10 times 5% = 50%
342 			}else{
343 				targetDeFrosted = SafeMath.mul(fivePercAmount, 10) + SafeMath.div(SafeMath.mul(monthsIndex-1, amountTotal), DEFROST_FACTOR);
344 			}
345             uint256 amountToRelease = SafeMath.sub(targetDeFrosted, icedBalances_defrosted[currentAddress]);
346 
347 		    if (amountToRelease > 0 && targetDeFrosted > 0) {
348                 icedBalances_frosted[currentAddress] = SafeMath.sub(icedBalances_frosted[currentAddress], amountToRelease);
349                 icedBalances_defrosted[currentAddress] = SafeMath.add(icedBalances_defrosted[currentAddress], amountToRelease);
350 				transfer(currentAddress, amountToRelease);
351 	        }
352         }
353 	}
354 
355 	function getStartIcoTimestamp() constant returns (uint) {
356 		return START_ICO_TIMESTAMP;
357 	}
358 
359 	function stopBatchAssign() onlyOwner {
360 			require ( batchAssignStopped == false);
361 			batchAssignStopped = true;
362 	}
363 
364 	function getAddressBalance(address addr) constant returns (uint256 balance)  {
365 			balance = balances[addr];
366 	}
367 
368 	function getAddressAndBalance(address addr) constant returns (address _address, uint256 _amount)  {
369 			_address = addr;
370 			_amount = balances[addr];
371 	}
372 
373 	function setStopDefrost() onlyOwner {
374 			stopDefrost = true;
375 	}
376 
377 	function killContract() onlyOwner {
378 		selfdestruct(owner);
379 	}
380 
381 
382 }