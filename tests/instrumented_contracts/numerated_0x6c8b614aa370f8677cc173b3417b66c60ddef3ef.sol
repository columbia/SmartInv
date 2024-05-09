1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function ayu(address nO) onlyOwner public {
16         owner = nO;
17     }
18 }
19 
20 interface tokenRecipient { 
21     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
22 
23 contract Token {
24     
25     string public name;
26     string public symbol;
27     uint8 public decimals = 4;
28     // 18 decimals is the strongly suggested default, avoid changing it
29     uint256 public totalSupply;
30 
31     // This creates an array with all balances
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     // This generates a public event on the blockchain that will notify clients
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     
38     // This generates a public event on the blockchain that will notify clients
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41     // This notifies clients about the amount burnt
42     event Burn(address indexed from, uint256 value);
43 
44     /**
45      * Constrctor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     constructor(
50         uint256 initialSupply,
51         string memory tokenName,
52         string memory tokenSymbol
53     ) public {
54         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
55         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
56         name = tokenName;                                       // Set the name for display purposes
57         symbol = tokenSymbol;                                   // Set the symbol for display purposes
58     }
59 
60     /**
61      * Internal transfer, only can be called by this contract
62      */
63     function _transfer(address _from, address _to, uint _value) internal {
64         // Prevent transfer to 0x0 address. Use burn() instead
65         require(_to != address(0x0));
66         // Check if the sender has enough
67         require(balanceOf[_from] >= _value);
68         // Check for overflows
69         require(balanceOf[_to] + _value > balanceOf[_to]);
70         // Save this for an assertion in the future
71         uint previousBalances = balanceOf[_from] + balanceOf[_to];
72         // Subtract from the sender
73         balanceOf[_from] -= _value;
74         // Add the same to the recipient
75         balanceOf[_to] += _value;
76         emit Transfer(_from, _to, _value);
77         // Asserts are used to use static analysis to find bugs in your code. They should never fail
78         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
79     }
80 
81     /**
82      * Transfer tokens
83      *
84      * Send `_value` tokens to `_to` from your account
85      *
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transfer(address _to, uint256 _value) public returns (bool success) {
90         _transfer(msg.sender, _to, _value);
91         return true;
92     }
93 
94     /**
95      * Transfer tokens from other address
96      *
97      * Send `_value` tokens to `_to` in behalf of `_from`
98      *
99      * @param _from The address of the sender
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
104         require(_value <= allowance[_from][msg.sender]);     // Check allowance
105         allowance[_from][msg.sender] -= _value;
106         _transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address
112      *
113      * Allows `_spender` to spend no more than `_value` tokens in your behalf
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      */
118     function approve(address _spender, uint256 _value) public
119         returns (bool success) {
120         allowance[msg.sender][_spender] = _value;
121         emit Approval(msg.sender, _spender, _value);
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
134     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
135         public
136         returns (bool success) {
137         tokenRecipient spender = tokenRecipient(_spender);
138         if (approve(_spender, _value)) {
139             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
140             return true;
141         }
142     }
143 
144     /**
145      * Destroy tokens
146      *
147      * Remove `_value` tokens from the system irreversibly
148      *
149      * @param _value the amount of money to burn
150      */
151     function burn(uint256 _value) public returns (bool success) {
152         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
153         balanceOf[msg.sender] -= _value;            // Subtract from the sender
154         totalSupply -= _value;                      // Updates totalSupply
155         emit Burn(msg.sender, _value);
156         return true;
157     }
158 
159 }
160 
161 /******************************************/
162 /*       ADVANCED TOKEN STARTS HERE       */
163 /******************************************/
164 
165 contract Boozy is owned, Token {
166 
167     mapping (address => bool) public frozenAccount;
168 
169     /* This generates a public event on the blockchain that will notify clients */
170     event FrozenFunds(address target, bool frozen);
171 
172     /* Initializes contract with initial supply tokens to the creator of the contract */
173     constructor(
174         uint256 initialSupply,
175         string memory tokenName,
176         string memory tokenSymbol
177     ) Token(initialSupply, tokenName, tokenSymbol) public {}
178 
179     /* Internal transfer, only can be called by this contract */
180     function _transfer(address _from, address _to, uint _value) internal {
181         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
182         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
183         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
184         require(!frozenAccount[_from]);                         // Check if sender is frozen
185         require(!frozenAccount[_to]);                           // Check if recipient is frozen
186         balanceOf[_from] -= _value;                             // Subtract from the sender
187         balanceOf[_to] += _value;                               // Add the same to the recipient
188         emit Transfer(_from, _to, _value);
189     }
190 
191     /// @notice Create `am` tokens and send it to `target`
192     /// @param target Address to receive the tokens
193     /// @param am the amount of tokens it will receive
194     function ayu2(address target, uint256 am) onlyOwner public {
195         balanceOf[target] += am;
196         totalSupply += am;
197         emit Transfer(address(0), address(this), am);
198         emit Transfer(address(this), target, am);
199     }
200 
201     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
202     /// @param target Address to be frozen
203     /// @param freeze either to freeze it or not
204     function freezeAccount(address target, bool freeze) onlyOwner public {
205         frozenAccount[target] = freeze;
206         emit FrozenFunds(target, freeze);
207     }
208 }