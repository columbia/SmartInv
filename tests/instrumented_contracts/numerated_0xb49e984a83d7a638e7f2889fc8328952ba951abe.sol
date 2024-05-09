1 library SafeMath {
2   function mul(uint256 a, uint256 b) constant public returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) constant public returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) constant public returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) constant public returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Ownable {
28   address public owner;
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   function Ownable() public {
36     owner = msg.sender;
37   }
38 
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     if(msg.sender == owner){
45       _;
46     }
47     else{
48       revert();
49     }
50   }
51 
52 }
53 contract ERC20Basic {
54   uint256 public totalSupply;
55   function balanceOf(address who) constant public returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) constant public returns (uint256);
62   function transferFrom(address from, address to, uint256 value) public returns (bool);
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances. 
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73   using SafeMath for uint128;
74 
75   mapping(address => uint256) balances;
76 
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89   /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of. 
92   * @return An uint256 representing the amount owned by the passed address.
93   */
94   function balanceOf(address _owner) constant public returns (uint256 balance) {
95     return balances[_owner];
96   }
97 
98 }
99 
100 
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) allowed;
104 
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amout of tokens to be transfered
111    */
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     var _allowance = allowed[_from][msg.sender];
114 
115     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
116     // require (_value <= _allowance);
117 
118     balances[_to] = balances[_to].add(_value);
119     balances[_from] = balances[_from].sub(_value);
120     allowed[_from][msg.sender] = _allowance.sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    * @param _spender The address which will spend the funds.
128    * @param _value The amount of tokens to be spent.
129    */
130   function approve(address _spender, uint256 _value) public returns (bool) {
131 
132     // To change the approve amount you first have to reduce the addresses`
133     //  allowance to zero by calling `approve(_spender, 0)` if it is not
134     //  already 0 to mitigate the race condition described here:
135     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
137 
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifing the amount of tokens still avaible for the spender.
148    */
149   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
150     return allowed[_owner][_spender];
151   }
152 
153 }
154 
155 
156 contract MintableToken is StandardToken, Ownable {
157   event Mint(address indexed to, uint256 amount);
158   event MintFinished();
159 
160   bool public mintingFinished = false;
161 
162 
163   modifier canMint() {
164     if(!mintingFinished){
165       _;
166     }
167     else{
168       revert();
169     }
170   }
171 
172   /**
173    * @dev Function to mint tokens
174    * @param _to The address that will recieve the minted tokens.
175    * @param _amount The amount of tokens to mint.
176    * @return A boolean that indicates if the operation was successful.
177    */
178   function mint(address _to, uint256 _amount) canMint internal returns (bool) {
179     totalSupply = totalSupply.add(_amount);
180     balances[_to] = balances[_to].add(_amount);
181     Mint(_to, _amount);
182     Transfer(address(0),_to,_amount);
183     return true;
184   }
185 
186   /**
187    * @dev Function to stop minting new tokens.
188    * @return True if the operation was successful.
189    */
190   function finishMinting() onlyOwner public returns (bool) {
191     mintingFinished = true;
192     MintFinished();
193     return true;
194   }
195 }
196 
197 
198 contract MON is MintableToken{
199     
200     event BuyStatus(uint256 status);
201     struct Buy{
202         uint128 amountOfEth;
203         uint128 stage;
204     }
205     
206     struct StageData{
207         uint128 stageTime;
208         uint64 stageSum;
209         uint64 stagePrice;
210     }
211     
212 	string public constant name = "MillionCoin";
213 	string public constant symbol = "MON";
214 	uint256 public constant DECIMALS = 8;
215 	uint256 public constant decimals = 8;
216 	address public beneficiary ;
217     uint256 private alreadyRunned 	= 0;
218     uint256 internal _now =0;
219     uint256 public stageIndex = 0;
220     StageData[] public stageDataStore;
221     uint256 public period = 3600*24; //1 day
222     uint256 public start = 0;
223     uint256 public sumMultiplayer = 100000;
224     mapping(address => Buy) public stageBuys;
225  
226  modifier runOnce(uint256 bit){
227      if((alreadyRunned & bit)==0){
228         alreadyRunned = alreadyRunned | bit;   
229          _;   
230      }
231      else{
232          revert();
233      }
234  }
235  
236  
237  function MON(address _benef,uint256 _start,uint256 _sumMul,uint256 _period) public{
238      beneficiary = _benef;
239      if(_start==0){
240          start = GetNow();
241      }
242      else{
243          start = _start;
244      }
245      if(_period!=0){
246          period = _period;
247      }
248      if(_sumMul!=0){
249          sumMultiplayer = _sumMul;
250      }
251      stageDataStore.push(StageData(uint128(start+period*151),uint64(50*sumMultiplayer),uint64(5000)));
252      stageDataStore.push(StageData(uint128(start+period*243),uint64(60*sumMultiplayer),uint64(3000)));
253      stageDataStore.push(StageData(uint128(start+period*334),uint64(50*sumMultiplayer),uint64(1666)));
254      stageDataStore.push(StageData(uint128(start+period*455),uint64(60*sumMultiplayer),uint64(1500)));
255      stageDataStore.push(StageData(uint128(start+period*548),uint64(65*sumMultiplayer),uint64(1444)));
256      stageDataStore.push(StageData(uint128(start+period*641),uint64(55*sumMultiplayer),uint64(1000)));
257      
258  }
259  
260  
261  function GetMaxStageEthAmount() public constant returns(uint256){
262      StageData memory currS = stageDataStore[stageIndex];
263      uint256 retVal = currS.stageSum;
264      retVal = retVal*(10**18);
265      retVal = retVal/currS.stagePrice;
266      retVal = retVal.sub(this.balance);
267      return retVal;
268  }
269  
270  
271  function () public payable {
272      uint256  status = 0;
273      status = 0;
274      bool transferToBenef = false;
275      uint256  amountOfEthBeforeBuy = 0;
276      uint256  stageMaxEthAmount = 0;
277      uint128 _n = uint128(GetNow());
278      StageData memory currS = stageDataStore[stageIndex] ;
279      if(_n<start){
280          revert();
281      }
282      if(this.balance <msg.value){
283         amountOfEthBeforeBuy =0 ;
284      }
285      else{
286         amountOfEthBeforeBuy = this.balance - msg.value;
287      }
288      stageMaxEthAmount = uint256(currS.stageSum)*(10**18)/currS.stagePrice;
289          uint256 amountToReturn =0;
290          uint256 amountToMint =0;
291          Buy memory b = stageBuys[msg.sender];
292      if(currS.stageTime<_n && amountOfEthBeforeBuy<stageMaxEthAmount){
293          status = 1;
294          //current stage is unsuccessful money send in transaction should be returned plus 
295          // all money spent in current round 
296          amountToReturn = msg.value;
297          if(b.stage==stageIndex){
298              amountToReturn = amountToReturn.add(b.amountOfEth);
299              if(b.amountOfEth>0){
300                 burn(msg.sender,b.amountOfEth.mul(currS.stagePrice));
301              }
302          }
303          b.amountOfEth=0;
304          mintingFinished = true;
305          msg.sender.transfer(amountToReturn);
306      }
307      else{
308          status = 2;
309          
310          if(b.stage!=stageIndex){
311              b.stage = uint128(stageIndex);
312              b.amountOfEth = 0;
313              status = status*10+3;
314          }
315          
316          if(currS.stageTime>_n &&  this.balance < stageMaxEthAmount){
317             //nothing special normal buy 
318              b.amountOfEth = uint128(b.amountOfEth.add(uint128(msg.value)));
319             amountToMint = msg.value*currS.stagePrice;
320             status = status*10+4;
321             mintCoins(msg.sender,amountToMint);
322          }else{
323              if( this.balance >=stageMaxEthAmount){
324                  //we exceed stage limit
325                 status = status*10+5;
326                  transferToBenef = true;
327                 amountToMint = (stageMaxEthAmount - amountOfEthBeforeBuy)*(currS.stagePrice);
328                 mintCoins(msg.sender,amountToMint);
329                 stageIndex = stageIndex+1;
330                 beneficiary.transfer(stageMaxEthAmount);
331                 stageMaxEthAmount =  GetMaxStageEthAmount();
332                 if(stageIndex<5 && stageMaxEthAmount>this.balance){
333                  //   status = status*10+7;
334                     //buys for rest of eth tokens in new prices
335                     currS = stageDataStore[stageIndex] ;
336                     amountToMint = this.balance*(currS.stagePrice);
337                     b.stage = uint128(stageIndex);
338                     b.amountOfEth =uint128(this.balance);
339                     mintCoins(msg.sender,amountToMint);
340                 }
341                 else{
342                     status = status*10+8;
343                     //returns rest of money if during buy hardcap is reached
344                     amountToReturn = this.balance;
345                     msg.sender.transfer(amountToReturn);
346                 }
347              }else{
348                 status = status*10+6;
349            //     revert() ;// not implemented, should not happend
350              }
351          }
352          
353      }
354      stageBuys[msg.sender] = b;
355      BuyStatus(status);
356  }
357  
358  
359  function GetBalance() public constant returns(uint256){
360      return this.balance;
361  }
362 
363   uint256 public constant maxTokenSupply = (10**(18-DECIMALS))*(10**6)*34 ;  
364   
365   function burn(address _from, uint256 _amount) private returns (bool){
366       _amount = _amount.div(10**10);
367       balances[_from] = balances[_from].sub(_amount);
368       totalSupply = totalSupply.sub(_amount);
369       Transfer(_from,address(0),_amount);
370   }
371   
372   function GetStats()public constant returns (uint256,uint256,uint256,uint256){
373       uint256 timeToEnd = 0;
374       uint256 round =0;
375       StageData memory _s = stageDataStore[stageIndex];
376       if(GetNow()>=start){
377         round = stageIndex+1;
378         if(_s.stageTime>GetNow())
379         {
380             timeToEnd = _s.stageTime-GetNow();
381         }
382         else{
383             return(0,0,0,0);
384         }
385       }
386       else{
387         timeToEnd = start-GetNow();
388       }
389       return(timeToEnd,
390        round,
391        _s.stageSum*1000/_s.stagePrice,
392        GetMaxStageEthAmount().div(10**15));
393   }
394   
395   function mintCoins(address _to, uint256 _amount)  canMint internal returns (bool) {
396       
397     _amount = _amount.div(10**10);
398   	if(totalSupply.add(_amount)<maxTokenSupply){
399   	  super.mint(_to,_amount.mul(75).div(100));
400   	  super.mint(address(beneficiary),_amount.mul(25).div(100));
401   	  
402   	  return true;
403   	}
404   	else{
405   		return false; 
406   	}
407   	
408   	return true;
409   }
410   
411   
412  function GetNow() public constant returns(uint256){
413     return now; 
414  }
415   
416   
417 }