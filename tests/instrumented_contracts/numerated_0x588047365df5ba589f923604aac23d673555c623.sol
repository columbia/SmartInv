1 pragma solidity ^0.4.19;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
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
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: zeppelin-solidity/contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: zeppelin-solidity/contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 // File: contracts/NaviToken.sol
245 
246 contract NaviToken is StandardToken, Ownable {
247     event AssignmentStopped();
248     event Frosted(address indexed to, uint256 amount, uint256 defrostClass);
249     event Defrosted(address indexed to, uint256 amount, uint256 defrostClass);
250 
251 	using SafeMath for uint256;
252 
253     /* Overriding some ERC20 variables */
254     string public constant name      = "NaviToken";
255     string public constant symbol    = "NAVI";
256     uint8 public constant decimals   = 18;
257 
258     uint256 public constant MAX_NUM_NAVITOKENS    = 1000000000 * 10 ** uint256(decimals);
259     uint256 public constant START_ICO_TIMESTAMP   = 1519912800;  // TODO: line to uncomment for the PROD before the main net deployment
260     //uint256 public START_ICO_TIMESTAMP; // TODO: !!! line to remove before the main net deployment (not constant for testing and overwritten in the constructor)
261 
262     uint256 public constant MONTH_IN_MINUTES = 43200; // month in minutes  (1month = 43200 min)
263     uint256 public constant DEFROST_AFTER_MONTHS = 6;
264 
265     uint256 public constant DEFROST_FACTOR_TEAMANDADV = 30;
266 
267     enum DefrostClass {Contributor, ReserveAndTeam, Advisor}
268 
269     // Fields that can be changed by functions
270     address[] icedBalancesReserveAndTeam;
271     mapping (address => uint256) mapIcedBalancesReserveAndTeamFrosted;
272     mapping (address => uint256) mapIcedBalancesReserveAndTeamDefrosted;
273 
274     address[] icedBalancesAdvisors;
275     mapping (address => uint256) mapIcedBalancesAdvisors;
276 
277     //Boolean to allow or not the initial assignement of token (batch)
278     bool public batchAssignStopped = false;
279 
280     modifier canAssign() {
281         require(!batchAssignStopped);
282         require(elapsedMonthsFromICOStart() < 2);
283         _;
284     }
285 
286     function NaviToken() public {
287         // for test only: set START_ICO to contract creation timestamp
288         //START_ICO_TIMESTAMP = now; // TODO: line to remove before the main net deployment
289     }
290 
291     /**
292     * @dev Transfer tokens in batches (of addresses)
293     * @param _addr address The address which you want to send tokens from
294     * @param _amounts address The address which you want to transfer to
295     */
296     function batchAssignTokens(address[] _addr, uint256[] _amounts, DefrostClass[] _defrostClass) public onlyOwner canAssign {
297         require(_addr.length == _amounts.length && _addr.length == _defrostClass.length);
298         //Looping into input arrays to assign target amount to each given address
299         for (uint256 index = 0; index < _addr.length; index++) {
300             address toAddress = _addr[index];
301             uint amount = _amounts[index];
302             DefrostClass defrostClass = _defrostClass[index]; // 0 = ico contributor, 1 = reserve and team , 2 = advisor
303 
304             totalSupply = totalSupply.add(amount);
305             require(totalSupply <= MAX_NUM_NAVITOKENS);
306 
307             if (defrostClass == DefrostClass.Contributor) {
308                 // contributor account
309                 balances[toAddress] = balances[toAddress].add(amount);
310                 Transfer(address(0), toAddress, amount);
311             } else if (defrostClass == DefrostClass.ReserveAndTeam) {
312                 // Iced account. The balance is not affected here
313                 icedBalancesReserveAndTeam.push(toAddress);
314                 mapIcedBalancesReserveAndTeamFrosted[toAddress] = mapIcedBalancesReserveAndTeamFrosted[toAddress].add(amount);
315                 Frosted(toAddress, amount, uint256(defrostClass));
316             } else if (defrostClass == DefrostClass.Advisor) {
317                 // advisors account: tokens to defrost
318                 icedBalancesAdvisors.push(toAddress);
319                 mapIcedBalancesAdvisors[toAddress] = mapIcedBalancesAdvisors[toAddress].add(amount);
320                 Frosted(toAddress, amount, uint256(defrostClass));
321             }
322         }
323     }
324 
325     function elapsedMonthsFromICOStart() view public returns (uint256) {
326        return (now <= START_ICO_TIMESTAMP) ? 0 : (now - START_ICO_TIMESTAMP) / 60 / MONTH_IN_MINUTES;
327     }
328 
329     function canDefrostReserveAndTeam() view public returns (bool) {
330         return elapsedMonthsFromICOStart() > DEFROST_AFTER_MONTHS;
331     }
332 
333     function defrostReserveAndTeamTokens() public {
334         require(canDefrostReserveAndTeam());
335 
336         uint256 monthsIndex = elapsedMonthsFromICOStart() - DEFROST_AFTER_MONTHS;
337 
338         if (monthsIndex > DEFROST_FACTOR_TEAMANDADV){
339             monthsIndex = DEFROST_FACTOR_TEAMANDADV;
340         }
341 
342         // Looping into the iced accounts
343         for (uint256 index = 0; index < icedBalancesReserveAndTeam.length; index++) {
344 
345             address currentAddress = icedBalancesReserveAndTeam[index];
346             uint256 amountTotal = mapIcedBalancesReserveAndTeamFrosted[currentAddress].add(mapIcedBalancesReserveAndTeamDefrosted[currentAddress]);
347             uint256 targetDefrosted = monthsIndex.mul(amountTotal).div(DEFROST_FACTOR_TEAMANDADV);
348             uint256 amountToRelease = targetDefrosted.sub(mapIcedBalancesReserveAndTeamDefrosted[currentAddress]);
349 
350             if (amountToRelease > 0) {
351                 mapIcedBalancesReserveAndTeamFrosted[currentAddress] = mapIcedBalancesReserveAndTeamFrosted[currentAddress].sub(amountToRelease);
352                 mapIcedBalancesReserveAndTeamDefrosted[currentAddress] = mapIcedBalancesReserveAndTeamDefrosted[currentAddress].add(amountToRelease);
353                 balances[currentAddress] = balances[currentAddress].add(amountToRelease);
354 
355                 Transfer(address(0), currentAddress, amountToRelease);
356                 Defrosted(currentAddress, amountToRelease, uint256(DefrostClass.ReserveAndTeam));
357             }
358         }
359     }
360 
361     function canDefrostAdvisors() view public returns (bool) {
362         return elapsedMonthsFromICOStart() >= DEFROST_AFTER_MONTHS;
363     }
364 
365     function defrostAdvisorsTokens() public {
366         require(canDefrostAdvisors());
367         for (uint256 index = 0; index < icedBalancesAdvisors.length; index++) {
368             address currentAddress = icedBalancesAdvisors[index];
369             uint256 amountToDefrost = mapIcedBalancesAdvisors[currentAddress];
370             if (amountToDefrost > 0) {
371                 balances[currentAddress] = balances[currentAddress].add(amountToDefrost);
372                 mapIcedBalancesAdvisors[currentAddress] = mapIcedBalancesAdvisors[currentAddress].sub(amountToDefrost);
373 
374                 Transfer(address(0), currentAddress, amountToDefrost);
375                 Defrosted(currentAddress, amountToDefrost, uint256(DefrostClass.Advisor));
376             }
377         }
378     }
379 
380     function stopBatchAssign() public onlyOwner canAssign {
381         batchAssignStopped = true;
382         AssignmentStopped();
383     }
384 
385     function() public payable {
386         revert();
387     }
388 }