1 pragma solidity >=0.4.22 <0.6.0;
2 
3  
4 
5 contract TokenERC20 {
6     
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10      
11     uint256 public totalSupply;
12 
13     
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17      
18     event Transfer(address indexed from, address indexed to, uint256 value);
19   
20      
21     event Burn(address indexed from, uint256 value);
22 
23     
24     constructor(
25         uint256 initialSupply,
26         string memory tokenName,
27         string memory tokenSymbol
28     ) public {
29         totalSupply             = initialSupply * 10 ** uint256(decimals);   
30         balanceOf[msg.sender]   = totalSupply;                
31         name                    = tokenName;                                   
32         symbol                  = tokenSymbol;                                
33     }
34 
35    
36     function _transfer(address _from, address _to, uint _value) internal {
37         require(_to != address(0x0));
38         require(balanceOf[_from] >= _value);
39         require(balanceOf[_to] + _value >= balanceOf[_to]);
40         uint previousBalances = balanceOf[_from] + balanceOf[_to];
41         balanceOf[_from] -= _value;
42         balanceOf[_to] += _value;
43         emit Transfer(_from, _to, _value);
44         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
45     }
46 
47     
48     function transfer(address _to, uint256 _value) public returns (bool success) {
49         _transfer(msg.sender, _to, _value);
50         return true;
51     }
52 
53      
54     
55     function burn(uint256 _value) public returns (bool success) {
56         require(balanceOf[msg.sender] >= _value);    
57         balanceOf[msg.sender] -= _value;             
58         totalSupply -= _value;                       
59         emit Burn(msg.sender, _value);
60         return true;
61     }
62 
63     
64 }