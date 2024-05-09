1 pragma solidity >=0.4.22;
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
37     
38     /**
39      * @dev Fix for the ERC20 short address attack.
40      */
41     modifier onlyPayloadSize(uint size) {
42        require(msg.data.length >= size + 4);
43        _;
44     }
45     
46     /**
47      * Constructor function
48      *
49      * Initializes contract with initial supply tokens to the creator of the contract
50      */
51     constructor(
52         uint256 initialSupply,
53         string tokenName,
54         string tokenSymbol
55     ) public {
56         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
57         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
58         name = tokenName;                                   // Set the name for display purposes
59         symbol = tokenSymbol;                               // Set the symbol for display purposes
60     }
61 
62     /**
63      * Internal transfer, only can be called by this contract
64      */
65     function _transfer(address _from, address _to, uint _value) internal {
66         // Prevent transfer to 0x0 address. Use burn() instead
67         require(_to != 0x0);
68         // Check if the sender has enough
69         require(balanceOf[_from] >= _value);
70         // Check for overflows
71         require(balanceOf[_to] + _value >= balanceOf[_to]);
72         // Save this for an assertion in the future
73         uint previousBalances = balanceOf[_from] + balanceOf[_to];
74         // Subtract from the sender
75         balanceOf[_from] -= _value;
76         // Add the same to the recipient
77         balanceOf[_to] += _value;
78         emit Transfer(_from, _to, _value);
79         // Asserts are used to use static analysis to find bugs in your code. They should never fail
80         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
81     }
82 
83     /**
84      * Transfer tokens
85      *
86      * Send `_value` tokens to `_to` from your account
87      *
88      * @param _to The address of the recipient
89      * @param _value the amount to send
90      */
91     function transfer(address _to, uint256 _value) public mustBeValidValue(_value) onlyPayloadSize(2 * 32) returns (bool success) {
92         _transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97      * Transfer tokens from other address
98      *
99      * Send `_value` tokens to `_to` on behalf of `_from`
100      *
101      * @param _from The address of the sender
102      * @param _to The address of the recipient
103      * @param _value the amount to send
104      */
105     function transferFrom(address _from, address _to, uint256 _value) public mustBeValidValue(_value) onlyPayloadSize(3 * 32) returns (bool success) {
106         require(_value <= allowance[_from][msg.sender]);     // Check allowance
107         allowance[_from][msg.sender] -= _value;
108         _transfer(_from, _to, _value);
109         return true;
110     }
111     
112     /**
113      * Set allowance for other address
114      *
115      * Allows `_spender` to spend no more than `_value` tokens on your behalf
116      *
117      * @param _spender The address authorized to spend
118      * @param _value the max amount they can spend
119      */
120     function approve(address _spender, uint256 _value) public
121         returns (bool success) {
122         require(balanceOf[msg.sender] >= _value);
123         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
124         allowance[msg.sender][_spender] = _value;
125         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
126         return true;
127     }
128 
129     /**
130      * Add the allowance for other address
131      *
132      * Allows `_spender` to spend another `_addValue` tokens on your behalf
133      *
134      * @param _spender The address authorized to spend
135      * @param _addValue the new added amount they can spend
136      */
137     function increaseApproval(address _spender, uint256 _addValue) public mustBeValidValue(_addValue)
138         returns (bool success) {
139         
140         require(allowance[msg.sender][_spender] + _addValue >= allowance[msg.sender][_spender]);
141         require(balanceOf[msg.sender] >= allowance[msg.sender][_spender] + _addValue);
142         allowance[msg.sender][_spender] += _addValue;
143         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
144         return true;
145     }
146     
147      /**
148      * Subtract allowance for other address
149      *
150      * Decrease the allowance of `_spender` by `_subValue`
151      *
152      * @param _spender The address authorized to spend
153      * @param _subValue the amount to decrease
154      */
155     function decreaseApproval(address _spender, uint256 _subValue) public mustBeValidValue(_subValue)
156         returns (bool success) {
157         
158         uint oldValue = allowance[msg.sender][_spender];
159         if (_subValue > oldValue)
160            allowance[msg.sender][_spender] = 0;
161         else
162            allowance[msg.sender][_spender] = oldValue - _subValue;
163         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
164         return true;
165     }
166 
167     /**
168      * Add the allowance for other address and notify
169      *
170      * Allows `_spender` to spend another `_addValue` tokens on your behalf, and then ping the contract about it
171      *
172      * @param _spender The address authorized to spend
173      * @param _addValue the new added amount they can spend
174      * @param _extraData some extra information to send to the approved contract
175      */
176     function increaseApproveAndCall(address _spender, uint256 _addValue, bytes _extraData)
177         public
178         mustBeValidValue(_addValue)
179         mustBeContract(_spender)
180         returns (bool success) {
181         
182         if (increaseApproval(_spender, _addValue)) {
183             tokenRecipient spender = tokenRecipient(_spender);
184             spender.receiveApproval(msg.sender, allowance[msg.sender][_spender], this, _extraData);
185             return true;
186         }
187     }
188     
189      /**
190      * Subtract allowance for other address and notify 
191      *
192      * Decrease the allowance of `_spender` by `_value` on your behalf, and then ping the contract about it
193      *
194      * @param _spender The address authorized to spend
195      * @param _subValue the amount to decrease
196      * @param _extraData some extra information to send to the approved contract
197      */
198     function decreaseApproveAndCall(address _spender, uint256 _subValue, bytes _extraData)
199         public
200         mustBeValidValue(_subValue)
201         mustBeContract(_spender)
202         returns (bool success) {
203    
204         if (decreaseApproval(_spender, _subValue)) {
205             tokenRecipient spender = tokenRecipient(_spender);
206             spender.receiveApproval(msg.sender, allowance[msg.sender][_spender], this, _extraData);
207             return true;
208         }
209     }
210 
211     /**
212      * Destroy tokens
213      *
214      * Remove `_value` tokens from the system irreversibly
215      *
216      * @param _value the amount of money to burn
217      */
218     function burn(uint256 _value) public mustBeValidValue(_value) returns (bool success) {
219         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
220         balanceOf[msg.sender] -= _value;            // Subtract from the sender
221         totalSupply -= _value;                      // Updates totalSupply
222         emit Burn(msg.sender, _value);
223         return true;
224     }
225 
226     /**
227      * Destroy tokens from other account
228      *
229      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
230      *
231      * @param _from the address of the sender
232      * @param _value the amount of money to burn
233      */
234     function burnFrom(address _from, uint256 _value) public mustBeValidValue(_value) returns (bool success) {
235         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
236         require(_value <= allowance[_from][msg.sender]);    // Check allowance
237         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
238         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
239         totalSupply -= _value;                              // Update totalSupply
240         emit Burn(_from, _value);
241         return true;
242     }
243 }