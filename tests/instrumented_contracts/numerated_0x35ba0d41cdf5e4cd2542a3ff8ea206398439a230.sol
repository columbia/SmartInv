1 pragma solidity ^0.4.18;
2 /**
3 * SMARTRealty
4 * ERC-20 Token Standard Compliant + Crowdsale
5 * @author Oyewole A. Samuel oyewoleabayomi@gmail.com
6 */
7 
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15   /**
16   * @dev Multiplies two numbers, throws on overflow.
17   */
18   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   /**
38   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 /**
56 * @title Admin parameters
57 * @dev Define administration parameters for this contract
58 */
59 contract admined {
60     //This token contract is administered
61     address public admin; //Admin address is public
62     bool public lockSupply; //Mint and Burn Lock flag
63     bool public lockTransfer; //Transfer Lock flag
64     address public allowedAddress; //an address that can override lock condition
65     bool public lockTokenSupply;
66 
67     /**
68     * @dev Contract constructor
69     * define initial administrator
70     */
71     function admined() internal {
72         admin = msg.sender; //Set initial admin to contract creator
73         Admined(admin);
74     }
75 
76    /**
77     * @dev Function to set an allowed address
78     * @param _to The address to give privileges.
79     */
80     function setAllowedAddress(address _to) public {
81         allowedAddress = _to;
82         AllowedSet(_to);
83     }
84 
85     modifier onlyAdmin() { //A modifier to define admin-only functions
86         require(msg.sender == admin);
87         _;
88     }
89 
90     modifier supplyLock() { //A modifier to lock mint and burn transactions
91         require(lockSupply == false);
92         _;
93     }
94 
95     modifier transferLock() { //A modifier to lock transactions
96         require(lockTransfer == false || allowedAddress == msg.sender);
97         _;
98     }
99 
100    /**
101     * @dev Function to set new admin address
102     * @param _newAdmin The address to transfer administration to
103     */
104     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
105         admin = _newAdmin;
106         TransferAdminship(admin);
107     }
108 
109    /**
110     * @dev Function to set mint and burn locks
111     * @param _set boolean flag (true | false)
112     */
113     function setSupplyLock(bool _set) onlyAdmin public { //Only the admin can set a lock on supply
114         lockSupply = _set;
115         SetSupplyLock(_set);
116     }
117 
118    /**
119     * @dev Function to set transfer lock
120     * @param _set boolean flag (true | false)
121     */
122     function setTransferLock(bool _set) onlyAdmin public { //Only the admin can set a lock on transfers
123         lockTransfer = _set;
124         SetTransferLock(_set);
125     }
126 
127     function setLockTokenSupply(bool _set) onlyAdmin public {
128         lockTokenSupply = _set;
129         SetLockTokenSupply(_set);
130     }
131 
132     function getLockTokenSupply() returns (bool) {
133         return lockTokenSupply;
134     }
135 
136     //All admin actions have a log for public review
137     event AllowedSet(address _to);
138     event SetSupplyLock(bool _set);
139     event SetTransferLock(bool _set);
140     event TransferAdminship(address newAdminister);
141     event Admined(address administer);
142     event SetLockTokenSupply(bool _set);
143 
144 }
145 
146 /**
147  * Token contract interface for external use
148  */
149 contract ERC20TokenInterface {
150     function balanceOf(address _owner) public constant returns (uint256 balance);
151     function transfer(address _to, uint256 _value) public returns (bool success);
152     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
153     function approve(address _spender, uint256 _value) public returns (bool success);
154     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
155 }
156 
157 /**
158 * @title Token definition
159 * @dev Define token paramters including ERC20 ones
160 */
161 contract StandardToken is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
162     using SafeMath for uint256;
163     uint256 public totalSupply;
164     mapping (address => uint256) balances; //A mapping of all balances per address
165     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
166     mapping (address => bool) frozen; //A mapping of frozen accounts
167 
168     /**
169     * @dev Get the balance of an specified address.
170     * @param _owner The address to be query.
171     */
172     function balanceOf(address _owner) public constant returns (uint256 balance) {
173       return balances[_owner];
174     }
175 
176     /**
177     * @dev transfer token to a specified address
178     * @param _to The address to transfer to.
179     * @param _value The amount to be transferred.
180     */
181     function transfer(address _to, uint256 _value) transferLock public returns (bool success) {
182         require(_to != address(0)); //If you dont want that people destroy token
183         require(balances[msg.sender] >= _value);
184         require(frozen[msg.sender]==false);
185         balances[msg.sender] = balances[msg.sender].safeSub(_value);
186         balances[_to] = balances[_to].safeAdd(_value);
187         Transfer(msg.sender, _to, _value);
188         return true;
189     }
190 
191     /**
192     * @dev transfer token from an address to another specified address using allowance
193     * @param _from The address where token comes.
194     * @param _to The address to transfer to.
195     * @param _value The amount to be transferred.
196     */
197     function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {
198         require(_to != address(0)); //If you dont want that people destroy token
199         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
200         require(frozen[_from]==false);
201         balances[_to] = balances[_to].safeAdd(_value);
202         balances[_from] = balances[_from].safeSub(_value);
203         allowed[_from][msg.sender] = allowed[_from][msg.sender].safeSub(_value);
204         Transfer(_from, _to, _value);
205         return true;
206     }
207 
208     /**
209     * @dev Assign allowance to an specified address to use the owner balance
210     * @param _spender The address to be allowed to spend.
211     * @param _value The amount to be allowed.
212     */
213     function approve(address _spender, uint256 _value) public returns (bool success) {
214       allowed[msg.sender][_spender] = _value;
215         Approval(msg.sender, _spender, _value);
216         return true;
217     }
218 
219     /**
220     * @dev Get the allowance of an specified address to use another address balance.
221     * @param _owner The address of the owner of the tokens.
222     * @param _spender The address of the allowed spender.
223     */
224     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
225         return allowed[_owner][_spender];
226     }
227 
228     /**
229     * @dev Mint token to an specified address.
230     * @param _target The address of the receiver of the tokens.
231     * @param _mintedAmount amount to mint.
232     */
233     function mintToken(address _target, uint256 _mintedAmount) onlyAdmin supplyLock public {
234         balances[_target] = SafeMath.safeAdd(balances[_target], _mintedAmount);
235         totalSupply = SafeMath.safeAdd(totalSupply, _mintedAmount);
236         Transfer(0, this, _mintedAmount);
237         Transfer(this, _target, _mintedAmount);
238     }
239 
240     /**
241     * @dev Burn token of an specified address.
242     * @param _target The address of the holder of the tokens.
243     * @param _burnedAmount amount to burn.
244     */
245     function burnToken(address _target, uint256 _burnedAmount) onlyAdmin supplyLock public {
246         balances[_target] = SafeMath.safeSub(balances[_target], _burnedAmount);
247         totalSupply = SafeMath.safeSub(totalSupply, _burnedAmount);
248         Burned(_target, _burnedAmount);
249     }
250 
251     /**
252     * @dev Frozen account.
253     * @param _target The address to being frozen.
254     * @param _flag The status of the frozen
255     */
256     function setFrozen(address _target,bool _flag) onlyAdmin public {
257         frozen[_target]=_flag;
258         FrozenStatus(_target,_flag);
259     }
260 
261     /**
262     * @dev Log Events
263     */
264     event Transfer(address indexed _from, address indexed _to, uint256 _value);
265     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
266     event Burned(address indexed _target, uint256 _value);
267     event FrozenStatus(address _target,bool _flag);
268 }
269 
270 contract SMARTRealty is StandardToken{
271     //using SafeMath for uint256;
272     
273     string public name = "SMARTRealty";
274     string public symbol = "RLTY";
275     uint8 public decimals = 8;
276     string public version = "1.0.0";
277 
278     uint public constant RATE = 1250; //1 RLTY = 0.0008 ETH
279     address public owner;
280     
281     // amount of raised money in wei
282     uint256 weiRaised;    
283     
284     struct ICOPhase {
285         uint fromTimestamp; //ico starting timestamp
286         uint toTimestamp; // ico end timestamp
287         uint256 minimum; // Minimum purchase for each phase
288         uint256 fundRaised;
289         uint bonus; // In percent, ie 10 is a 10% for bonus
290         uint totalNumberOfTokenPurchase; //number of token allowed for each phase
291     }
292     
293     mapping(uint => ICOPhase) phases;
294     uint icoPhaseCounter = 0;
295     
296     enum IcoStatus{Pending, Active, Inactive}
297     IcoStatus status;    
298     
299     function SMARTRealty() public payable {
300         
301         owner = msg.sender;
302         
303         totalSupply = 500000000 * (10**uint256(decimals));          //500 million initial token creation
304         
305         //Tokens to creator wallet - For distribution        
306         balances[owner] = 200000000 * (10**uint256(decimals)); //40% for public distribution
307         
308         //Initial Token Distribution
309         balances[0xF9568bd772C9B517193275b3C2E0CDAd38E586bB] = 50000000 * (10**uint256(decimals)); //10% Development, Executive, and Advisory Teams
310         balances[0x07ADB1D9399Bd1Fa4fD613D3179DFE883755Bb13] = 50000000 * (10**uint256(decimals)); //10% SMARTRealty Economy
311         balances[0xd35909DbeEb5255D65b1ea14602C7f00ce3872f6] = 50000000 * (10**uint256(decimals)); //10% Marketing
312         balances[0x9D2Fe4D5f1dc4FcA1f0Ea5f461C9fAA5D09b9CCE] = 50000000 * (10**uint256(decimals)); //10% SMARTMortgages
313         balances[0x8Bb41848B6dD3D98b8849049b780dC3549568c89] = 25000000 * (10**uint256(decimals)); //5% Admin
314         balances[0xC78DF195DE5717FB15FB3448D5C6893E8e7fB254] = 25000000 * (10**uint256(decimals)); //5% Contractors
315         balances[0x4690678926BCf9B30985c06806d4568C0C498123] = 25000000 * (10**uint256(decimals)); //5% Legal
316         balances[0x08AF803F0F90ccDBFCe046Bc113822cFf415e148] = 20000000 * (10**uint256(decimals)); //4% Bounties and Giveaways
317         balances[0x8661dFb67dE4E5569da9859f5CB4Aa676cd5F480] = 5000000 * (10**uint256(decimals)); //1% Charitable Use
318         
319     }
320     
321     //Set ICO Status
322     function activateICOStatus() public {
323         status = IcoStatus.Active;
324     }    
325     
326     //Set each Phase of your ICO here
327     function setICOPhase(uint _fromTimestamp, uint _toTimestamp, uint256 _min, uint _bonus) onlyAdmin public returns (uint ICOPhaseId) {
328         uint icoPhaseId = icoPhaseCounter++;
329         ICOPhase storage ico = phases[icoPhaseId];
330         ico.fromTimestamp = _fromTimestamp;
331         ico.toTimestamp = _toTimestamp;
332         ico.minimum = _min;
333         ico.bonus = _bonus;
334         //ico.totalNumberOfTokenPurchase = _numOfToken;
335 
336         phases[icoPhaseId] = ico;
337 
338         return icoPhaseId;
339     }
340     
341     //Get current ICO Phase
342     function getCurrentICOPhaseBonus() public view returns (uint _bonus, uint icoPhaseId) {
343         require(icoPhaseCounter > 0);
344         uint currentTimestamp = block.timestamp; //Get the current block timestamp
345 
346         for (uint i = 0; i < icoPhaseCounter; i++) {
347             
348             ICOPhase storage ico = phases[i];
349 
350             if (currentTimestamp >= ico.fromTimestamp && currentTimestamp <= ico.toTimestamp) {
351                 return (ico.bonus, i);
352             }
353         }
354 
355     }
356     
357     // Override this method to have a way to add business logic to your crowdsale when buying
358     function getTokenAmount(uint256 weiAmount) internal returns(uint256 token, uint id) {
359         var (bonus, phaseId) = getCurrentICOPhaseBonus();       //get current ICO phase information
360         uint256 numOfTokens = weiAmount.safeMul(RATE);
361         uint256 bonusToken = (bonus / 100) * numOfTokens;
362         
363         uint256 totalToken = numOfTokens.safeAdd(bonusToken);               //Total tokens to transfer
364         return (totalToken, phaseId);
365     }    
366     
367     // low level token purchase function
368     function _buyTokens(address beneficiary) public payable {
369         require(beneficiary != address(0) && beneficiary != owner);
370         
371         uint256 weiAmount = msg.value;
372         
373         // calculate token amount to be created
374         var (tokens, phaseId) = getTokenAmount(weiAmount);
375         
376         //update the current ICO Phase
377         ICOPhase storage ico = phases[phaseId]; //get phase
378         ico.fundRaised = ico.fundRaised.safeAdd(msg.value); //Update fundRaised for a particular phase
379         phases[phaseId] = ico;
380         
381         // update state
382         weiRaised = weiRaised.safeAdd(weiAmount);
383         
384         _transferToken(beneficiary, tokens);
385         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
386         
387         forwardFunds();
388     }
389     
390     function _transferToken(address _to, uint256 _amount) public returns (bool){
391         balances[owner] = balances[owner].safeSub(_amount);
392         balances[_to] = balances[_to].safeAdd(_amount);
393         Transfer(address(0), _to, _amount);
394         return true;        
395     }
396     
397     // send ether to the fund collection wallet
398     // override to create custom fund forwarding mechanisms
399     function forwardFunds() internal {
400         owner.transfer(msg.value);
401     }    
402 
403     // fallback function can be used to buy tokens
404     function () external payable {
405         _buyTokens(msg.sender);
406     } 
407     
408     
409     event TokenPurchase(address _sender, address _beneficiary, uint256 weiAmount, uint256 tokens);
410     
411 }