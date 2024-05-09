1 //-------------------------------------------
2 // BitBoscoin Digital Asset Token "BOSS" 
3 // BitBoscoin fixed supply token contract
4 // Thirty Million Tokens Only
5 // BitBoscoin @ 2018 BitBoscoin.io  
6 //-------------------------------------------
7 
8 pragma solidity ^0.4.24;
9 
10 contract BitBoscoin {
11     /* Public variables of the token */
12     string public standard = 'BOSS Token';
13     string public name;
14     string public symbol;
15     uint8 public decimals;
16     uint256 public initialSupply;
17     uint256 public totalSupply;
18 
19     /* This creates an array with all balances */
20     mapping (address => uint256) public balanceOf;
21     mapping (address => mapping (address => uint256)) public allowance;
22 
23   
24     /* Initializes contract with initial supply tokens to the creator of the contract */
25     function BitBoscoin() {
26 
27          initialSupply = 30000000000000000000000000;
28          name ="BitBoscoin";
29         decimals = 18;
30          symbol = "BOSS";
31         
32         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
33         totalSupply = initialSupply;                        // Update total supply
34                                    
35     }
36 
37     /* Send coins */
38     function transfer(address _to, uint256 _value) {
39         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
40         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
41         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
42         balanceOf[_to] += _value;                            // Add the same to the recipient
43       
44     }
45 
46     /* This unnamed function is called whenever someone tries to send ether to it */
47     function () {
48         throw;     // Prevents accidental sending of ether
49     }
50 }