1 pragma solidity  ^ 0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract RICHERC20 {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 8;
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
23     function RICHERC20 (
24         uint256 initialSupply,
25         string tokenName,
26         string tokenSymbol
27     ) public {
28         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
29         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
30         name = tokenName;                                   // Set the name for display purposes
31         symbol = tokenSymbol;                               // Set the symbol for display purposes
32     }
33 
34     function _transfer(address _from, address _to, uint _value) internal {
35         // Prevent transfer to 0x0 address. Use burn() instead
36         require(_to != 0x0);
37         // Check if the sender has enough
38         require(balanceOf[_from] >= _value);
39         // Check for overflows
40         require(balanceOf[_to] + _value > balanceOf[_to]);
41         // Save this for an assertion in the future
42         uint previousBalances = balanceOf[_from] + balanceOf[_to];
43         // Subtract from the sender
44         balanceOf[_from] -= _value;
45         // Add the same to the recipient
46         balanceOf[_to] += _value;
47         Transfer(_from, _to, _value);
48         // Asserts are used to use static analysis to find bugs in your code. They should never fail
49         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
50     }
51 
52     function transfer(address _to, uint256 _value) public {
53         _transfer(msg.sender, _to, _value);
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
57         require(_value <= allowance[_from][msg.sender]);     // Check allowance
58         allowance[_from][msg.sender] -= _value;
59         _transfer(_from, _to, _value);
60         return true;
61     }
62 
63     function approve(address _spender, uint256 _value) public
64         returns (bool success) {
65         allowance[msg.sender][_spender] = _value;
66         return true;
67     }
68 
69     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
70         public
71         returns (bool success) {
72         tokenRecipient spender = tokenRecipient(_spender);
73         if (approve(_spender, _value)) {
74             spender.receiveApproval(msg.sender, _value, this, _extraData);
75             return true;
76         }
77     }
78     function burn(uint256 _value) public returns (bool success) {
79         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
80         balanceOf[msg.sender] -= _value;            // Subtract from the sender
81         totalSupply -= _value;                      // Updates totalSupply
82         Burn(msg.sender, _value);
83         return true;
84     }
85 
86     function burnFrom(address _from, uint256 _value) public returns (bool success) {
87         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
88         require(_value <= allowance[_from][msg.sender]);    // Check allowance
89         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
90         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
91         totalSupply -= _value;                              // Update totalSupply
92         Burn(_from, _value);
93         return true;
94     }
95 }