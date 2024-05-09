1 pragma solidity >=0.4.22 <0.7.0;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
5 }
6 
7 contract KCToken {
8 
9     // Public variables of the token
10     string public name;
11     string public symbol;
12     uint8 public decimals = 18;
13     // 18 decimals is the strongly suggested default, avoid changing it
14     uint256 public totalSupply;
15     address public owner;
16 
17     // This creates an array with all balances
18     mapping(address => uint256) public balanceOf;
19     mapping(address => mapping(address => uint256)) public allowance;
20 
21     // This generates a public event on the blockchain that will notify clients
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     // This generates a public event on the blockchain that will notify clients
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26 
27 
28     /**
29      * Constructor function
30      *
31      * Initializes contract with initial supply tokens to the creator of the contract
32      */
33     constructor(
34         uint256 initialSupply,
35         string memory tokenName,
36         string memory tokenSymbol
37     ) public {
38         totalSupply = initialSupply * 10 ** uint256(decimals);
39         // Update total supply with the decimal amount
40         balanceOf[msg.sender] = totalSupply;
41         // Give the creator all initial tokens
42         name = tokenName;
43         // Set the name for display purposes
44         symbol = tokenSymbol;
45         // Set the symbol for display purposes
46         owner = msg.sender;
47     }
48 
49     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a * b;
51         assert(a == 0 || c / a == b);
52         return c;
53     }
54 
55     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
56         assert(b > 0);
57         uint256 c = a / b;
58         assert(a == b * c + a % b);
59         return c;
60     }
61 
62     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
63         assert(b <= a);
64         return a - b;
65     }
66 
67     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
68         uint256 c = a + b;
69         assert(c >= a && c >= b);
70         return c;
71     }
72 
73     /**
74      * Internal transfer, only can be called by this contract
75      */
76     function _transfer(address _from, address _to, uint _value) internal {
77         // Prevent transfer to 0x0 address. Use burn() instead
78         require(_to != address(0x0));
79         // Check if the sender has enough
80         require(balanceOf[_from] >= _value);
81         // Check for overflows
82         require(balanceOf[_to] + _value >= balanceOf[_to]);
83         // Save this for an assertion in the future
84         uint previousBalances = balanceOf[_from] + balanceOf[_to];
85         // Subtract from the sender
86         balanceOf[_from] -= _value;
87         // Add the same to the recipient
88         balanceOf[_to] += _value;
89         emit Transfer(_from, _to, _value);
90         // Asserts are used to use static analysis to find bugs in your code. They should never fail
91         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
92     }
93 
94     /**
95      * Transfer tokens
96      *
97      * Send `_value` tokens to `_to` from your account
98      *
99      * @param _to The address of the recipient
100      * @param _value the amount to send
101      */
102     function transfer(address _to, uint256 _value) public returns (bool success) {
103         _transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107     /**
108      * Transfer tokens from other address
109      *
110      * Send `_value` tokens to `_to` on behalf of `_from`
111      *
112      * @param _from The address of the sender
113      * @param _to The address of the recipient
114      * @param _value the amount to send
115      */
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
117         require(_value <= allowance[_from][msg.sender]);
118         // Check allowance
119         allowance[_from][msg.sender] -= _value;
120         _transfer(_from, _to, _value);
121         return true;
122     }
123 
124     /**
125      * Set allowance for other address
126      *
127      * Allows `_spender` to spend no more than `_value` tokens on your behalf
128      *
129      * @param _spender The address authorized to spend
130      * @param _value the max amount they can spend
131      */
132     function approve(address _spender, uint256 _value) public
133     returns (bool success) {
134         allowance[msg.sender][_spender] = _value;
135         emit Approval(msg.sender, _spender, _value);
136         return true;
137     }
138 
139     /**
140      * Set allowance for other address and notify
141      *
142      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
143      *
144      * @param _spender The address authorized to spend
145      * @param _value the max amount they can spend
146      * @param _extraData some extra information to send to the approved contract
147      */
148     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
149     public
150     returns (bool success) {
151         tokenRecipient spender = tokenRecipient(_spender);
152         if (approve(_spender, _value)) {
153             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
154             return true;
155         }
156     }
157 
158     //Transfer of ownership,only owner can call this function
159     function transferOwnership(address _address) public returns (bool success){
160         require((msg.sender == owner));
161         _transfer(owner, _address, balanceOf[owner]);
162         owner = _address;
163         return true;
164     }
165 
166 }