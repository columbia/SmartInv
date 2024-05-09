1 pragma solidity 0.4.25;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract Tokenran {
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
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 
24     // This notifies clients about the amount burnt
25     event Burn(address indexed from, uint256 value);
26 
27     /**
28      * Constructor function
29      *
30      * Initializes contract with initial supply tokens to the creator of the contract
31      */
32     constructor (
33         uint256 initialSupply,
34         string tokenName,
35         string tokenSymbol
36     ) public {
37         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
38         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
39         name = tokenName;                                   // Set the name for display purposes
40         symbol = tokenSymbol;                               // Set the symbol for display purposes
41         admin = msg.sender;
42     }
43 
44     /**
45      * Internal transfer, only can be called by this contract
46      */
47     function _transfer(address _from, address _to, uint _value) internal {
48         // Prevent transfer to 0x0 address. Use burn() instead
49         require(_to != 0x0);
50         // Check if the sender has enough
51         require(balanceOf[_from] >= _value);
52         // Check for overflows
53         require(balanceOf[_to] + _value > balanceOf[_to]);
54         // Save this for an assertion in the future
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];
56         // Subtract from the sender
57         balanceOf[_from] -= _value;
58         // Add the same to the recipient
59         balanceOf[_to] += _value;
60         emit Transfer(_from, _to, _value);
61         // Asserts are used to use static analysis to find bugs in your code. They should never fail
62         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
63     }
64 
65     /**
66      * Transfer tokens
67      *
68      * Send `_value` tokens to `_to` from your account
69      *
70      * @param _to The address of the recipient
71      * @param _value the amount to send
72      */
73     function transfer(address _to, uint256 _value) public returns (bool success) {
74         require(!blacklist[msg.sender]);
75         _transfer(msg.sender, _to, _value);
76         return true;
77     }
78 
79     /**
80      * Ban address
81      * 
82      * @param addr ban addr
83      */
84     function ban(address addr) public {
85         require(msg.sender == admin);
86         blacklist[addr] = true;
87     }
88 
89     /**
90      * Enable address
91      * 
92      *  @param addr enable addr
93      */
94     function enable(address addr) public {
95         require(msg.sender == admin);
96         blacklist[addr] = false;
97     }
98 
99     /**
100      * Transfer tokens from other address
101      *
102      * Send `_value` tokens to `_to` on behalf of `_from`
103      *
104      * @param _from The address of the sender
105      * @param _to The address of the recipient
106      * @param _value the amount to send
107      */
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
109         require(!blacklist[msg.sender]);
110         require(!blacklist[_from]);
111         require(_value <= allowance[_from][msg.sender]);     // Check allowance
112         allowance[_from][msg.sender] -= _value;
113         _transfer(_from, _to, _value);
114         return true;
115     }
116 
117     /**
118      * Set allowance for other address
119      *
120      * Allows `_spender` to spend no more than `_value` tokens on your behalf
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      */
125     function approve(address _spender, uint256 _value) public
126     returns (bool success) {
127         require(!blacklist[msg.sender]);
128         allowance[msg.sender][_spender] = _value;
129         emit Approval(msg.sender, _spender, _value); 
130         return true;
131     }
132 
133     /**
134      * Set allowance for other address and notify
135      *
136      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
137      *
138      * @param _spender The address authorized to spend
139      * @param _value the max amount they can spend
140      * @param _extraData some extra information to send to the approved contract
141      */
142     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
143     public
144     returns (bool success) {
145         require(!blacklist[msg.sender]);
146         tokenRecipient spender = tokenRecipient(_spender);
147         if (approve(_spender, _value)) {
148             spender.receiveApproval(msg.sender, _value, this, _extraData);
149             return true;
150         }
151     }
152 
153     /**
154      * Destroy tokens
155      *
156      * Remove `_value` tokens from the system irreversibly
157      *
158      * @param _value the amount of money to burn
159      */
160     function burn(uint256 _value) public returns (bool success) {
161         require(!blacklist[msg.sender]);
162         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
163         require(_value <= totalSupply);
164         balanceOf[msg.sender] -= _value;            // Subtract from the sender
165         totalSupply -= _value;                      // Updates totalSupply
166         emit Burn(msg.sender, _value);
167         return true;
168     }
169 
170     /**
171      * Destroy tokens from other account
172      *
173      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
174      *
175      * @param _from the address of the sender
176      * @param _value the amount of money to burn
177      */
178     function burnFrom(address _from, uint256 _value) public returns (bool success) {
179         require(!blacklist[msg.sender]);
180         require(!blacklist[_from]);
181         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
182         require(_value <= allowance[_from][msg.sender]);    // Check allowance
183         require(_value <= totalSupply);
184         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
185         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
186         totalSupply -= _value;                              // Update totalSupply
187         emit Burn(_from, _value);
188         return true;
189     }
190 }