1 pragma solidity ^0.4.11;
2 
3 //Creadit sikuma@github
4 
5 
6 /**
7  * @title SafeMath
8     * @dev Math operations with safety checks that throw on error
9        */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title Ownable
38     * @dev The Ownable contract has an owner address, and provides basic authorization control 
39        * functions, this simplifies the implementation of "user permissions". 
40           */
41 contract Ownable {
42   address public owner;
43 
44 
45   /** 
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47         * account.
48              */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner. 
56         */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65         * @param newOwner The address to transfer ownership to. 
66              */
67   function transferOwnership(address newOwner) onlyOwner {
68     if (newOwner != address(0)) {
69       owner = newOwner;
70     }
71   }
72 
73 }
74 
75 
76 /**
77  * @title ERC20Basic
78     * @dev Simpler version of ERC20 interface
79        * @dev see https://github.com/ethereum/EIPs/issues/179
80           */
81 contract ERC20Basic {
82   uint256 public totalSupply;
83   function balanceOf(address who) constant returns (uint256);
84   function transfer(address to, uint256 value) returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 /**
89  * @title Basic token
90     * @dev Basic version of StandardToken, with no allowances. 
91        */
92 contract BasicToken is ERC20Basic {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96 
97   /**
98   * @dev transfer token for a specified address
99       * @param _to The address to transfer to.
100           * @param _value The amount to be transferred.
101               */
102   function transfer(address _to, uint256 _value) returns (bool) {
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111       * @param _owner The address to query the the balance of. 
112           * @return An uint256 representing the amount owned by the passed address.
113               */
114   function balanceOf(address _owner) constant returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 
121 /**
122  * @title ERC20 interface
123     * @dev see https://github.com/ethereum/EIPs/issues/20
124        */
125 contract ERC20 is ERC20Basic {
126   function allowance(address owner, address spender) constant returns (uint256);
127   function transferFrom(address from, address to, uint256 value) returns (bool);
128   function approve(address spender, uint256 value) returns (bool);
129   event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 /**
133  * @title Standard ERC20 token
134     *
135       * @dev Implementation of the basic standard token.
136          * @dev https://github.com/ethereum/EIPs/issues/20
137             * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
138                */
139 contract StandardToken is ERC20, BasicToken {
140 
141   mapping (address => mapping (address => uint256)) allowed;
142 
143 
144   /**
145    * @dev Transfer tokens from one address to another
146         * @param _from address The address which you want to send tokens from
147              * @param _to address The address which you want to transfer to
148                   * @param _value uint256 the amout of tokens to be transfered
149                        */
150   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
151     var _allowance = allowed[_from][msg.sender];
152 
153     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
154     // require (_value <= _allowance);
155 
156     balances[_to] = balances[_to].add(_value);
157     balances[_from] = balances[_from].sub(_value);
158     allowed[_from][msg.sender] = _allowance.sub(_value);
159     Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
165         * @param _spender The address which will spend the funds.
166              * @param _value The amount of tokens to be spent.
167                   */
168   function approve(address _spender, uint256 _value) returns (bool) {
169 
170     // To change the approve amount you first have to reduce the addresses`
171     //  allowance to zero by calling `approve(_spender, 0)` if it is not
172     //  already 0 to mitigate the race condition described here:
173     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
175 
176     allowed[msg.sender][_spender] = _value;
177     Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183         * @param _owner address The address which owns the funds.
184              * @param _spender address The address which will spend the funds.
185                   * @return A uint256 specifing the amount of tokens still avaible for the spender.
186                        */
187   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
188     return allowed[_owner][_spender];
189   }
190 
191 }
192 
193 
194 /**
195  * @title Mintable token
196     * @dev Simple ERC20 Token example, with mintable token creation
197        * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
198           * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
199              */
200 
201 contract MintableToken is StandardToken, Ownable {
202   event Mint(address indexed to, uint256 amount);
203   event MintFinished();
204 
205   bool public mintingFinished = false;
206 
207 
208   modifier canMint() {
209     require(!mintingFinished);
210     _;
211   }
212 
213   /**
214    * @dev Function to mint tokens
215         * @param _to The address that will recieve the minted tokens.
216              * @param _amount The amount of tokens to mint.
217                   * @return A boolean that indicates if the operation was successful.
218                        */
219   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
220     totalSupply = totalSupply.add(_amount);
221     balances[_to] = balances[_to].add(_amount);
222     Mint(_to, _amount);
223     return true;
224   }
225 
226   /**
227    * @dev Function to stop minting new tokens.
228         * @return True if the operation was successful.
229              */
230   function finishMinting() onlyOwner returns (bool) {
231     mintingFinished = true;
232     MintFinished();
233     return true;
234   }
235 }
236 
237 contract LOLPreToken is StandardToken, Ownable {
238     using SafeMath for uint256;
239 
240     // Token Info.
241     string  public constant name = "LOLPresale Token";
242     string  public constant symbol = "LOLP";
243     uint8   public constant decimals = 18;
244 
245     // Sale period.
246     uint256 public startDate;
247     uint256 public endDate;
248 
249     // Token Cap for each rounds
250     uint256 public saleCap;
251 
252     // Address where funds are collected.
253     address public wallet;
254 
255     // Amount of raised money in wei.
256     uint256 public weiRaised;
257 
258     // Loldex user ID
259     mapping(address => bytes32) public lolpreUserIDs;
260 
261     // Event
262     event TokenPurchase(address indexed purchaser, uint256 value,
263                         uint256 amount);
264     event PreICOTokenPushed(address indexed buyer, uint256 amount);
265     event UserIDChanged(address owner, bytes32 user_id);
266 
267     // Modifiers
268     modifier uninitialized() {
269         require(wallet == 0x0);
270         _;
271     }
272 
273     function LOLPreToken() {
274     }
275 
276     function initialize(address _wallet, uint256 _start, uint256 _end,
277                         uint256 _saleCap, uint256 _totalSupply)
278                         onlyOwner uninitialized {
279         require(_start >= getCurrentTimestamp());
280         require(_start < _end);
281         require(_wallet != 0x0);
282         require(_totalSupply > _saleCap);
283 
284         startDate = _start;
285         endDate = _end;
286         saleCap = _saleCap;
287         wallet = _wallet;
288         totalSupply = _totalSupply;
289 
290         balances[wallet] = _totalSupply.sub(saleCap);
291         balances[0x1] = saleCap;
292     }
293 
294     function supply() internal returns (uint256) {
295         return balances[0x1];
296     }
297 
298     function getCurrentTimestamp() internal returns (uint256) {
299         return now;
300     }
301 
302     function getRateAt(uint256 at) constant returns (uint256) {
303         if (at < startDate) {
304             return 0;        
305         } else {
306             return 2720; //LOLP@ 0.05
307         }
308     }
309 
310     // Fallback function can be used to buy tokens
311     function () payable {
312         buyTokens(msg.sender, msg.value);
313     }
314 
315     // For pushing pre-ICO records
316     function push(address buyer, uint256 amount) onlyOwner {
317         require(balances[wallet] >= amount);
318 
319         uint256 actualRate = 2720;  // pre-ICO has also fixed rate of 2720
320         uint256 weiAmount = amount.div(actualRate);
321         uint256 updatedWeiRaised = weiRaised.add(weiAmount);
322 
323         // Transfer
324         balances[wallet] = balances[wallet].sub(amount);
325         balances[buyer] = balances[buyer].add(amount);
326         PreICOTokenPushed(buyer, amount);
327 
328         // Update state.
329         weiRaised = updatedWeiRaised;
330     }
331 
332     function buyTokens(address sender, uint256 value) internal {
333         require(saleActive());
334         require(value >= 1 ether);
335 
336         uint256 weiAmount = value;
337         uint256 updatedWeiRaised = weiRaised.add(weiAmount);
338 
339         // Calculate token amount to be purchased
340         uint256 actualRate = getRateAt(getCurrentTimestamp());
341         uint256 amount = weiAmount.mul(actualRate);
342         
343 
344         // We have enough token to sale
345         require(supply() >= amount);
346 
347         // Transfer
348         balances[0x1] = balances[0x1].sub(amount);
349         balances[sender] = balances[sender].add(amount);
350         TokenPurchase(sender, weiAmount, amount);
351 
352         // Update state.
353         weiRaised = updatedWeiRaised;
354 
355         // Forward the fund to fund collection wallet.
356         wallet.transfer(msg.value);
357     }
358 
359     function finalize() onlyOwner {
360         require(!saleActive());
361 
362         // Transfer the rest of token to LOLdex
363         balances[wallet] = balances[wallet].add(balances[0x1]);
364         balances[0x1] = 0;
365     }
366 
367     function saleActive() public constant returns (bool) {
368         return (getCurrentTimestamp() >= startDate &&
369                 getCurrentTimestamp() < endDate && supply() > 0);
370     }
371 
372     function setUserID(bytes32 user_id) {
373         lolpreUserIDs[msg.sender] = user_id;
374         UserIDChanged(msg.sender, user_id);
375     }
376     
377     // This function will destroy all LOLP and alocate 1-to-1 LOL token 
378      function destroyToken() onlyOwner {
379           require(!saleActive());
380           
381           // Transfer the rest of token to LOLdex
382           balances[wallet] = balances[wallet].add(balances[0x1]);
383           balances[0x1] = 0;
384           selfdestruct(wallet);
385         
386     }
387 }