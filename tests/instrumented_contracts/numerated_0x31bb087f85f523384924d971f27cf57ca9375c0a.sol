1 pragma solidity >=0.4.22 <0.6.0;
2 
3 
4 interface IERC20 {
5     function transfer(address to, uint256 value) external returns (bool);
6 
7     function approve(address spender, uint256 value) external returns (bool);
8 
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address who) external view returns (uint256);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 
23 contract SafeMath {
24   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b > 0);
35     uint256 c = a / b;
36     assert(a == b * c + a % b);
37     return c;
38   }
39 
40   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c>=a && c>=b);
48     return c;
49   }
50 
51 }
52 
53 
54 contract owned {
55     address public owner;
56 
57     constructor() public {
58         owner = msg.sender;
59     }
60 
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     function transferOwnership(address newOwner) onlyOwner public {
67         owner = newOwner;
68     }
69 }
70 
71 
72 contract TokenERC20 is SafeMath, IERC20  {
73  
74     // Public variables of the token
75     string public name;
76     string public symbol;
77     uint8 public decimals = 18;
78     // 18 decimals is the strongly suggested default, avoid changing it
79     uint256 public totalSupply;
80 
81     // This creates an array with all balances
82     mapping (address => uint256) public balanceOf;
83     mapping (address => mapping (address => uint256)) public allowance;
84 
85     // This generates a public event on the blockchain that will notify clients
86     event Transfer(address indexed from, address indexed to, uint256 value);
87     
88     // This generates a public event on the blockchain that will notify clients
89     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90 
91     // This notifies clients about the amount burnt
92     event Burn(address indexed from, uint256 value);
93 
94     /**
95      * Constrctor function
96      *
97      * Initializes contract with initial supply tokens to the creator of the contract
98      */
99     constructor(
100         uint256 initialSupply,
101         string memory tokenName,
102         string memory tokenSymbol
103     ) public {
104         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
105         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
106         name = tokenName;                                       // Set the name for display purposes
107         symbol = tokenSymbol;                                   // Set the symbol for display purposes
108     }
109 
110     /**
111      * Internal transfer, only can be called by this contract
112      */
113     function _transfer(address _from, address _to, uint _value) internal {
114         // Prevent transfer to 0x0 address. Use burn() instead
115         require(_to != address(0x0));
116         // Check if the sender has enough
117         require(balanceOf[_from] >= _value);
118         // Check for overflows
119         require(balanceOf[_to] + _value > balanceOf[_to]);
120         // Save this for an assertion in the future
121         uint previousBalances = balanceOf[_from] + balanceOf[_to];
122         // Subtract from the sender
123         balanceOf[_from] -= _value;
124         // Add the same to the recipient
125         balanceOf[_to] += _value;
126         emit Transfer(_from, _to, _value);
127         // Asserts are used to use static analysis to find bugs in your code. They should never fail
128         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
129     }
130 
131     /**
132      * Transfer tokens
133      *
134      * Send `_value` tokens to `_to` from your account
135      *
136      * @param _to The address of the recipient
137      * @param _value the amount to send
138      */
139     function transfer(address _to, uint256 _value) public returns (bool success) {
140         _transfer(msg.sender, _to, _value);
141         return true;
142     }
143 
144     /**
145      * Transfer tokens from other address
146      *
147      * Send `_value` tokens to `_to` in behalf of `_from`
148      *
149      * @param _from The address of the sender
150      * @param _to The address of the recipient
151      * @param _value the amount to send
152      */
153     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
154         require(_value <= allowance[_from][msg.sender]);     // Check allowance
155         allowance[_from][msg.sender] -= _value;
156         _transfer(_from, _to, _value);
157         return true;
158     }
159 
160     /**
161      * Set allowance for other address
162      *
163      * Allows `_spender` to spend no more than `_value` tokens in your behalf
164      *
165      * @param _spender The address authorized to spend
166      * @param _value the max amount they can spend
167      */
168     function approve(address _spender, uint256 _value) public
169         returns (bool success) {
170         allowance[msg.sender][_spender] = _value;
171         emit Approval(msg.sender, _spender, _value);
172         return true;
173     }
174 
175     /**
176      * Destroy tokens
177      *
178      * Remove `_value` tokens from the system irreversibly
179      *
180      * @param _value the amount of money to burn
181      */
182     function burn(uint256 _value) public returns (bool success) {
183         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
184         balanceOf[msg.sender] -= _value;            // Subtract from the sender
185         totalSupply -= _value;                      // Updates totalSupply
186         emit Burn(msg.sender, _value);
187         return true;
188     }
189 
190     /**
191      * Destroy tokens from other account
192      *
193      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
194      *
195      * @param _from the address of the sender
196      * @param _value the amount of money to burn
197      */
198     function burnFrom(address _from, uint256 _value) public returns (bool success) {
199         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
200         require(_value <= allowance[_from][msg.sender]);    // Check allowance
201         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
202         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
203         totalSupply -= _value;                              // Update totalSupply
204         emit Burn(_from, _value);
205         return true;
206     }
207 }
208 
209 
210 contract LuckyAdvcedWoken is owned, TokenERC20 {
211    
212 
213     mapping (address => bool) public frozenAccount;
214 
215     /* This generates a public event on the blockchain that will notify clients */
216     event FrozenFunds(address target, bool frozen);
217 
218     /* Initializes contract with initial supply tokens to the creator of the contract */
219     constructor(
220         uint256 initialSupply,
221         string memory tokenName,
222         string memory tokenSymbol
223     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
224 
225     /* Internal transfer, only can be called by this contract */
226     function _transfer(address _from, address _to, uint _value) internal {
227         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
228         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
229         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
230         require(!frozenAccount[_from]);                         // Check if sender is frozen
231         require(!frozenAccount[_to]);                           // Check if recipient is frozen
232         balanceOf[_from] -= _value;                             // Subtract from the sender
233         balanceOf[_to] += _value;                               // Add the same to the recipient
234         emit Transfer(_from, _to, _value);
235     }
236 
237     /// @notice Create `mintedAmount` tokens and send it to `target`
238     /// @param target Address to receive the tokens
239     /// @param mintedAmount the amount of tokens it will receive
240     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
241         balanceOf[target] += mintedAmount;
242         totalSupply += mintedAmount;
243         emit Transfer(address(0), address(this), mintedAmount);
244         emit Transfer(address(this), target, mintedAmount);
245     }
246 
247     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
248     /// @param target Address to be frozen
249     /// @param freeze either to freeze it or not
250     function freezeAccount(address target, bool freeze) onlyOwner public {
251         frozenAccount[target] = freeze;
252         emit FrozenFunds(target, freeze);
253     }
254 
255     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
256     /// @param newSellPrice Price the users can sell to the contract
257     /// @param newBuyPrice Price users can buy from the contract
258   
259 }