1 pragma solidity ^0.4.24;
2 
3 contract TokenSampleG {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 18;
7     uint256 public totalSupply;
8     
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11    
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     event Burn(address indexed from, uint256 value);
15     function TokenSampleG(
16     ) public {
17         totalSupply = 250000000 * 10 ** uint256(decimals);  
18         balanceOf[msg.sender] = totalSupply;    
19         name = "TokenSampleG";                     
20         symbol = "TKSG1";                     
21     }
22     function _transfer(address _from, address _to, uint _value) internal {
23         require(_to != 0x0);
24         require(balanceOf[_from] >= _value);
25         require(balanceOf[_to] + _value >= balanceOf[_to]);
26         uint previousBalances = balanceOf[_from] + balanceOf[_to];
27         balanceOf[_from] -= _value;
28         balanceOf[_to] += _value;
29         emit Transfer(_from, _to, _value);
30         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
31     }
32 
33 
34     function transfer(address _to, uint256 _value) public {
35         _transfer(msg.sender, _to, _value);
36     }
37 
38 
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
40         require(_value <= allowance[_from][msg.sender]);     // Check allowance
41         allowance[_from][msg.sender] -= _value;
42         _transfer(_from, _to, _value);
43         return true;
44     }
45 
46     
47     function approve(address _spender, uint256 _value) public
48         returns (bool success) {
49         allowance[msg.sender][_spender] = _value;
50         return true;
51     }
52  
53     function burn(uint256 _value) public returns (bool success) {
54         require(balanceOf[msg.sender] >= _value); 
55         balanceOf[msg.sender] -= _value;           
56         totalSupply -= _value;                    
57         emit Burn(msg.sender, _value);
58         return true;
59     }
60 
61     function burnFrom(address _from, uint256 _value) public returns (bool success) {
62         require(balanceOf[_from] >= _value);               
63         require(_value <= allowance[_from][msg.sender]);  
64         balanceOf[_from] -= _value;                        
65         allowance[_from][msg.sender] -= _value;      
66         totalSupply -= _value;                            
67         emit Burn(_from, _value);
68         return true;
69     }
70 }