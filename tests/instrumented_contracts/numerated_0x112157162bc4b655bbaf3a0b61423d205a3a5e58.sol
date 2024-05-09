1 pragma solidity ^0.4.19;
2 
3 // -----------------------------------------------------------------------
4 // An ERC20 standard
5 contract ERC20 {
6     // the total token supply
7     uint256 public totalSupply;
8  
9     // Get the account balance of another account with address _owner
10     function balanceOf(address _owner) public constant returns (uint256 balance);
11  
12     // Send _value amount of tokens to address _to
13     function transfer(address _to, uint256 _value) public returns (bool success);
14     
15     // transfer _value amount of token approved by address _from
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17 
18     // approve an address with _value amount of tokens
19     function approve(address _spender, uint256 _value) public returns (bool success);
20 
21     // get remaining token approved by _owner to _spender
22     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
23   
24     // Triggered when tokens are transferred.
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26  
27     // Triggered whenever approve(address _spender, uint256 _value) is called.
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);}
29 
30 interface TokenRecipient {
31     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
32 }
33 
34 contract GRVBase is ERC20 {
35     // Public variables of the token
36     string public name;
37     string public symbol;
38     uint8  public decimals = 18;
39     // 18 decimals is the strongly suggested default, avoid changing it
40 
41     // Balances
42     mapping (address => uint256) balances;
43     // Allowances
44     mapping (address => mapping (address => uint256)) allowances;
45 
46 
47     // ----- Events -----
48     event Burn(address indexed from, uint256 value);
49 
50 
51     /**
52      * Constructor function
53      */
54     function GRVBase(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
55         name = _tokenName;                                   // Set the name for display purposes
56         symbol = _tokenSymbol;                               // Set the symbol for display purposes
57         decimals = _decimals;
58 
59         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
60         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
61     }
62 
63     function balanceOf(address _owner) public view returns(uint256) {
64         return balances[_owner];
65     }
66 
67     function allowance(address _owner, address _spender) public view returns (uint256) {
68         return allowances[_owner][_spender];
69     }
70 
71     /**
72      * Internal transfer, only can be called by this contract
73      */
74     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
75         // Prevent transfer to 0x0 address. Use burn() instead
76         require(_to != 0x0);
77         // Check if the sender has enough
78         require(balances[_from] >= _value);
79         // Check for overflows
80         require(balances[_to] + _value > balances[_to]);
81         // Save this for an assertion in the future
82         uint previousBalances = balances[_from] + balances[_to];
83         // Subtract from the sender
84         balances[_from] -= _value;
85         // Add the same to the recipient
86         balances[_to] += _value;
87         Transfer(_from, _to, _value);
88         // Asserts are used to use static analysis to find bugs in your code. They should never fail
89         assert(balances[_from] + balances[_to] == previousBalances);
90 
91         return true;
92     }
93 
94     /**
95      * Transfer tokens
96      *
97      * Send `_value` tokens to `_to` from your account
98      *
99      * @param _to The address of the recipient
100      * @param _value the amount to send
101      */
102     function transfer(address _to, uint256 _value) public returns(bool) {
103         return _transfer(msg.sender, _to, _value);
104     }
105 
106     /**
107      * Transfer tokens from other address
108      *
109      * Send `_value` tokens to `_to` in behalf of `_from`
110      *
111      * @param _from The address of the sender
112      * @param _to The address of the recipient
113      * @param _value the amount to send
114      */
115     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
116         require(_value <= allowances[_from][msg.sender]);     // Check allowance
117         allowances[_from][msg.sender] -= _value;
118         return _transfer(_from, _to, _value);
119     }
120 
121     /**
122      * Set allowance for other address
123      *
124      * Allows `_spender` to spend no more than `_value` tokens in your behalf
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      */
129     function approve(address _spender, uint256 _value) public returns(bool) {
130         allowances[msg.sender][_spender] = _value;
131         Approval(msg.sender, _spender, _value);
132         return true;
133     }
134 
135     /**
136      * Set allowance for other address and notify
137      *
138      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
139      *
140      * @param _spender The address authorized to spend
141      * @param _value the max amount they can spend
142      * @param _extraData some extra information to send to the approved contract
143      */
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
145         if (approve(_spender, _value)) {
146             TokenRecipient spender = TokenRecipient(_spender);
147             spender.receiveApproval(msg.sender, _value, this, _extraData);
148             return true;
149         }
150         return false;
151     }
152 
153     /**
154      * Destroy tokens
155      *
156      * Remove `_value` tokens from the system irreversibly
157      *
158      * @param _value the amount of money to burn
159      */
160     function burn(uint256 _value) public returns(bool) {
161         require(balances[msg.sender] >= _value);   // Check if the sender has enough
162         balances[msg.sender] -= _value;            // Subtract from the sender
163         totalSupply -= _value;                      // Updates totalSupply
164         Burn(msg.sender, _value);
165         return true;
166     }
167 
168     /**
169      * Destroy tokens from other account
170      *
171      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
172      *
173      * @param _from the address of the sender
174      * @param _value the amount of money to burn
175      */
176     function burnFrom(address _from, uint256 _value) public returns(bool) {
177         require(balances[_from] >= _value);                // Check if the targeted balance is enough
178         require(_value <= allowances[_from][msg.sender]);    // Check allowance
179         balances[_from] -= _value;                         // Subtract from the targeted balance
180         allowances[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
181         totalSupply -= _value;                              // Update totalSupply
182         Burn(_from, _value);
183         return true;
184     }
185 
186     /**
187      * approve should be called when allowances[_spender] == 0. To increment
188      * allowances value is better to use this function to avoid 2 calls (and wait until
189      * the first transaction is mined)
190      * From MonolithDAO Token.sol
191      */
192     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193         // Check for overflows
194         require(allowances[msg.sender][_spender] + _addedValue > allowances[msg.sender][_spender]);
195 
196         allowances[msg.sender][_spender] += _addedValue;
197         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
198         return true;
199     }
200 
201     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
202         uint oldValue = allowances[msg.sender][_spender];
203         if (_subtractedValue > oldValue) {
204             allowances[msg.sender][_spender] = 0;
205         } else {
206             allowances[msg.sender][_spender] = oldValue - _subtractedValue;
207         }
208         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
209         return true;
210     }
211 
212 }
213 
214 
215 contract GRV is GRVBase {
216 
217     function GRV() GRVBase(10000000000, "Gravity Network", "GRV", 18) public {
218 
219     }
220 }