1 pragma solidity 0.5.11; /*
2 
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
13  █████╗ ███████╗██╗   ██╗███╗   ███╗ █████╗      ██████╗ ██████╗ ██╗███╗   ██╗
14 ██╔══██╗╚══███╔╝██║   ██║████╗ ████║██╔══██╗    ██╔════╝██╔═══██╗██║████╗  ██║
15 ███████║  ███╔╝ ██║   ██║██╔████╔██║███████║    ██║     ██║   ██║██║██╔██╗ ██║
16 ██╔══██║ ███╔╝  ██║   ██║██║╚██╔╝██║██╔══██║    ██║     ██║   ██║██║██║╚██╗██║
17 ██║  ██║███████╗╚██████╔╝██║ ╚═╝ ██║██║  ██║    ╚██████╗╚██████╔╝██║██║ ╚████║
18 ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝     ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝
19                                                                               
20                                                                               
21 
22 === 'Azumacoin' Token contract with following features ===
23     => ERC20 Compliance
24     => Higher degree of control by owner - safeguard functionality
25     => SafeMath implementation 
26     => Burnable and minting 
27 
28 
29 ======================= Quick Stats ===================
30     => Name        : Azuma coin
31     => Symbol      : Azum
32     => Total supply: 500,000,000 (500 Million)
33     => Decimals    : 18
34 
35 
36 ============= Independant Audit of the code ============
37     => Multiple Freelancers Auditors
38 
39 
40 
41 -------------------------------------------------------------------
42  Copyright (c) 2019 onwards Azuma Coin Inc. ( https://Azumacoin.io )
43  Contract designed with ❤ by EtherAuthority ( https://EtherAuthority.io )
44 -------------------------------------------------------------------
45 */ 
46 
47 
48 
49 
50 //*******************************************************************//
51 //------------------------ SafeMath Library -------------------------//
52 //*******************************************************************//
53 /**
54     * @title SafeMath
55     * @dev Math operations with safety checks that throw on error
56     */
57 library SafeMath {
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59     if (a == 0) {
60         return 0;
61     }
62     uint256 c = a * b;
63     require(c / a == b, 'SafeMath mul failed');
64     return c;
65     }
66 
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68     // assert(b > 0); // Solidity automatically throws when dividing by 0
69     uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71     return c;
72     }
73 
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     require(b <= a, 'SafeMath sub failed');
76     return a - b;
77     }
78 
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a + b;
81     require(c >= a, 'SafeMath add failed');
82     return c;
83     }
84 }
85 
86 
87 //*******************************************************************//
88 //------------------ Contract to Manage Ownership -------------------//
89 //*******************************************************************//
90     
91 contract owned {
92     address payable public owner;
93     address payable internal newOwner;
94 
95     event OwnershipTransferred(address indexed _from, address indexed _to);
96 
97     constructor() public {
98         owner = msg.sender;
99     }
100 
101     modifier onlyOwner {
102         require(msg.sender == owner);
103         _;
104     }
105 
106     function transferOwnership(address payable _newOwner) public onlyOwner {
107         newOwner = _newOwner;
108     }
109 
110     //this flow is to prevent transferring ownership to wrong wallet by mistake
111     function acceptOwnership() public {
112         require(msg.sender == newOwner);
113         emit OwnershipTransferred(owner, newOwner);
114         owner = newOwner;
115         newOwner = address(0);
116     }
117 }
118  
119 
120     
121 //****************************************************************************//
122 //---------------------        MAIN CODE STARTS HERE     ---------------------//
123 //****************************************************************************//
124     
125 contract Azumacoin is owned {
126     
127 
128     /*===============================
129     =         DATA STORAGE          =
130     ===============================*/
131 
132     // Public variables of the token
133     using SafeMath for uint256;
134     string constant public name = "Azuma coin";
135     string constant public symbol = "AZUM";
136     uint256 constant public decimals = 18;
137     uint256 constant public maxSupply = 500000000 * (10**decimals);   //500 million tokens
138     uint256 public totalSupply;
139     bool public safeguard;      //putting safeguard on will halt all non-owner functions
140     
141     
142     // This creates a mapping with all data storage
143     mapping (address => uint256) public balanceOf;
144     mapping (address => mapping (address => uint256)) public allowance;
145     mapping (address => bool) public frozenAccount;
146 
147 
148     /*===============================
149     =         PUBLIC EVENTS         =
150     ===============================*/
151 
152     // This generates a public event of token transfer
153     event Transfer(address indexed from, address indexed to, uint256 value);
154 
155     // This notifies clients about the amount burnt
156     event Burn(address indexed from, uint256 value);
157         
158     // This generates a public event for frozen (blacklisting) accounts
159     event FrozenAccounts(address target, bool frozen);
160     
161     // This will log approval of token Transfer
162     event Approval(address indexed from, address indexed spender, uint256 value);
163 
164 
165 
166     /*======================================
167     =       STANDARD ERC20 FUNCTIONS       =
168     ======================================*/
169 
170     /* Internal transfer, only can be called by this contract */
171     function _transfer(address _from, address _to, uint _value) internal {
172         
173         //checking conditions
174         require(!safeguard);
175         require(!frozenAccount[_from]);                     // Check if sender is frozen
176         require(!frozenAccount[_to]);                       // Check if recipient is frozen
177         
178         // overflow and undeflow checked by SafeMath Library
179         balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
180         balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
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
195         
196         //no need to check for input validations, as that is ruled by SafeMath
197         _transfer(msg.sender, _to, _value);
198         
199         return true;
200     }
201 
202     /**
203         * Transfer tokens from other address
204         *
205         * Send `_value` tokens to `_to` in behalf of `_from`
206         *
207         * @param _from The address of the sender
208         * @param _to The address of the recipient
209         * @param _value the amount to send
210         */
211     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
212         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
213         _transfer(_from, _to, _value);
214         return true;
215     }
216 
217     /**
218         * Set allowance for other address
219         *
220         * Allows `_spender` to spend no more than `_value` tokens in your behalf
221         *
222         * @param _spender The address authorized to spend
223         * @param _value the max amount they can spend
224         */
225     function approve(address _spender, uint256 _value) public returns (bool success) {
226         require(!safeguard);
227         require(balanceOf[msg.sender] >= _value, "Balance does not have enough tokens");
228         allowance[msg.sender][_spender] = _value;
229         emit Approval(msg.sender, _spender, _value);
230         return true;
231     }
232 
233 
234     /*=====================================
235     =       CUSTOM PUBLIC FUNCTIONS       =
236     ======================================*/
237     
238     constructor() public{
239         
240         totalSupply = maxSupply;
241         
242         //sending all the tokens to Owner
243         balanceOf[owner] = totalSupply;
244         
245         //firing event which logs this transaction
246         emit Transfer(address(0), owner, totalSupply);
247     }
248     
249     //just accept incoming ether
250     function () external payable {}
251 
252     /**
253         * Destroy tokens
254         *
255         * Remove `_value` tokens from the system irreversibly
256         *
257         * @param _value the amount of money to burn
258         */
259     function burn(uint256 _value) public returns (bool success) {
260         require(!safeguard);
261         //checking of enough token balance is done by SafeMath
262         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);  // Subtract from the sender
263         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
264         emit Burn(msg.sender, _value);
265         emit Transfer(msg.sender, address(0), _value);
266         return true;
267     }
268 
269     /**
270         * Destroy tokens from other account
271         *
272         * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
273         *
274         * @param _from the address of the sender
275         * @param _value the amount of money to burn
276         */
277     function burnFrom(address _from, uint256 _value) public returns (bool success) {
278         require(!safeguard);
279         //checking of allowance and token value is done by SafeMath
280         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
281         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value); // Subtract from the sender's allowance
282         totalSupply = totalSupply.sub(_value);                                   // Update totalSupply
283         emit  Burn(_from, _value);
284         emit Transfer(_from, address(0), _value);
285         return true;
286     }
287         
288     
289     /** 
290         * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
291         * @param target Address to be frozen
292         * @param freeze either to freeze it or not
293         */
294     function freezeAccount(address target, bool freeze) onlyOwner public {
295             frozenAccount[target] = freeze;
296         emit  FrozenAccounts(target, freeze);
297     }
298     
299     /** 
300         * @notice Create `mintedAmount` tokens and send it to `target`
301         * @param target Address to receive the tokens
302         * @param mintedAmount the amount of tokens it will receive
303         */
304     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
305         
306         //can not mint more than maxSupply
307         require(totalSupply.add(mintedAmount) <= maxSupply, 'can not mint more than maxSupply');
308         
309         balanceOf[target] = balanceOf[target].add(mintedAmount);
310         totalSupply = totalSupply.add(mintedAmount);
311         emit Transfer(address(0), target, mintedAmount);
312     }
313 
314 
315 
316     /**
317         * Owner can transfer tokens from contract to owner address
318         *
319         * When safeguard is true, then all the non-owner functions will stop working.
320         * When safeguard is false, then all the functions will resume working back again!
321         */
322     
323     function manualWithdrawTokens(uint256 tokenAmount) public onlyOwner{
324         // no need for overflow checking as that will be done in transfer function
325         _transfer(address(this), owner, tokenAmount);
326     }
327     
328     //Just in rare case, owner wants to transfer Ether from contract to owner address
329     function manualWithdrawEther()onlyOwner public{
330         address(owner).transfer(address(this).balance);
331     }
332     
333     /**
334         * Change safeguard status on or off
335         *
336         * When safeguard is true, then all the non-owner functions will stop working.
337         * When safeguard is false, then all the functions will resume working back again!
338         */
339     function changeSafeguardStatus() onlyOwner public{
340         if (safeguard == false){
341             safeguard = true;
342         }
343         else{
344             safeguard = false;    
345         }
346     }
347 
348     
349 
350 }