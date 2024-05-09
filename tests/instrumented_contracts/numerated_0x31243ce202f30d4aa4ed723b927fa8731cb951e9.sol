1 pragma solidity ^0.4.16;
2 
3 // -------------------------------------------------------------------------------
4 // 'Numisma' token contract
5 //
6 // Symbol      : NUM
7 // Name        : Numisma
8 // Total supply: 1000000
9 // Decimals    : 0
10 // Version     : 1.0
11 //
12 // Created just for fun to test 0 value issuable and shareble points. 
13 // 
14 // -------------------------------------------------------------------------------
15 
16 
17 contract owned {
18     address public owner;
19 
20     function owned() public {
21         owner = msg.sender;
22     }
23 
24     modifier onlyOwner {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     function transferOwnership(address newOwner) onlyOwner public {
30         owner = newOwner;
31     }
32 }
33 
34 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
35 
36 contract TokenERC20 {
37     // Public variables of the token
38     string public name;
39     string public symbol;
40     uint8 public decimals = 0;
41     // 18 decimals is the strongly suggested default, avoid changing it
42     uint256 public totalSupply;
43 
44     // This creates an array with all balances
45     mapping (address => uint256) public balanceOf;
46     mapping (address => mapping (address => uint256)) public allowance;
47 
48     // This generates a public event on the blockchain that will notify clients
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     // This notifies clients about the amount burnt
52     event Burn(address indexed from, uint256 value);
53 
54     /**
55      * Constrctor function
56      *
57      * Initializes contract with initial supply tokens to the creator of the contract
58      */
59     function TokenERC20(
60         uint256 initialSupply,
61         string tokenName,
62         string tokenSymbol
63     ) public {
64         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
65         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
66         name = tokenName;                                   // Set the name for display purposes
67         symbol = tokenSymbol;                               // Set the symbol for display purposes
68     }
69 
70     /**
71      * Internal transfer, only can be called by this contract
72      */
73     function _transfer(address _from, address _to, uint _value) internal {
74         // Prevent transfer to 0x0 address. Use burn() instead
75         require(_to != 0x0);
76         // Check if the sender has enough
77         require(balanceOf[_from] >= _value);
78         // Check for overflows
79         require(balanceOf[_to] + _value > balanceOf[_to]);
80         // Save this for an assertion in the future
81         uint previousBalances = balanceOf[_from] + balanceOf[_to];
82         // Subtract from the sender
83         balanceOf[_from] -= _value;
84         // Add the same to the recipient
85         balanceOf[_to] += _value;
86         Transfer(_from, _to, _value);
87         // Asserts are used to use static analysis to find bugs in your code. They should never fail
88         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
89     }
90 
91     /**
92      * Transfer tokens
93      *
94      * Send `_value` tokens to `_to` from your account
95      *
96      * @param _to The address of the recipient
97      * @param _value the amount to send
98      */
99     function transfer(address _to, uint256 _value) public {
100         _transfer(msg.sender, _to, _value);
101     }
102 
103     /**
104      * Transfer tokens from other address
105      *
106      * Send `_value` tokens to `_to` in behalf of `_from`
107      *
108      * @param _from The address of the sender
109      * @param _to The address of the recipient
110      * @param _value the amount to send
111      */
112     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
113         require(_value <= allowance[_from][msg.sender]);     // Check allowance
114         allowance[_from][msg.sender] -= _value;
115         _transfer(_from, _to, _value);
116         return true;
117     }
118 
119     /**
120      * Set allowance for other address
121      *
122      * Allows `_spender` to spend no more than `_value` tokens in your behalf
123      *
124      * @param _spender The address authorized to spend
125      * @param _value the max amount they can spend
126      */
127     function approve(address _spender, uint256 _value) public
128         returns (bool success) {
129         allowance[msg.sender][_spender] = _value;
130         return true;
131     }
132 
133     /**
134      * Set allowance for other address and notify
135      *
136      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
137      *
138      * @param _spender The address authorized to spend
139      * @param _value the max amount they can spend
140      * @param _extraData some extra information to send to the approved contract
141      */
142     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
143         public
144         returns (bool success) {
145         tokenRecipient spender = tokenRecipient(_spender);
146         if (approve(_spender, _value)) {
147             spender.receiveApproval(msg.sender, _value, this, _extraData);
148             return true;
149         }
150     }
151 
152     /**
153      * Destroy tokens
154      *
155      * Remove `_value` tokens from the system irreversibly
156      *
157      * @param _value the amount of money to burn
158      */
159     function burn(uint256 _value) public returns (bool success) {
160         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
161         balanceOf[msg.sender] -= _value;            // Subtract from the sender
162         totalSupply -= _value;                      // Updates totalSupply
163         Burn(msg.sender, _value);
164         return true;
165     }
166 
167     /**
168      * Destroy tokens from other account
169      *
170      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
171      *
172      * @param _from the address of the sender
173      * @param _value the amount of money to burn
174      */
175     function burnFrom(address _from, uint256 _value) public returns (bool success) {
176         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
177         require(_value <= allowance[_from][msg.sender]);    // Check allowance
178         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
179         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
180         totalSupply -= _value;                              // Update totalSupply
181         Burn(_from, _value);
182         return true;
183     }
184 }
185 
186 /******************************************/
187 /*       ADVANCED TOKEN STARTS HERE       */
188 /******************************************/
189 
190 contract Numisma is owned, TokenERC20 {
191 
192     string public comment;
193     uint256 initialSupply = 1000000;
194     string tokenName = "Numisma";
195     string tokenSymbol = "NUM";
196     string version = "1.0";
197 
198     mapping (address => bool) public frozenAccount;
199 
200     /* This generates a public event on the blockchain that will notify clients */
201     event FrozenFunds(address target, bool frozen);
202 
203     /* Initializes contract with initial supply tokens to the creator of the contract */
204     function Numisma() TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
205 
206     /* Internal transfer, only can be called by this contract */
207     function _transfer(address _from, address _to, uint _value) internal {
208         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
209         require (balanceOf[_from] >= _value);               // Check if the sender has enough
210         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
211         require(!frozenAccount[_from]);                     // Check if sender is frozen
212         require(!frozenAccount[_to]);                       // Check if recipient is frozen
213         balanceOf[_from] -= _value;                         // Subtract from the sender
214         balanceOf[_to] += _value;                           // Add the same to the recipient
215         Transfer(_from, _to, _value);
216     }
217 
218     /// @notice Create `mintedAmount` tokens and send it to `target`
219     /// @param target Address to receive the tokens
220     /// @param mintedAmount the amount of tokens it will receive
221     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
222         balanceOf[target] += mintedAmount;
223         totalSupply += mintedAmount;
224         Transfer(0, this, mintedAmount);
225         Transfer(this, target, mintedAmount);
226     }
227 
228     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
229     /// @param target Address to be frozen
230     /// @param freeze either to freeze it or not
231     function freezeAccount(address target, bool freeze) onlyOwner public {
232         frozenAccount[target] = freeze;
233         FrozenFunds(target, freeze);
234     }
235 
236     /// @notice Allow users to read comments
237     /// @param newComment is the comment
238     function setComment(string newComment) onlyOwner public {
239         comment = newComment;
240     }
241 
242 }