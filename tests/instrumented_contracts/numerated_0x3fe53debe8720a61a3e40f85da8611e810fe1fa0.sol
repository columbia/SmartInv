1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5     function owned() public {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12     function transferOwnership(address newOwner) onlyOwner public {
13         owner = newOwner;
14     }
15 }
16 
17 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
18 
19 contract MyTokenEVC is owned {
20     // Public variables of the token
21     string public name;
22     string public symbol;
23     uint8 public decimals = 18;
24     // 18 decimals is the strongly suggested default, avoid changing it
25     uint256 public totalSupply;
26     // This creates an array with all balances
27     mapping (address => uint256) public balanceOf;
28     mapping (address => mapping (address => uint256)) public allowance;
29     // This generates a public event on the blockchain that will notify clients
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     // This notifies clients about the amount burnt
32     event Burn(address indexed from, uint256 value);
33     /**
34      * Constrctor function
35      *
36      * Initializes contract with initial supply tokens to the creator of the contract
37      */
38     function MyTokenEVC() public {
39         totalSupply = 0 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
40         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
41         name = "MyTokenEVC 1";                                   // Set the name for display purposes
42         symbol = "MEVC1";                               // Set the symbol for display purposes
43     }
44     
45     function name() public constant returns (string _name) {
46         return name;
47     }
48     
49     function symbol() public constant returns (string _symbol) {
50         return symbol;
51     }
52     
53     function decimals() public constant returns (uint8 _decimals) {
54         return decimals;
55     }
56     
57     function totalSupply() public constant returns (uint256 _totalSupply) {
58         return totalSupply;
59     }
60     
61     function balanceOf(address _owner) public constant returns (uint256 _balance) {
62         return balanceOf[_owner];
63     }
64     
65     mapping (address => bool) public frozenAccount;
66     
67     event FrozenFunds(address target, bool frozen);
68 
69     function freezeAccount (address target, bool freeze) onlyOwner public {
70         frozenAccount[target] = freeze;
71         FrozenFunds(target, freeze);
72     }
73 
74     
75     
76     /**
77      * Internal transfer, only can be called by this contract
78      */
79     function _transfer(address _from, address _to, uint _value) internal {
80         // Prevent transfer to 0x0 address. Use burn() instead
81         require(_to != 0x0);
82         // Check if the sender has enough
83         require(balanceOf[_from] >= _value);
84         // Check for overflows
85         require(balanceOf[_to] + _value > balanceOf[_to]);
86         //Check if FrozenFunds
87         require(!frozenAccount[msg.sender]);
88         // Save this for an assertion in the future
89         uint previousBalances = balanceOf[_from] + balanceOf[_to];
90         // Subtract from the sender
91         balanceOf[_from] -= _value;
92         // Add the same to the recipient
93         balanceOf[_to] += _value;
94         Transfer(_from, _to, _value);
95         // Asserts are used to use static analysis to find bugs in your code. They should never fail
96         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
97     }
98     /**
99      * Transfer tokens
100      *
101      * Send `_value` tokens to `_to` from your account
102      *
103      * @param _to The address of the recipient
104      * @param _value the amount to send
105      */
106     function transfer(address _to, uint256 _value) public {
107         _transfer(msg.sender, _to, _value);
108     }
109     /**
110      * Transfer tokens from other address
111      *
112      * Send `_value` tokens to `_to` in behalf of `_from`
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
124     /**
125      * Set allowance for other address
126      *
127      * Allows `_spender` to spend no more than `_value` tokens in your behalf
128      *
129      * @param _spender The address authorized to spend
130      * @param _value the max amount they can spend
131      */
132     function approve(address _spender, uint256 _value) public
133         returns (bool success) {
134         allowance[msg.sender][_spender] = _value;
135         return true;
136     }
137     /**
138      * Set allowance for other address and notify
139      *
140      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
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
155     /**
156      * Destroy tokens
157      *
158      * Remove `_value` tokens from the system irreversibly
159      *
160      * @param _value the amount of money to burn
161      */
162     function burn(uint256 _value) onlyOwner public returns (bool success) {
163         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
164         balanceOf[msg.sender] -= _value;            // Subtract from the sender
165         totalSupply -= _value;                      // Updates totalSupply
166         Burn(msg.sender, _value);
167         return true;
168     }
169     /**
170      * Destroy tokens from other account
171      *
172      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
173      *
174      * @param _from the address of the sender
175      * @param _value the amount of money to burn
176      */
177     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
178         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
179     ///    require(_value <= allowance[_from][msg.sender]);    // Check allowance
180         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
181         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
182         totalSupply -= _value;                              // Update totalSupply
183         Burn(_from, _value);
184         return true;
185     }
186     /// @notice Create `mintedAmount` tokens and send it to `owner`
187     /// @param mintedAmount the amount of tokens it will receive
188     function mintToken(uint256 mintedAmount) onlyOwner public {
189         balanceOf[this] += mintedAmount;
190         totalSupply += mintedAmount;
191         Transfer(0, this, mintedAmount);
192     }
193 }