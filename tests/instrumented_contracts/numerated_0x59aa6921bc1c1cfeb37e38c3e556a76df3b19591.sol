1 pragma solidity ^0.4.24;
2 
3 
4 
5 contract FMC {
6 
7     string public name ;
8     string public symbol ;
9     uint8 public decimals = 18;  
10     uint256 public totalSupply  ;  
11 
12     
13     mapping (address => uint256) public balanceOf;
14     
15    
16 
17     
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     
21 
22     
23     function FMC(uint256 initialSupply, string tokenName, string tokenSymbol) public {
24        
25         totalSupply = initialSupply * 10 ** uint256(decimals);
26 
27         
28         balanceOf[msg.sender] = totalSupply;    
29 
30         name = tokenName;
31         symbol = tokenSymbol;
32     }
33 
34   
35     function _transfer(address _from, address _to, uint _value) internal {
36 
37        
38         require(_to != 0x0);
39 
40        
41         require(balanceOf[_from] >= _value);
42 
43         
44         require(balanceOf[_to] + _value > balanceOf[_to]);
45 
46         
47         uint previousBalances = balanceOf[_from] + balanceOf[_to];
48 
49        
50         balanceOf[_from] -= _value;
51         balanceOf[_to] += _value;
52 
53      
54         emit Transfer(_from, _to, _value);
55 
56         
57         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
58     }
59 
60    
61     function transfer(address _to, uint256 _value) public {
62         _transfer(msg.sender, _to, _value);
63     }
64 	
65 	
66 }