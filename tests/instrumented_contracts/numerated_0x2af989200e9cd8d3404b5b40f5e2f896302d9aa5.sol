1 pragma solidity ^0.4.13;
2 
3 contract owned {
4     address public owner;
5     mapping (address =>  bool) public admins;
6 
7     function owned() public {
8         owner = msg.sender;
9         admins[msg.sender]=true;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     modifier onlyAdmin   {
18         require(admins[msg.sender] == true);
19         _;
20     }
21 
22     function transferOwnership(address newOwner) onlyOwner public {
23         owner = newOwner;
24     }
25 
26     function makeAdmin(address newAdmin, bool isAdmin) onlyOwner public {
27         admins[newAdmin] = isAdmin;
28     }
29 }
30 
31 interface tokenRecipient {
32     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
33 }
34 
35 contract EcoCrypto is owned {
36     // Public variables of the token
37     string public name;
38     string public symbol;
39     uint8 public decimals;
40     uint256 public totalSupply;
41     bool public usersCanUnfreeze;
42 
43     mapping (address => bool) public admin;
44 
45     // This creates an array with all balances
46     mapping (address => uint256) public balanceOf;
47 
48     mapping (address => mapping (address => uint256)) public allowance;
49     mapping (address =>  bool) public frozen;
50 
51     // This generates a public event on the blockchain that will notify clients
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54     // This notifies clients about the amount burnt
55     event Burn(address indexed from, uint256 value);
56 
57     // This generates a public event on the blockchain that will notify clients
58     event Frozen(address indexed addr, bool frozen);
59 
60     /**
61      * Constrctor function
62      *
63      * Initializes contract with initial supply tokens to the creator of the contract
64      */
65     function EcoCrypto() public {
66         uint256 initialSupply = 10000000000000000000;
67         balanceOf[msg.sender] = initialSupply ;              // Give the creator all initial tokens
68         totalSupply = initialSupply;                        // Update total supply
69         name = "EcoCrypto Token";                                   // Set the name for display purposes
70         symbol = "ECO";                               // Set the symbol for display purposes
71         decimals = 8;                            // Amount of decimals for display purposes
72         usersCanUnfreeze=false;
73         admin[msg.sender]=true;
74     }
75 
76     function setAdmin(address addr, bool enabled) onlyOwner public {
77         admin[addr]=enabled;
78     }
79 
80 
81     function usersCanUnFreeze(bool can) onlyOwner public {
82         usersCanUnfreeze=can;
83     }
84 
85     /**
86      * transferAndFreeze
87      *
88      * Function to transfer to and freeze and account at the same time
89      */
90     function transferAndFreeze (address target,  uint256 amount )  onlyAdmin public {
91         _transfer(msg.sender, target, amount);
92         freeze(target, true);
93     }
94 
95     /**
96      * _freeze internal
97      *
98      * function to freeze an account
99      */
100     function _freeze (address target, bool froze )  internal {
101 
102         frozen[target]=froze;
103         Frozen(target, froze);
104     }
105 
106     /**
107      * freeze
108      *
109      * function to freeze an account
110      */
111     function freeze (address target, bool froze ) public   {
112         if(froze || (!froze && !usersCanUnfreeze)) {
113             require(admin[msg.sender]);
114         }
115         _freeze(target, froze);
116     }
117 
118     /**
119      * Internal transfer, only can be called by this contract
120      */
121     function _transfer(address _from, address _to, uint _value) internal {
122         require(_to != 0x0);                                   // Prevent transfer to 0x0 address. Use burn() instead
123         require(!frozen[_from]);                       //prevent transfer from frozen address
124         require(balanceOf[_from] >= _value);                // Check if the sender has enough
125         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
126         balanceOf[_from] -= _value;                         // Subtract from the sender
127         balanceOf[_to] += _value;                           // Add the same to the recipient
128         Transfer(_from, _to, _value);
129     }
130 
131     /**
132      * Transfer tokens
133      *
134      * Send `_value` tokens to `_to` from your account
135      *
136      * @param _to The address of the recipient
137      * @param _value the amount to send
138      */
139     function transfer(address _to, uint256 _value) public {
140         require(!frozen[msg.sender]);                       //prevent transfer from frozen address
141         _transfer(msg.sender, _to, _value);
142     }
143 
144 
145     /**
146      * Transfer tokens from other address
147      *
148      * Send `_value` tokens to `_to` in behalf of `_from`
149      *
150      * @param _from The address of the sender
151      * @param _to The address of the recipient
152      * @param _value the amount to send
153      */
154     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
155         require(!frozen[_from]);                       //prevent transfer from frozen address
156         require(_value <= allowance[_from][msg.sender]);     // Check allowance
157         allowance[_from][msg.sender] -= _value;
158         _transfer(_from, _to, _value);
159         return true;
160     }
161 
162     /**
163      * Set allowance for other address
164      *
165      * Allows `_spender` to spend no more than `_value` tokens in your behalf
166      *
167      * @param _spender The address authorized to spend
168      * @param _value the max amount they can spend
169      */
170     function approve(address _spender, uint256 _value) public
171     returns (bool success) {
172         allowance[msg.sender][_spender] = _value;
173         return true;
174     }
175 
176     /**
177      * Set allowance for other address and notify
178      *
179      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
180      *
181      * @param _spender The address authorized to spend
182      * @param _value the max amount they can spend
183      * @param _extraData some extra information to send to the approved contract
184      */
185     function approveAndCall(address _spender, uint256 _value, bytes _extraData) onlyOwner public
186     returns (bool success) {
187         tokenRecipient spender = tokenRecipient(_spender);
188         if (approve(_spender, _value)) {
189             spender.receiveApproval(msg.sender, _value, this, _extraData);
190             return true;
191         }
192     }
193 
194     /**
195      * Destroy tokens
196      *
197      * Remove `_value` tokens from the system irreversibly
198      *
199      * @param _value the amount of money to burn
200      */
201     function burn(uint256 _value) onlyOwner public returns (bool success)  {
202         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
203         balanceOf[msg.sender] -= _value;            // Subtract from the sender
204         totalSupply -= _value;                      // Updates totalSupply
205         Burn(msg.sender, _value);
206         return true;
207     }
208 
209     /**
210      * Destroy tokens from other ccount
211      *
212      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
213      *
214      * @param _from the address of the sender
215      * @param _value the amount of money to burn
216      */
217     function burnFrom(address _from, uint256 _value) public  returns (bool success) {
218         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
219         require(_value <= allowance[_from][msg.sender]);    // Check allowance
220         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
221         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
222         totalSupply -= _value;                              // Update totalSupply
223         Burn(_from, _value);
224         return true;
225     }
226 }