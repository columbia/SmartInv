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
13     address public partner;
14     bool public saleClosed = false;
15 
16     // This creates an array with all balances
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     // This generates a public event on the blockchain that will notify clients
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     // This notifies clients about the amount burnt
24     event Burn(address indexed from, uint256 value);
25 
26     /**
27      * Constructor function
28      *
29      * Initializes contract
30      */
31     function OysterPrePearl() public {
32         owner = msg.sender;
33         partner = 0x997c48CE1AF0CE2658D3E4c0bea30a0eB9c98382;
34     }
35     
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40     
41     modifier onlyAuth {
42         require(msg.sender == owner || msg.sender == partner);
43         _;
44     }
45     
46     function closeSale() onlyOwner {
47         saleClosed = true;
48     }
49 
50     function openSale() onlyOwner {
51         saleClosed = false;
52     }
53     
54     function () payable {
55         require(!saleClosed);
56         require(msg.value >= 1 ether);
57         require(funds + msg.value <= 2500 ether);
58         uint buyPrice;
59         if (msg.value >= 200 ether) {
60             buyPrice = 32500;//550% bonus
61         }
62         else if (msg.value >= 100 ether) {
63             buyPrice = 17500;//250% bonus
64         }
65         else if (msg.value >= 50 ether) {
66             buyPrice = 12500;//150% bonus
67         }
68         else buyPrice = 10000;//100% bonus
69         uint amount;
70         amount = msg.value * buyPrice;                    // calculates the amount
71         totalSupply += amount;                            // increases the total supply 
72         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
73         funds += msg.value;                               // track eth amount raised
74         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
75     }
76     
77     function withdrawFunds() onlyAuth {
78         uint256 payout = (this.balance/2) - 2;
79         owner.transfer(payout);
80         partner.transfer(payout);
81     }
82 
83     /**
84      * Internal transfer, only can be called by this contract
85      */
86     function _transfer(address _from, address _to, uint _value) internal {
87         // Prevent transfer to 0x0 address. Use burn() instead
88         require(_to != 0x0);
89         // Check if the sender has enough
90         require(balanceOf[_from] >= _value);
91         // Check for overflows
92         require(balanceOf[_to] + _value > balanceOf[_to]);
93         // Save this for an assertion in the future
94         uint previousBalances = balanceOf[_from] + balanceOf[_to];
95         // Subtract from the sender
96         balanceOf[_from] -= _value;
97         // Add the same to the recipient
98         balanceOf[_to] += _value;
99         Transfer(_from, _to, _value);
100         // Asserts are used to use static analysis to find bugs in your code. They should never fail
101         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
102     }
103 
104     /**
105      * Transfer tokens
106      *
107      * Send `_value` tokens to `_to` from your account
108      *
109      * @param _to The address of the recipient
110      * @param _value the amount to send
111      */
112     function transfer(address _to, uint256 _value) public {
113         _transfer(msg.sender, _to, _value);
114     }
115 
116     /**
117      * Transfer tokens from other address
118      *
119      * Send `_value` tokens to `_to` in behalf of `_from`
120      *
121      * @param _from The address of the sender
122      * @param _to The address of the recipient
123      * @param _value the amount to send
124      */
125     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
126         require(_value <= allowance[_from][msg.sender]);     // Check allowance
127         allowance[_from][msg.sender] -= _value;
128         _transfer(_from, _to, _value);
129         return true;
130     }
131 
132     /**
133      * Set allowance for other address
134      *
135      * Allows `_spender` to spend no more than `_value` tokens in your behalf
136      *
137      * @param _spender The address authorized to spend
138      * @param _value the max amount they can spend
139      */
140     function approve(address _spender, uint256 _value) public
141         returns (bool success) {
142         allowance[msg.sender][_spender] = _value;
143         return true;
144     }
145 
146     /**
147      * Set allowance for other address and notify
148      *
149      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
150      *
151      * @param _spender The address authorized to spend
152      * @param _value the max amount they can spend
153      * @param _extraData some extra information to send to the approved contract
154      */
155     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
156         public
157         returns (bool success) {
158         tokenRecipient spender = tokenRecipient(_spender);
159         if (approve(_spender, _value)) {
160             spender.receiveApproval(msg.sender, _value, this, _extraData);
161             return true;
162         }
163     }
164 
165     /**
166      * Destroy tokens
167      *
168      * Remove `_value` tokens from the system irreversibly
169      *
170      * @param _value the amount of money to burn
171      */
172     function burn(uint256 _value) public returns (bool success) {
173         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
174         balanceOf[msg.sender] -= _value;            // Subtract from the sender
175         totalSupply -= _value;                      // Updates totalSupply
176         Burn(msg.sender, _value);
177         return true;
178     }
179 
180     /**
181      * Destroy tokens from other account
182      *
183      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
184      *
185      * @param _from the address of the sender
186      * @param _value the amount of money to burn
187      */
188     function burnFrom(address _from, uint256 _value) public returns (bool success) {
189         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
190         require(_value <= allowance[_from][msg.sender]);    // Check allowance
191         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
192         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
193         totalSupply -= _value;                              // Update totalSupply
194         Burn(_from, _value);
195         return true;
196     }
197 }