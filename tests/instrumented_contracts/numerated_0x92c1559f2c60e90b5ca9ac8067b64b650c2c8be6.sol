1 pragma solidity ^0.5.8;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 }
15 
16 contract TokenERC20 {
17     // Public variables of the token
18     string public name;
19     string public symbol;
20     uint8 public decimals = 18;
21     // 18 decimals is the strongly suggested default, avoid changing it
22     uint256 public totalSupply;
23 
24     // This creates an array with all balances
25     mapping (address => uint256) public balanceOf;
26     mapping (address => mapping (address => uint256)) public allowance;
27 
28     // This generates a public event on the blockchain that will notify clients
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     // This generates a public event on the blockchain that will notify clients
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 
34     // This notifies clients about the amount burnt
35     event Burn(address indexed from, uint256 value);
36 
37     /**
38      * Constrctor function
39      *
40      * Initializes contract with initial supply tokens to the creator of the contract
41      */
42     constructor(
43         uint256 initialSupply,
44         string memory tokenName,
45         string memory tokenSymbol
46     ) public {
47         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
48         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
49         name = tokenName;                                   // Set the name for display purposes
50         symbol = tokenSymbol;                               // Set the symbol for display purposes
51     }
52 
53     /**
54      * Internal transfer, only can be called by this contract
55      */
56     function _transfer(address _from, address _to, uint _value) internal {
57         // Prevent transfer to 0x0 address. Use burn() instead
58         require(_to != address(0x0));
59         // Check if the sender has enough
60         require(balanceOf[_from] >= _value);
61         // Check for overflows
62         require(balanceOf[_to] + _value > balanceOf[_to]);
63         // Save this for an assertion in the future
64         uint previousBalances = balanceOf[_from] + balanceOf[_to];
65         // Subtract from the sender
66         balanceOf[_from] -= _value;
67         // Add the same to the recipient
68         balanceOf[_to] += _value;
69         emit Transfer(_from, _to, _value);
70         // Asserts are used to use static analysis to find bugs in your code. They should never fail
71         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
72     }
73 
74     /**
75      * Transfer tokens
76      *
77      * Send `_value` tokens to `_to` from your account
78      *
79      * @param _to The address of the recipient
80      * @param _value the amount to send
81      */
82     function transfer(address _to, uint256 _value) public returns (bool success) {
83         _transfer(msg.sender, _to, _value);
84         return true;
85     }
86 
87     /**
88      * Transfer tokens from other address
89      *
90      * Send `_value` tokens to `_to` in behalf of `_from`
91      *
92      * @param _from The address of the sender
93      * @param _to The address of the recipient
94      * @param _value the amount to send
95      */
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
97         require(_value <= allowance[_from][msg.sender]);     // Check allowance
98         allowance[_from][msg.sender] -= _value;
99         _transfer(_from, _to, _value);
100         return true;
101     }
102 
103     /**
104      * Set allowance for other address
105      *
106      * Allows `_spender` to spend no more than `_value` tokens in your behalf
107      *
108      * @param _spender The address authorized to spend
109      * @param _value the max amount they can spend
110      */
111     function approve(address _spender, uint256 _value) public
112     returns (bool success) {
113         allowance[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     /**
119      * Destroy tokens
120      *
121      * Remove `_value` tokens from the system irreversibly
122      *
123      * @param _value the amount of money to burn
124      */
125     function burn(uint256 _value) public returns (bool success) {
126         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
127         balanceOf[msg.sender] -= _value;            // Subtract from the sender
128         totalSupply -= _value;                      // Updates totalSupply
129         emit Burn(msg.sender, _value);
130         return true;
131     }
132 }
133 
134 /******************************************/
135 /*       ADVANCED TOKEN STARTS HERE       */
136 /******************************************/
137 
138 contract CSOToken is owned, TokenERC20 {
139 
140     mapping (address => bool) public frozenAccount;
141 
142     /* This generates a public event on the blockchain that will notify clients */
143     event FrozenFunds(address target, bool frozen);
144 
145     /* Initializes contract with initial supply tokens to the creator of the contract */
146     constructor(
147         uint256 initialSupply,
148         string memory tokenName,
149         string memory tokenSymbol
150     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
151 
152     /* Internal transfer, only can be called by this contract */
153     function _transfer(address _from, address _to, uint _value) internal {
154         require (_to != address(0x0));                               // Prevent transfer to 0x0 address. Use burn() instead
155         require (balanceOf[_from] >= _value);               // Check if the sender has enough
156         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
157         require(!frozenAccount[_from]);                     // Check if sender is frozen
158         require(!frozenAccount[_to]);                       // Check if recipient is frozen
159         balanceOf[_from] -= _value;                         // Subtract from the sender
160         balanceOf[_to] += _value;                           // Add the same to the recipient
161         emit Transfer(_from, _to, _value);
162     }
163 
164     /// @notice Create `mintedAmount` tokens and send it to `target`
165     /// @param target Address to receive the tokens
166     /// @param mintedAmount the amount of tokens it will receive
167     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
168         balanceOf[target] += mintedAmount;
169         totalSupply += mintedAmount;
170         emit Transfer(address(0), address(this), mintedAmount);
171         emit Transfer(address(this), target, mintedAmount);
172     }
173 
174     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
175     /// @param target Address to be frozen
176     /// @param freeze either to freeze it or not
177     function freezeAccount(address target, bool freeze) onlyOwner public {
178         frozenAccount[target] = freeze;
179         emit FrozenFunds(target, freeze);
180     }
181 }