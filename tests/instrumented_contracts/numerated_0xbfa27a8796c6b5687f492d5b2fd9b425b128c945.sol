1 /*
2 Ruden Token
3 */
4 pragma solidity ^0.4.25;
5 
6 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
7 
8 contract RudenCoin {
9     // Public variables of the token
10     string public constant name = 'Ruden Coin';
11     string public constant symbol = 'RDC';
12     uint8 public constant decimals = 18;
13     uint256 public totalSupply = 10000000000 * 10 ** uint256(decimals);
14 
15     // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     // This generates a public event on the blockchain that will notify clients
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 
23     // This notifies clients about the amount burnt
24     event Burn(address indexed from, uint256 value);
25 
26     /**
27      * Constrctor function
28      *
29      * Initializes contract with initial supply tokens to the creator of the contract
30      */
31     constructor() public {
32          balanceOf[msg.sender] = totalSupply;   // Give the creator all initial tokens
33     }
34 
35     /**
36      * Internal transfer, only can be called by this contract
37      */
38     function _transfer(address _from, address _to, uint _value) internal{
39         // Prevent transfer to 0x0 address. Use burn() instead
40         require(_to != 0x0);
41         // Check if the sender has enough
42         require(balanceOf[_from] >= _value);
43         // Check for overflows
44         require(balanceOf[_to] + _value > balanceOf[_to]);
45         // Save this for an assertion in the future
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         // Subtract from the sender
48         balanceOf[_from] -= _value;
49         // Add the same to the recipient
50         balanceOf[_to] += _value;
51         emit Transfer(_from, _to, _value);
52         // Asserts are used to use static analysis to find bugs in your code. They should never fail
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55 
56     /**
57      * Transfer tokens
58      *
59      * Send `_value` tokens to `_to` from your account
60      *
61      * @param _to The address of the recipient
62      * @param _value the amount to send
63      */
64     function transfer(address _to, uint256 _value) public returns (bool success) {
65         _transfer(msg.sender, _to, _value);
66         return true;
67     }
68 
69     /**
70      * Transfer tokens from other address
71      *
72      * Send `_value` tokens to `_to` in behalf of `_from`
73      *
74      * @param _from The address of the sender
75      * @param _to The address of the recipient
76      * @param _value the amount to send
77      */
78     function transferFrom(address _from, address _to, uint256 _value) 
79     public returns (bool success) {
80         require(_value <= allowance[_from][msg.sender]);     // Check allowance
81         allowance[_from][msg.sender] -= _value;
82         _transfer(_from, _to, _value);
83         return true;
84     }
85 
86     /**
87      * Set allowance for other address
88      *
89      * Allows `_spender` to spend no more than `_value` tokens in your behalf
90      *
91      * @param _spender The address authorized to spend
92      * @param _value the max amount they can spend
93      */
94     function approve(address _spender, uint256 _value) public returns (bool success) {
95         allowance[msg.sender][_spender] = _value;
96         emit Approval(msg.sender, _spender, _value);
97         return true;
98     }
99 
100     /**
101      * Set allowance for other address and notify
102      *
103      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
104      *
105      * @param _spender The address authorized to spend
106      * @param _value the max amount they can spend
107      * @param _extraData some extra information to send to the approved contract
108      */
109     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
110     public returns (bool success) {
111         tokenRecipient spender = tokenRecipient(_spender);
112         if (approve(_spender, _value)) {
113             spender.receiveApproval(msg.sender, _value, this, _extraData);
114             return true;
115         }
116         return false;
117     }
118 
119     /**
120      * @dev Increase the amount of tokens that an owner allowed to a spender.
121      *
122      * approve should be called when allowed[_spender] == 0. To increment
123      * allowed value is better to use this function to avoid 2 calls (and wait until
124      * the first transaction is mined)
125      * From MonolithDAO Token.sol
126      * @param _spender The address which will spend the funds.
127      * @param _addedValue The amount of tokens to increase the allowance by.
128      */
129     function increaseApproval(address _spender, uint _addedValue) public returns (bool)
130     {
131       require(allowance[msg.sender][_spender] + _addedValue > allowance[msg.sender][_spender]);
132       allowance[msg.sender][_spender] += _addedValue;
133       emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
134       return true;
135     }
136 
137     /**
138      * @dev Decrease the amount of tokens that an owner allowed to a spender.
139      *
140      * approve should be called when allowed[_spender] == 0. To decrement
141      * allowed value is better to use this function to avoid 2 calls (and wait until
142      * the first transaction is mined)
143      * From MonolithDAO Token.sol
144      * @param _spender The address which will spend the funds.
145      * @param _subtractedValue The amount of tokens to decrease the allowance by.
146      */
147     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool)
148     {
149       uint oldValue = allowance[msg.sender][_spender];
150       if (_subtractedValue > oldValue) {
151         allowance[msg.sender][_spender] = 0;
152       } else {
153         allowance[msg.sender][_spender] = oldValue - _subtractedValue;
154       }
155       emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
156       return true;
157     }
158 
159     /**
160      * Destroy tokens
161      *
162      * Remove `_value` tokens from the system irreversibly
163      *
164      * @param _value the amount of money to burn
165      */
166     function burn(uint256 _value) public returns (bool success) {
167         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
168         balanceOf[msg.sender] -= _value;            // Subtract from the sender
169         totalSupply -= _value;                      // Updates totalSupply
170         emit Burn(msg.sender, _value);
171         return true;
172     }
173 
174     /**
175      * Destroy tokens from other account
176      *
177      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
178      *
179      * @param _from the address of the sender
180      * @param _value the amount of money to burn
181      */
182     function burnFrom(address _from, uint256 _value) public returns (bool success) {
183         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
184         require(_value <= allowance[_from][msg.sender]);    // Check allowance
185         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
186         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
187         totalSupply -= _value;                              // Update totalSupply
188         emit Burn(_from, _value);
189         return true;
190     }
191 }