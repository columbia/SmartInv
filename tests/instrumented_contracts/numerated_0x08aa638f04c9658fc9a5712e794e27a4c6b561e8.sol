1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20Basic {
9   uint public totalSupply;
10   function balanceOf(address who) constant returns (uint);
11   function transfer(address to, uint value);
12   event Transfer(address indexed from, address indexed to, uint value);
13 }
14 
15 /**
16  * Math operations with safety checks
17  */
18 library SafeMath {
19   function mul(uint a, uint b) internal returns (uint) {
20     uint c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint a, uint b) internal returns (uint) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint a, uint b) internal returns (uint) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint a, uint b) internal returns (uint) {
38     uint c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 
43   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
44     return a >= b ? a : b;
45   }
46 
47   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
48     return a < b ? a : b;
49   }
50 
51   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
52     return a >= b ? a : b;
53   }
54 
55   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
56     return a < b ? a : b;
57   }
58   
59   /**
60    * Based on http://www.codecodex.com/wiki/Calculate_an_integer_square_root
61    */
62   function sqrt(uint num) internal returns (uint) {
63     if (0 == num) { // Avoid zero divide 
64       return 0; 
65     }   
66     uint n = (num / 2) + 1;      // Initial estimate, never low  
67     uint n1 = (n + (num / n)) / 2;  
68     while (n1 < n) {  
69       n = n1;  
70       n1 = (n + (num / n)) / 2;  
71     }  
72     return n;  
73   }
74 
75   function assert(bool assertion) internal {
76     if (!assertion) {
77       throw;
78     }
79   }
80 }
81 
82 /**
83  * @title Basic token
84  * @dev Basic version of StandardToken, with no allowances. 
85  */
86 contract BasicToken is ERC20Basic {
87   using SafeMath for uint;
88 
89   mapping(address => uint) balances;
90 
91   /**
92    * @dev Fix for the ERC20 short address attack.
93    */
94   modifier onlyPayloadSize(uint size) {
95      if(msg.data.length < size + 4) {
96        throw;
97      }
98      _;
99   }
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of. 
115   * @return An uint representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) constant returns (uint balance) {
118     return balances[_owner];
119   }
120 
121 }
122 
123 /**
124  * @title ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  */
127 contract ERC20 is ERC20Basic {
128   function allowance(address owner, address spender) constant returns (uint);
129   function transferFrom(address from, address to, uint value);
130   function approve(address spender, uint value);
131   event Approval(address indexed owner, address indexed spender, uint value);
132 }
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implemantation of the basic standart token.
138  * @dev https://github.com/ethereum/EIPs/issues/20
139  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is BasicToken, ERC20 {
142 
143   mapping (address => mapping (address => uint)) allowed;
144 
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint the amout of tokens to be transfered
150    */
151   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
152     var _allowance = allowed[_from][msg.sender];
153 
154     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
155     // if (_value > _allowance) throw;
156 
157     balances[_to] = balances[_to].add(_value);
158     balances[_from] = balances[_from].sub(_value);
159     allowed[_from][msg.sender] = _allowance.sub(_value);
160     Transfer(_from, _to, _value);
161   }
162 
163   /**
164    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint _value) {
169 
170     // To change the approve amount you first have to reduce the addresses`
171     //  allowance to zero by calling `approve(_spender, 0)` if it is not
172     //  already 0 to mitigate the race condition described here:
173     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
175 
176     allowed[msg.sender][_spender] = _value;
177     Approval(msg.sender, _spender, _value);
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens than an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint specifing the amount of tokens still avaible for the spender.
185    */
186   function allowance(address _owner, address _spender) constant returns (uint remaining) {
187     return allowed[_owner][_spender];
188   }
189 
190 }
191 
192 /**
193  * @title Crypto Masters Token
194  * 
195  */
196 contract CryptoMastersToken is StandardToken {
197     // metadata
198     string public constant name = "Crypto Masters Token";
199     string public constant symbol = "CMS";
200     uint public constant decimals = 0;
201     // crowdsale parameters
202     uint public constant tokenCreationMin = 1000000;
203     uint public constant tokenPriceMin = 0.0004 ether;
204     // contructor parameters
205     address public owner1;
206     address public owner2;
207     // contract state
208     uint public EthersRaised = 0;
209     bool public isHalted = false;
210     // events
211     event LogBuy(address indexed who, uint tokens, uint EthersValue, uint supplyAfter);  
212     /**
213      * @dev Throws if called by any account other than one of the owners. 
214      */
215     modifier onlyOwner() {
216       if (msg.sender != owner1 && msg.sender != owner2) {
217         throw;
218       }
219       _;
220     }
221     /**
222     * @dev Allows the current owner to transfer control of the contract to a newOwner.
223     * @param newOwner1 The address to transfer ownership to.
224     */
225     function transferOwnership1(address newOwner1) onlyOwner {
226      require(newOwner1 != address(0));      
227      owner1 = newOwner1;
228     }
229     function transferOwnership2(address newOwner2) onlyOwner {
230       require(newOwner2 != address(0));      
231       owner2 = newOwner2;
232     } 
233     // constructor
234     function CryptoMastersToken() {
235         owner1 = msg.sender;
236         owner2 = msg.sender;
237     }
238     /**
239      * @dev Calculates how many tokens one can buy for specified value
240      * @return Amount of tokens one will receive and purchase value without remainder. 
241      */
242     function getBuyPrice(uint _bidValue) constant returns (uint tokenCount, uint purchaseValue) {
243 
244         // Token price formula is twofold. We have flat pricing below tokenCreationMin, 
245         // and above that price linarly increases with supply. 
246 
247         uint flatTokenCount;
248         uint startSupply;
249         uint linearBidValue;
250         
251         if(totalSupply < tokenCreationMin) {
252             uint maxFlatTokenCount = _bidValue.div(tokenPriceMin);
253             // entire purchase in flat pricing
254             if(totalSupply.add(maxFlatTokenCount) <= tokenCreationMin) {
255                 return (maxFlatTokenCount, maxFlatTokenCount.mul(tokenPriceMin));
256             }
257             flatTokenCount = tokenCreationMin.sub(totalSupply);
258             linearBidValue = _bidValue.sub(flatTokenCount.mul(tokenPriceMin));
259             startSupply = tokenCreationMin;
260         } else {
261             flatTokenCount = 0;
262             linearBidValue = _bidValue;
263             startSupply = totalSupply;
264         }
265         
266         // Solves quadratic equation to calculate maximum token count that can be purchased
267         uint currentPrice = tokenPriceMin.mul(startSupply).div(tokenCreationMin);
268         uint delta = (2 * startSupply).mul(2 * startSupply).add(linearBidValue.mul(4 * 1 * 2 * startSupply).div(currentPrice));
269 
270         uint linearTokenCount = delta.sqrt().sub(2 * startSupply).div(2);
271         uint linearAvgPrice = currentPrice.add((startSupply+linearTokenCount+1).mul(tokenPriceMin).div(tokenCreationMin)).div(2);
272         
273         // double check to eliminate rounding errors
274         linearTokenCount = linearBidValue / linearAvgPrice;
275         linearAvgPrice = currentPrice.add((startSupply+linearTokenCount+1).mul(tokenPriceMin).div(tokenCreationMin)).div(2);
276         
277         purchaseValue = linearTokenCount.mul(linearAvgPrice).add(flatTokenCount.mul(tokenPriceMin));
278         return (
279             flatTokenCount + linearTokenCount,
280             purchaseValue
281         );
282      }
283     
284     /**
285      * Default function called by sending Ether to this address with no arguments.
286      * 
287      */
288     function() payable {
289         BuyLimit(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
290     }
291     
292     /**
293      * @dev Buy tokens
294      */
295     function Buy() payable external {
296         BuyLimit(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);    
297     }
298     
299     /**
300      * @dev Buy tokens with limit maximum average price
301      * @param _maxPrice Maximum price user want to pay for one token
302      */
303     function BuyLimit(uint _maxPrice) payable public {
304         require(msg.value >= tokenPriceMin);
305         assert(!isHalted);
306         
307         uint boughtTokens;
308         uint averagePrice;
309         uint purchaseValue;
310         
311         (boughtTokens, purchaseValue) = getBuyPrice(msg.value);
312         if(boughtTokens == 0) { 
313             // bid to small, return ether and abort
314             msg.sender.transfer(msg.value);
315             return; 
316         }
317         averagePrice = purchaseValue.div(boughtTokens);
318         if(averagePrice > _maxPrice) { 
319             // price too high, return ether and abort
320             msg.sender.transfer(msg.value);
321             return; 
322         }
323         assert(averagePrice >= tokenPriceMin);
324         assert(purchaseValue <= msg.value);
325         
326         totalSupply = totalSupply.add(boughtTokens);
327         balances[msg.sender] = balances[msg.sender].add(boughtTokens);
328       
329         LogBuy(msg.sender, boughtTokens, purchaseValue.div(1000000000000000000), totalSupply);
330         
331         if(msg.value > purchaseValue) {
332             msg.sender.transfer(msg.value.sub(purchaseValue));
333         }  
334         EthersRaised += purchaseValue;
335     }
336     /**
337      * @dev Withdraw funds to owners.
338      */
339     function withdrawAllFunds() external onlyOwner { 
340         msg.sender.transfer(this.balance);
341     }
342     function withdrawFunds(uint _amount) external onlyOwner { 
343         require(_amount <= this.balance);
344         msg.sender.transfer(_amount);
345     }
346     /**
347      * 
348      * @dev When contract is halted no one can buy new tokens.
349      * 
350      */
351     function haltCrowdsale() external onlyOwner {
352         isHalted = !isHalted;
353     }
354 }