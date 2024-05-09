1 pragma solidity ^0.4.17;
2 
3 pragma solidity ^0.4.16;
4 
5 pragma solidity ^0.4.17;
6 
7 
8 
9 interface TokenRecipient {
10     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
11 }
12 
13 
14 contract ERC20 {
15 
16     // Public variables of the token
17     uint256 public totalSupply;
18     string public name;
19     string public symbol;
20     uint8  public decimals;    // 18 decimals is the strongly suggested default, avoid changing it
21 
22 
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26 
27     function balanceOf(address who) public view returns (uint256);
28     function transfer(address to, uint256 value) public returns (bool);
29 
30     function approve(address spender, uint256 value) public returns (bool);
31     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool);
32     function allowance(address owner, address spender) public view returns (uint256);
33     function transferFrom(address from, address to, uint256 value) public returns (bool);
34 
35 }
36 
37 
38 contract TokenERC20 is ERC20 {
39 
40     // Balances
41     mapping (address => uint256) balances;
42     // Allowances
43     mapping (address => mapping (address => uint256)) allowances;
44 
45 
46     // ----- Events -----
47     event Burn(address indexed from, uint256 value);
48 
49 
50     /**
51      * Constructor function
52      */
53     constructor(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
54         name = _tokenName;                                   // Set the name for display purposes
55         symbol = _tokenSymbol;                               // Set the symbol for display purposes
56         decimals = _decimals;
57 
58         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
59         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
60     }
61 
62     function balanceOf(address _owner) public view returns(uint256) {
63         return balances[_owner];
64     }
65 
66     function allowance(address _owner, address _spender) public view returns (uint256) {
67         return allowances[_owner][_spender];
68     }
69 
70     /**
71      * Internal transfer, only can be called by this contract
72      */
73     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
74         // Prevent transfer to 0x0 address. Use burn() instead
75         require(_to != 0x0);
76         // Check if the sender has enough
77         require(balances[_from] >= _value);
78         // Check for overflows
79         require(balances[_to] + _value > balances[_to]);
80         // Save this for an assertion in the future
81         uint previousBalances = balances[_from] + balances[_to];
82         // Subtract from the sender
83         balances[_from] -= _value;
84         // Add the same to the recipient
85         balances[_to] += _value;
86         emit Transfer(_from, _to, _value);
87         // Asserts are used to use static analysis to find bugs in your code. They should never fail
88         assert(balances[_from] + balances[_to] == previousBalances);
89 
90         return true;
91     }
92 
93     /**
94      * Transfer tokens
95      *
96      * Send `_value` tokens to `_to` from your account
97      *
98      * @param _to The address of the recipient
99      * @param _value the amount to send
100      */
101     function transfer(address _to, uint256 _value) public returns(bool) {
102         return _transfer(msg.sender, _to, _value);
103     }
104 
105     /**
106      * Transfer tokens from other address
107      *
108      * Send `_value` tokens to `_to` in behalf of `_from`
109      *
110      * @param _from The address of the sender
111      * @param _to The address of the recipient
112      * @param _value the amount to send
113      */
114     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
115         require(_value <= allowances[_from][msg.sender]);     // Check allowance
116         allowances[_from][msg.sender] -= _value;
117         return _transfer(_from, _to, _value);
118     }
119 
120     /**
121      * Set allowance for other address
122      *
123      * Allows `_spender` to spend no more than `_value` tokens in your behalf
124      *
125      * @param _spender The address authorized to spend
126      * @param _value the max amount they can spend
127      */
128     function approve(address _spender, uint256 _value) public returns(bool) {
129         allowances[msg.sender][_spender] = _value;
130         emit Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134     /**
135      * Set allowance for other address and notify
136      *
137      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
138      *
139      * @param _spender The address authorized to spend
140      * @param _value the max amount they can spend
141      * @param _extraData some extra information to send to the approved contract
142      */
143     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
144         if (approve(_spender, _value)) {
145             TokenRecipient spender = TokenRecipient(_spender);
146             spender.receiveApproval(msg.sender, _value, this, _extraData);
147             return true;
148         }
149         return false;
150     }
151 
152     /**
153      * Destroy tokens
154      *
155      * Remove `_value` tokens from the system irreversibly
156      *
157      * @param _value the amount of money to burn
158      */
159     function burn(uint256 _value) public returns(bool) {
160         require(balances[msg.sender] >= _value);   // Check if the sender has enough
161         balances[msg.sender] -= _value;            // Subtract from the sender
162         totalSupply -= _value;                      // Updates totalSupply
163         emit Burn(msg.sender, _value);
164         return true;
165     }
166 
167     /**
168      * Destroy tokens from other account
169      *
170      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
171      *
172      * @param _from the address of the sender
173      * @param _value the amount of money to burn
174      */
175     function burnFrom(address _from, uint256 _value) public returns(bool) {
176         require(balances[_from] >= _value);                // Check if the targeted balance is enough
177         require(_value <= allowances[_from][msg.sender]);    // Check allowance
178         balances[_from] -= _value;                         // Subtract from the targeted balance
179         allowances[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
180         totalSupply -= _value;                              // Update totalSupply
181         emit Burn(_from, _value);
182         return true;
183     }
184 
185     /**
186      * approve should be called when allowances[_spender] == 0. To increment
187      * allowances value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      */
191     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
192         // Check for overflows
193         require(allowances[msg.sender][_spender] + _addedValue > allowances[msg.sender][_spender]);
194 
195         allowances[msg.sender][_spender] += _addedValue;
196         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
197         return true;
198     }
199 
200     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
201         uint oldValue = allowances[msg.sender][_spender];
202         if (_subtractedValue > oldValue) {
203             allowances[msg.sender][_spender] = 0;
204         } else {
205             allowances[msg.sender][_spender] = oldValue - _subtractedValue;
206         }
207         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
208         return true;
209     }
210 
211 
212 }
213 
214 
215 contract CaiToken is TokenERC20(21000000000, "Cai Token", "CAI", 18) {
216 
217     constructor() public {
218 
219     }
220 }