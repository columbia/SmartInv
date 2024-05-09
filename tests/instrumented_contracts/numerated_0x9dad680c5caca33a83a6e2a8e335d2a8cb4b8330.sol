1 pragma solidity ^0.4.18;
2 
3 // -----------------------------------------------------------------------
4 // CNN Token by D-Run Foundation.
5 // An ERC20 standard
6 contract ERC20 {
7     // the total token supply
8     uint256 public totalSupply;
9 
10     // Get the account balance of another account with address _owner
11     function balanceOf(address _owner) public constant returns (uint256 balance);
12 
13     // Send _value amount of tokens to address _to
14     function transfer(address _to, uint256 _value) public returns (bool success);
15 
16     // transfer _value amount of token approved by address _from
17     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
18 
19     // approve an address with _value amount of tokens
20     function approve(address _spender, uint256 _value) public returns (bool success);
21 
22     // get remaining token approved by _owner to _spender
23     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
24 
25     // Triggered when tokens are transferred.
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27 
28     // Triggered whenever approve(address _spender, uint256 _value) is called.
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);}
30 
31 interface TokenRecipient {
32     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
33 }
34 
35 contract LilithToken is ERC20 {
36     // Public variables of the token
37     string public name;
38     string public symbol;
39     uint8  public decimals = 18;
40     // 18 decimals is the strongly suggested default, avoid changing it
41 
42     // Balances
43     mapping (address => uint256) balances;
44     // Allowances
45     mapping (address => mapping (address => uint256)) allowances;
46 
47 
48     // ----- Events -----
49     event Burn(address indexed from, uint256 value);
50 
51 
52     /**
53      * Constructor function
54      */
55     function LilithToken(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
56         name = _tokenName;                                   // Set the name for display purposes
57         symbol = _tokenSymbol;                               // Set the symbol for display purposes
58         decimals = _decimals;
59 
60         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
61         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
62     }
63 
64     function balanceOf(address _owner) public view returns(uint256) {
65         return balances[_owner];
66     }
67 
68     function allowance(address _owner, address _spender) public view returns (uint256) {
69         return allowances[_owner][_spender];
70     }
71 
72     /**
73      * Internal transfer, only can be called by this contract
74      */
75     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
76         // Prevent transfer to 0x0 address. Use burn() instead
77         require(_to != 0x0);
78         // Check if the sender has enough
79         require(balances[_from] >= _value);
80         // Check for overflows
81         require(balances[_to] + _value > balances[_to]);
82         // Save this for an assertion in the future
83         uint previousBalances = balances[_from] + balances[_to];
84         // Subtract from the sender
85         balances[_from] -= _value;
86         // Add the same to the recipient
87         balances[_to] += _value;
88         Transfer(_from, _to, _value);
89         // Asserts are used to use static analysis to find bugs in your code. They should never fail
90         assert(balances[_from] + balances[_to] == previousBalances);
91 
92         return true;
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
103     function transfer(address _to, uint256 _value) public returns(bool) {
104         return _transfer(msg.sender, _to, _value);
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
116     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
117         require(_value <= allowances[_from][msg.sender]);     // Check allowance
118         allowances[_from][msg.sender] -= _value;
119         return _transfer(_from, _to, _value);
120     }
121 
122     /**
123      * Set allowance for other address
124      *
125      * Allows `_spender` to spend no more than `_value` tokens in your behalf
126      *
127      * @param _spender The address authorized to spend
128      * @param _value the max amount they can spend
129      */
130     function approve(address _spender, uint256 _value) public returns(bool) {
131         allowances[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136     /**
137      * Set allowance for other address and notify
138      *
139      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
140      *
141      * @param _spender The address authorized to spend
142      * @param _value the max amount they can spend
143      * @param _extraData some extra information to send to the approved contract
144      */
145     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
146         if (approve(_spender, _value)) {
147             TokenRecipient spender = TokenRecipient(_spender);
148             spender.receiveApproval(msg.sender, _value, this, _extraData);
149             return true;
150         }
151         return false;
152     }
153 
154     /**
155      * Destroy tokens
156      *
157      * Remove `_value` tokens from the system irreversibly
158      *
159      * @param _value the amount of money to burn
160      */
161     function burn(uint256 _value) public returns(bool) {
162         require(balances[msg.sender] >= _value);   // Check if the sender has enough
163         balances[msg.sender] -= _value;            // Subtract from the sender
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
177     function burnFrom(address _from, uint256 _value) public returns(bool) {
178         require(balances[_from] >= _value);                // Check if the targeted balance is enough
179         require(_value <= allowances[_from][msg.sender]);    // Check allowance
180         balances[_from] -= _value;                         // Subtract from the targeted balance
181         allowances[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
182         totalSupply -= _value;                              // Update totalSupply
183         Burn(_from, _value);
184         return true;
185     }
186 
187     /**
188      * approve should be called when allowances[_spender] == 0. To increment
189      * allowances value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      */
193     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194         // Check for overflows
195         require(allowances[msg.sender][_spender] + _addedValue > allowances[msg.sender][_spender]);
196 
197         allowances[msg.sender][_spender] += _addedValue;
198         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
199         return true;
200     }
201 
202     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
203         uint oldValue = allowances[msg.sender][_spender];
204         if (_subtractedValue > oldValue) {
205             allowances[msg.sender][_spender] = 0;
206         } else {
207             allowances[msg.sender][_spender] = oldValue - _subtractedValue;
208         }
209         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
210         return true;
211     }
212 
213 }
214 
215 
216 contract Lilith is LilithToken {
217 
218     function Lilith() LilithToken(199010251020, "LiLith", "LiLith", 18) public {
219 
220     }
221 }