1 contract Stalincoin {
2     /* Public variables of the token */
3     string public standard = 'Token 0.1';
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public initialSupply;
8 
9     /* This creates an array with all balances */
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13   
14     /* Initializes contract with initial supply tokens to the creator of the contract */
15     function Stalincoin() {
16 
17          initialSupply = 50000;
18          name ="Stalincoin";
19         decimals = 2;
20          symbol = "STC";
21         
22         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
23         uint256 totalSupply = initialSupply;                        // Update total supply
24                                    
25     }
26 
27     /* Send coins */
28     function transfer(address _to, uint256 _value) {
29         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
30         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
31         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
32         balanceOf[_to] += _value;                            // Add the same to the recipient
33       
34     }
35 
36    
37 
38     
39 
40    
41 
42     /* This unnamed function is called whenever someone tries to send ether to it */
43     function () {
44         throw;     // Prevents accidental sending of ether
45     }
46 }