1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     
7     // Owner of this contract
8      address public owner = msg.sender;
9  
10     // Public variables of the token
11     string public name;
12     string public symbol;
13     uint8 public decimals = 18;
14     uint256 public totalSupply;
15 
16     // This creates an array with all balances
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     // This generates a public event on the blockchain that will notify clients
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     // This notifies clients about the amount burnt
24     event Burn(address indexed from, uint256 value);
25 
26     function TokenERC20(
27 
28         uint256 initialSupply,
29         string tokenName,
30         string tokenSymbol
31 
32     ) public {
33 
34         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
35         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
36         name = tokenName;                                   // Set the name for display purposes
37         symbol = tokenSymbol;                               // Set the symbol for display purposes
38 
39     }
40 
41     function _transfer(address _from, address _to, uint _value) internal {
42 
43         // Prevent transfer to 0x0 address. Use burn() instead
44         require(_to != 0x0);
45 
46         // Check if the sender has enough balance
47         require(balanceOf[_from] >= _value);
48 
49         // Check for overflows
50         require(balanceOf[_to] + _value > balanceOf[_to]);
51 
52         // Save this for an assertion in the future
53         uint previousBalances = balanceOf[_from] + balanceOf[_to];
54 
55         // Subtract from the sender
56         balanceOf[_from] -= _value;
57 
58         // Add the same to the recipient
59         balanceOf[_to] += _value;
60         Transfer(_from, _to, _value);
61 
62         // Asserts are used to use static analysis to find bugs in your code. They should never fail
63         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
64     }
65 
66     function transfer(address _to, uint256 _value) public {
67         _transfer(msg.sender, _to, _value);
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
71         require(_value <= allowance[_from][msg.sender]);     // Check allowance
72         allowance[_from][msg.sender] -= _value;
73         _transfer(_from, _to, _value);
74         return true;
75     }
76 
77     function approve(address _spender, uint256 _value) public
78         returns (bool success) {
79         allowance[msg.sender][_spender] = _value;
80         return true;
81     }
82 
83     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
84         public
85         returns (bool success) {
86         tokenRecipient spender = tokenRecipient(_spender);
87         if (approve(_spender, _value)) {
88             spender.receiveApproval(msg.sender, _value, this, _extraData);
89             return true;
90         }
91     }
92 
93     function burn(uint256 _value) public returns (bool success) {
94         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
95         balanceOf[msg.sender] -= _value;            // Subtract from the sender
96         totalSupply -= _value;                      // Updates totalSupply
97         Burn(msg.sender, _value);
98         return true;
99     }
100 
101     function burnFrom(address _from, uint256 _value) public returns (bool success) {
102         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
103         require(_value <= allowance[_from][msg.sender]);    // Check allowance
104         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
105         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
106         totalSupply -= _value;                              // Update totalSupply
107         Burn(_from, _value);
108         return true;
109     }
110 }