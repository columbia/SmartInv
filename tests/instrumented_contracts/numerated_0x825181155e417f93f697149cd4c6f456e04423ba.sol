1 pragma solidity 0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49   function totalSupply() public view returns (uint256);
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 /**
56  * @title ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) public view returns (uint256);
61   function transferFrom(address from, address to, uint256 value) public returns (bool);
62   function approve(address spender, uint256 value) public returns (bool);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76     if (a == 0) {
77       return 0;
78     }
79     uint256 c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * @dev Integer division of two numbers, truncating the quotient.
86   */
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   /**
95   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   /**
103   * @dev Adds two numbers, throws on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256) {
106     uint256 c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) balances;
120 
121   uint256 totalSupply_;
122 
123   /**
124   * @dev total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[msg.sender]);
138 
139     // SafeMath.sub will throw if there is not enough balance.
140     balances[msg.sender] = balances[msg.sender].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     Transfer(msg.sender, _to, _value);
143     return true;
144   }
145 
146   /**
147   * @dev Gets the balance of the specified address.
148   * @param _owner The address to query the the balance of.
149   * @return An uint256 representing the amount owned by the passed address.
150   */
151   function balanceOf(address _owner) public view returns (uint256 balance) {
152     return balances[_owner];
153   }
154 
155 }
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) internal allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public view returns (uint256) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 /**
253  * @title SafeERC20
254  * @dev Wrappers around ERC20 operations that throw on failure.
255  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
256  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
257  */
258 library SafeERC20 {
259   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
260     assert(token.transfer(to, value));
261   }
262 
263   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
264     assert(token.transferFrom(from, to, value));
265   }
266 
267   function safeApprove(ERC20 token, address spender, uint256 value) internal {
268     assert(token.approve(spender, value));
269   }
270 }
271 
272 contract YUPTimelock is Ownable {
273     using SafeERC20 for StandardToken;
274     using SafeMath for uint256;
275     
276     /** Contract events **/
277     event IsLocked(uint256 _time);
278     event IsClaiming(uint256 _time);
279     event IsFinalized(uint256 _time);
280     event Claimed(address indexed _to, uint256 _value);
281     event ClaimedFutureUse(address indexed _to, uint256 _value);
282     
283     /** State variables **/
284     enum ContractState { Locked, Claiming, Finalized }
285     ContractState public state;
286     uint256 constant D160 = 0x0010000000000000000000000000000000000000000;
287     StandardToken public token;
288     mapping(address => uint256) public allocations;
289     mapping(address => bool) public claimed;                //indicates whether beneficiary has claimed tokens
290     uint256 public expectedAmount = 193991920 * (10**18);   //should hold 193,991,920 x 10^18 (43.59% of total supply)
291     uint256 public amountLocked;
292     uint256 public amountClaimed;
293     uint256 public releaseTime;     //investor claim starting time
294     uint256 public claimEndTime;    //investor claim expiration time
295     uint256 public fUseAmount;  //amount of tokens for future use
296     address fUseBeneficiary;    //address of future use tokens beneficiary
297     uint256 fUseReleaseTime;    //release time of locked future use tokens
298     
299     /** Modifiers **/
300     modifier isLocked() {
301         require(state == ContractState.Locked);
302         _;
303     }
304     
305     modifier isClaiming() {
306         require(state == ContractState.Claiming);
307         _;
308     }
309     
310     modifier isFinalized() {
311         require(state == ContractState.Finalized);
312         _;
313     }
314     
315     /** Constructor **/
316     function YUPTimelock(
317         uint256 _releaseTime,
318         uint256 _amountLocked,
319         address _fUseBeneficiary,
320         uint256 _fUseReleaseTime
321     ) public {
322         require(_releaseTime > now);
323         
324         releaseTime = _releaseTime;
325         amountLocked = _amountLocked;
326         fUseAmount = 84550000 * 10**18;     //84,550,000 tokens (with 18 decimals)
327         claimEndTime = now + 60*60*24*275;  //9 months (in seconds) from time of lock
328         fUseBeneficiary = _fUseBeneficiary;
329         fUseReleaseTime = _fUseReleaseTime;
330         
331         if (amountLocked != expectedAmount)
332             revert();
333     }
334     
335     /** Allows the owner to set the token contract address **/
336     function setTokenAddr(StandardToken tokAddr) public onlyOwner {
337         require(token == address(0x0)); //initialize only once
338         
339         token = tokAddr;
340         
341         state = ContractState.Locked; //switch contract to locked state
342         IsLocked(now);
343     }
344     
345     /** Retrieves individual investor token balance **/
346     function getUserBalance(address _owner) public view returns (uint256) {
347         if (claimed[_owner] == false && allocations[_owner] > 0)
348             return allocations[_owner];
349         else
350             return 0;
351     }
352     
353     /** Allows owner to initiate the claiming phase **/
354     function startClaim() public isLocked onlyOwner {
355         state = ContractState.Claiming;
356         IsClaiming(now);
357     }
358     
359     /** Allows owner to finalize contract (only after investor claimEnd time) **/
360     function finalize() public isClaiming onlyOwner {
361         require(now >= claimEndTime);
362         
363         state = ContractState.Finalized;
364         IsFinalized(now);
365     }
366     
367     /** Allows the owner to claim all unclaimed investor tokens **/
368     function ownerClaim() public isFinalized onlyOwner {
369         uint256 remaining = token.balanceOf(this);
370         amountClaimed = amountClaimed.add(remaining);
371         amountLocked = amountLocked.sub(remaining);
372         
373         token.safeTransfer(owner, remaining);
374         Claimed(owner, remaining);
375     }
376     
377     /** Facilitates the assignment of investor addresses and amounts (only before claiming phase starts) **/
378     function loadBalances(uint256[] data) public isLocked onlyOwner {
379         require(token != address(0x0));  //Fail if token is not set
380         
381         for (uint256 i = 0; i < data.length; i++) {
382             address addr = address(data[i] & (D160 - 1));
383             uint256 amount = data[i] / D160;
384             
385             allocations[addr] = amount;
386             claimed[addr] = false;
387         }
388     }
389     
390     /** Allows owner to claim future use tokens in favor of fUseBeneficiary account **/
391     function claimFutureUse() public onlyOwner {
392         require(now >= fUseReleaseTime);
393         
394         amountClaimed = amountClaimed.add(fUseAmount);
395         amountLocked = amountLocked.sub(fUseAmount);
396         
397         token.safeTransfer(fUseBeneficiary, fUseAmount);
398         ClaimedFutureUse(fUseBeneficiary, fUseAmount);
399     }
400     
401     /** Allows presale investors to claim tokens **/
402     function claim() external isClaiming {
403         require(token != address(0x0)); //Fail if token is not set
404         require(now >= releaseTime);
405         require(allocations[msg.sender] > 0);
406         
407         uint256 amount = allocations[msg.sender];
408         allocations[msg.sender] = 0;
409         claimed[msg.sender] = true;
410         amountClaimed = amountClaimed.add(amount);
411         amountLocked = amountLocked.sub(amount);
412         
413         token.safeTransfer(msg.sender, amount);
414         Claimed(msg.sender, amount);
415     }
416 }