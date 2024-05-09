1 pragma solidity ^0.4.22;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract iERC20v1{
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     
20     // This generates a public event on the blockchain that will notify clients
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 
23     // This notifies clients about the amount burnt
24     event Burn(address indexed from, uint256 value);
25 
26     modifier mustBeValidValue(uint256 _value) {
27         require(_value >= 0 && _value <= totalSupply);
28         _;
29     }
30     
31     modifier mustBeContract(address _spender) {
32         uint256 codeSize;
33         assembly { codeSize := extcodesize(_spender) }
34         require(codeSize > 0);
35         _;
36     }
37     /**
38      * Constructor function
39      *
40      * Initializes contract with initial supply tokens to the creator of the contract
41      */
42     constructor(
43         uint256 initialSupply,
44         string tokenName,
45         string tokenSymbol
46     ) public {
47         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
48         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
49         name = tokenName;                                   // Set the name for display purposes
50         symbol = tokenSymbol;                               // Set the symbol for display purposes
51     }
52 
53     /**
54      * Internal transfer, only can be called by this contract
55      */
56     function _transfer(address _from, address _to, uint _value) internal {
57         // Prevent transfer to 0x0 address. Use burn() instead
58         require(_to != 0x0);
59         // Check if the sender has enough
60         require(balanceOf[_from] >= _value);
61         // Check for overflows
62         require(balanceOf[_to] + _value >= balanceOf[_to]);
63         // Save this for an assertion in the future
64         uint previousBalances = balanceOf[_from] + balanceOf[_to];
65         // Subtract from the sender
66         balanceOf[_from] -= _value;
67         // Add the same to the recipient
68         balanceOf[_to] += _value;
69         emit Transfer(_from, _to, _value);
70         // Asserts are used to use static analysis to find bugs in your code. They should never fail
71         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
72     }
73 
74     /**
75      * Transfer tokens
76      *
77      * Send `_value` tokens to `_to` from your account
78      *
79      * @param _to The address of the recipient
80      * @param _value the amount to send
81      */
82     function transfer(address _to, uint256 _value) public mustBeValidValue(_value) {
83         _transfer(msg.sender, _to, _value);
84     }
85 
86     /**
87      * Transfer tokens from other address
88      *
89      * Send `_value` tokens to `_to` on behalf of `_from`
90      *
91      * @param _from The address of the sender
92      * @param _to The address of the recipient
93      * @param _value the amount to send
94      */
95     function transferFrom(address _from, address _to, uint256 _value) public mustBeValidValue(_value) returns (bool success) {
96         require(_value <= allowance[_from][msg.sender]);     // Check allowance
97         allowance[_from][msg.sender] -= _value;
98         _transfer(_from, _to, _value);
99         return true;
100     }
101 
102     /**
103      * Add the allowance for other address
104      *
105      * Allows `_spender` to spend another `_addValue` tokens on your behalf
106      *
107      * @param _spender The address authorized to spend
108      * @param _addValue the new added amount they can spend
109      */
110     function increaseApproval(address _spender, uint256 _addValue) public mustBeValidValue(_addValue)
111         returns (bool success) {
112         
113         require(allowance[msg.sender][_spender] + _addValue >= allowance[msg.sender][_spender]);
114         require(balanceOf[msg.sender] >= allowance[msg.sender][_spender] + _addValue);
115         allowance[msg.sender][_spender] += _addValue;
116         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
117         return true;
118     }
119     
120      /**
121      * Subtract allowance for other address
122      *
123      * Decrease the allowance of `_spender` by `_subValue`
124      *
125      * @param _spender The address authorized to spend
126      * @param _subValue the amount to decrease
127      */
128     function decreaseApproval(address _spender, uint256 _subValue) public mustBeValidValue(_subValue)
129         returns (bool success) {
130         
131         uint oldValue = allowance[msg.sender][_spender];
132         if (_subValue > oldValue)
133            allowance[msg.sender][_spender] = 0;
134         else
135            allowance[msg.sender][_spender] = oldValue - _subValue;
136         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
137         return true;
138     }
139 
140     /**
141      * Add the allowance for other address and notify
142      *
143      * Allows `_spender` to spend another `_addValue` tokens on your behalf, and then ping the contract about it
144      *
145      * @param _spender The address authorized to spend
146      * @param _addValue the new added amount they can spend
147      * @param _extraData some extra information to send to the approved contract
148      */
149     function increaseApproveAndCall(address _spender, uint256 _addValue, bytes _extraData)
150         public
151         mustBeValidValue(_addValue)
152         mustBeContract(_spender)
153         returns (bool success) {
154         
155         if (increaseApproval(_spender, _addValue)) {
156             tokenRecipient spender = tokenRecipient(_spender);
157             spender.receiveApproval(msg.sender, allowance[msg.sender][_spender], this, _extraData);
158             return true;
159         }
160     }
161     
162      /**
163      * Subtract allowance for other address and notify 
164      *
165      * Decrease the allowance of `_spender` by `_value` on your behalf, and then ping the contract about it
166      *
167      * @param _spender The address authorized to spend
168      * @param _subValue the amount to decrease
169      * @param _extraData some extra information to send to the approved contract
170      */
171     function decreaseApproveAndCall(address _spender, uint256 _subValue, bytes _extraData)
172         public
173         mustBeValidValue(_subValue)
174         mustBeContract(_spender)
175         returns (bool success) {
176    
177         if (decreaseApproval(_spender, _subValue)) {
178             tokenRecipient spender = tokenRecipient(_spender);
179             spender.receiveApproval(msg.sender, allowance[msg.sender][_spender], this, _extraData);
180             return true;
181         }
182     }
183 
184     /**
185      * Destroy tokens
186      *
187      * Remove `_value` tokens from the system irreversibly
188      *
189      * @param _value the amount of money to burn
190      */
191     function burn(uint256 _value) public mustBeValidValue(_value) returns (bool success) {
192         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
193         balanceOf[msg.sender] -= _value;            // Subtract from the sender
194         totalSupply -= _value;                      // Updates totalSupply
195         emit Burn(msg.sender, _value);
196         return true;
197     }
198 
199     /**
200      * Destroy tokens from other account
201      *
202      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
203      *
204      * @param _from the address of the sender
205      * @param _value the amount of money to burn
206      */
207     function burnFrom(address _from, uint256 _value) public mustBeValidValue(_value) returns (bool success) {
208         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
209         require(_value <= allowance[_from][msg.sender]);    // Check allowance
210         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
211         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
212         totalSupply -= _value;                              // Update totalSupply
213         emit Burn(_from, _value);
214         return true;
215     }
216 }