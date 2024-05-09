1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient 
4 { 
5 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
6 }
7 
8 contract owned 
9 {
10 	
11 	address public owner;
12 
13 	constructor() public {
14 		owner = msg.sender;
15 	}
16 
17 	modifier onlyOwner {
18 		require(msg.sender == owner);
19 		_;
20 	}
21 
22 	function transferOwnership(address newOwner) public onlyOwner {
23 		owner = newOwner;
24 	}
25 }
26 
27 
28 contract TokenERC20 
29 {	
30     string public name;
31     string public symbol;
32     uint8 public decimals = 2;
33 
34     uint256 public totalSupply;
35 
36     // This creates an array with all balances
37     mapping (address => uint256) public balanceOf;
38     mapping (address => mapping (address => uint256)) public allowance;
39 
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     
43     // This generates a public event on the blockchain that will notify clients
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 
46     // This notifies clients about the amount burnt
47     event Burn(address indexed from, uint256 value);
48 
49 	
50     /**
51      * Constrctor function
52      *
53      * Initializes contract with initial supply tokens to the creator of the contract
54      */
55     constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public	{
56         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
57         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
58         name = tokenName;                                   // Set the name for display purposes
59         symbol = tokenSymbol;                               // Set the symbol for display purposes
60 		decimals = decimalUnits;							// Set the decimal units of token
61     }
62 
63     /**
64      * Internal transfer, only can be called by this contract
65      */
66     function _transfer(address _from, address _to, uint _value) internal {
67         // Prevent transfer to 0x0 address. Use burn() instead
68         require(_to != 0x0);
69          /* Check if sender has balance and for overflows */
70         require(balanceOf[_from] >= _value && balanceOf[_to] + _value >= balanceOf[_to], "Not enough 7s provided");
71 		// Save this for an assertion in the future
72         uint previousBalances = balanceOf[_from] + balanceOf[_to];
73         // Subtract from the sender
74         balanceOf[_from] -= _value;
75         // Add the same to the recipient
76         balanceOf[_to] += _value;
77         emit Transfer(_from, _to, _value);
78         // Asserts are used to use static analysis to find bugs in your code. They should never fail
79         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80     }
81 
82     /**
83      * Transfer tokens
84      *
85      * Send `_value` tokens to `_to` from your account
86      *
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transfer(address _to, uint256 _value) public returns (bool success) {
91         _transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     /**
96      * Transfer tokens from other address
97      *
98      * Send `_value` tokens to `_to` in behalf of `_from`
99      *
100      * @param _from The address of the sender
101      * @param _to The address of the recipient
102      * @param _value the amount to send
103      */
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         require(_value <= allowance[_from][msg.sender]);     // Check allowance
106         allowance[_from][msg.sender] -= _value;
107         _transfer(_from, _to, _value);
108         return true;
109     }
110 
111     /**
112      * Set allowance for other address
113      *
114      * Allows `_spender` to spend no more than `_value` tokens in your behalf
115      *
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
128      *
129      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the 
130 	 * contract about it
131      *
132      * @param _spender The address authorized to spend
133      * @param _value the max amount they can spend
134      * @param _extraData some extra information to send to the approved contract
135      */
136     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public 
137 		returns (bool success) {
138         tokenRecipient spender = tokenRecipient(_spender);
139         if (approve(_spender, _value)) {
140             spender.receiveApproval(msg.sender, _value, this, _extraData);
141             return true;
142         }
143     }
144 
145     /**
146      * Destroy tokens
147      *
148      * Remove `_value` tokens from the system irreversibly
149      *
150      * @param _value the amount of money to burn
151      */
152     function burn(uint256 _value) public returns (bool success) {
153         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
154         balanceOf[msg.sender] -= _value;            // Subtract from the sender
155         totalSupply -= _value;                      // Updates totalSupply
156         emit Burn(msg.sender, _value);
157         return true;
158     }
159 
160     /**
161      * Destroy tokens from other account
162      *
163      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
164      *
165      * @param _from the address of the sender
166      * @param _value the amount of money to burn
167      */
168     function burnFrom(address _from, uint256 _value) public returns (bool success) {
169         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
170         require(_value <= allowance[_from][msg.sender]);    // Check allowance
171         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
172         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
173         totalSupply -= _value;                              // Update totalSupply
174         emit Burn(_from, _value);
175         return true;
176     }
177 }
178 
179 
180 contract SEVENS is owned, TokenERC20{
181 
182 	mapping (address => bool) public frozenAccount;
183    
184 	event FrozenFunds(address target, bool frozen);
185 	
186 	
187 	constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits)
188 		TokenERC20(initialSupply, tokenName, tokenSymbol, decimalUnits) public {}
189 	
190 	
191     /* Internal transfer, only can be called by this contract */
192     function _transfer(address _from, address _to, uint _value) internal {
193         require (_to != 0x0);                               	// Prevent transfer to 0x0 address. Use burn() instead
194         require(balanceOf[_from] >= _value && balanceOf[_to] + _value >= balanceOf[_to], "Not enough 7s provided");
195         require(!frozenAccount[_from], "7s account is frozen"); // Check if sender is frozen
196         require(!frozenAccount[_to], "7s account is frozen");  	// Check if recipient is frozen
197         balanceOf[_from] -= _value;                         	// Subtract from the sender
198         balanceOf[_to] += _value;                           	// Add the same to the recipient
199         emit Transfer(_from, _to, _value);
200     }
201 	
202 	
203 	/*create new tokens in case of account freeze or token burn e.g. on hacks*/
204 	function mintToken(address target, uint256 mintedAmount) public onlyOwner {
205         balanceOf[target] += mintedAmount;
206         totalSupply += mintedAmount;
207         emit Transfer(0, owner, mintedAmount);
208         emit Transfer(owner, target, mintedAmount);
209     }
210 
211 		
212 	function freezeAccount(address target, bool freeze) public onlyOwner {
213         frozenAccount[target] = freeze;
214         emit FrozenFunds(target, freeze);
215     }
216     
217 }