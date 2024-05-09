1 pragma solidity ^0.4.11;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract owned {
6     address public owner;
7 
8     function owned() {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address _newOwner) onlyOwner {
18         owner = _newOwner;
19     }
20 }
21 
22 contract PopeCoin is owned {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals;
27     uint256 public totalSupply;
28 
29     // This creates an array with all balances
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     // This generates a public event on the blockchain that will notify clients
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     // This notifies clients about the amount burnt
37     event Burn(address indexed from, uint256 value);
38 
39     /**
40      * Constrctor function
41      *require
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     function PopeCoin(
45         uint256 initialSupply,
46         string tokenName,
47         uint8 decimalUnits,
48         string tokenSymbol,
49         address centralMinter
50     ) {
51         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
52         totalSupply = initialSupply;                        // Update total supply
53         name = tokenName;                                   // Set the name for display purposes
54         symbol = tokenSymbol;                               // Set the symbol for display purposes
55         decimals = decimalUnits;                            // Amount of decimals for display purposes
56         
57         if (centralMinter != 0x00) {
58             owner = centralMinter;
59         }
60     }
61 
62     /**
63      * Internal transfer, only can be called by this contract
64      */
65     function _transfer(address _from, address _to, uint _value) internal {
66         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
67         require(balanceOf[_from] >= _value);                // Check if the sender has enough
68         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
69         
70         balanceOf[_from] -= _value;                         // Subtract from the sender
71         balanceOf[_to] += _value;                           // Add the same to the recipient
72         
73         // Notify
74         Transfer(_from, _to, _value);
75     }
76 
77     /**
78      * Transfer tokens
79      *
80      * Send `_value` tokens to `_to` from your account
81      *
82      * @param _to The address of the recipient
83      * @param _value the amount to send
84      */
85     function transfer(address _to, uint256 _value) {
86         _transfer(msg.sender, _to, _value);
87     }
88 
89     /**
90      * Transfer tokens from other address
91      *
92      * Send `_value` tokens to `_to` in behalf of `_from`
93      *
94      * @param _from The address of the sender
95      * @param _to The address of the recipient
96      * @param _value the amount to send
97      */
98     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
99         require(_value <= allowance[_from][msg.sender]);     // Check allowance
100 
101         allowance[_from][msg.sender] -= _value;
102         _transfer(_from, _to, _value);
103         
104         return true;
105     }
106 
107     /**
108      * Set allowance for other address
109      *
110      * Allows `_spender` to spend no more than `_value` tokens in your behalf
111      *
112      * @param _spender The address authorized to spend
113      * @param _value the max amount they can spend
114      */
115     function approve(address _spender, uint256 _value)
116         returns (bool success) {
117         
118         allowance[msg.sender][_spender] = _value;
119         
120         return true;
121     }
122 
123     /**
124      * Set allowance for other address and notify
125      *
126      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      * @param _extraData some extra information to send to the approved contract
131      */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
133         returns (bool success) {
134         
135         tokenRecipient spender = tokenRecipient(_spender);
136         
137         if (approve(_spender, _value)) {
138             spender.receiveApproval(msg.sender, _value, this, _extraData);
139             return true;
140         }
141     }
142 
143     /**
144      * Destroy tokens
145      *
146      * Remove `_value` tokens from the system irreversibly
147      *
148      * @param _value the amount of money to burn
149      */
150     function burn(uint256 _value) returns (bool success) {
151         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
152         
153         balanceOf[msg.sender] -= _value;            // Subtract from the sender
154         totalSupply -= _value;                      // Updates totalSupply
155         
156         // Notify
157         Burn(msg.sender, _value);
158         
159         return true;
160     }
161 
162     /**
163      * Destroy tokens from other ccount
164      *
165      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
166      *
167      * @param _from the address of the sender
168      * @param _value the amount of money to burn
169      */
170     function burnFrom(address _from, uint256 _value) returns (bool success) {
171         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
172         require(_value <= allowance[_from][msg.sender]);    // Check allowance
173         
174         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
175         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
176         totalSupply -= _value;                              // Update totalSupply
177         
178         // Notify
179         Burn(_from, _value);
180         
181         return true;
182     }
183     
184     /**
185      * Creates more tokens
186      * 
187      * @param _to the address ofwho will get newly minted tokens
188      * @param _value the amount of money to create
189      */
190     function mintToken(address _to, uint256 _value) onlyOwner {
191         require(totalSupply + _value > totalSupply); // Check for overflows
192         
193         balanceOf[_to] += _value;
194         totalSupply += _value;
195         
196         // Notify 
197         Transfer(0, owner, _value);
198         
199         if (owner != _to) {
200             Transfer(owner, _to, _value);
201         }
202     }
203 }