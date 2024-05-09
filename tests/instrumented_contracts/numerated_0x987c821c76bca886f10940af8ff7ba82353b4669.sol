1 pragma solidity ^0.4.10;
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
15     function transferOwnership(address newOwner) public onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 contract TPLAYToken is owned {
21 
22     // Public variables of the token
23     string public name;
24     string public symbol;
25     uint8 public decimals;
26     uint256 public totalSupply;
27 
28     // This creates an array with all balances
29     mapping (address => uint256) public balanceOf;
30     // This creates an array with frozen accounts
31     mapping (address => bool) public frozenAccount;
32 
33     // This generates a public event on the blockchain that will notify clients
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event FrozenFunds(address target, bool frozen);
36 
37     /**
38      * Constructor function
39      *
40      * Initializes contract with initial supply tokens to the creator of the contract
41      */
42     function TPLAYToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
43         balanceOf[msg.sender] = initialSupply;    // Give the creator all initial tokens
44         totalSupply = initialSupply;
45         name = tokenName;                         // Set the name for display purposes
46         symbol = tokenSymbol;                     // Set the symbol for display purposes
47         decimals = decimalUnits;                  // Amount of decimals for display purposes
48         owner = msg.sender;      		// used to set the owner of the contract
49     }
50 
51     function () {
52         //if ether is sent to this address, send it back.
53         revert();
54     }
55 
56     /**
57      * Transfer tokens
58      *
59      * Send `_value` tokens to `_to` from your account
60      *
61      * @param _to The address of the recipient
62      * @param _value the amount to send
63      */
64     function transfer(address _to, uint256 _value) public {
65         _transfer(msg.sender, _to, _value);
66     }
67 
68     /**
69      * Internal transfer, only can be called by this contract
70      */
71     function _transfer(address _from, address _to, uint _value) internal {
72         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
73         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
74         require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
75         require(!frozenAccount[_from]);                     // Check if sender is frozen
76         require(!frozenAccount[_to]);                       // Check if recipient is frozen
77         balanceOf[_from] -= _value;                         // Subtract from the sender
78         balanceOf[_to] += _value;                           // Add the same to the recipient
79         Transfer(_from, _to, _value);
80     }
81 
82     //if want to issue or remove tokens from circulation
83     function mintToken(address target, uint256 mintedAmount) public onlyOwner {
84         balanceOf[target] += mintedAmount;
85         totalSupply += mintedAmount;
86         Transfer(0, owner, mintedAmount);
87         Transfer(owner, target, mintedAmount);
88     }
89 
90     /**
91      * Destroy tokens
92      *
93      * Remove `_value` tokens from the system irreversibly
94      *
95      * @param _value the amount of money to burn
96      */
97     function burn(uint256 _value)  public onlyOwner returns (bool success) {
98         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
99         balanceOf[msg.sender] -= _value;            // Subtract from the sender
100         totalSupply -= _value;                      // Updates totalSupply
101         return true;
102     }
103 
104 
105 }