1 pragma solidity >=0.4.22 <0.6.0;
2 
3 // ----------------------------------------------------------------------------
4 // ‘JMT’ token contract
5 //
6 // Symbol      : JMT
7 // Name        : JMToken
8 // Total supply: 100000000
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 interface tokenRecipient { 
14     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
15 }
16 
17 contract JMToken {
18     // Public variables of the token
19     string public name;
20     string public symbol;
21     uint8 public decimals = 18;
22     // 18 decimals is the strongly suggested default, avoid changing it
23     uint256 public totalSupply;
24 
25     // This creates an array with all balances
26     mapping (address => uint256) public balanceOf;
27     mapping (address => mapping (address => uint256)) public allowance;
28 
29     // This generates a public event on the blockchain that will notify clients
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     
32     // This generates a public event on the blockchain that will notify clients
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 
35     // This notifies clients about the amount burnt
36     event Burn(address indexed from, uint256 value);
37 
38     /**
39      * Constructor function
40      *
41      * Initializes contract with initial supply tokens to the creator of the contract
42      */
43     constructor(
44         uint256 initialSupply,
45         string memory tokenName,
46         string memory tokenSymbol
47     ) public {
48         totalSupply = 100000000000000000000000000;  // Update total supply with the decimal amount
49         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
50         name = "JMToken";                                   // Set the name for display purposes
51         symbol = "JMT";                               // Set the symbol for display purposes
52     }
53 
54     /**
55      * Internal transfer, only can be called by this contract
56      */
57     function _transfer(address _from, address _to, uint _value) internal {
58         // Prevent transfer to 0x0 address. Use burn() instead
59         require(_to != address(0x0));
60         // Check if the sender has enough
61         require(balanceOf[_from] >= _value);
62         // Check for overflows
63         require(balanceOf[_to] + _value >= balanceOf[_to]);
64         // Save this for an assertion in the future
65         uint previousBalances = balanceOf[_from] + balanceOf[_to];
66         // Subtract from the sender
67         balanceOf[_from] -= _value;
68         // Add the same to the recipient
69         balanceOf[_to] += _value;
70         emit Transfer(_from, _to, _value);
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
83     function transfer(address _to, uint256 _value) public returns (bool success) {
84         _transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     /**
89      * Transfer tokens from other address
90      *
91      * Send `_value` tokens to `_to` on behalf of `_from`
92      *
93      * @param _from The address of the sender
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
98         require(_value <= allowance[_from][msg.sender]);     // Check allowance
99         allowance[_from][msg.sender] -= _value;
100         _transfer(_from, _to, _value);
101         return true;
102     }
103 
104     /**
105      * Set allowance for other address
106      *
107      * Allows `_spender` to spend no more than `_value` tokens on your behalf
108      *
109      * @param _spender The address authorized to spend
110      * @param _value the max amount they can spend
111      */
112     function approve(address _spender, uint256 _value) public
113         returns (bool success) {
114         allowance[msg.sender][_spender] = _value;
115         emit Approval(msg.sender, _spender, _value);
116         return true;
117     }
118 
119     /**
120      * Set allowance for other address and notify
121      *
122      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
123      *
124      * @param _spender The address authorized to spend
125      * @param _value the max amount they can spend
126      * @param _extraData some extra information to send to the approved contract
127      */
128     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
129         public
130         returns (bool success) {
131         tokenRecipient spender = tokenRecipient(_spender);
132         if (approve(_spender, _value)) {
133             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
134             return true;
135         }
136     }
137 
138     /**
139      * Destroy tokens
140      *
141      * Remove `_value` tokens from the system irreversibly
142      *
143      * @param _value the amount of money to burn
144      */
145     function burn(uint256 _value) public returns (bool success) {
146         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
147         balanceOf[msg.sender] -= _value;            // Subtract from the sender
148         totalSupply -= _value;                      // Updates totalSupply
149         emit Burn(msg.sender, _value);
150         return true;
151     }
152 
153     /**
154      * Destroy tokens from other account
155      *
156      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
157      *
158      * @param _from the address of the sender
159      * @param _value the amount of money to burn
160      */
161     function burnFrom(address _from, uint256 _value) public returns (bool success) {
162         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
163         require(_value <= allowance[_from][msg.sender]);    // Check allowance
164         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
165         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
166         totalSupply -= _value;                              // Update totalSupply
167         emit Burn(_from, _value);
168         return true;
169     }
170 }