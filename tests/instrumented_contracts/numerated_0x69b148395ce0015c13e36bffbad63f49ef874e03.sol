1 pragma solidity ^0.4.18;
2 
3 
4 contract ERC20 {
5 
6     uint256 public totalSupply;
7 
8     event Transfer(address indexed from, address indexed to, uint256 value);
9     event Approval(address indexed owner, address indexed spender, uint256 value);
10 
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13 
14     function allowance(address owner, address spender) public view returns (uint256);
15     function approve(address spender, uint256 value) public returns (bool);
16     function transferFrom(address from, address to, uint256 value) public returns (bool);
17 
18 }
19 
20 
21 interface TokenRecipient {
22     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
23 }
24 
25 
26 
27 contract TokenERC20 is ERC20 {
28     // Public variables of the token
29     string public name;
30     string public symbol;
31     uint8  public decimals = 18;
32     // 18 decimals is the strongly suggested default, avoid changing it
33 
34     // Balances
35     mapping (address => uint256) balances;
36     // Allowances
37     mapping (address => mapping (address => uint256)) allowances;
38 
39 
40     // ----- Events -----
41     event Burn(address indexed from, uint256 value);
42 
43 
44     /**
45      * Constructor function
46      */
47     function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
48         name = _tokenName;                                   // Set the name for display purposes
49         symbol = _tokenSymbol;                               // Set the symbol for display purposes
50         decimals = _decimals;
51 
52         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
53         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
54     }
55 
56     function balanceOf(address _owner) public view returns(uint256) {
57         return balances[_owner];
58     }
59 
60     function allowance(address _owner, address _spender) public view returns (uint256) {
61         return allowances[_owner][_spender];
62     }
63 
64     /**
65      * Internal transfer, only can be called by this contract
66      */
67     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
68         // Prevent transfer to 0x0 address. Use burn() instead
69         require(_to != 0x0);
70         // Check if the sender has enough
71         require(balances[_from] >= _value);
72         // Check for overflows
73         require(balances[_to] + _value > balances[_to]);
74         // Save this for an assertion in the future
75         uint previousBalances = balances[_from] + balances[_to];
76         // Subtract from the sender
77         balances[_from] -= _value;
78         // Add the same to the recipient
79         balances[_to] += _value;
80         Transfer(_from, _to, _value);
81         // Asserts are used to use static analysis to find bugs in your code. They should never fail
82         assert(balances[_from] + balances[_to] == previousBalances);
83 
84         return true;
85     }
86 
87     /**
88      * Transfer tokens
89      *
90      * Send `_value` tokens to `_to` from your account
91      *
92      * @param _to The address of the recipient
93      * @param _value the amount to send
94      */
95     function transfer(address _to, uint256 _value) public returns(bool) {
96         return _transfer(msg.sender, _to, _value);
97     }
98 
99     /**
100      * Transfer tokens from other address
101      *
102      * Send `_value` tokens to `_to` in behalf of `_from`
103      *
104      * @param _from The address of the sender
105      * @param _to The address of the recipient
106      * @param _value the amount to send
107      */
108     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
109         require(_value <= allowances[_from][msg.sender]);     // Check allowance
110         allowances[_from][msg.sender] -= _value;
111         return _transfer(_from, _to, _value);
112     }
113 
114     /**
115      * Set allowance for other address
116      *
117      * Allows `_spender` to spend no more than `_value` tokens in your behalf
118      *
119      * @param _spender The address authorized to spend
120      * @param _value the max amount they can spend
121      */
122     function approve(address _spender, uint256 _value) public returns(bool) {
123         allowances[msg.sender][_spender] = _value;
124         Approval(msg.sender, _spender, _value);
125         return true;
126     }
127 
128     /**
129      * Set allowance for other address and notify
130      *
131      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
132      *
133      * @param _spender The address authorized to spend
134      * @param _value the max amount they can spend
135      * @param _extraData some extra information to send to the approved contract
136      */
137     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
138         if (approve(_spender, _value)) {
139             TokenRecipient spender = TokenRecipient(_spender);
140             spender.receiveApproval(msg.sender, _value, this, _extraData);
141             return true;
142         }
143         return false;
144     }
145 
146     /**
147      * Destroy tokens
148      *
149      * Remove `_value` tokens from the system irreversibly
150      *
151      * @param _value the amount of money to burn
152      */
153     function burn(uint256 _value) public returns(bool) {
154         require(balances[msg.sender] >= _value);   // Check if the sender has enough
155         balances[msg.sender] -= _value;            // Subtract from the sender
156         totalSupply -= _value;                      // Updates totalSupply
157         Burn(msg.sender, _value);
158         return true;
159     }
160 
161     /**
162      * Destroy tokens from other account
163      *
164      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
165      *
166      * @param _from the address of the sender
167      * @param _value the amount of money to burn
168      */
169     function burnFrom(address _from, uint256 _value) public returns(bool) {
170         require(balances[_from] >= _value);                // Check if the targeted balance is enough
171         require(_value <= allowances[_from][msg.sender]);    // Check allowance
172         balances[_from] -= _value;                         // Subtract from the targeted balance
173         allowances[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
174         totalSupply -= _value;                              // Update totalSupply
175         Burn(_from, _value);
176         return true;
177     }
178 
179     /**
180      * approve should be called when allowances[_spender] == 0. To increment
181      * allowances value is better to use this function to avoid 2 calls (and wait until
182      * the first transaction is mined)
183      * From MonolithDAO Token.sol
184      */
185     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186         // Check for overflows
187         require(allowances[msg.sender][_spender] + _addedValue > allowances[msg.sender][_spender]);
188 
189         allowances[msg.sender][_spender] += _addedValue;
190         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
191         return true;
192     }
193 
194     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
195         uint oldValue = allowances[msg.sender][_spender];
196         if (_subtractedValue > oldValue) {
197             allowances[msg.sender][_spender] = 0;
198         } else {
199             allowances[msg.sender][_spender] = oldValue - _subtractedValue;
200         }
201         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
202         return true;
203     }
204 
205 
206 }
207 
208 
209 contract DataToken is TokenERC20 {
210 
211     function DataToken() TokenERC20(11500000000, "Data Token", "DTA", 18) public {
212 
213     }
214 }