1 pragma solidity ^0.4.17;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract OysterPrePearl {
6     // Public variables of the token
7     string public name = "Oyster PrePearl";
8     string public symbol = "PREPRL";
9     uint8 public decimals = 18;
10     uint256 public totalSupply = 0;
11     uint256 public funds = 0;
12     address public owner;
13     address public partner;
14     bool public saleClosed = false;
15     bool public transferFreeze = false;
16 
17     // This creates an array with all balances
18     mapping (address => uint256) public balanceOf;
19     mapping (address => mapping (address => uint256)) public allowance;
20 
21     // This generates a public event on the blockchain that will notify clients
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     // This notifies clients about the amount burnt
25     event Burn(address indexed from, uint256 value);
26 
27     /**
28      * Constructor function
29      *
30      * Initializes contract
31      */
32     function OysterPrePearl() public {
33         owner = msg.sender;
34         partner = 0x0524Fe637b77A6F5f0b3a024f7fD9Fe1E688A291;
35     }
36     
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41     
42     modifier onlyAuth {
43         require(msg.sender == owner || msg.sender == partner);
44         _;
45     }
46     
47     function closeSale() public onlyOwner {
48         saleClosed = true;
49     }
50 
51     function openSale() public onlyOwner {
52         saleClosed = false;
53     }
54     
55     function freeze() public onlyOwner {
56         transferFreeze = true;
57     }
58     
59     function thaw() public onlyOwner {
60         transferFreeze = false;
61     }
62     
63     function () payable public {
64         require(!saleClosed);
65         require(msg.value >= 100 finney);
66         require(funds + msg.value <= 5000 ether);
67         uint buyPrice;
68         if (msg.value >= 50 ether) {
69             buyPrice = 8000;//60% bonus
70         }
71         else if (msg.value >= 5 ether) {
72             buyPrice = 7000;//40% bonus
73         }
74         else buyPrice = 6000;//20% bonus
75         uint256 amount;
76         amount = msg.value * buyPrice;                    // calculates the amount
77         totalSupply += amount;                            // increases the total supply 
78         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
79         funds += msg.value;                               // track eth amount raised
80         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
81     }
82     
83     function withdrawFunds() public onlyAuth {
84         uint256 payout = (this.balance/2) - 2;
85         owner.transfer(payout);
86         partner.transfer(payout);
87     }
88 
89     /**
90      * Internal transfer, only can be called by this contract
91      */
92     function _transfer(address _from, address _to, uint _value) internal {
93         require(!transferFreeze);
94         // Prevent transfer to 0x0 address. Use burn() instead
95         require(_to != 0x0);
96         // Check if the sender has enough
97         require(balanceOf[_from] >= _value);
98         // Check for overflows
99         require(balanceOf[_to] + _value > balanceOf[_to]);
100         // Save this for an assertion in the future
101         uint previousBalances = balanceOf[_from] + balanceOf[_to];
102         // Subtract from the sender
103         balanceOf[_from] -= _value;
104         // Add the same to the recipient
105         balanceOf[_to] += _value;
106         Transfer(_from, _to, _value);
107         // Asserts are used to use static analysis to find bugs in your code. They should never fail
108         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
109     }
110 
111     /**
112      * Transfer tokens
113      *
114      * Send `_value` tokens to `_to` from your account
115      *
116      * @param _to The address of the recipient
117      * @param _value the amount to send
118      */
119     function transfer(address _to, uint256 _value) public {
120         _transfer(msg.sender, _to, _value);
121     }
122 
123     /**
124      * Transfer tokens from other address
125      *
126      * Send `_value` tokens to `_to` in behalf of `_from`
127      *
128      * @param _from The address of the sender
129      * @param _to The address of the recipient
130      * @param _value the amount to send
131      */
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
133         require(_value <= allowance[_from][msg.sender]);     // Check allowance
134         allowance[_from][msg.sender] -= _value;
135         _transfer(_from, _to, _value);
136         return true;
137     }
138 
139     /**
140      * Set allowance for other address
141      *
142      * Allows `_spender` to spend no more than `_value` tokens in your behalf
143      *
144      * @param _spender The address authorized to spend
145      * @param _value the max amount they can spend
146      */
147     function approve(address _spender, uint256 _value) public
148         returns (bool success) {
149         allowance[msg.sender][_spender] = _value;
150         return true;
151     }
152 
153     /**
154      * Set allowance for other address and notify
155      *
156      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
157      *
158      * @param _spender The address authorized to spend
159      * @param _value the max amount they can spend
160      * @param _extraData some extra information to send to the approved contract
161      */
162     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
163         public
164         returns (bool success) {
165         tokenRecipient spender = tokenRecipient(_spender);
166         if (approve(_spender, _value)) {
167             spender.receiveApproval(msg.sender, _value, this, _extraData);
168             return true;
169         }
170     }
171 
172     /**
173      * Destroy tokens
174      *
175      * Remove `_value` tokens from the system irreversibly
176      *
177      * @param _value the amount of money to burn
178      */
179     function burn(uint256 _value) public returns (bool success) {
180         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
181         balanceOf[msg.sender] -= _value;            // Subtract from the sender
182         totalSupply -= _value;                      // Updates totalSupply
183         Burn(msg.sender, _value);
184         return true;
185     }
186 
187     /**
188      * Destroy tokens from other account
189      *
190      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
191      *
192      * @param _from the address of the sender
193      * @param _value the amount of money to burn
194      */
195     function burnFrom(address _from, uint256 _value) public returns (bool success) {
196         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
197         require(_value <= allowance[_from][msg.sender]);    // Check allowance
198         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
199         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
200         totalSupply -= _value;                              // Update totalSupply
201         Burn(_from, _value);
202         return true;
203     }
204 }