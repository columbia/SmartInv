1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;}
4 
5 contract STLcoin {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
13     // This creates an array with all balances
14     mapping(address => uint256) public balanceOf;
15     mapping(address => mapping(address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23     /**
24     * Constrctor function
25     * Initializes contract with initial supply tokens to the creator of the contract
26     */
27     function STLcoin(
28         uint256 initialSupply,
29         string tokenName,
30         string tokenSymbol
31     ) public {
32         totalSupply = initialSupply * 10 ** uint256(decimals);
33         // Update total supply with the decimal amount
34         balanceOf[msg.sender] = totalSupply;
35         // Give the creator all initial tokens
36         name = tokenName;
37         // Set the name for display purposes
38         symbol = tokenSymbol;
39         // Set the symbol for display purposes
40     }
41 
42     /**
43     * Internal transfer, only can be called by this contract
44     */
45     function _transfer(address _from, address _to, uint _value) internal {
46         // Prevent transfer to 0x0 address. Use burn() instead
47         require(_to != 0x0);
48         // Check if the sender has enough
49         require(balanceOf[_from] >= _value);
50         // Check for overflows
51         require(balanceOf[_to] + _value > balanceOf[_to]);
52         // Save this for an assertion in the future
53         uint previousBalances = balanceOf[_from] + balanceOf[_to];
54         // Subtract from the sender
55         balanceOf[_from] -= _value;
56         // Add the same to the recipient
57         balanceOf[_to] += _value;
58         Transfer(_from, _to, _value);
59         // Asserts are used to use static analysis to find bugs in your code. They should never fail
60         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
61     }
62 
63     /**
64     * Transfer tokens
65     * Send `_value` tokens to `_to` from your account
66     * @param _to The address of the recipient
67     * @param _value the amount to send
68     */
69     function transfer(address _to, uint256 _value) public {
70         _transfer(msg.sender, _to, _value);
71     }
72 
73     /**
74     * Transfer tokens from other address
75     * Send `_value` tokens to `_to` in behalf of `_from`
76     * @param _from The address of the sender
77     * @param _to The address of the recipient
78     * @param _value the amount to send
79     */
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
81         require(_value <= allowance[_from][msg.sender]);
82         // Check allowance
83         allowance[_from][msg.sender] -= _value;
84         _transfer(_from, _to, _value);
85         return true;
86     }
87 
88     /**
89     * Set allowance for other address
90     * Allows `_spender` to spend no more than `_value` tokens in your behalf
91     * @param _spender The address authorized to spend
92     * @param _value the max amount they can spend
93     */
94     function approve(address _spender, uint256 _value) public
95     returns (bool success) {
96         allowance[msg.sender][_spender] = _value;
97         return true;
98     }
99 
100     /**
101     * Set allowance for other address and notify
102     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
103     * @param _spender The address authorized to spend
104     * @param _value the max amount they can spend
105     * @param _extraData some extra information to send to the approved contract
106     */
107     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
108     public
109     returns (bool success) {
110         tokenRecipient spender = tokenRecipient(_spender);
111         if (approve(_spender, _value)) {
112             spender.receiveApproval(msg.sender, _value, this, _extraData);
113             return true;
114         }
115     }
116 
117     /**
118     * Destroy tokens
119     * Remove `_value` tokens from the system irreversibly
120     * @param _value the amount of money to burn
121     */
122     function burn(uint256 _value) public returns (bool success) {
123         require(balanceOf[msg.sender] >= _value);
124         // Check if the sender has enough
125         balanceOf[msg.sender] -= _value;
126         // Subtract from the sender
127         totalSupply -= _value;
128         // Updates totalSupply
129         Burn(msg.sender, _value);
130         return true;
131     }
132 
133     /**
134     * Destroy tokens from other account
135     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
136     * @param _from the address of the sender
137     * @param _value the amount of money to burn
138     */
139     function burnFrom(address _from, uint256 _value) public returns (bool success) {
140         require(balanceOf[_from] >= _value);
141         // Check if the targeted balance is enough
142         require(_value <= allowance[_from][msg.sender]);
143         // Check allowance
144         balanceOf[_from] -= _value;
145         // Subtract from the targeted balance
146         allowance[_from][msg.sender] -= _value;
147         // Subtract from the sender's allowance
148         totalSupply -= _value;
149         // Update totalSupply
150         Burn(_from, _value);
151         return true;
152     }
153 }