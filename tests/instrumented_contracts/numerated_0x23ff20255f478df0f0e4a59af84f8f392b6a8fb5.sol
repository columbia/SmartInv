1 pragma solidity ^0.4.16;
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
13     bool public saleClosed = false;
14 
15     // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     // This generates a public event on the blockchain that will notify clients
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     // This notifies clients about the amount burnt
23     event Burn(address indexed from, uint256 value);
24 
25     /**
26      * Constructor function
27      *
28      * Initializes contract
29      */
30     function OysterPrePearl() public {
31         owner = msg.sender;
32     }
33     
34     modifier onlyOwner {
35         require(msg.sender == owner);
36         _;
37     }
38     
39     function closeSale() onlyOwner {
40         saleClosed = true;
41     }
42 
43     function openSale() onlyOwner {
44         saleClosed = false;
45     }
46     
47     function () payable {
48         require(!saleClosed);
49         require(msg.value >= 1 ether);
50         require(funds + msg.value <= 3500 ether);
51         uint buyPrice;
52         if (msg.value >= 200 ether) {
53             buyPrice = 32500;//550% bonus
54         }
55         else if (msg.value >= 100 ether) {
56             buyPrice = 17500;//250% bonus
57         }
58         else if (msg.value >= 50 ether) {
59             buyPrice = 12500;//150% bonus
60         }
61         else buyPrice = 10000;//100% bonus
62         uint amount;
63         amount = msg.value * buyPrice;                    // calculates the amount
64         totalSupply += amount;                            // increases the total supply 
65         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
66         funds += msg.value;                               // track eth amount raised
67         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
68     }
69     
70     function withdrawFunds() onlyOwner {
71         owner.transfer(this.balance);
72     }
73 
74     /**
75      * Internal transfer, only can be called by this contract
76      */
77     function _transfer(address _from, address _to, uint _value) internal {
78         // Prevent transfer to 0x0 address. Use burn() instead
79         require(_to != 0x0);
80         // Check if the sender has enough
81         require(balanceOf[_from] >= _value);
82         // Check for overflows
83         require(balanceOf[_to] + _value > balanceOf[_to]);
84         // Save this for an assertion in the future
85         uint previousBalances = balanceOf[_from] + balanceOf[_to];
86         // Subtract from the sender
87         balanceOf[_from] -= _value;
88         // Add the same to the recipient
89         balanceOf[_to] += _value;
90         Transfer(_from, _to, _value);
91         // Asserts are used to use static analysis to find bugs in your code. They should never fail
92         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
93     }
94 
95     /**
96      * Transfer tokens
97      *
98      * Send `_value` tokens to `_to` from your account
99      *
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transfer(address _to, uint256 _value) public {
104         _transfer(msg.sender, _to, _value);
105     }
106 
107     /**
108      * Transfer tokens from other address
109      *
110      * Send `_value` tokens to `_to` in behalf of `_from`
111      *
112      * @param _from The address of the sender
113      * @param _to The address of the recipient
114      * @param _value the amount to send
115      */
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
117         require(_value <= allowance[_from][msg.sender]);     // Check allowance
118         allowance[_from][msg.sender] -= _value;
119         _transfer(_from, _to, _value);
120         return true;
121     }
122 
123     /**
124      * Set allowance for other address
125      *
126      * Allows `_spender` to spend no more than `_value` tokens in your behalf
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      */
131     function approve(address _spender, uint256 _value) public
132         returns (bool success) {
133         allowance[msg.sender][_spender] = _value;
134         return true;
135     }
136 
137     /**
138      * Set allowance for other address and notify
139      *
140      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
141      *
142      * @param _spender The address authorized to spend
143      * @param _value the max amount they can spend
144      * @param _extraData some extra information to send to the approved contract
145      */
146     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
147         public
148         returns (bool success) {
149         tokenRecipient spender = tokenRecipient(_spender);
150         if (approve(_spender, _value)) {
151             spender.receiveApproval(msg.sender, _value, this, _extraData);
152             return true;
153         }
154     }
155 
156     /**
157      * Destroy tokens
158      *
159      * Remove `_value` tokens from the system irreversibly
160      *
161      * @param _value the amount of money to burn
162      */
163     function burn(uint256 _value) public returns (bool success) {
164         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
165         balanceOf[msg.sender] -= _value;            // Subtract from the sender
166         totalSupply -= _value;                      // Updates totalSupply
167         Burn(msg.sender, _value);
168         return true;
169     }
170 
171     /**
172      * Destroy tokens from other account
173      *
174      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
175      *
176      * @param _from the address of the sender
177      * @param _value the amount of money to burn
178      */
179     function burnFrom(address _from, uint256 _value) public returns (bool success) {
180         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
181         require(_value <= allowance[_from][msg.sender]);    // Check allowance
182         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
183         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
184         totalSupply -= _value;                              // Update totalSupply
185         Burn(_from, _value);
186         return true;
187     }
188 }