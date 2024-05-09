1 pragma solidity ^0.4.18;
2 
3 
4 // -----------------------------------------------------------------------
5 // An ERC20 standard
6 contract ERC20 {
7     // the total token supply
8     uint256 public totalSupply;
9 
10     function balanceOf(address _owner) public constant returns (uint256 balance);
11     function transfer(address _to, uint256 _value) public returns (bool success);
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13     function approve(address _spender, uint256 _value) public returns (bool success);
14     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 
20 interface TokenRecipient {
21     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
22 }
23 
24 
25 contract TourismEcologyChainBase is ERC20 {
26     // Public variables of the token
27     string public name;
28     string public symbol;
29     uint8  public decimals = 18;
30     // 18 decimals is the strongly suggested default, avoid changing it
31 
32     // Balances
33     mapping (address => uint256) balances;
34     // Allowances
35     mapping (address => mapping (address => uint256)) allowances;
36 
37 
38     // ----- Events -----
39     event Burn(address indexed from, uint256 value);
40 
41     /**
42      * Constructor function
43      */
44     function TourismEcologyChainBase(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
45         name = _tokenName;                                   // Set the name for display purposes
46         symbol = _tokenSymbol;                               // Set the symbol for display purposes
47         decimals = _decimals;
48 
49         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
50         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
51     }
52 
53     function balanceOf(address _owner) public view returns(uint256) {
54         return balances[_owner];
55     }
56 
57     function allowance(address _owner, address _spender) public view returns (uint256) {
58         return allowances[_owner][_spender];
59     }
60 
61     /**
62      * Internal transfer, only can be called by this contract
63      */
64     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
65         // Prevent transfer to 0x0 address. Use burn() instead
66         require(_to != 0x0);
67         // Check if the sender has enough
68         require(balances[_from] >= _value);
69         // Check for overflows
70         require(balances[_to] + _value > balances[_to]);
71         // Save this for an assertion in the future
72         uint previousBalances = balances[_from] + balances[_to];
73         // Subtract from the sender
74         balances[_from] -= _value;
75         // Add the same to the recipient
76         balances[_to] += _value;
77         Transfer(_from, _to, _value);
78         // Asserts are used to use static analysis to find bugs in your code. They should never fail
79         assert(balances[_from] + balances[_to] == previousBalances);
80 
81         return true;
82     }
83 
84     /**
85      * Transfer tokens
86      *
87      * Send `_value` tokens to `_to` from your account
88      *
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transfer(address _to, uint256 _value) public returns(bool) {
93         return _transfer(msg.sender, _to, _value);
94     }
95 
96     /**
97      * Transfer tokens from other address
98      *
99      * Send `_value` tokens to `_to` in behalf of `_from`
100      *
101      * @param _from The address of the sender
102      * @param _to The address of the recipient
103      * @param _value the amount to send
104      */
105     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
106         require(_value <= allowances[_from][msg.sender]);     // Check allowance
107         allowances[_from][msg.sender] -= _value;
108         return _transfer(_from, _to, _value);
109     }
110 
111     /**
112      * Set allowance for other address
113      *
114      * Allows `_spender` to spend no more than `_value` tokens in your behalf
115      *
116      * @param _spender The address authorized to spend
117      * @param _value the max amount they can spend
118      */
119     function approve(address _spender, uint256 _value) public returns(bool) {
120         allowances[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122         return true;
123     }
124 
125     /**
126      * Set allowance for other address and notify
127      *
128      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
129      *
130      * @param _spender The address authorized to spend
131      * @param _value the max amount they can spend
132      * @param _extraData some extra information to send to the approved contract
133      */
134     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
135         if (approve(_spender, _value)) {
136             TokenRecipient spender = TokenRecipient(_spender);
137             spender.receiveApproval(msg.sender, _value, this, _extraData);
138             return true;
139         }
140         return false;
141     }
142 
143     /**
144      * Destroy tokens
145      *
146      * Remove `_value` tokens from the system irreversibly
147      *
148      * @param _value the amount of money to burn
149      */
150     function burn(uint256 _value) public returns(bool) {
151         require(balances[msg.sender] >= _value);   // Check if the sender has enough
152         balances[msg.sender] -= _value;            // Subtract from the sender
153         totalSupply -= _value;                      // Updates totalSupply
154         Burn(msg.sender, _value);
155         return true;
156     }
157 
158     /**
159      * Destroy tokens from other account
160      *
161      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
162      *
163      * @param _from the address of the sender
164      * @param _value the amount of money to burn
165      */
166     function burnFrom(address _from, uint256 _value) public returns(bool) {
167         require(balances[_from] >= _value);                // Check if the targeted balance is enough
168         require(_value <= allowances[_from][msg.sender]);    // Check allowance
169         balances[_from] -= _value;                         // Subtract from the targeted balance
170         allowances[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
171         totalSupply -= _value;                              // Update totalSupply
172         Burn(_from, _value);
173         return true;
174     }
175 
176     /**
177      * approve should be called when allowances[_spender] == 0. To increment
178      * allowances value is better to use this function to avoid 2 calls (and wait until
179      * the first transaction is mined)
180      * From MonolithDAO Token.sol
181      */
182     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
183         // Check for overflows
184         require(allowances[msg.sender][_spender] + _addedValue > allowances[msg.sender][_spender]);
185 
186         allowances[msg.sender][_spender] += _addedValue;
187         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
188         return true;
189     }
190 
191     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
192         uint oldValue = allowances[msg.sender][_spender];
193         if (_subtractedValue > oldValue) {
194             allowances[msg.sender][_spender] = 0;
195         } else {
196             allowances[msg.sender][_spender] = oldValue - _subtractedValue;
197         }
198         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
199         return true;
200     }
201 
202 }
203 
204 
205 contract TourismEcologyChainToken is TourismEcologyChainBase {
206 
207     function TourismEcologyChainToken() TourismEcologyChainBase(800000000, "TEC Token", "TEC", 18) public {
208 
209     }
210 }