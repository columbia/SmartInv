1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 contract GEDADIC {
8     // Public variables of the token
9     string public name;
10     string public symbol;
11     string public site;
12     uint8 public decimals = 18;
13     // 18 decimals is the strongly suggested default, avoid changing it
14     uint256 public totalSupply;
15     uint256 public cotiniCentavos;
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
27 
28     /**
29      * Constructor function
30      *
31      * Initializes contract with initial supply tokens to the creator of the contract
32      */
33     constructor(
34         uint256 initialSupply
35     ) public {
36         initialSupply = 1000000000000;
37         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
38         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
39         name = "GED ADIC";                                   // Set the name for display purposes
40         symbol = "GED";                               // Set the symbol for display purposes
41         site = "gedadic.grupoestopadoppelganger.com";
42         cotiniCentavos = 100;
43     }
44 
45     /**
46      * Internal transfer, only can be called by this contract
47      */
48     function _transfer(address _from, address _to, uint _value) internal {
49         // Prevent transfer to 0x0 address. Use burn() instead
50         require(_to != address(0x0));
51         // Check if the sender has enough
52         require(balanceOf[_from] >= _value);
53         // Check for overflows
54         require(balanceOf[_to] + _value >= balanceOf[_to]);
55         // Save this for an assertion in the future
56         uint previousBalances = balanceOf[_from] + balanceOf[_to];
57         // Subtract from the sender
58         balanceOf[_from] -= _value;
59         // Add the same to the recipient
60         balanceOf[_to] += _value;
61         emit Transfer(_from, _to, _value);
62         // Asserts are used to use static analysis to find bugs in your code. They should never fail
63         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
64     }
65 
66     /**
67      * Transfer tokens
68      *
69      * Send `_value` tokens to `_to` from your account
70      *
71      * @param _to The address of the recipient
72      * @param _value the amount to send
73      */
74     function transfer(address _to, uint256 _value) public returns (bool success) {
75         _transfer(msg.sender, _to, _value);
76         return true;
77     }
78 
79     /**
80      * Transfer tokens from other address
81      *
82      * Send `_value` tokens to `_to` on behalf of `_from`
83      *
84      * @param _from The address of the sender
85      * @param _to The address of the recipient
86      * @param _value the amount to send
87      */
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
89         require(_value <= allowance[_from][msg.sender]);     // Check allowance
90         allowance[_from][msg.sender] -= _value;
91         _transfer(_from, _to, _value);
92         return true;
93     }
94 
95     /**
96      * Set allowance for other address
97      *
98      * Allows `_spender` to spend no more than `_value` tokens on your behalf
99      *
100      * @param _spender The address authorized to spend
101      * @param _value the max amount they can spend
102      */
103     function approve(address _spender, uint256 _value) public
104         returns (bool success) {
105         allowance[msg.sender][_spender] = _value;
106         emit Approval(msg.sender, _spender, _value);
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address and notify
112      *
113      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      * @param _extraData some extra information to send to the approved contract
118      */
119     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
120         public
121         returns (bool success) {
122         tokenRecipient spender = tokenRecipient(_spender);
123         if (approve(_spender, _value)) {
124             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
125             return true;
126         }
127     }
128 
129 }