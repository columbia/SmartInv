1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
4 
5 contract SafeMath {
6     
7     uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
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
49     // Name of token
50     string public name;
51     // Abbreviation of tokens name
52     string public symbol;
53     // Number of decimals token has
54     uint8 public decimals;
55     // Maximum tokens that can be minted
56     uint256 public totalSupply;
57 
58 
59     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
60     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
61     address payable fundsWallet;           // Where should the raised ETH go?
62 
63     // Map of users balances
64     mapping (address => uint256) public balanceOf;
65     // Map of users allowances
66     mapping (address => mapping (address => uint256)) public allowance;
67     // Map of frozen accounts
68     mapping (address => bool) public frozenAccount;
69 
70     // This generates a public event on the blockchain that will notify clients
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     // This generates a public event on the blockchain that will notify clients
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74     // This notifies clients about the amount burnt
75     event Burn(address indexed from, uint256 value);
76     // This generates a public event on the blockchain that will notify clients
77     event FrozenFunds(address target, bool frozen);
78     // This notifies clients about the amount minted
79     event Mint(address indexed _to, uint256 _value);
80 
81 
82 
83     function() payable external{
84         totalEthInWei = totalEthInWei + msg.value;
85         uint256 amount = msg.value * unitsOneEthCanBuy;
86         require(balanceOf[fundsWallet] >= amount);
87 
88         balanceOf[fundsWallet] = balanceOf[fundsWallet] - amount;
89         balanceOf[msg.sender] = balanceOf[msg.sender] + amount;
90 
91         fundsWallet.transfer(msg.value); // Transfers ETH from msg.sender to fundsWallet
92         emit Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain                           
93     }
94 
95     function setUnitsOneEthCanBuy(uint256 amount)onlyOwner public returns (bool success){
96         unitsOneEthCanBuy = amount;
97         return true;
98     }
99 
100     /**
101     * @dev Returns number of tokens in circulation
102     *
103     * @return total number od tokens
104     */
105     function getTotalSupply() public returns (uint256) {
106         return totalSupply;
107     }
108 
109     /**
110      * Internal transfer, only can be called by this contract
111      */
112     function _transfer(address _from, address _to, uint _value) internal {
113         require(!frozenAccount[_from]);                                     // Check if sender is frozen
114         require(!frozenAccount[_to]);                                       // Check if recipient is frozen
115         require (_to != address(0x0));                                      // Prevent transfer to 0x0 address. Use burn() instead
116         require (balanceOf[_from] >= _value);                               // Check if the sender has enough
117         require (safeAdd(balanceOf[_to], _value) >= balanceOf[_to]);        // Check for overflows
118         uint previousBalances = safeAdd(balanceOf[_from], balanceOf[_to]);  // Save this for an assertion in the future
119         balanceOf[_from] = safeSub(balanceOf[_from], _value);               // Subtract from the sender
120         balanceOf[_to] = safeAdd(balanceOf[_to], _value);                   // Add the same to the recipient
121         emit Transfer(_from, _to, _value);
122         assert(safeAdd(balanceOf[_from], balanceOf[_to]) == previousBalances);      // Asserts are used to use static analysis to find bugs in your code. They should never fail
123     }
124 
125     /**
126      * Transfer tokens
127      *
128      * Send `_value` tokens to `_to` from your account
129      *
130      * @param _to The address of the recipient
131      * @param _value the amount to send
132      */
133     function transfer(address _to, uint256 _value) public returns (bool success) {
134         _transfer(msg.sender, _to, _value);
135         return true;
136     }
137 
138     /**
139      * Transfer tokens from other address
140      *
141      * Send `_value` tokens to `_to` in behalf of `_from`
142      *
143      * @param _from The address of the sender
144      * @param _to The address of the recipient
145      * @param _value the amount to send
146      */
147     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
148         require(_value <= allowance[_from][msg.sender]);     // Check allowance
149         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
150         _transfer(_from, _to, _value);
151         return true;
152     }
153 
154     /**
155      * Set allowance for other address
156      *
157      * Allows `_spender` to spend no more than `_value` tokens in your behalf
158      *
159      * @param _spender The address authorized to spend
160      * @param _value the max amount they can spend
161      */
162     function approve(address _spender, uint256 _value) public returns (bool success) {
163         allowance[msg.sender][_spender] = _value;
164         emit Approval(msg.sender, _spender, _value);
165         return true;
166     }
167 
168     /**
169      * Set allowance for other address and notify
170      *
171      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
172      *
173      * @param _spender The address authorized to spend
174      * @param _value the max amount they can spend
175      * @param _extraData some extra information to send to the approved contract
176      */
177     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
178         tokenRecipient spender = tokenRecipient(_spender);
179         if (approve(_spender, _value)) {
180             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
181             return true;
182         }
183     }
184 
185 
186     /// @notice Create `mintedAmount` tokens and send it to `target`
187     /// @param target Address to receive the tokens
188     /// @param mintedAmount the amount of tokens it will receive
189     function mintToken(address target, uint256 mintedAmount) onlyOwner public returns (bool success){
190         totalSupply = safeAdd(totalSupply, mintedAmount);
191         balanceOf[target] = safeAdd(balanceOf[target], mintedAmount);
192         emit Mint(target, mintedAmount);
193         return true;
194     }
195 
196     /**
197      * Destroy tokens
198      *
199      * Remove `burnAmount` tokens from the system irreversibly
200      *
201      * @param burnAmount the amount of money to burn
202      */
203     function burn(uint256 burnAmount) public returns (bool success) {
204         require(balanceOf[msg.sender] >= burnAmount);                           // Check if the sender has enough
205         totalSupply = safeSub(totalSupply, burnAmount);                         // Subtract from total supply
206         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], burnAmount);     // Subtract from the sender
207         emit Burn(msg.sender, burnAmount);
208         return true;
209     }
210 
211     /**
212      * Destroy tokens from other account
213      *
214      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
215      *
216      * @param _from the address of the sender
217      * @param _value the amount of money to burn
218      */
219     function burnFrom(address _from, uint256 _value) public returns (bool success) {
220         require(balanceOf[_from] >= _value);                                  // Check if the targeted balance is enough
221         totalSupply = safeSub(totalSupply, _value);                           // Update supply
222         require(_value <= allowance[_from][msg.sender]);                      // Check allowance
223         balanceOf[_from] = safeSub(balanceOf[_from], _value);                           // Subtract from the targeted balance
224         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);   // Subtract from the sender's allowance
225         emit Burn(_from, _value);
226         return true;
227     }
228 
229     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
230     /// @param target Address to be frozen
231     /// @param freeze either to freeze it or not
232     function freezeAccount(address target, bool freeze) onlyOwner public returns (bool success) {
233         frozenAccount[target] = freeze;                         // Freeze target address
234         emit FrozenFunds(target, freeze);
235         return true;
236     }
237     
238     /// destroy the contract and reclaim the leftover funds.
239     function kill() onlyOwner public returns (bool killed){
240         selfdestruct(msg.sender);
241         return true;
242     }
243 }
244 
245 contract FinalToken is TokenERC20{
246     uint256 tokenamount;
247     
248     /**
249     * @dev Intialises token and all the necesary variable
250     */
251     constructor() public{
252         name = "XY Oracle";
253         symbol = "XYO";
254         decimals = 18;
255         tokenamount = 14198847000;
256 
257         fundsWallet = msg.sender;
258         unitsOneEthCanBuy = 70000;
259 
260         totalSupply = tokenamount * 10 ** uint256(decimals);
261         balanceOf[msg.sender] = totalSupply;
262     }
263 }