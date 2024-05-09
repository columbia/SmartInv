1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract ERC20Basic {
6   uint256 public totalSupply;
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) balances;
85   
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94     require(_value <= balances[msg.sender]);
95 
96     // SafeMath.sub will throw if there is not enough balance.
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) public view returns (uint256 balance) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender) public view returns (uint256);
117   function transferFrom(address from, address to, uint256 value) public returns (bool);
118   function approve(address spender, uint256 value) public returns (bool);
119   event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 contract StandardToken is ERC20, BasicToken {
123 
124   mapping (address => mapping (address => uint256)) internal allowed;
125 
126 
127   /**
128    * @dev Transfer tokens from one address to another
129    * @param _from address The address which you want to send tokens from
130    * @param _to address The address which you want to transfer to
131    * @param _value uint256 the amount of tokens to be transferred
132    */
133   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134     require(_to != address(0));
135     require(_value <= balances[_from]);
136     require(_value <= allowed[_from][msg.sender]);
137 
138     balances[_from] = balances[_from].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141     Transfer(_from, _to, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    *
148    * Beware that changing an allowance with this method brings the risk that someone may use both the old
149    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152    * @param _spender The address which will spend the funds.
153    * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint256 _value) public returns (bool) {
156     allowed[msg.sender][_spender] = _value;
157     Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Function to check the amount of tokens that an owner allowed to a spender.
163    * @param _owner address The address which owns the funds.
164    * @param _spender address The address which will spend the funds.
165    * @return A uint256 specifying the amount of tokens still available for the spender.
166    */
167   function allowance(address _owner, address _spender) public view returns (uint256) {
168     return allowed[_owner][_spender];
169   }
170 
171   /**
172    * approve should be called when allowed[_spender] == 0. To increment
173    * allowed value is better to use this function to avoid 2 calls (and wait until
174    * the first transaction is mined)
175    * From MonolithDAO Token.sol
176    */
177   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
178     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
179     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 
183   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
184     uint oldValue = allowed[msg.sender][_spender];
185     if (_subtractedValue > oldValue) {
186       allowed[msg.sender][_spender] = 0;
187     } else {
188       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
189     }
190     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194 }
195 
196 contract TOKKA is StandardToken {
197     string public name = "StreamPay Token";
198     string public symbol = "STPY";
199     uint256 public decimals = 18;
200 
201    
202     function TOKKA() public {
203        totalSupply = 35000000 * 10**18;
204        balances[msg.sender] = totalSupply;
205     }
206 }
207 
208 
209 contract Crowdsale is Ownable {
210   using SafeMath for uint256;
211 
212    // The token being sold
213   TOKKA public token;
214 
215   // start and end timestamps where investments are allowed (both inclusive)
216   uint256 public startTime;
217   uint256 public endTime;
218 
219   // address where funds are collected
220   address public wallet;
221 
222   // how many token units a buyer gets per wei (500)
223   uint256 public rate ;
224 
225   // amount of raised money in wei
226   uint256 public weiRaised;
227   
228   // Our Goal is 68254.06111663644 Ethers Hardcap
229   uint256 public CAP = 68254061116636440000000;
230   
231   bool crowdsaleClosed = false;
232   
233   //Bonus Parameters
234   
235   uint256 public PreIcobonusEnds = 1535731200;
236   
237   uint256 public StgOnebonusEnds = 1538323200;
238   uint256 public StgTwobonusEnds = 1541001600;
239   uint256 public StgThreebonusEnds = 1543593600;
240   uint256 public StgFourbonusEnds = 1546272000;
241   
242   
243   
244 
245   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
246 
247 
248   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
249     require(_startTime >= now);
250     require(_endTime >= _startTime);
251     require(_rate > 0);
252     require(_wallet != address(0));
253 
254     startTime = _startTime;
255     endTime = _endTime;
256     rate = _rate;
257     wallet = _wallet;
258     
259     //Bonus Parametersss
260     
261     //StgOnebonusEnds = _bonusEnds;
262     
263     token = createTokenContract();
264   }
265 
266 // creates the token to be sold.
267 // override this method to have crowdsale of a specific mintable token.
268 function createTokenContract() internal returns (TOKKA) {
269     return new TOKKA();
270   }
271 
272 
273   // fallback function can be used to buy tokens
274   function() external payable {
275     buyTokens(msg.sender);
276   }
277 
278   // low level token purchase function
279 function buyTokens(address beneficiary) public payable {
280     require(beneficiary != address(0));
281     require(validPurchase());
282     require(!crowdsaleClosed);
283     
284     //Bounus Conditions
285     
286     
287     
288     if (now <= PreIcobonusEnds) {
289             rate = 667;
290          } 
291     
292      else if (now <= StgOnebonusEnds && now > PreIcobonusEnds) {
293             rate = 641;
294          }  
295     
296     else if (now <= StgTwobonusEnds && now > StgOnebonusEnds ) {
297             rate = 616;
298          }  
299      
300      else if (now <= StgThreebonusEnds && now > StgTwobonusEnds ) {
301             rate = 590;
302          } 
303          else if (now <= StgFourbonusEnds && now > StgThreebonusEnds ) {
304             rate = 564;
305          }
306     else{
307         rate = 513;
308     }
309      
310     
311 
312     uint256 weiAmount = msg.value;
313 
314     // calculate token amount to be created
315     uint256 tokens = weiAmount.mul(rate);
316 
317     // update state
318     weiRaised = weiRaised.add(weiAmount);
319 
320     // transfer tokens purchased 
321     //ERC20(token).transfer(this, tokens);
322     //StandardToken(token).transfer(this, tokens);
323     token.transfer(beneficiary, tokens);
324 
325     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
326 
327     forwardFunds();
328 }
329 
330 
331   function forwardFunds() internal {
332     wallet.transfer(msg.value);
333   }
334 
335 
336   function validPurchase() internal view returns (bool) {
337     bool withinPeriod = now >= startTime && now <= endTime;
338     bool nonZeroPurchase = msg.value != 0;
339     return withinPeriod && nonZeroPurchase;
340   }
341 
342 
343   function hasEnded() public view returns (bool) {
344     return now > endTime;
345   }
346   
347   function GoalReached() public view returns (bool) {
348     return (weiRaised >= CAP);
349   }
350   
351   function Pause() public onlyOwner
352   {
353        //if (weiRaised >= CAP){
354            
355         //}
356         require(weiRaised >= CAP);
357         
358         crowdsaleClosed = true;
359   }
360   
361   function Play() public onlyOwner
362   {
363        //if (weiRaised >= CAP){
364            
365         //}
366         require(crowdsaleClosed == true);
367         
368         crowdsaleClosed = false;
369   }
370 
371 }