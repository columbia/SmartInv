1 pragma solidity ^0.4.21;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
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
19 contract SafeMath {
20   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
27     assert(b > 0);
28     uint256 c = a / b;
29     assert(a == b * c + a % b);
30     return c;
31   }
32 
33   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
39     uint256 c = a + b;
40     assert(c>=a && c>=b);
41     return c;
42   }
43 
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       throw;
47     }
48   }
49 }
50 
51 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
52 
53 contract TokenERC20 {
54     // Public variables of the token
55     string public name;
56     string public symbol;
57     uint8 public decimals = 18;
58     uint256 public totalSupply;
59 
60     // This creates an array with all balances
61     mapping (address => uint256) public balanceOf;
62     mapping (address => mapping (address => uint256)) public allowance;
63 
64     // This generates a public event on the blockchain that will notify clients
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     // This notifies clients about the amount burnt
68     event Burn(address indexed from, uint256 value);
69 
70     /**
71      * Constrctor function
72      *
73      * Initializes contract with initial supply tokens to the creator of the contract
74      */
75     function TokenERC20(
76         uint256 initialSupply,
77         string tokenName,
78         string tokenSymbol
79     ) public {
80         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
81         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
82         name = tokenName;                                   // Set the name for display purposes
83         symbol = tokenSymbol;                               // Set the symbol for display purposes
84     }
85 
86     /**
87      * Internal transfer, only can be called by this contract
88      */
89     function _transfer(address _from, address _to, uint _value) internal {
90         // Prevent transfer to 0x0 address. Use burn() instead
91         require(_to != 0x0);
92         // Check if the sender has enough
93         require(balanceOf[_from] >= _value);
94         // Check for overflows
95         require(balanceOf[_to] + _value > balanceOf[_to]);
96         // Save this for an assertion in the future
97         uint previousBalances = balanceOf[_from] + balanceOf[_to];
98         // Subtract from the sender
99         balanceOf[_from] -= _value;
100         // Add the same to the recipient
101         balanceOf[_to] += _value;
102         Transfer(_from, _to, _value);
103         // Asserts are used to use static analysis to find bugs in your code. They should never fail
104         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
105     }
106 
107     /**
108      * Transfer tokens
109      *
110      * Send `_value` tokens to `_to` from your account
111      *
112      * @param _to The address of the recipient
113      * @param _value the amount to send
114      */
115     function transfer(address _to, uint256 _value) public {
116         _transfer(msg.sender, _to, _value);
117     }
118 
119     /**
120      * Transfer tokens from other address
121      *
122      * Send `_value` tokens to `_to` in behalf of `_from`
123      *
124      * @param _from The address of the sender
125      * @param _to The address of the recipient
126      * @param _value the amount to send
127      */
128     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
129         require(_value <= allowance[_from][msg.sender]);     // Check allowance
130         allowance[_from][msg.sender] -= _value;
131         _transfer(_from, _to, _value);
132         return true;
133     }
134 
135     /**
136      * Set allowance for other address
137      *
138      * Allows `_spender` to spend no more than `_value` tokens in your behalf
139      *
140      * @param _spender The address authorized to spend
141      * @param _value the max amount they can spend
142      */
143     function approve(address _spender, uint256 _value) public
144         returns (bool success) {
145         allowance[msg.sender][_spender] = _value;
146         return true;
147     }
148 
149     /**
150      * Set allowance for other address and notify
151      *
152      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
153      *
154      * @param _spender The address authorized to spend
155      * @param _value the max amount they can spend
156      * @param _extraData some extra information to send to the approved contract
157      */
158     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
159         public
160         returns (bool success) {
161         tokenRecipient spender = tokenRecipient(_spender);
162         if (approve(_spender, _value)) {
163             spender.receiveApproval(msg.sender, _value, this, _extraData);
164             return true;
165         }
166     }
167 
168     /**
169      * Destroy tokens
170      *
171      * Remove `_value` tokens from the system irreversibly
172      *
173      * @param _value the amount of money to burn
174      */
175     function burn(uint256 _value) public returns (bool success) {
176         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
177         balanceOf[msg.sender] -= _value;            // Subtract from the sender
178         totalSupply -= _value;                      // Updates totalSupply
179         Burn(msg.sender, _value);
180         return true;
181     }
182 
183     /**
184      * Destroy tokens from other account
185      *
186      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
187      *
188      * @param _from the address of the sender
189      * @param _value the amount of money to burn
190      */
191     function burnFrom(address _from, uint256 _value) public returns (bool success) {
192         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
193         require(_value <= allowance[_from][msg.sender]);    // Check allowance
194         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
195         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
196         totalSupply -= _value;                              // Update totalSupply
197         Burn(_from, _value);
198         return true;
199     }
200 }
201 
202 contract LKYToken is owned, TokenERC20 {
203 
204     mapping (address => bool) public frozenAccount;
205 
206     /* This generates a public event on the blockchain that will notify clients */
207     event FrozenFunds(address target, bool frozen);
208 
209     /* Initializes contract with initial supply tokens to the creator of the contract */
210     function LKYToken(
211         uint256 initialSupply,
212         string tokenName,
213         string tokenSymbol
214     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
215 
216     /* Internal transfer, only can be called by this contract */
217     function _transfer(address _from, address _to, uint _value) internal {
218         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
219         require (balanceOf[_from] >= _value);               // Check if the sender has enough
220         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
221         require(!frozenAccount[_from]);                     // Check if sender is frozen
222         require(!frozenAccount[_to]);                       // Check if recipient is frozen
223         balanceOf[_from] -= _value;                         // Subtract from the sender
224         balanceOf[_to] += _value;                           // Add the same to the recipient
225         Transfer(_from, _to, _value);
226     }
227 
228     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
229     /// @param target Address to be frozen
230     /// @param freeze either to freeze it or not
231     function freezeAccount(address target, bool freeze) onlyOwner public {
232         frozenAccount[target] = freeze;
233         FrozenFunds(target, freeze);
234     }
235 }