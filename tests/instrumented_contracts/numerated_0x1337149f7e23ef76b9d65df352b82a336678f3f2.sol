1 pragma solidity ^0.4.21;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
57     if (a == 0) {
58       return 0;
59     }
60     c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     // uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return a / b;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
87     c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
187     require(_to != address(0));
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     emit Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     emit Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(address _owner, address _spender) public view returns (uint256) {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 // File: contracts/TokenVesting.sol
264 
265 contract TokenVesting is Ownable {
266     using SafeMath for uint256;
267 
268     // -- Parameters
269 
270     // Token to vest.
271     address public token;
272 
273     // Total token to vest.
274     uint256 public totalToken;
275 
276     // Vest starting time.
277     uint256 public startingTime;
278 
279     // Number of stages to vest.
280     uint256 public nStages;
281 
282     // Length of the vesting contract.
283     uint256 public period;
284 
285     // Vest interval.
286     uint256 public vestInterval;
287 
288     // The address of beneficiary.
289     address public beneficiary;
290 
291     // Whether or not the contract is revoked.
292     bool revoked;
293 
294     // -- Events
295     event Claimed(uint256 amount);
296 
297     constructor() public {
298     }
299 
300     function initialize(
301         address _token,
302         uint256 _startingTime,
303         uint256 _nStages,
304         uint256 _period,
305         uint256 _vestInterval,
306         address _beneficiary
307     ) onlyOwner {
308         // nStages: number of nStages.
309         // period: the length of the vest (unit in months).
310         // vestInterval: interval between each release.
311         //
312         // For example, given:
313         //  startingTime = xxx
314         //  nStages = 4
315         //  period = 24
316         //  vestInterval = 1
317         //
318         // This results in the vesting rule:
319         // 1. The first vest happens in 24 / 4 = 6 months, vest 1 / 4 of total
320         //    Tokens.
321         // 2. The rest of the tokens are released every month (vestInterval),
322         //    amount = total * (3 / 4) / 18
323 
324         require(token == 0x0);
325         require(_nStages > 0 && _period > 0 && _vestInterval > 0);
326         require(_period % _nStages == 0);
327         require(_period % _vestInterval == 0);
328 
329         token = _token;
330         startingTime = _startingTime;
331         nStages = _nStages;
332         period = _period;
333         vestInterval = _vestInterval;
334         beneficiary = _beneficiary;
335 
336         StandardToken vestToken = StandardToken(token);
337         totalToken = vestToken.allowance(msg.sender, this);
338         vestToken.transferFrom(msg.sender, this, totalToken);
339     }
340 
341     function getCurrentTimestamp() internal view returns (uint256) {
342         return now;
343     }
344 
345     function balance() public view returns (uint256) {
346         StandardToken vestToken = StandardToken(token);
347         return vestToken.balanceOf(this);
348     }
349 
350     function claimable() public view returns (uint256) {
351         uint256 elapsedSecs = getCurrentTimestamp() - startingTime;
352         if (elapsedSecs <= 0) {
353             return 0;
354         }
355 
356         uint256 currentPeriod = elapsedSecs.div(30 days);
357         currentPeriod = currentPeriod.div(vestInterval).mul(vestInterval);
358 
359         // Can not claim when we have not pass the 1st period.
360         if (currentPeriod < period / nStages) {
361             return 0;
362         }
363 
364         if (currentPeriod > period)  {
365             currentPeriod = period;
366         }
367 
368         // Calculate Number of token the user can claim at current time.
369         uint256 totalClaimable = totalToken.mul(currentPeriod).div(period);
370         uint256 totalLeftOvers = totalToken.sub(totalClaimable);
371         uint256 claimable_ = balance().sub(totalLeftOvers);
372 
373         return claimable_;
374     }
375 
376     function claim() public {
377         require(!revoked);
378 
379         uint256 claimable_ = claimable();
380         require(claimable_ > 0);
381 
382         StandardToken vestToken = StandardToken(token);
383         vestToken.transfer(beneficiary, claimable_);
384 
385         emit Claimed(claimable_);
386     }
387 
388     function revoke() onlyOwner public {
389         require(!revoked);
390 
391         StandardToken vestToken = StandardToken(token);
392         vestToken.transfer(owner, balance());
393         revoked = true;
394     }
395 
396     function () payable {
397         revert();
398     }
399 }