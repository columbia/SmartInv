1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
29         return a >= b ? a : b;
30     }
31 
32   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
33       return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
37       return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
41       return a < b ? a : b;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     owner = newOwner;
73     OwnershipTransferred(owner, newOwner);
74   }
75 
76 }
77 
78 contract ERC20Basic {
79     uint256 public totalSupply;
80     function balanceOf(address _owner) public constant returns (uint256 balance);
81     function transfer(address _to, uint256 _value) public returns (bool success);
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83 }
84 
85 contract BasicToken is ERC20Basic {
86     using SafeMath for uint256;
87 
88     mapping(address => uint256) balances;
89 
90     /**
91     * @dev Transfer token for a specified address.
92     * @param _to address The address to transfer to.
93     * @param _value uint256 The amount to be transferred.
94     */
95     function transfer(address _to, uint256 _value) public returns (bool) {
96         require(_to != address(0));
97 
98         // SafeMath.sub will throw if there is not enough balance.
99         balances[msg.sender] = balances[msg.sender].sub(_value);
100         balances[_to] = balances[_to].add(_value);
101         Transfer(msg.sender, _to, _value);
102         return true;
103     }
104 
105     /**
106     * @dev Gets the balance of the specified address.
107     * @param _owner address The address to query the the balance of.
108     * @return An uint256 representing the amount owned by the passed address.
109     */
110     function balanceOf(address _owner) public constant returns (uint256 balance) {
111         return balances[_owner];
112     }
113 
114 }
115 
116 contract ERC20 is ERC20Basic {
117     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
118     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
119     function approve(address _spender, uint256 _value) public returns (bool success);
120     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
121 }
122 
123 contract ERC677 is ERC20 {
124     function transferAndCall(address _to, uint256 _value, bytes _data) public returns (bool success);
125     
126     event ERC677Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
127 }
128 
129 contract ERC677Receiver {
130     function onTokenTransfer(address _sender, uint _value, bytes _data) public returns (bool success);
131 }
132 
133 contract ERC677Token is ERC677 {
134 
135     /**
136     * @dev Transfer token to a contract address with additional data if the recipient is a contact.
137     * @param _to address The address to transfer to.
138     * @param _value uint256 The amount to be transferred.
139     * @param _data bytes The extra data to be passed to the receiving contract.
140     */
141     function transferAndCall(address _to, uint256 _value, bytes _data) public returns (bool success) {
142         require(super.transfer(_to, _value));
143         ERC677Transfer(msg.sender, _to, _value, _data);
144         if (isContract(_to)) {
145             contractFallback(_to, _value, _data);
146         }
147         return true;
148     }
149 
150     // PRIVATE
151 
152     function contractFallback(address _to, uint256 _value, bytes _data) private {
153         ERC677Receiver receiver = ERC677Receiver(_to);
154         require(receiver.onTokenTransfer(msg.sender, _value, _data));
155     }
156 
157     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
158     function isContract(address _addr) private view returns (bool hasCode) {
159         uint length;
160         assembly { length := extcodesize(_addr) }
161         return length > 0;
162     }
163 }
164 
165 contract StandardToken is ERC20, BasicToken {
166 
167     mapping (address => mapping (address => uint256)) allowed;
168 
169     /**
170     * @dev Transfer tokens from one address to another.
171     * @param _from address The address which you want to send tokens from.
172     * @param _to address The address which you want to transfer to.
173     * @param _value uint256 the amout of tokens to be transfered.
174     */
175     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176         require(_to != address(0));
177 
178         var _allowance = allowed[_from][msg.sender];
179 
180         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
181         // require (_value <= _allowance);
182 
183         balances[_to] = balances[_to].add(_value);
184         balances[_from] = balances[_from].sub(_value);
185         allowed[_from][msg.sender] = _allowance.sub(_value);
186         Transfer(_from, _to, _value);
187         return true;
188     }
189 
190     /**
191     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
192     * @param _spender address The address which will spend the funds.
193     * @param _value uint256 The amount of tokens to be spent.
194     */
195     function approve(address _spender, uint256 _value) public returns (bool) {
196         // To change the approve amount you first have to reduce the addresses`
197         //  allowance to zero by calling `approve(_spender, 0)` if it is not
198         //  already 0 to mitigate the race condition described here:
199         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
201 
202         allowed[msg.sender][_spender] = _value;
203         Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 
207     /**
208     * @dev Function to check the amount of tokens that an owner allowed to a spender.
209     * @param _owner address The address which owns the funds.
210     * @param _spender address The address which will spend the funds.
211     * @return A uint256 specifing the amount of tokens still avaible for the spender.
212     */
213     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
214         return allowed[_owner][_spender];
215     }
216 }
217 
218 contract MDToken is StandardToken, ERC677Token, Ownable {
219     using SafeMath for uint256;
220 
221     // Token metadata
222     string public constant name = "Measurable Data Token";
223     string public constant symbol = "MDT";
224     uint256 public constant decimals = 18;
225     uint256 public constant maxSupply = 10 * (10**8) * (10**decimals); // 1 billion MDT
226 
227     // 240 million MDT reserved for MDT team (24%)
228     uint256 public constant TEAM_TOKENS_RESERVED = 240 * (10**6) * (10**decimals);
229 
230     // 150 million MDT reserved for user growth (15%)
231     uint256 public constant USER_GROWTH_TOKENS_RESERVED = 150 * (10**6) * (10**decimals);
232 
233     // 110 million MDT reserved for early investors (11%)
234     uint256 public constant INVESTORS_TOKENS_RESERVED = 110 * (10**6) * (10**decimals);
235 
236     // 200 million MDT reserved for bonus giveaway (20%)
237     uint256 public constant BONUS_TOKENS_RESERVED = 200 * (10**6) * (10**decimals);
238 
239     // Token sale wallet address, contains tokens for private sale, early bird and bonus giveaway
240     address public tokenSaleAddress;
241 
242     // MDT team wallet address
243     address public mdtTeamAddress;
244 
245     // User Growth Pool wallet address
246     address public userGrowthAddress;
247 
248     // Early Investors wallet address
249     address public investorsAddress;
250 
251     // MDT team foundation wallet address, contains tokens which were not sold during token sale and unraised bonus
252     address public mdtFoundationAddress;
253 
254     event Burn(address indexed _burner, uint256 _value);
255 
256     /// @dev Reverts if address is 0x0 or this token address
257     modifier validRecipient(address _recipient) {
258         require(_recipient != address(0) && _recipient != address(this));
259         _;
260     }
261 
262     /**
263     * @dev MDToken contract constructor.
264     * @param _tokenSaleAddress address The token sale address.
265     * @param _mdtTeamAddress address The MDT team address.
266     * @param _userGrowthAddress address The user growth address.
267     * @param _investorsAddress address The investors address.
268     * @param _mdtFoundationAddress address The MDT Foundation address.
269     * @param _presaleAmount uint256 Amount of MDT tokens sold during presale.
270     * @param _earlybirdAmount uint256 Amount of MDT tokens to sold during early bird.
271     */
272     function MDToken(
273         address _tokenSaleAddress,
274         address _mdtTeamAddress,
275         address _userGrowthAddress,
276         address _investorsAddress,
277         address _mdtFoundationAddress,
278         uint256 _presaleAmount,
279         uint256 _earlybirdAmount)
280         public
281     {
282 
283         require(_tokenSaleAddress != address(0));
284         require(_mdtTeamAddress != address(0));
285         require(_userGrowthAddress != address(0));
286         require(_investorsAddress != address(0));
287         require(_mdtFoundationAddress != address(0));
288 
289         tokenSaleAddress = _tokenSaleAddress;
290         mdtTeamAddress = _mdtTeamAddress;
291         userGrowthAddress = _userGrowthAddress;
292         investorsAddress = _investorsAddress;
293         mdtFoundationAddress = _mdtFoundationAddress;
294 
295         // issue tokens to token sale, MDT team, etc
296         uint256 saleAmount = _presaleAmount.add(_earlybirdAmount).add(BONUS_TOKENS_RESERVED);
297         mint(tokenSaleAddress, saleAmount);
298         mint(mdtTeamAddress, TEAM_TOKENS_RESERVED);
299         mint(userGrowthAddress, USER_GROWTH_TOKENS_RESERVED);
300         mint(investorsAddress, INVESTORS_TOKENS_RESERVED);
301 
302         // issue remaining tokens to MDT Foundation
303         uint256 remainingTokens = maxSupply.sub(totalSupply);
304         if (remainingTokens > 0) {
305             mint(mdtFoundationAddress, remainingTokens);
306         }
307     }
308 
309     /**
310     * @dev Mint MDT tokens. (internal use only)
311     * @param _to address Address to send minted MDT to.
312     * @param _amount uint256 Amount of MDT tokens to mint.
313     */
314     function mint(address _to, uint256 _amount)
315         private
316         validRecipient(_to)
317         returns (bool)
318     {
319         require(totalSupply.add(_amount) <= maxSupply);
320         totalSupply = totalSupply.add(_amount);
321         balances[_to] = balances[_to].add(_amount);
322 
323         Transfer(0x0, _to, _amount);
324         return true;
325     }
326 
327     /**
328     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
329     * @param _spender address The address which will spend the funds.
330     * @param _value uint256 The amount of tokens to be spent.
331     */
332     function approve(address _spender, uint256 _value)
333         public
334         validRecipient(_spender)
335         returns (bool)
336     {
337         return super.approve(_spender, _value);
338     }
339 
340     /**
341     * @dev Transfer token for a specified address.
342     * @param _to address The address to transfer to.
343     * @param _value uint256 The amount to be transferred.
344     */
345     function transfer(address _to, uint256 _value)
346         public
347         validRecipient(_to)
348         returns (bool)
349     {
350         return super.transfer(_to, _value);
351     }
352 
353     /**
354     * @dev Transfer token to a contract address with additional data if the recipient is a contact.
355     * @param _to address The address to transfer to.
356     * @param _value uint256 The amount to be transferred.
357     * @param _data bytes The extra data to be passed to the receiving contract.
358     */
359     function transferAndCall(address _to, uint256 _value, bytes _data)
360         public
361         validRecipient(_to)
362         returns (bool success)
363     {
364         return super.transferAndCall(_to, _value, _data);
365     }
366 
367     /**
368     * @dev Transfer tokens from one address to another.
369     * @param _from address The address which you want to send tokens from.
370     * @param _to address The address which you want to transfer to.
371     * @param _value uint256 the amout of tokens to be transfered.
372     */
373     function transferFrom(address _from, address _to, uint256 _value)
374         public
375         validRecipient(_to)
376         returns (bool)
377     {
378         return super.transferFrom(_from, _to, _value);
379     }
380 
381     /**
382      * @dev Burn tokens. (token owner only)
383      * @param _value uint256 The amount to be burned.
384      * @return always true.
385      */
386     function burn(uint256 _value)
387         public
388         onlyOwner
389         returns (bool)
390     {
391         balances[msg.sender] = balances[msg.sender].sub(_value);
392         totalSupply = totalSupply.sub(_value);
393         Burn(msg.sender, _value);
394         return true;
395     }
396 
397     /**
398      * @dev Burn tokens on behalf of someone. (token owner only)
399      * @param _from address The address of the owner of the token.
400      * @param _value uint256 The amount to be burned.
401      * @return always true.
402      */
403     function burnFrom(address _from, uint256 _value)
404         public
405         onlyOwner
406         returns(bool)
407     {
408         var _allowance = allowed[_from][msg.sender];
409         balances[_from] = balances[_from].sub(_value);
410         allowed[_from][msg.sender] = _allowance.sub(_value);
411         totalSupply = totalSupply.sub(_value);
412         Burn(_from, _value);
413         return true;
414     }
415 
416     /**
417      * @dev Transfer to owner any tokens send by mistake to this contract. (token owner only)
418      * @param token ERC20 The address of the token to transfer.
419      * @param amount uint256 The amount to be transfered.
420      */
421     function emergencyERC20Drain(ERC20 token, uint256 amount)
422         public
423         onlyOwner
424     {
425         token.transfer(owner, amount);
426     }
427 
428     /**
429      * @dev Change to a new token sale address. (token owner only)
430      * @param _tokenSaleAddress address The new token sale address.
431      */
432     function changeTokenSaleAddress(address _tokenSaleAddress)
433         public
434         onlyOwner
435         validRecipient(_tokenSaleAddress)
436     {
437         tokenSaleAddress = _tokenSaleAddress;
438     }
439 
440     /**
441      * @dev Change to a new MDT team address. (token owner only)
442      * @param _mdtTeamAddress address The new MDT team address.
443      */
444     function changeMdtTeamAddress(address _mdtTeamAddress)
445         public
446         onlyOwner
447         validRecipient(_mdtTeamAddress)
448     {
449         mdtTeamAddress = _mdtTeamAddress;
450     }
451 
452     /**
453      * @dev Change to a new user growth address. (token owner only)
454      * @param _userGrowthAddress address The new user growth address.
455      */
456     function changeUserGrowthAddress(address _userGrowthAddress)
457         public
458         onlyOwner
459         validRecipient(_userGrowthAddress)
460     {
461         userGrowthAddress = _userGrowthAddress;
462     }
463 
464     /**
465      * @dev Change to a new investors address. (token owner only)
466      * @param _investorsAddress address The new investors address.
467      */
468     function changeInvestorsAddress(address _investorsAddress)
469         public
470         onlyOwner
471         validRecipient(_investorsAddress)
472     {
473         investorsAddress = _investorsAddress;
474     }
475 
476     /**
477      * @dev Change to a new MDT Foundation address. (token owner only)
478      * @param _mdtFoundationAddress address The new MDT Foundation address.
479      */
480     function changeMdtFoundationAddress(address _mdtFoundationAddress)
481         public
482         onlyOwner
483         validRecipient(_mdtFoundationAddress)
484     {
485         mdtFoundationAddress = _mdtFoundationAddress;
486     }
487 }