1 /*
2 
3   Copyright 2019 Horizon0x.net
4 
5 */
6 
7 pragma solidity ^0.4.21;
8 
9 contract owned {
10     address public owner;
11 
12     function owned() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address newOwner) onlyOwner public {
22         owner = newOwner;
23     }
24 }
25 contract SafeMath {
26   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
27     uint256 c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
33     assert(b > 0);
34     uint256 c = a / b;
35     assert(a == b * c + a % b);
36     return c;
37   }
38 
39   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
45     uint256 c = a + b;
46     assert(c>=a && c>=b);
47     return c;
48   }
49 
50   function assert(bool assertion) internal {
51     if (!assertion) {
52       throw;
53     }
54   }
55 }
56 
57 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
58 
59 contract TokenERC20 {
60     // Public variables of the token
61     string public name;
62     string public symbol;
63     uint8 public decimals = 18;
64     uint256 public totalSupply;
65 
66     // This creates an array with all balances
67     mapping (address => uint256) public balanceOf;
68     mapping (address => mapping (address => uint256)) public allowance;
69 
70     // This generates a public event on the blockchain that will notify clients
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     // This notifies clients about the amount burnt
74     event Burn(address indexed from, uint256 value);
75 
76     /**
77      * Constrctor function
78      *
79      * Initializes contract with initial supply tokens to the creator of the contract
80      */
81     function TokenERC20(
82         uint256 initialSupply,
83         string tokenName,
84         string tokenSymbol
85     ) public {
86         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
87         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
88         name = tokenName;                                   // Set the name for display purposes
89         symbol = tokenSymbol;                               // Set the symbol for display purposes
90     }
91 
92     /**
93      * Internal transfer, only can be called by this contract
94      */
95     function _transfer(address _from, address _to, uint _value) internal {
96         // Prevent transfer to 0x0 address. Use burn() instead
97         require(_to != 0x0);
98         // Check if the sender has enough
99         require(balanceOf[_from] >= _value);
100         // Check for overflows
101         require(balanceOf[_to] + _value > balanceOf[_to]);
102         // Save this for an assertion in the future
103         uint previousBalances = balanceOf[_from] + balanceOf[_to];
104         // Subtract from the sender
105         balanceOf[_from] -= _value;
106         // Add the same to the recipient
107         balanceOf[_to] += _value;
108         Transfer(_from, _to, _value);
109         // Asserts are used to use static analysis to find bugs in your code. They should never fail
110         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
111     }
112 
113     /**
114      * Transfer tokens
115      *
116      * Send `_value` tokens to `_to` from your account
117      *
118      * @param _to The address of the recipient
119      * @param _value the amount to send
120      */
121     function transfer(address _to, uint256 _value) public {
122         _transfer(msg.sender, _to, _value);
123     }
124 
125     /**
126      * Transfer tokens from other address
127      *
128      * Send `_value` tokens to `_to` in behalf of `_from`
129      *
130      * @param _from The address of the sender
131      * @param _to The address of the recipient
132      * @param _value the amount to send
133      */
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
135         require(_value <= allowance[_from][msg.sender]);     // Check allowance
136         allowance[_from][msg.sender] -= _value;
137         _transfer(_from, _to, _value);
138         return true;
139     }
140 
141     /**
142      * Set allowance for other address
143      *
144      * Allows `_spender` to spend no more than `_value` tokens in your behalf
145      *
146      * @param _spender The address authorized to spend
147      * @param _value the max amount they can spend
148      */
149     function approve(address _spender, uint256 _value) public
150         returns (bool success) {
151         allowance[msg.sender][_spender] = _value;
152         return true;
153     }
154 
155     /**
156      * Set allowance for other address and notify
157      *
158      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
159      *
160      * @param _spender The address authorized to spend
161      * @param _value the max amount they can spend
162      * @param _extraData some extra information to send to the approved contract
163      */
164     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
165         public
166         returns (bool success) {
167         tokenRecipient spender = tokenRecipient(_spender);
168         if (approve(_spender, _value)) {
169             spender.receiveApproval(msg.sender, _value, this, _extraData);
170             return true;
171         }
172     }
173 
174     /**
175      * Destroy tokens
176      *
177      * Remove `_value` tokens from the system irreversibly
178      *
179      * @param _value the amount of money to burn
180      */
181     function burn(uint256 _value) public returns (bool success) {
182         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
183         balanceOf[msg.sender] -= _value;            // Subtract from the sender
184         totalSupply -= _value;                      // Updates totalSupply
185         Burn(msg.sender, _value);
186         return true;
187     }
188 
189     /**
190      * Destroy tokens from other account
191      *
192      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
193      *
194      * @param _from the address of the sender
195      * @param _value the amount of money to burn
196      */
197     function burnFrom(address _from, uint256 _value) public returns (bool success) {
198         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
199         require(_value <= allowance[_from][msg.sender]);    // Check allowance
200         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
201         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
202         totalSupply -= _value;                              // Update totalSupply
203         Burn(_from, _value);
204         return true;
205     }
206 }
207 
208 contract Horizon0x is owned, TokenERC20 {
209 
210     mapping (address => bool) public frozenAccount;
211 
212     /* This generates a public event on the blockchain that will notify clients */
213     event FrozenFunds(address target, bool frozen);
214 
215     /* Initializes contract with initial supply tokens to the creator of the contract */
216     function Horizon0x(
217         uint256 initialSupply,
218         string tokenName,
219         string tokenSymbol
220     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
221 
222     /* Internal transfer, only can be called by this contract */
223     function _transfer(address _from, address _to, uint _value) internal {
224         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
225         require (balanceOf[_from] >= _value);               // Check if the sender has enough
226         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
227         require(!frozenAccount[_from]);                     // Check if sender is frozen
228         require(!frozenAccount[_to]);                       // Check if recipient is frozen
229         balanceOf[_from] -= _value;                         // Subtract from the sender
230         balanceOf[_to] += _value;                           // Add the same to the recipient
231         Transfer(_from, _to, _value);
232     }
233 
234     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
235     /// @param target Address to be frozen
236     /// @param freeze either to freeze it or not
237     function freezeAccount(address target, bool freeze) onlyOwner public {
238         frozenAccount[target] = freeze;
239         FrozenFunds(target, freeze);
240     }
241 }