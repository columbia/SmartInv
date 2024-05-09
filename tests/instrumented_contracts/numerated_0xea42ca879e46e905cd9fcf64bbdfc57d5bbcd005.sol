1 contract BITCOINGAME {
2     /* Public variables of the token */
3     string public standard = 'Token 0.1';
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public initialSupply;
8     uint256 public totalSupply;
9 
10     /* This creates an array with all balances */
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14   
15     /* Initializes contract with initial supply tokens to the creator of the contract */
16     function BITCOINGAME() {
17 
18          initialSupply = 21000000000000000000000000;
19          name ="BITCOINGAME";
20         decimals = 18;
21          symbol = "BGAME";
22         
23         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
24         totalSupply = initialSupply;                        // Update total supply
25                                    
26     }
27 
28     /* Send coins */
29     function transfer(address _to, uint256 _value) {
30         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
31         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
32         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
33         balanceOf[_to] += _value;                            // Add the same to the recipient
34       
35     }
36 
37    
38 
39     
40 
41    
42 
43     /* This unnamed function is called whenever someone tries to send ether to it */
44     function () {
45         throw;     // Prevents accidental sending of ether
46     }
47 }