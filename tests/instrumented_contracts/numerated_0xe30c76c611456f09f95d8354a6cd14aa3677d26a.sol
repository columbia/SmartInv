1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract owned {
6         address public owner;
7 
8         function owned() public {
9             owner = msg.sender;
10         }
11 
12         modifier onlyOwner {
13             require(msg.sender == owner);
14             _;
15         }
16 
17         function transferOwnership(address newOwner) onlyOwner public {
18             owner = newOwner;
19         }
20     }
21 
22 contract minted is owned {
23         address public minter;
24 
25         function minted() public {
26             minter = msg.sender;
27         }
28 
29         modifier onlyMinter {
30             require(msg.sender == minter);
31             _;
32         }
33 
34         function transferMintship(address newMinter) onlyOwner public {
35             minter = newMinter;
36         }
37     }
38 
39 
40 contract mortal is owned {
41 	function kill() onlyOwner() public {
42 		selfdestruct(owner);
43 	}
44 }
45 
46 contract TokenERC20 is owned, mortal, minted{
47     // Public variables of the token
48     string public name;
49     string public symbol;
50     uint8 public decimals = 0;
51     // 18 decimals is the strongly suggested default, avoid changing it
52     uint256 public totalSupply;
53 
54     // This creates an array with all balances
55     mapping (address => uint256) public balanceOf;
56     mapping (address => mapping (address => uint256)) public allowance;
57 
58     // This generates a public event on the blockchain that will notify clients
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 
61     // This notifies clients about the amount burnt
62     event Burn(address indexed from, uint256 value);
63 
64     /**
65      * Constructor function
66      *
67      * Initializes contract with initial supply tokens to the creator of the contract
68      */
69     function TokenERC20(
70         uint256 initialSupply,
71         string tokenName,
72         string tokenSymbol,
73 	  address centralMinter
74     ) public {
75 	  if(centralMinter !=0) owner = centralMinter;
76         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
77         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
78         name = tokenName;                                   // Set the name for display purposes
79         symbol = tokenSymbol;                               // Set the symbol for display purposes
80     }
81 
82     function mintToken(address target, uint256 mintedAmount) onlyMinter public {
83         balanceOf[target] += mintedAmount;
84         totalSupply += mintedAmount;
85         emit Transfer(0, minter, mintedAmount);
86         emit Transfer(minter, target, mintedAmount);
87     }
88 
89     /**
90      * Internal transfer, only can be called by this contract
91      */
92     function _transfer(address _from, address _to, uint _value) internal {
93         // Prevent transfer to 0x0 address. Use burn() instead
94         require(_to != 0x0);
95         // Check if the sender has enough
96         require(balanceOf[_from] >= _value);
97         // Check for overflows
98         require(balanceOf[_to] + _value > balanceOf[_to]);
99         // Save this for an assertion in the future
100         uint previousBalances = balanceOf[_from] + balanceOf[_to];
101         // Subtract from the sender
102         balanceOf[_from] -= _value;
103         // Add the same to the recipient
104         balanceOf[_to] += _value;
105         emit Transfer(_from, _to, _value);
106         // Asserts are used to use static analysis to find bugs in your code. They should never fail
107         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
108     }
109 
110     /**
111      * Transfer tokens
112      *
113      * Send `_value` tokens to `_to` from your account
114      *
115      * @param _to The address of the recipient
116      * @param _value the amount to send
117      */
118     function transfer(address _to, uint256 _value) public {
119         _transfer(msg.sender, _to, _value);
120     }
121 
122     /**
123      * Transfer tokens from other address
124      *
125      * Send `_value` tokens to `_to` on behalf of `_from`
126      *
127      * @param _from The address of the sender
128      * @param _to The address of the recipient
129      * @param _value the amount to send
130      */
131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
132         require(_value <= allowance[_from][msg.sender]);     // Check allowance
133         allowance[_from][msg.sender] -= _value;
134         _transfer(_from, _to, _value);
135         return true;
136     }
137 
138     /**
139      * Set allowance for other address
140      *
141      * Allows `_spender` to spend no more than `_value` tokens on your behalf
142      *
143      * @param _spender The address authorized to spend
144      * @param _value the max amount they can spend
145      */
146     function approve(address _spender, uint256 _value) public
147         returns (bool success) {
148         allowance[msg.sender][_spender] = _value;
149         return true;
150     }
151 
152     /**
153      * Set allowance for other address and notify
154      *
155      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
156      *
157      * @param _spender The address authorized to spend
158      * @param _value the max amount they can spend
159      * @param _extraData some extra information to send to the approved contract
160      */
161     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
162         public
163         returns (bool success) {
164         tokenRecipient spender = tokenRecipient(_spender);
165         if (approve(_spender, _value)) {
166             spender.receiveApproval(msg.sender, _value, this, _extraData);
167             return true;
168         }
169     }
170 
171     /**
172      * Destroy tokens
173      *
174      * Remove `_value` tokens from the system irreversibly
175      *
176      * @param _value the amount of money to burn
177      */
178     function burn(uint256 _value) public returns (bool success) {
179         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
180         balanceOf[msg.sender] -= _value;            // Subtract from the sender
181         totalSupply -= _value;                      // Updates totalSupply
182         emit Burn(msg.sender, _value);
183         return true;
184     }
185 
186     /**
187      * Destroy tokens from other account
188      *
189      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
190      *
191      * @param _from the address of the sender
192      * @param _value the amount of money to burn
193      */
194     function burnFrom(address _from, uint256 _value) public returns (bool success) {
195         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
196         require(_value <= allowance[_from][msg.sender]);    // Check allowance
197         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
198         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
199         totalSupply -= _value;                              // Update totalSupply
200         emit Burn(_from, _value);
201         return true;
202     }
203 }