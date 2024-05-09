1 pragma solidity ^0.4.18;
2 
3 
4 contract AbstractTRMBalances {
5     mapping(address => bool) public oldBalances;
6 }
7 
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   uint256 public totalSupply;
16   function balanceOf(address who) constant returns (uint256);
17   function transfer(address to, uint256 value) returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 /**
22  * @title ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 is ERC20Basic {
26   function allowance(address owner, address spender) constant returns (uint256);
27   function transferFrom(address from, address to, uint256 value) returns (bool);
28   function approve(address spender, uint256 value) returns (bool);
29   event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that throw on error
35  */
36 library SafeMath {
37     
38   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a * b;
40     assert(a == 0 || c / a == b);
41     return c;
42   }
43 
44   function div(uint256 a, uint256 b) internal constant returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function add(uint256 a, uint256 b) internal constant returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61   
62 }
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances. 
67  */
68 contract BasicToken is ERC20Basic {
69     
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   /**
75   * @dev transfer token for a specified address
76   * @param _to The address to transfer to.
77   * @param _value The amount to be transferred.
78   */
79   function transfer(address _to, uint256 _value) returns (bool) {
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of. 
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) constant returns (uint256 balance) {
92     return balances[_owner];
93   }
94 
95 }
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implementation of the basic standard token.
101  * @dev https://github.com/ethereum/EIPs/issues/20
102  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract StandardToken is ERC20, BasicToken {
105 
106   mapping (address => mapping (address => uint256)) allowed;
107 
108   /**
109    * @dev Transfer tokens from one address to another
110    * @param _from address The address which you want to send tokens from
111    * @param _to address The address which you want to transfer to
112    * @param _value uint256 the amout of tokens to be transfered
113    */
114   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
115     var _allowance = allowed[_from][msg.sender];
116 
117     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
118     // require (_value <= _allowance);
119 
120     balances[_to] = balances[_to].add(_value);
121     balances[_from] = balances[_from].sub(_value);
122     allowed[_from][msg.sender] = _allowance.sub(_value);
123     Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   /**
128    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) returns (bool) {
133 
134     // To change the approve amount you first have to reduce the addresses`
135     //  allowance to zero by calling `approve(_spender, 0)` if it is not
136     //  already 0 to mitigate the race condition described here:
137     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
139 
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifing the amount of tokens still available for the spender.
150    */
151   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
152     return allowed[_owner][_spender];
153   }
154 
155 }
156 
157 /**
158  * @title Ownable
159  * @dev The Ownable contract has an owner address, and provides basic authorization control
160  * functions, this simplifies the implementation of "user permissions".
161  */
162 contract Ownable {
163     
164   address public owner;
165 
166   /**
167    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
168    * account.
169    */
170   function Ownable() {
171     owner = msg.sender;
172   }
173 
174   /**
175    * @dev Throws if called by any account other than the owner.
176    */
177   modifier onlyOwner() {
178     require(msg.sender == owner);
179     _;
180   }
181 
182   /**
183    * @dev Allows the current owner to transfer control of the contract to a newOwner.
184    * @param newOwner The address to transfer ownership to.
185    */
186   function transferOwnership(address newOwner) onlyOwner {
187     require(newOwner != address(0));      
188     owner = newOwner;
189   }
190 
191 }
192 
193 /**
194  * @title Mintable token
195  * @dev Simple ERC20 Token example, with mintable token creation
196  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
197  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
198  */
199 
200 contract MintableToken is StandardToken, Ownable {
201     
202   event Mint(address indexed to, uint256 amount);
203   
204   event MintFinished();
205 
206   bool public mintingFinished = false;
207 
208   modifier canMint() {
209     require(!mintingFinished);
210     _;
211   }
212 
213   /**
214    * @dev Function to mint tokens
215    * @param _to The address that will recieve the minted tokens.
216    * @param _amount The amount of tokens to mint.
217    * @return A boolean that indicates if the operation was successful.
218    */
219   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
220     totalSupply = totalSupply.add(_amount);
221     balances[_to] = balances[_to].add(_amount);
222     //Mint(_to, _amount);
223     Transfer(address(0), _to, _amount);
224     return true;
225   }
226 
227   /**
228    * @dev Function to stop minting new tokens.
229    * @return True if the operation was successful.
230    */
231   function finishMinting() onlyOwner returns (bool) {
232     mintingFinished = true;
233     MintFinished();
234     return true;
235   }
236   
237 }
238 
239 contract TRM2TokenCoin is MintableToken {
240     
241     string public constant name = "Terraminer";
242     
243     string public constant symbol = "TRM2";
244     
245     uint32 public constant decimals = 8;
246     
247 }
248 
249 
250 
251 contract Crowdsale is Ownable, AbstractTRMBalances {
252     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
253     
254     using SafeMath for uint;
255     
256     uint public ETHUSD;
257     
258     address multisig;
259     
260     address manager;
261 
262     TRM2TokenCoin public token = new TRM2TokenCoin();
263 
264     uint public startPreSale;
265     uint public endPreSale;
266     
267     uint public startPreICO;
268     uint public endPreICO;
269     
270     uint public startICO;
271     uint public endICO;
272     
273     uint public startPostICO;
274     uint public endPostICO;    
275     
276     uint hardcap;
277     
278     bool pause;
279     
280     AbstractTRMBalances oldBalancesP1;
281     AbstractTRMBalances oldBalancesP2;   
282     
283 
284     function Crowdsale() {
285         //кошелек на который зачисляются средства
286         multisig = 0xc2CDcE18deEcC1d5274D882aEd0FB082B813FFE8;
287         //адрес кошелька управляющего контрактом
288         manager = 0xf5c723B7Cc90eaA3bEec7B05D6bbeBCd9AFAA69a;
289         //курс эфира к токенам 
290         ETHUSD = 72846;
291         
292         //время   
293         startPreSale = 1513728000; // Wed, 20 Dec 2017 00:00:00 GMT
294         endPreSale = 1514332800; //Wed, 27 Dec 2017 00:00:00 GMT
295         
296         startPreICO = 1514332800; // Wed, 27 Dec 2017 00:00:00 GMT
297         endPreICO = 1517443200; // Thu, 01 Feb 2018 00:00:00 GMT
298 
299         startICO = 1517443200; // Thu, 01 Feb 2018 00:00:00 GMT
300         endICO = 1519862400; // Thu, 01 Mar 2018 00:00:00 GMT
301         
302         startPostICO = 1519862400; // Thu, 01 Mar 2018 00:00:00 GMT
303         endPostICO = 1522540800; // Sun, 01 Apr 2018 00:00:00 GMT
304 		
305         //максимальное число сбора в токенах
306         hardcap = 250000000 * 100000000;
307         //пауза  
308         pause = false;
309         
310         oldBalancesP1 = AbstractTRMBalances(0xfcc6C3C19dcD67c282fFE27Ea79F1181693dA194);
311         oldBalancesP2 = AbstractTRMBalances(0x4B7a1c77323c1e2ED6BcE44152b30092CAA9B1D3);
312     }
313 
314     modifier saleIsOn() {
315         require((now >= startPreSale && now < endPreSale) || (now >= startPreICO && now < endPreICO) || (now >= startICO && now < endICO) || (now >= startPostICO && now < endPostICO));
316     	require(pause!=true);
317     	_;
318     }
319 	
320     modifier isUnderHardCap() {
321         require(token.totalSupply() < hardcap);
322         _;
323     }
324 
325     function finishMinting() public {
326         require(msg.sender == manager);
327         token.finishMinting();
328         token.transferOwnership(manager);
329     }
330 
331     function createTokens() isUnderHardCap saleIsOn payable {
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
348         if(now >= startPreSale && now < endPreSale){
349             
350             require( (oldBalancesP1.oldBalances(msg.sender) == true)||(oldBalancesP2.oldBalances(msg.sender) == true) );
351             
352             
353             tokenPrice = 35 * 100000000000000000; 
354 
355             numTokens = sumUSD.mul(100000000).div(tokenPrice);
356             
357         }
358         //------------------------------------
359         
360         //PreICO
361         //------------------------------------
362         if(now >= startPreICO && now < endPreICO){
363             
364             tokenPrice = 7 ether; 
365             if(sum >= 151 ether){
366                tokenPrice = 35 * 100000000000000000;
367             } else if(sum >= 66 ether){
368                tokenPrice = 40 * 100000000000000000;
369             } else if(sum >= 10 ether){
370                tokenPrice = 45 * 100000000000000000;
371             } else if(sum >= 5 ether){
372                tokenPrice = 50 * 100000000000000000;
373             }
374             
375             numTokens = sumUSD.mul(100000000).div(tokenPrice);
376             
377         }
378         //------------------------------------        
379         
380         //ICO
381         //------------------------------------
382         if(now >= startICO && now < endICO){
383             
384             tokenPrice = 7 ether; 
385             if(sum >= 151 ether){
386                tokenPrice = 40 * 100000000000000000;
387             } else if(sum >= 66 ether){
388                tokenPrice = 50 * 100000000000000000;
389             } else if(sum >= 10 ether){
390                tokenPrice = 55 * 100000000000000000;
391             } else if(sum >= 5 ether){
392                tokenPrice = 60 * 100000000000000000;
393             } 
394             
395             numTokens = sumUSD.mul(100000000).div(tokenPrice);
396             
397         }
398         //------------------------------------
399         
400         //PostICO
401         //------------------------------------
402         if(now >= startPostICO && now < endPostICO){
403             
404             tokenPrice = 8 ether; 
405             if(sum >= 151 ether){
406                tokenPrice = 45 * 100000000000000000;
407             } else if(sum >= 66 ether){
408                tokenPrice = 55 * 100000000000000000;
409             } else if(sum >= 10 ether){
410                tokenPrice = 60 * 100000000000000000;
411             } else if(sum >= 5 ether){
412                tokenPrice = 65 * 100000000000000000;
413             } 
414             
415             numTokens = sumUSD.mul(100000000).div(tokenPrice);
416             
417         }
418         //------------------------------------   
419         numTokens = numTokens;
420         require(msg.value > 0);
421         require(numTokens > 0);
422         
423         tokenRest = hardcap.sub(totalSupply);
424         require(tokenRest >= numTokens);
425         
426         token.mint(msg.sender, numTokens);
427         multisig.transfer(msg.value);
428         
429         NewContribution(msg.sender, numTokens, msg.value);
430         
431         
432     }
433 
434     function() external payable {
435         createTokens();
436     }
437 
438     function mint(address _to, uint _value) {
439         require(msg.sender == manager);
440         uint256 tokenRest = hardcap.sub(token.totalSupply());
441         require(tokenRest > 0);
442         if(_value > tokenRest)
443             _value = tokenRest;
444         token.mint(_to, _value);   
445     }    
446     
447     function setETHUSD( uint256 _newPrice ) {
448         require(msg.sender == manager);
449         ETHUSD = _newPrice;
450     }    
451     
452     function setPause( bool _newPause ) {
453         require(msg.sender == manager);
454         pause = _newPause;
455     }
456 
457 }