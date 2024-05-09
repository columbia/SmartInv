1 contract T20coin {
2   
3     string public standard = '0.1';
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public initialSupply;
8     uint256 public totalSupply;
9 
10     
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14   
15     
16     function T20coin() {
17 
18          initialSupply = 10000000000;
19          name ="T20coin";
20         decimals = 1;
21          symbol = "T20";
22         
23         balanceOf[msg.sender] = initialSupply;              
24         totalSupply = initialSupply;                
25                                    
26     }
27 
28     
29     function transfer(address _to, uint256 _value) {
30         if (balanceOf[msg.sender] < _value) throw;           
31         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
32         balanceOf[msg.sender] -= _value;                     
33         balanceOf[_to] += _value;                            
34       
35     }
36 
37    
38 
39     
40 
41    
42 
43     
44     function () {
45         throw;    
46     }
47 }