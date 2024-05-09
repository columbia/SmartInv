1 pragma solidity ^0.4.18;
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract BalToken is owned {
23     string public name;                 // Name of the Token
24     string public symbol;               // Symbol of the Token
25     uint8 public decimals = 18;         // Decimal Places for the token
26     uint256 public totalSupply;         // Total Supply of the token
27 
28     struct frozenInfo {
29         bool frozen;                    // Frozen state of the account
30         uint till;                      // The timestamp account will be frozen till
31     }
32     
33     // This creates an array with all balances
34     mapping (address => uint256) public balanceOf;
35 
36     // This creates an array with all allowances
37     mapping (address => mapping (address => uint256)) public allowance;
38 
39     // This creates and array with all Frozen accounts with time limit
40     mapping (address => frozenInfo) public frozenAccount;
41     
42     // This generates a public event on the blockchain that will notify clients
43     event FrozenFunds(address target, bool frozen, uint till);
44 
45     // This generates a public event on the blockchain that will notify clients
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     /**
49      * Constrctor function
50      *
51      * Initializes contract with initial supply tokens to the creator of the contract
52      */
53     function BalToken(
54         uint256 initialSupply,
55         string tokenName,
56         string tokenSymbol
57     ) public 
58     {
59         totalSupply = initialSupply * 10 ** uint256(decimals);      // Update total supply with the decimal amount
60         balanceOf[msg.sender] = totalSupply;                        // Give the creator all initial tokens
61         name = tokenName;                                           // Set the name for display purposes
62         symbol = tokenSymbol;                                       // Set the symbol for display purposes
63     }
64 
65     /**
66      * Function for other contracts to call to get balances of individual accounts
67      */
68     function getBalanceOf(address _owner) public constant returns (uint256 balance) {
69         return balanceOf[_owner];
70     }    
71 
72     /**
73      * Internal transfer, only can be called by this contract
74      */
75     function _transfer(address _from, address _to, uint _value) internal {
76         require (_to != 0x0);                                           // Prevent transfer to 0x0 address.
77         require (_to != address(this));                                 // Prevent transfer back to this contract
78         require (balanceOf[_from] >= _value);                           // Check if the sender has enough
79         require (balanceOf[_to] + _value > balanceOf[_to]);             // Check for overflows
80         require(!(frozenAccount[_from].frozen));                        // Check if sender is frozen
81         require(!(frozenAccount[_to].frozen));                          // Check if recipient is frozen
82         uint previousBalances = balanceOf[_from] + balanceOf[_to];      // Save this value for assertion
83 
84         balanceOf[_from] -= _value;                                     // Subtract from the sender
85         balanceOf[_to] += _value;                                       // Add the same to the recipient
86         Transfer(_from, _to, _value);                                   // Transfer the token from _from to _to for the amount of _value
87         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  // Asserts that the previous value matches the current value 
88     }
89 
90     /**
91      * Transfer tokens
92      *
93      * Send `_value` tokens to `_to` from your account
94      *
95      * @param _to The address of the recipient
96      * @param _value the amount to send
97      */
98     function transfer(address _to, uint256 _value) public {
99         _transfer(msg.sender, _to, _value);
100     }
101 
102     /**
103      * Transfer tokens from other address
104      *
105      * Send `_value` tokens to `_to` in behalf of `_from`
106      *
107      * @param _from The address of the sender
108      * @param _to The address of the recipient
109      * @param _value the amount to send
110      */
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
112         require(_value <= allowance[_from][msg.sender]);     // Check allowance
113         allowance[_from][msg.sender] -= _value; // Subtract from the 
114         _transfer(_from, _to, _value);
115         return true;
116     }
117 
118     /**
119      * Set allowance for other address
120      *
121      * Allows `_spender` to spend no more than `_value` tokens in your behalf
122      *
123      * @param _spender The address authorized to spend
124      * @param _value the max amount they can spend
125      */
126     function approve(address _spender, uint256 _value) public returns (bool success) {
127         allowance[msg.sender][_spender] = _value;
128         return true;
129     }
130 
131     /**
132      * Set allowance for other address and notify
133      *
134      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
135      *
136      * @param _spender The address authorized to spend
137      * @param _value the max amount they can spend
138      * @param _extraData some extra information to send to the approved contract
139      */
140     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
141         tokenRecipient spender = tokenRecipient(_spender);
142         if (approve(_spender, _value)) {
143             spender.receiveApproval(msg.sender, _value, this, _extraData);
144             return true;
145         }
146     }
147 
148     /// @notice `freeze? Prevent` `target` from sending & receiving tokens
149     /// @param target Address to be frozen
150     /// @param till Timestamp frozen till
151     function freezeAccount(address target, uint till) onlyOwner public {
152         require(!frozenAccount[target].frozen); 
153 
154         frozenInfo memory fi = frozenInfo(true, till);
155         frozenAccount[target] = fi;
156         FrozenFunds(target, true, till);
157 
158     }
159 
160     /// @notice `unfreeze? Allows` `target` from sending & receiving tokens
161     /// @param target Address to be unfrozen
162     function unfreezeAccount(address target) onlyOwner public {
163         require(frozenAccount[target].frozen);
164         require(frozenAccount[target].till < now);
165         
166         frozenInfo memory fi = frozenInfo(false, 0);
167         frozenAccount[target] = fi;
168         FrozenFunds(target, false, 0);
169     }
170 }