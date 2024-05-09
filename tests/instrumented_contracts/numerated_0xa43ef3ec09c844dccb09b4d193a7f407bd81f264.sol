1 pragma solidity ^0.4.18;
2 /*
3 This is based on the standard example of an ERC20 token.
4 */
5 contract owned {
6     address public owner;
7 
8     function owned() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner public {
18         owner = newOwner;
19     }
20 }
21 
22 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
23 
24 contract TokenERC20 {
25     // Public variables of the token
26     string public name;
27     string public symbol;
28     uint8 public decimals = 18;
29 
30     uint256 public totalSupply;
31 
32 
33     mapping (address => uint256) public balanceOf;
34     mapping (address => mapping (address => uint256)) public allowance;
35 
36     // This generates a public event on the blockchain that will notify clients
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     // This notifies clients about the amount burnt
40     event Burn(address indexed from, uint256 value);
41 
42     /**
43      * Constructor function
44      *
45      * Initializes contract with initial supply tokens to the creator of the contract
46      */
47     function TokenERC20(
48         uint256 initialSupply,
49         string tokenName,
50         string tokenSymbol
51     ) public {
52         totalSupply = initialSupply * 10 ** uint256(decimals);                    // Update total supply with the decimal amount
53         balanceOf[msg.sender] = totalSupply;                                      // Give the creator all initial tokens
54         name = tokenName;                                                         // Set the name for display purposes
55         symbol = tokenSymbol;                                                     // Set the symbol for display purposes
56     }
57 
58     /**
59      * Internal transfer, only can be called by this contract
60      */
61     function _transfer(address _from, address _to, uint _value) internal {
62         // Prevent transfer to 0x0 address. Use burn() instead
63         require(_to != 0x0);
64         // Check if the sender has enough
65         require(balanceOf[_from] >= _value);
66         // Check for overflows
67         require(balanceOf[_to] + _value > balanceOf[_to]);
68         // Save this for an assertion in the future
69         uint previousBalances = balanceOf[_from] + balanceOf[_to];
70         // Subtract from the sender
71         balanceOf[_from] -= _value;
72         // Add the same to the recipient
73         balanceOf[_to] += _value;
74         Transfer(_from, _to, _value);
75         // Asserts are used to use static analysis to find bugs in your code. They should never fail
76         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
77     }
78 
79     /**
80      * Transfer tokens
81      *
82      * Send `_value` tokens to `_to` from your account
83      *
84      * @param _to The address of the recipient
85      * @param _value the amount to send
86      */
87     function transfer(address _to, uint256 _value) public {
88         _transfer(msg.sender, _to, _value);
89     }
90 
91     /**
92      * Transfer tokens from other address
93      *
94      * Send `_value` tokens to `_to` in behalf of `_from`
95      *
96      * @param _from The address of the sender
97      * @param _to The address of the recipient
98      * @param _value the amount to send
99      */
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
101         require(_value <= allowance[_from][msg.sender]);     // Check allowance
102         allowance[_from][msg.sender] -= _value;
103         _transfer(_from, _to, _value);
104         return true;
105     }
106 
107     /**
108      * Set allowance for other address
109      *
110      * Allows `_spender` to spend no more than `_value` tokens in your behalf
111      *
112      * @param _spender The address authorized to spend
113      * @param _value the max amount they can spend
114      */
115     function approve(address _spender, uint256 _value) public
116         returns (bool success) {
117         allowance[msg.sender][_spender] = _value;
118         return true;
119     }
120 
121     /**
122      * Set allowance for other address and notify
123      *
124      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      * @param _extraData some extra information to send to the approved contract
129      */
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
131         public
132         returns (bool success) {
133         tokenRecipient spender = tokenRecipient(_spender);
134         if (approve(_spender, _value)) {
135             spender.receiveApproval(msg.sender, _value, this, _extraData);
136             return true;
137         }
138     }
139 
140     /**
141      * Destroy tokens
142      *
143      * Remove `_value` tokens from the system irreversibly
144      *
145      * @param _value the amount of money to burn
146      */
147     function burn(uint256 _value) public returns (bool success) {
148         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
149         balanceOf[msg.sender] -= _value;            // Subtract from the sender
150         totalSupply -= _value;                      // Updates totalSupply
151         Burn(msg.sender, _value);
152         return true;
153     }
154 
155     /**
156      * Destroy tokens from other account
157      *
158      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
159      *
160      * @param _from the address of the sender
161      * @param _value the amount of money to burn
162      */
163     function burnFrom(address _from, uint256 _value) public returns (bool success) {
164         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
165         require(_value <= allowance[_from][msg.sender]);    // Check allowance
166         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
167         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
168         totalSupply -= _value;                              // Update totalSupply
169         Burn(_from, _value);
170         return true;
171     }
172 }
173 
174 contract QRG is owned, TokenERC20 {
175 
176     uint256 public buyPrice;
177     bool public isContractFrozen;
178 
179     mapping (address => bool) public frozenAccount;
180 
181     /* This generates a public event on the blockchain that will notify clients */
182     event FrozenFunds(address target, bool frozen);
183     event FrozenContract(bool frozen);
184 
185     /* Initializes contract with initial supply tokens to the creator of the contract */
186     function QRG(
187         uint256 initialSupply,
188         string tokenName,
189         string tokenSymbol
190     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
191 
192     /* Internal transfer, only can be called by this contract */
193     function _transfer(address _from, address _to, uint _value) internal {
194         require (!isContractFrozen);
195         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
196         require (balanceOf[_from] >= _value);               // Check if the sender has enough
197         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
198         require(!frozenAccount[_from]);                     // Check if sender is frozen
199         require(!frozenAccount[_to]);                       // Check if recipient is frozen
200         balanceOf[_from] -= _value;                         // Subtract from the sender
201         balanceOf[_to] += _value;                           // Add the same to the recipient
202         Transfer(_from, _to, _value);
203     }
204 
205     /// @notice Create `mintedAmount` tokens and send it to `target`
206     /// @param target Address to receive the tokens
207     /// @param mintedAmount the amount of tokens it will receive
208     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
209         balanceOf[target] += mintedAmount;
210         totalSupply += mintedAmount;
211         Transfer(0, this, mintedAmount);
212         Transfer(this, target, mintedAmount);
213     }
214 
215     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
216     /// @param target Address to be frozen
217     /// @param freeze either to freeze it or not
218     function freezeAccount(address target, bool freeze) onlyOwner public {
219         frozenAccount[target] = freeze;
220         FrozenFunds(target, freeze);
221     }
222 
223     function freezeContract(bool freeze) onlyOwner public {
224         isContractFrozen = freeze;
225         FrozenContract(freeze);           // triggers network event
226     }
227 
228     function withdrawTokens(uint256 amount) onlyOwner public{
229         _transfer(this, msg.sender, amount);
230     }
231 
232     function kill() onlyOwner public{
233         selfdestruct(msg.sender);
234     }
235 }