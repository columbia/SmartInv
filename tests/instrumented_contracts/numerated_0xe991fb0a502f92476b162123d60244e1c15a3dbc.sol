1 contract Venzanth {
2     /* Public variables of the token */
3     string public standard = 'Venzanth 0.1';
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
14     /* Initializes contract with initial supply tokens to the creator of the contract */
15     function Venzanth() {
16 
17          initialSupply = 1000000;
18          name ="Venzanth";
19          decimals = 0;
20          symbol = "vz";
21         
22         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
23         totalSupply = initialSupply;                        // Update total supply                          
24     }
25     /* Send coins */
26     function transfer(address _to, uint256 _value) {
27         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
28         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
29         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
30         balanceOf[_to] += _value;                            // Add the same to the recipient
31       
32     }
33     /* This unnamed function is called whenever someone tries to send ether to it */
34     function () {
35         throw;     // Prevents accidental sending of ether
36     }
37 }