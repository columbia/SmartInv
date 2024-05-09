1 pragma solidity ^0.4.18;
2 
3 // SafeMath for addition and substraction
4 library SafeMath {
5 
6   /**
7   * @dev Adds two numbers, throws on overflow.
8   */
9     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     c = a + b;
11     assert(c >= a);
12     return c;
13     }
14 
15 /**
16   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
17   */
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21     }
22   
23 }
24 
25 
26 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
27 
28 contract BCSToken {
29     // Use SafeMath library for addition and substraction
30     using SafeMath for uint;
31     // Public variables of the token
32     string public name;
33     string public symbol;
34     uint256 public decimals = 8;
35     uint256 public totalSupply;
36     address private owner;
37     // This creates an array with all balances
38     mapping (address => uint256) public balanceOf;
39     mapping (address => mapping (address => uint256)) public allowance;
40 
41     // This generates a public event on the blockchain that will notify clients
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     // This notifies clients about the amount burnt
45     event Burn(address indexed from, uint256 value);
46 
47     /**
48      * Constructor function
49      *
50      * Initializes contract with initial supply tokens to the creator of the contract
51      */
52     function BCSToken() public {
53     	name = "BlockChainStore Token";                          // Set the name for display purposes
54         symbol = "BCST";                                         // and symbol
55     	uint256 initialSupply = 100000000;			            // 100M	tokens
56         totalSupply = initialSupply * (10 ** uint256(decimals));// 8 digits for mantissa , no safeMath needed here
57         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
58         owner = msg.sender;
59     }
60 
61     /**
62      * Internal transfer, only can be called by this contract
63      */
64     function _transfer(address _from, address _to, uint _value) internal {
65         // Prevent transfer to 0x0 address. Use burn() instead
66         require(_to != 0x0);
67         // Check if the sender has enough
68         require(balanceOf[_from] >= _value);
69         // Check for overflows
70         require(SafeMath.add(balanceOf[_to] ,_value) >= balanceOf[_to]);
71         // Save this for an assertion in the future
72         uint previousBalances = SafeMath.add(balanceOf[_from] , balanceOf[_to]);
73         // Subtract from the sender
74         balanceOf[_from]=SafeMath.sub(balanceOf[_from] , _value);
75         // Add the same to the recipient
76         balanceOf[_to]=SafeMath.add(balanceOf[_to] , _value);
77         emit Transfer(_from, _to, _value);
78         // Asserts are used to use static analysis to find bugs in your code. They should never fail
79         assert(SafeMath.add(balanceOf[_from] , balanceOf[_to]) == previousBalances);
80     }
81 
82     /**
83      * Transfer tokens
84      *
85      * Send `_value` tokens to `_to` from your account
86      *
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transfer(address _to, uint256 _value) public {
91         _transfer(msg.sender, _to, _value);
92     }
93 
94     /**
95      * Transfer tokens from other address
96      *
97      * Send `_value` tokens to `_to` on behalf of `_from`
98      *
99      * @param _from The address of the sender
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
104         require(_value <= allowance[_from][msg.sender]);     // Check allowance
105         allowance[_from][msg.sender]=SafeMath.sub(allowance[_from][msg.sender] , _value);
106         _transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address
112      *
113      * Allows `_spender` to spend no more than `_value` tokens on your behalf
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      */
118     function approve(address _spender, uint256 _value) public
119         returns (bool success) {
120         allowance[msg.sender][_spender] = _value;
121         return true;
122     }
123 
124     /**
125      * Destroy tokens
126      *
127      * Remove `_value` tokens from the system irreversibly
128      *
129      * @param _value the amount of money to burn
130      */
131     function burn(uint256 _value) public returns (bool success) {
132         require(balanceOf[msg.sender] >= _value);                          // Check if the sender has enough
133         require(owner==msg.sender);                                        // Check owner only can destroy
134         balanceOf[msg.sender]=SafeMath.sub(balanceOf[msg.sender],_value);  // Subtract from the sender
135         totalSupply = SafeMath.sub(totalSupply , _value);                  // Updates totalSupply
136         emit Burn(msg.sender, _value);
137         return true;
138     }
139 
140 }