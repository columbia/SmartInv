1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /**
15  * @title ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/20
17  */
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender) public constant returns (uint256);
20   function transferFrom(address from, address to, uint256 value) public returns (bool);
21   function approve(address spender, uint256 value) public returns (bool);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title Basic token
27  * @dev Basic version of StandardToken, with no allowances.
28  */
29 contract BasicToken is ERC20Basic {
30   using SafeMath for uint256;
31 
32   mapping(address => uint256) balances;
33 
34   /**
35   * @dev transfer token for a specified address
36   * @param _to The address to transfer to.
37   * @param _value The amount to be transferred.
38   */
39   function transfer(address _to, uint256 _value) public returns (bool) {
40     require(_to != address(0));
41 
42     // SafeMath.sub will throw if there is not enough balance.
43     balances[msg.sender] = balances[msg.sender].sub(_value);
44     balances[_to] = balances[_to].add(_value);
45     Transfer(msg.sender, _to, _value);
46     return true;
47   }
48 
49   /**
50   * @dev Gets the balance of the specified address.
51   * @param _owner The address to query the the balance of.
52   * @return An uint256 representing the amount owned by the passed address.
53   */
54   function balanceOf(address _owner) public constant returns (uint256 balance) {
55     return balances[_owner];
56   }
57 
58 }
59 
60 /**
61  * @title Standard ERC20 token
62  *
63  * @dev Implementation of the basic standard token.
64  * @dev https://github.com/ethereum/EIPs/issues/20
65  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
66  */
67 contract StandardToken is ERC20, BasicToken {
68 
69   mapping (address => mapping (address => uint256)) allowed;
70 
71 
72   /**
73    * @dev Transfer tokens from one address to another
74    * @param _from address The address which you want to send tokens from
75    * @param _to address The address which you want to transfer to
76    * @param _value uint256 the amount of tokens to be transferred
77    */
78   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80 
81     uint256 _allowance = allowed[_from][msg.sender];
82 
83     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
84     // require (_value <= _allowance);
85 
86     balances[_from] = balances[_from].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     allowed[_from][msg.sender] = _allowance.sub(_value);
89     Transfer(_from, _to, _value);
90     return true;
91   }
92 
93   /**
94    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
95    *
96    * Beware that changing an allowance with this method brings the risk that someone may use both the old
97    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
98    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
99    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
100    * @param _spender The address which will spend the funds.
101    * @param _value The amount of tokens to be spent.
102    */
103   function approve(address _spender, uint256 _value) public returns (bool) {
104     allowed[msg.sender][_spender] = _value;
105     Approval(msg.sender, _spender, _value);
106     return true;
107   }
108 
109   /**
110    * @dev Function to check the amount of tokens that an owner allowed to a spender.
111    * @param _owner address The address which owns the funds.
112    * @param _spender address The address which will spend the funds.
113    * @return A uint256 specifying the amount of tokens still available for the spender.
114    */
115   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
116     return allowed[_owner][_spender];
117   }
118 
119   /**
120    * approve should be called when allowed[_spender] == 0. To increment
121    * allowed value is better to use this function to avoid 2 calls (and wait until
122    * the first transaction is mined)
123    * From MonolithDAO Token.sol
124    */
125   function increaseApproval (address _spender, uint _addedValue)
126     returns (bool success) {
127     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
128     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
129     return true;
130   }
131 
132   function decreaseApproval (address _spender, uint _subtractedValue)
133     returns (bool success) {
134     uint oldValue = allowed[msg.sender][_spender];
135     if (_subtractedValue > oldValue) {
136       allowed[msg.sender][_spender] = 0;
137     } else {
138       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
139     }
140     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
141     return true;
142   }
143 
144 }
145 
146 
147 
148 /**
149  * @title Ownable
150  * @dev The Ownable contract has an owner address, and provides basic authorization control
151  * functions, this simplifies the implementation of "user permissions".
152  */
153 contract Ownable {
154   address public owner;
155 
156 
157   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
158 
159 
160   /**
161    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162    * account.
163    */
164   function Ownable() {
165     owner = msg.sender;
166   }
167 
168 
169   /**
170    * @dev Throws if called by any account other than the owner.
171    */
172   modifier onlyOwner() {
173     require(msg.sender == owner);
174     _;
175   }
176 
177 
178   /**
179    * @dev Allows the current owner to transfer control of the contract to a newOwner.
180    * @param newOwner The address to transfer ownership to.
181    */
182   function transferOwnership(address newOwner) onlyOwner public {
183     require(newOwner != address(0));
184     OwnershipTransferred(owner, newOwner);
185     owner = newOwner;
186   }
187 
188 }
189 
190 library SafeMath {
191   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
192     uint256 c = a * b;
193     assert(a == 0 || c / a == b);
194     return c;
195   }
196 
197   function div(uint256 a, uint256 b) internal constant returns (uint256) {
198     // assert(b > 0); // Solidity automatically throws when dividing by 0
199     uint256 c = a / b;
200     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201     return c;
202   }
203 
204   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
205     assert(b <= a);
206     return a - b;
207   }
208 
209   function add(uint256 a, uint256 b) internal constant returns (uint256) {
210     uint256 c = a + b;
211     assert(c >= a);
212     return c;
213   }
214 }
215 
216 
217 // This is just a contract of a B2BC Token.
218 // It is a ERC20 token
219 contract B2BCToken is StandardToken, Ownable{
220     
221     string public version = "1.8";
222     string public name = "B2B Coin Token";
223     string public symbol = "B2BC";
224     uint8 public  decimals = 18;
225 
226     
227     uint256 internal constant INITIAL_SUPPLY = 300 * (10**6) * (10 **18);
228     uint256 internal constant DEVELOPER_RESERVED = 120 * (10**6) * (10**18);
229 
230     //address public developer;
231     //uint256 internal crowdsaleAvaible;
232 
233 
234     event Burn(address indexed burner, uint256 value);
235     
236     // constructor
237     function B2BCToken(address _developer) { 
238         balances[_developer] = DEVELOPER_RESERVED;
239         totalSupply = DEVELOPER_RESERVED;
240     }
241 
242   
243     /**
244      * @dev Burns a specific amount of tokens.
245      * @param _value The amount of token to be burned.
246      */
247     function burn(uint256 _value) public returns (bool success) {
248         require(_value > 0);
249         require(_value <= balances[msg.sender]);
250     
251         address burner = msg.sender;
252         balances[burner] = balances[burner].sub(_value);
253         totalSupply = totalSupply.sub(_value);
254         Burn(burner, _value);
255         return true;
256     }
257 
258     // 
259     function isSoleout() public constant returns (bool) {
260         return (totalSupply >= INITIAL_SUPPLY);
261     }
262 
263 
264     modifier canMint() {
265         require(!isSoleout());
266         _;
267     } 
268     
269     /**
270    * @dev Function to mint tokens
271    * @param _to The address that will receive the minted tokens.
272    * @param _amount The amount of tokens to mint.
273    * @return A boolean that indicates if the operation was successful.
274    */
275     function mintB2BC(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
276         totalSupply = totalSupply.add(_amount);
277         balances[_to] = balances[_to].add(_amount);
278         Transfer(0x0, _to, _amount);
279         return true;
280     }
281 }
282 
283 
284 // Contract for B2BC Token sale
285 contract B2BCCrowdsale is Ownable{
286     using SafeMath for uint256;
287 
288       // The token being sold
289       B2BCToken public b2bcToken;
290 
291       // start and end timestamps where investments are allowed (both inclusive)
292       uint256 public startTime;
293       uint256 public endTime;
294       
295 
296       uint256 internal constant baseExchangeRate =  2000 ;  //2000 B2BC Tokens per 1 ETH
297       uint256 internal constant earlyExchangeRate = 2300 ;  //2300 B2BC Tokens per 1 ETH
298       uint256 internal constant vipExchangeRate =   2900 ;  //2900 B2BC Tokens per 1 ETH
299       uint256 internal constant vcExchangeRate  =   3000 ;  //3000 B2BC Tokens per 1 ETH
300       uint8   internal constant  DaysForEarlyDay = 11;
301       uint256 internal constant vipThrehold = 1000 * (10**18);
302            
303       // amount of eth crowded in wei
304       uint256 public weiCrowded;
305       event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
306 
307       //constructor
308       function B2BCCrowdsale() {          
309             owner = 0xeedA60D0C81836747f684cE48d53137d08392448;
310             b2bcToken = new B2BCToken(owner); 
311       }
312 
313       function setStartEndTime(uint256 _startTime, uint256 _endTime) onlyOwner{
314             require(_startTime >= now);
315             require(_endTime >= _startTime);
316             startTime = _startTime;
317             endTime = _endTime;
318       }
319       // fallback function can be used to buy tokens
320       function () payable {
321           buyTokens(msg.sender);
322       }
323 
324       // low level token purchase function
325       function buyTokens(address beneficiary) public payable {
326             require(beneficiary != 0x0);
327             require(validPurchase());
328 
329             uint256 weiAmount = msg.value;
330             weiCrowded = weiCrowded.add(weiAmount);
331 
332             
333             // calculate token amount to be created
334             uint256 rRate = rewardRate();
335             uint256 rewardB2BC = weiAmount.mul(rRate);
336             uint256 baseB2BC = weiAmount.mul(baseExchangeRate);
337            
338             // the rewardB2BC lock in 3 mounthes
339             if(rRate > baseExchangeRate) {
340                 b2bcToken.mintB2BC(beneficiary, rewardB2BC);  
341                 TokenPurchase(msg.sender, beneficiary, weiAmount, rewardB2BC);
342             } else {
343                 b2bcToken.mintB2BC(beneficiary, baseB2BC);  
344                 TokenPurchase(msg.sender, beneficiary, weiAmount, baseB2BC);
345             }
346 
347             forwardFunds();           
348       }
349 
350       /**
351        * reward rate for purchase
352        */
353       function rewardRate() internal constant returns (uint256) {
354             uint256 rate = baseExchangeRate;
355             if (now < startTime) {
356                 rate = vcExchangeRate;
357             } else {
358                 uint crowdIndex = (now - startTime) / (24 * 60 * 60); 
359                 if (crowdIndex < DaysForEarlyDay) {
360                     rate = earlyExchangeRate;
361                 } else {
362                     rate = baseExchangeRate;
363                 }
364 
365                 //vip
366                 if (msg.value >= vipThrehold) {
367                     rate = vipExchangeRate;
368                 }
369             }
370             return rate;
371       }
372 
373       // send ether to the fund collection wallet
374       function forwardFunds() internal {
375             owner.transfer(msg.value);
376       }
377 
378       // @return true if the transaction can buy tokens
379       function validPurchase() internal constant returns (bool) {
380             bool nonZeroPurchase = msg.value != 0;
381             bool noEnd = !hasEnded();
382             return  nonZeroPurchase && noEnd;
383       }
384 
385       // @return true if crowdsale event has ended
386       function hasEnded() public constant returns (bool) {
387             return (now > endTime) || b2bcToken.isSoleout(); 
388       }
389 }