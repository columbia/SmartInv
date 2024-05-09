1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   function Ownable() public {
69     owner = msg.sender;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address newOwner) public onlyOwner {
85     require(newOwner != address(0));
86     emit OwnershipTransferred(owner, newOwner);
87     owner = newOwner;
88   }
89 
90 }
91 
92 /**
93  * @title SKYFChain Tokens
94  * @dev SKYFChain Token, ERC20 implementation, contract based on Zeppelin contracts:
95  * Ownable, BasicToken, StandardToken, ERC20Basic, Burnable
96 */
97 contract SKYFToken is Ownable {
98     using SafeMath for uint256;
99     
100     enum State {Active, Finalized}
101     State public state = State.Active;
102 
103 
104     /**
105      * @dev ERC20 descriptor variables
106      */
107     string public constant name = "SKYFchain";
108     string public constant symbol = "SKYFT";
109     uint8 public decimals = 18;
110 
111     uint256 public constant startTime = 1534334400;
112     uint256 public constant airdropTime = startTime + 365 days;
113     uint256 public constant shortAirdropTime = startTime + 182 days;
114     
115     
116     uint256 public totalSupply_ = 1200 * 10 ** 24;
117 
118     uint256 public constant crowdsaleSupply = 528 * 10 ** 24;
119     uint256 public constant networkDevelopmentSupply = 180 * 10 ** 24;
120     uint256 public constant communityDevelopmentSupply = 120 * 10 ** 24;
121     uint256 public constant reserveSupply = 114 * 10 ** 24; 
122     uint256 public constant bountySupply = 18 * 10 ** 24;
123     uint256 public constant teamSupply = 240 * 10 ** 24;
124     
125 
126     address public crowdsaleWallet;
127     address public networkDevelopmentWallet;
128     address public communityDevelopmentWallet;
129     address public reserveWallet;
130     address public bountyWallet;
131     address public teamWallet;
132 
133     address public siteAccount;
134 
135     mapping (address => mapping (address => uint256)) allowed;
136     mapping (address => uint256) balances;
137     mapping (address => uint256) airdrop;
138     mapping (address => uint256) shortenedAirdrop;
139 
140         
141 
142     event Transfer(address indexed from, address indexed to, uint256 value);
143     event Approval(address indexed owner, address indexed spender, uint256 value);
144     event Burn(address indexed burner, uint256 value);
145     event Airdrop(address indexed beneficiary, uint256 amount);
146 
147     /**
148      * @dev Contract constructor
149      */
150     constructor(address _crowdsaleWallet
151                 , address _networkDevelopmentWallet
152                 , address _communityDevelopmentWallet
153                 , address _reserveWallet
154                 , address _bountyWallet
155                 , address _teamWallet
156                 , address _siteAccount) public {
157         require(_crowdsaleWallet != address(0));
158         require(_networkDevelopmentWallet != address(0));
159         require(_communityDevelopmentWallet != address(0));
160         require(_reserveWallet != address(0));
161         require(_bountyWallet != address(0));
162         require(_teamWallet != address(0));
163 
164         require(_siteAccount != address(0));
165 
166         crowdsaleWallet = _crowdsaleWallet;
167         networkDevelopmentWallet = _networkDevelopmentWallet;
168         communityDevelopmentWallet = _communityDevelopmentWallet;
169         reserveWallet = _reserveWallet;
170         bountyWallet = _bountyWallet;
171         teamWallet = _teamWallet;
172 
173         siteAccount = _siteAccount;
174 
175         // Issue 528 millions crowdsale tokens
176         _issueTokens(crowdsaleWallet, crowdsaleSupply);
177 
178         // Issue 180 millions network development tokens
179         _issueTokens(networkDevelopmentWallet, networkDevelopmentSupply);
180 
181         // Issue 120 millions community development tokens
182         _issueTokens(communityDevelopmentWallet, communityDevelopmentSupply);
183 
184         // Issue 114 millions reserve tokens
185         _issueTokens(reserveWallet, reserveSupply);
186 
187         // Issue 18 millions bounty tokens
188         _issueTokens(bountyWallet, bountySupply);
189 
190         // Issue 240 millions team tokens
191         _issueTokens(teamWallet, teamSupply);
192 
193         allowed[crowdsaleWallet][siteAccount] = crowdsaleSupply;
194         emit Approval(crowdsaleWallet, siteAccount, crowdsaleSupply);
195         allowed[crowdsaleWallet][owner] = crowdsaleSupply;
196         emit Approval(crowdsaleWallet, owner, crowdsaleSupply);
197     }
198 
199     function _issueTokens(address _to, uint256 _amount) internal {
200         require(balances[_to] == 0);
201         balances[_to] = balances[_to].add(_amount);
202         emit Transfer(address(0), _to, _amount);
203     }
204 
205     function _airdropUnlocked(address _who) internal view returns (bool) {
206         return now > airdropTime
207         || (now > shortAirdropTime && airdrop[_who] == 0) 
208         || !isAirdrop(_who);
209     }
210 
211     modifier erc20Allowed() {
212         require(state == State.Finalized || msg.sender == owner|| msg.sender == siteAccount || msg.sender == crowdsaleWallet);
213         require (_airdropUnlocked(msg.sender));
214         _;
215     }
216 
217     modifier onlyOwnerOrSiteAccount() {
218         require(msg.sender == owner || msg.sender == siteAccount);
219         _;
220     }
221     
222     function setSiteAccountAddress(address _address) public onlyOwner {
223         require(_address != address(0));
224 
225         uint256 allowance = allowed[crowdsaleWallet][siteAccount];
226         allowed[crowdsaleWallet][siteAccount] = 0;
227         emit Approval(crowdsaleWallet, siteAccount, 0);
228         allowed[crowdsaleWallet][_address] = allowed[crowdsaleWallet][_address].add(allowance);
229         emit Approval(crowdsaleWallet, _address, allowed[crowdsaleWallet][_address]);
230         siteAccount = _address;
231     }
232 
233     /**
234      * @dev Gets the balance of the specified address.
235      * @param _owner The address to query the the balance of.
236      * @return An uint256 representing the amount owned by the passed address.
237     */
238     function balanceOf(address _owner) public view returns (uint256 balance) {
239         return balances[_owner];
240     }
241 
242 
243     /**
244      * @dev total number of tokens in existence
245     */
246     function totalSupply() public view returns (uint256) {
247         return totalSupply_;
248     }
249 
250     /**
251     * @dev transfer token for a specified address
252     * @param _to The address to transfer to.
253     * @param _value The amount to be transferred.
254     */
255     function transfer(address _to, uint256 _value) public erc20Allowed returns (bool) {
256         require(_to != address(0));
257         require(_value <= balances[msg.sender]);
258         require(_airdropUnlocked(_to));
259 
260         
261         balances[msg.sender] = balances[msg.sender].sub(_value);
262         balances[_to] = balances[_to].add(_value);
263 
264 
265         emit Transfer(msg.sender, _to, _value);
266         return true;
267     }
268 
269     /**
270      * @dev Transfer tokens from one address to another
271      * @param _from address The address which you want to send tokens from
272      * @param _to address The address which you want to transfer to
273      * @param _value uint256 the amount of tokens to be transferred
274      */
275     function transferFrom(address _from, address _to, uint256 _value) public erc20Allowed returns (bool) {
276         return _transferFrom(msg.sender, _from, _to, _value);
277     }
278 
279     function _transferFrom(address _who, address _from, address _to, uint256 _value) internal returns (bool) {
280         require(_to != address(0));
281         require(_value <= balances[_from]);
282         require(_airdropUnlocked(_to) || _from == crowdsaleWallet);
283 
284         uint256 _allowance = allowed[_from][_who];
285 
286         require(_value <= _allowance);
287 
288         balances[_from] = balances[_from].sub(_value);
289         balances[_to] = balances[_to].add(_value);
290         allowed[_from][_who] = _allowance.sub(_value);
291 
292         _recalculateAirdrop(_to);
293 
294         emit Transfer(_from, _to, _value);
295         return true;
296     }
297 
298     /**
299      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
300      *
301      * Beware that changing an allowance with this method brings the risk that someone may use both the old
302      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
303      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
304      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
305      * @param _spender The address which will spend the funds.
306      * @param _value The amount of tokens to be spent.
307      */
308     function approve(address _spender, uint256 _value) public erc20Allowed returns (bool) {
309         allowed[msg.sender][_spender] = _value;
310         emit Approval(msg.sender, _spender, _value);
311         return true;
312     }
313 
314 
315     /**
316      * @dev Function to check the amount of tokens that an owner allowed to a spender.
317      * @param _owner address The address which owns the funds.
318      * @param _spender address The address which will spend the funds.
319      * @return A uint256 specifying the amount of tokens still available for the spender.
320      */
321     function allowance(address _owner, address _spender) public view returns (uint256) {
322         return allowed[_owner][_spender];
323     }
324 
325     /**
326      * @dev Increase the amount of tokens that an owner allowed to a spender.
327      *
328      * approve should be called when allowed[_spender] == 0. To increment
329      * allowed value is better to use this function to avoid 2 calls (and wait until
330      * the first transaction is mined)
331      * From MonolithDAO Token.sol
332      * @param _spender The address which will spend the funds.
333      * @param _addedValue The amount of tokens to increase the allowance by.
334     */
335     function increaseApproval(address _spender, uint256 _addedValue) public erc20Allowed returns (bool) {
336         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
337         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
338         return true;
339     }
340 
341     /**
342      * @dev Decrease the amount of tokens that an owner allowed to a spender.
343      *
344      * approve should be called when allowed[_spender] == 0. To decrement
345      * allowed value is better to use this function to avoid 2 calls (and wait until
346      * the first transaction is mined)
347      * From MonolithDAO Token.sol
348      * @param _spender The address which will spend the funds.
349      * @param _subtractedValue The amount of tokens to decrease the allowance by.
350     */
351     function decreaseApproval(address _spender, uint256 _subtractedValue) public erc20Allowed returns (bool) {
352         uint256 oldValue = allowed[msg.sender][_spender];
353         if (_subtractedValue > oldValue) {
354             allowed[msg.sender][_spender] = 0;
355         } else {
356             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
357         }
358         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
359         return true;
360     }
361 
362     /**
363      * @dev Burns a specific amount of tokens.
364      * @param _value The amount of token to be burned.
365     */
366     function burn(uint256 _value) public erc20Allowed {
367         _burn(msg.sender, _value);
368     }
369 
370     function _burn(address _who, uint256 _value) internal {
371         require(_value <= balances[_who]);
372         // no need to require value <= totalSupply, since that would imply the
373         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
374 
375         balances[_who] = balances[_who].sub(_value);
376         totalSupply_ = totalSupply_.sub(_value);
377         emit Burn(_who, _value);
378         emit Transfer(_who, address(0), _value);
379     }
380 
381     function finalize() public onlyOwner {
382         require(state == State.Active);
383         require(now > startTime);
384         state = State.Finalized;
385 
386         uint256 crowdsaleBalance = balanceOf(crowdsaleWallet);
387 
388         uint256 burnAmount = networkDevelopmentSupply.mul(crowdsaleBalance).div(crowdsaleSupply);
389         _burn(networkDevelopmentWallet, burnAmount);
390 
391         burnAmount = communityDevelopmentSupply.mul(crowdsaleBalance).div(crowdsaleSupply);
392         _burn(communityDevelopmentWallet, burnAmount);
393 
394         burnAmount = reserveSupply.mul(crowdsaleBalance).div(crowdsaleSupply);
395         _burn(reserveWallet, burnAmount);
396 
397         burnAmount = bountySupply.mul(crowdsaleBalance).div(crowdsaleSupply);
398         _burn(bountyWallet, burnAmount);
399 
400         burnAmount = teamSupply.mul(crowdsaleBalance).div(crowdsaleSupply);
401         _burn(teamWallet, burnAmount);
402 
403         _burn(crowdsaleWallet, crowdsaleBalance);
404     }
405     
406     function addAirdrop(address _beneficiary, uint256 _amount) public onlyOwnerOrSiteAccount {
407         require(_beneficiary != crowdsaleWallet);
408         require(_beneficiary != networkDevelopmentWallet);
409         require(_beneficiary != communityDevelopmentWallet);
410         require(_beneficiary != bountyWallet);
411         require(_beneficiary != siteAccount);
412         
413 
414         //Don't allow to block already bought tokens with airdrop.
415         require(balances[_beneficiary] == 0 || isAirdrop(_beneficiary));
416 
417         if (shortenedAirdrop[_beneficiary] != 0) {
418             shortenedAirdrop[_beneficiary] = shortenedAirdrop[_beneficiary].add(_amount);
419         }
420         else {
421             airdrop[_beneficiary] = airdrop[_beneficiary].add(_amount);
422         }
423         
424         _transferFrom(msg.sender, crowdsaleWallet, _beneficiary, _amount);
425         emit Airdrop(_beneficiary, _amount);
426     }
427 
428     function isAirdrop(address _who) public view returns (bool result) {
429         return airdrop[_who] > 0 || shortenedAirdrop[_who] > 0;
430     }
431 
432     function _recalculateAirdrop(address _who) internal {
433         if(state == State.Active && isAirdrop(_who)) {
434             uint256 initialAmount = airdrop[_who];
435             if (initialAmount > 0) {
436                 uint256 rate = balances[_who].div(initialAmount);
437                 if (rate >= 4) {
438                     delete airdrop[_who];
439                 } else if (rate >= 2) {
440                     delete airdrop[_who];
441                     shortenedAirdrop[_who] = initialAmount;
442                 }
443             } else {
444                 initialAmount = shortenedAirdrop[_who];
445                 if (initialAmount > 0) {
446                     rate = balances[_who].div(initialAmount);
447                     if (rate >= 4) {
448                         delete shortenedAirdrop[_who];
449                     }
450                 }
451             }
452         }
453     }
454    
455 }