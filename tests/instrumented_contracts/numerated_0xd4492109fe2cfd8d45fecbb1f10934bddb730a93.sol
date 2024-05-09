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
83      * Batch Token transfer (Airdrop) function || Every address gets unique amount
84      */
85     function bulkDropAllUnique(address[] memory _addrs, uint256[] memory _amounts)onlyOwner public returns (uint256 sendTokensTotal){
86         uint256 sum = 0;
87         for(uint256 i = 0; i < _addrs.length; i++){
88             transfer(_addrs[i], _amounts[i] * 10 ** uint256(decimals));
89             sum += _amounts[i] * 10 ** uint256(decimals);
90         }
91         return sum;
92     }
93 
94     /**
95      * Batch Token transfer (Airdrop) function || All addresses get same amount
96      */
97     function bulkDropAllSame(address[] memory _addrs, uint256 _amount)onlyOwner public returns (uint256 sendTokensTotal){
98         uint256 sum = 0;
99         for(uint256 i = 0; i < _addrs.length; i++){
100             transfer(_addrs[i], _amount * 10 ** uint256(decimals));
101             sum += _amount * 10 ** uint256(decimals);
102         }
103         return sum;
104     }
105 
106     /**
107      * Batch Token transfer (Airdrop) function || Every address gets random amount (min,max)
108      */
109     function bulkDropAllRandom(address[] memory _addrs, uint256 minimum, uint256 maximum)onlyOwner public returns (uint256 sendTokensTotal){
110         uint256 sum = 0;
111         uint256 amount = 0;
112         for(uint256 i = 0; i < _addrs.length; i++){
113             amount = getRndInteger(minimum,maximum);
114             transfer(_addrs[i], amount * 10 ** uint256(decimals));
115             sum += amount * 10 ** uint256(decimals);
116         }
117         return sum;
118     }
119 
120     uint nonce = 0;
121     // Random integer between min and max
122     function getRndInteger(uint256 min, uint256 max) internal returns (uint) {
123         nonce += 1;
124         uint temp = uint(keccak256(abi.encodePacked(nonce)));
125         while(temp<min || temp>max){
126             temp = temp % max;
127             if(temp>=min){return temp;}
128             temp = temp + min;
129         }
130         return temp;
131     }
132 
133     /**
134      * Setter for bonus of tokens user get for 1 ETH sending to contract
135      */
136     function setBonus(uint256 bonus)onlyOwner public returns (bool success){
137         bonusinpercent = bonus;
138         return true;
139     }
140 
141 
142     /**
143      * Setter for amount of tokens user get for 1 ETH sending to contract
144      */
145     function setUnitsOneEthCanBuy(uint256 amount)onlyOwner public returns (bool success){
146         unitsOneEthCanBuy = amount;
147         return true;
148     }
149 
150     /**
151      * Setter for unlocking the sales (Send ETH, Get Token)
152      */
153     function salesactive(bool active)onlyOwner public returns (bool success){
154         salerunning = active;
155         return true;
156     }
157 
158     /**
159      * Internal transfer, only can be called by this contract
160      */
161     function _transfer(address _from, address _to, uint _value) internal {
162         require(!frozenAccount[_from]);                                     // Check if sender is frozen
163         require(!frozenAccount[_to]);                                       // Check if recipient is frozen
164         require (_to != address(0x0));                                      // Prevent transfer to 0x0 address. Use burn() instead
165         require (balanceOf[_from] >= _value);                               // Check if the sender has enough
166         require (safeAdd(balanceOf[_to], _value) >= balanceOf[_to]);        // Check for overflows
167         uint previousBalances = safeAdd(balanceOf[_from], balanceOf[_to]);  // Save this for an assertion in the future
168         balanceOf[_from] = safeSub(balanceOf[_from], _value);               // Subtract from the sender
169         balanceOf[_to] = safeAdd(balanceOf[_to], _value);                   // Add the same to the recipient
170         emit Transfer(_from, _to, _value);
171         assert(safeAdd(balanceOf[_from], balanceOf[_to]) == previousBalances);      // Asserts are used to use static analysis to find bugs in your code. They should never fail
172     }
173 
174     /**
175      * Transfer tokens
176      *
177      * Send `_value` tokens to `_to` from your account
178      *
179      * @param _to The address of the recipient
180      * @param _value the amount to send
181      */
182     function transfer(address _to, uint256 _value) public returns (bool success) {
183         _transfer(msg.sender, _to, _value);
184         return true;
185     }
186 
187     /**
188      * Transfer tokens from other address
189      *
190      * Send `_value` tokens to `_to` in behalf of `_from`
191      *
192      * @param _from The address of the sender
193      * @param _to The address of the recipient
194      * @param _value the amount to send
195      */
196     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
197         require(_value <= allowance[_from][msg.sender]);     // Check allowance
198         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
199         _transfer(_from, _to, _value);
200         return true;
201     }
202 
203     /**
204      * Set allowance for other address
205      *
206      * Allows `_spender` to spend no more than `_value` tokens in your behalf
207      *
208      * @param _spender The address authorized to spend
209      * @param _value the max amount they can spend
210      */
211     function approve(address _spender, uint256 _value) public returns (bool success) {
212         allowance[msg.sender][_spender] = _value;
213         emit Approval(msg.sender, _spender, _value);
214         return true;
215     }
216 
217     /**
218      * Set allowance for other address and notify
219      *
220      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
221      *
222      * @param _spender The address authorized to spend
223      * @param _value the max amount they can spend
224      * @param _extraData some extra information to send to the approved contract
225      */
226     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
227         tokenRecipient spender = tokenRecipient(_spender);
228         if (approve(_spender, _value)) {
229             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
230             return true;
231         }
232     }
233 
234 
235     /// @notice Create `mintedAmount` tokens and send it to `target`
236     /// @param target Address to receive the tokens
237     /// @param mintedAmount the amount of tokens it will receive
238     function mintToken(address target, uint256 mintedAmount) onlyOwner public returns (bool success){
239         totalSupply = safeAdd(totalSupply, mintedAmount);
240         balanceOf[target] = safeAdd(balanceOf[target], mintedAmount);
241         emit Mint(target, mintedAmount);
242         return true;
243     }
244 
245     /**
246      * Destroy tokens
247      *
248      * Remove `burnAmount` tokens from the system irreversibly
249      *
250      * @param burnAmount the amount of money to burn
251      */
252     function burn(uint256 burnAmount) public returns (bool success) {
253         require(balanceOf[msg.sender] >= burnAmount);                           // Check if the sender has enough
254         totalSupply = safeSub(totalSupply, burnAmount);                         // Subtract from total supply
255         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], burnAmount);     // Subtract from the sender
256         emit Burn(msg.sender, burnAmount);
257         return true;
258     }
259 
260     /**
261      * Destroy tokens from other account
262      *
263      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
264      *
265      * @param _from the address of the sender
266      * @param _value the amount of money to burn
267      */
268     function burnFrom(address _from, uint256 _value) public returns (bool success) {
269         require(balanceOf[_from] >= _value);                                  // Check if the targeted balance is enough
270         totalSupply = safeSub(totalSupply, _value);                           // Update supply
271         require(_value <= allowance[_from][msg.sender]);                      // Check allowance
272         balanceOf[_from] = safeSub(balanceOf[_from], _value);                           // Subtract from the targeted balance
273         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);   // Subtract from the sender's allowance
274         emit Burn(_from, _value);
275         return true;
276     }
277 
278     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
279     /// @param target Address to be frozen
280     /// @param freeze either to freeze it or not
281     function freezeAccount(address target, bool freeze) onlyOwner public returns (bool success) {
282         frozenAccount[target] = freeze;                         // Freeze target address
283         emit FrozenFunds(target, freeze);
284         return true;
285     }
286     
287     /// destroy the contract and reclaim the leftover funds.
288     function kill() onlyOwner public returns (bool killed){
289         selfdestruct(msg.sender);
290         return true;
291     }
292 }
293 
294 contract PublishedToken is TokenERC20{
295     uint256 tokenamount;
296     
297     /**
298     * @dev Intialises token and all the necesary variable
299     */
300     constructor() public{
301         name = "Evedo Token";
302         symbol = "EVED";
303         decimals = 18;
304         tokenamount = 160000000;
305         unitsOneEthCanBuy = 2000;
306         salerunning = true;
307         bonusinpercent = 35;
308 
309         fundsWallet = msg.sender;
310         totalSupply = tokenamount * 10 ** uint256(decimals);
311         balanceOf[msg.sender] = totalSupply;
312     }
313 }