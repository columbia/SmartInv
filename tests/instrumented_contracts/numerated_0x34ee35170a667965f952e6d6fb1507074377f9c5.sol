1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint32 _value, address _token, bytes _extraData) public; }
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
17     // 實現所有權轉移
18     function transferOwnership(address newOwner) onlyOwner {
19         owner = newOwner;
20     }
21 }    
22     contract x32323 is owned {
23         function x32323(
24             uint32 initialSupply,
25             string tokenName,
26             uint8 decimalUnits,
27             string tokenSymbol,
28             address centralMinter
29         ) {
30         if(centralMinter != 0 ) owner = centralMinter;
31         }
32         
33         // Public variables of the token
34         string public name;
35         string public symbol;
36         uint8 public decimals = 0;
37         // 18 decimals is the strongly suggested default, avoid changing it
38         uint32 public totalSupply;
39 
40         // This creates an array with all balances
41         mapping (address => uint256) public balanceOf;
42         mapping (address => mapping (address => uint256)) public allowance;
43 
44         // This generates a public event on the blockchain that will notify clients
45         event Transfer(address indexed from, address indexed to, uint32 value);
46 
47         // This notifies clients about the amount burnt
48         event Burn(address indexed from, uint32 value);
49 
50 
51 
52             /**
53            * Constructor function
54             *
55             * Initializes contract with initial supply tokens to the creator of the contract
56             */
57         function TokenERC20(
58             uint32 initialSupply,
59             string tokenName,
60             string tokenSymbol
61         ) public {
62             totalSupply =  23000000 ;  // Update total supply with the decimal amount
63             balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
64             name = "測試";                                   // Set the name for display purposes
65             symbol = "測試";                               // Set the symbol for display purposes
66         }
67 
68         /**
69         * Internal transfer, only can be called by this contract
70         */
71     
72         mapping (address => bool) public frozenAccount;
73         event FrozenFunds(address target, bool frozen);
74 
75         function freezeAccount(address target, bool freeze) onlyOwner {
76             frozenAccount[target] = freeze;
77             FrozenFunds(target, freeze);
78         }
79     
80         function _transfer(address _from, address _to, uint32 _value) internal {
81             // Prevent transfer to 0x0 address. Use burn() instead
82             require(_to != 0x0);
83             // Check if the sender has enough
84             require(balanceOf[_from] >= _value);
85             // Check for overflows
86             require(balanceOf[_to] + _value > balanceOf[_to]);
87             // Save this for an assertion in the future
88             uint previousBalances = balanceOf[_from] + balanceOf[_to];
89             // Subtract from the sender
90             balanceOf[_from] -= _value;
91             // Add the same to the recipient
92             balanceOf[_to] += _value;
93             Transfer(_from, _to , _value);
94             // Asserts are used to use static analysis to find bugs in your code. They should never fail
95             assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
96         }
97 
98         /**
99         * Transfer tokens
100         *
101         * Send `_value` tokens to `_to` from your account
102         *
103         * @param _to The address of the recipient
104         * @param _value the amount to send
105         */
106         function transfer(address _to, uint32 _value) public {
107             require(!frozenAccount[msg.sender]);
108             _transfer(msg.sender, _to, _value);
109         }
110 
111         /**
112         * Transfer tokens from other address
113         *
114         * Send `_value` tokens to `_to` on behalf of `_from`
115         *
116         * @param _from The address of the sender
117         * @param _to The address of the recipient
118         * @param _value the amount to send
119         */
120         function transferFrom(address _from, address _to, uint32 _value) public returns (bool success) {
121             require(_value <= allowance[_from][msg.sender]);     // Check allowance
122             allowance[_from][msg.sender] -= _value;
123             _transfer(_from, _to, _value);
124             return true;
125         }
126 
127         /**
128         * Set allowance for other address
129         *
130         * Allows `_spender` to spend no more than `_value` tokens on your behalf
131         *
132         * @param _spender The address authorized to spend
133         * @param _value the max amount they can spend
134         */
135         function approve(address _spender, uint32 _value) public
136             returns (bool success) {
137             allowance[msg.sender][_spender] = _value;
138             return true;
139         }
140 
141         /**
142         * Set allowance for other address and notify
143         *
144         * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
145         *
146         * @param _spender The address authorized to spend
147         * @param _value the max amount they can spend
148         * @param _extraData some extra information to send to the approved contract
149         */
150         function approveAndCall(address _spender, uint32 _value, bytes _extraData)
151         public
152         returns (bool success) {
153         tokenRecipient spender = tokenRecipient(_spender);
154         if (approve(_spender, _value)) {
155             spender.receiveApproval(msg.sender, _value, this, _extraData);
156             return true;
157             }
158         }
159 
160          /**
161         * Destroy tokens
162         *
163         * Remove `_value` tokens from the system irreversibly
164         *
165         * @param _value the amount of money to burn
166         */
167         function burn(uint32 _value) public returns (bool success) {
168             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
169             balanceOf[msg.sender] -= _value;            // Subtract from the sender
170             totalSupply -= _value;                      // Updates totalSupply
171             Burn(msg.sender,  _value);
172             return true;
173         }
174 
175         /**
176         * Destroy tokens from other account
177         *
178         * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
179         *
180         * @param _from the address of the sender
181         * @param _value the amount of money to burn
182         */
183         function burnFrom(address _from, uint32 _value) public returns (bool success) {
184             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
185             require(_value <= allowance[_from][msg.sender]);    // Check allowance
186             balanceOf[_from] -= _value;                         // Subtract from the targeted balance
187             allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
188             totalSupply -= _value;                              // Update totalSupply
189             Burn(_from,  _value);
190             return true;
191         }
192     }