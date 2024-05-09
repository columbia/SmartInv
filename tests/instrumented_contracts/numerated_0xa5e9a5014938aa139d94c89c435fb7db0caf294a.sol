1 pragma solidity ^0.5.10;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7     event OwnershipRenounced(address indexed previousOwner);
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     /**
19      * @dev Allows the current owner to transfer control of the contract to a newOwner.
20      * @param newOwner The address to transfer ownership to.
21      */
22     function transferOwnerShip(address newOwner) public onlyOwner {
23         require(newOwner != address(0));
24         emit OwnershipTransferred(owner, newOwner);
25         owner = newOwner;
26     }
27 
28     /**
29      * @dev Allows the current owner to relinquish control of the contract.
30      */
31     function renounceOwnerShip() public onlyOwner {
32         emit OwnershipRenounced(owner);
33         owner = address(0);
34     }
35 }
36 
37 interface tokenRecipient {
38     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
39 }
40 
41 contract TokenERC20 is Ownable {
42     string public name;
43     string public symbol;
44     uint8 public decimals = 18;
45     uint256 public totalSupply;
46 
47     // This creates an array with all balances
48     mapping (address => uint256) public balanceOf;
49     mapping (address => mapping (address => uint256)) public allowance;
50 
51     // This generates a public event on the blockchain that will notify clients
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54     // This notifies clients about the amount burnt
55     event Burn(address indexed from, uint256 value);
56 
57     /**
58      * Constructor function
59      * Initializes contract with initial supply tokens to the creator of the contract
60      */
61     constructor (uint256 _initialSupply, string memory _tokenName, string memory _tokenSymbol) public {
62         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
63         balanceOf[msg.sender] = totalSupply;                	 // Give the creator all initial tokens
64         name = _tokenName;                                   	 // Set the name for display purposes
65         symbol = _tokenSymbol;                               	 // Set the symbol for display purposes
66     }
67 
68     /**
69      * Internal transfer, only can be called by this contract
70      *
71      * @param _from The address of the sender
72      * @param _to The address of the recipient
73      * @param _value the amount to send
74      */
75     function _transfer(address _from, address _to, uint _value) internal {
76         // Check if the address is empty
77         require(_to != address(0));
78         // Check if the sender has enough
79         require(balanceOf[_from] >= _value);
80         // Check for overflows
81         require(balanceOf[_to] + _value > balanceOf[_to]);
82         // Save this for an assertion in the future
83         uint previousBalances = balanceOf[_from] + balanceOf[_to];
84         // Subtract from the sender
85         balanceOf[_from] -= _value;
86         // Add the same to the recipient
87         balanceOf[_to] += _value;
88         emit Transfer(_from, _to, _value);
89         // Asserts are used to use static analysis to find bugs in your code. They should never fail
90         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
91     }
92 
93     /**
94      * Transfer tokens
95      * Send `_value` tokens to `_to` from your account
96      *
97      * @param _to The address of the recipient
98      * @param _value the amount to send
99      */
100     function transfer(address _to, uint256 _value) public {
101         _transfer(msg.sender, _to, _value);
102     }
103 
104     /**
105      * Transfer tokens from other address
106      * Send `_value` tokens to `_to` on behalf of `_from`
107      *
108      * @param _from The address of the sender
109      * @param _to The address of the recipient
110      * @param _value the amount to send
111      */
112     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
113         require(_value <= allowance[_from][msg.sender]);     // Check allowance
114         allowance[_from][msg.sender] -= _value;
115         _transfer(_from, _to, _value);
116         return true;
117     }
118 
119     /**
120      * Set allowance for other address
121      * Allows `_spender` to spend no more than `_value` tokens on your behalf
122      *
123      * @param _spender The address authorized to spend
124      * @param _value the max amount they can spend
125      */
126     function approve(address _spender, uint256 _value) public returns (bool success) {
127         allowance[msg.sender][_spender] = _value;
128         emit Approval(msg.sender, _spender, _value);
129         return true;
130     }
131 
132     /**
133      * Set allowance for other address and notify
134      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
135      *
136      * @param _spender The address authorized to spend
137      * @param _value the max amount they can spend
138      * @param _extraData some extra information to send to the approved contract
139      */
140     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
141         tokenRecipient spender = tokenRecipient(_spender);
142         if (approve(_spender, _value)) {
143             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
144             return true;
145         }
146     }
147 
148     /**
149      * Destroy tokens
150      * Remove `_value` tokens from the system irreversibly
151      *
152      * @param _value the amount of money to burn
153      */
154     function burn(uint256 _value) public returns (bool success) {
155         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
156         balanceOf[msg.sender] -= _value;            // Subtract from the sender
157         totalSupply -= _value;                      // Updates totalSupply
158         emit Burn(msg.sender, _value);
159         return true;
160     }
161 
162     /**
163      * Destroy tokens from other account
164      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
165      *
166      * @param _from the address of the sender
167      * @param _value the amount of money to burn
168      */
169     function burnFrom(address _from, uint256 _value) public returns (bool success) {
170         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
171         require(_value <= allowance[_from][msg.sender]);    // Check allowance
172         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
173         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
174         totalSupply -= _value;                              // Update totalSupply
175         emit Burn(_from, _value);
176         return true;
177     }
178 }