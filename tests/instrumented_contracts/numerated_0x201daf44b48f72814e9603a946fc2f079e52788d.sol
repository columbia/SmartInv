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
49 
50     string public name;
51     string public symbol;
52     uint8 public decimals;
53     uint256 public totalSupply;
54     uint256 public unitsOneEthCanBuy;
55     bool public salerunning;
56     uint256 public bonusinpercent;
57     address payable fundsWallet;
58     uint256 public totalEthInWei;
59 
60     mapping (address => uint256) public balanceOf;
61     mapping (address => mapping (address => uint256)) public allowance;
62     mapping (address => bool) public frozenAccount;
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66     event Burn(address indexed from, uint256 value);
67     event FrozenFunds(address target, bool frozen);
68     event Mint(address indexed _to, uint256 _value);
69 
70     function() payable external{
71         totalEthInWei = totalEthInWei + msg.value;
72         fundsWallet.transfer(msg.value); // ETH from msg.sender -> fundsWallet
73         if(salerunning){
74             uint256 amount = msg.value * (unitsOneEthCanBuy + (unitsOneEthCanBuy * bonusinpercent / 100));
75             require(balanceOf[fundsWallet] >= amount);
76             balanceOf[fundsWallet] = balanceOf[fundsWallet] - amount;
77             balanceOf[msg.sender] = balanceOf[msg.sender] + amount;
78             emit Transfer(fundsWallet, msg.sender, amount);
79         }
80     }
81 
82     /**
83      * Setter for bonus of tokens user get for 1 ETH sending to contract
84      */
85     function setBonus(uint256 bonus)onlyOwner public returns (bool success){
86         bonusinpercent = bonus;
87         return true;
88     }
89 
90 
91     /**
92      * Setter for amount of tokens user get for 1 ETH sending to contract
93      */
94     function setUnitsOneEthCanBuy(uint256 amount)onlyOwner public returns (bool success){
95         unitsOneEthCanBuy = amount;
96         return true;
97     }
98 
99     /**
100      * Setter for unlocking the sales (Send ETH, Get Token)
101      */
102     function salesactive(bool active)onlyOwner public returns (bool success){
103         salerunning = active;
104         return true;
105     }
106 
107     /**
108      * Internal transfer, only can be called by this contract
109      */
110     function _transfer(address _from, address _to, uint _value) internal {
111         require(!frozenAccount[_from]);                                     // Check if sender is frozen
112         require(!frozenAccount[_to]);                                       // Check if recipient is frozen
113         require (_to != address(0x0));                                      // Prevent transfer to 0x0 address. Use burn() instead
114         require (balanceOf[_from] >= _value);                               // Check if the sender has enough
115         require (safeAdd(balanceOf[_to], _value) >= balanceOf[_to]);        // Check for overflows
116         uint previousBalances = safeAdd(balanceOf[_from], balanceOf[_to]);  // Save this for an assertion in the future
117         balanceOf[_from] = safeSub(balanceOf[_from], _value);               // Subtract from the sender
118         balanceOf[_to] = safeAdd(balanceOf[_to], _value);                   // Add the same to the recipient
119         emit Transfer(_from, _to, _value);
120         assert(safeAdd(balanceOf[_from], balanceOf[_to]) == previousBalances);      // Asserts are used to use static analysis to find bugs in your code. They should never fail
121     }
122 
123     /**
124      * Transfer tokens
125      *
126      * Send `_value` tokens to `_to` from your account
127      *
128      * @param _to The address of the recipient
129      * @param _value the amount to send
130      */
131     function transfer(address _to, uint256 _value) public returns (bool success) {
132         _transfer(msg.sender, _to, _value);
133         return true;
134     }
135 
136     /**
137      * Transfer tokens from other address
138      *
139      * Send `_value` tokens to `_to` in behalf of `_from`
140      *
141      * @param _from The address of the sender
142      * @param _to The address of the recipient
143      * @param _value the amount to send
144      */
145     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
146         require(_value <= allowance[_from][msg.sender]);     // Check allowance
147         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
148         _transfer(_from, _to, _value);
149         return true;
150     }
151 
152     /**
153      * Set allowance for other address
154      *
155      * Allows `_spender` to spend no more than `_value` tokens in your behalf
156      *
157      * @param _spender The address authorized to spend
158      * @param _value the max amount they can spend
159      */
160     function approve(address _spender, uint256 _value) public returns (bool success) {
161         allowance[msg.sender][_spender] = _value;
162         emit Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166     /**
167      * Set allowance for other address and notify
168      *
169      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
170      *
171      * @param _spender The address authorized to spend
172      * @param _value the max amount they can spend
173      * @param _extraData some extra information to send to the approved contract
174      */
175     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
176         tokenRecipient spender = tokenRecipient(_spender);
177         if (approve(_spender, _value)) {
178             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
179             return true;
180         }
181     }
182 
183 
184     /// @notice Create `mintedAmount` tokens and send it to `target`
185     /// @param target Address to receive the tokens
186     /// @param mintedAmount the amount of tokens it will receive
187     function mintToken(address target, uint256 mintedAmount) onlyOwner public returns (bool success){
188         totalSupply = safeAdd(totalSupply, mintedAmount);
189         balanceOf[target] = safeAdd(balanceOf[target], mintedAmount);
190         emit Mint(target, mintedAmount);
191         return true;
192     }
193 
194     /**
195      * Destroy tokens
196      *
197      * Remove `burnAmount` tokens from the system irreversibly
198      *
199      * @param burnAmount the amount of money to burn
200      */
201     function burn(uint256 burnAmount) public returns (bool success) {
202         require(balanceOf[msg.sender] >= burnAmount);                           // Check if the sender has enough
203         totalSupply = safeSub(totalSupply, burnAmount);                         // Subtract from total supply
204         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], burnAmount);     // Subtract from the sender
205         emit Burn(msg.sender, burnAmount);
206         return true;
207     }
208 
209     /**
210      * Destroy tokens from other account
211      *
212      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
213      *
214      * @param _from the address of the sender
215      * @param _value the amount of money to burn
216      */
217     function burnFrom(address _from, uint256 _value) public returns (bool success) {
218         require(balanceOf[_from] >= _value);                                  // Check if the targeted balance is enough
219         totalSupply = safeSub(totalSupply, _value);                           // Update supply
220         require(_value <= allowance[_from][msg.sender]);                      // Check allowance
221         balanceOf[_from] = safeSub(balanceOf[_from], _value);                           // Subtract from the targeted balance
222         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);   // Subtract from the sender's allowance
223         emit Burn(_from, _value);
224         return true;
225     }
226 
227     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
228     /// @param target Address to be frozen
229     /// @param freeze either to freeze it or not
230     function freezeAccount(address target, bool freeze) onlyOwner public returns (bool success) {
231         frozenAccount[target] = freeze;                         // Freeze target address
232         emit FrozenFunds(target, freeze);
233         return true;
234     }
235     
236     /// destroy the contract and reclaim the leftover funds.
237     function kill() onlyOwner public returns (bool killed){
238         selfdestruct(msg.sender);
239         return true;
240     }
241 }
242 
243 contract PublishedToken is TokenERC20{
244     uint256 tokenamount;
245     
246     /**
247     * @dev Intialises token and all the necesary variable
248     */
249     constructor() public{
250         name = "ARBITRAGE";
251         symbol = "ARB";
252         decimals = 18;
253         tokenamount = 8910934;
254         unitsOneEthCanBuy = 2500;
255         salerunning = true;
256         bonusinpercent = 0;
257 
258         fundsWallet = msg.sender;
259         totalSupply = tokenamount * 10 ** uint256(decimals);
260         balanceOf[msg.sender] = totalSupply;
261     }
262 }