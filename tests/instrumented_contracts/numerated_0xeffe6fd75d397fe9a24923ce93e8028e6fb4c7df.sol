1 pragma solidity ^0.4.11;
2 
3 /*
4 Token ini penyempurnaan untuk code pengiriman semua balance
5 */
6 
7 contract owned {
8     address public owner;
9 
10     function owned() {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require (msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner {
20         owner = newOwner;
21     }
22 }
23 
24 contract token {
25     /* Public variables of the token */
26     string public standard = 'Token 0.1';
27     string public name;
28     string public symbol;
29     uint8 public decimals;
30     uint256 public totalSupply;
31 
32     /* This creates an array with all balances */
33     mapping (address => uint256) public balanceOf;
34 
35     /* This generates a public event on the blockchain that will notify clients */
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     /* Initializes contract with initial supply tokens to the creator of the contract */
39     function token(
40         uint256 initialSupply,
41         string tokenName,
42         uint8 decimalUnits,
43         string tokenSymbol
44         ) {
45         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
46         totalSupply = initialSupply;                        // Update total supply
47         name = tokenName;                                   // Set the name for display purposes
48         symbol = tokenSymbol;                               // Set the symbol for display purposes
49         decimals = decimalUnits;                            // Amount of decimals for display purposes
50     }
51 
52 
53 
54 
55 }
56 
57 contract MyAdvancedToken is owned, token {
58 
59     mapping (address => bool) public frozenAccount;
60 
61     /* This generates a public event on the blockchain that will notify clients */
62     event FrozenFunds(address target, bool frozen);
63 
64     /* Initializes contract with initial supply tokens to the creator of the contract */
65     function MyAdvancedToken(
66         uint256 initialSupply,
67         string tokenName,
68         uint8 decimalUnits,
69         string tokenSymbol
70     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
71 
72 
73     function freezeAccount(address target, bool freeze) onlyOwner {
74         require (target != owner);           // owner tidak boleh membekukan dirinya sendiri
75         frozenAccount[target] = freeze;
76         FrozenFunds(target, freeze);
77     }
78 
79     /* Send coins */
80     function transfer(address _to, uint256 _value) {
81         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
82         require (frozenAccount[msg.sender] != true);                 // Mencegah frozen account untuk mengirim
83         require (balanceOf[msg.sender] >= _value);           // Check if the sender has enough
84         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
85         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
86         balanceOf[_to] += _value;                            // Add the same to the recipient
87         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
88     }
89 
90 
91 
92     /* transfer dari akun ke akun tapi yang berhak melakukannya adalah akun itu saja */
93     function transferDari(address _from, address _to, uint256 _value) returns (bool success) {
94         require (_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
95         require (msg.sender == _from);                       // Mencegah user mengirim dari akun lain
96         require (balanceOf[_from] >= _value);                 // Check if the sender has enough
97         require (balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
98         balanceOf[_from] -= _value;                           // Subtract from the sender
99         balanceOf[_to] += _value;                             // Add the same to the recipient
100         Transfer(_from, _to, _value);
101         return true;
102     }
103 
104 }