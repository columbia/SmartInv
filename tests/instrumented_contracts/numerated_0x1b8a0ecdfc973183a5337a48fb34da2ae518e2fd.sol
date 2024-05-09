1 pragma solidity 0.4.24;
2 
3 
4 interface TokenRecipient {
5     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
6 }
7 
8 
9 contract TavuxCoin {
10     // Public variables of the token
11     string public name;
12     string public symbol;
13     uint8 public decimals = 2;
14     // 18 decimals is the strongly suggested default, avoid changing it
15     uint256 public totalSupply;
16 
17     // This creates an array with all balances
18     mapping (address => uint256) public balanceOf;
19     mapping (address => mapping (address => uint256)) public allowance;
20 
21     // This generates a public event on the blockchain that will notify clients
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     // This generates a public event on the blockchain that will notify clients
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26 
27     // This notifies clients about the amount burnt
28     event Burn(address indexed from, uint256 value);
29 
30     /**
31      * Constructor function
32      *
33      * Initializes contract with initial supply tokens to the creator of the contract
34      */
35     constructor(
36         uint256 initialSupply,
37         string tokenName,
38         string tokenSymbol
39     ) public {
40         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
41         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
42         name = tokenName;                                   // Set the name for display purposes
43         symbol = tokenSymbol;                               // Set the symbol for display purposes
44     }
45 
46     /**
47      * Internal transfer, only can be called by this contract
48      */
49     function _transfer(address _from, address _to, uint _value) internal {
50         // Prevent transfer to 0x0 address. Use burn() instead
51         require(_to != 0x0);
52         // Check if the sender has enough
53         require(balanceOf[_from] >= _value);
54         // Check for overflows
55         require(balanceOf[_to] + _value >= balanceOf[_to]);
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
67     function transfer(address _to, uint256 _value) public returns (bool success) {
68         _transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         require(_value <= allowance[_from][msg.sender]);     // Check allowance
74         allowance[_from][msg.sender] -= _value;
75         _transfer(_from, _to, _value);
76         return true;
77     }
78 
79     function approve(address _spender, uint256 _value) public
80     returns (bool success) {
81         allowance[msg.sender][_spender] = _value;
82         emit Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
87     public
88     returns (bool success) {
89         TokenRecipient spender = TokenRecipient(_spender);
90         if (approve(_spender, _value)) {
91             spender.receiveApproval(msg.sender, _value, this, _extraData);
92             return true;
93         }
94     }
95 
96     function burn(uint256 _value) public returns (bool success) {
97         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
98         balanceOf[msg.sender] -= _value;            // Subtract from the sender
99         totalSupply -= _value;                      // Updates totalSupply
100         emit Burn(msg.sender, _value);
101         return true;
102     }
103 
104     function burnFrom(address _from, uint256 _value) public returns (bool success) {
105         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
106         require(_value <= allowance[_from][msg.sender]);    // Check allowance
107         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
108         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
109         totalSupply -= _value;                              // Update totalSupply
110         emit Burn(_from, _value);
111         return true;
112     }
113 }