1 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
2 
3     contract Nexium { 
4         /* Public variables of the token */
5         string public name;
6         string public symbol;
7         uint8 public decimals;
8 
9         /* This creates an array with all balances */
10         mapping (address => uint256) public balanceOf;
11         mapping (address => mapping (address => uint)) public allowance;
12         mapping (address => mapping (address => uint)) public spentAllowance;
13 
14         /* This generates a public event on the blockchain that will notify clients */
15         event Transfer(address indexed from, address indexed to, uint256 value);
16 
17         /* Initializes contract with initial supply tokens to the creator of the contract */
18         function Nexium() {
19             balanceOf[msg.sender] = 100000000000;              // Give the creator all initial tokens                    
20             name = 'Nexium';                                   // Set the name for display purposes     
21             symbol = 'NxC';                               // Set the symbol for display purposes    
22             decimals = 3;                            // Amount of decimals for display purposes        
23         }
24 
25         /* Send coins */
26         function transfer(address _to, uint256 _value) {
27             if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough   
28             if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
29             balanceOf[msg.sender] -= _value;                     // Subtract from the sender
30             balanceOf[_to] += _value;                            // Add the same to the recipient            
31             Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
32         }
33 
34         /* Allow another contract to spend some tokens in your behalf */
35 
36         function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
37             allowance[msg.sender][_spender] = _value;     
38             tokenRecipient spender = tokenRecipient(_spender);
39             spender.receiveApproval(msg.sender, _value, this, _extraData);
40 			
41 			return true;
42         }
43 
44         /* A contract attempts to get the coins */
45 
46         function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
47             if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough   
48             if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
49             if (spentAllowance[_from][msg.sender] + _value > allowance[_from][msg.sender]) throw;   // Check allowance
50             balanceOf[_from] -= _value;                          // Subtract from the sender
51             balanceOf[_to] += _value;                            // Add the same to the recipient            
52             spentAllowance[_from][msg.sender] += _value;
53             Transfer(msg.sender, _to, _value); 
54 			
55 			return true;
56         } 
57 
58         /* This unnamed function is called whenever someone tries to send ether to it */
59         function () {
60             throw;     // Prevents accidental sending of ether
61         }        
62     }