1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-13
3 */
4 
5 pragma solidity 0.5.12; /*
6 
7 
8 ___________________________________________________________________
9   _      _                                        ______           
10   |  |  /          /                                /              
11 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
12   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
13 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
14 
15 
16 
17 ███╗   ██╗███████╗██╗  ██╗██╗  ██╗██╗   ██╗███████╗     ██████╗ ██████╗ ██╗███╗   ██╗
18 ████╗  ██║██╔════╝╚██╗██╔╝╚██╗██╔╝██║   ██║██╔════╝    ██╔════╝██╔═══██╗██║████╗  ██║
19 ██╔██╗ ██║█████╗   ╚███╔╝  ╚███╔╝ ██║   ██║███████╗    ██║     ██║   ██║██║██╔██╗ ██║
20 ██║╚██╗██║██╔══╝   ██╔██╗  ██╔██╗ ██║   ██║╚════██║    ██║     ██║   ██║██║██║╚██╗██║
21 ██║ ╚████║███████╗██╔╝ ██╗██╔╝ ██╗╚██████╔╝███████║    ╚██████╗╚██████╔╝██║██║ ╚████║
22 ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝
23                                                                                      
24 
25 
26 === 'NEXXUS COIN' Token contract with following features ===
27     => ERC20 Compliance
28     => Higher degree of control by owner - safeguard functionality
29     => SafeMath implementation 
30     => Burnable and minting 
31     => approve and call
32     => Increase and decrease allowance
33     => air drop (active)
34 
35 
36 ======================= Quick Stats ===================
37     => Name        : Nexxus
38     => Symbol      : NXR
39     => Total supply: 375,000,000 (375 Million)
40     => Decimals    : 8
41 
42 
43 ============= Independant Audit of the code ============
44     => Multiple Freelancers Auditors
45     => Community Audit by Bug Bounty program
46     => Scanned code with MythX, Oyente, smartdec tool, chain security tool
47 
48 
49 -------------------------------------------------------------------
50  Copyright (c) 2019 onwards Nexxus Inc. ( https://Nexxuscoin.com )
51  Contract designed with ❤ by EtherAuthority ( https://EtherAuthority.io )
52 -------------------------------------------------------------------
53 */ 
54 
55 
56 
57 
58 
59 //*******************************************************************//
60 //------------------------ SafeMath Library -------------------------//
61 //*******************************************************************//
62 /**
63     * @title SafeMath
64     * @dev Math operations with safety checks that throw on error
65     */
66 library SafeMath {
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68     if (a == 0) {
69         return 0;
70     }
71     uint256 c = a * b;
72     require(c / a == b, 'SafeMath mul failed');
73     return c;
74     }
75 
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     // assert(b > 0); // Solidity automatically throws when dividing by 0
78     uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80     return c;
81     }
82 
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     require(b <= a, 'SafeMath sub failed');
85     return a - b;
86     }
87 
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89     uint256 c = a + b;
90     require(c >= a, 'SafeMath add failed');
91     return c;
92     }
93 }
94 
95 
96 //*******************************************************************//
97 //------------------ Contract to Manage Ownership -------------------//
98 //*******************************************************************//
99     
100 contract owned {
101     address payable public owner;
102     address payable internal newOwner;
103 
104     event OwnershipTransferred(address indexed _from, address indexed _to);
105 
106     constructor() public {
107         owner = msg.sender;
108     }
109 
110     modifier onlyOwner {
111         require(msg.sender == owner);
112         _;
113     }
114 
115     function transferOwnership(address payable _newOwner) public onlyOwner {
116         require(_newOwner != address(0), 'Invalid address');
117         newOwner = _newOwner;
118     }
119 
120     //this flow is to prevent transferring ownership to wrong wallet by mistake
121     function acceptOwnership() public {
122         require(msg.sender == newOwner);
123         emit OwnershipTransferred(owner, newOwner);
124         owner = newOwner;
125         newOwner = address(0);
126     }
127 }
128  
129 
130     
131 //****************************************************************************//
132 //---------------------        MAIN CODE STARTS HERE     ---------------------//
133 //****************************************************************************//
134     
135 contract NexxusCoin is owned {
136     
137 
138     /*===============================
139     =         DATA STORAGE          =
140     ===============================*/
141 
142     // Public variables of the token
143     using SafeMath for uint256;
144     string constant public name = "Nexxus";
145     string constant public symbol = "NXR";
146     uint256 constant public decimals = 8;
147     uint256 public totalSupply = 375000000 * (10**decimals);   //375 million tokens
148 	uint256 constant public maxSupply = 375000000 * (10**decimals);   //375 million tokens
149     bool public safeguard;  //putting safeguard on will halt all non-owner functions
150 
151     // This creates a mapping with all data storage
152     mapping (address => uint256) public balanceOf;
153     mapping (address => mapping (address => uint256)) public allowance;
154     mapping (address => bool) public frozenAccount;
155 
156 
157     /*===============================
158     =         PUBLIC EVENTS         =
159     ===============================*/
160 
161     // This generates a public event of token transfer
162     event Transfer(address indexed from, address indexed to, uint256 value);
163 
164     // This notifies clients about the amount burnt
165     event Burn(address indexed from, uint256 value);
166         
167     // This generates a public event for frozen (blacklisting) accounts
168     event FrozenAccounts(address target, bool frozen);
169     
170     // This will log approval of token Transfer
171     event Approval(address indexed from, address indexed spender, uint256 value);
172 
173 
174     /*======================================
175     =       STANDARD ERC20 FUNCTIONS       =
176     ======================================*/
177 
178     /* Internal transfer, only can be called by this contract */
179     function _transfer(address _from, address _to, uint _value) internal {
180         
181         //checking conditions
182         require(!safeguard, 'Safeguard is placed');
183         require(!frozenAccount[_from], 'Frozen Account');                     // Check if sender is frozen
184         require(!frozenAccount[_to], 'Frozen Account');                       // Check if recipient is frozen
185         require(_to != address(0), 'Invalid address');
186         // overflow and undeflow checked by SafeMath Library
187         balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
188         balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
189         
190         // emit Transfer event
191         emit Transfer(_from, _to, _value);
192     }
193 
194     /**
195         * Transfer tokens
196         *
197         * Send `_value` tokens to `_to` from your account
198         *
199         * @param _to The address of the recipient
200         * @param _value the amount to send
201         */
202     function transfer(address _to, uint256 _value) public returns (bool success) {
203         //no need to check for input validations, as that is ruled by SafeMath
204         _transfer(msg.sender, _to, _value);
205         
206         return true;
207     }
208 
209     /**
210         * Transfer tokens from other address
211         *
212         * Send `_value` tokens to `_to` in behalf of `_from`
213         *
214         * @param _from The address of the sender
215         * @param _to The address of the recipient
216         * @param _value the amount to send
217         */
218     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
219         //checking of allowance and token value is done by SafeMath
220         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
221         _transfer(_from, _to, _value);
222         return true;
223     }
224 
225     /**
226         * Set allowance for other address
227         *
228         * Allows `_spender` to spend no more than `_value` tokens in your behalf
229         *
230         * @param _spender The address authorized to spend
231         * @param _value the max amount they can spend
232         */
233     function approve(address _spender, uint256 _value) public returns (bool success) {
234         require(!safeguard, 'Safeguard is placed');
235         require(balanceOf[msg.sender] >= _value, 'Balance does not have enough tokens');
236         allowance[msg.sender][_spender] = _value;
237         emit Approval(msg.sender, _spender, _value);
238         return true;
239     }
240 
241 
242     /*=====================================
243     =       CUSTOM PUBLIC FUNCTIONS       =
244     ======================================*/
245     
246     constructor() public{
247         //sending all the tokens to Owner
248         balanceOf[owner] = totalSupply;
249         
250         //firing event which logs this transaction
251         emit Transfer(address(0), owner, totalSupply);
252     }
253     
254     
255     /**
256      * Increase allowance of spender
257      */
258     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
259         require(allowance[msg.sender][spender] > 0 ,"no amount is approved" );
260         uint256 newAmount = allowance[msg.sender][spender].add(addedValue);
261         approve(spender, newAmount);
262         
263         return true;
264     }
265     
266     
267     /**
268      * Decrease allowance of spender
269      */
270     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
271         require(allowance[msg.sender][spender] >= subtractedValue,"subtractedValue is not correct" );
272         uint256 newAmount = allowance[msg.sender][spender].sub(subtractedValue);
273         approve(spender, newAmount);
274         
275         return true;
276     }
277     
278     
279     /**
280      * Approve and make call to any _spender smart contract.
281      */
282     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success)  {
283         approve(_spender, _value);
284         (bool result,) = _spender.call(abi.encodeWithSignature("receiveApproval(address,uint256,address,bytes)", msg.sender, _value, address(this), _extraData));
285         if(!result){
286             return false;
287         }
288         return true;
289     }
290 
291     /**
292         * Destroy tokens
293         *
294         * Remove `_value` tokens from the system irreversibly
295         *
296         * @param _value the amount of money to burn
297         */
298     function burn(uint256 _value) public returns (bool success) {
299         require(!safeguard, 'Safeguard is placed');
300         //checking of enough token balance is done by SafeMath
301         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);  // Subtract from the sender
302         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
303         emit Burn(msg.sender, _value);
304         emit Transfer(msg.sender, address(0), _value);
305         return true;
306     }
307 
308     /**
309         * Destroy tokens from other account
310         *
311         * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
312         *
313         * @param _from the address of the sender
314         * @param _value the amount of money to burn
315         */
316     function burnFrom(address _from, uint256 _value) public returns (bool success) {
317         require(!safeguard, 'Safeguard is placed');
318         //checking of allowance and token value is done by SafeMath
319         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
320         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value); // Subtract from the sender's allowance
321         totalSupply = totalSupply.sub(_value);                                   // Update totalSupply
322         emit  Burn(_from, _value);
323         emit Transfer(_from, address(0), _value);
324         return true;
325     }
326         
327     
328     /** 
329         * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
330         * @param target Address to be frozen
331         * @param freeze either to freeze it or not
332         */
333     function freezeAccount(address target, bool freeze) onlyOwner public {
334         frozenAccount[target] = freeze;
335         emit  FrozenAccounts(target, freeze);
336     }
337     
338     /** 
339         * @notice Create `mintedAmount` tokens and send it to `target`
340         * @param target Address to receive the tokens
341         * @param mintedAmount the amount of tokens it will receive
342         */
343     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
344 		require(totalSupply.add(mintedAmount) <= maxSupply, 'Cannot Mint more than maximum supply');
345         balanceOf[target] = balanceOf[target].add(mintedAmount);
346         totalSupply = totalSupply.add(mintedAmount);
347         emit Transfer(address(0), target, mintedAmount);
348     }
349 
350         
351 
352     /**
353         * Owner can transfer tokens from contract to owner address
354         *
355         * When safeguard is true, then all the non-owner functions will stop working.
356         * When safeguard is false, then all the functions will resume working back again!
357         */
358     
359     function manualWithdrawTokens(uint256 tokenAmount) public onlyOwner{
360         // no need for overflow checking as that will be done in transfer function
361         _transfer(address(this), owner, tokenAmount);
362     }
363     
364     
365     /**
366         * Change safeguard status on or off
367         *
368         * When safeguard is true, then all the non-owner functions will stop working.
369         * When safeguard is false, then all the functions will resume working back again!
370         */
371     function changeSafeguardStatus() onlyOwner public{
372         if (safeguard == false){
373             safeguard = true;
374         }
375         else{
376             safeguard = false;    
377         }
378     }
379     
380 
381     /*************************************/
382     /*    Section for User Air drop      */
383     /*************************************/
384     
385     
386     /**
387      * Run an Air-Drop
388      *
389      * It requires an array of all the addresses and amount of tokens to distribute
390      * It will only process first 150 recipients. That limit is fixed to prevent gas limit
391      */
392     function airdrop(address[] memory recipients,uint256[] memory tokenAmount) public  {
393         uint256 totalAddresses = recipients.length;
394         require(totalAddresses <= 150,"Too many recipients");
395         for(uint i = 0; i < totalAddresses; i++)
396         {
397           //This will loop through all the recipients and send them the specified tokens
398           //Input data validation is unncessary, as that is done by SafeMath and which also saves some gas.
399           transfer(recipients[i], tokenAmount[i]);
400         }
401     }
402     
403  
404 
405 }