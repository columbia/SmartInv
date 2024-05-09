1 pragma solidity ^0.4.24;
2 
3 contract TOPB {
4     string public name = 'TOPBTC TOKEN';
5     string public symbol = 'TOPB';
6     uint8 public decimals = 18;
7     uint256 public totalSupply;
8 	
9     mapping (address => uint256) public balanceOf;
10 	
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Burn(address indexed from, uint256 value);
13 	
14     function () payable public {
15 		assert(false);
16     }
17 
18     function TOPB() public {
19         totalSupply = 200000000 * 10 ** uint256(decimals);
20         balanceOf[msg.sender] = totalSupply;
21     }
22 
23     function _transfer(address _from, address _to, uint256 _value) internal {
24 		assert(_to != 0x0);
25 		assert(balanceOf[_from] >= _value);
26 		assert(balanceOf[_to] + _value > balanceOf[_to]);
27 		uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
28 		balanceOf[_from] -= _value;
29 		balanceOf[_to] += _value;
30 		emit Transfer(_from, _to, _value);
31 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
32     }
33 
34     function transfer(address _to, uint256 _value) public {
35         _transfer(msg.sender, _to, _value);
36     }
37 
38     function burn(uint256 _value) public returns (bool success) {
39         assert(balanceOf[msg.sender] >= _value); 
40         balanceOf[msg.sender] -= _value;
41         totalSupply -= _value;
42         emit Burn(msg.sender, _value);
43         return true;
44     }
45 }