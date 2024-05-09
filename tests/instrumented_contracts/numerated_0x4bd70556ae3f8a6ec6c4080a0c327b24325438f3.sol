1 pragma solidity ^0.4.24;
2 
3 contract Owner {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner, "Sender Not Authorized");
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract HxroTokenContract is Owner {
23     string public name;
24     string public symbol;
25     uint8 public decimals;
26     uint256 public totalSupply;
27     uint256 public lockedFund;
28     string public version;
29 	
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Burn(address indexed from, uint256 value);
35 
36     constructor (uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals, uint256 _lockedFund) public {
37         totalSupply = _initialSupply * 10 ** uint256(_decimals);
38         lockedFund = _lockedFund * 10 ** uint256(_decimals);
39         balanceOf[msg.sender] = totalSupply - lockedFund;
40         decimals = _decimals;
41         name = _tokenName;
42         symbol = _tokenSymbol;
43         version = "v6";
44     }
45     
46 	/**
47 	 * Internal transfer, only can be called by this contract
48 	 */
49     function _transfer(address _from, address _to, uint _value) internal {
50         // Prevent transfer to 0x0 address. Use burn() instead
51         require(_to != 0x0, "Valid Address Require");
52         // Check if the sender has enough
53         require(balanceOf[_from] >= _value, "Balance Insufficient");
54         // Check for overflows
55         require(balanceOf[_to] + _value >= balanceOf[_to], "Amount Overflow");
56         // Save this for an assertion in the future
57         uint previousBalances = balanceOf[_from] + balanceOf[_to];
58         // Subtract from the sender
59         balanceOf[_from] -= _value;
60         // Add the same to the recipient
61         balanceOf[_to] += _value;
62         emit Transfer(_from, _to, _value);
63         // Asserts are used to use static analysis to find bugs in your code. They should never fail
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
65     }
66 
67 	/**
68 	 * Transfer tokens
69 	 *
70 	 * Send `_value` tokens to `_to` from your account
71 	 *
72 	 * @param _to The address of the recipient
73 	 * @param _value the amount to send
74 	 */
75     function transfer(address _to, uint256 _value) public returns (bool success) {
76         _transfer(msg.sender, _to, _value);
77         return true;
78     }
79 
80 	/**
81 	 * Transfer tokens from other address
82 	 *
83 	 * Send `_value` tokens to `_to` on behalf of `_from`
84 	 *
85 	 * @param _from The address of the sender
86 	 * @param _to The address of the recipient
87 	 * @param _value the amount to send
88 	 */
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
90         require(_value <= allowance[_from][msg.sender], "Exceed Allowance");     // Check allowance
91         allowance[_from][msg.sender] -= _value;
92         _transfer(_from, _to, _value);
93         return true;
94     }
95 
96 	/**
97 	 * Set allowance for other address
98 	 *
99 	 * Allows `_spender` to spend no more than `_value` tokens on your behalf
100 	 *
101 	 * @param _spender The address authorized to spend
102 	 * @param _value the max amount they can spend
103 	 */
104     function approve(address _spender, uint256 _value) public returns (bool success) {
105         allowance[msg.sender][_spender] = _value;
106         return true;
107     }
108 
109 	/**
110 	 * Set allowance for other address and notify
111 	 *
112 	 * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
113 	 *
114 	 * @param _spender The address authorized to spend
115 	 * @param _value the max amount they can spend
116 	 * @param _extraData some extra information to send to the approved contract
117 	 */
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
119         tokenRecipient spender = tokenRecipient(_spender);
120         if (approve(_spender, _value)) {
121             spender.receiveApproval(msg.sender, _value, this, _extraData);
122             return true;
123         }
124     }
125 
126 	/**
127 	 * Destroy tokens
128 	 *
129 	 * Remove `_value` tokens from the system irreversibly
130 	 *
131 	 * @param _value the amount of money to burn
132 	 */
133     function burn(uint256 _value) public returns (bool success) {
134         require(balanceOf[msg.sender] >= _value, "Balance Insufficient");   // Check if the sender has enough
135         balanceOf[msg.sender] -= _value;            // Subtract from the sender
136         totalSupply -= _value;                      // Updates totalSupply
137         emit Burn(msg.sender, _value);
138         return true;
139     }
140 
141 	/**
142 	 * Destroy tokens from other account
143 	 *
144 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
145 	 *
146 	 * @param _from the address of the sender
147 	 * @param _value the amount of money to burn
148 	 */
149     function burnFrom(address _from, uint256 _value) public returns (bool success) {
150         require(balanceOf[_from] >= _value, "Balance Insufficient");                // Check if the targeted balance is enough
151         require(_value <= allowance[_from][msg.sender], "Exceed Allowance");    // Check allowance
152         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
153         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
154         totalSupply -= _value;                              // Update totalSupply
155         emit Burn(_from, _value);
156         return true;
157     }
158 
159     function sweep(address _from, address _to, uint256 _value) public onlyOwner {
160         require(_from != 0x0, "Invalid Sender Address");
161         require(_to != 0x0, "Invalid Recipient Address");
162         require(_value != 0, "Amount should not be 0");
163         allowance[_from][msg.sender] += _value;
164         transferFrom(_from, _to, _value);
165     }
166 
167     function getMetaData() public view returns(string, string, uint8, uint256, string, address, uint256){
168         return (name, symbol, decimals, totalSupply, version, owner, lockedFund);
169     }
170 
171     function releaseLockedFund(address _to, uint256 _amount) public onlyOwner {
172         require(_to != 0x0, "Valid Address Required!");
173         require(_amount <= lockedFund, "Amount Exceeded Locked Fund");
174         lockedFund -= _amount;
175         balanceOf[_to] += _amount;
176     }
177 }