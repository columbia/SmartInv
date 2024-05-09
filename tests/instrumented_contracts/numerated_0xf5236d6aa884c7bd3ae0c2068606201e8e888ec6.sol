1 pragma solidity 0.4.21;
2 
3     contract owned {
4         address public owner;
5 
6         function owned()public {
7             owner = msg.sender;
8         }
9 
10         modifier onlyOwner {
11             require(msg.sender == owner);
12             _;
13         }
14 
15         function transferOwnership(address newOwner) public onlyOwner {
16             owner = newOwner;
17         }
18     }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract Instacocoa is owned {
23     // Public variables of the token
24      
25    
26     string public name;
27     string public symbol;
28   
29    
30     uint8 public decimals = 18;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply;
33 
34     // This creates an array with all balances
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37     mapping (address => bool) public frozenAccount;
38     event FrozenFunds(address target, bool frozen);
39     
40     
41     
42   
43     
44    
45     
46     function freezeAccount(address target, bool freeze) public onlyOwner {
47         frozenAccount[target] = freeze;
48         emit FrozenFunds(target, freeze);
49     }
50 
51     // This generates a public event on the blockchain that will notify clients
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54     // This notifies clients about the amount burnt
55     event Burn(address indexed from, uint256 value);
56 
57     /**
58      * Constructor function
59      *
60      * Initializes contract with initial supply tokens to the creator of the contract
61      */
62     function Instacocoa(
63         uint256 initialSupply,
64         string tokenName,
65         string tokenSymbol,
66         address centralMinter
67         
68     ) public {
69         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
70         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
71         name = tokenName;                                   // Set the name for display purposes
72         symbol = tokenSymbol;                               // Set the symbol for display purposes
73         if(centralMinter != 0 ) owner = centralMinter;
74     }
75 
76     /**
77      * Internal transfer, only can be called by this contract
78      */
79     function _transfer(address _from, address _to, uint _value) internal {
80         // Prevent transfer to 0x0 address. Use burn() instead
81         require(_to != 0x0);
82         // Check if the sender has enough
83         require(balanceOf[_from] >= _value);
84         // Check for overflows
85         require(balanceOf[_to] + _value >= balanceOf[_to]);
86         // Save this for an assertion in the future
87         uint previousBalances = balanceOf[_from] + balanceOf[_to];
88         // Subtract from the sender
89         balanceOf[_from] -= _value;
90         // Add the same to the recipient
91         balanceOf[_to] += _value;
92         emit Transfer(_from, _to, _value);
93         // Asserts are used to use static analysis to find bugs in your code. They should never fail
94         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
95     }
96 
97     /**
98      * Transfer tokens
99      *
100      * Send `_value` tokens to `_to` from your account
101      *
102      * @param _to The address of the recipient
103      * @param _value the amount to send
104      */
105     
106     function transfer(address _to, uint256 _value) public {
107          require(!frozenAccount[msg.sender]);
108         _transfer(msg.sender, _to, _value);
109        
110        
111     }
112     /**
113      * Transfer tokens from other address
114      *
115      * Send `_value` tokens to `_to` on behalf of `_from`
116      *
117      * @param _from The address of the sender
118      * @param _to The address of the recipient
119      * @param _value the amount to send
120      */
121     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
122         require(_value <= allowance[_from][msg.sender]);     // Check allowance
123         allowance[_from][msg.sender] -= _value;
124         _transfer(_from, _to, _value);
125         return true;
126     }
127 
128 
129 /**
130 Function to allow creation of new coins
131 */
132     function mintToken(address target, uint256 mintedAmount)public onlyOwner {
133         balanceOf[target] += mintedAmount;
134         totalSupply += mintedAmount;
135        emit Transfer(0, owner, mintedAmount);
136        emit Transfer(owner, target, mintedAmount);
137     }
138     /**
139      * Set allowance for other address
140      *
141      * Allows `_spender` to spend no more than `_value` tokens on your behalf
142      *
143      * @param _spender The address authorized to spend
144      * @param _value the max amount they can spend
145      */
146     function approve(address _spender, uint256 _value) public
147         returns (bool success) {
148         allowance[msg.sender][_spender] = _value;
149         return true;
150     }
151 
152     /**
153      * Set allowance for other address and notify
154      *
155      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
156      *
157      * @param _spender The address authorized to spend
158      * @param _value the max amount they can spend
159      * @param _extraData some extra information to send to the approved contract
160      */
161     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
162         public
163         returns (bool success) {
164         tokenRecipient spender = tokenRecipient(_spender);
165         if (approve(_spender, _value)) {
166             spender.receiveApproval(msg.sender, _value, this, _extraData);
167             return true;
168         }
169     }
170 
171     /**
172      * Destroy tokens
173      *
174      * Remove `_value` tokens from the system irreversibly
175      *
176      * @param _value the amount of money to burn
177      */
178     function burn(uint256 _value) public returns (bool success) {
179         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
180         balanceOf[msg.sender] -= _value;            // Subtract from the sender
181         totalSupply -= _value;                      // Updates totalSupply
182         emit Burn(msg.sender, _value);
183         return true;
184     }
185 
186     /**
187      * Destroy tokens from other account
188      *
189      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
190      *
191      * @param _from the address of the sender
192      * @param _value the amount of money to burn
193      */
194     function burnFrom(address _from, uint256 _value) public returns (bool success) {
195         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
196         require(_value <= allowance[_from][msg.sender]);    // Check allowance
197         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
198         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
199         totalSupply -= _value;                              // Update totalSupply
200         emit Burn(_from, _value);
201         return true;
202     }
203     
204  
205     
206  
207 }