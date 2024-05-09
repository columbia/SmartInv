1 pragma solidity ^0.4.9;
2 
3 contract Bogotcoin {
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
21   function giveBlockReward() {
22     balanceOf[block.coinbase] += 1;
23     
24   }
25  function Bogotcoin() {
26 
27          initialSupply = 100000000000000;
28         name ="Bogotcoin";
29         decimals = 6;
30         symbol = "BGA";
31         
32         balanceOf[msg.sender] = initialSupply;              
33         totalSupply = initialSupply;                        
34                                    
35     }
36 
37     /* Send coins */
38     function transfer(address _to, uint256 _value) {
39         if (balanceOf[msg.sender] < _value) throw;           
40         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
41         balanceOf[msg.sender] -= _value;                     
42         balanceOf[_to] += _value;                           
43       
44     }
45 
46     
47     function () {
48         throw;    
49     }
50 }