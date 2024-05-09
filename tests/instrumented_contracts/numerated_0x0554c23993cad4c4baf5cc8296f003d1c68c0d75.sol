1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         assert(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         assert(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         assert(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         assert(b > 0);
18         c = a / b;
19         assert(a == b * c + a % b);
20     }
21 }
22 
23 contract ownable {
24     address public owner;
25 
26     function ownable() public {
27         owner = msg.sender;
28     }
29 
30     modifier onlyOwner {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     function transferOwnership(address newOwner) onlyOwner public {
36         owner = newOwner;
37     }
38 
39     function isOwner(address _owner) internal view returns (bool) {
40         return owner == _owner;
41     }
42 }
43 
44 contract Pausable is ownable {
45     bool public paused = false;
46     
47     event Pause();
48     event Unpause();
49     
50     modifier whenNotPaused() {
51         require(!paused);
52         _;
53     }
54     
55     modifier whenPaused() {
56         require(paused);
57         _;
58     }
59     
60     function pause() onlyOwner whenNotPaused public returns (bool success) {
61         paused = true;
62         Pause();
63         return true;
64     }
65   
66     function unpause() onlyOwner whenPaused public returns (bool success) {
67         paused = false;
68         Unpause();
69         return true;
70     }
71 }
72 
73 contract Lockable is Pausable {
74     mapping (address => bool) public locked;
75     
76     event Lockup(address indexed target);
77     event UnLockup(address indexed target);
78     
79     function lockup(address _target) onlyOwner public returns (bool success) {
80         require(!isOwner(_target));
81         locked[_target] = true;
82         Lockup(_target);
83         return true;
84     }
85 
86     function unlockup(address _target) onlyOwner public returns (bool success) {
87         require(!isOwner(_target));
88         delete locked[_target];
89         UnLockup(_target);
90         return true;
91     }
92     
93     function isLockup(address _target) internal view returns (bool) {
94         if(true == locked[_target])
95             return true;
96     }
97 }
98 
99 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
100 
101 contract TokenERC20 {
102     using SafeMath for uint;
103 
104     string public name;
105     string public symbol;
106     uint8 public decimals = 18;
107     
108     // 18 decimals is the strongly suggested default, avoid changing it
109     uint256 public totalSupply;
110 
111     // This creates an array with all balances
112     mapping (address => uint256) public balanceOf;
113     mapping (address => mapping (address => uint256)) public allowance;
114 
115     // This generates a public event on the blockchain that will notify clients
116     event Transfer(address indexed from, address indexed to, uint256 value);
117     // This generates a public event on the blockchain that will notify clients
118     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
119     // This notifies clients about the amount burnt
120     event Burn(address indexed from, uint256 value);
121 
122     /**
123      * Constrctor function
124      * Initializes contract with initial supply tokens to the creator of the contract
125      */
126     function TokenERC20 (
127         uint256 initialSupply,
128         string tokenName,
129         string tokenSymbol
130     ) public {
131         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
132         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
133         name = tokenName;                                   // Set the name for display purposes
134         symbol = tokenSymbol;                               // Set the symbol for display purposes
135     }
136 
137     /**
138      * Internal transfer, only can be called by this contract
139      */
140     function _transfer(address _from, address _to, uint _value) internal {
141         // Prevent transfer to 0x0 address. Use burn() instead
142         require(_to != 0x0);
143         // Check if the sender has enough
144         require(balanceOf[_from] >= _value);
145         // Check for overflows
146         require(SafeMath.add(balanceOf[_to], _value) > balanceOf[_to]);
147 
148         // Save this for an assertion in the future
149         uint previousBalances = SafeMath.add(balanceOf[_from], balanceOf[_to]);
150         // Subtract from the sender
151         balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);
152         // Add the same to the recipient
153         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
154 
155         Transfer(_from, _to, _value);
156         // Asserts are used to use static analysis to find bugs in your code. They should never fail
157         assert(SafeMath.add(balanceOf[_from], balanceOf[_to]) == previousBalances);
158     }
159 
160     /**
161      * Transfer tokens
162      * Send `_value` tokens to `_to` from your account
163      * @param _to The address of the recipient
164      * @param _value the amount to send
165      */
166     function transfer(address _to, uint256 _value) public returns (bool success) {
167         _transfer(msg.sender, _to, _value);
168         return true;
169     }
170 
171     /**
172      * Transfer tokens from other address
173      * Send `_value` tokens to `_to` in behalf of `_from`
174      * @param _from The address of the sender
175      * @param _to The address of the recipient
176      * @param _value the amount to send
177      */
178     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
179         require(_value <= allowance[_from][msg.sender]);
180         allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);
181         _transfer(_from, _to, _value);
182         return true;
183     }
184 
185     /**
186      * Set allowance for other address
187      *
188      * Allows `_spender` to spend no more than `_value` tokens in your behalf
189      *
190      * @param _spender The address authorized to spend
191      * @param _value the max amount they can spend
192      */
193     function approve(address _spender, uint256 _value) public
194         returns (bool success) {
195         allowance[msg.sender][_spender] = _value;
196         Approval(msg.sender, _spender, _value);
197         return true;
198     }
199 
200     /**
201      * Set allowance for other address and notify
202      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
203      * @param _spender The address authorized to spend
204      * @param _value the max amount they can spend
205      * @param _extraData some extra information to send to the approved contract
206      */
207     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
208         public
209         returns (bool success) {
210         tokenRecipient spender = tokenRecipient(_spender);
211         if (approve(_spender, _value)) {
212             spender.receiveApproval(msg.sender, _value, this, _extraData);
213             return true;
214         }
215     }
216 
217     /**
218      * Destroy tokens
219      * Remove `_value` tokens from the system irreversibly
220      * @param _value the amount of money to burn
221      */
222     function burn(uint256 _value) public returns (bool success) {
223         require(balanceOf[msg.sender] >= _value);                               // Check if the sender has enough
224         balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);    // Subtract from the sender
225         totalSupply = SafeMath.sub(totalSupply, _value);                        // Updates totalSupply
226         Burn(msg.sender, _value);
227         return true;
228     }
229 
230     /**
231      * Destroy tokens from other account
232      *
233      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
234      *
235      * @param _from the address of the sender
236      * @param _value the amount of money to burn
237      */
238     function burnFrom(address _from, uint256 _value) public returns (bool success) {
239         require(balanceOf[_from] >= _value);                        // Check if the targeted balance is enough
240         require(_value <= allowance[_from][msg.sender]);            // Check allowance
241         balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);  // Subtract from the targeted balance
242         allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value); // Subtract from the sender's allowance
243         totalSupply = SafeMath.sub(totalSupply, _value);            // Update totalSupply
244         Burn(_from, _value);
245         return true;
246     }
247 }
248 
249 contract ValueToken is Lockable, TokenERC20 {
250     uint256 public sellPrice;
251     uint256 public buyPrice;
252     uint256 public minAmount;
253     uint256 public soldToken;
254 
255     uint internal constant MIN_ETHER        = 1*1e16; // 0.01 ether
256     uint internal constant EXCHANGE_RATE    = 10000;  // 1 eth = 10000 VALUE
257 
258     mapping (address => bool) public frozenAccount;
259 
260     /* This generates a public event on the blockchain that will notify clients */
261     event FrozenFunds(address target, bool frozen);
262     event LogWithdrawContractToken(address indexed owner, uint value);
263     event LogFallbackTracer(address indexed owner, uint value);
264 
265     /* Initializes contract with initial supply tokens to the creator of the contract */
266     function ValueToken (
267         uint256 initialSupply,
268         string tokenName,
269         string tokenSymbol
270     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
271         
272     }
273 
274     /* Internal transfer, only can be called by this contract */
275     function _transfer(address _from, address _to, uint _value) internal {
276         require (_to != 0x0);                                 // Prevent transfer to 0x0 address. Use burn() instead
277         require (balanceOf[_from] >= _value);                 // Check if the sender has enough
278         require (balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
279         require(!frozenAccount[_from]);                       // Check if sender is frozen
280         require(!frozenAccount[_to]);                         // Check if recipient is frozen
281         require(!isLockup(_from));
282         require(!isLockup(_to));
283 
284         balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);   // Subtract from the sender
285         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);       // Add the same to the recipient
286         Transfer(_from, _to, _value);
287     }
288 
289     /// @notice Create `mintedAmount` tokens and send it to `target`
290     /// @param target Address to receive the tokens
291     /// @param mintedAmount the amount of tokens it will receive
292     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
293         balanceOf[target] = SafeMath.add(balanceOf[target], mintedAmount);
294         totalSupply = SafeMath.add(totalSupply, mintedAmount);
295         Transfer(0, this, mintedAmount);
296         Transfer(this, target, mintedAmount);
297     }
298 
299     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
300     /// @param target Address to be frozen
301     /// @param freeze either to freeze it or not
302     function freezeAccount(address target, bool freeze) onlyOwner public {
303         require(!isOwner(target));
304         require(!frozenAccount[target]);
305 
306         frozenAccount[target] = freeze;
307         FrozenFunds(target, freeze);
308     }
309 
310     function withdrawContractToken(uint _value) onlyOwner public returns (bool success) {
311         _transfer(this, msg.sender, _value);
312         LogWithdrawContractToken(msg.sender, _value);
313         return true;
314     }
315     
316     function getContractBalanceOf() public constant returns(uint blance) {
317         blance = balanceOf[this];
318     }
319     
320     // payable
321     function () payable public {
322         require(MIN_ETHER <= msg.value);
323         uint amount = msg.value;
324         uint token = amount.mul(EXCHANGE_RATE);
325         require(token > 0);
326         _transfer(this, msg.sender, amount);
327         LogFallbackTracer(msg.sender, amount);
328     }
329 }