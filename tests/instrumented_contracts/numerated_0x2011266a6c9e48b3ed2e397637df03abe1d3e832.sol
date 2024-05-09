1 pragma solidity ^0.4.16;
2 
3 contract ETGOLDToken {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 18;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Burn(address indexed from, uint256 value);
14 
15     function ETGOLDToken() public {
16         totalSupply = 24000000 * 10 ** uint256(decimals);
17         balanceOf[msg.sender] = totalSupply;
18         name = "Gold Ethereum";
19         symbol = "ETGOLD";
20     }
21 
22     function _transfer(address _from, address _to, uint _value) internal {
23         require(_to != 0x0);
24         require(balanceOf[_from] >= _value);
25         require(balanceOf[_to] + _value > balanceOf[_to]);
26         uint previousBalances = balanceOf[_from] + balanceOf[_to];
27         balanceOf[_from] -= _value;
28         balanceOf[_to] += _value;
29         Transfer(_from, _to, _value);
30         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
31     }
32 
33     function transfer(address _to, uint256 _value) public {
34         _transfer(msg.sender, _to, _value);
35     }
36 
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
38         require(_value <= allowance[_from][msg.sender]);     
39         allowance[_from][msg.sender] -= _value;
40         _transfer(_from, _to, _value);
41         return true;
42     }
43 
44     function approve(address _spender, uint256 _value) public returns (bool success) {
45         allowance[msg.sender][_spender] = _value;
46         return true;
47     }
48 
49     function burn(uint256 _value) public returns (bool success) {
50         require(balanceOf[msg.sender] >= _value);   
51         balanceOf[msg.sender] -= _value;            
52         totalSupply -= _value;                      
53         Burn(msg.sender, _value);
54         return true;
55     }
56 
57     function burnFrom(address _from, uint256 _value) public returns (bool success) {
58         require(balanceOf[_from] >= _value);                
59         require(_value <= allowance[_from][msg.sender]);    
60         balanceOf[_from] -= _value;                         
61         allowance[_from][msg.sender] -= _value;             
62         totalSupply -= _value;                              
63         Burn(_from, _value);
64         return true;
65     }
66 }