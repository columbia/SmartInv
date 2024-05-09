1 pragma solidity ^0.4.22;
2 
3 contract Owned {
4     
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19 }
20 
21 interface tokenRecipient {
22     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
23 }
24 
25 contract CONUNToken2 is Owned {
26 
27     struct Lock {
28         bool state; // whether locked or not
29         uint until; // lock until in timestamp
30                     // 0 will be unlocked manually(if unlocked by owner)
31                     // > 0 will be unlocked automatically(if expired)
32     }
33 
34     mapping(address => Lock) public locks;
35 
36     // This notifies clients about the address locked until or unlocked.
37     event Locked(address target, bool state, uint until);
38 
39     // Public variables of the token
40     string public name;
41     string public symbol;
42     uint8 public decimals = 18;
43     uint256 public totalSupply;
44 
45      // This creates an array with all balances
46     mapping (address => uint256) public balanceOf;
47     mapping (address => mapping (address => uint256)) public allowance;
48 
49     // This generates a public event on the blockchain that will notify clients
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     
52     // This generates a public event on the blockchain that will notify clients
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 
55     // This notifies clients about the amount burnt.
56     event Burn(address indexed from, uint256 value);
57 
58     /**
59      * Constructor function
60      *
61      * Initializes contract with initial supply tokens to the creator of the contract
62      */
63     constructor(
64 		uint256 initialSupply,
65         string tokenName,
66         string tokenSymbol
67 	) Owned() public {
68         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
69         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
70         name = tokenName;                                   // Set the name for display purposes
71         symbol = tokenSymbol;                               // Set the symbol for display purposes
72     }
73     
74     /**
75      * Internal transfer, only can be called by this contract
76      */
77     function _transfer(address _from, address _to, uint _value) internal {
78         // Unlock account if its lock is expired.
79         if (locks[msg.sender].state && locks[msg.sender].until > 0 && now > locks[msg.sender].until) {
80             locks[msg.sender] = Lock(false, 0);
81         }
82         if (msg.sender != owner) {
83             // Check if the contract is unlocked
84             require(!locks[owner].state);
85         }
86         // Check if the account is unlocked.
87         require(!locks[msg.sender].state);
88         // Prevent transfer to 0x0 address. Use burn() instead
89         require(_to != 0x0);
90         // Check if the sender has enough
91         require(balanceOf[_from] >= _value);
92         // Check for overflows
93         require(balanceOf[_to] + _value >= balanceOf[_to]);
94         // Save this for an assertion in the future
95         uint previousBalances = balanceOf[_from] + balanceOf[_to];
96         // Subtract from the sender
97         balanceOf[_from] -= _value;
98         // Add the same to the recipient
99         balanceOf[_to] += _value;
100         emit Transfer(_from, _to, _value);
101 		// This should never fail
102         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
103     }
104 
105     /**
106      * Transfer tokens
107      *
108      * Send `_value` tokens to `_to` from your account
109      *
110      * @param _to The address of the recipient
111      * @param _value The amount to send
112      */
113     function transfer(address _to, uint256 _value) public returns (bool success) {
114         _transfer(msg.sender, _to, _value);
115         return true;
116     }
117 
118     /**
119      * Transfer tokens from other account
120      *
121      * Send `_value` tokens to `_to` on behalf of `_from`
122      *
123      * @param _from The address of the sender
124      * @param _to The address of the recipient
125      * @param _value The amount to send
126      */
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
128         require(_value <= allowance[_from][msg.sender]); // Check allowance
129         allowance[_from][msg.sender] -= _value;
130         _transfer(_from, _to, _value);
131         return true;
132     }
133 
134     /**
135      * Transfer tokens and lock recipient
136      *
137      * Send `_value` tokens to `_to` from your account and lock `_to` until `_until`
138      *
139      * @param _to The address of the recipient
140      * @param _value The amount to send
141      */
142     function transferAndLock(address _to, uint256 _value, uint _until) public returns (bool success) {
143         return transfer(_to, _value) && lock(_to, true, _until);
144     }
145     
146     /**
147      * Set allowance for other address
148      *
149      * Allow `_spender` to spend no more than `_value` tokens on your behalf
150      *
151      * @param _spender The address authorized to spend
152      * @param _value The max amount they can spend
153      */
154     function approve(address _spender, uint256 _value) public returns (bool success) {
155         allowance[msg.sender][_spender] = _value;
156         emit Approval(msg.sender, _spender, _value);
157         return true;
158     }
159 
160     /**
161      * Set allowance for other address and notify
162      *
163      * Allow `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
164      *
165      * @param _spender The address authorized to spend
166      * @param _value The max amount they can spend
167      * @param _extraData Some extra information to send to the approved contract
168      */
169     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
170         tokenRecipient spender = tokenRecipient(_spender);
171         if (approve(_spender, _value)) {
172             spender.receiveApproval(msg.sender, _value, this, _extraData);
173             return true;
174         }
175     }
176 
177     /**
178      * Internal burn, only can be called by this contract
179      */
180     function _burn(address _from, uint256 _value) internal {
181         balanceOf[_from] -= _value; // Subtract from
182         totalSupply -= _value; // Update totalSupply
183     }
184     
185     /**
186      * Destroy tokens
187      *
188      * Remove `_value` tokens from the system irreversibly
189      *
190      * @param _value The amount of money to burn
191      */
192     function burn(uint256 _value) onlyOwner public returns (bool success) {
193         require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
194         _burn(msg.sender, _value);
195         emit Burn(msg.sender, _value);
196         return true;
197     }
198 
199     /**
200      * Destroy tokens from other account
201      *
202      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
203      *
204      * @param _from The address of the sender
205      * @param _value The amount of money to burn
206      */
207     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
208         require(balanceOf[_from] >= _value); // Check if the targeted balance is enough
209         require(_value <= allowance[_from][msg.sender]); // Check allowance
210         allowance[_from][msg.sender] -= _value; // Subtract from the sender's allowance
211         _burn(_from, _value);
212         emit Burn(_from, _value);
213         return true;
214     }
215     
216     /**
217      * Lock or unlock account
218      *
219      * Set `_target`'s account to `_state` until `_until`.
220      *
221      * @param _target The address of the target
222      * @param _state Whether the account is locked or not
223      * @param _until Lock until in timestamp
224      */
225     function lock(address _target, bool _state, uint _until) onlyOwner public returns (bool success) {
226         locks[_target] = Lock(_state, _until);
227         emit Locked(_target, _state, _until);
228         return true;
229     }
230 }