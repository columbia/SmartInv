1 contract HackerSpaceBarneysToken {
2     /* This creates an array with all balances */
3     mapping (address => uint256) public balanceOf;
4 
5     /* Initializes contract with initial supply tokens to the creator of the contract */
6     function HackerSpaceBarneysToken() {
7         balanceOf[msg.sender] = 1000000;              // Give the creator all initial tokens
8     }
9 
10     /* Send coins */
11     function transfer(address _to, uint256 _value) {
12         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
13         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
14         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
15         balanceOf[_to] += _value;                            // Add the same to the recipient
16     }
17 }