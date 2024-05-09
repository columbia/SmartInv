1 contract tokenltkrecipiente { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
2 
3 contract tokenltk{
4     /* Public variables of the token */
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8     uint256 public totalSupply;
9     address public owner;
10 
11     /* This creates an array with all balances */
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     /* This generates a public event on the blockchain that will notify clients */
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed _owner, address indexed spender, uint256 value);
19 
20     /* This notifies clients about the amount burnt */
21     event Burn(address indexed from, uint256 value);
22 
23     /* Initializes contract with initial supply tokens to the creator of the contract */
24     function tokenltk(
25         uint256 initialSupply,
26         string tokenName,
27         uint8 decimalUnits,
28         string tokenSymbol
29         ) public {
30         owner = msg.sender;
31         balanceOf[owner] = initialSupply;              // Give the creator all initial tokens
32         totalSupply = initialSupply;                        // Update total supply
33         name = tokenName;                                   // Set the name for display purposes
34         symbol = tokenSymbol;                               // Set the symbol for display purposes
35         decimals = decimalUnits;                            // Amount of decimals for display purposes
36     }
37 
38     /* Internal transfer, only can be called by this contract */
39     function _transfer(address _from, address _to, uint _value) internal {
40         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
41         require (balanceOf[_from] >= _value);                // Check if the sender has enough
42         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
43         balanceOf[_from] -= _value;                         // Subtract from the sender
44         balanceOf[_to] += _value;                            // Add the same to the recipient
45         Transfer(_from, _to, _value);
46     }
47 
48     /// @notice Send `_value` tokens to `_to` from your account
49     /// @param _to The address of the recipient
50     /// @param _value the amount to send
51     function transfer(address _to, uint256 _value) public {
52         _transfer(msg.sender, _to, _value);
53     }
54 
55     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
56     /// @param _from The address of the sender
57     /// @param _to The address of the recipient
58     /// @param _value the amount to send
59     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
60         require (_value <= allowance[_from][msg.sender]);     // Check allowance
61         allowance[_from][msg.sender] -= _value;
62         _transfer(_from, _to, _value);
63         return true;
64     }
65 
66     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
67     /// @param _spender The address authorized to spend
68     /// @param _value the max amount they can spend
69     function approve(address _spender, uint256 _value) public
70         returns (bool success) {
71         allowance[msg.sender][_spender] = _value;
72         Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
77     /// @param _spender The address authorized to spend
78     /// @param _value the max amount they can spend
79     /// @param _extraData some extra information to send to the approved contract
80     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
81         public
82         returns (bool success) {
83         tokenltkrecipiente spender = tokenltkrecipiente(_spender);
84         if (approve(_spender, _value)) {
85             spender.receiveApproval(msg.sender, _value, this, _extraData);
86             return true;
87         }
88     }        
89 
90     /// @notice Remove `_value` tokens from the system irreversibly
91     /// @param _value the amount of money to burn
92     function burn(uint256 _value) public returns (bool success) {
93         require (balanceOf[msg.sender] >= _value);            // Check if the sender has enough
94         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
95         totalSupply -= _value;                                // Updates totalSupply
96         Burn(msg.sender, _value);
97         return true;
98     }
99 
100     function burnFrom(address _from, uint256 _value) public returns (bool success) {
101         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
102         require(_value <= allowance[_from][msg.sender]);    // Check allowance
103         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
104         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
105         totalSupply -= _value;                              // Update totalSupply
106         Burn(_from, _value);
107         return true;
108     }
109 }