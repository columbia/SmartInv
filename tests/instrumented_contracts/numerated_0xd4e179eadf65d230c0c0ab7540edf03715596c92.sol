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
22 contract NecashTokenBase {
23     string public constant _myTokeName = 'Necash Token';
24     string public constant _mySymbol = 'NEC';
25     uint public constant _myinitialSupply = 20000000;
26     // Public variables of the token
27     string public name;
28     string public symbol;
29     uint256 public decimals = 18;
30     uint256 public totalSupply;
31 
32     // This creates an array with all balances
33     mapping (address => uint256) public balanceOf;
34     mapping (address => mapping (address => uint256)) public allowance;
35 
36     // This generates a public event on the blockchain that will notify clients
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     // This notifies clients about the amount burnt
40     event Burn(address indexed from, uint256 value);
41 
42     /**
43      * Constrctor function
44      *
45      * Initializes contract with initial supply tokens to the creator of the contract
46      */
47     function NecashTokenBase() public {
48         totalSupply = _myinitialSupply * (10 ** uint256(decimals));
49         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
50         name = _myTokeName;                                   // Set the name for display purposes
51         symbol = _mySymbol;                               // Set the symbol for display purposes
52     }
53 
54     /**
55      * Internal transfer, only can be called by this contract
56      */
57     function _transfer(address _from, address _to, uint _value) internal {
58         // Prevent transfer to 0x0 address. Use burn() instead
59         require(_to != 0x0);
60         // Check if the sender has enough
61         require(balanceOf[_from] >= _value);
62         // Check for overflows
63         require(balanceOf[_to] + _value > balanceOf[_to]);
64         // Save this for an assertion in the future
65         uint previousBalances = balanceOf[_from] + balanceOf[_to];
66         // Subtract from the sender
67         balanceOf[_from] -= _value;
68         // Add the same to the recipient
69         balanceOf[_to] += _value;
70         Transfer(_from, _to, _value);
71         // Asserts are used to use static analysis to find bugs in your code. They should never fail
72         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
73     }
74 
75     /**
76      * Transfer tokens
77      *
78      * Send `_value` tokens to `_to` from your account
79      *
80      * @param _to The address of the recipient
81      * @param _value the amount to send
82      */
83     function transfer(address _to, uint256 _value) public {
84         _transfer(msg.sender, _to, _value);
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
112         returns (bool success) {
113         allowance[msg.sender][_spender] = _value;
114         return true;
115     }
116 
117     /**
118      * Set allowance for other address and notify
119      *
120      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      * @param _extraData some extra information to send to the approved contract
125      */
126     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
127         public
128         returns (bool success) {
129         tokenRecipient spender = tokenRecipient(_spender);
130         if (approve(_spender, _value)) {
131             spender.receiveApproval(msg.sender, _value, this, _extraData);
132             return true;
133         }
134     }
135 }
136 
137 
138 contract NecashToken is owned, NecashTokenBase {
139 
140 
141     mapping (address => bool) public frozenAccount;
142 
143     /* This generates a public event on the blockchain that will notify clients */
144     event FrozenFunds(address target, bool frozen);
145 
146     /* Initializes contract with initial supply tokens to the creator of the contract */
147     function NecashToken() NecashTokenBase() public {}
148 
149     /* Internal transfer, only can be called by this contract */
150     function _transfer(address _from, address _to, uint _value) internal {
151         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
152         require (balanceOf[_from] >= _value);               // Check if the sender has enough
153         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
154         require(!frozenAccount[_from]);                     // Check if sender is frozen
155         require(!frozenAccount[_to]);                       // Check if recipient is frozen
156         balanceOf[_from] -= _value;                         // Subtract from the sender
157         balanceOf[_to] += _value;                           // Add the same to the recipient
158         Transfer(_from, _to, _value);
159     }
160 
161     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
162     /// @param target Address to be frozen
163     /// @param freeze either to freeze it or not
164     function freezeAccount(address target, bool freeze) onlyOwner public {
165         frozenAccount[target] = freeze;
166         FrozenFunds(target, freeze);
167     }
168 }