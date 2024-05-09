1 // SPDX-License-Identifier: UNLICENSED
2 /*
3 
4 ___________________________________________________________________
5   _      _                                        ______           
6   |  |  /          /                                /              
7 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
8   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
9 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
10 
11 
12 
13 
14  █████╗ ██╗     ██████╗ ██╗  ██╗ █████╗      ██████╗ ███╗   ███╗███████╗ ██████╗  █████╗      ██████╗ ██████╗ ██╗███╗   ██╗
15 ██╔══██╗██║     ██╔══██╗██║  ██║██╔══██╗    ██╔═══██╗████╗ ████║██╔════╝██╔════╝ ██╔══██╗    ██╔════╝██╔═══██╗██║████╗  ██║
16 ███████║██║     ██████╔╝███████║███████║    ██║   ██║██╔████╔██║█████╗  ██║  ███╗███████║    ██║     ██║   ██║██║██╔██╗ ██║
17 ██╔══██║██║     ██╔═══╝ ██╔══██║██╔══██║    ██║   ██║██║╚██╔╝██║██╔══╝  ██║   ██║██╔══██║    ██║     ██║   ██║██║██║╚██╗██║
18 ██║  ██║███████╗██║     ██║  ██║██║  ██║    ╚██████╔╝██║ ╚═╝ ██║███████╗╚██████╔╝██║  ██║    ╚██████╗╚██████╔╝██║██║ ╚████║
19 ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝     ╚═════╝ ╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝     ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝
20                                                                                                                            
21 
22 
23 === 'Alpha Omega Coin' Token contract with following features ===
24     => ERC20 Compliance
25     => Higher degree of control by owner - safeguard functionality
26     => SafeMath implementation 
27     => Burnable 
28     => minting capped to max supply
29     => owner can freeze/blacklist any wallet. This useful for system abuse prevention
30 
31 
32 
33 ======================= Quick Stats ===================
34     => Name        : Alpha Omega Coin
35     => Symbol      : AOC
36     => Total supply: 100 000 000 000  (100 Billion)
37     => Decimals    : 6
38 
39 
40 ============= Independant Audit of the code ============
41     => Multiple Freelancers Auditors
42     => Community Audit by Bug Bounty program
43 
44 
45 -------------------------------------------------------------------
46  Copyright (c) 2021 onwards Alpha Omega Coin. 
47  Contract designed with ❤ by EtherAuthority ( https://EtherAuthority.io )
48 -------------------------------------------------------------------
49 */ 
50 
51 
52 
53 pragma solidity 0.8.0;
54 //*******************************************************************//
55 //------------------------ SafeMath Library -------------------------//
56 //*******************************************************************//
57 /**
58     * @title SafeMath
59     * @dev Math operations with safety checks that throw on error
60     */
61 library SafeMath {
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63     if (a == 0) {
64         return 0;
65     }
66     uint256 c = a * b;
67     require(c / a == b, 'SafeMath mul failed');
68     return c;
69     }
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76     }
77 
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     require(b <= a, 'SafeMath sub failed');
80     return a - b;
81     }
82 
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a, 'SafeMath add failed');
86     return c;
87     }
88 }
89 
90 
91 //*******************************************************************//
92 //------------------ Contract to Manage Ownership -------------------//
93 //*******************************************************************//
94     
95 contract owned {
96     address public owner;
97     address internal newOwner;
98 
99     event OwnershipTransferred(address indexed _from, address indexed _to);
100 
101     constructor()  {
102         owner = msg.sender;
103         emit OwnershipTransferred(address(0), owner);
104     }
105 
106     modifier onlyOwner {
107         require(msg.sender == owner);
108         _;
109     }
110 
111     function transferOwnership(address  _newOwner) external onlyOwner {
112         newOwner = _newOwner;
113     }
114 
115     //this flow is to prevent transferring ownership to wrong wallet by mistake
116     function acceptOwnership() external {
117         require(msg.sender == newOwner);
118         emit OwnershipTransferred(owner, newOwner);
119         owner = newOwner;
120         newOwner = address(0);
121     }
122 }
123  
124 
125     
126 //****************************************************************************//
127 //---------------------        MAIN CODE STARTS HERE     ---------------------//
128 //****************************************************************************//
129     
130 contract AlphaOmegaCoin is owned {
131     
132 
133     /*===============================
134     =         DATA STORAGE          =
135     ===============================*/
136 
137     // Public variables of the token
138     using SafeMath for uint256;
139     string constant private _name = "Alpha Omega Coin";
140     string constant private _symbol = "AOC";
141     uint256 constant private _decimals = 6;
142     uint256 private _totalSupply = 100000000000 * (10**_decimals);         //100 billion tokens
143     uint256 constant public maxSupply = 100000000000 * (10**_decimals);    //100 billion tokens
144     bool public safeguard;  //putting safeguard on will halt all non-owner functions
145 
146     // This creates a mapping with all data storage
147     mapping (address => uint256) private _balanceOf;
148     mapping (address => mapping (address => uint256)) private _allowance;
149     mapping (address => bool) public frozenAccount;
150 
151 
152     /*===============================
153     =         PUBLIC EVENTS         =
154     ===============================*/
155 
156     // This generates a public event of token transfer
157     event Transfer(address indexed from, address indexed to, uint256 value);
158 
159     // This notifies clients about the amount burnt
160     event Burn(address indexed from, uint256 value);
161         
162     // This generates a public event for frozen (blacklisting) accounts
163     event FrozenAccounts(address target, bool frozen);
164     
165     // This will log approval of token Transfer
166     event Approval(address indexed from, address indexed spender, uint256 value);
167 
168 
169 
170     /*======================================
171     =       STANDARD ERC20 FUNCTIONS       =
172     ======================================*/
173     
174     /**
175      * Returns name of token 
176      */
177     function name() external pure returns(string memory){
178         return _name;
179     }
180     
181     /**
182      * Returns symbol of token 
183      */
184     function symbol() external pure returns(string memory){
185         return _symbol;
186     }
187     
188     /**
189      * Returns decimals of token 
190      */
191     function decimals() external pure returns(uint256){
192         return _decimals;
193     }
194     
195     /**
196      * Returns totalSupply of token.
197      */
198     function totalSupply() external view returns (uint256) {
199         return _totalSupply;
200     }
201     
202     /**
203      * Returns balance of token 
204      */
205     function balanceOf(address user) external view returns(uint256){
206         return _balanceOf[user];
207     }
208     
209     /**
210      * Returns allowance of token 
211      */
212     function allowance(address owner, address spender) external view returns (uint256) {
213         return _allowance[owner][spender];
214     }
215     
216     /**
217      * Internal transfer, only can be called by this contract 
218      */
219     function _transfer(address _from, address _to, uint _value) internal {
220         
221         //checking conditions
222         require(!safeguard);
223         require (_to != address(0));                      // Prevent transfer to 0x0 address. Use burn() instead
224         require(!frozenAccount[_from]);                     // Check if sender is frozen
225         require(!frozenAccount[_to]);                       // Check if recipient is frozen
226         
227         // overflow and undeflow checked by SafeMath Library
228         _balanceOf[_from] = _balanceOf[_from].sub(_value);    // Subtract from the sender
229         _balanceOf[_to] = _balanceOf[_to].add(_value);        // Add the same to the recipient
230         
231         // emit Transfer event
232         emit Transfer(_from, _to, _value);
233     }
234 
235     /**
236         * Transfer tokens
237         *
238         * Send `_value` tokens to `_to` from your account
239         *
240         * @param _to The address of the recipient
241         * @param _value the amount to send
242         */
243     function transfer(address _to, uint256 _value) external returns (bool success) {
244         //no need to check for input validations, as that is ruled by SafeMath
245         _transfer(msg.sender, _to, _value);
246         return true;
247     }
248 
249     /**
250         * Transfer tokens from other address
251         *
252         * Send `_value` tokens to `_to` in behalf of `_from`
253         *
254         * @param _from The address of the sender
255         * @param _to The address of the recipient
256         * @param _value the amount to send
257         */
258     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
259         //checking of allowance and token value is done by SafeMath
260         _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value);
261         _transfer(_from, _to, _value);
262         return true;
263     }
264 
265     /**
266         * Set allowance for other address
267         *
268         * Allows `_spender` to spend no more than `_value` tokens in your behalf
269         *
270         * @param _spender The address authorized to spend
271         * @param _value the max amount they can spend
272         */
273     function approve(address _spender, uint256 _value) external returns (bool success) {
274         require(!safeguard);
275         /* AUDITOR NOTE:
276             Many dex and dapps pre-approve large amount of tokens to save gas for subsequent transaction. This is good use case.
277             On flip-side, some malicious dapp, may pre-approve large amount and then drain all token balance from user.
278             So following condition is kept in commented. It can be be kept that way or not based on client's consent.
279         */
280         //require(_balanceOf[msg.sender] >= _value, "Balance does not have enough tokens");
281         _allowance[msg.sender][_spender] = _value;
282         emit Approval(msg.sender, _spender, _value);
283         return true;
284     }
285     
286     /**
287      * @dev Increase the amount of tokens that an owner allowed to a spender.
288      * approve should be called when allowed_[_spender] == 0. To increment
289      * allowed value is better to use this function to avoid 2 calls (and wait until
290      * the first transaction is mined)
291      * Emits an Approval event.
292      * @param spender The address which will spend the funds.
293      * @param value The amount of tokens to increase the allowance by.
294      */
295     function increase_allowance(address spender, uint256 value) external returns (bool) {
296         require(spender != address(0));
297         _allowance[msg.sender][spender] = _allowance[msg.sender][spender].add(value);
298         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
299         return true;
300     }
301 
302     /**
303      * @dev Decrease the amount of tokens that an owner allowed to a spender.
304      * approve should be called when allowed_[_spender] == 0. To decrement
305      * allowed value is better to use this function to avoid 2 calls (and wait until
306      * the first transaction is mined)
307      * Emits an Approval event.
308      * @param spender The address which will spend the funds.
309      * @param value The amount of tokens to decrease the allowance by.
310      */
311     function decrease_allowance(address spender, uint256 value) external returns (bool) {
312         require(spender != address(0));
313         _allowance[msg.sender][spender] = _allowance[msg.sender][spender].sub(value);
314         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
315         return true;
316     }
317 
318 
319     /*=====================================
320     =       CUSTOM PUBLIC FUNCTIONS       =
321     ======================================*/
322     
323     constructor() {
324         //sending all the tokens to Owner
325         _balanceOf[owner] = _totalSupply;
326         
327         //firing event which logs this transaction
328         emit Transfer(address(0), owner, _totalSupply);
329     }
330     
331     
332     /* No incoming ether allowed
333     
334     function () external payable {
335       
336     }
337     */
338 
339     /**
340         * Destroy tokens
341         *
342         * Remove `_value` tokens from the system irreversibly
343         *
344         * @param _value the amount of money to burn
345         */
346     function burn(uint256 _value) external returns (bool success) {
347         require(!safeguard);
348         //checking of enough token balance is done by SafeMath
349         _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);  // Subtract from the sender
350         _totalSupply = _totalSupply.sub(_value);                      // Updates totalSupply
351         emit Burn(msg.sender, _value);
352         emit Transfer(msg.sender, address(0), _value);
353         return true;
354     }
355 
356     
357     /** 
358         * @notice Create `mintedAmount` tokens and send it to `target`
359         * @param target Address to receive the tokens
360         * @param mintedAmount the amount of tokens it will receive
361         */
362     function mintToken(address target, uint256 mintedAmount) onlyOwner external {
363         require(_totalSupply.add(mintedAmount) <= maxSupply, "Cannot Mint more than maximum supply");
364         _balanceOf[target] = _balanceOf[target].add(mintedAmount);
365         _totalSupply = _totalSupply.add(mintedAmount);
366         emit Transfer(address(0), target, mintedAmount);
367     }    
368     
369     /** 
370         * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
371         * @param target Address to be frozen
372         * @param freeze either to freeze it or not
373         */
374     function freezeAccount(address target, bool freeze) onlyOwner external {
375         frozenAccount[target] = freeze;
376         emit  FrozenAccounts(target, freeze);
377     }
378     
379 
380     /**
381         * Owner can transfer tokens from contract to owner address
382         * This is to transfer the tokens sent to contract address by mistake
383         */
384     
385     function manualWithdrawTokens(uint256 tokenAmount) external onlyOwner{
386         // no need for overflow checking as that will be done in transfer function
387         _transfer(address(this), owner, tokenAmount);
388     }
389     
390     
391     
392     /**
393         * Change safeguard status on or off
394         *
395         * When safeguard is true, then all the non-owner functions will stop working.
396         * When safeguard is false, then all the functions will resume working back again!
397         */
398     function changeSafeguardStatus() onlyOwner external{
399         if (safeguard == false){
400             safeguard = true;
401         }
402         else{
403             safeguard = false;    
404         }
405     }
406     
407 
408     
409 
410 }