1 1 pragma solidity ^0.4.16;
2 
3 2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 3 contract MICE {
6 4     // Public variables of the token
7 5     string public name;
8 6     string public symbol;
9 7     uint8 public decimals = 18;
10 8     // 18 decimals is the strongly suggested default, avoid changing it
11 9     uint256 public totalSupply;
12 
13 10     // This creates an array with all balances
14 11     mapping (address => uint256) public balanceOf;
15 12     mapping (address => mapping (address => uint256)) public allowance;
16 
17 13     // This generates a public event on the blockchain that will notify clients
18 14     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20 15     // This notifies clients about the amount burnt
21 16     event Burn(address indexed from, uint256 value);
22 
23   
24 17     function MICE(
25 18         uint256 initialSupply,
26 19         string tokenName,
27 20         string tokenSymbol
28 21     ) public {
29 22         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
30 23         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
31 24         name = tokenName;                                   // Set the name for display purposes
32 25         symbol = tokenSymbol;                               // Set the symbol for display purposes
33 26     }
34 
35 27     function _transfer(address _from, address _to, uint _value) internal {
36 28         // Prevent transfer to 0x0 address. Use burn() instead
37 29         require(_to != 0x0);
38 30         // Check if the sender has enough
39 31         require(balanceOf[_from] >= _value);
40 32         // Check for overflows
41 33         require(balanceOf[_to] + _value >= balanceOf[_to]);
42 34         // Save this for an assertion in the future
43 35         uint previousBalances = balanceOf[_from] + balanceOf[_to];
44 36         // Subtract from the sender
45 37         balanceOf[_from] -= _value;
46 38         // Add the same to the recipient
47 39         balanceOf[_to] += _value;
48 40         emit Transfer(_from, _to, _value);
49 41         // Asserts are used to use static analysis to find bugs in your code. They should never fail
50 42         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51 43     }
52 
53 
54 44     function transfer(address _to, uint256 _value) public {
55 45         _transfer(msg.sender, _to, _value);
56 46     }
57 
58 
59 47     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
60 48         require(_value <= allowance[_from][msg.sender]);     // Check allowance
61 49         allowance[_from][msg.sender] -= _value;
62 50         _transfer(_from, _to, _value);
63 51         return true;
64 52     }
65 
66 53     function approve(address _spender, uint256 _value) public
67 54         returns (bool success) {
68 55         allowance[msg.sender][_spender] = _value;
69 56         return true;
70 57     }
71 
72   
73 58     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
74 59         public
75 60         returns (bool success) {
76 61         tokenRecipient spender = tokenRecipient(_spender);
77 62         if (approve(_spender, _value)) {
78 63             spender.receiveApproval(msg.sender, _value, this, _extraData);
79 64             return true;
80 65         }
81 66     }
82 
83 
84 67     function burn(uint256 _value) public returns (bool success) {
85 68         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
86 69         balanceOf[msg.sender] -= _value;            // Subtract from the sender
87 70         totalSupply -= _value;                      // Updates totalSupply
88 71         emit Burn(msg.sender, _value);
89 72         return true;
90 73     }
91 
92 74     function burnFrom(address _from, uint256 _value) public returns (bool success) {
93 75         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
94 76         require(_value <= allowance[_from][msg.sender]);    // Check allowance
95 77         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
96 78         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
97 79         totalSupply -= _value;                              // Update totalSupply
98 80         emit Burn(_from, _value);
99 81         return true;
100 82     }
101 83 }