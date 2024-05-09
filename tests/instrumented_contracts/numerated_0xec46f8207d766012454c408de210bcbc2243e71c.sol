1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4 
5   address public owner = msg.sender;
6   address private newOwner = address(0);
7 
8   modifier onlyOwner() {
9     require(msg.sender == owner);
10     _;
11   }
12 
13   function transferOwnership(address _newOwner) public onlyOwner {
14     require(_newOwner != address(0));      
15     newOwner = _newOwner;
16   }
17 
18   function acceptOwnership() public {
19     require(msg.sender != address(0));
20     require(msg.sender == newOwner);
21 
22     owner = newOwner;
23     newOwner = address(0);
24   }
25 
26 }
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33 
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39 }
40 
41 
42 /**
43  * @title ERC20 interface
44  * @dev see https://github.com/ethereum/EIPs/issues/20
45  */
46 contract ERC20 {
47 
48   /**
49    * the total token supply.
50    */
51   uint256 public totalSupply;
52 
53   /**
54    * @param _owner The address from which the balance will be retrieved
55    * @return The balance
56    */
57   function balanceOf(address _owner) public constant returns (uint256 balance);
58 
59   /**
60    * @notice send `_value` token to `_to` from `msg.sender`
61    * @param _to The address of the recipient
62    * @param _value The amount of token to be transferred
63    * @return Whether the transfer was successful or not
64    */
65   function transfer(address _to, uint256 _value) public returns (bool success);
66 
67   /**
68    * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
69    * @param _from The address of the sender
70    * @param _to The address of the recipient
71    * @param _value The amount of token to be transferred
72    * @return Whether the transfer was successful or not
73    */
74   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
75 
76   /**
77    * @notice `msg.sender` approves `_spender` to spend `_value` tokens
78    * @param _spender The address of the account able to transfer the tokens
79    * @param _value The amount of tokens to be approved for transfer
80    * @return Whether the approval was successful or not
81    */
82   function approve(address _spender, uint256 _value) public returns (bool success);
83 
84   /**
85    * @param _owner The address of the account owning tokens
86    * @param _spender The address of the account able to transfer the tokens
87    * @return Amount of remaining tokens allowed to spent
88    */
89   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
90 
91   /**
92    * MUST trigger when tokens are transferred, including zero value transfers.
93    */
94   event Transfer(address indexed _from, address indexed _to, uint256 _value);
95 
96   /**
97    * MUST trigger on any successful call to approve(address _spender, uint256 _value)
98    */
99   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 
101 }
102 
103 /**
104  * @title Standard ERC20 token
105  *
106  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
107  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/StandardToken.sol
108  */
109 contract ERC20Token is ERC20 {
110 
111   using SafeMath for uint256;
112 
113   mapping (address => uint256) balances;
114   
115   mapping (address => mapping (address => uint256)) allowed;
116 
117   /**
118    * @dev Gets the balance of the specified address.
119    * @param _owner The address to query the the balance of.
120    * @return An uint256 representing the amount owned by the passed address.
121    */
122   function balanceOf(address _owner) public constant returns (uint256 balance) {
123     return balances[_owner];
124   }
125   
126   /**
127    * @dev transfer token for a specified address
128    * @param _to The address to transfer to.
129    * @param _value The amount to be transferred.
130    */
131   function transfer(address _to, uint256 _value) public returns (bool) {
132     require(_to != address(0));
133 
134     // SafeMath.sub will throw if there is not enough balance.
135     balances[msg.sender] = balances[msg.sender].sub(_value);
136     balances[_to] +=_value;
137     Transfer(msg.sender, _to, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amount of tokens to be transferred
146    */
147   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149     require(_value > 0);
150 
151     balances[_from] = balances[_from].sub(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     
154     balances[_to] += _value;
155     
156     Transfer(_from, _to, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
167     return allowed[_owner][_spender];
168   }
169 
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    *
173    * Beware that changing an allowance with this method brings the risk that someone may use both the old
174    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177    * @param _spender The address which will spend the funds.
178    * @param _value The amount of tokens to be spent.
179    */
180   function approve(address _spender, uint256 _value) public returns (bool) {
181     allowed[msg.sender][_spender] = _value;
182     Approval(msg.sender, _spender, _value);
183     return true;
184   }
185 
186 }
187 
188 contract NitroToken is ERC20Token, Ownable {
189     
190   string public constant name = "Nitro";
191   string public constant symbol = "NOX";
192   uint8 public constant decimals = 18;
193 
194   function NitroToken(uint256 _totalSupply) public {
195     totalSupply = _totalSupply;
196     balances[owner] = _totalSupply;
197     Transfer(address(0), owner, _totalSupply);
198   }
199   
200   function acceptOwnership() public {
201     address oldOwner = owner;
202     super.acceptOwnership();
203     balances[owner] = balances[oldOwner];
204     balances[oldOwner] = 0;
205     Transfer(oldOwner, owner, balances[owner]);
206   }
207 
208 }
209 
210 contract Declaration {
211   
212   enum TokenTypes { crowdsale, interactive, icandy, consultant, team, reserve }
213   mapping(uint => uint256) public balances;
214   
215   uint256 public preSaleStart = 1511020800;
216   uint256 public preSaleEnd = 1511452800;
217     
218   uint256 public saleStart = 1512057600;
219   uint256 public saleStartFirstDayEnd = saleStart + 1 days;
220   uint256 public saleStartSecondDayEnd = saleStart + 3 days;
221   uint256 public saleEnd = 1514304000;
222   
223   uint256 public teamFrozenTokens = 4800000 * 1 ether;
224   uint256 public teamUnfreezeDate = saleEnd + 182 days;
225 
226   uint256 public presaleMinValue = 5 ether;
227  
228   uint256 public preSaleRate = 1040;
229   uint256 public saleRate = 800;
230   uint256 public saleRateFirstDay = 1000;
231   uint256 public saleRateSecondDay = 920;
232 
233   NitroToken public token;
234 
235   function Declaration() public {
236     balances[uint8(TokenTypes.crowdsale)] = 60000000 * 1 ether;
237     balances[uint8(TokenTypes.interactive)] = 6000000 * 1 ether;
238     balances[uint8(TokenTypes.icandy)] = 3000000 * 1 ether;
239     balances[uint8(TokenTypes.consultant)] = 1200000 * 1 ether;
240     balances[uint8(TokenTypes.team)] = 7200000 * 1 ether;
241     balances[uint8(TokenTypes.reserve)] = 42600000 * 1 ether;
242     token = new NitroToken(120000000 * 1 ether);
243   }
244   
245   modifier withinPeriod(){
246     require(isPresale() || isSale());
247     _;
248   }
249   
250   function isPresale() public constant returns (bool){
251     return now>=preSaleStart && now<=preSaleEnd;
252   }
253 
254   function isSale()  public constant returns (bool){
255     return now >= saleStart && now <= saleEnd;
256   }
257   
258   function rate() public constant returns (uint256) {
259     if (isPresale()) {
260       return preSaleRate;
261     } else if (now>=saleStart && now<=(saleStartFirstDayEnd)){
262       return saleRateFirstDay;
263     } else if (now>(saleStartFirstDayEnd) && now<=(saleStartSecondDayEnd)){
264       return saleRateSecondDay;
265     }
266     return saleRate;
267   }
268   
269 }
270 
271 contract Crowdsale is Declaration, Ownable{
272     
273     using SafeMath for uint256;
274 
275     address public wallet;
276     
277     uint256 public weiLimit = 6 ether;
278     uint256 public satLimit = 30000000;
279 
280     mapping(address => bool) users;
281     mapping(address => uint256) weiOwed;
282     mapping(address => uint256) satOwed;
283     mapping(address => uint256) weiTokensOwed;
284     mapping(address => uint256) satTokensOwed;
285     
286     uint256 public weiRaised;
287     uint256 public satRaised;
288 
289     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
290     
291     function Crowdsale(address _wallet) Declaration public {
292         wallet = _wallet;    
293     }
294     
295     function () public payable {
296         buy();
297     }
298 
299     function weiFreeze(address _addr, uint256 _value) internal {
300         uint256 amount = _value * rate();
301         balances[0] = balances[0].sub(amount);
302         weiOwed[_addr] += _value;
303         weiTokensOwed[_addr] += amount;
304     }
305 
306     function weiTransfer(address _addr, uint256 _value) internal {
307         uint256 amount = _value * rate();
308         balances[0] = balances[0].sub(amount);
309         token.transfer(_addr, amount);
310         weiRaised += _value;
311         TokenPurchase(_addr, _addr, _value, amount);
312     }
313 
314     function buy() withinPeriod public payable returns (bool){
315         if (isPresale()) {
316           require(msg.value >= presaleMinValue);
317         }else{
318           require(msg.value > 0);
319         }
320         if (weiOwed[msg.sender]>0) {
321           weiFreeze(msg.sender, msg.value);
322         } else if (msg.value>weiLimit && !users[msg.sender]) {
323           weiFreeze(msg.sender, msg.value.sub(weiLimit));
324           weiTransfer(msg.sender, weiLimit);
325         } else {
326           weiTransfer(msg.sender, msg.value);
327         }
328         return true;
329     }
330     
331     function _verify(address _addr) onlyOwner internal {
332         users[_addr] = true;
333         
334         weiRaised += weiOwed[_addr];
335         satRaised += satOwed[_addr];
336 
337         token.transfer(_addr, weiTokensOwed[_addr] + satTokensOwed[_addr]);
338         
339         TokenPurchase(_addr, _addr, 0, weiTokensOwed[_addr] + satTokensOwed[_addr]);
340 
341         weiOwed[_addr]=0;
342         satOwed[_addr]=0;
343         weiTokensOwed[_addr]=0;
344         satTokensOwed[_addr]=0;
345     }
346 
347     function verify(address _addr) public returns(bool){
348         _verify(_addr);
349         return true;
350     }
351     
352     function isVerified(address _addr) public constant returns(bool){
353       return users[_addr];
354     }
355     
356     function getWeiTokensOwed(address _addr) public constant returns (uint256){
357         return weiTokensOwed[_addr];
358     }
359 
360     function getSatTokensOwed(address _addr) public constant returns (uint256){
361         return satTokensOwed[_addr];
362     }
363 
364     function owedTokens(address _addr) public constant returns (uint256){
365         return weiTokensOwed[_addr] + satTokensOwed[_addr];
366     }
367     
368     function getSatOwed(address _addr) public constant returns (uint256){
369         return satOwed[_addr];
370     }
371     
372     function getWeiOwed(address _addr) public constant returns (uint256){
373         return weiOwed[_addr];
374     }
375     
376     function satFreeze(address _addr, uint256 _wei, uint _sat) private {
377         uint256 amount = _wei * rate();
378         balances[0] = balances[0].sub(amount);
379         
380         satOwed[_addr] += _sat;
381         satTokensOwed[_addr] += amount;    
382     }
383 
384     function satTransfer(address _addr, uint256 _wei, uint _sat) private {
385         uint256 amount = _wei * rate();
386         balances[0] = balances[0].sub(amount);
387         
388         token.transfer(_addr, amount);
389         TokenPurchase(_addr, _addr, _wei, amount);
390         satRaised += _sat;
391     }
392 
393     function buyForBtc(
394         address _addr,
395         uint256 _sat,
396         uint256 _satOwed,
397         uint256 _wei,
398         uint256 _weiOwed
399     ) onlyOwner withinPeriod public {
400         require(_addr != address(0));
401         
402         satFreeze(_addr, _weiOwed, _satOwed);
403         satTransfer(_addr, _wei, _sat);
404     }
405     
406     function refundWei(address _addr, uint256 _amount) onlyOwner public returns (bool){
407         _addr.transfer(_amount);
408         balances[0] += weiTokensOwed[_addr];
409         weiTokensOwed[_addr] = 0;
410         weiOwed[_addr] = 0;
411         return true;
412     }
413   
414     function refundedSat(address _addr) onlyOwner public returns (bool){
415         balances[0] += satTokensOwed[_addr];
416         satTokensOwed[_addr] = 0;
417         satOwed[_addr] = 0;
418         return true;
419     }
420     
421     function sendOtherTokens(
422         uint8 _index,
423         address _addr,
424         uint256 _amount
425     ) onlyOwner public {
426         require(_addr!=address(0));
427 
428         if (_index==uint8(TokenTypes.team) && now<teamUnfreezeDate) {
429             uint256 limit = balances[uint8(TokenTypes.team)].sub(teamFrozenTokens);
430             require(_amount<=limit);
431         }
432         
433         token.transfer(_addr, _amount);
434         balances[_index] = balances[_index].sub(_amount);
435         TokenPurchase(owner, _addr, 0, _amount);
436     }
437     
438     function rsrvToSale(uint256 _amount) onlyOwner public {
439         balances[uint8(TokenTypes.reserve)] = balances[uint8(TokenTypes.reserve)].sub(_amount);
440         balances[0] += _amount;
441     }
442     
443     function forwardFunds(uint256 amount) onlyOwner public {
444         wallet.transfer(amount);
445     }
446     
447     function setTokenOwner(address _addr) onlyOwner public {
448         token.transferOwnership(_addr);
449     }
450 
451 }