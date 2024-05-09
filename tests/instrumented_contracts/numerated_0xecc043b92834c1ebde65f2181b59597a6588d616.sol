1 pragma solidity 0.4.24;
2 pragma experimental "v0.5.0";
3 
4 contract Administration {
5 
6     using SafeMath for uint256;
7 
8     address public owner;
9     address public admin;
10 
11     event AdminSet(address _admin);
12     event OwnershipTransferred(address _previousOwner, address _newOwner);
13 
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     modifier onlyAdmin() {
21         require(msg.sender == owner || msg.sender == admin);
22         _;
23     }
24 
25     modifier nonZeroAddress(address _addr) {
26         require(_addr != address(0), "must be non zero address");
27         _;
28     }
29 
30     constructor() public {
31         owner = msg.sender;
32         admin = msg.sender;
33     }
34 
35     function setAdmin(
36         address _newAdmin
37     )
38         public
39         onlyOwner
40         nonZeroAddress(_newAdmin)
41         returns (bool)
42     {
43         require(_newAdmin != admin);
44         admin = _newAdmin;
45         emit AdminSet(_newAdmin);
46         return true;
47     }
48 
49     function transferOwnership(
50         address _newOwner
51     )
52         public
53         onlyOwner
54         nonZeroAddress(_newOwner)
55         returns (bool)
56     {
57         owner = _newOwner;
58         emit OwnershipTransferred(msg.sender, _newOwner);
59         return true;
60     }
61 
62 }
63 
64 
65 library SafeMath {
66 
67   // We use `pure` bbecause it promises that the value for the function depends ONLY
68   // on the function arguments
69     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
70         uint256 c = a * b;
71         require(a == 0 || c / a == b);
72         return c;
73     }
74 
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a / b;
77         return c;
78     }
79 
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         require(b <= a);
82         return a - b;
83     }
84 
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a);
88         return c;
89     }
90 }
91 
92 /*
93     ERC20 Standard Token interface
94 */
95 interface ERC20Interface {
96     function owner() external view returns (address);
97     function decimals() external view returns (uint8);
98     function transfer(address _to, uint256 _value) external returns (bool);
99     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
100     function approve(address _spender, uint256 _amount) external returns (bool);
101     function totalSupply() external view returns (uint256);
102     function balanceOf(address _owner) external view returns (uint256);
103     function allowance(address _owner, address _spender) external view returns (uint256);
104 }
105 
106 interface StakeInterface {
107     function activeStakes() external view returns (uint256);
108 }
109 
110 /// @title RTC Token Contract
111 /// @author Postables, RTrade Technologies Ltd
112 /// @dev We able V5 for safety features, see https://solidity.readthedocs.io/en/v0.4.24/security-considerations.html#take-warnings-seriously
113 contract RTCoin is Administration {
114 
115     using SafeMath for uint256;
116 
117     // this is the initial supply of tokens, 61.6 Million
118     uint256 constant public INITIALSUPPLY = 61600000000000000000000000;
119     string  constant public VERSION = "production";
120 
121     // this is the interface that allows interaction with the staking contract
122     StakeInterface public stake = StakeInterface(0);
123     // this is the address of the staking contract
124     address public  stakeContractAddress = address(0);
125     // This is the address of the merged mining contract, not yet developed
126     address public  mergedMinerValidatorAddress = address(0);
127     string  public  name = "RTCoin";
128     string  public  symbol = "RTC";
129     uint256 public  totalSupply = INITIALSUPPLY;
130     uint8   public  decimals = 18;
131     // allows transfers to be frozen, but enable them by default
132     bool    public  transfersFrozen = true;
133     bool    public  stakeFailOverRestrictionLifted = false;
134 
135     mapping (address => uint256) public balances;
136     mapping (address => mapping (address => uint256)) public allowed;
137     mapping (address => bool) public minters;
138 
139     event Transfer(address indexed _sender, address indexed _recipient, uint256 _amount);
140     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
141     event TransfersFrozen(bool indexed _transfersFrozen);
142     event TransfersThawed(bool indexed _transfersThawed);
143     event ForeignTokenTransfer(address indexed _sender, address indexed _recipient, uint256 _amount);
144     event EthTransferOut(address indexed _recipient, uint256 _amount);
145     event MergedMinerValidatorSet(address _contractAddress);
146     event StakeContractSet(address _contractAddress);
147     event FailOverStakeContractSet(address _contractAddress);
148     event CoinsMinted(address indexed _stakeContract, address indexed _recipient, uint256 _mintAmount);
149 
150     modifier transfersNotFrozen() {
151         require(!transfersFrozen, "transfers must not be frozen");
152         _;
153     }
154 
155     modifier transfersAreFrozen() {
156         require(transfersFrozen, "transfers must be frozen");
157         _;
158     }
159 
160     // makes sure that only the stake contract, or merged miner validator contract can mint coins
161     modifier onlyMinters() {
162         require(minters[msg.sender] == true, "sender must be a valid minter");
163         _;
164     }
165 
166     modifier nonZeroAddress(address _addr) {
167         require(_addr != address(0), "must be non zero address");
168         _;
169     }
170 
171     modifier nonAdminAddress(address _addr) {
172         require(_addr != owner && _addr != admin, "addr cant be owner or admin");
173         _;
174     }
175 
176     constructor() public {
177         balances[msg.sender] = totalSupply;
178         emit Transfer(address(0), msg.sender, totalSupply);
179     }
180 
181     /** @notice Used to transfer tokens
182         * @param _recipient This is the recipient of the transfer
183         * @param _amount This is the amount of tokens to send
184      */
185     function transfer(
186         address _recipient,
187         uint256 _amount
188     )
189         public
190         transfersNotFrozen
191         nonZeroAddress(_recipient)
192         returns (bool)
193     {
194         // check that the sender has a valid balance
195         require(balances[msg.sender] >= _amount, "sender does not have enough tokens");
196         balances[msg.sender] = balances[msg.sender].sub(_amount);
197         balances[_recipient] = balances[_recipient].add(_amount);
198         emit Transfer(msg.sender, _recipient, _amount);
199         return true;
200     }
201 
202     /** @notice Used to transfer tokens on behalf of someone else
203         * @param _recipient This is the recipient of the transfer
204         * @param _amount This is the amount of tokens to send
205      */
206     function transferFrom(
207         address _owner,
208         address _recipient,
209         uint256 _amount
210     )
211         public
212         transfersNotFrozen
213         nonZeroAddress(_recipient)
214         returns (bool)
215     {
216         // ensure owner has a valid balance
217         require(balances[_owner] >= _amount, "owner does not have enough tokens");
218         // ensure that the spender has a valid allowance
219         require(allowed[_owner][msg.sender] >= _amount, "sender does not have enough allowance");
220         // reduce the allowance
221         allowed[_owner][msg.sender] = allowed[_owner][msg.sender].sub(_amount);
222         // reduce balance of owner
223         balances[_owner] = balances[_owner].sub(_amount);
224         // increase balance of recipient
225         balances[_recipient] = balances[_recipient].add(_amount);
226         emit Transfer(_owner, _recipient, _amount);
227         return true;
228     }
229 
230     /** @notice This is used to approve someone to send tokens on your behalf
231         * @param _spender This is the person who can spend on your behalf
232         * @param _value This is the amount of tokens that they can spend
233      */
234     function approve(address _spender, uint256 _value) public returns (bool) {
235         allowed[msg.sender][_spender] = _value;
236         emit Approval(msg.sender, _spender, _value);
237         return true;
238     }
239 
240     // NON STANDARD FUNCTIONS //
241 
242     /** @notice This is used to set the merged miner validator contract
243         * @param _mergedMinerValidator this is the address of the mergedmining contract
244      */
245     function setMergedMinerValidator(address _mergedMinerValidator) external onlyOwner nonAdminAddress(_mergedMinerValidator) returns (bool) {
246         mergedMinerValidatorAddress = _mergedMinerValidator;
247         minters[_mergedMinerValidator] = true;
248         emit MergedMinerValidatorSet(_mergedMinerValidator);
249         return true;
250     }
251 
252     /** @notice This is used to set the staking contract
253         * @param _contractAddress this is the address of the staking contract
254     */
255     function setStakeContract(address _contractAddress) external onlyOwner nonAdminAddress(_contractAddress) returns (bool) {
256         // this prevents us from changing contracts while there are active stakes going on
257         if (stakeContractAddress != address(0)) {
258             require(stake.activeStakes() == 0, "staking contract already configured, to change it must have 0 active stakes");
259         }
260         stakeContractAddress = _contractAddress;
261         minters[_contractAddress] = true;
262         stake = StakeInterface(_contractAddress);
263         emit StakeContractSet(_contractAddress);
264         return true;
265     }
266 
267     /** @notice Emergency use function designed to prevent stake deadlocks, allowing a fail-over stake contract to be implemented
268         * Requires 2 transaction, the first lifts the restriction, the second enables the restriction and sets the contract
269         * @dev We restrict to the owner address for security reasons, and don't update the stakeContractAddress variable to avoid breaking compatability
270         * @param _contractAddress This is the address of the stake contract
271      */
272     function setFailOverStakeContract(address _contractAddress) external onlyOwner nonAdminAddress(_contractAddress) returns (bool) {
273         if (stakeFailOverRestrictionLifted == false) {
274             stakeFailOverRestrictionLifted = true;
275             return true;
276         } else {
277             minters[_contractAddress] = true;
278             stakeFailOverRestrictionLifted = false;
279             emit FailOverStakeContractSet(_contractAddress);
280             return true;
281         }
282     }
283 
284     /** @notice This is used to mint new tokens
285         * @dev Can only be executed by the staking, and merged miner validator contracts
286         * @param _recipient This is the person who will received the mint tokens
287         * @param _amount This is the amount of tokens that they will receive and which will be generated
288      */
289     function mint(
290         address _recipient,
291         uint256 _amount)
292         public
293         onlyMinters
294         returns (bool)
295     {
296         balances[_recipient] = balances[_recipient].add(_amount);
297         totalSupply = totalSupply.add(_amount);
298         emit Transfer(address(0), _recipient, _amount);
299         emit CoinsMinted(msg.sender, _recipient, _amount);
300         return true;
301     }
302 
303     /** @notice Allow us to transfer tokens that someone might've accidentally sent to this contract
304         @param _tokenAddress this is the address of the token contract
305         @param _recipient This is the address of the person receiving the tokens
306         @param _amount This is the amount of tokens to send
307      */
308     function transferForeignToken(
309         address _tokenAddress,
310         address _recipient,
311         uint256 _amount)
312         public
313         onlyAdmin
314         nonZeroAddress(_recipient)
315         returns (bool)
316     {
317         // don't allow us to transfer RTC tokens
318         require(_tokenAddress != address(this), "token address can't be this contract");
319         ERC20Interface eI = ERC20Interface(_tokenAddress);
320         require(eI.transfer(_recipient, _amount), "token transfer failed");
321         emit ForeignTokenTransfer(msg.sender, _recipient, _amount);
322         return true;
323     }
324     
325     /** @notice Transfers eth that is stuck in this contract
326         * ETH can be sent to the address this contract resides at before the contract is deployed
327         * A contract can be suicided, forcefully sending ether to this contract
328      */
329     function transferOutEth()
330         public
331         onlyAdmin
332         returns (bool)
333     {
334         uint256 balance = address(this).balance;
335         msg.sender.transfer(address(this).balance);
336         emit EthTransferOut(msg.sender, balance);
337         return true;
338     }
339 
340     /** @notice Used to freeze token transfers
341      */
342     function freezeTransfers()
343         public
344         onlyAdmin
345         returns (bool)
346     {
347         transfersFrozen = true;
348         emit TransfersFrozen(true);
349         return true;
350     }
351 
352     /** @notice Used to thaw token transfers
353      */
354     function thawTransfers()
355         public
356         onlyAdmin
357         returns (bool)
358     {
359         transfersFrozen = false;
360         emit TransfersThawed(true);
361         return true;
362     }
363 
364 
365     /**
366     * @dev Increase the amount of tokens that an owner allowed to a spender.
367     * approve should be called when allowed[_spender] == 0. To increment
368     * allowed value is better to use this function to avoid 2 calls (and wait until
369     * the first transaction is mined)
370     * From MonolithDAO Token.sol
371     * @param _spender The address which will spend the funds.
372     * @param _addedValue The amount of tokens to increase the allowance by.
373     */
374     function increaseApproval(
375         address _spender,
376         uint256 _addedValue
377     )
378         public
379         returns (bool)
380     {
381         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
382         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
383         return true;
384     }
385 
386     /**
387     * @dev Decrease the amount of tokens that an owner allowed to a spender.
388     * approve should be called when allowed[_spender] == 0. To decrement
389     * allowed value is better to use this function to avoid 2 calls (and wait until
390     * the first transaction is mined)
391     * From MonolithDAO Token.sol
392     * @param _spender The address which will spend the funds.
393     * @param _subtractedValue The amount of tokens to decrease the allowance by.
394     */
395     function decreaseApproval(
396         address _spender,
397         uint256 _subtractedValue
398     )
399         public
400         returns (bool)
401     {
402         uint256 oldValue = allowed[msg.sender][_spender];
403         if (_subtractedValue >= oldValue) {
404             allowed[msg.sender][_spender] = 0;
405         } else {
406             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
407         }
408         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
409         return true;
410     }
411 
412     /**GETTERS */
413 
414     /** @notice Used to get the total supply
415      */
416     function totalSupply()
417         public
418         view
419         returns (uint256)
420     {
421         return totalSupply;
422     }
423 
424     /** @notice Used to get the balance of a holder
425         * @param _holder The address of the token holder
426      */
427     function balanceOf(
428         address _holder
429     )
430         public
431         view
432         returns (uint256)
433     {
434         return balances[_holder];
435     }
436 
437     /** @notice Used to get the allowance of someone
438         * @param _owner The address of the token owner
439         * @param _spender The address of thhe person allowed to spend funds on behalf of the owner
440      */
441     function allowance(
442         address _owner,
443         address _spender
444     )
445         public
446         view
447         returns (uint256)
448     {
449         return allowed[_owner][_spender];
450     }
451 
452 }