1 pragma solidity ^0.4.2;
2 
3 contract CON0217 {
4     /* Public variables of the token */
5     string public standard = 'Консервативный от 02.2017';
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     uint256 public totalSupply;
10 
11 
12     address public owner;
13 
14     
15 
16     modifier onlyOwner {
17         if (msg.sender != owner) throw;
18         _;
19     }
20 
21     function transferOwnership(address newOwner) onlyOwner {
22         owner = newOwner;
23     }
24     
25     /* This creates an array with all balances */
26     mapping (address => uint256) public balanceOf;
27     mapping (address => mapping (address => uint256)) public allowance;
28 
29     /* This generates a public event on the blockchain that will notify clients */
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     /* Initializes contract with initial supply tokens to the creator of the contract */
33     function CON0217() {
34         if (owner!=0) throw;
35         owner = msg.sender;
36         balanceOf[msg.sender] = 0;              // Give the creator all initial tokens
37         totalSupply = 0;                        // Update total supply
38         name = 'CON0217';                                   // Set the name for display purposes
39         symbol = 'CON';                               // Set the symbol for display purposes
40         decimals = 0;                            // Amount of decimals for display purposes
41     }
42 
43     /* Send coins */
44     function transfer(address _to, uint256 _value) {
45         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
46         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
47         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
48         balanceOf[_to] += _value;                            // Add the same to the recipient
49         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
50     }
51 
52     /* Allow another contract to spend some tokens in your behalf */
53     function approve(address _spender, uint256 _value)
54         returns (bool success) {
55         allowance[msg.sender][_spender] = _value;
56         return true;
57     }
58 
59      
60 
61     /* A contract attempts to get the coins */
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
64         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
65         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
66         balanceOf[_from] -= _value;                          // Subtract from the sender
67         balanceOf[_to] += _value;                            // Add the same to the recipient
68         allowance[_from][msg.sender] -= _value;
69         Transfer(_from, _to, _value);
70         return true;
71     }
72     function mintToken(uint256 mintedAmount) onlyOwner {
73         balanceOf[owner] += mintedAmount;
74         totalSupply += mintedAmount;
75         Transfer(0, owner, mintedAmount);
76     }
77     /* This unnamed function is called whenever someone tries to send ether to it */
78     function () {
79         throw;     // Prevents accidental sending of ether
80     }
81 }