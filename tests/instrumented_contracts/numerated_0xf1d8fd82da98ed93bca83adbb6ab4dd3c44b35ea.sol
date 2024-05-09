1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5     function owned() public {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12     function transferOwnership(address _newOwner) onlyOwner public {
13         owner = _newOwner;
14     }
15 }
16 
17 contract GOG is owned {
18     // Public variables of the GOG token
19     string public name;
20     string public symbol;
21     uint8 public decimals = 6;
22     // 6 decimals for GOG
23     uint256 public totalSupply;
24 
25     // This creates an array with all balances
26     mapping (address => uint256) public balances;
27     // this creates an 2 x 2 array with allowances
28     mapping (address => mapping (address => uint256)) public allowance;
29     // This creates an array with all frozenFunds
30     mapping (address => uint256) public frozenFunds;
31     // This generates a public event on the blockchain that will notify clients freezing of funds
32     event FrozenFunds(address target, uint256 funds);
33         // This generates a public event on the blockchain that will notify clients unfreezing of funds
34     event UnFrozenFunds(address target, uint256 funds);
35     // This generates a public event on the blockchain that will notify clients transfering of funds
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39     // This notifies clients about approval of allowances
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 
42     /**
43      * Constrctor function
44      * Initializes contract with initial supply tokens to the creator of the contract
45      */
46     function GOG() public {
47         totalSupply = 10000000000000000;               // GOG's total supply is 10 billion with 6 decimals
48         balances[msg.sender] = totalSupply;          // Give the creator all initial tokens
49         name = "GoGlobe Token";                       // Token name is GoGlobe Token
50         symbol = "GOG";                               // token symbol is GOG
51     }
52 
53     /**
54      * Freeze funds on account
55      * @param _target The account will be freezed
56      * @param _funds The amount of funds will be freezed
57      */
58     function freezeAccount(address _target, uint256 _funds) public onlyOwner {
59         if (_funds == 0x0)
60             frozenFunds[_target] = balances[_target];
61         else
62             frozenFunds[_target] = _funds;
63         FrozenFunds(_target, _funds);
64     }
65 
66     /**
67      * unfreeze funds on account
68      * @param _target The account will be unfreezed
69      * @param _funds The amount of funds will be unfreezed
70      */
71     function unFreezeAccount(address _target, uint256 _funds) public onlyOwner {
72         require(_funds > 0x0);
73         uint256 temp = frozenFunds[_target];
74         temp = temp < _funds ? 0x0 : temp - _funds;
75         frozenFunds[_target] = temp;
76         UnFrozenFunds(_target, _funds);
77     }
78 
79     /**
80      * get the balance of account
81      * @param _owner The account address
82      */
83     function balanceOf(address _owner) constant public returns (uint256) {
84         return balances[_owner];
85     }
86 
87     /**
88      * get the frozen balance of account
89      * @param _owner The account address
90      */
91     function frozenFundsOf(address _owner) constant public returns (uint256) {
92         return frozenFunds[_owner];
93     }
94 
95     /**
96      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
97      * @param _spender The address which will spend the funds.
98      * @param _value The amount of tokens to be spent.
99      */
100     function approve(address _spender, uint256 _value) public returns (bool) {
101         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
102         allowance[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     /**
108      * @dev Function to check the amount of tokens that an owner allowance to a spender.
109      * @param _owner address The address which owns the funds.
110      * @param _spender address The address which will spend the funds.
111      * @return A uint256 specifing the amount of tokens still avaible for the spender.
112      */
113     function allowance(address _owner, address _spender) constant public returns (uint256) {
114         return allowance[_owner][_spender];
115     }
116 
117     /**
118      * Internal transfer, only can be called by this contract
119      */
120     function _transfer(address _from, address _to, uint _value) internal {
121         // Prevent transfer to 0x0 address. Use burn() instead
122         require(_to != 0x0);
123 
124         // Check if the sender has enough
125         require(balances[_from] > frozenFunds[_from]);
126         require((balances[_from] - frozenFunds[_from]) >= _value);
127         // Check for overflows
128         require(balances[_to] + _value > balances[_to]);
129         // Save this for an assertion in the future
130         uint previousBalances = balances[_from] + balances[_to];
131         // Subtract from the sender
132         balances[_from] -= _value;
133         // Add the same to the recipient
134         balances[_to] += _value;
135         Transfer(_from, _to, _value);
136         // Asserts are used to use static analysis to find bugs in your code. They should never fail
137         assert(balances[_from] + balances[_to] == previousBalances);
138     }
139 
140     /**
141      * Transfer tokens
142      * Send `_value` tokens to `_to` from your account
143      * @param _to The address of the recipient
144      * @param _value the amount to send
145      */
146     function transfer(address _to, uint256 _value) public {
147         _transfer(msg.sender, _to, _value);
148     }
149 
150     /**
151      * Transfer tokens from other address
152      * Send `_value` tokens to `_to` on behalf of `_from`
153      * @param _from The address of the sender
154      * @param _to The address of the recipient
155      * @param _value the amount to send
156      */
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158         require(_value <= allowance[_from][msg.sender]);     // Check allowance
159         allowance[_from][msg.sender] -= _value;
160         _transfer(_from, _to, _value);
161         return true;
162     }
163 
164     /**
165      * Destroy tokens
166      * Remove `_value` tokens from the system irreversibly
167      * @param _value the amount of money to burn
168      */
169     function burn(uint256 _value) public returns (bool) {
170         require(balances[msg.sender] >= _value);   // Check if the sender has enough
171         balances[msg.sender] -= _value;            // Subtract from the sender
172         totalSupply -= _value;                      // Updates totalSupply
173         Burn(msg.sender, _value);
174         return true;
175     }
176 
177     /**
178      * Destroy tokens from other account
179      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
180      * @param _from the address of the sender
181      * @param _value the amount of money to burn
182      */
183     function burnFrom(address _from, uint256 _value) public returns (bool) {
184         require(balances[_from] >= _value);                // Check if the targeted balance is enough
185         require(_value <= allowance[_from][msg.sender]);    // Check allowance
186         balances[_from] -= _value;                         // Subtract from the targeted balance
187         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
188         totalSupply -= _value;                              // Update totalSupply
189         Burn(_from, _value);
190         return true;
191     }
192 }