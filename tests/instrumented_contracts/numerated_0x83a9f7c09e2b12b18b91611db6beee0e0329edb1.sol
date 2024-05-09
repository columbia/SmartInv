1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 //ERC20 Token
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 
74 
75 
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that throw on error
79  */
80 library SafeMath {
81   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
82     uint256 c = a * b;
83     assert(a == 0 || c / a == b);
84     return c;
85   }
86 
87   function div(uint256 a, uint256 b) internal constant returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   function add(uint256 a, uint256 b) internal constant returns (uint256) {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 
107 
108 /**
109  * @title Basic token
110  * @dev Basic version of StandardToken, with no allowances.
111  */
112 contract BasicToken is ERC20Basic {
113   using SafeMath for uint256;
114 
115   mapping(address => uint256) balances;
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _value The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[msg.sender]);
125 
126     // SafeMath.sub will throw if there is not enough balance.
127     balances[msg.sender] = balances[msg.sender].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     Transfer(msg.sender, _to, _value);
130     return true;
131   }
132 
133   /**
134   * @dev Gets the balance of the specified address.
135   * @param _owner The address to query the the balance of.
136   * @return An uint256 representing the amount owned by the passed address.
137   */
138   function balanceOf(address _owner) public constant returns (uint256 balance) {
139     return balances[_owner];
140   }
141 
142 }
143 
144 
145 
146 
147 
148 
149 
150 /**
151  * @title ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/20
153  */
154 contract ERC20 is ERC20Basic {
155   function allowance(address owner, address spender) public constant returns (uint256);
156   function transferFrom(address from, address to, uint256 value) public returns (bool);
157   function approve(address spender, uint256 value) public returns (bool);
158   event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 
162 
163 /**
164  * @title Standard ERC20 token
165  *
166  * @dev Implementation of the basic standard token.
167  * @dev https://github.com/ethereum/EIPs/issues/20
168  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
169  */
170 contract StandardToken is ERC20, BasicToken {
171 
172   mapping (address => mapping (address => uint256)) internal allowed;
173 
174 
175   /**
176    * @dev Transfer tokens from one address to another
177    * @param _from address The address which you want to send tokens from
178    * @param _to address The address which you want to transfer to
179    * @param _value uint256 the amount of tokens to be transferred
180    */
181   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
182     require(_to != address(0));
183     require(_value <= balances[_from]);
184     require(_value <= allowed[_from][msg.sender]);
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    *
196    * Beware that changing an allowance with this method brings the risk that someone may use both the old
197    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
198    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
199    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200    * @param _spender The address which will spend the funds.
201    * @param _value The amount of tokens to be spent.
202    */
203   function approve(address _spender, uint256 _value) public returns (bool) {
204     allowed[msg.sender][_spender] = _value;
205     Approval(msg.sender, _spender, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Function to check the amount of tokens that an owner allowed to a spender.
211    * @param _owner address The address which owns the funds.
212    * @param _spender address The address which will spend the funds.
213    * @return A uint256 specifying the amount of tokens still available for the spender.
214    */
215   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
216     return allowed[_owner][_spender];
217   }
218 
219   /**
220    * approve should be called when allowed[_spender] == 0. To increment
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    */
225   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
226     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
227     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 
245 /**
246  * @title Burnable Token
247  * @dev Token that can be irreversibly burned (destroyed).
248  */
249 contract BurnableToken is StandardToken {
250 
251     event Burn(address indexed burner, uint256 value);
252 
253     /**
254      * @dev Burns a specific amount of tokens.
255      * @param _value The amount of token to be burned.
256      */
257     function burn(uint256 _value) public {
258         require(_value > 0);
259         require(_value <= balances[msg.sender]);
260         // no need to require value <= totalSupply, since that would imply the
261         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
262 
263         address burner = msg.sender;
264         balances[burner] = balances[burner].sub(_value);
265         totalSupply = totalSupply.sub(_value);
266         Burn(burner, _value);
267     }
268 }
269 
270 
271 
272 contract CJToken is BurnableToken, Ownable {
273 
274     string public constant name = "ConnectJob";
275     string public constant symbol = "CJT";
276     uint public constant decimals = 18;
277     uint256 public constant initialSupply = 300000000 * (10 ** uint256(decimals));
278 
279     // Constructor
280     function CJToken() {
281         totalSupply = initialSupply;
282         balances[msg.sender] = initialSupply; // Send all tokens to owner
283     }
284 }
285 
286 
287 contract Crowdsale is Ownable {
288     using SafeMath for uint256;
289 
290     // address where funds are collected
291     address public multisigVault;
292 
293     CJToken public coin;
294 
295     // start and end timestamps where investments are allowed (both inclusive)
296     uint256 public startTime;
297     uint256 public endTime;
298     // amount of raised money in wei
299     uint256 public weiRaised;
300     // amount of tokens sold
301     uint256 public tokensSold;
302     // max amount of token for sale during ICO
303     uint256 public maxCap;
304 
305     /**
306     * event for token purchase logging
307     * @param purchaser who paid for the tokens
308     * @param beneficiary who got the tokens
309     * @param value weis paid for purchase
310     * @param amount of tokens purchased
311     */
312     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
313 
314     function Crowdsale(address _CJTokenAddress, address _to, uint256 _maxCap) {
315         coin = CJToken(_CJTokenAddress);
316         multisigVault = _to;
317         maxCap = _maxCap;
318 
319         // startTime = 1518651000; // new Date("Feb 14 2018 23:30:00 GMT").getTime() / 1000;
320         startTime = now; // for testing we use now
321         endTime = startTime + 75 days; // ICO end on Apr 30 2018 00:00:00 GMT
322     }
323 
324     // fallback function can be used to buy tokens
325     function () payable {
326         buyTokens(msg.sender);
327     }
328 
329     // allow owner to modify address of wallet
330     function setMultiSigVault(address _multisigVault) public onlyOwner {
331         require(_multisigVault != address(0));
332         multisigVault = _multisigVault;
333     }
334 
335     // compute amount of token based on 1 ETH = 2400 CJT
336     function getTokenAmount(uint256 _weiAmount) internal returns(uint256) {
337         // minimum deposit amount is 0.4 ETH
338         if (_weiAmount < 0.001 * (10 ** 18)) {
339           return 0;
340         }
341 
342         uint256 tokens = _weiAmount.mul(2400);
343         // compute bonus
344         if(now < startTime + 7 * 1 days) {
345             tokens += (tokens * 12) / 100; // 12% for first week
346         } else if(now < startTime + 14 * 1 days) {
347             tokens += (tokens * 9) / 100; // 9% for second week
348         } else if(now < startTime + 21 * 1 days) {
349             tokens += (tokens * 6) / 100; // 6% for third week
350         } else if(now < startTime + 28 * 1 days) {
351             tokens += (tokens * 3) / 100; // 3% for fourth week
352         }
353 
354         return tokens;
355     }
356 
357     // low level token purchase function
358     function buyTokens(address beneficiary) payable {
359         require(beneficiary != 0x0);
360         require(msg.value != 0);
361         require(!hasEnded());
362         require(now > startTime);
363 
364         uint256 weiAmount = msg.value;
365         uint256 refundWeiAmount = 0;
366 
367         // calculate token amount to be sent
368         uint256 tokens = getTokenAmount(weiAmount);
369         require(tokens > 0);
370 
371         // check if we are over maxCap
372         if (tokensSold + tokens > maxCap) {
373           // send remaining tokens to user
374           uint256 overSoldTokens = (tokensSold + tokens) - maxCap;
375           refundWeiAmount = weiAmount * overSoldTokens / tokens;
376           weiAmount = weiAmount - refundWeiAmount;
377           tokens = tokens - overSoldTokens;
378         }
379 
380         // update state
381         weiRaised = weiRaised.add(weiAmount);
382         tokensSold = tokensSold.add(tokens);
383 
384         coin.transfer(beneficiary, tokens);
385         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
386         multisigVault.transfer(weiAmount);
387 
388         // return extra ether to last user
389         if (refundWeiAmount > 0) {
390           beneficiary.transfer(refundWeiAmount);
391         }
392     }
393 
394     // @return true if crowdsale event has ended
395     function hasEnded() public constant returns (bool) {
396         return now > endTime || tokensSold >= maxCap;
397     }
398 
399     // Finalize crowdsale buy burning the remaining tokens
400     // can only be called when the ICO is over
401     function finalizeCrowdsale() {
402         require(hasEnded());
403         require(coin.balanceOf(this) > 0);
404 
405         coin.burn(coin.balanceOf(this));
406     }
407 }