1 pragma solidity ^0.4.24;
2 
3 // Token name: HyperChipToken
4 // Symbol: HYCT
5 // Decimals: 8
6 // Twitter : @HyperChipToken
7 
8 
9 interface tokenRecipient {
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
13   function allowance(address owner, address spender) public view returns (uint256);
14   function transferFrom(address from, address to, uint256 value) public returns (bool);
15   function approve(address spender, uint256 value) public returns (bool);
16   
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19      
20 contract HyperChipToken {
21     // Public variables of the token
22     string public name = "HyperChipToken";
23     string public symbol = "HYCT";
24     uint8 public decimals = 8;
25 	uint256 public unitsOneEthCanBuy = 10000000000000;
26 	uint256 public totalEthInWei = 5000000;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply = 500;
29     address public fundsWallet;
30 
31     // This creates an array with all balances
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     // This generates a public event on the blockchain that will notify clients
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     // This notifies clients about the amount burnt
39     event Burn(address indexed from, uint256 value);
40     
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balanceOf[_owner];
43     }
44 
45     /**
46      * Constructor function
47      *
48      * Initializes contract with initial supply tokens to the creator of the contract
49      */
50     function Constructor(uint256 initialSupply, string tokenName, string tokenSymbol
51     ) public {
52         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
53         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
54         name = tokenName;                                   // Set the name for display purposes
55         symbol = tokenSymbol;                               // Set the symbol for display purposes
56     }
57 	
58 	
59 	function() payable{
60         totalEthInWei = totalEthInWei + msg.value;
61         uint256 amount = msg.value * unitsOneEthCanBuy;
62         require(balanceOf[fundsWallet] >= amount);
63 
64         balanceOf[fundsWallet] = balanceOf[fundsWallet] - amount;
65         balanceOf[msg.sender] = balanceOf[msg.sender] + amount;
66 
67         emit Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
68 
69         //Transfer ether to fundsWallet
70         fundsWallet.transfer(msg.value);                               
71     }
72 	
73 
74     /**
75      * Internal transfer, only can be called by this contract
76      */
77     function _transfer(address _from, address _to, uint _value) internal {
78         // Prevent transfer to 0x0 address. Use burn() instead
79         require(_to != 0x0);
80         // Check if the sender has enough
81         require(balanceOf[_from] >= _value);
82         // Check for overflows
83         require(balanceOf[_to] + _value >= balanceOf[_to]);
84         // Save this for an assertion in the future
85         uint previousBalances = balanceOf[_from] + balanceOf[_to];
86         // Subtract from the sender
87         balanceOf[_from] -= _value;
88         // Add the same to the recipient
89         balanceOf[_to] += _value;
90         emit Transfer(_from, _to, _value);
91         // Asserts are used to use static analysis to find bugs in your code. They should never fail
92         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
93     }
94 
95     /**
96      * Transfer tokens
97      *
98      * Send `_value` tokens to `_to` from your account
99      *
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transfer(address _to, uint256 _value) public {
104         _transfer(msg.sender, _to, _value);
105     }
106 
107     /**
108      * Transfer tokens from other address
109      *
110      * Send `_value` tokens to `_to` on behalf of `_from`
111      *
112      * @param _from The address of the sender
113      * @param _to The address of the recipient
114      * @param _value the amount to send
115      */
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
117         require(_value <= allowance[_from][msg.sender]);     // Check allowance
118         allowance[_from][msg.sender] -= _value;
119         _transfer(_from, _to, _value);
120         return true;
121     }
122 
123     /**
124      * Set allowance for other address
125      *
126      * Allows `_spender` to spend no more than `_value` tokens on your behalf
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      */
131     function approve(address _spender, uint256 _value) public
132         returns (bool success) {
133         allowance[msg.sender][_spender] = _value;
134         return true;
135     }
136 
137     /**
138      * Set allowance for other address and notify
139      *
140      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
141      *
142      * @param _spender The address authorized to spend
143      * @param _value the max amount they can spend
144      * @param _extraData some extra information to send to the approved contract
145      */
146     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
147         public
148         returns (bool success) {
149         tokenRecipient spender = tokenRecipient(_spender);
150         if (approve(_spender, _value)) {
151             spender.receiveApproval(msg.sender, _value, this, _extraData);
152             return true;
153         }
154     }
155 
156     /**
157      * Destroy tokens
158      *
159      * Remove `_value` tokens from the system irreversibly
160      *
161      * @param _value the amount of money to burn
162      */
163     function burn(uint256 _value) public returns (bool success) {
164         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
165         balanceOf[msg.sender] -= _value;            // Subtract from the sender
166         totalSupply -= _value;                      // Updates totalSupply
167         emit Burn(msg.sender, _value);
168         return true;
169     }
170 
171     /**
172      * Destroy tokens from other account
173      *
174      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
175      *
176      * @param _from the address of the sender
177      * @param _value the amount of money to burn
178      */
179     function burnFrom(address _from, uint256 _value) public returns (bool success) {
180         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
181         require(_value <= allowance[_from][msg.sender]);    // Check allowance
182         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
183         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
184         totalSupply -= _value;                              // Update totalSupply
185         emit Burn(_from, _value);
186         return true;
187     }
188 }