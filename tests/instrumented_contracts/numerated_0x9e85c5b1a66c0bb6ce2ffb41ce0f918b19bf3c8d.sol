1 pragma solidity ^0.4.24;
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
19 
20 /**
21  * Math operations with safety checks
22  */
23 contract SafeMath {
24   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
25     uint256 c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
31     assert(b > 0);
32     uint256 c = a / b;
33     assert(a == b * c + a % b);
34     return c;
35   }
36 
37   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
43     uint256 c = a + b;
44     assert(c>=a && c>=b);
45     return c;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
56 
57 contract TokenERC20 is SafeMath {
58     // Public variables of the token
59     string public name;
60     string public symbol;
61     uint8 public decimals = 18;
62     // 18 decimals is the strongly suggested default, avoid changing it
63     uint256 public totalSupply;
64 
65     // This creates an array with all balances
66     mapping (address => uint256) public balanceOf;
67     mapping (address => mapping (address => uint256)) public allowance;
68 
69     // This generates a public event on the blockchain that will notify clients
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     
72     // This generates a public event on the blockchain that will notify clients
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74 
75     // This notifies clients about the amount burnt
76     event Burn(address indexed from, uint256 value);
77 
78     /**
79      * Constrctor function
80      *
81      * Initializes contract with initial supply tokens to the creator of the contract
82      */
83     function TokenERC20(
84         uint256 initialSupply,
85         string tokenName,
86         string tokenSymbol
87     ) public {
88         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
89         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
90         name = tokenName;                                   // Set the name for display purposes
91         symbol = tokenSymbol;                               // Set the symbol for display purposes
92     }
93 
94     /**
95      * Internal transfer, only can be called by this contract
96      */
97     function _transfer(address _from, address _to, uint _value) internal {
98         // Prevent transfer to 0x0 address. Use burn() instead
99         require(_to != 0x0);
100         // Check if the sender has enough
101         require(balanceOf[_from] >= _value);
102         // Check for overflows
103         require(SafeMath.safeAdd(balanceOf[_to], _value) > balanceOf[_to]);
104         // Save this for an assertion in the future
105         uint previousBalances = SafeMath.safeAdd(balanceOf[_from], balanceOf[_to]); 
106         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                     // Subtract from the sender
107         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
108         emit Transfer(_from, _to, _value);
109         // Asserts are used to use static analysis to find bugs in your code. They should never fail
110         assert(SafeMath.safeAdd(balanceOf[_from], balanceOf[_to]) == previousBalances);
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
121     function transfer(address _to, uint256 _value) public returns (bool success) {
122         _transfer(msg.sender, _to, _value);
123         return true;
124     }
125 
126     /**
127      * Transfer tokens from other address
128      *
129      * Send `_value` tokens to `_to` in behalf of `_from`
130      *
131      * @param _from The address of the sender
132      * @param _to The address of the recipient
133      * @param _value the amount to send
134      */
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
136         require(_value <= allowance[_from][msg.sender]);     // Check allowance
137         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
138         _transfer(_from, _to, _value);
139         return true;
140     }
141 
142     /**
143      * Set allowance for other address
144      *
145      * Allows `_spender` to spend no more than `_value` tokens in your behalf
146      *
147      * @param _spender The address authorized to spend
148      * @param _value the max amount they can spend
149      */
150     function approve(address _spender, uint256 _value) public
151         returns (bool success) {
152         allowance[msg.sender][_spender] = SafeMath.safeSub(allowance[msg.sender][_spender], _value);
153         emit Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     /**
158      * Set allowance for other address and notify
159      *
160      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
161      *
162      * @param _spender The address authorized to spend
163      * @param _value the max amount they can spend
164      * @param _extraData some extra information to send to the approved contract
165      */
166     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
167         public
168         returns (bool success) {
169         tokenRecipient spender = tokenRecipient(_spender);
170         if (approve(_spender, _value)) {
171             spender.receiveApproval(msg.sender, _value, this, _extraData);
172             return true;
173         }
174     }
175 
176     /**
177      * Destroy tokens
178      *
179      * Remove `_value` tokens from the system irreversibly
180      *
181      * @param _value the amount of money to burn
182      */
183     function burn(uint256 _value) public returns (bool success) {
184         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
185         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);    // Subtract from the sender
186         totalSupply = SafeMath.safeSub(totalSupply, _value);     // Updates totalSupply
187         emit Burn(msg.sender, _value);
188         return true;
189     }
190 
191     /**
192      * Destroy tokens from other account
193      *
194      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
195      *
196      * @param _from the address of the sender
197      * @param _value the amount of money to burn
198      */
199     function burnFrom(address _from, uint256 _value) public returns (bool success) {
200         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
201         require(_value <= allowance[_from][msg.sender]);    // Check allowance
202         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
203         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
204         totalSupply = SafeMath.safeSub(totalSupply, _value);     // Updates totalSupply
205         emit Burn(_from, _value);
206         return true;
207     }
208 }
209 
210 /******************************************/
211 /*       Gran Turismo Club TOKEN STARTS HERE       */
212 /******************************************/
213 
214 contract ClubToken is owned, TokenERC20 {
215     
216     /// The full name of the CLUB token.
217     string public constant tokenName = "GranTurismoClub";
218     /// Symbol of the CLUB token.
219     string public constant tokenSymbol = "CLUB";
220     
221     uint256 public initialSupply = 100000000;
222 
223     mapping (address => bool) public frozenAccount;
224 
225     /* This generates a public event on the blockchain that will notify clients */
226     event FrozenFunds(address target, bool frozen);
227 
228     /* Initializes contract with initial supply tokens to the creator of the contract */
229     function ClubToken() TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
230 
231     /* Internal transfer, only can be called by this contract */
232     function _transfer(address _from, address _to, uint _value) internal {
233         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
234         require (balanceOf[_from] >= _value);               // Check if the sender has enough
235         require(SafeMath.safeAdd(balanceOf[_to], _value) > balanceOf[_to]);
236         require(!frozenAccount[_from]);                     // Check if sender is frozen
237         require(!frozenAccount[_to]);                       // Check if recipient is frozen
238         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
239         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
240         emit Transfer(_from, _to, _value);
241     }
242 
243     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
244     /// @param target Address to be frozen
245     /// @param freeze either to freeze it or not
246     function freezeAccount(address target, bool freeze) onlyOwner public {
247         frozenAccount[target] = freeze;
248         emit FrozenFunds(target, freeze);
249     }
250 
251 }