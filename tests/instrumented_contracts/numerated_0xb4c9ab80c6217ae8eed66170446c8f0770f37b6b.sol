1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 	address public referral;
6 	address public development;
7 
8     constructor() public {
9         owner = msg.sender;
10 		referral = 0x5593481690957F314cf9AC95eC3517FD38E5F669;
11 		development = 0x9327E4956E5956e657f2bD6982960F7c0ecce640;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 	function transferReferral(address newRef) onlyOwner public {
23         referral = newRef;
24     }
25 	function transferDevelopment(address newDev) onlyOwner public {
26         development = newDev;
27     }
28 }
29 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
30 
31 contract TokenERC20 {
32     // Public variables of the token
33     string public name;
34     string public symbol;
35     uint public decimals = 18;
36     // 18 decimals is the strongly suggested default, avoid changing it
37     uint256 public totalSupply;
38    
39     // This creates an array with all balances
40     mapping (address => uint256) public balanceOf;
41     mapping (address => mapping (address => uint256)) public allowance;
42 
43     // This generates a public event on the blockchain that will notify clients
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     
46     // This generates a public event on the blockchain that will notify clients
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 
49     // This notifies clients about the amount burnt
50     event Burn(address indexed from, uint256 value);
51 
52     /**
53      * Constrctor function
54      * Initializes contract with initial supply tokens to the creator of the contract
55      */
56     constructor(
57         uint256 initialSupply,
58         string tokenName,
59         string tokenSymbol
60     ) public {
61         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
62         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
63         name = tokenName;                                   // Set the name for display purposes
64         symbol = tokenSymbol;                               // Set the symbol for display purposes
65     }
66 
67     /**
68      * Internal transfer, only can be called by this contract
69      */
70     function _transfer(address _from, address _to, uint _value) internal {
71         // Prevent transfer to 0x0 address. Use burn() instead
72         require(_to != 0x0);
73         // Check if the sender has enough
74         require(balanceOf[_from] >= _value);
75         // Check for overflows
76         require(balanceOf[_to] + _value > balanceOf[_to]);
77         // Save this for an assertion in the future
78         uint previousBalances = balanceOf[_from] + balanceOf[_to];
79         // Subtract from the sender
80         balanceOf[_from] -= _value;
81         // Add the same to the recipient
82         balanceOf[_to] += _value;
83         emit Transfer(_from, _to, _value);
84         // Asserts are used to use static analysis to find bugs in your code. They should never fail
85         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
86     }
87    
88     /**
89      * Transfer tokens
90      * Send `_value` tokens to `_to` from your account
91      * @param _to The address of the recipient
92      * @param _value the amount to send
93      */
94     function transfer(address _to, uint256 _value) public returns (bool success) {
95         _transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99     /**
100      * Transfer tokens from other address
101      * Send `_value` tokens to `_to` in behalf of `_from`
102      * @param _from The address of the sender
103      * @param _to The address of the recipient
104      * @param _value the amount to send
105      */
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
107         require(_value <= allowance[_from][msg.sender]);     // Check allowance
108         allowance[_from][msg.sender] -= _value;
109         _transfer(_from, _to, _value);
110         return true;
111     }
112 
113     /**
114      * Set allowance for other address
115      * Allows `_spender` to spend no more than `_value` tokens in your behalf
116      * @param _spender The address authorized to spend
117      * @param _value the max amount they can spend
118      */
119     function approve(address _spender, uint256 _value) public
120         returns (bool success) {
121         allowance[msg.sender][_spender] = _value;
122         emit Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126     /**
127      * Set allowance for other address and notify
128      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
129      * @param _spender The address authorized to spend
130      * @param _value the max amount they can spend
131      * @param _extraData some extra information to send to the approved contract
132      */
133     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
134         public
135         returns (bool success) {
136         tokenRecipient spender = tokenRecipient(_spender);
137         if (approve(_spender, _value)) {
138             spender.receiveApproval(msg.sender, _value, this, _extraData);
139             return true;
140         }
141     }
142 
143     /**
144      * Destroy tokens
145      * Remove `_value` tokens from the system irreversibly
146      * @param _value the amount of money to burn
147      */
148     function burn(uint256 _value) public returns (bool success) {
149         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
150         balanceOf[msg.sender] -= _value;            // Subtract from the sender
151         totalSupply -= _value;                      // Updates totalSupply
152         emit Burn(msg.sender, _value);
153         return true;
154     }
155 
156     /**
157      * Destroy tokens from other account
158      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
159      * @param _from the address of the sender
160      * @param _value the amount of money to burn
161      */
162     function burnFrom(address _from, uint256 _value) public returns (bool success) {
163         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
164         require(_value <= allowance[_from][msg.sender]);    // Check allowance
165         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
166         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
167         totalSupply -= _value;                              // Update totalSupply
168         emit Burn(_from, _value);
169         return true;
170     }
171     
172 }
173 
174 /******************************************/
175 /*       ADVANCED TOKEN STARTS HERE       */
176 /******************************************/
177 
178 contract MyAdvancedToken is owned, TokenERC20 {
179 
180 	// TAXXXXXX
181     uint tax = 6;
182     uint256 public rivalutazione;
183 	
184     mapping (address => bool) public frozenAccount;
185 
186     /* This generates a public event on the blockchain that will notify clients */
187     event FrozenFunds(address target, bool frozen);
188 
189     /* Initializes contract with initial supply tokens to the creator of the contract */
190     constructor(
191         uint256 initialSupply,
192         string tokenName,
193         string tokenSymbol
194     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {} 
195 
196     /* Internal transfer, only can be called by this contract */
197     function _transfer(address _from, address _to, uint _value) internal {
198         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
199         require (balanceOf[_from] >= _value);               // Check if the sender has enough
200         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
201         require(!frozenAccount[_from]);                     // Check if sender is frozen
202         require(!frozenAccount[_to]);                       // Check if recipient is frozen
203         balanceOf[_from] -= _value;  // Subtract from the sender
204         balanceOf[_to] +=  ( _value - ((_value/(10**2))*tax) );  // Add the same to the recipient
205         emit Transfer(_from, _to, _value);
206         balanceOf[development] += ((_value/(10**2))*2);    //  Manda l' 2% sul portafoglio per lo sviluppo
207         rivalutazione += ((_value/(10**2))*3);       //  Conteggia il 3% per la rivalutazione
208 		totalSupply -= ((_value/(10**2))*3);         // brucia il 3% per la rivalutazione
209 		balanceOf[referral] += ((_value/(10**2))*1);  //  Manda l' 1% al fondo referral
210     }
211 
212     
213     /// @notice Create `mintedAmount` tokens and send it to `target`
214     /// @param target Address to receive the tokens
215     /// @param mintedAmount the amount of tokens it will receive
216     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
217         balanceOf[target] += mintedAmount;
218         totalSupply += mintedAmount;
219         emit Transfer(0, this, mintedAmount);
220         emit Transfer(this, target, mintedAmount);
221     }
222 
223     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
224     /// @param target Address to be frozen
225     /// @param freeze either to freeze it or not
226     function freezeAccount(address target, bool freeze) onlyOwner public {
227         frozenAccount[target] = freeze;
228         emit FrozenFunds(target, freeze);
229     }
230 }