1 pragma solidity ^0.4.20;
2 
3 contract BenToken {
4     string public name="BenToken";
5     string public symbol="BenCoin";
6     uint8 public decimals=8;
7 
8     /* This creates an array with all balances */
9     mapping (address => uint256) public balanceOf;
10 
11         /* Initializes contract with initial supply tokens to the creator of the contract */
12     function constrcutor() public {
13         balanceOf[msg.sender] = 10000;
14     }
15 
16     /* Send coins */
17     function transfer(address _to, uint256 _value) public {
18         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
19         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
20         balanceOf[msg.sender] -= _value;                    // Subtract from the sender
21         balanceOf[_to] += _value;                           // Add the same to the recipient
22     }
23 }