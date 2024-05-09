1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 
6     constructor () public {
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
22 contract ERC20 is owned {
23     // Public variables of the token
24     string public name = "Intcoex coin";
25     string public symbol = "ITX";
26     uint8 public decimals = 18;
27     uint256 public totalSupply = 200000000 * 10 ** uint256(decimals);
28 
29     bool public released = false;
30 
31     /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
32     address public ICO_Contract;
33 
34     // This creates an array with all balances
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37     mapping (address => bool) public frozenAccount;
38    
39     // This generates a public event on the blockchain that will notify clients
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     /* This generates a public event on the blockchain that will notify clients */
43     event FrozenFunds(address target, bool frozen);
44 
45     /**
46      * Constrctor function
47      *
48      * Initializes contract with initial supply tokens to the creator of the contract
49      */
50     constructor () public {
51         balanceOf[owner] = totalSupply;
52     }
53     modifier canTransfer() {
54         require(released ||  msg.sender == ICO_Contract || msg.sender == owner);
55        _;
56      }
57 
58     function releaseToken() public onlyOwner {
59         released = true;
60     }
61     
62     /**
63      * Internal transfer, only can be called by this contract
64      */
65     function _transfer(address _from, address _to, uint256 _value) canTransfer internal {
66         // Prevent transfer to 0x0 address. Use burn() instead
67         require(_to != 0x0);
68         // Check if the sender has enough
69         require(balanceOf[_from] >= _value);
70         // Check for overflows
71         require(balanceOf[_to] + _value > balanceOf[_to]);
72         // Check if sender is frozen
73         require(!frozenAccount[_from]);
74         // Check if recipient is frozen
75         require(!frozenAccount[_to]);
76         // Save this for an assertion in the future
77         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
78         // Subtract from the sender
79         balanceOf[_from] -= _value;
80         // Add the same to the recipient
81         balanceOf[_to] += _value;
82         emit Transfer(_from, _to, _value);
83         // Asserts are used to use static analysis to find bugs in your code. They should never fail
84         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
85     }
86 
87     /**
88      * Transfer tokens
89      *
90      * Send `_value` tokens to `_to` from your account
91      *
92      * @param _to The address of the recipient
93      * @param _value the amount to send
94      */
95     function transfer(address _to, uint256 _value) public {
96         _transfer(msg.sender, _to, _value);
97     }
98 
99     /**
100      * Transfer tokens from other address
101      *
102      * Send `_value` tokens to `_to` in behalf of `_from`
103      *
104      * @param _from The address of the sender
105      * @param _to The address of the recipient
106      * @param _value the amount to send
107      */
108     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool success) {
109         require(_value <= allowance[_from][msg.sender]);     // Check allowance
110         allowance[_from][msg.sender] -= _value;
111         _transfer(_from, _to, _value);
112         return true;
113     }
114 
115     /**
116      * Set allowance for other address
117      *
118      * Allows `_spender` to spend no more than `_value` tokens in your behalf
119      *
120      * @param _spender The address authorized to spend
121      * @param _value the max amount they can spend
122      */
123     function approve(address _spender, uint256 _value) public
124         returns (bool success) {
125         allowance[msg.sender][_spender] = _value;
126         return true;
127     }
128 
129     /**
130      * Set allowance for other address and notify
131      *
132      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
133      *
134      * @param _spender The address authorized to spend
135      * @param _value the max amount they can spend
136      * @param _extraData some extra information to send to the approved contract
137      */
138     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
139         public
140         returns (bool success) {
141         tokenRecipient spender = tokenRecipient(_spender);
142         if (approve(_spender, _value)) {
143             spender.receiveApproval(msg.sender, _value, this, _extraData);
144             return true;
145         }
146     }
147 
148     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
149     /// @param target Address to be frozen
150     /// @param freeze either to freeze it or not
151     function freezeAccount(address target, bool freeze) onlyOwner public {
152         frozenAccount[target] = freeze;
153         emit FrozenFunds(target, freeze);
154     }
155     
156     /// @dev Set the ICO_Contract.
157     /// @param _ICO_Contract crowdsale contract address
158     function setICO_Contract(address _ICO_Contract) onlyOwner public {
159         ICO_Contract = _ICO_Contract;
160     }
161 }