1 pragma solidity ^0.4.24;
2 
3 
4 contract UtilityToken {
5     string public name;
6     string public symbol;
7     uint8 public decimals = 6; 
8     uint256 public totalSupply;
9     
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     constructor() public {
17         totalSupply = 1000000000 * 10 ** uint256(decimals); 
18         balanceOf[msg.sender] = totalSupply;              
19         name = "UtilityToken";                                 
20         symbol = "UTLC";                            
21     }
22 
23     function _transfer(address _from, address _to, uint _value) internal {
24   
25         require(_to != 0x0);
26         require(balanceOf[_from] >= _value);
27         require(balanceOf[_to] + _value > balanceOf[_to]);
28         
29         uint previousBalances = balanceOf[_from] + balanceOf[_to];
30         // Subtract from the sender
31         balanceOf[_from] -= _value;
32         // Add the same to the recipient
33         balanceOf[_to] += _value;
34         emit Transfer(_from, _to, _value);
35 
36         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
37     }
38 
39     function transfer(address _to, uint256 _value) public {
40         _transfer(msg.sender, _to, _value);
41     }
42 
43 
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
45         require(_value <= allowance[_from][msg.sender]);     // Check allowance
46         allowance[_from][msg.sender] -= _value;
47         _transfer(_from, _to, _value);
48         return true;
49     }
50 
51     function approve(address _spender, uint256 _value) public
52         returns (bool success) {
53         allowance[msg.sender][_spender] = _value;
54         return true;
55     }
56 }