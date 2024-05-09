1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract YMtestCoin{
6     // Public variables of the token
7     string constant public name = "YMtest";
8     string constant public symbol = "YM";
9     
10     uint8 public decimals = 18;
11     // 18 decimals is the strongly suggested default, avoid changing it
12     uint256 public totalSupply;
13     address public owner;
14 
15     // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17     mapping (address => uint256) public freezeOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     // This generates a public event on the blockchain that will notify clients
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     
23     // This generates a public event on the blockchain that will notify clients
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 
26     // This notifies clients about the amount burnt
27     event Burn(address indexed from, uint256 value);
28 
29 
30     /* This notifies clients about the amount frozen */
31     event Freeze(address indexed from, uint256 value);
32 
33     /* This notifies clients about the amount unfrozen */
34     event Unfreeze(address indexed from, uint256 value);
35 
36     /**
37      * Constructor function
38      *
39      * Initializes contract with initial supply tokens to the creator of the contract
40      */
41     constructor(uint256 initialSupply) public {
42         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
43         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
44         owner = msg.sender;		// Set the symbol for display purposes
45     }
46 
47     /**
48      * Internal transfer, only can be called by this contract
49      */
50     function _transfer(address _from, address _to, uint _value) internal {
51         // Prevent transfer to 0x0 address. Use burn() instead
52         require(_to != 0x0);
53         // Check if the sender has enough
54         require(balanceOf[_from] >= _value);
55         // Check for overflows
56         require(balanceOf[_to] + _value >= balanceOf[_to]);
57         // Save this for an assertion in the future
58         uint previousBalances = balanceOf[_from] + balanceOf[_to];
59         // Subtract from the sender
60         balanceOf[_from] -= _value;
61         // Add the same to the recipient
62         balanceOf[_to] += _value;
63         emit Transfer(_from, _to, _value);
64         // Asserts are used to use static analysis to find bugs in your code. They should never fail
65         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
66     }
67 
68     /**
69      * Transfer tokens
70      *
71      * Send `_value` tokens to `_to` from your account
72      *
73      * @param _to The address of the recipient
74      * @param _value the amount to send
75      */
76     function transfer(address _to, uint256 _value) public returns (bool success) {
77         _transfer(msg.sender, _to, _value);
78         return true;
79     }
80 
81     /**
82      * Transfer tokens from other address
83      *
84      * Send `_value` tokens to `_to` on behalf of `_from`
85      *
86      * @param _from The address of the sender
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         require(_value <= allowance[_from][msg.sender]);     // Check allowance
92         allowance[_from][msg.sender] -= _value;
93         _transfer(_from, _to, _value);
94         return true;
95     }
96 
97     /**
98      * Set allowance for other address
99      *
100      * Allows `_spender` to spend no more than `_value` tokens on your behalf
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
111 
112     /**
113      * Set allowance for other address and notify
114      *
115      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
116      *
117      * @param _spender The address authorized to spend
118      * @param _value the max amount they can spend
119      * @param _extraData some extra information to send to the approved contract
120      */
121     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
122         public
123         returns (bool success) {
124         tokenRecipient spender = tokenRecipient(_spender);
125         if (approve(_spender, _value)) {
126             spender.receiveApproval(msg.sender, _value, this, _extraData);
127             return true;
128         }
129     }
130 
131     /**
132      * Destroy tokens
133      *
134      * Remove `_value` tokens from the system irreversibly
135      *
136      * @param _value the amount of money to burn
137      */
138     function burn(uint256 _value) public returns (bool success) {
139         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
140         balanceOf[msg.sender] -= _value;            // Subtract from the sender
141         totalSupply -= _value;                      // Updates totalSupply
142         emit Burn(msg.sender, _value);
143         return true;
144     }
145 
146     /**
147      * Destroy tokens from other account
148      *
149      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
150      *
151      * @param _from the address of the sender
152      * @param _value the amount of money to burn
153      */
154     function burnFrom(address _from, uint256 _value) public returns (bool success) {
155         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
156         require(_value <= allowance[_from][msg.sender]);    // Check allowance
157         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
158         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
159         totalSupply -= _value;                              // Update totalSupply
160         emit Burn(_from, _value);
161         return true;
162     }
163 
164     function freeze(uint256 _value) public returns (bool success) {
165         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
166         require(freezeOf[msg.sender] + _value > freezeOf[msg.sender]);
167         require(_value > 0); 
168         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
169         freezeOf[msg.sender] += _value;                                // Updates totalSupply
170         emit Freeze(msg.sender, _value);
171         return true;
172     }
173 
174     function unfreeze(uint256 _value) public returns (bool success) {
175         require(freezeOf[msg.sender] >= _value);            // Check if the sender has enough
176         require(balanceOf[msg.sender] + _value > balanceOf[msg.sender]);
177         require(_value > 0); 
178         freezeOf[msg.sender] -= _value;                      // Subtract from the sender
179         balanceOf[msg.sender] += _value;
180         emit Unfreeze(msg.sender, _value);
181         return true;
182     }
183     
184     // transfer balance to owner
185     function withdrawEther(uint256 amount) public {
186         require(msg.sender == owner);
187         owner.transfer(amount);
188     }
189 }