1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is
33 greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns
68 (uint256);
69   function transferFrom(address from, address to, uint256 value) public
70 returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256
73 value);
74 }
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82   mapping(address => uint256) balances;
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     // SafeMath.sub will throw if there is not enough balance.
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256 balance) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * @dev https://github.com/ethereum/EIPs/issues/20
116  * @dev Based on code by FirstBlood:
117 https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
118  */
119 contract StandardToken is ERC20, BasicToken {
120 
121   mapping (address => mapping (address => uint256)) internal allowed;
122 
123 
124   /**
125    * @dev Transfer tokens from one address to another
126    * @param _from address The address which you want to send tokens from
127    * @param _to address The address which you want to transfer to
128    * @param _value uint256 the amount of tokens to be transferred
129    */
130   function transferFrom(address _from, address _to, uint256 _value) public
131 returns (bool) {
132     require(_to != address(0));
133     require(_value <= balances[_from]);
134     require(_value <= allowed[_from][msg.sender]);
135 
136     balances[_from] = balances[_from].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139     Transfer(_from, _to, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Approve the passed address to spend the specified amount of
145 tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk
148 that someone may use both the old
149    * and the new allowance by unfortunate transaction ordering. One
150 possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set
152 the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a
165 spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint256 specifying the amount of tokens still available for
169 the spender.
170    */
171   function allowance(address _owner, address _spender) public view returns
172 (uint256) {
173     return allowed[_owner][_spender];
174   }
175 
176   /**
177    * @dev Increase the amount of tokens that an owner allowed to a spender.
178    *
179    * approve should be called when allowed[_spender] == 0. To increment
180    * allowed value is better to use this function to avoid 2 calls (and
181 wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187   function increaseApproval(address _spender, uint _addedValue) public
188 returns (bool) {
189     allowed[msg.sender][_spender] =
190 allowed[msg.sender][_spender].add(_addedValue);
191     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194 
195   /**
196    * @dev Decrease the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To decrement
199    * allowed value is better to use this function to avoid 2 calls (and
200 wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _subtractedValue The amount of tokens to decrease the allowance
205 by.
206    */
207   function decreaseApproval(address _spender, uint _subtractedValue) public
208 returns (bool) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 contract RandoCoin is StandardToken {
222     using SafeMath for uint256;
223     
224     // Standard token variables
225     // Initial supply is 100MM RAND
226     uint256 public totalSupply = (100000000) * 1000;
227     string public name = "RandoCoin";
228     string public symbol = "RAND";
229     uint8 public decimals = 3;
230     uint BLOCK_WAIT_TIME = 30;
231     uint INIT_BLOCK_WAIT = 250;
232     
233     // Dev variables
234     address owner;
235     uint public buyPrice;
236     uint public sellPrice;
237     uint public priceChangeBlock;
238     uint public oldPriceChangeBlock;
239     bool isInitialized = false;
240     
241     // PRICE VARIABLES -- all prices are in wei per rando
242     // 1000 rando =  1 RAND
243     // Prices will change randomly in the range
244     // between 0.00001 and 0.01 ETH per rand
245     // Which is between $0.01 and $10
246     // Initial price $5 per RAND
247     // That means that the first price change has a 50/50
248     // chance of going up or down.
249     uint public PRICE_MIN = 0.00000001 ether;
250     uint public PRICE_MAX = 0.00001 ether;
251     uint public PRICE_MID = 0.000005 ether;
252     
253     // If anyone wants to write a bot...
254     event BuyPriceChanged(uint newBuyPrice);
255     event SellPriceChanged(uint newSellPrice);
256 
257     function RandoCoin() public payable {
258         owner = msg.sender;
259         // No premining!
260         // The contract holds the whole balance
261         balances[this] = totalSupply;
262         
263         // These numbers don't matter, they will be overriden when init() is called
264         // Which will kick off the contract
265         priceChangeBlock = block.number + INIT_BLOCK_WAIT;
266         oldPriceChangeBlock = block.number;
267         buyPrice = PRICE_MID;
268         sellPrice = PRICE_MID;
269     }
270     
271     // Can only be called once
272     // This kicks off the initial 1 hour timer
273     // So I can time it with a social media post
274     function init() public {
275         require(msg.sender == owner);
276         require(!isInitialized);
277         
278         // Initial prices in wei per rando
279         buyPrice = PRICE_MID;
280         sellPrice = PRICE_MID;
281         
282         // First time change is roughly 1 hr (250 blocks)
283         // This gives more time for people to invest in the initial price
284         oldPriceChangeBlock = block.number;
285         priceChangeBlock = block.number + INIT_BLOCK_WAIT;
286         isInitialized = true;
287     }
288     
289     function buy() public requireNotExpired requireCooldown payable returns (uint amount){
290         amount = msg.value / buyPrice;
291         require(balances[this] >= amount);
292         balances[msg.sender] = balances[msg.sender].add(amount);
293         balances[this] = balances[this].sub(amount);
294         
295         Transfer(this, msg.sender, amount);
296         return amount;
297     }
298     
299     function sell(uint amount) public requireNotExpired requireCooldown returns (uint revenue){
300         require(balances[msg.sender] >= amount);
301         balances[this] += amount;
302         balances[msg.sender] -= amount;
303 
304         revenue = amount.mul(sellPrice);
305         msg.sender.transfer(revenue);
306         
307         Transfer(msg.sender, this, amount);
308         return revenue;
309     }
310     
311     // Change the price if possible
312     // Get rewarded with 1 RAND
313     function maybeChangePrice() public {
314         // We actually need two block hashes, one for buy price, one for sell
315         // We will use ppriceChangeBlock and priceChangeBlock + 1, so we need
316         // to wait for 1 more block
317         // This will create a 1 block period where you cannot buy/sell or
318         // change the price, sorry!
319         require(block.number > priceChangeBlock + 1);
320         
321         // Block is too far away to get hash, restart timer
322         // Sorry, no reward here. At this point the contract
323         // is probably dead anyway.
324         if (block.number - priceChangeBlock > 250) {
325             waitMoreTime();
326             return;
327         }
328         
329         // I know this isn't good but
330         // Open challenge if a miner can break this
331         sellPrice = shittyRand(0);
332         buyPrice = shittyRand(1);
333         
334         // Set minimum prices to avoid miniscule amounts
335         if (sellPrice < PRICE_MIN) {
336             sellPrice = PRICE_MIN;
337         }
338         
339         if (buyPrice < PRICE_MIN) {
340             buyPrice = PRICE_MIN;
341         }
342         
343         BuyPriceChanged(buyPrice);
344         SellPriceChanged(sellPrice);
345 
346         oldPriceChangeBlock = priceChangeBlock;
347         priceChangeBlock = block.number + BLOCK_WAIT_TIME;
348         
349         // Reward the person who refreshed priceChangeBlock 0.1 RAND
350         uint reward = 100;
351         if (balances[this] > reward) {
352             balances[msg.sender] = balances[msg.sender].add(reward);
353             balances[this] = balances[this].sub(reward);
354         }
355     }
356     
357     // You don't want someone to be able to change the price and then
358     // Execute buy and sell in the same block, they could potentially
359     // game the system (I think..), so freeze buying for 2 blocks after a price change.
360     modifier requireCooldown() {
361         // This should always be true..
362         if (block.number >= oldPriceChangeBlock) {
363             require(block.number - priceChangeBlock > 2);
364         }
365         _;
366     }
367     
368     modifier requireNotExpired() {
369         require(block.number < priceChangeBlock);
370         _;
371     }
372     
373     // Wait more time without changing the price
374     // Used only when the blockhash is too far away
375     // If we didn't do this, and instead picked a block within 256
376     // Someone could game the system and wait to call the function 
377     // until a block which gave favorable prices.
378     function waitMoreTime() internal {
379         priceChangeBlock = block.number + BLOCK_WAIT_TIME;
380     }
381     
382     // Requires block to be 256 away
383     function shittyRand(uint seed) public returns(uint) {
384         uint randomSeed = uint(block.blockhash(priceChangeBlock + seed));
385         return randomSeed % PRICE_MAX;
386     }
387     
388     function getBlockNumber() public returns(uint) {
389         return block.number;
390     }
391 
392 }