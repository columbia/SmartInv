1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenREXC {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
13     mapping (address => bool) public blacklist;
14     address admin;
15 
16     // This creates an array with all balances
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     // This generates a public event on the blockchain that will notify clients
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     // This notifies clients about the amount burnt
24     event Burn(address indexed from, uint256 value);
25 
26     /**
27      * Constructor function
28      *
29      * Initializes contract with initial supply tokens to the creator of the contract
30      */
31     function TokenREXC(
32         uint256 initialSupply,
33         string tokenName,
34         string tokenSymbol
35     ) public {
36         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
37         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
38         name = tokenName;                                   // Set the name for display purposes
39         symbol = tokenSymbol;                               // Set the symbol for display purposes
40         admin = msg.sender;
41     }
42 
43     /**
44      * Internal transfer, only can be called by this contract
45      */
46     function _transfer(address _from, address _to, uint _value) internal {
47         // Prevent transfer to 0x0 address. Use burn() instead
48         require(_to != 0x0);
49         // Check if the sender has enough
50         require(balanceOf[_from] >= _value);
51         // Check for overflows
52         require(balanceOf[_to] + _value > balanceOf[_to]);
53         // Save this for an assertion in the future
54         uint previousBalances = balanceOf[_from] + balanceOf[_to];
55         // Subtract from the sender
56         balanceOf[_from] -= _value;
57         // Add the same to the recipient
58         balanceOf[_to] += _value;
59         Transfer(_from, _to, _value);
60         // Asserts are used to use static analysis to find bugs in your code. They should never fail
61         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
62     }
63 
64     /**
65      * Transfer tokens
66      *
67      * Send `_value` tokens to `_to` from your account
68      *
69      * @param _to The address of the recipient
70      * @param _value the amount to send
71      */
72     function transfer(address _to, uint256 _value) public {
73         require(!blacklist[msg.sender]);
74         _transfer(msg.sender, _to, _value);
75     }
76 
77     /**
78      * Ban address
79      * 
80      * @param addr ban addr
81      */
82     function ban(address addr) public {
83         require(msg.sender == admin);
84         blacklist[addr] = true;
85     }
86 
87     /**
88      * Enable address
89      * 
90      *  @param addr enable addr
91      */
92     function enable(address addr) public {
93         require(msg.sender == admin);
94         blacklist[addr] = false;
95     }
96 
97     /**
98      * Transfer tokens from other address
99      *
100      * Send `_value` tokens to `_to` on behalf of `_from`
101      *
102      * @param _from The address of the sender
103      * @param _to The address of the recipient
104      * @param _value the amount to send
105      */
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
107         require(!blacklist[msg.sender]);
108         require(_value <= allowance[_from][msg.sender]);     // Check allowance
109         allowance[_from][msg.sender] -= _value;
110         _transfer(_from, _to, _value);
111         return true;
112     }
113 
114     /**
115      * Set allowance for other address
116      *
117      * Allows `_spender` to spend no more than `_value` tokens on your behalf
118      *
119      * @param _spender The address authorized to spend
120      * @param _value the max amount they can spend
121      */
122     function approve(address _spender, uint256 _value) public
123     returns (bool success) {
124         require(!blacklist[msg.sender]);
125         allowance[msg.sender][_spender] = _value;
126         return true;
127     }
128 
129     /**
130      * Set allowance for other address and notify
131      *
132      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
133      *
134      * @param _spender The address authorized to spend
135      * @param _value the max amount they can spend
136      * @param _extraData some extra information to send to the approved contract
137      */
138     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
139     public
140     returns (bool success) {
141         require(!blacklist[msg.sender]);
142         tokenRecipient spender = tokenRecipient(_spender);
143         if (approve(_spender, _value)) {
144             spender.receiveApproval(msg.sender, _value, this, _extraData);
145             return true;
146         }
147     }
148 
149     /**
150      * Destroy tokens
151      *
152      * Remove `_value` tokens from the system irreversibly
153      *
154      * @param _value the amount of money to burn
155      */
156     function burn(uint256 _value) public returns (bool success) {
157         require(!blacklist[msg.sender]);
158         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
159         balanceOf[msg.sender] -= _value;            // Subtract from the sender
160         totalSupply -= _value;                      // Updates totalSupply
161         Burn(msg.sender, _value);
162         return true;
163     }
164 
165     /**
166      * Destroy tokens from other account
167      *
168      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
169      *
170      * @param _from the address of the sender
171      * @param _value the amount of money to burn
172      */
173     function burnFrom(address _from, uint256 _value) public returns (bool success) {
174         require(!blacklist[msg.sender]);
175         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
176         require(_value <= allowance[_from][msg.sender]);    // Check allowance
177         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
178         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
179         totalSupply -= _value;                              // Update totalSupply
180         Burn(_from, _value);
181         return true;
182     }
183 }