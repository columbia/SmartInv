1 pragma solidity ^0.4.16;
2 contract BmarktToken {
3 
4     string public name;
5     string public symbol;
6     uint8 public decimals = 18;
7 
8     uint256 public totalSupply;
9 
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     event Burn(address indexed from, uint256 value);
18 
19     function BmarktToken() public {
20         totalSupply = 90000000 * 10 ** uint256(decimals);
21         balanceOf[msg.sender] = totalSupply;
22         name = "Bmarkt";
23         symbol = "BMK";
24     }
25 
26     function _transfer(address _from, address _to, uint _value) internal {
27         require(_to != 0x0);
28         require(balanceOf[_from] >= _value);
29         require(balanceOf[_to] + _value > balanceOf[_to]);
30         uint previousBalances = balanceOf[_from] + balanceOf[_to];
31         balanceOf[_from] -= _value;
32         balanceOf[_to] += _value;
33         Transfer(_from, _to, _value);
34         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
35     }
36 
37     function transfer(address _to, uint256 _value) public {
38         _transfer(msg.sender, _to, _value);
39     }
40      
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
42         require(_value <= allowance[_from][msg.sender]);     
43         allowance[_from][msg.sender] -= _value;
44         _transfer(_from, _to, _value);
45         return true;
46     }
47      
48     function approve(address _spender, uint256 _value) public returns (bool success) {
49         allowance[msg.sender][_spender] = _value;
50         return true;
51     }
52      
53     function burn(uint256 _value) public returns (bool success) {
54         require(balanceOf[msg.sender] >= _value);   
55         balanceOf[msg.sender] -= _value;            
56         totalSupply -= _value;                      
57         Burn(msg.sender, _value);
58         return true;
59     }
60      
61     function burnFrom(address _from, uint256 _value) public returns (bool success) {
62         require(balanceOf[_from] >= _value);                
63         require(_value <= allowance[_from][msg.sender]);    
64         balanceOf[_from] -= _value;                         
65         allowance[_from][msg.sender] -= _value;             
66         totalSupply -= _value;                              
67         Burn(_from, _value);
68         return true;
69     }
70 }