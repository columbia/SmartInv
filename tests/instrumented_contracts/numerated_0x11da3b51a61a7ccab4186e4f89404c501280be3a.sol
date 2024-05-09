1 pragma solidity ^0.5.9;
2 
3 contract owned {
4     address public owner;
5 
6     constructor () public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnerShip(address newOwer) public onlyOwner {
16         owner = newOwer;
17     }
18 }
19 
20 interface tokenRecipient {
21 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
22 }
23 
24 contract TokenERC20 {
25     string public name;
26     string public symbol;
27     uint8 public decimals = 9;
28 	uint256 public totalSupply;
29 	
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 	
40     /**
41      * Constructor function
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     constructor (uint256 _initialSupply, string memory _tokenName, string memory _tokenSymbol) public {
45         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
46         balanceOf[msg.sender] = totalSupply;                	 // Give the creator all initial tokens
47         name = _tokenName;                                   	 // Set the name for display purposes
48         symbol = _tokenSymbol;                               	 // Set the symbol for display purposes
49     }
50 	
51     /**
52      * Internal transfer, only can be called by this contract
53      */
54     function _transfer(address _from, address _to, uint _value) internal {
55         // Prevent transfer to 0x0 address. Use burn() instead
56         require(_to != address(0x0));
57         // Check if the sender has enough
58         require(balanceOf[_from] >= _value);
59         // Check for overflows
60         require(balanceOf[_to] + _value > balanceOf[_to]);
61         // Save this for an assertion in the future
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63         // Subtract from the sender
64         balanceOf[_from] -= _value;
65         // Add the same to the recipient
66         balanceOf[_to] += _value;
67         emit Transfer(_from, _to, _value);
68         // Asserts are used to use static analysis to find bugs in your code. They should never fail
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70     }
71 	
72     /**
73      * Transfer tokens
74      * Send `_value` tokens to `_to` from your account
75      *
76      * @param _to The address of the recipient
77      * @param _value the amount to send
78      */
79     function transfer(address _to, uint256 _value) public {
80         _transfer(msg.sender, _to, _value);
81     }
82 
83     /**
84      * Transfer tokens from other address
85      * Send `_value` tokens to `_to` on behalf of `_from`
86      *
87      * @param _from The address of the sender
88      * @param _to The address of the recipient
89      * @param _value the amount to send
90      */
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         require(_value <= allowance[_from][msg.sender]);     // Check allowance
93         allowance[_from][msg.sender] -= _value;
94         _transfer(_from, _to, _value);
95         return true;
96     }
97 
98     /**
99      * Set allowance for other address
100      * Allows `_spender` to spend no more than `_value` tokens on your behalf
101      *
102      * @param _spender The address authorized to spend
103      * @param _value the max amount they can spend
104      */
105     function approve(address _spender, uint256 _value) public
106         returns (bool success) {
107         allowance[msg.sender][_spender] = _value;
108 		emit Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     /**
113      * Set allowance for other address and notify
114      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
115      *
116      * @param _spender The address authorized to spend
117      * @param _value the max amount they can spend
118      * @param _extraData some extra information to send to the approved contract
119      */
120     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
121         public
122         returns (bool success) {
123         tokenRecipient spender = tokenRecipient(_spender);
124         if (approve(_spender, _value)) {
125             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
126             return true;
127         }
128     }
129 
130     /**
131      * Destroy tokens
132      * Remove `_value` tokens from the system irreversibly
133      *
134      * @param _value the amount of money to burn
135      */
136     function burn(uint256 _value) public returns (bool success) {
137         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
138         balanceOf[msg.sender] -= _value;            // Subtract from the sender
139         totalSupply -= _value;                      // Updates totalSupply
140         emit Burn(msg.sender, _value);
141         return true;
142     }
143 
144     /**
145      * Destroy tokens from other account
146      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
147      *
148      * @param _from the address of the sender
149      * @param _value the amount of money to burn
150      */
151     function burnFrom(address _from, uint256 _value) public returns (bool success) {
152         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
153         require(_value <= allowance[_from][msg.sender]);    // Check allowance
154         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
155         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
156         totalSupply -= _value;                              // Update totalSupply
157         emit Burn(_from, _value);
158         return true;
159     }
160 }