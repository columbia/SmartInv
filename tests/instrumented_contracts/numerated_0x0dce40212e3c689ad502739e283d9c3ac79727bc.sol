1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
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
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 8;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32 
33     // This generates a public event on the blockchain that will notify clients
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     // This notifies clients about the amount burnt
37     event Burn(address indexed from, uint256 value);
38 
39     /**
40      * Constrctor function
41      *
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     function TokenERC20(
45         uint256 initialSupply,
46         string tokenName,
47         string tokenSymbol
48     ) public {
49         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
50         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
51         name = tokenName;                                   // Set the name for display purposes
52         symbol = tokenSymbol;                               // Set the symbol for display purposes
53     }
54 
55     /**
56      * Internal transfer, only can be called by this contract
57      */
58     function _transfer(address _from, address _to, uint _value) internal {
59         // Prevent transfer to 0x0 address. Use burn() instead
60         require(_to != 0x0);
61         // Check if the sender has enough
62         require(balanceOf[_from] >= _value);
63         // Check for overflows
64         require(balanceOf[_to] + _value > balanceOf[_to]);
65         // Save this for an assertion in the future
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];
67         // Subtract from the sender
68         balanceOf[_from] -= _value;
69         // Add the same to the recipient
70         balanceOf[_to] += _value;
71         emit Transfer(_from, _to, _value);
72         // Asserts are used to use static analysis to find bugs in your code. They should never fail
73         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74     }
75 
76     /**
77      * Transfer tokens
78      *
79      * Send `_value` tokens to `_to` from your account
80      *
81      * @param _to The address of the recipient
82      * @param _value the amount to send
83      */
84     function transfer(address _to, uint256 _value) public {
85         _transfer(msg.sender, _to, _value);
86     }
87     
88     /**
89      * Destroy tokens
90      *
91      * Remove `_value` tokens from the system irreversibly
92      *
93      * @param _value the amount of money to burn
94      */
95     function burn(uint256 _value) internal returns (bool success) {
96         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
97         balanceOf[msg.sender] -= _value;            // Subtract from the sender
98         totalSupply -= _value;                      // Updates totalSupply
99         emit Burn(msg.sender, _value);
100         return true;
101     }
102 }
103 
104 /******************************************/
105 /*       ADVANCED TOKEN STARTS HERE       */
106 /******************************************/
107 
108 contract MasterNet is owned, TokenERC20 {
109 
110     /* Initializes contract with initial supply tokens to the creator of the contract */
111     function MasterNet(
112         uint256 initialSupply,
113         string tokenName,
114         string tokenSymbol
115     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
116 
117     /* Internal transfer, only can be called by this contract */
118     function _transfer(address _from, address _to, uint _value) internal {
119         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
120         require (balanceOf[_from] >= _value);               // Check if the sender has enough
121         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
122         balanceOf[_from] -= _value;                         // Subtract from the sender
123         balanceOf[_to] += _value;                           // Add the same to the recipient
124         emit Transfer(_from, _to, _value);
125     }
126 
127     function burnToken(uint256 _value) onlyOwner public returns (bool success) {
128         return burn(_value);
129     }
130 }