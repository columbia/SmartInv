1 contract SkechoCoin {
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
14     /* Initializes contract with initial supply tokens to the creator of the contract */
15     function SkechoCoin() {
16          initialSupply = 21000000000000000000000000000;
17          name ="SkechoCoin";
18         decimals = 18;
19          symbol = "SCC";
20         
21         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
22         totalSupply = initialSupply;                        // Update total supply
23                                    
24     }
25 
26     /* Send coins */
27     function transfer(address _to, uint256 _value) {
28         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
29         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
30         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
31         balanceOf[_to] += _value;                            // Add the same to the recipient
32       
33     }
34 
35 
36 
37     /* This unnamed function is called whenever someone tries to send ether to it */
38     function () {
39         throw;     // Prevents accidental sending of ether
40     }
41 }