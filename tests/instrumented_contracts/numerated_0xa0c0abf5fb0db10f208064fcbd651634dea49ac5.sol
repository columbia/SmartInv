1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     emit OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44     if (a == 0) {
45       return 0;
46     }
47     uint256 c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers, truncating the quotient.
54   */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   /**
71   * @dev Adds two numbers, throws on overflow.
72   */
73   function add(uint256 a, uint256 b) internal pure returns (uint256) {
74     uint256 c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract BasicToken is ERC20Basic {
88   using SafeMath for uint256;
89 
90   mapping(address => uint256) balances;
91 
92   uint256 totalSupply_;
93 
94   /**
95   * @dev total number of tokens in existence
96   */
97   function totalSupply() public view returns (uint256) {
98     return totalSupply_;
99   }
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) public returns (bool) {
107     require(_to != address(0));
108     require(_value <= balances[msg.sender]);
109 
110     // SafeMath.sub will throw if there is not enough balance.
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     emit Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256 balance) {
123     return balances[_owner];
124   }
125 
126 }
127 
128 contract BurnableToken is BasicToken {
129 
130   event Burn(address indexed burner, uint256 value);
131 
132   /**
133    * @dev Burns a specific amount of tokens.
134    * @param _value The amount of token to be burned.
135    */
136   function burn(uint256 _value) public {
137     require(_value <= balances[msg.sender]);
138     // no need to require value <= totalSupply, since that would imply the
139     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
140 
141     address burner = msg.sender;
142     balances[burner] = balances[burner].sub(_value);
143     totalSupply_ = totalSupply_.sub(_value);
144     emit Burn(burner, _value);
145     emit Transfer(burner, address(0), _value);
146   }
147 }
148 
149 contract ERC20 is ERC20Basic {
150   function allowance(address owner, address spender) public view returns (uint256);
151   function transferFrom(address from, address to, uint256 value) public returns (bool);
152   function approve(address spender, uint256 value) public returns (bool);
153   event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     emit Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     emit Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 contract MintableToken is StandardToken, Ownable {
245   event Mint(address indexed to, uint256 amount);
246   event MintFinished();
247 
248   bool public mintingFinished = false;
249 
250 
251   modifier canMint() {
252     require(!mintingFinished);
253     _;
254   }
255 
256   /**
257    * @dev Function to mint tokens
258    * @param _to The address that will receive the minted tokens.
259    * @param _amount The amount of tokens to mint.
260    * @return A boolean that indicates if the operation was successful.
261    */
262   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
263     totalSupply_ = totalSupply_.add(_amount);
264     balances[_to] = balances[_to].add(_amount);
265     emit Mint(_to, _amount);
266     emit Transfer(address(0), _to, _amount);
267     return true;
268   }
269 
270   /**
271    * @dev Function to stop minting new tokens.
272    * @return True if the operation was successful.
273    */
274   function finishMinting() onlyOwner canMint public returns (bool) {
275     mintingFinished = true;
276     emit MintFinished();
277     return true;
278   }
279 }
280 
281 contract CryptohomaToken is StandardToken, MintableToken, BurnableToken {
282     
283     string public name = "CryptohomaToken";
284     string public symbol = "HOMA";
285     uint public decimals = 18;
286 
287     using SafeMath for uint256;
288 
289     // Amount of wei raised
290     uint256 public weiRaised;
291 
292     uint start = 1525132801;
293 
294     uint period = 31;
295 
296     uint256 public totalSupply = 50000000 * 1 ether;
297 
298     uint256 public totalMinted;
299 
300     uint256 public presale_tokens = 1562500 * 1 ether;
301     uint public bounty_percent = 5;
302     uint public airdrop_percent = 2;
303     uint public organizers_percent = 15;
304 
305     address public multisig = 0xcBF6E568F588Fc198312F9587e660CbdF64DB262;
306     address public presale = 0x42d8388E55A527Fa84f29A4D8768B923Dd8628E3;
307     address public bounty = 0x27986d9CB66Dc4b60911D1E10f2DB6Ca3459A075;
308     address public airdrop = 0xE0D7bd9a4ce64049A187b0097f86F6ae49bD19b5;
309     address public organizer1 = 0x4FE7F4AA0d221827112090Ad7B90c7D8B9c08cc5;
310     address public organizer2 = 0x6A7fd6308791B198739679F571bD981F7aA3a239;
311     address public organizer3 = 0xCb04445D08830db4BFEB8F94fb71422C2FBAB17F;
312     address public organizer4 = 0x4A44960b49816b8cB77de28FCB512AD903d62FEb;
313     address public organizer5 = 0xEB27178C637336c3A6243aA312C3f197B54155f1;
314     address public organizer6 = 0x84ae1B4E8c008dCbEfF91A923EA216a5fA718e25;
315     address public organizer7 = 0x6de044c56D91b880C73C8e667C37A2B2A977FC3a;
316     address public organizer8 = 0x5b3a08DaAcC4167e9432dCF56D3fcd147006192c;
317 
318     uint256 public rate = 0.000011 * 1 ether;
319     uint256 public rate2 = 0.000015 * 1 ether;
320 
321     function CryptohomaToken() public {
322 
323         totalMinted = totalMinted.add(presale_tokens);
324         super.mint(presale, presale_tokens);
325 
326         uint256 tokens = totalSupply.mul(bounty_percent).div(100);
327         totalMinted = totalMinted.add(tokens);
328         super.mint(bounty, tokens);
329 
330         tokens = totalSupply.mul(airdrop_percent).div(100);
331         totalMinted = totalMinted.add(tokens);
332         super.mint(airdrop, tokens);
333 
334         tokens = totalSupply.mul(organizers_percent).div(100);
335         totalMinted = totalMinted.add(tokens);
336         tokens = tokens.div(8);
337         super.mint(organizer1, tokens);
338         super.mint(organizer2, tokens);
339         super.mint(organizer3, tokens);
340         super.mint(organizer4, tokens);
341         super.mint(organizer5, tokens);
342         super.mint(organizer6, tokens);
343         super.mint(organizer7, tokens);
344         super.mint(organizer8, tokens);
345 
346     }
347 
348 
349     /**
350     * Event for token purchase logging
351     * @param purchaser who paid for the tokens
352     * @param beneficiary who got the tokens
353     * @param value weis paid for purchase
354     * @param amount amount of tokens purchased
355     */
356     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
357 
358     /**
359     * @dev fallback function ***DO NOT OVERRIDE***
360     */
361     function () external payable {
362         buyTokens(msg.sender);
363     }
364 
365     /**
366     * @dev low level token purchase ***DO NOT OVERRIDE***
367     * @param _beneficiary Address performing the token purchase
368     */
369     function buyTokens(address _beneficiary) public payable {
370 
371         uint256 weiAmount = msg.value;
372         _preValidatePurchase(_beneficiary, weiAmount);
373 
374         // calculate token amount to be created
375         uint256 tokens = _getTokenAmount(weiAmount);
376 
377         // update state
378         weiRaised = weiRaised.add(weiAmount);
379 
380         _processPurchase(_beneficiary, tokens);
381         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
382 
383         _forwardFunds();
384     }
385 
386     /**
387     * @dev Override to extend the way in which ether is converted to tokens.
388     * @param _weiAmount Value in wei to be converted into tokens
389     * @return Number of tokens that can be purchased with the specified _weiAmount
390     */
391     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
392         return _weiAmount / rate * 1 ether;
393     }
394 
395     /**
396     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations. ***ПЕРЕОПРЕДЕЛЕНО***
397     * @param _beneficiary Address performing the token purchase
398     * @param _weiAmount Value in wei involved in the purchase
399     */
400     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
401         require(_beneficiary != address(0));
402         require(_weiAmount != 0);
403 
404         require(now > start && now < start + period * 1 days);
405 
406         if (now > start.add(15 * 1 days)) {
407             rate = rate2;
408         }
409 
410         uint256 tokens = _getTokenAmount(_weiAmount);
411         totalMinted = totalMinted.add(tokens);
412 
413         require(totalSupply >= totalMinted);
414 
415     }
416 
417     /**
418     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
419     * @param _beneficiary Address performing the token purchase
420     * @param _tokenAmount Number of tokens to be emitted
421     */
422     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
423         super.transfer(_beneficiary, _tokenAmount);
424     }
425 
426     /**
427     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
428     * @param _beneficiary Address receiving the tokens
429     * @param _tokenAmount Number of tokens to be purchased
430     */
431     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
432         _deliverTokens(_beneficiary, _tokenAmount);
433     }
434 
435     /**
436     * @dev Determines how ETH is stored/forwarded on purchases.
437     */
438     function _forwardFunds() internal {
439         multisig.transfer(msg.value);
440     }
441 
442 }