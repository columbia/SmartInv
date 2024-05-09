1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
4 
5 contract SafeMath {
6     
7     uint256 constant MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
8 
9     function safeAdd(uint256 x, uint256 y) internal returns (uint256 z) {
10         require(x <= MAX_UINT256 - y);
11         return x + y;
12     }
13 
14     function safeSub(uint256 x, uint256 y) internal returns (uint256 z) {
15         require(x >= y);
16         return x - y;
17     }
18 
19     function safeMul(uint256 x, uint256 y) internal returns (uint256 z) {
20         if (y == 0) {
21             return 0;
22         }
23         require(x <= (MAX_UINT256 / y));
24         return x * y;
25     }
26 }
27 
28 contract Owned {
29     address public originalOwner;
30     address public owner;
31 
32     constructor() public {
33         originalOwner = msg.sender;
34         owner = originalOwner;
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function transferOwnership(address newOwner) onlyOwner public {
43         require(newOwner != owner);
44         owner = newOwner;
45     }
46 }
47 
48 contract TokenERC20 is SafeMath, Owned{
49     string public name;
50     string public symbol;
51     uint8 public decimals;
52     uint256 public totalSupply;
53     uint256 public unitsOneEthCanBuy;
54     uint256 public totalEthInWei;
55     address payable fundsWallet;
56     uint256 public bonusinpercent;
57     bool salerunning;
58 
59     // Map of users balances
60     mapping (address => uint256) public balanceOf;
61     // Map of users allowances
62     mapping (address => mapping (address => uint256)) public allowance;
63     // Map of frozen accounts
64     mapping (address => bool) public frozenAccount;
65 
66     // This generates a public event on the blockchain that will notify clients
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     // This generates a public event on the blockchain that will notify clients
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70     // This notifies clients about the amount burnt
71     event Burn(address indexed from, uint256 value);
72     // This generates a public event on the blockchain that will notify clients
73     event FrozenFunds(address target, bool frozen);
74     // This notifies clients about the amount minted
75     event Mint(address indexed _to, uint256 _value);
76 
77 
78 
79     function() payable external{
80         totalEthInWei = totalEthInWei + msg.value;
81         fundsWallet.transfer(msg.value); // ETH from msg.sender -> fundsWallet
82 
83         if(salerunning){
84 
85             uint256 amount = msg.value * (unitsOneEthCanBuy + (unitsOneEthCanBuy * bonusinpercent / 100));
86             require(balanceOf[fundsWallet] >= amount);
87 
88             balanceOf[fundsWallet] = balanceOf[fundsWallet] - amount;
89             balanceOf[msg.sender] = balanceOf[msg.sender] + amount;
90             emit Transfer(fundsWallet, msg.sender, amount);
91 
92         }
93     }
94 
95     /**
96      * Setter for bonus of tokens user get for 1 ETH sending to contract
97      */
98     function salesactive(bool active)onlyOwner public returns (bool success){
99         salerunning = active;
100         return true;
101     }
102 
103     /**
104      * Setter for bonus of tokens user get for 1 ETH sending to contract
105      */
106     function setBonus(uint256 bonus)onlyOwner public returns (bool success){
107         bonusinpercent = bonus;
108         return true;
109     }
110 
111 
112     /**
113      * Setter for amount of tokens user get for 1 ETH sending to contract
114      */
115     function setUnitsOneEthCanBuy(uint256 amount)onlyOwner public returns (bool success){
116         unitsOneEthCanBuy = amount;
117         return true;
118     }
119 
120     /**
121     * @dev Returns number of tokens in circulation
122     *
123     * @return total number od tokens
124     */
125     function getTotalSupply() public returns (uint256) {
126         return totalSupply;
127     }
128 
129     /**
130      * Internal transfer, only can be called by this contract
131      */
132     function _transfer(address _from, address _to, uint _value) internal {
133         require(!frozenAccount[_from]);                                     // Check if sender is frozen
134         require(!frozenAccount[_to]);                                       // Check if recipient is frozen
135         require (_to != address(0x0));                                      // Prevent transfer to 0x0 address. Use burn() instead
136         require (balanceOf[_from] >= _value);                               // Check if the sender has enough
137         require (safeAdd(balanceOf[_to], _value) >= balanceOf[_to]);        // Check for overflows
138         uint previousBalances = safeAdd(balanceOf[_from], balanceOf[_to]);  // Save this for an assertion in the future
139         balanceOf[_from] = safeSub(balanceOf[_from], _value);               // Subtract from the sender
140         balanceOf[_to] = safeAdd(balanceOf[_to], _value);                   // Add the same to the recipient
141         emit Transfer(_from, _to, _value);
142         assert(safeAdd(balanceOf[_from], balanceOf[_to]) == previousBalances);      // Asserts are used to use static analysis to find bugs in your code. They should never fail
143     }
144 
145     /**
146      * Transfer tokens
147      *
148      * Send `_value` tokens to `_to` from your account
149      *
150      * @param _to The address of the recipient
151      * @param _value the amount to send
152      */
153     function transfer(address _to, uint256 _value) public returns (bool success) {
154         _transfer(msg.sender, _to, _value);
155         return true;
156     }
157 
158     /**
159      * Transfer tokens from other address
160      *
161      * Send `_value` tokens to `_to` in behalf of `_from`
162      *
163      * @param _from The address of the sender
164      * @param _to The address of the recipient
165      * @param _value the amount to send
166      */
167     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
168         require(_value <= allowance[_from][msg.sender]);     // Check allowance
169         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
170         _transfer(_from, _to, _value);
171         return true;
172     }
173 
174     /**
175      * Set allowance for other address
176      *
177      * Allows `_spender` to spend no more than `_value` tokens in your behalf
178      *
179      * @param _spender The address authorized to spend
180      * @param _value the max amount they can spend
181      */
182     function approve(address _spender, uint256 _value) public returns (bool success) {
183         allowance[msg.sender][_spender] = _value;
184         emit Approval(msg.sender, _spender, _value);
185         return true;
186     }
187 
188     /**
189      * Set allowance for other address and notify
190      *
191      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
192      *
193      * @param _spender The address authorized to spend
194      * @param _value the max amount they can spend
195      * @param _extraData some extra information to send to the approved contract
196      */
197     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
198         tokenRecipient spender = tokenRecipient(_spender);
199         if (approve(_spender, _value)) {
200             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
201             return true;
202         }
203     }
204 
205 
206     /// @notice Create `mintedAmount` tokens and send it to `target`
207     /// @param target Address to receive the tokens
208     /// @param mintedAmount the amount of tokens it will receive
209     function mintToken(address target, uint256 mintedAmount) onlyOwner public returns (bool success){
210         totalSupply = safeAdd(totalSupply, mintedAmount);
211         balanceOf[target] = safeAdd(balanceOf[target], mintedAmount);
212         emit Mint(target, mintedAmount);
213         return true;
214     }
215 
216     /**
217      * Destroy tokens
218      *
219      * Remove `burnAmount` tokens from the system irreversibly
220      *
221      * @param burnAmount the amount of money to burn
222      */
223     function burn(uint256 burnAmount) public returns (bool success) {
224         require(balanceOf[msg.sender] >= burnAmount);                           // Check if the sender has enough
225         totalSupply = safeSub(totalSupply, burnAmount);                         // Subtract from total supply
226         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], burnAmount);     // Subtract from the sender
227         emit Burn(msg.sender, burnAmount);
228         return true;
229     }
230 
231     /**
232      * Destroy tokens from other account
233      *
234      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
235      *
236      * @param _from the address of the sender
237      * @param _value the amount of money to burn
238      */
239     function burnFrom(address _from, uint256 _value) public returns (bool success) {
240         require(balanceOf[_from] >= _value);                                  // Check if the targeted balance is enough
241         totalSupply = safeSub(totalSupply, _value);                           // Update supply
242         require(_value <= allowance[_from][msg.sender]);                      // Check allowance
243         balanceOf[_from] = safeSub(balanceOf[_from], _value);                           // Subtract from the targeted balance
244         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);   // Subtract from the sender's allowance
245         emit Burn(_from, _value);
246         return true;
247     }
248 
249     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
250     /// @param target Address to be frozen
251     /// @param freeze either to freeze it or not
252     function freezeAccount(address target, bool freeze) onlyOwner public returns (bool success) {
253         frozenAccount[target] = freeze;                         // Freeze target address
254         emit FrozenFunds(target, freeze);
255         return true;
256     }
257     
258     /// destroy the contract and reclaim the leftover funds.
259     function kill() onlyOwner public returns (bool killed){
260         selfdestruct(msg.sender);
261         return true;
262     }
263 }
264 
265 contract PublishedToken is TokenERC20{
266     uint256 tokenamount;
267     
268     /**
269     * @dev Intialises token and all the necesary variable
270     */
271     constructor() public{
272         name = "MinerOne";
273         symbol = "MIO";
274         decimals = 18;
275         tokenamount = 16734685;
276         unitsOneEthCanBuy = 100000;
277         salerunning = true;
278         bonusinpercent = 0;
279 
280         fundsWallet = msg.sender;
281         totalSupply = tokenamount * 10 ** uint256(decimals);
282         balanceOf[msg.sender] = totalSupply;
283     }
284 }