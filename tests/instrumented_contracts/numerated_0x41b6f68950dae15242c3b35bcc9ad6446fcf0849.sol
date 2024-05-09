1 // Powered by SCVSoft
2 // https://www.scvsoft.net/
3 pragma solidity >=0.4.22 <0.6.0;
4 contract owned {
5     address public owner;
6     constructor() public {
7         owner = msg.sender;
8     }
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13     function transferOwnership(address newOwner) onlyOwner public {
14         owner = newOwner;
15     }
16 }
17 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
18 contract TokenERC20 {
19     // Public variables of the token
20     string public name;
21     string public symbol;
22     uint8 public decimals = 18;
23     // 18 decimals is the strongly suggested default, avoid changing it
24     uint256 public totalSupply;
25     // This creates an array with all balances
26     mapping (address => uint256) public balanceOf;
27     mapping (address => mapping (address => uint256)) public allowance;
28     // This generates a public event on the blockchain that will notify clients
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     
31     // This generates a public event on the blockchain that will notify clients
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33     // This notifies clients about the amount burnt
34     event Burn(address indexed from, uint256 value);
35     /**
36      * Constrctor function
37      *
38      * Initializes contract with initial supply tokens to the creator of the contract
39      */
40     constructor(
41         uint256 initialSupply,
42         string memory tokenName,
43         string memory tokenSymbol
44     ) public {
45         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
46         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
47         name = tokenName;                                       // Set the name for display purposes
48         symbol = tokenSymbol;                                   // Set the symbol for display purposes
49     }
50     /**
51      * Internal transfer, only can be called by this contract
52      */
53     function _transfer(address _from, address _to, uint _value) internal {
54         // Prevent transfer to 0x0 address. Use burn() instead
55         require(_to != address(0x0));
56         // Check if the sender has enough
57         require(balanceOf[_from] >= _value);
58         // Check for overflows
59         require(balanceOf[_to] + _value > balanceOf[_to]);
60         // Save this for an assertion in the future
61         uint previousBalances = balanceOf[_from] + balanceOf[_to];
62         // Subtract from the sender
63         balanceOf[_from] -= _value;
64         // Add the same to the recipient
65         balanceOf[_to] += _value;
66         emit Transfer(_from, _to, _value);
67         // Asserts are used to use static analysis to find bugs in your code. They should never fail
68         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
69     }
70     /**
71      * Transfer tokens
72      *
73      * Send `_value` tokens to `_to` from your account
74      *
75      * @param _to The address of the recipient
76      * @param _value the amount to send
77      */
78     function transfer(address _to, uint256 _value) public returns (bool success) {
79         _transfer(msg.sender, _to, _value);
80         return true;
81     }
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
97     /**
98      * Set allowance for other address
99      *
100      * Allows `_spender` to spend no more than `_value` tokens in your behalf
101      *
102      * @param _spender The address authorized to spend
103      * @param _value the max amount they can spend
104      */
105     function approve(address _spender, uint256 _value) public
106         returns (bool success) {
107         allowance[msg.sender][_spender] = _value;
108         emit Approval(msg.sender, _spender, _value);
109         return true;
110     }
111     /**
112      * Set allowance for other address and notify
113      *
114      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
115      *
116      * @param _spender The address authorized to spend
117      * @param _value the max amount they can spend
118      * @param _extraData some extra information to send to the approved contract
119      */
120     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
121         public
122         returns (bool success) {
123         tokenRecipient spender = tokenRecipient(_spender);
124         if (approve(_spender, _value)) {
125             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
126             return true;
127         }
128     }
129     /**
130      * Destroy tokens
131      *
132      * Remove `_value` tokens from the system irreversibly
133      *
134      * @param _value the amount of money to burn
135      */
136     function burn(uint256 _value) public returns (bool success) {
137         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
138         balanceOf[msg.sender] -= _value;            // Subtract from the sender
139         totalSupply -= _value;                      // Updates totalSupply
140         emit Burn(msg.sender, _value);
141         return true;
142     }
143     /**
144      * Destroy tokens from other account
145      *
146      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
147      *
148      * @param _from the address of the sender
149      * @param _value the amount of money to burn
150      */
151     function burnFrom(address _from, uint256 _value) public returns (bool success) {
152         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
153         require(_value <= allowance[_from][msg.sender]);    // Check allowance
154         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
155         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
156         totalSupply -= _value;                              // Update totalSupply
157         emit Burn(_from, _value);
158         return true;
159     }
160 }
161 /******************************************/
162 /*       ADVANCED TOKEN STARTS HERE       */
163 /******************************************/
164 contract KDA is owned, TokenERC20 {
165     mapping (address => bool) public frozenAccount;
166     /* This generates a public event on the blockchain that will notify clients */
167     event FrozenFunds(address target, bool frozen);
168     /* Initializes contract with initial supply tokens to the creator of the contract */
169     constructor(
170         uint256 initialSupply,
171         string memory tokenName,
172         string memory tokenSymbol
173     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
174     /* Internal transfer, only can be called by this contract */
175     function _transfer(address _from, address _to, uint _value) internal {
176         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
177         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
178         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
179         require(!frozenAccount[_from]);                         // Check if sender is frozen
180         require(!frozenAccount[_to]);                           // Check if recipient is frozen
181         balanceOf[_from] -= _value;                             // Subtract from the sender
182         balanceOf[_to] += _value;                               // Add the same to the recipient
183         emit Transfer(_from, _to, _value);
184     }
185     /// @notice Create `mintedAmount` tokens and send it to `target`
186     /// @param target Address to receive the tokens
187     /// @param mintedAmount the amount of tokens it will receive
188     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
189         balanceOf[target] += mintedAmount;
190         totalSupply += mintedAmount;
191         emit Transfer(address(0), address(this), mintedAmount);
192         emit Transfer(address(this), target, mintedAmount);
193     }
194     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
195     /// @param target Address to be frozen
196     /// @param freeze either to freeze it or not
197     function freezeAccount(address target, bool freeze) onlyOwner public {
198         frozenAccount[target] = freeze;
199         emit FrozenFunds(target, freeze);
200     }
201 }