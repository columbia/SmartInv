1 pragma solidity ^0.4.16;
2 contract Ownable {
3     address public owner;
4 
5 
6     modifier onlyOwner() {
7         if (msg.sender == owner)
8             _;
9         else {
10             revert();
11         }
12     }
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal constant returns (uint256) {
27     assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Pausable is Ownable {
46   event Pause();
47   event Unpause();
48 
49   bool public paused = false;
50 
51 
52   /**
53    *  modifier to allow actions only when the contract IS paused
54    */
55   modifier whenNotPaused() {
56     require(!paused);
57     _;
58   }
59 
60   /**
61    *  modifier to allow actions only when the contract IS NOT paused
62    */
63   modifier whenPaused() {
64     require(paused);
65     _;
66   }
67 
68   /**
69    *  called by the owner to pause, triggers stopped state
70    */
71   function pause() public onlyOwner whenNotPaused {
72     paused = true;
73     Pause();
74   }
75 
76   /**
77    *  called by the owner to unpause, returns to normal state
78    */
79   function unpause() public  onlyOwner whenPaused {
80     paused = false;
81     Unpause();
82   }
83 }
84 contract Mortal is Ownable {
85 
86     function kill()  public {
87         if (msg.sender == owner) {
88             selfdestruct(owner);
89         }
90     }
91 }
92 contract UserTokensControl is Ownable{
93     uint256 isUserAbleToTransferTime = 1579174400000;//control for transfer Thu Jan 16 2020 
94     modifier isUserAbleToTransferCheck(uint balance,uint _value) {
95       if(msg.sender == 0x3b06AC092339D382050C892aD035b5F140B7C628){
96          if(now<isUserAbleToTransferTime){
97              revert();
98          }
99          _;
100       }else {
101           _;
102       }
103     }
104    
105 }
106 
107 /**
108  * @title ERC20Basic
109  * @dev Simpler version of ERC20 interface
110  */
111 contract ERC20Basic {
112   uint256 public totalSupply;
113   function balanceOf(address who) public constant returns (uint256);
114   function transfer(address to, uint256 value) public returns (bool);
115   event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 
118 /**
119  * @title Basic token
120  * @dev Basic version of StandardToken, with no allowances.
121  */
122 contract BasicToken is ERC20Basic, Pausable , UserTokensControl{
123   using SafeMath for uint256;
124  
125   mapping(address => uint256) balances;
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public whenNotPaused isUserAbleToTransferCheck(balances[msg.sender],_value) returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139    // Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public constant returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 /**
154  * @title ERC20 interface
155  * @dev see https://github.com/ethereum/EIPs/issues/20
156  */
157 contract ERC20 is ERC20Basic {
158   function allowance(address owner, address spender) public constant returns (uint256);
159   function transferFrom(address from, address to, uint256 value) public returns (bool);
160   function approve(address spender, uint256 value) public returns (bool);
161   event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
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
175   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused isUserAbleToTransferCheck(balances[msg.sender],_value) returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183   //  Transfer(_from, _to, _value);
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
209   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * approve should be called when allowed[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    */
219   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
220     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
226     uint oldValue = allowed[msg.sender][_spender];
227     if (_subtractedValue > oldValue) {
228       allowed[msg.sender][_spender] = 0;
229     } else {
230       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
231     }
232     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236 }
237 
238 
239 contract Potentium is StandardToken, Mortal {
240     string public constant name = "POTENTIAM";
241     uint public constant decimals = 18;
242     string public constant symbol = "PTM";
243     address companyReserve;
244     uint saleEndDate;
245     uint public amountRaisedInWei;
246     uint public priceOfToken=1041600000000000;//0.0010416 ETH
247     address[] allParticipants;
248     uint tokenSales=0;
249      mapping(address => uint256)public  balancesHold;
250     event TokenHold( address indexed to, uint256 value);
251     mapping (address => bool) isParticipated;
252     uint public icoStartDate;
253     uint public icoWeek1Bonus = 10;
254     uint public icoWeek2Bonus = 7;
255     uint public icoWeek3Bonus = 5;
256     uint public icoWeek4Bonus = 3;
257     function Potentium()  public {
258       totalSupply=100000000 *(10**decimals);  // 
259        owner = msg.sender;
260        companyReserve=0x3b06AC092339D382050C892aD035b5F140B7C628;
261        balances[msg.sender] = 75000000 * (10**decimals);
262        balances[companyReserve] = 25000000 * (10**decimals); //given by potentieum
263       saleEndDate =  1520554400000;  //8 March 2018
264     }
265 
266     
267     function() payable whenNotPaused public {
268         require(msg.sender !=0x0);
269         require(now<=saleEndDate);
270         require(msg.value >=40000000000000000); //minimum 0.04 eth
271         require(tokenSales<=(60000000 * (10 ** decimals)));
272         uint256 tokens = (msg.value * (10 ** decimals)) / priceOfToken;
273         uint256 bonusTokens = 0;
274         if(now <1513555100000){
275             bonusTokens = (tokens * 40) /100; //17 dec 2017 % bonus presale
276         }else if(now <1514760800000) {
277             bonusTokens = (tokens * 35) /100; //31 dec 2017 % bonus
278         }else if(now <1515369600000){
279             bonusTokens = (tokens * 30) /100; //jan 7 2018 bonus
280         }else if(now <1515974400000){
281             bonusTokens = (tokens * 25) /100; //jan 14 2018 bonus
282         }
283         else if(now <1516578400000){
284             bonusTokens = (tokens * 20) /100; //jan 21 2018 bonus
285         }else if(now <1517011400000){
286               bonusTokens = (tokens * 15) /100; //jan 26 2018 bonus
287         }
288         else if(now>=icoStartDate){
289             if(now <= (icoStartDate + 1 * 7 days) ){
290                 bonusTokens = (tokens * icoWeek1Bonus) /100; 
291             }
292             else if(now <= (icoStartDate + 2 * 7 days) ){
293                 bonusTokens = (tokens * icoWeek2Bonus) /100; 
294             }
295            else if(now <= (icoStartDate + 3 * 7 days) ){
296                 bonusTokens = (tokens * icoWeek3Bonus) /100; 
297             }
298            else if(now <= (icoStartDate + 4 * 7 days) ){
299                 bonusTokens = (tokens * icoWeek4Bonus) /100; 
300             }
301             
302         }
303         tokens +=bonusTokens;
304         tokenSales+=tokens;
305         balancesHold[msg.sender]+=tokens;
306         amountRaisedInWei = amountRaisedInWei + msg.value;
307         if(!isParticipated[msg.sender]){
308             allParticipants.push(msg.sender);
309         }
310         TokenHold(msg.sender,tokens);//event to dispactc as token hold successfully
311     }
312     function distributeTokensAfterIcoByOwner()public onlyOwner{
313         for (uint i = 0; i < allParticipants.length; i++) {
314                     address userAdder=allParticipants[i];
315                     var tokens = balancesHold[userAdder];
316                     if(tokens>0){
317                     allowed[owner][userAdder] += tokens;
318                     transferFrom(owner, userAdder, tokens);
319                     balancesHold[userAdder] = 0;
320                      }
321                  }
322     }
323     /**
324    * @dev called by the owner to extend deadline relative to last deadLine Time,
325    * to accept ether and transfer tokens
326    */
327    function extendSaleEndDate(uint saleEndTimeInMIllis)public onlyOwner{
328        saleEndDate = saleEndTimeInMIllis;
329    }
330    function setIcoStartDate(uint icoStartDateInMilli)public onlyOwner{
331        icoStartDate = icoStartDateInMilli;
332    }
333     function setICOWeek1Bonus(uint bonus)public onlyOwner{
334        icoWeek1Bonus= bonus;
335    }
336      function setICOWeek2Bonus(uint bonus)public onlyOwner{
337        icoWeek2Bonus= bonus;
338    }
339      function setICOWeek3Bonus(uint bonus)public onlyOwner{
340        icoWeek3Bonus= bonus;
341    }
342      function setICOWeek4Bonus(uint bonus)public onlyOwner{
343        icoWeek4Bonus= bonus;
344    }
345    function rateForOnePTM(uint rateInWei) public onlyOwner{
346        priceOfToken = rateInWei;
347    }
348 
349    //function ext
350    /**
351      * to get total particpants count
352      */
353     function getCountPartipants() public constant returns (uint count){
354        return allParticipants.length;
355     }
356     function getParticipantIndexAddress(uint index)public constant returns (address){
357         return allParticipants[index];
358     }
359     /**
360     * Transfer entire balance to any account (by owner and admin only)
361     **/
362     function transferFundToAccount(address _accountByOwner) public onlyOwner {
363         require(amountRaisedInWei > 0);
364         _accountByOwner.transfer(amountRaisedInWei);
365         amountRaisedInWei = 0;
366     }
367 
368     function resetTokenOfAddress(address _userAdd)public onlyOwner {
369       uint256 userBal=  balances[_userAdd] ;
370       balances[_userAdd] = 0;
371       balances[owner] +=userBal;
372     }
373     /**
374     * Transfer part of balance to any account (by owner and admin only)
375     **/
376     function transferLimitedFundToAccount(address _accountByOwner, uint256 balanceToTransfer) public onlyOwner   {
377         require(amountRaisedInWei > balanceToTransfer);
378         _accountByOwner.transfer(balanceToTransfer);
379         amountRaisedInWei -= balanceToTransfer;
380     }
381 }