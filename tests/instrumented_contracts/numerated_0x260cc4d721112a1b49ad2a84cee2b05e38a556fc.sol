1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
5 }
6 
7 contract owned {
8     address public owner = msg.sender;
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract TokenERC20 is owned {
21     // Public variables of the token
22     string public name;
23     string public symbol;
24     uint8 public decimals = 18;
25     // 18 decimals is the strongly suggested default, avoid changing it
26     uint256 public totalSupply;
27 
28     // This creates an array with all balances
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     mapping (address => uint256[2][]) public frozens;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constructor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     function TokenERC20() public {
46         totalSupply = 100000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
47         balanceOf[owner] = totalSupply;                    // Give the creator all initial tokens
48         name = "91CT";                                           // Set the name for display purposes
49         symbol = "91CT";                                         // Set the symbol for display purposes
50     }
51 
52     function freeze(address _to, uint256 _value, uint256 _endtime) onlyOwner public returns (bool success) {
53         frozens[_to].push([_endtime, _value]);
54 
55         return true;
56     }
57 
58     function frozensTotal(address _to) public view  returns (uint256 amount) {
59         uint256 result;
60 
61         for(uint i = 0; i < frozens[_to].length; i++){
62           if (now <= frozens[_to][i][0]) {
63               result += frozens[_to][i][1];
64           }
65         }
66 
67         return result;
68     }
69 
70     function frozensDetail(address _to) public view returns (uint256[2][] details) {
71         return frozens[_to];
72     }
73 
74     function unfreeze(address _to) onlyOwner public returns (bool success) {
75         frozens[_to] = new uint[2][](0);
76 
77         return true;
78     }
79 
80     /**
81      * Internal transfer, only can be called by this contract
82      */
83     function _transfer(address _from, address _to, uint256 _value) internal {
84         // Prevent transfer to 0x0 address. Use burn() instead
85         require(_to != 0x0);
86         // Check if the sender has enough
87         require(balanceOf[_from] >= _value);
88         // Check for overflows
89         require(balanceOf[_to] + _value > balanceOf[_to]);
90         // Check frozen
91         if (frozens[_from].length > 0) {
92             uint256 frozenValue = 0;
93             for (uint i = 0; i < frozens[_from].length; i++) {
94                 if (now <= frozens[_from][i][0]) {
95                     frozenValue += frozens[_from][i][1];
96                 }
97             }
98 
99             require((balanceOf[_from] - frozenValue) >= _value);
100         }
101 
102         // Save this for an assertion in the future
103         uint previousBalances = balanceOf[_from] + balanceOf[_to];
104         // Subtract from the sender
105         balanceOf[_from] -= _value;
106         // Add the same to the recipient
107         balanceOf[_to] += _value;
108         emit Transfer(_from, _to, _value);
109         // Asserts are used to use static analysis to find bugs in your code. They should never fail
110         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
111     }
112 
113     /**
114      * Transfer tokens
115      *
116      * Send `_value` tokens to `_to` from your account
117      *
118      * @param _to The address of the recipient
119      * @param _value the amount to send
120      */
121     function transfer(address _to, uint256 _value) public {
122         _transfer(msg.sender, _to, _value);
123     }
124 
125     /**
126      * Transfer tokens from other address
127      *
128      * Send `_value` tokens to `_to` on behalf of `_from`
129      *
130      * @param _from The address of the sender
131      * @param _to The address of the recipient
132      * @param _value the amount to send
133      */
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
135         require(_value <= allowance[_from][msg.sender]);     // Check allowance
136         allowance[_from][msg.sender] -= _value;
137         _transfer(_from, _to, _value);
138         return true;
139     }
140 
141     /**
142      * Set allowance for other address
143      *
144      * Allows `_spender` to spend no more than `_value` tokens on your behalf
145      *
146      * @param _spender The address authorized to spend
147      * @param _value the max amount they can spend
148      */
149     function approve(address _spender, uint256 _value) public
150     returns (bool success) {
151         allowance[msg.sender][_spender] = _value;
152         return true;
153     }
154 
155     /**
156      * Set allowance for other address and notify
157      *
158      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
159      *
160      * @param _spender The address authorized to spend
161      * @param _value the max amount they can spend
162      * @param _extraData some extra information to send to the approved contract
163      */
164     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
165     public
166     returns (bool success) {
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
182         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
183         balanceOf[msg.sender] -= _value;            // Subtract from the sender
184         totalSupply -= _value;                      // Updates totalSupply
185         emit Burn(msg.sender, _value);
186         return true;
187     }
188 
189     /**
190      * Destroy tokens from other account
191      *
192      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
193      *
194      * @param _from the address of the sender
195      * @param _value the amount of money to burn
196      */
197     function burnFrom(address _from, uint256 _value) public returns (bool success) {
198         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
199         require(_value <= allowance[_from][msg.sender]);    // Check allowance
200         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
201         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
202         totalSupply -= _value;                              // Update totalSupply
203         emit Burn(_from, _value);
204         return true;
205     }
206 }