1 pragma solidity 0.5.6; /*
2 
3 ___________________________________________________________________
4   _      _                                        ______           
5   |  |  /          /                                /              
6 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
8 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10 
11 ██████╗ ██╗     ██╗██╗  ██╗███████╗    ████████╗ ██████╗ ██╗  ██╗███████╗███╗   ██╗
12 ██╔══██╗██║     ██║██║ ██╔╝██╔════╝    ╚══██╔══╝██╔═══██╗██║ ██╔╝██╔════╝████╗  ██║
13 ██║  ██║██║     ██║█████╔╝ █████╗         ██║   ██║   ██║█████╔╝ █████╗  ██╔██╗ ██║
14 ██║  ██║██║     ██║██╔═██╗ ██╔══╝         ██║   ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╗██║
15 ██████╔╝███████╗██║██║  ██╗███████╗       ██║   ╚██████╔╝██║  ██╗███████╗██║ ╚████║
16 ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═╝╚══════╝       ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝
17                                                                                    
18                                                                                    
19 // ----------------------------------------------------------------------------
20 // 'DlikeToken' contract with following features
21 //      => ERC20 Compliance
22 //      => Higher degree of control by owner - safeguard functionality
23 //      => SafeMath implementation 
24 //      => Burnable and minting 
25 //      => in-built buy/sell functions (owner can control buying/selling process)
26 //
27 // Name        : DlikeToken
28 // Symbol      : DLIKE
29 // Total supply: 800,000,000 (800 Million)
30 // Decimals    : 18
31 //
32 // Copyright 2019 onwards - Dlike ( https://dlike.io )
33 // Contract designed and audited by EtherAuthority ( https://EtherAuthority.io )
34 // Special thanks to openzeppelin for inspiration:  ( https://github.com/OpenZeppelin )
35 // ----------------------------------------------------------------------------
36 */ 
37 
38 //*******************************************************************//
39 //------------------------ SafeMath Library -------------------------//
40 //*******************************************************************//
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     if (a == 0) {
48       return 0;
49     }
50     uint256 c = a * b;
51     assert(c / a == b);
52     return c;
53   }
54 
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 
75 //*******************************************************************//
76 //------------------ Contract to Manage Ownership -------------------//
77 //*******************************************************************//
78     
79 contract owned {
80     address payable internal owner;
81     
82      constructor () public {
83         owner = msg.sender;
84     }
85 
86     modifier onlyOwner {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     function transferOwnership(address payable newOwner) onlyOwner public {
92         owner = newOwner;
93     }
94 }
95     
96 
97     
98 //****************************************************************************//
99 //---------------------        MAIN CODE STARTS HERE     ---------------------//
100 //****************************************************************************//
101     
102 contract DlikeToken is owned {
103     
104 
105     /*===============================
106     =         DATA STORAGE          =
107     ===============================*/
108 
109     // Public variables of the token
110     using SafeMath for uint256;
111     string constant public name = "DlikeToken";
112     string constant public symbol = "DLIKE";
113     uint256 constant public decimals = 18;
114     uint256 public totalSupply = 800000000 * (10**decimals);   //800 million tokens
115     uint256 public maximumMinting;
116     bool public safeguard = false;  //putting safeguard on will halt all non-owner functions
117     
118     // This creates a mapping with all data storage
119     mapping (address => uint256) internal _balanceOf;
120     mapping (address => mapping (address => uint256)) internal _allowance;
121     mapping (address => bool) internal _frozenAccount;
122 
123 
124     /*===============================
125     =         PUBLIC EVENTS         =
126     ===============================*/
127 
128     // This generates a public event of token transfer
129     event Transfer(address indexed from, address indexed to, uint256 value);
130     
131     // This will log approval of token Transfer
132     event Approval(address indexed from, address indexed spender, uint256 value);
133 
134     // This notifies clients about the amount burnt
135     event Burn(address indexed from, uint256 value);
136         
137     // This generates a public event for frozen (blacklisting) accounts
138     event FrozenFunds(address indexed target, bool indexed frozen);
139 
140 
141 
142     /*======================================
143     =       STANDARD ERC20 FUNCTIONS       =
144     ======================================*/
145     
146     /**
147      * Check token balance of any user
148      */
149     function balanceOf(address owner) public view returns (uint256) {
150         return _balanceOf[owner];
151     }
152     
153     /**
154      * Check allowance of any spender versus owner
155      */
156     function allowance(address owner, address spender) public view returns (uint256) {
157         return _allowance[owner][spender];
158     }
159     
160     /**
161      * Check if particular user address is frozen or not
162      */
163     function frozenAccount(address owner) public view returns (bool) {
164         return _frozenAccount[owner];
165     }
166 
167     /**
168      * Internal transfer, only can be called by this contract
169      */
170     function _transfer(address _from, address _to, uint _value) internal {
171         
172         //checking conditions
173         require(!safeguard);
174         require (_to != address(0));                         // Prevent transfer to 0x0 address. Use burn() instead
175         require(!_frozenAccount[_from]);                     // Check if sender is frozen
176         require(!_frozenAccount[_to]);                       // Check if recipient is frozen
177         
178         // overflow and undeflow checked by SafeMath Library
179         _balanceOf[_from] = _balanceOf[_from].sub(_value);   // Subtract from the sender
180         _balanceOf[_to] = _balanceOf[_to].add(_value);       // Add the same to the recipient
181         
182         // emit Transfer event
183         emit Transfer(_from, _to, _value);
184     }
185 
186     /**
187         * Transfer tokens
188         *
189         * Send `_value` tokens to `_to` from your account
190         *
191         * @param _to The address of the recipient
192         * @param _value the amount to send
193         */
194     function transfer(address _to, uint256 _value) public returns (bool success) {
195         //no need to check for input validations, as that is ruled by SafeMath
196         _transfer(msg.sender, _to, _value);
197         
198         return true;
199     }
200 
201     /**
202         * Transfer tokens from other address
203         *
204         * Send `_value` tokens to `_to` in behalf of `_from`
205         *
206         * @param _from The address of the sender
207         * @param _to The address of the recipient
208         * @param _value the amount to send
209         */
210     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
211         require(_value <= _allowance[_from][msg.sender]);     // Check _allowance
212         _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value);
213         _transfer(_from, _to, _value);
214         return true;
215     }
216 
217     /**
218         * Set _allowance for other address
219         *
220         * Allows `_spender` to spend no more than `_value` tokens in your behalf
221         *
222         * @param _spender The address authorized to spend
223         * @param _value the max amount they can spend
224         */
225     function approve(address _spender, uint256 _value) public returns (bool success) {
226         require(!safeguard);
227         _allowance[msg.sender][_spender] = _value;
228         emit Approval(msg.sender, _spender, _value);
229         return true;
230     }
231     
232     /**
233      * @dev Increase the amount of tokens that an owner allowed to a spender.
234      * approve should be called when allowed_[_spender] == 0. To increment
235      * allowed value is better to use this function to avoid 2 calls (and wait until
236      * the first transaction is mined)
237      * Emits an Approval event.
238      * @param spender The address which will spend the funds.
239      * @param value The amount of tokens to increase the _allowance by.
240      */
241     function increase_allowance(address spender, uint256 value) public returns (bool) {
242         require(spender != address(0));
243 
244         _allowance[msg.sender][spender] = _allowance[msg.sender][spender].add(value);
245         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
246         return true;
247     }
248 
249     /**
250      * @dev Decrease the amount of tokens that an owner allowed to a spender.
251      * approve should be called when allowed_[_spender] == 0. To decrement
252      * allowed value is better to use this function to avoid 2 calls (and wait until
253      * the first transaction is mined)
254      * Emits an Approval event.
255      * @param spender The address which will spend the funds.
256      * @param value The amount of tokens to decrease the _allowance by.
257      */
258     function decrease_allowance(address spender, uint256 value) public returns (bool) {
259         require(spender != address(0));
260 
261         _allowance[msg.sender][spender] = _allowance[msg.sender][spender].sub(value);
262         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
263         return true;
264     }
265 
266 
267     /*=====================================
268     =       CUSTOM PUBLIC FUNCTIONS       =
269     ======================================*/
270     
271     constructor() public{
272         //sending all the tokens to Owner
273         _balanceOf[owner] = totalSupply;
274         
275         //maximum minting set to totalSupply
276         maximumMinting = totalSupply;
277         
278         //firing event which logs this transaction
279         emit Transfer(address(0), owner, totalSupply);
280     }
281     
282     /* No need for empty fallback function as contract without it will automatically rejects incoming ether */
283     //function () external payable { revert; }
284 
285     /**
286         * Destroy tokens
287         *
288         * Remove `_value` tokens from the system irreversibly
289         *
290         * @param _value the amount of money to burn
291         */
292     function burn(uint256 _value) public returns (bool success) {
293         require(!safeguard);
294         //checking of enough token balance is done by SafeMath
295         _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);  // Subtract from the sender
296         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
297         emit Burn(msg.sender, _value);
298         return true;
299     }
300 
301     /**
302         * Destroy tokens from other account
303         *
304         * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
305         *
306         * @param _from the address of the sender
307         * @param _value the amount of money to burn
308         */
309     function burnFrom(address _from, uint256 _value) public returns (bool success) {
310         require(!safeguard);
311         //checking of _allowance and token value is done by SafeMath
312         _balanceOf[_from] = _balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
313         _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value); // Subtract from the sender's _allowance
314         totalSupply = totalSupply.sub(_value);                                   // Update totalSupply
315         emit  Burn(_from, _value);
316         return true;
317     }
318         
319     
320     /** 
321         * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
322         * @param target Address to be frozen
323         * @param freeze either to freeze it or not
324         */
325     function freezeAccount(address target, bool freeze) onlyOwner public {
326             _frozenAccount[target] = freeze;
327         emit  FrozenFunds(target, freeze);
328     }
329     
330     /** 
331         * @notice Create `mintedAmount` tokens and send it to `target`
332         * @param target Address to receive the tokens
333         * @param mintedAmount the amount of tokens it will receive
334         */
335     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
336         totalSupply = totalSupply.add(mintedAmount);
337         //owner can not mint more than max supply of tokens, to prevent 'Evil Mint' issue!!
338         require(totalSupply <= maximumMinting, 'Minting reached its maximum minting limit' );
339         _balanceOf[target] = _balanceOf[target].add(mintedAmount);
340         
341         emit Transfer(address(0), target, mintedAmount);
342     }
343 
344         
345 
346     /**
347         * Owner can transfer tokens from contract to owner address
348         *
349         * When safeguard is true, then all the non-owner functions will stop working.
350         * When safeguard is false, then all the functions will resume working back again!
351         */
352     
353     function manualWithdrawTokens(uint256 tokenAmount) public onlyOwner{
354         // no need for overflow checking as that will be done in transfer function
355         _transfer(address(this), owner, tokenAmount);
356     }
357     
358     //Just in rare case, owner wants to transfer Ether from contract to owner address
359     function manualWithdrawEther()onlyOwner public{
360         address(owner).transfer(address(this).balance);
361     }
362     
363     /**
364         * Change safeguard status on or off
365         *
366         * When safeguard is true, then all the non-owner functions will stop working.
367         * When safeguard is false, then all the functions will resume working back again!
368         */
369     function changeSafeguardStatus() onlyOwner public{
370         if (safeguard == false){
371             safeguard = true;
372         }
373         else{
374             safeguard = false;    
375         }
376     }
377 
378 }