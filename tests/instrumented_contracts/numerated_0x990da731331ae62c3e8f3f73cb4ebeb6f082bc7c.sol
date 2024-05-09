1 pragma solidity ^0.4.13; 
2 contract Owned { 
3   address public owner;
4 
5   function Owned() {
6       owner = msg.sender;
7   }
8 
9   modifier onlyOwner {
10       require(msg.sender == owner);
11       _;
12   }
13 
14   function transferOwnership(address newOwner) onlyOwner {
15       owner = newOwner;
16   }
17 }
18 
19 contract ERC20Interface {
20     // Get the total token supply
21     uint256 public totalSupply;
22  
23     // Get the account balance of another account with address _owner
24     function balanceOf(address _owner) constant returns (uint256 balance);
25  
26     // Send _value amount of tokens to address _to
27     function transfer(address _to, uint256 _value) returns (bool success);
28  
29     // Send _value amount of tokens from address _from to address _to
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
31  
32     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
33     // If this function is called again it overwrites the current allowance with _value.
34     // this function is required for some DEX functionality
35     function approve(address _spender, uint256 _value) returns (bool success);
36  
37     // Returns the amount which _spender is still allowed to withdraw from _owner
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
39  
40     // Triggered when tokens are transferred.
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42  
43     // Triggered whenever approve(address _spender, uint256 _value) is called.
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 
46     // Burn token
47     event Burn(address indexed from, uint256 value);
48 }
49 
50 contract PlatoToken is Owned, ERC20Interface {
51   string  public name = "Plato"; 
52   string  public symbol = "PAT"; 
53   uint8   public decimals = 8; 
54   uint256 public totalSupply = 10000000000000000;
55   mapping (address => uint256) public balanceOf;
56   mapping (address => mapping (address => uint256)) public allowance;
57 
58   function PlatoToken() {
59     owner = msg.sender;
60     balanceOf[owner] = totalSupply;
61   }
62 
63   function balanceOf(address _owner) constant returns (uint256 balance){
64     return balanceOf[_owner];
65   }  
66   /* Internal transfer, only can be called by this contract */
67   function _transfer(address _from, address _to, uint _value) internal {
68       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
69       require (balanceOf[_from] > _value);                // Check if the sender has enough
70       require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
71       balanceOf[_from] -= _value;                         // Subtract from the sender
72       balanceOf[_to] += _value;                           // Add the same to the recipient
73       Transfer(_from, _to, _value);
74   }
75 
76   /// @notice Send `_value` tokens to `_to` from your account
77   /// @param _to The address of the recipient
78   /// @param _value the amount to send
79   function transfer(address _to, uint256 _value) returns (bool success){
80       _transfer(msg.sender, _to, _value);
81       return true;
82   }
83 
84   /// @notice Send `_value` tokens to `_to` in behalf of `_from`
85   /// @param _from The address of the sender
86   /// @param _to The address of the recipient
87   /// @param _value the amount to send
88   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
89       require (_value < allowance[_from][msg.sender]);     // Check allowance
90       allowance[_from][msg.sender] -= _value;
91       _transfer(_from, _to, _value);
92       return true;
93   }
94 
95   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
96   /// @param _spender The address authorized to spend
97   /// @param _value the max amount they can spend
98   function approve(address _spender, uint256 _value)
99       returns (bool success) {
100       allowance[msg.sender][_spender] = _value;
101       return true;
102   }  
103 
104   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
105     return allowance[_owner][_spender];
106   }
107 
108   /// @notice Remove `_value` tokens from the system irreversibly
109   /// @param _value the amount of money to burn
110   function burn(uint256 _value) returns (bool success) {
111       require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
112       balanceOf[msg.sender] -= _value;                      // Subtract from the sender
113       totalSupply -= _value;                                // Updates totalSupply
114       Burn(msg.sender, _value);
115       return true;
116   }
117 
118   function burnFrom(address _from, uint256 _value) returns (bool success) {
119       require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
120       require(_value <= allowance[_from][msg.sender]);    // Check allowance
121       balanceOf[_from] -= _value;                         // Subtract from the targeted balance
122       allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
123       totalSupply -= _value;                              // Update totalSupply
124       Burn(_from, _value);
125       return true;
126   }
127   
128   /// @notice Create `mintedAmount` tokens and send it to `target`
129   /// @param target Address to receive the tokens
130   /// @param mintedAmount the amount of tokens it will receive
131   function mintToken(address target, uint256 mintedAmount) onlyOwner {
132       balanceOf[target] += mintedAmount;
133       totalSupply += mintedAmount;
134       Transfer(0, this, mintedAmount);
135       Transfer(this, target, mintedAmount);
136   }
137 
138   function(){
139     revert();
140   }
141 }