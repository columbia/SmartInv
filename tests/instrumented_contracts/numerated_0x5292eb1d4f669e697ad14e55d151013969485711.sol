1 pragma solidity ^0.4.16;    // Versão Compilador v0.4.16+commit.d7661dd9 - Runs (Optimiser):200 - Optimization Enabled:	No
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
3 contract WorkValley {
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint8 public decimals = 8;
8 
9     uint256 public totalSupply;
10 
11     // This creates an array with all balances
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     // This generates a public event on the blockchain that will notify clients
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     // This notifies clients about the amount burnt
19     event Burn(address indexed from, uint256 value);
20 
21     function WorkValley(
22 
23 ) public {
24         totalSupply = 1000000000 * 10 ** 8;  //
25         balanceOf[msg.sender] = totalSupply;
26         name = "WorkValley";
27         symbol = "WVT";
28     }
29 
30 
31 
32     function _transfer(address _from, address _to, uint _value) internal {
33         // Prevent transfer to 0x0 address. Use burn() instead
34         require(_to != 0x0);
35         // Check if the sender has enough
36         require(balanceOf[_from] >= _value);
37         // Check for overflows
38         require(balanceOf[_to] + _value > balanceOf[_to]);
39         // Save this for an assertion in the future
40         uint previousBalances = balanceOf[_from] + balanceOf[_to];
41         // Subtract from the sender
42         balanceOf[_from] -= _value;
43         // Add the same to the recipient
44         balanceOf[_to] += _value;
45         Transfer(_from, _to, _value);
46         // Asserts are used to use static analysis to find bugs in your code. They should never fail
47         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
48     }
49 
50 
51     function transfer(address _to, uint256 _value) public {
52         _transfer(msg.sender, _to, _value);
53     }
54 
55 
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
57         require(_value <= allowance[_from][msg.sender]);     // Check allowance
58         allowance[_from][msg.sender] -= _value;
59         _transfer(_from, _to, _value);
60         return true;
61     }
62 
63 
64     function approve(address _spender, uint256 _value) public
65     returns (bool success) {
66         allowance[msg.sender][_spender] = _value;
67         return true;
68     }
69 
70 
71     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
72     public
73     returns (bool success) {
74         tokenRecipient spender = tokenRecipient(_spender);
75         if (approve(_spender, _value)) {
76             spender.receiveApproval(msg.sender, _value, this, _extraData);
77             return true;
78         }
79     }
80 
81     function burn(uint256 _value) public returns (bool success) {
82         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
83         balanceOf[msg.sender] -= _value;            // Subtract from the sender
84         totalSupply -= _value;                      // Updates totalSupply
85         Burn(msg.sender, _value);
86         return true;
87     }
88 
89 
90     function burnFrom(address _from, uint256 _value) public returns (bool success) {
91         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
92         require(_value <= allowance[_from][msg.sender]);    // Check allowance
93         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
94         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
95         totalSupply -= _value;                              // Update totalSupply
96         Burn(_from, _value);
97         return true;
98     }
99 }