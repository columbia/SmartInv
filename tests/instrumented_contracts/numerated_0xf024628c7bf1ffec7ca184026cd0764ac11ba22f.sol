1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract ClickGemTokenERC20 {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23     
24     function ClickGemTokenERC20(
25         uint256 initialSupply,
26         string tokenName,
27         string tokenSymbol
28     ) public {
29         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
30         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
31         name = tokenName;                                   // Set the name for display purposes
32         symbol = tokenSymbol;                               // Set the symbol for display purposes
33     }
34 
35     
36     function _transfer(address _from, address _to, uint _value) internal {
37         // Prevent transfer to 0x0 address. Use burn() instead
38         require(_to != 0x0);
39         // Check if the sender has enough
40         require(balanceOf[_from] >= _value);
41         // Check for overflows
42         require(balanceOf[_to] + _value >= balanceOf[_to]);
43         // Save this for an assertion in the future
44         uint previousBalances = balanceOf[_from] + balanceOf[_to];
45         // Subtract from the sender
46         balanceOf[_from] -= _value;
47         // Add the same to the recipient
48         balanceOf[_to] += _value;
49         emit Transfer(_from, _to, _value);
50         // Asserts are used to use static analysis to find bugs in your code. They should never fail
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53 
54     
55     function transfer(address _to, uint256 _value) public {
56         _transfer(msg.sender, _to, _value);
57     }
58 
59     
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
61         require(_value <= allowance[_from][msg.sender]);     // Check allowance
62         allowance[_from][msg.sender] -= _value;
63         _transfer(_from, _to, _value);
64         return true;
65     }
66 
67     
68     function approve(address _spender, uint256 _value) public
69         returns (bool success) {
70         allowance[msg.sender][_spender] = _value;
71         return true;
72     }
73 
74     
75     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
76         public
77         returns (bool success) {
78         tokenRecipient spender = tokenRecipient(_spender);
79         if (approve(_spender, _value)) {
80             spender.receiveApproval(msg.sender, _value, this, _extraData);
81             return true;
82         }
83     }
84 
85   
86     function burn(uint256 _value) public returns (bool success) {
87         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
88         balanceOf[msg.sender] -= _value;            // Subtract from the sender
89         totalSupply -= _value;                      // Updates totalSupply
90         emit Burn(msg.sender, _value);
91         return true;
92     }
93 
94     
95     function burnFrom(address _from, uint256 _value) public returns (bool success) {
96         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
97         require(_value <= allowance[_from][msg.sender]);    // Check allowance
98         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
99         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
100         totalSupply -= _value;                              // Update totalSupply
101         emit Burn(_from, _value);
102         return true;
103     }
104 }