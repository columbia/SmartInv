1 pragma solidity ^0.4.11;
2 
3 contract owned {
4     address public owner;
5     function owned() {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         if (msg.sender != owner) throw;
10         _;
11     }
12 }
13 
14 contract NECPToken is owned {
15     /* Public variables of the token */
16     string public constant standard = 'Token 0.1';
17     string public constant name = "Neureal Early Contributor Points";
18     string public constant symbol = "NECP";
19     uint256 public constant decimals = 8;
20     uint256 public constant MAXIMUM_SUPPLY = 3000000000000;
21     
22     uint256 public totalSupply;
23     bool public frozen = false;
24 
25     /* This tracks all balances */
26     mapping (address => uint256) public balanceOf;
27 
28     /* This generates a public event on the blockchain that will notify clients */
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     /* Initializes contract with initial supply tokens to the creator of the contract */
32     function NECPToken() {
33         balanceOf[msg.sender] = MAXIMUM_SUPPLY;              // Give the creator all initial tokens
34         totalSupply = MAXIMUM_SUPPLY;                        // Update total supply
35     }
36 
37     /* Send coins */
38     function transfer(address _to, uint256 _value) {
39         if (frozen) throw;                                   // Check if frozen
40         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
41         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
42         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
43         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
44         balanceOf[_to] += _value;                            // Add the same to the recipient
45         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
46     }
47 
48     function freezeTransfers() onlyOwner  {
49         frozen = true;
50     }
51 
52     /* This unnamed function is called whenever someone tries to send ether to it */
53     function () {
54         throw;   // Prevents accidental sending of ether
55     }
56 }