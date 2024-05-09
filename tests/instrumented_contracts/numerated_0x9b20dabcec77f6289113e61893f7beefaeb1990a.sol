1 pragma solidity ^0.4.16;
2 
3 pragma solidity ^0.4.16;
4 
5 pragma solidity ^0.4.16;
6 
7 
8 contract ERC20 {
9 
10     uint256 public totalSupply;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 
15     function balanceOf(address who) public view returns (uint256);
16     function transfer(address to, uint256 value) public returns (bool);
17 
18     function allowance(address owner, address spender) public view returns (uint256);
19     function approve(address spender, uint256 value) public returns (bool);
20     function transferFrom(address from, address to, uint256 value) public returns (bool);
21 
22 }
23 
24 
25 interface TokenRecipient {
26     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
27 }
28 
29 
30 
31 contract TokenERC20 is ERC20 {
32     // Public variables of the token
33     string public name;
34     string public symbol;
35     uint8  public decimals = 18;
36     // 18 decimals is the strongly suggested default, avoid changing it
37 
38     // Balances
39     mapping (address => uint256) balances;
40     // Allowances
41     mapping (address => mapping (address => uint256)) allowances;
42 
43 
44     // ----- Events -----
45     event Burn(address indexed from, uint256 value);
46 
47 
48     /**
49      * Constructor function
50      */
51     function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
52         name = _tokenName;                                   // Set the name for display purposes
53         symbol = _tokenSymbol;                               // Set the symbol for display purposes
54         decimals = _decimals;
55 
56         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
57         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
58     }
59 
60     function balanceOf(address _owner) public view returns(uint256) {
61         return balances[_owner];
62     }
63 
64     function allowance(address _owner, address _spender) public view returns (uint256) {
65         return allowances[_owner][_spender];
66     }
67 
68     /**
69      * Internal transfer, only can be called by this contract
70      */
71     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
72         // Prevent transfer to 0x0 address. Use burn() instead
73         require(_to != 0x0);
74         // Check if the sender has enough
75         require(balances[_from] >= _value);
76         // Check for overflows
77         require(balances[_to] + _value > balances[_to]);
78         // Save this for an assertion in the future
79         uint previousBalances = balances[_from] + balances[_to];
80         // Subtract from the sender
81         balances[_from] -= _value;
82         // Add the same to the recipient
83         balances[_to] += _value;
84         Transfer(_from, _to, _value);
85         // Asserts are used to use static analysis to find bugs in your code. They should never fail
86         assert(balances[_from] + balances[_to] == previousBalances);
87 
88         return true;
89     }
90 
91     /**
92      * Transfer tokens
93      *
94      * Send `_value` tokens to `_to` from your account
95      *
96      * @param _to The address of the recipient
97      * @param _value the amount to send
98      */
99     function transfer(address _to, uint256 _value) public returns(bool) {
100         return _transfer(msg.sender, _to, _value);
101     }
102 
103     /**
104      * Transfer tokens from other address
105      *
106      * Send `_value` tokens to `_to` in behalf of `_from`
107      *
108      * @param _from The address of the sender
109      * @param _to The address of the recipient
110      * @param _value the amount to send
111      */
112     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
113         require(_value <= allowances[_from][msg.sender]);     // Check allowance
114         allowances[_from][msg.sender] -= _value;
115         return _transfer(_from, _to, _value);
116     }
117 
118     /**
119      * Set allowance for other address
120      *
121      * Allows `_spender` to spend no more than `_value` tokens in your behalf
122      *
123      * @param _spender The address authorized to spend
124      * @param _value the max amount they can spend
125      */
126     function approve(address _spender, uint256 _value) public returns(bool) {
127         allowances[msg.sender][_spender] = _value;
128         Approval(msg.sender, _spender, _value);
129         return true;
130     }
131 
132     /**
133      * Set allowance for other address and notify
134      *
135      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
136      *
137      * @param _spender The address authorized to spend
138      * @param _value the max amount they can spend
139      * @param _extraData some extra information to send to the approved contract
140      */
141     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
142         if (approve(_spender, _value)) {
143             TokenRecipient spender = TokenRecipient(_spender);
144             spender.receiveApproval(msg.sender, _value, this, _extraData);
145             return true;
146         }
147         return false;
148     }
149 
150     /**
151      * Destroy tokens
152      *
153      * Remove `_value` tokens from the system irreversibly
154      *
155      * @param _value the amount of money to burn
156      */
157     function burn(uint256 _value) public returns(bool) {
158         require(balances[msg.sender] >= _value);   // Check if the sender has enough
159         balances[msg.sender] -= _value;            // Subtract from the sender
160         totalSupply -= _value;                      // Updates totalSupply
161         Burn(msg.sender, _value);
162         return true;
163     }
164 
165     /**
166      * Destroy tokens from other account
167      *
168      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
169      *
170      * @param _from the address of the sender
171      * @param _value the amount of money to burn
172      */
173     function burnFrom(address _from, uint256 _value) public returns(bool) {
174         require(balances[_from] >= _value);                // Check if the targeted balance is enough
175         require(_value <= allowances[_from][msg.sender]);    // Check allowance
176         balances[_from] -= _value;                         // Subtract from the targeted balance
177         allowances[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
178         totalSupply -= _value;                              // Update totalSupply
179         Burn(_from, _value);
180         return true;
181     }
182 
183     /**
184      * approve should be called when allowances[_spender] == 0. To increment
185      * allowances value is better to use this function to avoid 2 calls (and wait until
186      * the first transaction is mined)
187      * From MonolithDAO Token.sol
188      */
189     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
190         // Check for overflows
191         require(allowances[msg.sender][_spender] + _addedValue > allowances[msg.sender][_spender]);
192 
193         allowances[msg.sender][_spender] += _addedValue;
194         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
195         return true;
196     }
197 
198     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199         uint oldValue = allowances[msg.sender][_spender];
200         if (_subtractedValue > oldValue) {
201             allowances[msg.sender][_spender] = 0;
202         } else {
203             allowances[msg.sender][_spender] = oldValue - _subtractedValue;
204         }
205         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
206         return true;
207     }
208 
209 
210 }
211 
212 
213 contract FairToken is TokenERC20 {
214 
215     function FairToken() TokenERC20(1200000000, "Fair Token", "FAIR", 18) public {
216 
217     }
218 }