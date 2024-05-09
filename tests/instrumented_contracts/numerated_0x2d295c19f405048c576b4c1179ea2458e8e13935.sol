1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract owned {
6     address public owner;
7 
8     function owned() {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16     function transferOwnership(address newOwner) onlyOwner {
17         owner = newOwner;
18     }
19 }    
20 
21 contract x32323 is owned{
22 
23     mapping (address => bool) public frozenAccount;
24     event FrozenFunds(address target, bool frozen);
25 
26     function freezeAccount(address target, bool freeze) onlyOwner {
27         frozenAccount[target] = freeze;
28         FrozenFunds(target, freeze);
29     }
30 
31 
32     function MyToken(
33         uint256 initialSupply,
34         string tokenName,
35         uint8 decimalUnits,
36         string tokenSymbol,
37         address centralMinter
38         ) {
39         if(centralMinter != 0 ) owner = centralMinter;
40     }
41 
42     // Public variables of the token
43     string public name;
44     string public symbol;
45     uint8 public decimals = 0;
46     // 0 decimals is the strongly suggested default, avoid changing it
47     uint256 public totalSupply;
48 
49     // This creates an array with all balances
50     mapping (address => uint256) public balanceOf;
51     mapping (address => mapping (address => uint256)) public allowance;
52 
53     // This generates a public event on the blockchain that will notify clients
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 
56     // This notifies clients about the amount burnt
57     event Burn(address indexed from, uint256 value);
58 
59     /**
60      * Constructor function
61      *
62      * Initializes contract with initial supply tokens to the creator of the contract
63      */
64     function TokenERC20(
65         uint256 initialSupply,
66         string tokenName,
67         string tokenSymbol
68     ) public {
69         totalSupply = 23000000;  // Update total supply with the decimal amount
70         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
71         name = "測試3";                                   // Set the name for display purposes
72         symbol = "測試3";                               // Set the symbol for display purposes
73     }
74 
75     /**
76      * Internal transfer, only can be called by this contract
77      */
78     function _transfer(address _from, address _to, uint _value) internal {
79         // Prevent transfer to 0x0 address. Use burn() instead
80         require(_to != 0x0);
81         // Check if the sender has enough
82         require(balanceOf[_from] >= _value);
83         // Check for overflows
84         require(balanceOf[_to] + _value > balanceOf[_to]);
85         // Save this for an assertion in the future
86         uint previousBalances = balanceOf[_from] + balanceOf[_to];
87         // Subtract from the sender
88         balanceOf[_from] -= _value;
89         // Add the same to the recipient
90         balanceOf[_to] += _value;
91         Transfer(_from, _to, _value);
92         // Asserts are used to use static analysis to find bugs in your code. They should never fail
93         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
94     }
95 
96     /**
97      * Transfer tokens
98      *
99      * Send `_value` tokens to `_to` from your account
100      *
101      * @param _to The address of the recipient
102      * @param _value the amount to send
103      */
104     function transfer(address _to, uint256 _value) public {
105         require(!frozenAccount[msg.sender]);
106         _transfer(msg.sender, _to, _value);
107     }
108 
109     /**
110      * Transfer tokens from other address
111      *
112      * Send `_value` tokens to `_to` on behalf of `_from`
113      *
114      * @param _from The address of the sender
115      * @param _to The address of the recipient
116      * @param _value the amount to send
117      */
118     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
119         require(_value <= allowance[_from][msg.sender]);     // Check allowance
120         allowance[_from][msg.sender] -= _value;
121         _transfer(_from, _to, _value);
122         return true;
123     }
124 
125     /**
126      * Set allowance for other address
127      *
128      * Allows `_spender` to spend no more than `_value` tokens on your behalf
129      *
130      * @param _spender The address authorized to spend
131      * @param _value the max amount they can spend
132      */
133     function approve(address _spender, uint256 _value) public
134         returns (bool success) {
135         allowance[msg.sender][_spender] = _value;
136         return true;
137     }
138 
139     /**
140      * Set allowance for other address and notify
141      *
142      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
143      *
144      * @param _spender The address authorized to spend
145      * @param _value the max amount they can spend
146      * @param _extraData some extra information to send to the approved contract
147      */
148     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
149         public
150         returns (bool success) {
151         tokenRecipient spender = tokenRecipient(_spender);
152         if (approve(_spender, _value)) {
153             spender.receiveApproval(msg.sender, _value, this, _extraData);
154             return true;
155         }
156     }
157 
158     /**
159      * Destroy tokens
160      *
161      * Remove `_value` tokens from the system irreversibly
162      *
163      * @param _value the amount of money to burn
164      */
165     function burn(uint256 _value) public returns (bool success) {
166         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
167         balanceOf[msg.sender] -= _value;            // Subtract from the sender
168         totalSupply -= _value;                      // Updates totalSupply
169         Burn(msg.sender, _value);
170         return true;
171     }
172 
173     /**
174      * Destroy tokens from other account
175      *
176      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
177      *
178      * @param _from the address of the sender
179      * @param _value the amount of money to burn
180      */
181     function burnFrom(address _from, uint256 _value) public returns (bool success) {
182         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
183         require(_value <= allowance[_from][msg.sender]);    // Check allowance
184         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
185         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
186         totalSupply -= _value;                              // Update totalSupply
187         Burn(_from, _value);
188         return true;
189     }
190 }