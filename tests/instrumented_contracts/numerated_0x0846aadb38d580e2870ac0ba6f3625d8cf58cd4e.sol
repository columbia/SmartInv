1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract stoppable{
21     /// share holder
22     struct ShareHolder {
23         address addr;// shareholder address
24         bool agree;// authorized
25     }
26 
27     ShareHolder[] public shareHolders4;// exactly 4, constructor param
28 
29     function _sh_init(address[] shareHolderAddresses4) internal {
30         require(shareHolderAddresses4.length==4,"only support 4 shareholders.");
31         for (uint i = 0; i < shareHolderAddresses4.length; i++) {
32             shareHolders4.push(ShareHolder({
33                 addr: shareHolderAddresses4[i],
34                 agree: false
35             }));
36         }
37     }
38 
39     function _sh_index(address target) internal view returns (uint) {
40         for(uint i=0;i<shareHolders4.length;i++){
41             if(target == shareHolders4[i].addr){
42                 return i;
43             }
44         }
45         return shareHolders4.length;
46     }
47 
48     function _sh_clear_agree() internal {
49         for(uint i=0;i<shareHolders4.length;i++){
50             shareHolders4[i].agree = false;
51         }
52     }
53 
54     function sh_doAgree() public {
55         uint i = _sh_index(msg.sender);
56         require(i<shareHolders4.length, "not valid shareholder.");
57 
58         shareHolders4[i].agree = true;
59     }
60 
61     function sh_doTransfer(address other) public {
62         uint i1 = _sh_index(msg.sender);
63         require(i1<shareHolders4.length,"self is not valid shareholder.");
64 
65         uint i2 = _sh_index(other);
66         require(i2==shareHolders4.length,"other is alreay shareholder.");
67 
68         shareHolders4[i1].addr = other;
69         shareHolders4[i1].agree = false;
70     }
71 
72     modifier sh_agreed {
73         uint sum = 0;
74         for(uint i=0;i<shareHolders4.length;i++){
75             if(shareHolders4[i].agree){
76                 sum += 1;
77             }
78         }
79         require(sum >= 3, "need at least 3 shareholders to agree.");
80         _;
81     }
82 
83     /// running
84 
85     bool public isRunning = true;
86 
87     function start() public sh_agreed returns (bool currentStatus) {
88         require(!isRunning, "contract is running already.");
89         isRunning = true;
90         _sh_clear_agree();
91         return isRunning;
92     }
93 
94     function stop() public sh_agreed returns (bool currentStatus) {
95         require(isRunning, "contract is not running already.");
96         isRunning = false;
97         _sh_clear_agree();
98         return isRunning;
99     }
100 
101     modifier ifRunning {
102         require(isRunning, "contract is not running.");
103         _;
104     }
105 }
106 
107 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
108 
109 contract TokenERC20 is stoppable{
110     // Public variables of the token
111     string public name;
112     string public symbol;
113     uint8 public decimals = 18;
114     // 18 decimals is the strongly suggested default, avoid changing it
115     uint256 public totalSupply;
116 
117     // This creates an array with all balances
118     mapping (address => uint256) public balanceOf;
119     mapping (address => mapping (address => uint256)) public allowance;
120 
121     // This generates a public event on the blockchain that will notify clients
122     event Transfer(address indexed from, address indexed to, uint256 value);
123     
124     // This generates a public event on the blockchain that will notify clients
125     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
126 
127     // This notifies clients about the amount burnt
128     event Burn(address indexed from, uint256 value);
129 
130     /**
131      * Constrctor function
132      *
133      * Initializes contract with initial supply tokens to the creator of the contract
134      */
135     constructor(
136         uint256 initialSupply,
137         string tokenName,
138         string tokenSymbol
139     ) public {
140         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
141         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
142         name = tokenName;                                   // Set the name for display purposes
143         symbol = tokenSymbol;                               // Set the symbol for display purposes
144     }
145 
146     /**
147      * Internal transfer, only can be called by this contract
148      */
149     function _transfer(address _from, address _to, uint _value) internal {
150         // Prevent transfer to 0x0 address. Use burn() instead
151         require(_to != 0x0);
152         // Check if the sender has enough
153         require(balanceOf[_from] >= _value);
154         // Check for overflows
155         require(balanceOf[_to] + _value > balanceOf[_to]);
156         // Save this for an assertion in the future
157         uint previousBalances = balanceOf[_from] + balanceOf[_to];
158         // Subtract from the sender
159         balanceOf[_from] -= _value;
160         // Add the same to the recipient
161         balanceOf[_to] += _value;
162         emit Transfer(_from, _to, _value);
163         // Asserts are used to use static analysis to find bugs in your code. They should never fail
164         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
165     }
166 
167     /**
168      * Transfer tokens
169      *
170      * Send `_value` tokens to `_to` from your account
171      *
172      * @param _to The address of the recipient
173      * @param _value the amount to send
174      */
175     function transfer(address _to, uint256 _value) public ifRunning returns (bool success) {
176         _transfer(msg.sender, _to, _value);
177         return true;
178     }
179 
180     /**
181      * Transfer tokens from other address
182      *
183      * Send `_value` tokens to `_to` in behalf of `_from`
184      *
185      * @param _from The address of the sender
186      * @param _to The address of the recipient
187      * @param _value the amount to send
188      */
189     function transferFrom(address _from, address _to, uint256 _value) public ifRunning returns (bool success) {
190         require(_value <= allowance[_from][msg.sender]);     // Check allowance
191         allowance[_from][msg.sender] -= _value;
192         _transfer(_from, _to, _value);
193         return true;
194     }
195 
196     /**
197      * Set allowance for other address
198      *
199      * Allows `_spender` to spend no more than `_value` tokens in your behalf
200      *
201      * @param _spender The address authorized to spend
202      * @param _value the max amount they can spend
203      */
204     function approve(address _spender, uint256 _value) public ifRunning
205         returns (bool success) {
206         allowance[msg.sender][_spender] = _value;
207         emit Approval(msg.sender, _spender, _value);
208         return true;
209     }
210 
211     /**
212      * Set allowance for other address and notify
213      *
214      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
215      *
216      * @param _spender The address authorized to spend
217      * @param _value the max amount they can spend
218      * @param _extraData some extra information to send to the approved contract
219      */
220     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
221         public ifRunning
222         returns (bool success) {
223         tokenRecipient spender = tokenRecipient(_spender);
224         if (approve(_spender, _value)) {
225             spender.receiveApproval(msg.sender, _value, this, _extraData);
226             return true;
227         }
228     }
229 
230     /**
231      * Destroy tokens
232      *
233      * Remove `_value` tokens from the system irreversibly
234      *
235      * @param _value the amount of money to burn
236      */
237     function burn(uint256 _value) public ifRunning returns (bool success) {
238         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
239         balanceOf[msg.sender] -= _value;            // Subtract from the sender
240         totalSupply -= _value;                      // Updates totalSupply
241         emit Burn(msg.sender, _value);
242         return true;
243     }
244 
245     /**
246      * Destroy tokens from other account
247      *
248      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
249      *
250      * @param _from the address of the sender
251      * @param _value the amount of money to burn
252      */
253     function burnFrom(address _from, uint256 _value) public ifRunning returns (bool success) {
254         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
255         require(_value <= allowance[_from][msg.sender]);    // Check allowance
256         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
257         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
258         totalSupply -= _value;                              // Update totalSupply
259         emit Burn(_from, _value);
260         return true;
261     }
262 }
263 
264 /******************************************/
265 /*       ADVANCED TOKEN STARTS HERE       */
266 /******************************************/
267 
268 contract MyAdvancedToken is owned, TokenERC20 {
269 
270     uint256 public sellPrice;
271     uint256 public buyPrice;
272 
273     mapping (address => bool) public frozenAccount;
274 
275     /* This generates a public event on the blockchain that will notify clients */
276     event FrozenFunds(address target, bool frozen);
277 
278     /* Initializes contract with initial supply tokens to the creator of the contract */
279     constructor(
280         uint256 initialSupply,
281         string tokenName,
282         string tokenSymbol,
283         address[] shareHolderAddresses4
284     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
285         _sh_init(shareHolderAddresses4);
286     }
287 
288     /* Internal transfer, only can be called by this contract */
289     function _transfer(address _from, address _to, uint _value) internal {
290         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
291         require (balanceOf[_from] >= _value);               // Check if the sender has enough
292         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
293         require(!frozenAccount[_from]);                     // Check if sender is frozen
294         require(!frozenAccount[_to]);                       // Check if recipient is frozen
295         balanceOf[_from] -= _value;                         // Subtract from the sender
296         balanceOf[_to] += _value;                           // Add the same to the recipient
297         emit Transfer(_from, _to, _value);
298     }
299 
300     /// @notice Create `mintedAmount` tokens and send it to `target`
301     /// @param target Address to receive the tokens
302     /// @param mintedAmount the amount of tokens it will receive
303     function mintToken(address target, uint256 mintedAmount) public onlyOwner {
304         balanceOf[target] += mintedAmount;
305         totalSupply += mintedAmount;
306         emit Transfer(0, this, mintedAmount);
307         emit Transfer(this, target, mintedAmount);
308     }
309 
310     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
311     /// @param target Address to be frozen
312     /// @param freeze either to freeze it or not
313     function freezeAccount(address target, bool freeze) public onlyOwner {
314         frozenAccount[target] = freeze;
315         emit FrozenFunds(target, freeze);
316     }
317 
318     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
319     /// @param newSellPrice Price the users can sell to the contract
320     /// @param newBuyPrice Price users can buy from the contract
321     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
322         sellPrice = newSellPrice;
323         buyPrice = newBuyPrice;
324     }
325 
326     /// @notice Buy tokens from contract by sending ether
327     function buy() payable public ifRunning {
328         uint amount = msg.value / buyPrice;               // calculates the amount
329         _transfer(this, msg.sender, amount);              // makes the transfers
330     }
331 
332     /// @notice Sell `amount` tokens to contract
333     /// @param amount amount of tokens to be sold
334     function sell(uint256 amount) public ifRunning {
335         address myAddress = this;
336         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
337         _transfer(msg.sender, this, amount);              // makes the transfers
338         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
339     }
340 }