1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5  contract owned {
6         address public owner;
7 
8         function owned() {
9             owner = msg.sender;
10         }
11 
12         modifier onlyOwner {
13             require(msg.sender == owner);
14             _;
15         }
16 
17         function transferOwnership(address newOwner) onlyOwner {
18             owner = newOwner;
19         }
20     }
21 
22 contract Robet is owned {
23     // Public variables of the token
24     string public name;
25     string public symbol; 
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33     mapping (address => bool) public frozenAccount;
34     
35 
36     // This generates a public event on the blockchain that will notify clients
37     event FrozenFunds(address target, bool frozen);
38 
39     // This generates a public event on the blockchain that will notify clients
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     
42     // This generates a public event on the blockchain that will notify clients
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 
45     // This notifies clients about the amount burnt
46     event Burn(address indexed from, uint256 value);
47 
48     /**
49      * Constructor function
50      *
51      * Initializes contract with initial supply tokens to the creator of the contract
52      */
53     function Robet(
54         uint256 initialSupply,
55         string tokenName,
56         string tokenSymbol
57     ) public {
58         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
59         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
60         name = tokenName;                                   // Set the name for display purposes
61         symbol = tokenSymbol;                               // Set the symbol for display purposes
62     }
63 
64     /**
65      * Internal transfer, only can be called by this contract
66      */
67     function _transfer(address _from, address _to, uint _value) internal {
68         // Prevent transfer to 0x0 address. Use burn() instead
69         require(_to != 0x0);
70         // Check if the sender has enough
71         require(balanceOf[_from] >= _value);
72         // Check for overflows
73         require(balanceOf[_to] + _value >= balanceOf[_to]);
74         // Check if sender is frozen
75         require(!frozenAccount[_from]); 
76         // Check if recipient is frozen                   
77         require(!frozenAccount[_to]);                       
78         // Save this for an assertion in the future
79         uint previousBalances = balanceOf[_from] + balanceOf[_to];
80         // Subtract from the sender
81         balanceOf[_from] -= _value;
82         // Add the same to the recipient
83         balanceOf[_to] += _value;
84         // Notify anyone listening that this transfer took place
85         emit Transfer(msg.sender, _to, _value);
86         // Asserts are used to use static analysis to find bugs in your code. They should never fail
87         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
98     function transfer(address _to, uint256 _value) public returns (bool success) {
99         _transfer(msg.sender, _to, _value);
100         return true;
101     }
102 
103     /**
104      * Transfer tokens from other address
105      *
106      * Send `_value` tokens to `_to` on behalf of `_from`
107      *
108      * @param _from The address of the sender
109      * @param _to The address of the recipient
110      * @param _value the amount to send
111      */
112     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
113         require(_value <= allowance[_from][msg.sender]);     // Check allowance
114         allowance[_from][msg.sender] -= _value;
115         _transfer(_from, _to, _value);
116         return true;
117     }
118 
119     /**
120      * Set allowance for other address
121      *
122      * Allows `_spender` to spend no more than `_value` tokens on your behalf
123      *
124      * @param _spender The address authorized to spend
125      * @param _value the max amount they can spend
126      */
127     function approve(address _spender, uint256 _value) public
128         returns (bool success) {
129         allowance[msg.sender][_spender] = _value;
130         emit Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134     /**
135      * Set allowance for other address and notify
136      *
137      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
138      *
139      * @param _spender The address authorized to spend
140      * @param _value the max amount they can spend
141      * @param _extraData some extra information to send to the approved contract
142      */
143     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
144         public
145         returns (bool success) {
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
161         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
162         balanceOf[msg.sender] -= _value;            // Subtract from the sender
163         totalSupply -= _value;                      // Updates totalSupply
164         emit Burn(msg.sender, _value);
165         return true;
166     }
167 
168     /**
169      * Freeze tokens
170      *
171      * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
172      * 
173      * @param target Address to be frozen
174      * @param freeze either to freeze it or not
175      */
176     function freezeAccount(address target, bool freeze) onlyOwner public {
177         frozenAccount[target] = freeze;
178         emit FrozenFunds(target, freeze);
179     }
180 
181     /**
182      * Destroy tokens from other account
183      *
184      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
185      *
186      * @param _from the address of the sender
187      * @param _value the amount of money to burn
188      */
189     function burnFrom(address _from, uint256 _value) public returns (bool success) {
190         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
191         require(_value <= allowance[_from][msg.sender]);    // Check allowance
192         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
193         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
194         totalSupply -= _value;                              // Update totalSupply
195         emit Burn(_from, _value);
196         return true;
197     }
198 }