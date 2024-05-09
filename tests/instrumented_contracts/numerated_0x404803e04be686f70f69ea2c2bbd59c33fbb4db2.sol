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
13     bool public saleClosed = false;
14     bool public transferFreeze = false;
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
33     }
34     
35     modifier onlyOwner {
36         require(msg.sender == owner);
37         _;
38     }
39     
40     function closeSale() public onlyOwner {
41         saleClosed = true;
42     }
43 
44     function openSale() public onlyOwner {
45         saleClosed = false;
46     }
47     
48     function freeze() public onlyOwner {
49         transferFreeze = true;
50     }
51     
52     function thaw() public onlyOwner {
53         transferFreeze = false;
54     }
55     
56     function () payable public {
57         require(!saleClosed);
58         require(msg.value >= 100 finney);
59         require(funds + msg.value <= 200 ether);
60         uint buyPrice;
61         if (msg.value >= 50 ether) {
62             buyPrice = 8000;//60% bonus
63         }
64         else if (msg.value >= 5 ether) {
65             buyPrice = 7000;//40% bonus
66         }
67         else buyPrice = 6000;//20% bonus
68         uint256 amount;
69         amount = msg.value * buyPrice;                    // calculates the amount
70         totalSupply += amount;                            // increases the total supply 
71         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
72         funds += msg.value;                               // track eth amount raised
73         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
74     }
75     
76     function withdrawFunds() public onlyOwner {
77         owner.transfer(this.balance);
78     }
79 
80     /**
81      * Internal transfer, only can be called by this contract
82      */
83     function _transfer(address _from, address _to, uint _value) internal {
84         require(!transferFreeze);
85         // Prevent transfer to 0x0 address. Use burn() instead
86         require(_to != 0x0);
87         // Check if the sender has enough
88         require(balanceOf[_from] >= _value);
89         // Check for overflows
90         require(balanceOf[_to] + _value > balanceOf[_to]);
91         // Save this for an assertion in the future
92         uint previousBalances = balanceOf[_from] + balanceOf[_to];
93         // Subtract from the sender
94         balanceOf[_from] -= _value;
95         // Add the same to the recipient
96         balanceOf[_to] += _value;
97         Transfer(_from, _to, _value);
98         // Asserts are used to use static analysis to find bugs in your code. They should never fail
99         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
100     }
101 
102     /**
103      * Transfer tokens
104      *
105      * Send `_value` tokens to `_to` from your account
106      *
107      * @param _to The address of the recipient
108      * @param _value the amount to send
109      */
110     function transfer(address _to, uint256 _value) public {
111         _transfer(msg.sender, _to, _value);
112     }
113 
114     /**
115      * Transfer tokens from other address
116      *
117      * Send `_value` tokens to `_to` in behalf of `_from`
118      *
119      * @param _from The address of the sender
120      * @param _to The address of the recipient
121      * @param _value the amount to send
122      */
123     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
124         require(_value <= allowance[_from][msg.sender]);     // Check allowance
125         allowance[_from][msg.sender] -= _value;
126         _transfer(_from, _to, _value);
127         return true;
128     }
129 
130     /**
131      * Set allowance for other address
132      *
133      * Allows `_spender` to spend no more than `_value` tokens in your behalf
134      *
135      * @param _spender The address authorized to spend
136      * @param _value the max amount they can spend
137      */
138     function approve(address _spender, uint256 _value) public
139         returns (bool success) {
140         allowance[msg.sender][_spender] = _value;
141         return true;
142     }
143 
144     /**
145      * Set allowance for other address and notify
146      *
147      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
148      *
149      * @param _spender The address authorized to spend
150      * @param _value the max amount they can spend
151      * @param _extraData some extra information to send to the approved contract
152      */
153     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
154         public
155         returns (bool success) {
156         tokenRecipient spender = tokenRecipient(_spender);
157         if (approve(_spender, _value)) {
158             spender.receiveApproval(msg.sender, _value, this, _extraData);
159             return true;
160         }
161     }
162 
163     /**
164      * Destroy tokens
165      *
166      * Remove `_value` tokens from the system irreversibly
167      *
168      * @param _value the amount of money to burn
169      */
170     function burn(uint256 _value) public returns (bool success) {
171         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
172         balanceOf[msg.sender] -= _value;            // Subtract from the sender
173         totalSupply -= _value;                      // Updates totalSupply
174         Burn(msg.sender, _value);
175         return true;
176     }
177 
178     /**
179      * Destroy tokens from other account
180      *
181      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
182      *
183      * @param _from the address of the sender
184      * @param _value the amount of money to burn
185      */
186     function burnFrom(address _from, uint256 _value) public returns (bool success) {
187         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
188         require(_value <= allowance[_from][msg.sender]);    // Check allowance
189         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
190         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
191         totalSupply -= _value;                              // Update totalSupply
192         Burn(_from, _value);
193         return true;
194     }
195 }