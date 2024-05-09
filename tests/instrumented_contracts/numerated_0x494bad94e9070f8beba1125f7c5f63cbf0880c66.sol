1 pragma solidity ^0.4.0;
2 
3 contract UNIKENaddress {
4     string public standard = 'Token 0.1';
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8     uint256 public initialSupply;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14   
15     function UNIKENaddress() {
16 
17          initialSupply = 23100000; //Is de 25% of the totalSupply;
18          name ="UNKE";
19         decimals = 2;
20          symbol = "U";
21         
22         balanceOf[msg.sender] = initialSupply; 
23         totalSupply = initialSupply;                        // Update total supply the other 75% 
24                                    
25     }
26 
27     /* To send coins */
28     function transfer(address _to, uint256 _value) {
29         if (balanceOf[msg.sender] < _value) throw;           
30         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
31         balanceOf[msg.sender] -= _value;                     
32         balanceOf[_to] += _value;                            
33       
34     }
35 
36    
37 
38     function () {
39         throw;     // Prevents accidental sending of ether
40     }
41 }