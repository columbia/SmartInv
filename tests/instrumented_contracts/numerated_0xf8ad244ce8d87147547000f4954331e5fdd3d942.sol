1 contract Qudostokenone {
2     /* Public variables of the token */
3     string public standard = 'Token 0.1';
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public initialSupply;
8     uint256 public totalSupply;
9     /* This creates an array with all balances */
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12   
13     /* Initializes contract with initial supply tokens to the creator of the contract */
14     function Qudostokenone() {
15          initialSupply = 500000;
16          name ="qudostokenone";
17         decimals = 3;
18          symbol = "QTKO";
19         
20         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
21         totalSupply = initialSupply;                        // Update total supply
22                                    
23     }
24     /* Send coins */
25     function transfer(address _to, uint256 _value) {
26         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
27         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
28         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
29         balanceOf[_to] += _value;                            // Add the same to the recipient
30       
31     }
32    
33     
34    
35     /* This unnamed function is called whenever someone tries to send ether to it */
36     function () {
37         throw;     // Prevents accidental sending of ether
38     }
39 }