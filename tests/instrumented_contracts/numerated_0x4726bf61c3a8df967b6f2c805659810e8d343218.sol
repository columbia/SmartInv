1 pragma solidity ^0.4.4;
2 
3 contract Agriss {
4     uint8 public decimals = 18;
5     mapping (address => uint256) public balanceOf;
6     
7     constructor (
8         uint256 initialSupply
9         ) public {
10         balanceOf[msg.sender] = initialSupply * 10 ** uint256(decimals);              
11     }
12 
13     /* Send coins */
14     function transfer(address _to, uint256 _value) public {
15         require(balanceOf[msg.sender] >= _value);           
16         require(balanceOf[_to] + _value >= balanceOf[_to]); 
17         balanceOf[msg.sender] -= _value;                    
18         balanceOf[_to] += _value;                           
19     }
20 
21     function getBalanceOf(address src) constant public returns (uint256) {
22         return balanceOf[src];
23     }
24 }