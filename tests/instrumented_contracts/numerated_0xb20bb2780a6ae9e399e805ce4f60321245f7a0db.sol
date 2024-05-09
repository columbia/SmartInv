1 pragma solidity ^0.4.2;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) throw;
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 contract MyToken is owned {
21     /* This creates an array with all balances */
22     mapping (address => uint256) public balanceOf;
23 
24     /* Public variables of the token */
25     string public standard = 'Token 0.1';
26     string public name = 'TrekMiles';
27     string public symbol = 'TMC';
28     uint8 public decimals = 0;
29     uint256 public totalSupply;
30 
31     /* Initializes contract with initial supply tokens to the creator of the contract */
32     function MyToken() {
33         uint256 initialSupply = 10;
34         balanceOf[msg.sender] = initialSupply;
35         totalSupply = initialSupply;
36     }
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     /* Send coins */
41     function transfer(address _to, uint256 _value) {
42         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
43         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
44         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
45         balanceOf[_to] += _value;                            // Add the same to the recipient
46         Transfer(msg.sender, _to, _value);        // Notify anyone listening that this transfer took place
47     }
48 
49     /* Mint coins */
50     function mintToken(address target, uint256 mintedAmount) onlyOwner {
51         balanceOf[target] += mintedAmount;
52         totalSupply += mintedAmount;
53         Transfer(0, owner, mintedAmount);
54         Transfer(owner, target, mintedAmount);
55     }
56 
57     function () {
58         //if ether is sent to this address, send it back.
59         throw;
60     }
61 }