1 pragma solidity >=0.4.10;
2 
3 /*  ----------------------------------------------------------------------------------------
4 
5     Dev:    "Owned" to ensure control of contracts
6 
7             Identical to https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
8 
9     ---------------------------------------------------------------------------------------- */
10 contract Owned {
11     address public owner;
12 
13     function Owned() {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function transferOwnership(address newOwner) onlyOwner {
23         owner = newOwner;
24     }
25 }
26 
27 /*  ----------------------------------------------------------------------------------------
28 
29     Dev:    SafeMath library
30 
31             Identical to https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
32 
33     ---------------------------------------------------------------------------------------- */
34 library SafeMath {
35   function safeMul(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a * b;
37     assert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function safeDiv(uint256 a, uint256 b) internal constant returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function safeSub(uint256 a, uint256 b) internal constant returns (uint256) {
49     assert(b <= a); // Ensuring no negatives
50     return a - b;
51   }
52 
53   function safeAdd(uint256 a, uint256 b) internal constant returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a && c>=b);
56     return c;
57   }
58 }
59 
60 /*  ----------------------------------------------------------------------------------------
61 
62     Dev:    ESG Asset Holder is called when the token "burn" function is called
63 
64     Sum:    Locked to false so users cannot burn their tokens until the Asset Contract is
65             put in place with value.
66 
67     ---------------------------------------------------------------------------------------- */
68 contract ESGAssetHolder {
69     
70     function burn(address _holder, uint _amount) returns (bool result) {
71 
72         _holder = 0x0;                              // To avoid variable not used issue on deployment
73         _amount = 0;                                // To avoid variable not used issue on deployment
74         return false;
75     }
76 }
77 
78 
79 /*  ----------------------------------------------------------------------------------------
80 
81     Dev:    The Esports Gold Token:  ERC20 standard token with MINT and BURN functions
82 
83     Func:   Mint, Approve, Transfer, TransferFrom  
84 
85     Note:   Mint function takes UNITS of tokens to mint as ICO event is set to have a minimum
86             contribution of 1 token. All other functions (transfer etc), the value to transfer
87             is the FULL DECIMAL value
88             The user is only ever presented with the latter option, therefore should avoid
89             any confusion.
90     ---------------------------------------------------------------------------------------- */
91 contract ESGToken is Owned {
92         
93     string public name = "ESG Token";               // Name of token
94     string public symbol = "ESG";                   // Token symbol
95     uint256 public decimals = 3;                    // Decimals for the token
96     uint256 public totalSupply;                   // Current supply of tokens
97     uint256 public supplyCap;                       // Hard cap on supply of tokens
98     address public ICOcontroller;                   // Controlling contract from ICO
99     address public timelockTokens;                  // Address for locked management tokens
100     bool public tokenParametersSet;                        // Ensure that parameters required are set
101     bool public controllerSet;                             // Ensure that ICO controller is set
102 
103     mapping (address => uint256) public balanceOf;                      // Balances of addresses
104     mapping (address => mapping (address => uint)) public allowance;    // Allowances from addresses
105     mapping (address => bool) public frozenAccount;                     // Safety mechanism
106 
107 
108     modifier onlyControllerOrOwner() {            // Ensures that only contracts can manage key functions
109         require(msg.sender == ICOcontroller || msg.sender == owner);
110         _;
111     }
112 
113     event Transfer(address indexed from, address indexed to, uint256 value);
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115     event Mint(address owner, uint amount);
116     event FrozenFunds(address target, bool frozen);
117     event Burn(address coinholder, uint amount);
118     
119     /*  ----------------------------------------------------------------------------------------
120 
121     Dev:    Constructor
122 
123     param:  Owner:  Address of owner
124             Name:   Esports Gold Token
125             Sym:    ESG_TKN
126             Dec:    3
127             Cap:    Hard coded cap to ensure excess tokens cannot be minted
128 
129     Other parameters have been set up as a separate function to help lower initial gas deployment cost.
130 
131     ---------------------------------------------------------------------------------------- */
132     function ESGToken() {
133         totalSupply = 0;                      // Starting supply is zero
134         supplyCap = 0;                          // Hard cap supply in Tokens set by ICO
135         tokenParametersSet = false;             // Ensure parameters are set
136         controllerSet = false;                  // Ensure controller is set
137     }
138 
139     /*  ----------------------------------------------------------------------------------------
140 
141     Dev:    Key parameters to setup for ICO event
142 
143     Param:  _ico    Address of the ICO Event contract to ensure the ICO event can control
144                     the minting function
145     
146     ---------------------------------------------------------------------------------------- */
147     function setICOController(address _ico) onlyOwner {     // ICO event address is locked in
148         require(_ico != 0x0);
149         ICOcontroller = _ico;
150         controllerSet = true;
151     }
152 
153 
154     /*  ----------------------------------------------------------------------------------------
155     NEW
156     Dev:    Address for the timelock tokens to be held
157 
158     Param:  _timelockAddr   Address of the timelock contract that will hold the locked tokens
159     
160     ---------------------------------------------------------------------------------------- */
161     function setParameters(address _timelockAddr) onlyOwner {
162         require(_timelockAddr != 0x0);
163 
164         timelockTokens = _timelockAddr;
165 
166         tokenParametersSet = true;
167     }
168 
169     function parametersAreSet() constant returns (bool) {
170         return tokenParametersSet && controllerSet;
171     }
172 
173     /*  ----------------------------------------------------------------------------------------
174 
175     Dev:    Set the total number of Tokens that can be minted
176 
177     Param:  _supplyCap  The number of tokens (in whole units) that can be minted. This number then
178                         gets increased by the decimal number
179    
180     ---------------------------------------------------------------------------------------- */
181     function setTokenCapInUnits(uint256 _supplyCap) onlyControllerOrOwner {   // Supply cap in UNITS
182         assert(_supplyCap > 0);
183         
184         supplyCap = SafeMath.safeMul(_supplyCap, (10**decimals));
185     }
186 
187     /*  ----------------------------------------------------------------------------------------
188 
189     Dev:    Mint the number of tokens for the timelock contract
190 
191     Param:  _mMentTkns  Number of tokens in whole units that need to be locked into the Timelock
192     
193     ---------------------------------------------------------------------------------------- */
194     function mintLockedTokens(uint256 _mMentTkns) onlyControllerOrOwner {
195         assert(_mMentTkns > 0);
196         assert(tokenParametersSet);
197 
198         mint(timelockTokens, _mMentTkns);  
199     }
200 
201     /*  ----------------------------------------------------------------------------------------
202 
203     Dev:    ERC20 protocols
204     
205     ---------------------------------------------------------------------------------------- */
206     function balanceOf(address _owner) constant returns (uint256 balance) {
207         return balanceOf[_owner];
208     }
209 
210     /*  ----------------------------------------------------------------------------------------
211 
212     Dev:    Mint ESG Tokens by controller
213 
214     Control:            OnlyControllers. ICO event needs to be able to control the minting
215                         function
216 
217     Param:  Address     Address for tokens to be minted to
218             Amount      Number of tokens to be minted (in whole UNITS. Min minting is 1 token)
219                         Minimum ETH contribution in ICO event is 0.01ETH at 100 tokens per ETH
220     
221     ---------------------------------------------------------------------------------------- */
222     function mint(address _address, uint _amount) onlyControllerOrOwner {
223         require(_address != 0x0);
224         uint256 amount = SafeMath.safeMul(_amount, (10**decimals));             // Tokens minted using unit parameter supplied
225 
226         // Ensure that supplyCap is set and that new tokens don't breach cap
227         assert(supplyCap > 0 && amount > 0 && SafeMath.safeAdd(totalSupply, amount) <= supplyCap);
228         
229         balanceOf[_address] = SafeMath.safeAdd(balanceOf[_address], amount);    // Add tokens to address
230         totalSupply = SafeMath.safeAdd(totalSupply, amount);                // Add to supply
231         
232         Mint(_address, amount);
233         Transfer(0x0, _address, amount);
234     }
235     
236     /*  ----------------------------------------------------------------------------------------
237 
238     Dev:    ERC20 standard transfer function
239 
240     Param:  _to         Address to send to
241             _value      Number of tokens to be sent - in FULL decimal length
242     
243     Ref:    https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/BasicToken.sol
244     ---------------------------------------------------------------------------------------- */
245     function transfer(address _to, uint _value) returns (bool success) {
246         require(!frozenAccount[msg.sender]);        // Ensure account is not frozen
247 
248         /* 
249             Update balances from "from" and "to" addresses with the tokens transferred
250             safeSub method ensures that address sender has enough tokens to send
251         */
252         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);    
253         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                  
254         Transfer(msg.sender, _to, _value);
255         
256         return true;
257     }
258     
259     /*  ----------------------------------------------------------------------------------------
260 
261     Dev:    ERC20 standard transferFrom function
262 
263     Param:  _from       Address to send from
264             _to         Address to send to
265             Amount      Number of tokens to be sent - in FULL decimal length
266 
267     ---------------------------------------------------------------------------------------- */
268     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {   
269         require(!frozenAccount[_from]);                         // Check account is not frozen
270         
271         /* 
272             Ensure sender has been authorised to send the required number of tokens
273         */
274         if (allowance[_from][msg.sender] < _value)
275             return false;
276 
277         /* 
278             Update allowance of sender to reflect tokens sent
279         */
280         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value); 
281 
282         /* 
283             Update balances from "from" and "to" addresses with the tokens transferred
284             safeSub method ensures that address sender has enough tokens to send
285         */
286         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
287         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
288 
289         Transfer(_from, _to, _value);
290         return true;
291     }
292     
293     /*  ----------------------------------------------------------------------------------------
294 
295     Dev:    ERC20 standard approve function
296 
297     Param:  _spender        Address of sender who is approved
298             _value          The number of tokens (full decimals) that are approved
299 
300     ---------------------------------------------------------------------------------------- */
301     function approve(address _spender, uint256 _value)      // FULL DECIMALS OF TOKENS
302         returns (bool success)
303     {
304         require(!frozenAccount[msg.sender]);                // Check account is not frozen
305 
306         /* Requiring the user to set to zero before resetting to nonzero */
307         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) {
308            return false;
309         }
310 
311         allowance[msg.sender][_spender] = _value;
312         
313         Approval(msg.sender, _spender, _value);
314         return true;
315     }
316 
317     /*  ----------------------------------------------------------------------------------------
318 
319     Dev:    Function to check the amount of tokens that the owner has allowed the "spender" to
320             transfer
321 
322     Param:  _owner          Address of the authoriser who owns the tokens
323             _spender        Address of sender who will be authorised to spend the tokens
324 
325     ---------------------------------------------------------------------------------------- */
326 
327     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
328         return allowance[_owner][_spender];
329     }
330     
331     /*  ----------------------------------------------------------------------------------------
332 
333     Dev:    As ESG is aiming to be a regulated betting operator. Regulatory hurdles may require
334             this function if an account on the betting platform, using the token, breaches
335             a regulatory requirement.
336 
337             ESG can then engage with the account holder to get it unlocked
338 
339             This does not stop the token accruing value from its share of the Asset Contract
340 
341     Param:  _target         Address of account
342             _freeze         Boolean to lock/unlock account
343 
344     Ref:    This is a replica of the code as per https://ethereum.org/token
345     ---------------------------------------------------------------------------------------- */
346     function freezeAccount(address target, bool freeze) onlyOwner {
347         frozenAccount[target] = freeze;
348         FrozenFunds(target, freeze);
349     }
350 
351     /*  ----------------------------------------------------------------------------------------
352 
353     Dev:    Burn function: User is able to burn their token for a share of the ESG Asset Contract
354 
355     Note:   Deployed with the ESG Asset Contract set to false to ensure token holders cannot
356             accidentally burn their tokens for zero value
357 
358     Param:  _amount         Number of tokens (full decimals) that should be burnt
359 
360     Ref:    Based on the open source TokenCard Burn function. A copy can be found at
361             https://github.com/bokkypoobah/TokenCardICOAnalysis
362     ---------------------------------------------------------------------------------------- */
363     function burn(uint _amount) returns (bool result) {
364 
365         if (_amount > balanceOf[msg.sender])
366             return false;       // If owner has enough to burn
367 
368         /* 
369             Remove tokens from circulation
370             Update sender's balance of tokens
371         */
372         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _amount);
373         totalSupply = SafeMath.safeSub(totalSupply, _amount);
374 
375         // Call burn function
376         result = esgAssetHolder.burn(msg.sender, _amount);
377         require(result);
378 
379         Burn(msg.sender, _amount);
380     }
381 
382     /*  ----------------------------------------------------------------------------------------
383 
384     Dev:    Section of the contract that links to the ESG Asset Contract
385 
386     Note:   Deployed with the ESG Asset Contract set to false to ensure token holders cannot
387             accidentally burn their tokens for zero value
388 
389     Param:  _amount         Number of tokens (full decimals) that should be burnt
390 
391     Ref:    Based on the open source TokenCard Burn function. A copy can be found at
392             https://github.com/bokkypoobah/TokenCardICOAnalysis
393     ---------------------------------------------------------------------------------------- */
394 
395     ESGAssetHolder esgAssetHolder;              // Holds the accumulated asset contract
396     bool lockedAssetHolder;                     // Will be locked to stop tokenholder to be upgraded
397 
398     function lockAssetHolder() onlyOwner {      // Locked once deployed
399         lockedAssetHolder = true;
400     }
401 
402     function setAssetHolder(address _assetAdress) onlyOwner {   // Used to lock in the Asset Contract
403         assert(!lockedAssetHolder);             // Check that we haven't locked the asset holder yet
404         esgAssetHolder = ESGAssetHolder(_assetAdress);
405     }    
406 }