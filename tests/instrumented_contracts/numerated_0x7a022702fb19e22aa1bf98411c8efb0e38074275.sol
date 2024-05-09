1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 library SafeMath {
46   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
47     uint256 c = a * b;
48     assert(a == 0 || c / a == b);
49     return c;
50   }
51 
52   function div(uint256 a, uint256 b) internal constant returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return c;
57   }
58 
59   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   function add(uint256 a, uint256 b) internal constant returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 contract ERC20Basic {
72   uint256 public totalSupply;
73   function balanceOf(address who) public constant returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 contract ERC20 is ERC20Basic {
83   function allowance(address owner, address spender) public constant returns (uint256);
84   function transferFrom(address from, address to, uint256 value) public returns (bool);
85   function approve(address spender, uint256 value) public returns (bool);
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public constant returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 /**
121  * @title Standard ERC20 token
122  *
123  * @dev Implementation of the basic standard token.
124  * @dev https://github.com/ethereum/EIPs/issues/20
125  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
126  */
127 contract StandardToken is ERC20, BasicToken {
128 
129   mapping (address => mapping (address => uint256)) allowed;
130 
131 
132   /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint256 the amount of tokens to be transferred
137    */
138   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140 
141     uint256 _allowance = allowed[_from][msg.sender];
142 
143     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
144     // require (_value <= _allowance);
145 
146     balances[_from] = balances[_from].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     allowed[_from][msg.sender] = _allowance.sub(_value);
149     Transfer(_from, _to, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    *
156    * Beware that changing an allowance with this method brings the risk that someone may use both the old
157    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160    * @param _spender The address which will spend the funds.
161    * @param _value The amount of tokens to be spent.
162    */
163   function approve(address _spender, uint256 _value) public returns (bool) {
164     allowed[msg.sender][_spender] = _value;
165     Approval(msg.sender, _spender, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Function to check the amount of tokens that an owner allowed to a spender.
171    * @param _owner address The address which owns the funds.
172    * @param _spender address The address which will spend the funds.
173    * @return A uint256 specifying the amount of tokens still available for the spender.
174    */
175   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
176     return allowed[_owner][_spender];
177   }
178 
179   /**
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    */
185   function increaseApproval (address _spender, uint _addedValue)
186     returns (bool success) {
187     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192   function decreaseApproval (address _spender, uint _subtractedValue)
193     returns (bool success) {
194     uint oldValue = allowed[msg.sender][_spender];
195     if (_subtractedValue > oldValue) {
196       allowed[msg.sender][_spender] = 0;
197     } else {
198       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199     }
200     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204 }
205 
206 contract MintableToken is StandardToken, Ownable {
207   event Mint(address indexed to, uint256 amount);
208   event MintFinished();
209 
210   bool public mintingFinished = false;
211 
212 
213   modifier canMint() {
214     require(!mintingFinished);
215     _;
216   }
217 
218   /**
219    * @dev Function to mint tokens
220    * @param _to The address that will receive the minted tokens.
221    * @param _amount The amount of tokens to mint.
222    * @return A boolean that indicates if the operation was successful.
223    */
224   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
225     totalSupply = totalSupply.add(_amount);
226     balances[_to] = balances[_to].add(_amount);
227     Mint(_to, _amount);
228     Transfer(0x0, _to, _amount);
229     return true;
230   }
231 
232   /**
233    * @dev Function to stop minting new tokens.
234    * @return True if the operation was successful.
235    */
236   function finishMinting() onlyOwner public returns (bool) {
237     mintingFinished = true;
238     MintFinished();
239     return true;
240   }
241 }
242 
243 /**
244  * @title BetrToken
245  * @dev Betr ERC20 Token that can be minted.
246  * It is meant to be used in sether crowdsale contract.
247  */
248 contract BetrToken is MintableToken {
249 
250     string public constant name = "BETer";
251     string public constant symbol = "BTR";
252     uint8 public constant decimals = 18;
253 
254     function getTotalSupply() public returns (uint256) {
255         return totalSupply;
256     }
257 }
258 
259 /**
260  * @title BetrBaseCrowdsale
261  * @dev BetrBaseCrowdsale is a base contract for managing a sether token crowdsale.
262  */
263 contract BetrCrowdsale is Ownable {
264   using SafeMath for uint256;
265 
266     // The token being sold
267     BetrToken public token;
268 
269     // address where funds are collected
270     address public wallet;
271 
272     // how many finney per token
273     uint256 public rate;
274 
275     // amount of raised money in wei
276     uint256 public weiRaised;
277 
278     uint256 public constant TEAM_LIMIT = 225 * (10 ** 6) * (10 ** 18);
279     uint256 public constant PRESALE_LIMIT = 275 * (10 ** 6) * (10 ** 18);
280     uint public constant PRESALE_BONUS = 30;
281     uint saleStage = 0; //0: presale with bonus, !0: normal sale without bonus
282     bool public isFinalized = false;
283 
284     /**
285     * event for token purchase logging
286     * @param purchaser who paid for the tokens
287     * @param beneficiary who got the tokens
288     * @param value weis paid for purchase
289     * @param amount amount of tokens purchased
290     */
291     event BetrTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
292 
293     function BetrCrowdsale(uint256 _rate, address _wallet, address _tok_addr) {
294         require(_rate > 0);
295         require(_wallet != address(0));
296 
297         token = BetrToken(_tok_addr);
298         rate = _rate;
299         wallet = _wallet;
300     }
301 
302     // fallback function can be used to buy tokens
303     function () payable {
304         buyTokens(msg.sender);
305     }
306 
307     // low level token purchase function
308     function buyTokens(address beneficiary) public payable {
309         require(beneficiary != address(0));
310         require(validPurchase());
311         require(!isFinalized);
312 
313         uint256 weiAmount = msg.value;
314 
315         // calculate token amount to be created
316         uint256 tokens = computeTokens(weiAmount);
317 
318         require(isWithinTokenAllocLimit(tokens));
319 
320         // update state
321         weiRaised = weiRaised.add(weiAmount);
322 
323         token.mint(beneficiary, tokens);
324 
325         BetrTokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
326 
327         forwardFunds();
328     }
329 
330 
331     // send ether to the fund collection wallet
332     function forwardFunds() internal {
333         wallet.transfer(msg.value);
334     }
335 
336     // @return true if the transaction can buy tokens
337     function validPurchase() internal constant returns (bool) {
338         bool nonZeroPurchase = msg.value != 0;
339         return nonZeroPurchase;
340     }
341     
342     //Override this method with token distribution strategy
343     function computeTokens(uint256 weiAmount) internal returns (uint256) {
344         //To be overriden
345         uint256 appliedBonus = 0;
346 	    if (saleStage == 0) {
347              appliedBonus = PRESALE_BONUS;
348         }
349 
350         return weiAmount.mul(100).mul(100 + appliedBonus).div(rate);
351     }
352 
353     //Override this method with token limitation strategy
354     function isWithinTokenAllocLimit(uint256 _tokens) internal returns (bool) {
355         //To be overriden
356         return token.getTotalSupply().add(_tokens) <= PRESALE_LIMIT;
357     }
358 
359     function setStage(uint stage) onlyOwner public {
360         require(!isFinalized);
361         saleStage = stage;
362     }
363 
364     /**
365     * @dev Must be called after crowdsale ends, to do some extra finalization
366     * work. Calls the contract's finalization function.
367     */
368     function finalize() onlyOwner public {
369         require(!isFinalized);
370     
371         uint256 ownerShareTokens = TEAM_LIMIT;
372         token.mint(wallet, ownerShareTokens);
373         
374         isFinalized = true;
375     }
376 }