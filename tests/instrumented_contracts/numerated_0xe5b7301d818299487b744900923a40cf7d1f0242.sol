1 pragma solidity ^0.4.16;
2 contract ASCToken {
3     string public name;
4     string public symbol;
5     uint8 public decimals = 2;
6     uint256 public totalSupply;
7     mapping (address => uint256) public balanceOf;
8     mapping (address => mapping (address => uint256)) public allowance;
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     event Burn(address indexed from, uint256 value);
11     function ASCToken() public {
12         totalSupply = 60000000000 * 10 ** uint256(decimals);
13         balanceOf[msg.sender] = totalSupply;
14         name = "Ascereum";
15         symbol = "ASC";
16     }
17     function _transfer(address _from, address _to, uint _value) internal {
18         require(_to != 0x0);
19         require(balanceOf[_from] >= _value);
20         require(balanceOf[_to] + _value > balanceOf[_to]);
21         uint previousBalances = balanceOf[_from] + balanceOf[_to];
22         balanceOf[_from] -= _value;
23         balanceOf[_to] += _value;
24         Transfer(_from, _to, _value);
25         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
26     }
27     function transfer(address _to, uint256 _value) public {
28         _transfer(msg.sender, _to, _value);
29     }
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
31         require(_value <= allowance[_from][msg.sender]);     
32         allowance[_from][msg.sender] -= _value;
33         _transfer(_from, _to, _value);
34         return true;
35     }
36     function approve(address _spender, uint256 _value) public returns (bool success) {
37         allowance[msg.sender][_spender] = _value;
38         return true;
39     }
40     function burn(uint256 _value) public returns (bool success) {
41         require(balanceOf[msg.sender] >= _value);   
42         balanceOf[msg.sender] -= _value;            
43         totalSupply -= _value;                      
44         Burn(msg.sender, _value);
45         return true;
46     }
47     function burnFrom(address _from, uint256 _value) public returns (bool success) {
48         require(balanceOf[_from] >= _value);                
49         require(_value <= allowance[_from][msg.sender]);    
50         balanceOf[_from] -= _value;                         
51         allowance[_from][msg.sender] -= _value;             
52         totalSupply -= _value;                              
53         Burn(_from, _value);
54         return true;
55     }
56 }