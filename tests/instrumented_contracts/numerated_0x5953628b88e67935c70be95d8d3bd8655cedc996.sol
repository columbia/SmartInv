1 pragma solidity ^0.4.13; 
2 contract Owned { 
3     address public owner;
4     function Owned() {
5       owner = msg.sender;
6   }
7 
8   modifier onlyOwner {
9       require(msg.sender == owner);
10       _;
11   }
12 
13   function transferOwnership(address newOwner) onlyOwner {
14       owner = newOwner;
15   }
16 }
17 
18 contract Token {
19     /* Public variables of the token */ 
20     string public name; 
21     string public symbol; 
22     uint8 public decimals; 
23     uint256 public totalSupply;      
24     /* This creates an array with all balances */    
25     mapping (address => uint256) public balanceOf;
26   
27   /* This generates a public event on the blockchain that will notify clients */
28   event Transfer(address indexed from, address indexed to, uint256 value);
29 
30   /* This notifies clients about the amount burnt */
31   event Burn(address indexed from, uint256 value);
32 
33   /* Initializes contract with initial supply tokens to the creator of the contract */
34   function Token(
35       uint256 initialSupply,
36       string tokenName,
37       uint8 decimalUnits,
38       string tokenSymbol
39       ) {
40       balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
41       totalSupply = initialSupply;                        // Update total supply
42       name = tokenName;                                   // Set the name for display purposes
43       symbol = tokenSymbol;                               // Set the symbol for display purposes
44       decimals = decimalUnits;                            // Amount of decimals for display purposes      
45   }
46 
47   /* Internal transfer, only can be called by this contract */
48   function _transfer(address _from, address _to, uint _value) internal {
49       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
50       require (balanceOf[_from] >= _value);                // Check if the sender has enough
51       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
52       balanceOf[_from] -= _value;                         // Subtract from the sender
53       balanceOf[_to] += _value;                            // Add the same to the recipient
54       Transfer(_from, _to, _value);
55   }
56 
57   /// @notice Send `_value` tokens to `_to` from your account
58   /// @param _to The address of the recipient
59   /// @param _value the amount to send
60   function transfer(address _to, uint256 _value) {       
61       _transfer(msg.sender, _to, _value);
62   }
63     
64   /// @notice Remove `_value` tokens from the system irreversibly
65   /// @param _value the amount of money to burn
66   function burn(uint256 _value) returns (bool success) {
67       require (balanceOf[msg.sender] >= _value);            // Check if the sender has enough
68       balanceOf[msg.sender] -= _value;                      // Subtract from the sender
69       totalSupply -= _value;                                // Updates totalSupply
70       Burn(msg.sender, _value);
71       return true;
72   } 
73 }
74 
75 contract BiteduToken is Owned, Token {  
76   mapping (address => bool) public frozenAccount;
77 
78   /* This generates a public event on the blockchain that will notify clients */
79   event FrozenFunds(address target, bool frozen);
80 
81   /* Initializes contract with initial supply tokens to the creator of the contract */
82   function BiteduToken() Token (29000000, "BITEDU", 0, "BTEU") {
83       
84   }
85 
86  /* Internal transfer, only can be called by this contract */
87   function _transfer(address _from, address _to, uint _value) internal {      
88       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
89       require (balanceOf[_from] >= _value);                // Check if the sender has enough
90       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
91       require(!frozenAccount[_from]);                     // Check if sender is frozen
92       require(!frozenAccount[_to]);                       // Check if recipient is frozen
93       balanceOf[_from] -= _value;                         // Subtract from the sender
94       balanceOf[_to] += _value;                           // Add the same to the recipient      
95       Transfer(_from, _to, _value);
96   }
97 
98   /* Internal transfer, only can be called by this contract */
99   function _transferFrom(address _from, address _to, uint256 _value) internal {            
100       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
101       require (balanceOf[_from] >= _value);                // Check if the sender has enough
102       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
103       require(!frozenAccount[_from]);                     // Check if sender is frozen
104       require(!frozenAccount[_to]);                       // Check if recipient is frozen
105       balanceOf[_from] -= _value;                         // Subtract from the sender
106       balanceOf[_to] += _value;                           // Add the same to the recipient         
107       Transfer(_from, _to, _value);
108   }
109   /// @notice Send `_value` tokens to `_to` in behalf of `_from`
110   /// @param _from The address of the sender
111   /// @param _to The address of the recipient
112   /// @param _value the amount to send
113   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {                   
114       _transferFrom(_from, _to, _value);
115       return true;
116   }
117   /// @notice Create `mintedAmount` tokens and send it to `target`
118   /// @param target Address to receive the tokens
119   /// @param mintedAmount the amount of tokens it will receive
120   function mintToken(address target, uint256 mintedAmount) onlyOwner {
121       balanceOf[target] += mintedAmount;
122       totalSupply += mintedAmount;
123       Transfer(0, this, mintedAmount);
124       Transfer(this, target, mintedAmount);
125   }
126   /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
127   /// @param target Address to be frozen
128   /// @param freeze either to freeze it or not
129   function freezeAccount(address target, bool freeze) onlyOwner {
130       frozenAccount[target] = freeze;
131       FrozenFunds(target, freeze);
132   }  
133    
134 }