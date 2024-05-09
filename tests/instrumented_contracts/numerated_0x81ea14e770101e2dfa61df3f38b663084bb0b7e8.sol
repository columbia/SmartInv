1 pragma solidity 0.4.25;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TokenATIC {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
13     mapping (address => bool) public blacklist;
14     address public admin;
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
27     event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
28 
29     /**
30      * Constructor function
31      *
32      * Initializes contract with initial supply tokens to the creator of the contract
33      */
34     constructor (
35         uint256 initialSupply,
36         string tokenName,
37         string tokenSymbol
38     ) public {
39         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
40         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
41         name = tokenName;                                   // Set the name for display purposes
42         symbol = tokenSymbol;                               // Set the symbol for display purposes
43         admin = msg.sender;
44     }
45 
46     /**
47      * Internal transfer, only can be called by this contract
48      */
49     function _transfer(address _from, address _to, uint _value) internal {
50         // Prevent transfer to 0x0 address. Use burn() instead
51         require(_to != 0x0);
52         // Check if the sender has enough
53         require(balanceOf[_from] >= _value);
54         // Check for overflows
55         require(balanceOf[_to] + _value > balanceOf[_to]);
56         // Save this for an assertion in the future
57         uint previousBalances = balanceOf[_from] + balanceOf[_to];
58         // Subtract from the sender
59         balanceOf[_from] -= _value;
60         // Add the same to the recipient
61         balanceOf[_to] += _value;
62         emit Transfer(_from, _to, _value);
63         // Asserts are used to use static analysis to find bugs in your code. They should never fail
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
65     }
66 
67     /**
68      * Transfer tokens
69      *
70      * Send `_value` tokens to `_to` from your account
71      *
72      * @param _to The address of the recipient
73      * @param _value the amount to send
74      */
75     function transfer(address _to, uint256 _value) public returns (bool success) {
76         require(!blacklist[msg.sender]);
77         _transfer(msg.sender, _to, _value);
78         return true;
79     }
80 
81     /**
82      * @dev Change control of the blacklist to a newAdmin.
83      * @param newAdmin The address to transfer admin to.
84      */
85     function changeAdmin(address newAdmin) public {
86         require(msg.sender == admin);
87         _changeAdmin(newAdmin);
88     }
89 
90     /**
91      * @dev internal function.
92      * @param newAdmin The address to transfer admin to.
93      */
94     function _changeAdmin(address newAdmin) internal {
95         require(newAdmin != address(0));
96         emit AdminChanged(admin, newAdmin); 
97         admin = newAdmin; 
98     }
99 
100     /**
101      * Ban address
102      * 
103      * @param addr ban addr
104      */
105     function ban(address addr) public {
106         require(msg.sender == admin);
107         blacklist[addr] = true;
108     }
109 
110     /**
111      * Enable address
112      * 
113      *  @param addr enable addr
114      */
115     function enable(address addr) public {
116         require(msg.sender == admin);
117         blacklist[addr] = false;
118     }
119 
120     /**
121      * Transfer tokens from other address
122      *
123      * Send `_value` tokens to `_to` on behalf of `_from`
124      *
125      * @param _from The address of the sender
126      * @param _to The address of the recipient
127      * @param _value the amount to send
128      */
129     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
130         require(!blacklist[msg.sender]);
131         require(!blacklist[_from]);
132         require(_value <= allowance[_from][msg.sender]);     // Check allowance
133         allowance[_from][msg.sender] -= _value;
134         _transfer(_from, _to, _value);
135         return true;
136     }
137 
138     /**
139      * Set allowance for other address
140      *
141      * Allows `_spender` to spend no more than `_value` tokens on your behalf
142      *
143      * @param _spender The address authorized to spend
144      * @param _value the max amount they can spend
145      */
146     function approve(address _spender, uint256 _value) public
147     returns (bool success) {
148         require(!blacklist[msg.sender]);
149         allowance[msg.sender][_spender] = _value;
150         emit Approval(msg.sender, _spender, _value); 
151         return true;
152     }
153 
154     /**
155      * Set allowance for other address and notify
156      *
157      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
158      *
159      * @param _spender The address authorized to spend
160      * @param _value the max amount they can spend
161      * @param _extraData some extra information to send to the approved contract
162      */
163     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
164     public
165     returns (bool success) {
166         require(!blacklist[msg.sender]);
167         tokenRecipient spender = tokenRecipient(_spender);
168         if (approve(_spender, _value)) {
169             spender.receiveApproval(msg.sender, _value, this, _extraData);
170             return true;
171         }
172     }
173 
174     /**
175      * Destroy tokens
176      *
177      * Remove `_value` tokens from the system irreversibly
178      *
179      * @param _value the amount of money to burn
180      */
181     function burn(uint256 _value) public returns (bool success) {
182         require(!blacklist[msg.sender]);
183         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
184         require(_value <= totalSupply);
185         balanceOf[msg.sender] -= _value;            // Subtract from the sender
186         totalSupply -= _value;                      // Updates totalSupply
187         emit Burn(msg.sender, _value);
188         return true;
189     }
190 
191     /**
192      * Destroy tokens from other account
193      *
194      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
195      *
196      * @param _from the address of the sender
197      * @param _value the amount of money to burn
198      */
199     function burnFrom(address _from, uint256 _value) public returns (bool success) {
200         require(!blacklist[msg.sender]);
201         require(!blacklist[_from]);
202         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
203         require(_value <= allowance[_from][msg.sender]);    // Check allowance
204         require(_value <= totalSupply);
205         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
206         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
207         totalSupply -= _value;                              // Update totalSupply
208         emit Burn(_from, _value);
209         return true;
210     }
211 }