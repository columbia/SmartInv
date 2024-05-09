1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 /**
48  * @title ERC20Basic
49  * @dev Simpler version of ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/179
51  */
52 contract ERC20Basic {
53   function totalSupply() public view returns (uint256);
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) public view returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     // SafeMath.sub will throw if there is not enough balance.
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 
117 
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is ERC20, BasicToken {
127 
128   mapping (address => mapping (address => uint256)) internal allowed;
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public view returns (uint256) {
172     return allowed[_owner][_spender];
173   }
174 
175   /**
176    * @dev Increase the amount of tokens that an owner allowed to a spender.
177    *
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _addedValue The amount of tokens to increase the allowance by.
184    */
185   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191   /**
192    * @dev Decrease the amount of tokens that an owner allowed to a spender.
193    *
194    * approve should be called when allowed[_spender] == 0. To decrement
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _subtractedValue The amount of tokens to decrease the allowance by.
200    */
201   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
202     uint oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212 }
213 
214 contract BoostoToken is StandardToken {
215     using SafeMath for uint256;
216 
217     struct HourlyReward{
218         uint passedHours;
219         uint percent;
220     }
221 
222     string public name = "Boosto";
223     string public symbol = "BST";
224     uint8 public decimals = 18;
225 
226     // 1B total supply
227     uint256 public totalSupply = 1000000000 * (uint256(10) ** decimals);
228     
229     uint256 public totalRaised; // total ether raised (in wei)
230 
231     uint256 public startTimestamp; // timestamp after which ICO will start
232     
233     // 1 month = 1 * 30 * 24 * 60 * 60
234     uint256 public durationSeconds;
235 
236     // the ICO ether max cap (in wei)
237     uint256 public maxCap;
238 
239     
240      // Minimum Transaction Amount(0.1 ETH)
241     uint256 public minAmount = 0.1 ether;
242 
243     // 1 ETH = X BST
244     uint256 public coinsPerETH = 1000;
245 
246     /**
247      * hourlyRewards[hours from start timestamp] = percent
248      * for example hourlyRewards[10] = 20 -- 20% more coins for first 10 hoours after ICO start
249      */
250     HourlyReward[] public hourlyRewards;
251 
252     /**
253      * if true, everyone can participate in ICOs.
254      * otherwise just whitelisted wallets can participate
255      */
256     bool isPublic = false;
257 
258     /**
259      * mapping to save whitelisted users
260      */
261     mapping(address => bool) public whiteList;
262     
263     /**
264      * Address which will receive raised funds 
265      * and owns the total supply of tokens
266      */
267     address public fundsWallet = 0x776EFa46B4b39Aa6bd2D65ce01480B31042aeAA5;
268 
269     /**
270      * Address which will manage whitelist
271      * and ICOs
272      */
273     address private adminWallet = 0xc6BD816331B1BddC7C03aB51215bbb9e2BE62dD2;    
274     /**
275      * @dev Constructor
276      */
277     constructor() public{
278         //fundsWallet = msg.sender;
279 
280         startTimestamp = now;
281 
282         // ICO is not active by default. Admin can set it later
283         durationSeconds = 0;
284 
285         //initially assign all tokens to the fundsWallet
286         balances[fundsWallet] = totalSupply;
287         Transfer(0x0, fundsWallet, totalSupply);
288     }
289 
290     /**
291      * @dev Checks if an ICO is open
292      */
293     modifier isIcoOpen() {
294         require(isIcoInProgress());
295         _;
296     }
297 
298     /**
299      * @dev Checks if the investment amount is greater than min amount
300      */
301     modifier checkMin(){
302         require(msg.value >= minAmount);
303         _;
304     }
305 
306     /**
307      * @dev Checks if msg.sender can participate in the ICO
308      */
309     modifier isWhiteListed(){
310         require(isPublic || whiteList[msg.sender]);
311         _;
312     }
313 
314     /**
315      * @dev Checks if msg.sender is admin
316      * both fundsWallet and adminWallet are considered as admin
317      */
318 
319     modifier isAdmin(){
320         require(msg.sender == fundsWallet || msg.sender == adminWallet);
321         _;
322     }
323 
324     /**
325      * @dev Payable fallback. This function will be called
326      * when investors send ETH to buy BST
327      */
328     function() public isIcoOpen checkMin isWhiteListed payable{
329         totalRaised = totalRaised.add(msg.value);
330 
331         uint256 tokenAmount = calculateTokenAmount(msg.value);
332         balances[fundsWallet] = balances[fundsWallet].sub(tokenAmount);
333         balances[msg.sender] = balances[msg.sender].add(tokenAmount);
334 
335         Transfer(fundsWallet, msg.sender, tokenAmount);
336 
337         // immediately transfer ether to fundsWallet
338         fundsWallet.transfer(msg.value);
339     }
340 
341     /**
342      * @dev Calculates token amount for investors based on weekly rewards
343      * and msg.value
344      * @param weiAmount ETH amount in wei amount
345      * @return Total BST amount
346      */
347     function calculateTokenAmount(uint256 weiAmount) public constant returns(uint256) {
348         uint256 tokenAmount = weiAmount.mul(coinsPerETH);
349         // setting rewards is possible only for 4 weeks
350         for (uint i = 0; i < hourlyRewards.length; i++) {
351             if (now <= startTimestamp + (hourlyRewards[i].passedHours * 1 hours)) {
352                 return tokenAmount.mul(100+hourlyRewards[i].percent).div(100);    
353             }
354         }
355         return tokenAmount;
356     }
357 
358     /**
359      * @dev Update WhiteList for an address
360      * @param _address The address
361      * @param _value Boolean to represent the status
362      */
363     function adminUpdateWhiteList(address _address, bool _value) public isAdmin{
364         whiteList[_address] = _value;
365     }
366 
367 
368     /**
369      * @dev Allows admin to launch a new ICO
370      * @param _startTimestamp Start timestamp in epochs
371      * @param _durationSeconds ICO time in seconds(1 day=24*60*60)
372      * @param _coinsPerETH BST price in ETH(1 ETH = ? BST)
373      * @param _maxCap Max ETH capture in wei amount
374      * @param _minAmount Min ETH amount per user in wei amount
375      * @param _isPublic Boolean to represent that the ICO is public or not
376      */
377     function adminAddICO(
378         uint256 _startTimestamp,
379         uint256 _durationSeconds, 
380         uint256 _coinsPerETH,
381         uint256 _maxCap,
382         uint256 _minAmount, 
383         uint[] _rewardHours,
384         uint256[] _rewardPercents,
385         bool _isPublic
386         ) public isAdmin{
387 
388         // we can't add a new ICO when an ICO is already in progress
389         assert(!isIcoInProgress());
390         assert(_rewardPercents.length == _rewardHours.length);
391 
392         startTimestamp = _startTimestamp;
393         durationSeconds = _durationSeconds;
394         coinsPerETH = _coinsPerETH;
395         maxCap = _maxCap;
396         minAmount = _minAmount;
397 
398         hourlyRewards.length = 0;
399         for(uint i=0; i < _rewardHours.length; i++){
400             hourlyRewards[hourlyRewards.length++] = HourlyReward({
401                     passedHours: _rewardHours[i],
402                     percent: _rewardPercents[i]
403                 });
404         }
405 
406         isPublic = _isPublic;
407         // reset totalRaised
408         totalRaised = 0;
409     }
410 
411     /**
412      * @dev Return true if an ICO is already in progress;
413      * otherwise returns false
414      */
415     function isIcoInProgress() public constant returns(bool){
416         if(now < startTimestamp){
417             return false;
418         }
419         if(now > (startTimestamp + durationSeconds)){
420             return false;
421         }
422         if(totalRaised >= maxCap){
423             return false;
424         }
425         return true;
426     }
427 }