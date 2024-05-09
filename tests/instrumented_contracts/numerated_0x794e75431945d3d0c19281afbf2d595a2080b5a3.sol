1 pragma solidity ^0.4.24;
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
15     function transferOwnership(address newOwner) public onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 contract tokenRecipient {
21     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
22 }
23 
24 contract MyToken is owned {
25     /* Public variables of the token */
26     string public name;
27     string public symbol;
28     uint8 public decimals;
29     uint256 public totalSupply;
30 
31     /* This creates an array with all balances */
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     /* This generates a public event on the blockchain that will notify clients */
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     /* This notifies clients about the amount burnt */
39     event Burn(address indexed from, uint256 value);
40 
41     mapping (address => bool) public frozenAccount;
42     event FrozenFunds(address target, bool frozen);
43 
44     function freezeAccount(address target, bool freeze) public onlyOwner {
45         frozenAccount[target] = freeze;
46         emit FrozenFunds(target, freeze);
47     }
48 
49     /* Initializes contract with initial supply tokens to the creator of the contract */
50     constructor(
51         uint256 initialSupply,
52         string tokenName,
53         uint8 decimalUnits,
54         string tokenSymbol,
55         address centralMinter
56         ) public {
57         if (centralMinter != 0) owner = centralMinter;      // 设置所有者
58         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
59         totalSupply = initialSupply;                        // Update total supply
60         name = tokenName;                                   // Set the name for display purposes
61         symbol = tokenSymbol;                               // Set the symbol for display purposes
62         decimals = decimalUnits;                            // Amount of decimals for display purposes
63     }
64 
65     /* Internal transfer, only can be called by this contract */
66     function _transfer(address _from, address _to, uint _value) internal {
67         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
68         require (balanceOf[_from] >= _value);                // Check if the sender has enough
69         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
70         require(!frozenAccount[_from]);
71         balanceOf[_from] -= _value;                         // Subtract from the sender
72         balanceOf[_to] += _value;                            // Add the same to the recipient
73         emit Transfer(_from, _to, _value);
74     }
75 
76     /// @notice Send `_value` tokens to `_to` from your account
77     /// @param _to The address of the recipient
78     /// @param _value the amount to send
79     function transfer(address _to, uint256 _value) public {
80         _transfer(msg.sender, _to, _value);
81     }
82 
83     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
84     /// @param _from The address of the sender
85     /// @param _to The address of the recipient
86     /// @param _value the amount to send
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         require (_value < allowance[_from][msg.sender]);     // Check allowance
89         allowance[_from][msg.sender] -= _value;
90         _transfer(_from, _to, _value);
91         return true;
92     }
93 
94     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
95     /// @param _spender The address authorized to spend
96     /// @param _value the max amount they can spend
97     function approve(address _spender, uint256 _value) public
98         returns (bool success) {
99         allowance[msg.sender][_spender] = _value;
100         return true;
101     }
102 
103     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
104     /// @param _spender The address authorized to spend
105     /// @param _value the max amount they can spend
106     /// @param _extraData some extra information to send to the approved contract
107     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public
108         returns (bool success) {
109         tokenRecipient spender = tokenRecipient(_spender);
110         if (approve(_spender, _value)) {
111             spender.receiveApproval(msg.sender, _value, this, _extraData);
112             return true;
113         }
114     }
115 
116     /// @notice Remove `_value` tokens from the system irreversibly
117     /// @param _value the amount of money to burn
118     function burn(uint256 _value) public returns (bool success) {
119         require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
120         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
121         totalSupply -= _value;                                // Updates totalSupply
122         emit Burn(msg.sender, _value);
123         return true;
124     }
125 
126     function burnFrom(address _from, uint256 _value) public returns (bool success) {
127         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
128         require(_value <= allowance[_from][msg.sender]);    // Check allowance
129         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
130         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
131         totalSupply -= _value;                              // Update totalSupply
132         emit Burn(_from, _value);
133         return true;
134     }
135 }