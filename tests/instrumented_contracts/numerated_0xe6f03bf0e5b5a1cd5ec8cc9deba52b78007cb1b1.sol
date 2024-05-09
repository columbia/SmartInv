1 pragma solidity 0.5.9; /*
2 
3 ___________________________________________________________________
4   _      _                                        ______           
5   |  |  /          /                                /              
6 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
8 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10 
11 
12  .----------------.  .----------------.  .-----------------. .----------------.  .----------------. 
13 | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
14 | |  _________   | || |     _____    | || | ____  _____  | || |   ________   | || | _____  _____ | |
15 | | |  _   _  |  | || |    |_   _|   | || ||_   \|_   _| | || |  |  __   _|  | || ||_   _||_   _|| |
16 | | |_/ | | \_|  | || |      | |     | || |  |   \ | |   | || |  |_/  / /    | || |  | |    | |  | |
17 | |     | |      | || |      | |     | || |  | |\ \| |   | || |     .'.' _   | || |  | '    ' |  | |
18 | |    _| |_     | || |     _| |_    | || | _| |_\   |_  | || |   _/ /__/ |  | || |   \ `--' /   | |
19 | |   |_____|    | || |    |_____|   | || ||_____|\____| | || |  |________|  | || |    `.__.'    | |
20 | |              | || |              | || |              | || |              | || |              | |
21 | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
22  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 
23 
24 
25 
26 // ----------------------------------------------------------------------------
27 // 'Tinzu' token contract with following features
28 //      => ERC20 Compliance
29 //      => Higher degree of control by owner - safeguard functionality
30 //      => SafeMath implementation 
31 //      => Burnable and minting 
32 //
33 // Name        : Tinzu
34 // Symbol      : TIN
35 // Total supply: 1,000,000,000 (1 Billion)
36 // Decimals    : 18
37 //
38 // Copyright 2019 onwards - Tinzu ( https://Tinzu.org )
39 // Contract designed by EtherAuthority ( https://EtherAuthority.io )
40 // ----------------------------------------------------------------------------
41 */ 
42 
43 
44 //*******************************************************************//
45 //------------------------ SafeMath Library -------------------------//
46 //*******************************************************************//
47 /**
48     * @title SafeMath
49     * @dev Math operations with safety checks that throw on error
50     */
51 library SafeMath {
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54         return 0;
55     }
56     uint256 c = a * b;
57     require(c / a == b);
58     return c;
59     }
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     uint256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return c;
66     }
67 
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     require(b <= a);
70     return a - b;
71     }
72 
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74     uint256 c = a + b;
75     require(c >= a);
76     return c;
77     }
78 }
79 
80 
81 //*******************************************************************//
82 //------------------ Contract to Manage Ownership -------------------//
83 //*******************************************************************//
84     
85 contract owned {
86     address payable internal owner;
87     
88      constructor () public {
89         owner = msg.sender;
90     }
91 
92     modifier onlyOwner {
93         require(msg.sender == owner);
94         _;
95     }
96 
97     function transferOwnership(address payable newOwner) onlyOwner public {
98         owner = newOwner;
99     }
100 }
101     
102 
103     
104 //****************************************************************************//
105 //---------------------        MAIN CODE STARTS HERE     ---------------------//
106 //****************************************************************************//
107     
108 contract Tinzu is owned {
109     
110 
111     /*===============================
112     =         DATA STORAGE          =
113     ===============================*/
114 
115     // Public variables of the token
116     using SafeMath for uint256;
117     string constant public name = "Tinzu";
118     string constant public symbol = "TIN";
119     uint256 constant public decimals = 18;
120     uint256 public totalSupply = 1000000000 * (10**decimals);   // 1 Billion tokens
121     uint256 public maximumMinting;
122     bool public safeguard = false;  //putting safeguard on will halt all non-owner functions
123     
124     // This creates a mapping with all data storage
125     mapping (address => uint256) internal _balanceOf;
126     mapping (address => mapping (address => uint256)) internal _allowance;
127     mapping (address => bool) internal _frozenAccount;
128 
129 
130     /*===============================
131     =         PUBLIC EVENTS         =
132     ===============================*/
133 
134     // This generates a public event of token transfer
135     event Transfer(address indexed from, address indexed to, uint256 value);
136     
137     // This will log approval of token Transfer
138     event Approval(address indexed from, address indexed spender, uint256 value);
139 
140     // This notifies clients about the amount burnt
141     event Burn(address indexed from, uint256 value);
142         
143     // This generates a public event for frozen (blacklisting) accounts
144     event FrozenFunds(address indexed target, bool indexed frozen);
145 
146 
147 
148     /*======================================
149     =       STANDARD ERC20 FUNCTIONS       =
150     ======================================*/
151     
152     /**
153      * Check token balance of any user
154      */
155     function balanceOf(address owner) public view returns (uint256) {
156         return _balanceOf[owner];
157     }
158     
159     /**
160      * Check allowance of any spender versus owner
161      */
162     function allowance(address owner, address spender) public view returns (uint256) {
163         return _allowance[owner][spender];
164     }
165     
166     /**
167      * Check if particular user address is frozen or not
168      */
169     function frozenAccount(address owner) public view returns (bool) {
170         return _frozenAccount[owner];
171     }
172 
173     /**
174      * Internal transfer, only can be called by this contract
175      */
176     function _transfer(address _from, address _to, uint _value) internal {
177         
178         //checking conditions
179         require(!safeguard);
180         require (_to != address(0));                         // Prevent transfer to 0x0 address. Use burn() instead
181         require(!_frozenAccount[_from]);                     // Check if sender is frozen
182         require(!_frozenAccount[_to]);                       // Check if recipient is frozen
183         
184         // overflow and undeflow checked by SafeMath Library
185         _balanceOf[_from] = _balanceOf[_from].sub(_value);   // Subtract from the sender
186         _balanceOf[_to] = _balanceOf[_to].add(_value);       // Add the same to the recipient
187         
188         // emit Transfer event
189         emit Transfer(_from, _to, _value);
190     }
191 
192     /**
193         * Transfer tokens
194         *
195         * Send `_value` tokens to `_to` from your account
196         *
197         * @param _to The address of the recipient
198         * @param _value the amount to send
199         */
200     function transfer(address _to, uint256 _value) public returns (bool success) {
201         //no need to check for input validations, as that is ruled by SafeMath
202         _transfer(msg.sender, _to, _value);
203         
204         return true;
205     }
206 
207     /**
208         * Transfer tokens from other address
209         *
210         * Send `_value` tokens to `_to` in behalf of `_from`
211         *
212         * @param _from The address of the sender
213         * @param _to The address of the recipient
214         * @param _value the amount to send
215         */
216     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
217         require(_value <= _allowance[_from][msg.sender]);     // Check _allowance
218         _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value);
219         _transfer(_from, _to, _value);
220         return true;
221     }
222 
223     /**
224         * Set _allowance for other address
225         *
226         * Allows `_spender` to spend no more than `_value` tokens in your behalf
227         *
228         * @param _spender The address authorized to spend
229         * @param _value the max amount they can spend
230         */
231     function approve(address _spender, uint256 _value) public returns (bool success) {
232         require(!safeguard);
233         require(_balanceOf[msg.sender] >= _value, "Balance does not have enough tokens");
234         _allowance[msg.sender][_spender] = _value;
235         emit Approval(msg.sender, _spender, _value);
236         return true;
237     }
238     
239     /**
240      * @dev Increase the amount of tokens that an owner allowed to a spender.
241      * approve should be called when allowed_[_spender] == 0. To increment
242      * allowed value is better to use this function to avoid 2 calls (and wait until
243      * the first transaction is mined)
244      * Emits an Approval event.
245      * @param spender The address which will spend the funds.
246      * @param value The amount of tokens to increase the _allowance by.
247      */
248     function increase_allowance(address spender, uint256 value) public returns (bool) {
249         require(spender != address(0));
250 
251         _allowance[msg.sender][spender] = _allowance[msg.sender][spender].add(value);
252         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
253         return true;
254     }
255 
256     /**
257      * @dev Decrease the amount of tokens that an owner allowed to a spender.
258      * approve should be called when allowed_[_spender] == 0. To decrement
259      * allowed value is better to use this function to avoid 2 calls (and wait until
260      * the first transaction is mined)
261      * Emits an Approval event.
262      * @param spender The address which will spend the funds.
263      * @param value The amount of tokens to decrease the _allowance by.
264      */
265     function decrease_allowance(address spender, uint256 value) public returns (bool) {
266         require(spender != address(0));
267 
268         _allowance[msg.sender][spender] = _allowance[msg.sender][spender].sub(value);
269         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
270         return true;
271     }
272 
273 
274     /*=====================================
275     =       CUSTOM PUBLIC FUNCTIONS       =
276     ======================================*/
277     
278     constructor() public{
279         //sending all the tokens to Owner
280         _balanceOf[owner] = totalSupply;
281         
282         //maximum minting set to totalSupply
283         maximumMinting = totalSupply;
284         
285         //firing event which logs this transaction
286         emit Transfer(address(0), owner, totalSupply);
287     }
288     
289     /* No need for empty fallback function as contract without it will automatically rejects incoming ether */
290     //function () external payable { revert; }
291 
292     /**
293         * Destroy tokens
294         *
295         * Remove `_value` tokens from the system irreversibly
296         *
297         * @param _value the amount of money to burn
298         */
299     function burn(uint256 _value) public returns (bool success) {
300         require(!safeguard);
301         //checking of enough token balance is done by SafeMath
302         _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);  // Subtract from the sender
303         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
304         emit Burn(msg.sender, _value);
305         emit Transfer(msg.sender, address(0), _value);
306         return true;
307     }
308 
309     /**
310         * Destroy tokens from other account
311         *
312         * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
313         *
314         * @param _from the address of the sender
315         * @param _value the amount of money to burn
316         */
317     function burnFrom(address _from, uint256 _value) public returns (bool success) {
318         require(!safeguard);
319         //checking of _allowance and token value is done by SafeMath
320         _balanceOf[_from] = _balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
321         _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value); // Subtract from the sender's _allowance
322         totalSupply = totalSupply.sub(_value);                                   // Update totalSupply
323         emit  Burn(_from, _value);
324         emit Transfer(_from, address(0), _value);
325         return true;
326     }
327         
328     
329     /** 
330         * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
331         * @param target Address to be frozen
332         * @param freeze either to freeze it or not
333         */
334     function freezeAccount(address target, bool freeze) onlyOwner public {
335             _frozenAccount[target] = freeze;
336         emit  FrozenFunds(target, freeze);
337     }
338     
339     /** 
340         * @notice Create `mintedAmount` tokens and send it to `target`
341         * @param target Address to receive the tokens
342         * @param mintedAmount the amount of tokens it will receive
343         */
344     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
345         totalSupply = totalSupply.add(mintedAmount);
346         //owner can not mint more than max supply of tokens, to prevent 'Evil Mint' issue!!
347         require(totalSupply <= maximumMinting, 'Minting reached its maximum minting limit' );
348         _balanceOf[target] = _balanceOf[target].add(mintedAmount);
349         
350         emit Transfer(address(0), target, mintedAmount);
351     }
352 
353         
354 
355     /**
356         * Owner can transfer tokens from contract to owner address
357         *
358         * When safeguard is true, then all the non-owner functions will stop working.
359         * When safeguard is false, then all the functions will resume working back again!
360         */
361     
362     function manualWithdrawTokens(uint256 tokenAmount) public onlyOwner{
363         // no need for overflow checking as that will be done in transfer function
364         _transfer(address(this), owner, tokenAmount);
365     }
366     
367     //Just in rare case, owner wants to transfer Ether from contract to owner address
368     function manualWithdrawEther()onlyOwner public{
369         address(owner).transfer(address(this).balance);
370     }
371     
372     /**
373         * Change safeguard status on or off
374         *
375         * When safeguard is true, then all the non-owner functions will stop working.
376         * When safeguard is false, then all the functions will resume working back again!
377         */
378     function changeSafeguardStatus() onlyOwner public{
379         if (safeguard == false){
380             safeguard = true;
381         }
382         else{
383             safeguard = false;    
384         }
385     }
386 
387 }