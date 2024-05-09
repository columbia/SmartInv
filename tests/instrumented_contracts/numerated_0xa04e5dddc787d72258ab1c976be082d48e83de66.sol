1 pragma solidity ^0.4.13;
2  
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) constant returns (uint256);
12   function transfer(address to, uint256 value) returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) constant returns (uint256);
22   function transferFrom(address from, address to, uint256 value) returns (bool);
23   function approve(address spender, uint256 value) returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32     
33   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
34     uint256 c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal constant returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal constant returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56   
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances. 
62  */
63 contract BasicToken is ERC20Basic {
64     
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   /**
70   * @dev transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) returns (bool) {
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of. 
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) allowed;
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amout of tokens to be transfered
108    */
109   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
110     var _allowance = allowed[_from][msg.sender];
111 
112     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
113     // require (_value <= _allowance);
114 
115     balances[_to] = balances[_to].add(_value);
116     balances[_from] = balances[_from].sub(_value);
117     allowed[_from][msg.sender] = _allowance.sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) returns (bool) {
128 
129     // To change the approve amount you first have to reduce the addresses`
130     //  allowance to zero by calling `approve(_spender, 0)` if it is not
131     //  already 0 to mitigate the race condition described here:
132     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
134 
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifing the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150 }
151 
152 /**
153  * @title Ownable
154  * @dev The Ownable contract has an owner address, and provides basic authorization control
155  * functions, this simplifies the implementation of "user permissions".
156  */
157 contract Ownable {
158     
159   address public owner;
160 
161   /**
162    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
163    * account.
164    */
165   function Ownable() {
166     owner = msg.sender;
167   }
168 
169   /**
170    * @dev Throws if called by any account other than the owner.
171    */
172   modifier onlyOwner() {
173     require(msg.sender == owner);
174     _;
175   }
176 
177   /**
178    * @dev Allows the current owner to transfer control of the contract to a newOwner.
179    * @param newOwner The address to transfer ownership to.
180    */
181   function transferOwnership(address newOwner) onlyOwner {
182     require(newOwner != address(0));      
183     owner = newOwner;
184   }
185 
186 }
187 
188 /**
189  * @title Mintable token
190  * @dev Simple ERC20 Token example, with mintable token creation
191  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
192  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
193  */
194 
195 contract MintableToken is StandardToken, Ownable {
196     
197   event Mint(address indexed to, uint256 amount);
198   
199   event MintFinished();
200 
201   bool public mintingFinished = false;
202 
203   modifier canMint() {
204     require(!mintingFinished);
205     _;
206   }
207 
208   /**
209    * @dev Function to mint tokens
210    * @param _to The address that will recieve the minted tokens.
211    * @param _amount The amount of tokens to mint.
212    * @return A boolean that indicates if the operation was successful.
213    */
214   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
215     totalSupply = totalSupply.add(_amount);
216     balances[_to] = balances[_to].add(_amount);
217     Transfer(address(0), _to, _amount);
218     return true;
219   }
220 
221   /**
222    * @dev Function to stop minting new tokens.
223    * @return True if the operation was successful.
224    */
225   function finishMinting() onlyOwner returns (bool) {
226     mintingFinished = true;
227     MintFinished();
228     return true;
229   }
230   
231 }
232 
233 contract RomanovEmpireTokenCoin is MintableToken {
234     
235     string public constant name = " Romanov Empire Imperium Token";
236     
237     string public constant symbol = "REI";
238     
239     uint32 public constant decimals = 0;
240     
241 }
242 
243 
244 contract Crowdsale is Ownable {
245     
246     using SafeMath for uint;
247     
248     address multisig;
249     
250     address manager;
251 
252     uint restrictedPercent;
253 
254     address restricted;
255 
256     RomanovEmpireTokenCoin public token = new RomanovEmpireTokenCoin();
257 
258     uint start;
259 
260     uint preIcoEnd;
261     
262     //uint period;
263 
264     //uint hardcap;
265     
266     uint preICOhardcap;
267 
268     uint public ETHUSD;
269     
270     uint public hardcapUSD;
271     
272     uint public collectedFunds;
273     
274     bool pause;
275 
276     function Crowdsale() {
277         //кошелек на который зачисляются средства
278         multisig = 0x1e129862b37Fe605Ef2099022F497caab7Db194c;//msg.sender;
279         //кошелек куда будет перечислен процент наших токенов
280         restricted = 0x1e129862b37Fe605Ef2099022F497caab7Db194c;//msg.sender;
281         //адрес кошелька управляющего контрактом
282         manager = msg.sender;
283         //процент, от проданных токенов, который мы оставляем себе 
284         restrictedPercent = 1200;
285         //курс эфира к токенам 
286         ETHUSD = 70000;
287         //время старта  
288         start = now;
289 	//время завершения prICO
290         preIcoEnd = 1546300800;//Tue, 01 Jan 2019 00:00:00 GMT
291         //период ICO в минутах
292         //period = 25;
293         //максимальное число сбора в токенах на PreICO
294         preICOhardcap = 42000;		
295         //максимальное число сбора в токенах
296         //hardcap = 42000;
297         //максимальное число сбора в центах
298         hardcapUSD = 500000000;
299         //собрано средство в центах
300         collectedFunds = 0;
301         //пауза 
302         pause = false;
303     }
304 
305     modifier saleIsOn() {
306     	require(now > start && now < preIcoEnd);
307     	require(pause!=true);
308     	_;
309     }
310 	
311     modifier isUnderHardCap() {
312         require(token.totalSupply() < preICOhardcap);
313         //если набран hardcapUSD
314         require(collectedFunds < hardcapUSD);
315         _;
316     }
317 
318     function finishMinting() public {
319         require(msg.sender == manager);
320         
321         uint issuedTokenSupply = token.totalSupply();
322         uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(10000);
323         token.mint(restricted, restrictedTokens);
324         token.transferOwnership(restricted);
325     }
326 
327     function createTokens() isUnderHardCap saleIsOn payable {
328 
329         require(msg.value > 0);
330         
331         uint256 totalSupply = token.totalSupply();
332         
333         uint256 numTokens = 0;
334         uint256 summ1 = 1800000;
335         uint256 summ2 = 3300000;
336           
337         uint256 price1 = 18000;
338         uint256 price2 = 15000;
339         uint256 price3 = 12000;
340           
341         uint256 usdValue = msg.value.mul(ETHUSD).div(1000000000000000000);
342           
343         uint256 spendMoney = 0; 
344         
345         uint256 tokenRest = 0;
346         uint256 rest = 0;
347         
348           tokenRest = preICOhardcap.sub(totalSupply);
349           require(tokenRest > 0);
350             
351           
352           if(usdValue>summ2 && tokenRest > 200 ){
353               numTokens = (usdValue.sub(summ2)).div(price3).add(200);
354               if(numTokens > tokenRest)
355                 numTokens = tokenRest;              
356               spendMoney = summ2.add((numTokens.sub(200)).mul(price3));
357           }else if(usdValue>summ1 && tokenRest > 100 ) {
358               numTokens = (usdValue.sub(summ1)).div(price2).add(100);
359               if(numTokens > tokenRest)
360                 numTokens = tokenRest;
361               spendMoney = summ1.add((numTokens.sub(100)).mul(price2));
362           }else {
363               numTokens = usdValue.div(price1);
364               if(numTokens > tokenRest)
365                 numTokens = tokenRest;
366               spendMoney = numTokens.mul(price1);
367           }
368     
369           rest = (usdValue.sub(spendMoney)).mul(1000000000000000000).div(ETHUSD);
370     
371          msg.sender.transfer(rest);
372          if(rest<msg.value){
373             multisig.transfer(msg.value.sub(rest));
374             collectedFunds = collectedFunds + msg.value.sub(rest).mul(ETHUSD).div(1000000000000000000); 
375          }
376          
377           token.mint(msg.sender, numTokens);
378           
379         
380         
381     }
382 
383     function() external payable {
384         createTokens();
385     }
386 
387     function mint(address _to, uint _value) {
388         require(msg.sender == manager);
389         token.mint(_to, _value);   
390     }    
391     
392     function setETHUSD( uint256 _newPrice ) {
393         require(msg.sender == manager);
394         ETHUSD = _newPrice;
395     }    
396     
397     function setPause( bool _newPause ) {
398         require(msg.sender == manager);
399         pause = _newPause;
400     } 
401     
402 }