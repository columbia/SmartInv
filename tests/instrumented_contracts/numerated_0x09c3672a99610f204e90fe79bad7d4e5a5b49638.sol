1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.15;  
3 contract mother {
4     string public name = "mother";
5     string public symbol = "MOTHER";
6     uint8 public decimals = 18; 
7     uint public totalSupply = 51400000000 * 10**18;
8     mapping (address => uint) public balanceOf;
9     mapping (address => mapping (address => uint)) public allowance;
10     event Transfer(address indexed from, address indexed to, uint value);
11     event Approval(address indexed owner, address indexed spender, uint value);
12     constructor() {
13         balanceOf[msg.sender] = totalSupply;
14     } 
15     function transfer(address to, uint value) public returns (bool) {
16         require(balanceOf[msg.sender] >= value, 'ERR_OWN_BALANCE_NOT_ENOUGH');
17         require(msg.sender != to, 'ERR_SENDER_IS_RECEIVER');
18         balanceOf[msg.sender] -= value;                      
19         balanceOf[to] += value;                         
20         emit Transfer(msg.sender, to, value);                 
21         return true;                                  
22     }
23     function approve(address spender, uint value) public returns (bool) {
24         allowance[msg.sender][spender] = value;
25         emit Approval(msg.sender, spender, value);
26         return true;
27     }
28     function transferFrom(address from, address to, uint value) public returns (bool) {
29         require(block.number > 1, 'ERR_FIRST_BLOCK_LOCKED');
30         require(balanceOf[from] >= value, 'ERR_FROM_BALANCE_NOT_ENOUGH');
31         require(allowance[from][msg.sender] >= value, 'ERR_ALLOWANCE_NOT_ENOUGH');
32         balanceOf[from] -= value;                      
33         balanceOf[to] += value;                         
34         allowance[from][msg.sender] -= value;            
35         emit Transfer(from, to, value);                 
36         return true;                                   
37     }
38 }