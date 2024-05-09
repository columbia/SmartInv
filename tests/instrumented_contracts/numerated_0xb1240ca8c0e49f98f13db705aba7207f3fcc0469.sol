1 pragma solidity ^0.4.16;
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name = "MicroBusinessCoin";
25     string public symbol = "MBC";
26     uint8 public decimals = 18;
27     uint256 public totalSupply = 90000000000 * 10 ** uint256(decimals);
28 
29     // This creates an array with all balances
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     // This generates a public event on the blockchain that will notify clients
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     // This notifies clients about the amount burnt
37     event Burn(address indexed from, uint256 value);
38 
39     /**
40      * Constrctor function
41      *
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     function TokenERC20(
45     ) public {
46         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
47     }
48 
49     /**
50      * Internal transfer, only can be called by this contract
51      */
52     function _transfer(address _from, address _to, uint _value) internal {
53         // Prevent transfer to 0x0 address. Use burn() instead
54         require(_to != 0x0);
55         // Check if the sender has enough
56         require(balanceOf[_from] >= _value);
57         // Check for overflows
58         require(balanceOf[_to] + _value > balanceOf[_to]);
59         // Save this for an assertion in the future
60         uint previousBalances = balanceOf[_from] + balanceOf[_to];
61         // Subtract from the sender
62         balanceOf[_from] -= _value;
63         // Add the same to the recipient
64         balanceOf[_to] += _value;
65         Transfer(_from, _to, _value);
66         // Asserts are used to use static analysis to find bugs in your code. They should never fail
67         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
68     }
69 
70     /**
71      * Transfer tokens
72      *
73      * Send `_value` tokens to `_to` from your account
74      *
75      * @param _to The address of the recipient
76      * @param _value the amount to send
77      */
78     function transfer(address _to, uint256 _value) public {
79         _transfer(msg.sender, _to, _value);
80     }
81 
82     /**
83      * Transfer tokens from other address
84      *
85      * Send `_value` tokens to `_to` in behalf of `_from`
86      *
87      * @param _from The address of the sender
88      * @param _to The address of the recipient
89      * @param _value the amount to send
90      */
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         require(_value <= allowance[_from][msg.sender]);     // Check allowance
93         allowance[_from][msg.sender] -= _value;
94         _transfer(_from, _to, _value);
95         return true;
96     }
97 
98     /**
99      * Set allowance for other address
100      *
101      * Allows `_spender` to spend no more than `_value` tokens in your behalf
102      *
103      * @param _spender The address authorized to spend
104      * @param _value the max amount they can spend
105      */
106     function approve(address _spender, uint256 _value) public
107         returns (bool success) {
108         allowance[msg.sender][_spender] = _value;
109         return true;
110     }
111 
112     /**
113      * Set allowance for other address and notify
114      *
115      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
116      *
117      * @param _spender The address authorized to spend
118      * @param _value the max amount they can spend
119      * @param _extraData some extra information to send to the approved contract
120      */
121     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
122         public
123         returns (bool success) {
124         tokenRecipient spender = tokenRecipient(_spender);
125         if (approve(_spender, _value)) {
126             spender.receiveApproval(msg.sender, _value, this, _extraData);
127             return true;
128         }
129     }
130 
131     /**
132      * Destroy tokens
133      *
134      * Remove `_value` tokens from the system irreversibly
135      *
136      * @param _value the amount of money to burn
137      */
138     function burn(uint256 _value) public returns (bool success) {
139         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
140         balanceOf[msg.sender] -= _value;            // Subtract from the sender
141         totalSupply -= _value;                      // Updates totalSupply
142         Burn(msg.sender, _value);
143         return true;
144     }
145 
146     /**
147      * Destroy tokens from other account
148      *
149      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
150      *
151      * @param _from the address of the sender
152      * @param _value the amount of money to burn
153      */
154     function burnFrom(address _from, uint256 _value) public returns (bool success) {
155         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
156         require(_value <= allowance[_from][msg.sender]);    // Check allowance
157         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
158         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
159         totalSupply -= _value;                              // Update totalSupply
160         Burn(_from, _value);
161         return true;
162     }
163 }
164 
165 /******************************************/
166 /*       ADVANCED TOKEN STARTS HERE       */
167 /******************************************/
168 
169 contract AdvancedToken is owned, TokenERC20 {
170     mapping (address => bool) public frozenAccount;
171 
172     /* This generates a public event on the blockchain that will notify clients */
173     event FrozenFunds(address target, bool frozen);
174 
175     /* Initializes contract with initial supply tokens to the creator of the contract */
176     function AdvancedToken(
177     ) TokenERC20() public {}
178 
179     /* Internal transfer, only can be called by this contract */
180     function _transfer(address _from, address _to, uint _value) internal {
181         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
182         require (balanceOf[_from] >= _value);               // Check if the sender has enough
183         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
184         require(!frozenAccount[_from]);                     // Check if sender is frozen
185         require(!frozenAccount[_to]);                       // Check if recipient is frozen
186         balanceOf[_from] -= _value;                         // Subtract from the sender
187         balanceOf[_to] += _value;                           // Add the same to the recipient
188         Transfer(_from, _to, _value);
189     }
190 
191     // function mintToken(address target, uint256 mintedAmount) onlyOwner public {
192     //     balanceOf[target] += mintedAmount;
193     //     totalSupply += mintedAmount;
194     //     Transfer(0, this, mintedAmount);
195     //     Transfer(this, target, mintedAmount);
196     // }
197 
198     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
199     /// @param target Address to be frozen
200     /// @param freeze either to freeze it or not
201     function freezeAccount(address target, bool freeze) onlyOwner public {
202         frozenAccount[target] = freeze;
203         FrozenFunds(target, freeze);
204     }
205     
206     /// @notice freeze multiple addresses
207     /// @param addresses to freeze
208     /// @param freeze or not
209     function freezeMultiAccounts(address[] addresses, bool freeze) onlyOwner public {
210         for (uint i = 0; i < addresses.length; i++) {
211             frozenAccount[addresses[i]] = freeze;
212             FrozenFunds(addresses[i], freeze);
213         }
214     }
215     
216     /// @notice distribute tokens to multiple addresses
217     /// @param addresses to distribute to
218     /// @param _value to distribute
219     function distributeToken(address[] addresses, uint256 _value) onlyOwner public {
220         require (balanceOf[owner] >= _value*addresses.length);                      // Check if the sender has enough
221         for (uint i = 0; i < addresses.length; i++) {
222             require (addresses[i] != 0x0);                                          // Prevent transfer to 0x0 address. Use burn() instead
223             require (balanceOf[addresses[i]] + _value > balanceOf[addresses[i]]);   // Check for overflows
224             require(!frozenAccount[owner]);                                         // Check if sender is frozen
225             require(!frozenAccount[addresses[i]]);                                  // Check if recipient is frozen
226             balanceOf[owner] -= _value;
227             balanceOf[addresses[i]] += _value;
228             Transfer(owner, addresses[i], _value);
229         }
230     }
231 }