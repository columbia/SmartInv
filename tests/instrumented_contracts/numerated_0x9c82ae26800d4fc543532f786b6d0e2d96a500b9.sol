1 pragma solidity ^0.4.16;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) constant returns (uint256);
45   function transfer(address to, uint256 value) returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) returns (bool);
57   function approve(address spender, uint256 value) returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   /**
73   * @dev transfer token for a specified address
74   * @param _to The address to transfer to.
75   * @param _value The amount to be transferred.
76   */
77   function transfer(address _to, uint256 _value) returns (bool) {
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) constant returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) allowed;
105 
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
148    * @return A uint256 specifing the amount of tokens still avaible for the spender.
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
162   address public owner;
163 
164 
165   /**
166    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
167    * account.
168    */
169   function Ownable() {
170     owner = msg.sender;
171   }
172 
173 
174   /**
175    * @dev Throws if called by any account other than the owner.
176    */
177   modifier onlyOwner() {
178     require(msg.sender == owner);
179     _;
180   }
181 
182 
183   /**
184    * @dev Allows the current owner to transfer control of the contract to a newOwner.
185    * @param newOwner The address to transfer ownership to.
186    */
187   function transferOwnership(address newOwner) onlyOwner {
188     if (newOwner != address(0)) {
189       owner = newOwner;
190     }
191   }
192 
193 }
194 
195 
196 /**
197  * @title Pausable
198  * @dev Base contract which allows children to implement an emergency stop mechanism.
199  */
200 contract Pausable is Ownable {
201   event Pause();
202   event Unpause();
203 
204   bool public paused = false;
205 
206 
207   /**
208    * @dev modifier to allow actions only when the contract IS paused
209    */
210   modifier whenNotPaused() {
211     require(!paused);
212     _;
213   }
214 
215   /**
216    * @dev modifier to allow actions only when the contract IS NOT paused
217    */
218   modifier whenPaused {
219     require(paused);
220     _;
221   }
222 
223   /**
224    * @dev called by the owner to pause, triggers stopped state
225    */
226   function pause() onlyOwner whenNotPaused returns (bool) {
227     paused = true;
228     Pause();
229     return true;
230   }
231 
232   /**
233    * @dev called by the owner to unpause, returns to normal state
234    */
235   function unpause() onlyOwner whenPaused returns (bool) {
236     paused = false;
237     Unpause();
238     return true;
239   }
240 }
241 
242 
243 contract Hgt is StandardToken, Pausable {
244 
245     string public name = "HelloGold Token";
246     string public symbol = "HGT";
247     uint256 public decimals = 18;
248 
249 }
250 
251 contract Hgs {
252     struct CsAction {
253       bool        passedKYC;
254       bool        blocked;
255     }
256 
257 
258     /* This creates an array with all balances */
259     mapping (address => CsAction) public permissions;
260     mapping (address => uint256)  public deposits;
261 }
262 
263 contract HelloGoldRound1Point5 is Ownable {
264 
265     using SafeMath for uint256;
266     bool    public  started;
267     uint256 public  startTime = 1505995200; // September 21, 2017 8:00:00 PM GMT+08:00
268     uint256 public  endTime = 1507204800;  // October 5, 2017 8:00:00 PM GMT+08:00
269     uint256 public  weiRaised;
270     uint256 public  lastSaleInHGT = 170000000 * 10 ** 8 ;
271     uint256 public  hgtSold;
272     uint256 public  r15Backers;
273 
274     uint256 public  rate = 12489 * 10 ** 8;
275     Hgs     public  hgs = Hgs(0x574FB6d9d090042A04D0D12a4E87217f8303A5ca);
276     Hgt     public  hgt = Hgt(0xba2184520A1cC49a6159c57e61E1844E085615B6);
277     address public  multisig = 0xC03281aF336e2C25B41FF893A0e6cE1a932B23AF; // who gets the ether
278     address public  reserves = 0xC03281aF336e2C25B41FF893A0e6cE1a932B23AF; // who has the HGT pool
279 
280 //////   //    /////     BIG BLOODY REMINDER   The code below is for testing purposes
281 //   //  //   //   //    BIG BLOODY REMINDER   If you are not the developer of this code
282 /////    //   //         BIG BLOODY REMINDER   And you can see this, SHOUT coz it should 
283 //  ///  //   //  ///    BIG BLOODY REMINDER   Not be here in production and all hell will
284 //  ///  //   //   //    BIG BLOODY REMINDER   Break loose, the gates of hell will open and
285 //////   //    //////    BIG BLOODY REMINDER   Winged monstors and daemons will roam free  
286 
287     // bool testing = true;
288 
289     // function testingOnly() {
290     //     if (!testing)
291     //         return;
292     //     hgs = Hgs(0x5aB936795ECEeF9D34198d3AAEe1bA32b8f34B6b);
293     //     hgt = Hgt(0x38738A39d1EbdA813237C34122677a5925454ec8);
294     //     multisig = 0x3D1F6Cd19d58767E3680c4D60D0b3355331F7b46;
295     //     reserves = 0x1bdc4085d0222F459B92fa23FfA570f493e6E763;
296     // }
297 
298 
299 //////   //    /////     BIG BLOODY REMINDER   The code above is for testing purposes
300 //   //  //   //   //    BIG BLOODY REMINDER   If you are not the developer of this code
301 /////    //   //         BIG BLOODY REMINDER   And you can see this, SHOUT coz it should 
302 //  ///  //   //  ///    BIG BLOODY REMINDER   Not be here in production and all hell will
303 //  ///  //   //   //    BIG BLOODY REMINDER   Break loose, the gates of hell will open and
304 //////   //    //////    BIG BLOODY REMINDER   Winged monstors and daemons will roam free  
305 
306 
307 
308 
309     mapping (address => uint256) public deposits;
310     mapping (address => bool) public upgraded;
311     mapping (address => uint256) public upgradeHGT;
312 
313     modifier validPurchase() {
314         bool passedKYC;
315         bool blocked;
316         require (msg.value >= 1 finney);
317         require (started || (now > startTime));
318         require (now <= endTime);
319         require (hgtSold < lastSaleInHGT);
320         (passedKYC,blocked) = hgs.permissions(msg.sender); 
321         require (passedKYC);
322         require (!blocked);
323 
324 
325         _;
326     }
327 
328  
329     function HelloGoldRound1Point5() {
330         // handle the guy who had three proxy accounts
331         deposits[0xA3f59EbC3bf8Fa664Ce12e2f841Fe6556289F053] = 30 ether; // so sum balance = 40 ether
332         upgraded[0xA3f59EbC3bf8Fa664Ce12e2f841Fe6556289F053] = true;
333         upgraded[0x00f07DA332aa7751F9170430F6e4b354568c5B40] = true;
334         upgraded[0x938CdFb9B756A5b6c8f3fBA535EC17700edD4c15] = true;
335         upgraded[0xa6a777ed720746FBE7b6b908584CD3D533d307D3] = true;
336 
337         // testingOnly(); // removing this allows me to keep the BIG COMMENTS to see if Robin ever hears about it :-p
338     }
339 
340     function reCap(uint256 newCap) onlyOwner {
341         lastSaleInHGT = newCap;
342     }
343 
344     function startAndSetStopTime(uint256 period) onlyOwner {
345         started = true;
346         if (period == 0)
347             endTime = now + 2 weeks;
348         else
349             endTime = now + period;
350     }
351 
352     // Need to check cases
353     //  1   already upgraded
354     //  2   first deposit (no R1)
355     //  3   R1 < 10, first R1.5 takes over 10 ether
356     //  4   R1 <= 10, second R1.5 takes over 10 ether
357     function upgradeOnePointZeroBalances() internal {
358     // 1
359         if (upgraded[msg.sender]) {
360             log0("account already upgraded");
361             return;
362         }
363     // 2
364         uint256 deposited = hgs.deposits(msg.sender);
365         if (deposited == 0)
366             return;
367     // 3
368         deposited = deposited.add(deposits[msg.sender]);
369         if (deposited.add(msg.value) < 10 ether)
370             return;
371     // 4
372         uint256 hgtBalance = hgt.balanceOf(msg.sender);
373         uint256 upgradedAmount = deposited.mul(rate).div(1 ether);
374         if (hgtBalance < upgradedAmount) {
375             uint256 diff = upgradedAmount.sub(hgtBalance);
376             hgt.transferFrom(reserves,msg.sender,diff);
377             hgtSold = hgtSold.add(diff);
378             upgradeHGT[msg.sender] = upgradeHGT[msg.sender].add(diff);
379             log0("upgraded R1 to 20%");
380         }
381         upgraded[msg.sender] = true;
382     }
383 
384     function () payable validPurchase {
385         if (deposits[msg.sender] == 0)
386             r15Backers++;
387         upgradeOnePointZeroBalances();
388         deposits[msg.sender] = deposits[msg.sender].add(msg.value);
389         
390         buyTokens(msg.sender,msg.value);
391     }
392 
393     function buyTokens(address recipient, uint256 valueInWei) internal {
394         uint256 numberOfTokens = valueInWei.mul(rate).div(1 ether);
395         weiRaised = weiRaised.add(valueInWei);
396         require(hgt.transferFrom(reserves,recipient,numberOfTokens));
397         hgtSold = hgtSold.add(numberOfTokens);
398         multisig.transfer(msg.value);
399     }
400 
401     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
402         token.transfer(owner, amount);
403     }
404 
405 }