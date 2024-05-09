1 pragma solidity ^0.4.9;
2 
3 contract Petrocoin {
4      /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     
8     */
9     /// total amount of tokens
10     string public standard = 'Token 0.1';
11     string public name;
12     string public symbol;
13     uint8 public decimals;
14     uint256 public initialSupply;
15     uint256 public totalSupply;
16 
17     /* This creates an array with all balances */
18     mapping (address => uint256) public balanceOf;
19     mapping (address => mapping (address => uint256)) public allowance;
20 
21  
22 
23  
24  
25  
26  function Petrocoin() {
27 
28         initialSupply = 100000000;
29         name ="Petrocoin";
30         decimals = 0;
31         symbol = "PETRO";
32         
33         balanceOf[msg.sender] = initialSupply;              
34         totalSupply = initialSupply;                        
35                                    
36     }
37 
38     /* Send coins */
39     function transfer(address _to, uint256 _value) {
40         if (balanceOf[msg.sender] < _value) throw;           
41         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
42         balanceOf[msg.sender] -= _value;                     
43         balanceOf[_to] += _value;                           
44       
45     }
46 
47 
48  
49   function approve(address _spender, uint256 _value)
50         returns (bool success) {
51         allowance[msg.sender][_spender] = _value;
52         return true;
53     }
54     
55     function depositToken(address token, uint256 amount){
56     
57 }
58     
59     function () {
60         throw;    
61     }
62 }