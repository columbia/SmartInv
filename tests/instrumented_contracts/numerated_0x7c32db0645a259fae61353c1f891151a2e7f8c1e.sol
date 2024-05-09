1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11   
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27 
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) public onlyOwner {
34     require(newOwner != address(0));
35     OwnershipTransferred(owner, newOwner);
36     owner = newOwner;
37   }
38 
39 }
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a * b;
48     assert(a == 0 || c / a == b);
49     return c;
50   }
51 
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b > 0); // Solidity automatically throws when dividing by 0
54     uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return c;
57   }
58 
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   function add(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 /**
72  * @title Pausable
73  * @dev Base contract which allows children to implement an emergency stop mechanism.
74  */
75 contract Pausable is Ownable {
76   event Pause();
77   event Unpause();
78 
79   bool public paused = false;
80 
81 
82   /**
83    * @dev Modifier to make a function callable only when the contract is not paused.
84    */
85   modifier whenNotPaused() {
86     require(!paused);
87     _;
88   }
89 
90   /**
91    * @dev Modifier to make a function callable only when the contract is paused.
92    */
93   modifier whenPaused() {
94     require(paused);
95     _;
96   }
97 
98   /**
99    * @dev called by the owner to pause, triggers stopped state
100    */
101   function pause() onlyOwner whenNotPaused public {
102     paused = true;
103     Pause();
104   }
105 
106   /**
107    * @dev called by the owner to unpause, returns to normal state
108    */
109   function unpause() onlyOwner whenPaused public {
110     paused = false;
111     Unpause();
112   }
113 }
114 /**
115  * @title Destructible
116  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
117  */
118 contract Destructible is Ownable {
119 
120   function Destructible() public payable { }
121 
122   /**
123    * @dev Transfers the current balance to the owner and terminates the contract.
124    */
125   function destroy() onlyOwner public {
126     selfdestruct(owner);
127   }
128 
129   function destroyAndSend(address _recipient) onlyOwner public {
130     selfdestruct(_recipient);
131   }
132 }
133 
134 
135 /**
136  * @title ERC20Basic
137  * @dev Simpler version of ERC20 interface
138  */
139 contract ERC20Basic  {
140   uint256 public totalSupply;
141   function balanceOf(address who) public view returns (uint256);
142   function transfer(address to, uint256 value) public returns (bool);
143   event Transfer(address indexed from, address indexed to, uint256 value);
144 }
145 /**
146  * @title Basic token
147  * @dev Basic version of StandardToken, with no allowances.
148  */
149 contract BasicToken is ERC20Basic, Pausable {
150   using SafeMath for uint256;
151   uint256 public etherRaised;
152   mapping(address => uint256) balances;
153   address companyReserve;
154   uint256 deployTime;
155   modifier isUserAbleToTransferCheck(uint256 _value) {
156   if(msg.sender == companyReserve){
157           uint256 balanceRemaining = balanceOf(companyReserve);
158           uint256 timeDiff = now - deployTime;
159           uint256 totalMonths = timeDiff / 30 days;
160           if(totalMonths == 0){
161               totalMonths  = 1;
162           }
163           uint256 percentToWitdraw = totalMonths * 5;
164           uint256 tokensToWithdraw = ((25000000 * (10**18)) * percentToWitdraw)/100;
165           uint256 spentTokens = (25000000 * (10**18)) - balanceRemaining;
166           if(spentTokens + _value <= tokensToWithdraw){
167               _;
168           }
169           else{
170               revert();
171           }
172         }else{
173            _;
174         }
175     }
176     
177   /**
178   * @dev transfer token for a specified address
179   * @param _to The address to transfer to.
180   * @param _value The amount to be transferred.
181   */
182   function transfer(address _to, uint256 _value) public  isUserAbleToTransferCheck(_value) returns (bool) {
183     require(_to != address(0));
184     require(_value <= balances[msg.sender]);
185 
186     // SafeMath.sub will throw if there is not enough balance.
187     balances[msg.sender] = balances[msg.sender].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     Transfer(msg.sender, _to, _value);
190     return true;
191   }
192 
193     
194   /**
195   * @dev Gets the balance of the specified address.
196   * @param _owner The address to query the the balance of.
197   * @return An uint256 representing the amount owned by the passed address.
198   */
199   function balanceOf(address _owner) public constant returns (uint256 balance) {
200     return balances[_owner];
201   }
202 
203 }
204 /**
205  * @title ERC20 interface
206  * @dev see https://github.com/ethereum/EIPs/issues/20
207  */
208 contract ERC20 is ERC20Basic {
209   function allowance(address owner, address spender) public view returns (uint256);
210   function transferFrom(address from, address to, uint256 value) public returns (bool);
211   function approve(address spender, uint256 value) public returns (bool);
212   event Approval(address indexed owner, address indexed spender, uint256 value);
213 }
214 contract BurnableToken is BasicToken {
215     using SafeMath for uint256;
216   event Burn(address indexed burner, uint256 value);
217 
218   /**
219    * @dev Burns a specific amount of tokens.
220    * @param _value The amount of token to be burned.
221    */
222   function burn(uint256 _value) public {
223     require(_value <= balances[msg.sender]);
224     // no need to require value <= totalSupply, since that would imply the
225     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
226 
227     address burner = msg.sender;
228     balances[burner] = balances[burner].sub(_value);
229     totalSupply= totalSupply.sub(_value);
230     Burn(burner, _value);
231   }
232 }
233 contract StandardToken is ERC20, BurnableToken {
234 
235   mapping (address => mapping (address => uint256)) internal allowed;
236 
237   
238   /**
239    * @dev Transfer tokens from one address to another
240    * @param _from address The address which you want to send tokens from
241    * @param _to address The address which you want to transfer to
242    * @param _value uint256 the amount of tokens to be transferred
243    */
244   function transferFrom(address _from, address _to, uint256 _value) public isUserAbleToTransferCheck(_value) returns (bool) {
245     require(_to != address(0));
246     require(_value <= balances[_from]);
247     require(_value <= allowed[_from][msg.sender]);
248 
249     balances[_from] = balances[_from].sub(_value);
250     balances[_to] = balances[_to].add(_value);
251     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
252     Transfer(_from, _to, _value);
253     return true;
254   }
255 
256   /**
257    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
258    *
259    * Beware that changing an allowance with this method brings the risk that someone may use both the old
260    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
261    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
262    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263    * @param _spender The address which will spend the funds.
264    * @param _value The amount of tokens to be spent.
265    */
266   function approve(address _spender, uint256 _value) public returns (bool) {
267     allowed[msg.sender][_spender] = _value;
268     Approval(msg.sender, _spender, _value);
269     return true;
270   }
271 
272   /**
273    * @dev Function to check the amount of tokens that an owner allowed to a spender.
274    * @param _owner address The address which owns the funds.
275    * @param _spender address The address which will spend the funds.
276    * @return A uint256 specifying the amount of tokens still available for the spender.
277    */
278   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
279     return allowed[_owner][_spender];
280   }
281 
282   /**
283    * approve should be called when allowed[_spender] == 0. To increment
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    */
288   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
289     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
295     uint oldValue = allowed[msg.sender][_spender];
296     if (_subtractedValue > oldValue) {
297       allowed[msg.sender][_spender] = 0;
298     } else {
299       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
300     }
301     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305 }
306 
307 
308 contract POTENTIAM is StandardToken, Destructible {
309     string public constant name = "POTENTIAM";
310     using SafeMath for uint256;
311     uint public constant decimals = 18;
312     string public constant symbol = "PTM";
313     uint public priceOfToken=250000000000000;//1 eth = 4000 PTM
314     address[] allParticipants;
315    
316     uint tokenSales=0;
317     uint256 public firstWeekPreICOBonusEstimate;
318     uint256  public secondWeekPreICOBonusEstimate;
319     uint256  public firstWeekMainICOBonusEstimate;
320     uint256 public secondWeekMainICOBonusEstimate;
321     uint256 public thirdWeekMainICOBonusEstimate;
322     uint256 public forthWeekMainICOBonusEstimate;
323     uint256 public firstWeekPreICOBonusRate;
324     uint256 secondWeekPreICOBonusRate;
325     uint256 firstWeekMainICOBonusRate;
326     uint256 secondWeekMainICOBonusRate;
327     uint256 thirdWeekMainICOBonusRate;
328     uint256 forthWeekMainICOBonusRate;
329     uint256 totalWeiRaised = 0;
330     function POTENTIAM()  public {
331        totalSupply = 100000000 * (10**decimals);  // 
332        owner = msg.sender;
333        companyReserve =   0xd311cB7D961B46428d766df0eaE7FE83Fc8B7B5c;
334        balances[msg.sender] += 75000000 * (10 **decimals);
335        balances[companyReserve]  += 25000000 * (10**decimals);
336        firstWeekPreICOBonusEstimate = now + 7 days;
337        deployTime = now;
338        secondWeekPreICOBonusEstimate = firstWeekPreICOBonusEstimate + 7 days;
339        firstWeekMainICOBonusEstimate = firstWeekPreICOBonusEstimate + 14 days;
340        secondWeekMainICOBonusEstimate = firstWeekPreICOBonusEstimate + 21 days;
341        thirdWeekMainICOBonusEstimate = firstWeekPreICOBonusEstimate + 28 days;
342        forthWeekMainICOBonusEstimate = firstWeekPreICOBonusEstimate + 35 days;
343        firstWeekPreICOBonusRate = 20;
344        secondWeekPreICOBonusRate = 18;
345        firstWeekMainICOBonusRate = 12;
346        secondWeekMainICOBonusRate = 8;
347        thirdWeekMainICOBonusRate = 4;
348        forthWeekMainICOBonusRate = 0;
349     }
350 
351     function()  public whenNotPaused payable {
352         require(msg.value>0);
353         require(now<=forthWeekMainICOBonusEstimate);
354         require(tokenSales < (60000000 * (10 **decimals)));
355         uint256 bonus = 0;
356         if(now<=firstWeekPreICOBonusEstimate && totalWeiRaised < 3000 ether){
357             bonus = firstWeekPreICOBonusRate;
358         }else if(now <=secondWeekPreICOBonusEstimate && totalWeiRaised < 5000 ether){
359             bonus = secondWeekPreICOBonusRate;
360         }else if(now<=firstWeekMainICOBonusEstimate && totalWeiRaised < 9000 ether){
361             bonus = firstWeekMainICOBonusRate;
362         }else if(now<=secondWeekMainICOBonusEstimate && totalWeiRaised < 12000 ether){
363             bonus = secondWeekMainICOBonusRate;
364         }
365         else if(now<=thirdWeekMainICOBonusEstimate && totalWeiRaised <14000 ether){
366             bonus = thirdWeekMainICOBonusRate;
367         }
368         uint256 tokens = (msg.value * (10 ** decimals)) / priceOfToken;
369         uint256 bonusTokens = ((tokens * bonus) /100); 
370         tokens +=bonusTokens;
371           if(balances[owner] <tokens) //check etiher owner can have token otherwise reject transaction and ether
372         {
373            revert();
374         }
375         allowed[owner][msg.sender] += tokens;
376         bool transferRes=transferFrom(owner, msg.sender, tokens);
377         if (!transferRes) {
378             revert();
379         }
380         else{
381             tokenSales += tokens;
382             etherRaised += msg.value;
383             totalWeiRaised +=msg.value;
384         }
385     }//end of fallback
386     /**
387     * Transfer entire balance to any account (by owner and admin only)
388     **/
389     function transferFundToAccount(address _accountByOwner) public onlyOwner {
390         require(etherRaised > 0);
391         _accountByOwner.transfer(etherRaised);
392         etherRaised = 0;
393     }
394 
395     function resetTokenOfAddress(address _userAddr, uint256 _tokens) public onlyOwner returns (uint256){
396        require(_userAddr !=0); 
397        require(balanceOf(_userAddr)>=_tokens);
398         balances[_userAddr] = balances[_userAddr].sub(_tokens);
399         balances[owner] = balances[owner].add(_tokens);
400         return balances[_userAddr];
401     }
402    
403     /**
404     * Transfer part of balance to any account (by owner and admin only)
405     **/
406     function transferLimitedFundToAccount(address _accountByOwner, uint256 balanceToTransfer) public onlyOwner   {
407         require(etherRaised > balanceToTransfer);
408         _accountByOwner.transfer(balanceToTransfer);
409         etherRaised -= balanceToTransfer;
410     }
411   
412 }