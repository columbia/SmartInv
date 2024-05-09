1 pragma solidity ^0.4.13;
2 contract owned {
3     address public owner;
4     mapping (address =>  bool) public admins;
5 
6     function owned() public {
7         owner = msg.sender;
8         admins[msg.sender]=true;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     modifier onlyAdmin   {
17         require(admins[msg.sender] == true);
18         _;
19     }
20 
21     function transferOwnership(address newOwner) onlyOwner public {
22         owner = newOwner;
23     }
24 
25     function makeAdmin(address newAdmin, bool isAdmin) onlyOwner public {
26         admins[newAdmin] = isAdmin;
27     }
28 }
29 
30 interface tokenRecipient {
31     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
32 }
33 
34 contract FaceTech is owned {
35     // Public variables of the token
36     string public name;
37     string public symbol;
38     uint8 public decimals;
39     uint256 public totalSupply;
40     bool public usersCanUnfreeze;
41 
42     mapping (address => bool) public admin;
43 
44     // This creates an array with all balances
45     mapping (address => uint256) public balanceOf;
46 
47     mapping (address => mapping (address => uint256)) public allowance;
48     mapping (address =>  bool) public frozen;
49 
50     // This generates a public event on the blockchain that will notify clients
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     // This notifies clients about the amount burnt
54     event Burn(address indexed from, uint256 value);
55 
56     // This generates a public event on the blockchain that will notify clients
57     event Frozen(address indexed addr, bool frozen);
58 
59     /**
60      * Constrctor function
61      *
62      * Initializes contract with initial supply tokens to the creator of the contract
63      */
64     function FaceTech() public {
65         uint256 initialSupply = 8500000000000000;
66         balanceOf[msg.sender] = initialSupply ;              // Give the creator all initial tokens
67         totalSupply = initialSupply;                        // Update total supply
68         name = "FaceTech";                                   // Set the name for display purposes
69         symbol = "FAT";                               // Set the symbol for display purposes
70         decimals = 8;                            // Amount of decimals for display purposes
71         usersCanUnfreeze=false;
72         admin[msg.sender]=true;
73     }
74 
75     function setAdmin(address addr, bool enabled) onlyOwner public {
76         admin[addr]=enabled;
77     }
78 
79 
80     function usersCanUnFreeze(bool can) onlyOwner public {
81         usersCanUnfreeze=can;
82     }
83 
84     /**
85      * transferAndFreeze
86      *
87      * Function to transfer to and freeze and account at the same time
88      */
89     function transferAndFreeze (address target,  uint256 amount )  onlyAdmin public {
90         _transfer(msg.sender, target, amount);
91         freeze(target, true);
92     }
93 
94     /**
95      * _freeze internal
96      *
97      * function to freeze an account
98      */
99     function _freeze (address target, bool froze )  internal {
100 
101         frozen[target]=froze;
102         Frozen(target, froze);
103     }
104 
105     /**
106      * freeze
107      *
108      * function to freeze an account
109      */
110     function freeze (address target, bool froze ) public   {
111         if(froze || (!froze && !usersCanUnfreeze)) {
112             require(admin[msg.sender]);
113         }
114         _freeze(target, froze);
115     }
116 
117     /**
118      * Internal transfer, only can be called by this contract
119      */
120     function _transfer(address _from, address _to, uint _value) internal {
121         require(_to != 0x0);                                   // Prevent transfer to 0x0 address. Use burn() instead
122         require(!frozen[_from]);                       //prevent transfer from frozen address
123         require(balanceOf[_from] >= _value);                // Check if the sender has enough
124         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
125         balanceOf[_from] -= _value;                         // Subtract from the sender
126         balanceOf[_to] += _value;                           // Add the same to the recipient
127         Transfer(_from, _to, _value);
128     }
129 
130     /**
131      * Transfer tokens
132      *
133      * Send `_value` tokens to `_to` from your account
134      *
135      * @param _to The address of the recipient
136      * @param _value the amount to send
137      */
138     function transfer(address _to, uint256 _value) public {
139         require(!frozen[msg.sender]);                       //prevent transfer from frozen address
140         _transfer(msg.sender, _to, _value);
141     }
142 
143 
144     /**
145      * Transfer tokens from other address
146      *
147      * Send `_value` tokens to `_to` in behalf of `_from`
148      *
149      * @param _from The address of the sender
150      * @param _to The address of the recipient
151      * @param _value the amount to send
152      */
153     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
154         require(!frozen[_from]);                       //prevent transfer from frozen address
155         require(_value <= allowance[_from][msg.sender]);     // Check allowance
156         allowance[_from][msg.sender] -= _value;
157         _transfer(_from, _to, _value);
158         return true;
159     }
160 
161     /**
162      * Transfer tokens to multiple address
163      *
164      * Send `_value` tokens to `addresses` from your account
165      *
166      * @param addresses The address list of the recipient
167      * @param _value the amount to send
168      */
169     function distributeToken(address[] addresses, uint256 _value) public {
170         require(!frozen[msg.sender]); 
171         for (uint i = 0; i < addresses.length; i++) {
172              _transfer(msg.sender, addresses[i], _value);
173         }
174     }
175 
176     /**
177      * Set allowance for other address
178      *
179      * Allows `_spender` to spend no more than `_value` tokens in your behalf
180      *
181      * @param _spender The address authorized to spend
182      * @param _value the max amount they can spend
183      */
184     function approve(address _spender, uint256 _value) public
185     returns (bool success) {
186         allowance[msg.sender][_spender] = _value;
187         return true;
188     }
189 
190     /**
191      * Set allowance for other address and notify
192      *
193      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
194      *
195      * @param _spender The address authorized to spend
196      * @param _value the max amount they can spend
197      * @param _extraData some extra information to send to the approved contract
198      */
199     function approveAndCall(address _spender, uint256 _value, bytes _extraData) onlyOwner public
200     returns (bool success) {
201         tokenRecipient spender = tokenRecipient(_spender);
202         if (approve(_spender, _value)) {
203             spender.receiveApproval(msg.sender, _value, this, _extraData);
204             return true;
205         }
206     }
207 
208     /**
209      * Destroy tokens
210      *
211      * Remove `_value` tokens from the system irreversibly
212      *
213      * @param _value the amount of money to burn
214      */
215     function burn(uint256 _value) onlyOwner public returns (bool success)  {
216         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
217         balanceOf[msg.sender] -= _value;            // Subtract from the sender
218         totalSupply -= _value;                      // Updates totalSupply
219         Burn(msg.sender, _value);
220         return true;
221     }
222 
223     /**
224      * Destroy tokens from other ccount
225      *
226      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
227      *
228      * @param _from the address of the sender
229      * @param _value the amount of money to burn
230      */
231     function burnFrom(address _from, uint256 _value) public  returns (bool success) {
232         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
233         require(_value <= allowance[_from][msg.sender]);    // Check allowance
234         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
235         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
236         totalSupply -= _value;                              // Update totalSupply
237         Burn(_from, _value);
238         return true;
239     }
240 }