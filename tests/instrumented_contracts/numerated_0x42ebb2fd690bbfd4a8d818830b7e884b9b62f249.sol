1 pragma solidity ^0.4.18;
2 
3 contract AbstractTRMBalances {
4     mapping(address => bool) public oldBalances;
5 }
6 
7 
8 /**
9  * @title ERC20Basic
10  * @dev Simpler version of ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/179
12  */
13 contract ERC20Basic {
14   uint256 public totalSupply;
15   function balanceOf(address who) constant returns (uint256);
16   function transfer(address to, uint256 value) returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) constant returns (uint256);
26   function transferFrom(address from, address to, uint256 value) returns (bool);
27   function approve(address spender, uint256 value) returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36     
37   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
38     uint256 c = a * b;
39     assert(a == 0 || c / a == b);
40     return c;
41   }
42 
43   function div(uint256 a, uint256 b) internal constant returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint256 a, uint256 b) internal constant returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60   
61 }
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances. 
66  */
67 contract BasicToken is ERC20Basic {
68     
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   /**
74   * @dev transfer token for a specified address
75   * @param _to The address to transfer to.
76   * @param _value The amount to be transferred.
77   */
78   function transfer(address _to, uint256 _value) returns (bool) {
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of. 
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) constant returns (uint256 balance) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * @dev https://github.com/ethereum/EIPs/issues/20
101  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) allowed;
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amout of tokens to be transfered
112    */
113   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
114     var _allowance = allowed[_from][msg.sender];
115 
116     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
117     // require (_value <= _allowance);
118 
119     balances[_to] = balances[_to].add(_value);
120     balances[_from] = balances[_from].sub(_value);
121     allowed[_from][msg.sender] = _allowance.sub(_value);
122     Transfer(_from, _to, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    * @param _spender The address which will spend the funds.
129    * @param _value The amount of tokens to be spent.
130    */
131   function approve(address _spender, uint256 _value) returns (bool) {
132 
133     // To change the approve amount you first have to reduce the addresses`
134     //  allowance to zero by calling `approve(_spender, 0)` if it is not
135     //  already 0 to mitigate the race condition described here:
136     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
138 
139     allowed[msg.sender][_spender] = _value;
140     Approval(msg.sender, _spender, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param _owner address The address which owns the funds.
147    * @param _spender address The address which will spend the funds.
148    * @return A uint256 specifing the amount of tokens still available for the spender.
149    */
150   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
151     return allowed[_owner][_spender];
152   }
153 
154 }
155 
156 /**
157  * @title Ownable
158  * @dev The Ownable contract has an owner address, and provides basic authorization control
159  * functions, this simplifies the implementation of "user permissions".
160  */
161 contract Ownable {
162     
163   address public owner;
164 
165   /**
166    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
167    * account.
168    */
169   function Ownable() {
170     owner = msg.sender;
171   }
172 
173   /**
174    * @dev Throws if called by any account other than the owner.
175    */
176   modifier onlyOwner() {
177     require(msg.sender == owner);
178     _;
179   }
180 
181   /**
182    * @dev Allows the current owner to transfer control of the contract to a newOwner.
183    * @param newOwner The address to transfer ownership to.
184    */
185   function transferOwnership(address newOwner) onlyOwner {
186     require(newOwner != address(0));      
187     owner = newOwner;
188   }
189 
190 }
191 
192 /**
193  * @title Mintable token
194  * @dev Simple ERC20 Token example, with mintable token creation
195  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
196  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
197  */
198 
199 contract MintableToken is StandardToken, Ownable {
200     
201   event Mint(address indexed to, uint256 amount);
202   
203   event MintFinished();
204 
205   bool public mintingFinished = false;
206 
207   modifier canMint() {
208     require(!mintingFinished);
209     _;
210   }
211 
212   /**
213    * @dev Function to mint tokens
214    * @param _to The address that will recieve the minted tokens.
215    * @param _amount The amount of tokens to mint.
216    * @return A boolean that indicates if the operation was successful.
217    */
218   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
219     totalSupply = totalSupply.add(_amount);
220     balances[_to] = balances[_to].add(_amount);
221     //Mint(_to, _amount);
222     Transfer(address(0), _to, _amount);
223     return true;
224   }
225 
226   /**
227    * @dev Function to stop minting new tokens.
228    * @return True if the operation was successful.
229    */
230   function finishMinting() onlyOwner returns (bool) {
231     mintingFinished = true;
232     MintFinished();
233     return true;
234   }
235   
236 }
237 
238 contract TRM2TokenCoin is MintableToken {
239     
240     string public constant name = "TerraMiner";
241     
242     string public constant symbol = "TRM2";
243     
244     uint32 public constant decimals = 8;
245     
246 }
247 
248 
249 
250 contract Crowdsale is Ownable, AbstractTRMBalances {
251     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
252     
253     using SafeMath for uint;
254     
255     uint public ETHUSD;
256     
257     address multisig;
258     
259     address manager;
260 
261     TRM2TokenCoin public token = new TRM2TokenCoin();
262 
263     uint public startPreSale;
264     uint public endPreSale;
265     
266     uint public startPreICO;
267     uint public endPreICO;
268     
269     uint public startICO;
270     uint public endICO;
271     
272     uint public startPostICO;
273     uint public endPostICO;    
274     
275     uint hardcap;
276     
277     bool pause;
278     
279     AbstractTRMBalances oldBalancesP1;
280     AbstractTRMBalances oldBalancesP2;   
281     
282 
283     function Crowdsale() {
284         //кошелек на который зачисляются средства
285         multisig = 0xc2CDcE18deEcC1d5274D882aEd0FB082B813FFE8;
286         //адрес кошелька управляющего контрактом
287         manager = 0xf5c723B7Cc90eaA3bEec7B05D6bbeBCd9AFAA69a;
288         //курс эфира к токенам 
289         ETHUSD = 70000;
290         
291         //время   
292         startPreSale = now;
293         endPreSale = 1515974400; //Mon, 15 Jan 2018 00:00:00 GMT
294         
295         startPreICO = 1514332800; // Wed, 27 Dec 2017 00:00:00 GMT
296         endPreICO = 1517443200; // Thu, 01 Feb 2018 00:00:00 GMT
297 
298         startICO = 1517443200; // Thu, 01 Feb 2018 00:00:00 GMT
299         endICO = 1519862400; // Thu, 01 Mar 2018 00:00:00 GMT
300         
301         startPostICO = 1519862400; // Thu, 01 Mar 2018 00:00:00 GMT
302         endPostICO = 1522540800; // Sun, 01 Apr 2018 00:00:00 GMT
303 		
304         //максимальное число сбора в токенах
305         hardcap = 250000000 * 100000000;
306         //пауза  
307         pause = false;
308         
309         oldBalancesP1 = AbstractTRMBalances(0xfcc6C3C19dcD67c282fFE27Ea79F1181693dA194);
310         oldBalancesP2 = AbstractTRMBalances(0x4B7a1c77323c1e2ED6BcE44152b30092CAA9B1D3);
311     }
312 
313     modifier saleIsOn() {
314         require((now >= startPreSale && now < endPreSale) || (now >= startPreICO && now < endPreICO) || (now >= startICO && now < endICO) || (now >= startPostICO && now < endPostICO));
315     	require(pause!=true);
316     	_;
317     }
318 	
319     modifier isUnderHardCap() {
320         require(token.totalSupply() < hardcap);
321         _;
322     }
323 
324     function finishMinting() public {
325         require(msg.sender == manager);
326         token.finishMinting();
327         token.transferOwnership(manager);
328     }
329 
330     function createTokens() isUnderHardCap saleIsOn payable {
331 
332         uint256 sum = msg.value;
333         uint256 sumUSD = msg.value.mul(ETHUSD).div(100);
334 
335        //require(msg.value > 0);
336         require(sumUSD.div(1000000000000000000) > 100);
337         
338         uint256 totalSupply = token.totalSupply();
339         
340         uint256 numTokens = 0;
341         
342         uint256 tokenRest = 0;
343         uint256 tokenPrice = 8 * 1000000000000000000;
344         
345         
346         //PreSale
347         //------------------------------------
348         if( (now >= startPreSale && now < endPreSale ) && ((oldBalancesP1.oldBalances(msg.sender) == true)||(oldBalancesP2.oldBalances(msg.sender) == true)) ){
349             
350             tokenPrice = 35 * 100000000000000000; 
351 
352             numTokens = sumUSD.mul(100000000).div(tokenPrice);
353             
354         } else {
355             //------------------------------------
356             
357             //PreICO
358             //------------------------------------
359             if(now >= startPreICO && now < endPreICO){
360                 
361                 tokenPrice = 7 ether; 
362                 if(sum >= 151 ether){
363                    tokenPrice = 35 * 100000000000000000;
364                 } else if(sum >= 66 ether){
365                    tokenPrice = 40 * 100000000000000000;
366                 } else if(sum >= 10 ether){
367                    tokenPrice = 45 * 100000000000000000;
368                 } else if(sum >= 5 ether){
369                    tokenPrice = 50 * 100000000000000000;
370                 }
371                 
372                 numTokens = sumUSD.mul(100000000).div(tokenPrice);
373                 
374             }
375             //------------------------------------        
376             
377             //ICO
378             //------------------------------------
379             if(now >= startICO && now < endICO){
380                 
381                 tokenPrice = 7 ether; 
382                 if(sum >= 151 ether){
383                    tokenPrice = 40 * 100000000000000000;
384                 } else if(sum >= 66 ether){
385                    tokenPrice = 50 * 100000000000000000;
386                 } else if(sum >= 10 ether){
387                    tokenPrice = 55 * 100000000000000000;
388                 } else if(sum >= 5 ether){
389                    tokenPrice = 60 * 100000000000000000;
390                 } 
391                 
392                 numTokens = sumUSD.mul(100000000).div(tokenPrice);
393                 
394             }
395             //------------------------------------
396             
397             //PostICO
398             //------------------------------------
399             if(now >= startPostICO && now < endPostICO){
400                 
401                 tokenPrice = 8 ether; 
402                 if(sum >= 151 ether){
403                    tokenPrice = 45 * 100000000000000000;
404                 } else if(sum >= 66 ether){
405                    tokenPrice = 55 * 100000000000000000;
406                 } else if(sum >= 10 ether){
407                    tokenPrice = 60 * 100000000000000000;
408                 } else if(sum >= 5 ether){
409                    tokenPrice = 65 * 100000000000000000;
410                 } 
411                 
412                 numTokens = sumUSD.mul(100000000).div(tokenPrice);
413                 
414             }
415             //------------------------------------  
416         }
417 
418         require(msg.value > 0);
419         require(numTokens > 0);
420         
421         tokenRest = hardcap.sub(totalSupply);
422         require(tokenRest >= numTokens);
423         
424         token.mint(msg.sender, numTokens);
425         multisig.transfer(msg.value);
426         
427         NewContribution(msg.sender, numTokens, msg.value);
428         
429         
430     }
431 
432     function() external payable {
433         createTokens();
434     }
435 
436     function mint(address _to, uint _value) {
437         require(msg.sender == manager);
438         uint256 tokenRest = hardcap.sub(token.totalSupply());
439         require(tokenRest > 0);
440         if(_value > tokenRest)
441             _value = tokenRest;
442         token.mint(_to, _value);   
443     }    
444     
445     function setETHUSD( uint256 _newPrice ) {
446         require(msg.sender == manager);
447         ETHUSD = _newPrice;
448     }    
449     
450     function setPause( bool _newPause ) {
451         require(msg.sender == manager);
452         pause = _newPause;
453     }
454 
455 }