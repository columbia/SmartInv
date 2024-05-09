1 /**
2  *Submitted for verification at Etherscan.io on 2019-03-27
3 */
4 
5 pragma solidity ^0.4.16;
6 
7 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
8 
9 contract TokenATIC {
10     // Public variables of the token
11     string public name;
12     string public symbol;
13     uint8 public decimals = 18;
14     // 18 decimals is the strongly suggested default, avoid changing it
15     uint256 public totalSupply;
16 
17     mapping (address => bool) public blacklist;
18     address admin;
19 
20     // This creates an array with all balances
21     mapping (address => uint256) public balanceOf;
22     mapping (address => mapping (address => uint256)) public allowance;
23 
24     // This generates a public event on the blockchain that will notify clients
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     // This notifies clients about the amount burnt
28     event Burn(address indexed from, uint256 value);
29 
30     /**
31      * Constructor function
32      *
33      * Initializes contract with initial supply tokens to the creator of the contract
34      */
35     function TokenATIC(
36         uint256 initialSupply,
37         string tokenName,
38         string tokenSymbol
39     ) public {
40         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
41         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
42         name = tokenName;                                   // Set the name for display purposes
43         symbol = tokenSymbol;                               // Set the symbol for display purposes
44         admin = msg.sender;
45     }
46 
47     /**
48      * Internal transfer, only can be called by this contract
49      */
50     function _transfer(address _from, address _to, uint _value) internal {
51         // Prevent transfer to 0x0 address. Use burn() instead
52         require(_to != 0x0);
53         // Check if the sender has enough
54         require(balanceOf[_from] >= _value);
55         // Check for overflows
56         require(balanceOf[_to] + _value > balanceOf[_to]);
57         // Save this for an assertion in the future
58         uint previousBalances = balanceOf[_from] + balanceOf[_to];
59         // Subtract from the sender
60         balanceOf[_from] -= _value;
61         // Add the same to the recipient
62         balanceOf[_to] += _value;
63         Transfer(_from, _to, _value);
64         // Asserts are used to use static analysis to find bugs in your code. They should never fail
65         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
66     }
67 
68     /**
69      * Transfer tokens
70      *
71      * Send `_value` tokens to `_to` from your account
72      *
73      * @param _to The address of the recipient
74      * @param _value the amount to send
75      */
76     function transfer(address _to, uint256 _value) public {
77         require(!blacklist[msg.sender]);
78         _transfer(msg.sender, _to, _value);
79     }
80 
81     /**
82      * Ban address
83      * 
84      * @param addr ban addr
85      */
86     function ban(address addr) public {
87         require(msg.sender == admin);
88         blacklist[addr] = true;
89     }
90 
91     /**
92      * Enable address
93      * 
94      *  @param addr enable addr
95      */
96     function enable(address addr) public {
97         require(msg.sender == admin);
98         blacklist[addr] = false;
99     }
100 
101     /**
102      * Transfer tokens from other address
103      *
104      * Send `_value` tokens to `_to` on behalf of `_from`
105      *
106      * @param _from The address of the sender
107      * @param _to The address of the recipient
108      * @param _value the amount to send
109      */
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
111         require(!blacklist[msg.sender]);
112         require(_value <= allowance[_from][msg.sender]);     // Check allowance
113         allowance[_from][msg.sender] -= _value;
114         _transfer(_from, _to, _value);
115         return true;
116     }
117 
118     /**
119      * Set allowance for other address
120      *
121      * Allows `_spender` to spend no more than `_value` tokens on your behalf
122      *
123      * @param _spender The address authorized to spend
124      * @param _value the max amount they can spend
125      */
126     function approve(address _spender, uint256 _value) public
127     returns (bool success) {
128         require(!blacklist[msg.sender]);
129         allowance[msg.sender][_spender] = _value;
130         return true;
131     }
132 
133     /**
134      * Set allowance for other address and notify
135      *
136      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
137      *
138      * @param _spender The address authorized to spend
139      * @param _value the max amount they can spend
140      * @param _extraData some extra information to send to the approved contract
141      */
142     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
143     public
144     returns (bool success) {
145         require(!blacklist[msg.sender]);
146         tokenRecipient spender = tokenRecipient(_spender);
147         if (approve(_spender, _value)) {
148             spender.receiveApproval(msg.sender, _value, this, _extraData);
149             return true;
150         }
151     }
152 
153     /**
154      * Destroy tokens
155      *
156      * Remove `_value` tokens from the system irreversibly
157      *
158      * @param _value the amount of money to burn
159      */
160     function burn(uint256 _value) public returns (bool success) {
161         require(!blacklist[msg.sender]);
162         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
163         balanceOf[msg.sender] -= _value;            // Subtract from the sender
164         totalSupply -= _value;                      // Updates totalSupply
165         Burn(msg.sender, _value);
166         return true;
167     }
168 
169     /**
170      * Destroy tokens from other account
171      *
172      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
173      *
174      * @param _from the address of the sender
175      * @param _value the amount of money to burn
176      */
177     function burnFrom(address _from, uint256 _value) public returns (bool success) {
178         require(!blacklist[msg.sender]);
179         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
180         require(_value <= allowance[_from][msg.sender]);    // Check allowance
181         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
182         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
183         totalSupply -= _value;                              // Update totalSupply
184         Burn(_from, _value);
185         return true;
186     }
187 }