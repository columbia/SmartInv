1 pragma solidity ^0.4.19;
2 
3 contract TCZToken {
4     // Public variables of the token
5     string public name = "TCZ Token";
6     string public symbol = "TCZ";
7     uint256 public decimals = 6;
8     uint256 public totalSupply = 4*1000*1000*1000*10**uint256(decimals);
9 	
10     address owner;
11 
12     mapping (address => uint256) public balanceOf;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     event Burn(address indexed from, uint256 value);
17 
18     function TCZToken( ) public {
19 	    owner = msg.sender;
20         balanceOf[msg.sender] = totalSupply;               
21     }
22 
23     function _transfer(address _from, address _to, uint _value) internal {
24 	
25         require(_to != 0x0);
26         
27         require(balanceOf[_from] >= _value);
28        
29         require(balanceOf[_to] + _value > balanceOf[_to]);
30         
31         uint previousBalances = balanceOf[_from] + balanceOf[_to];
32         
33         balanceOf[_from] -= _value;
34         
35         balanceOf[_to] += _value;
36         emit Transfer(_from, _to, _value);
37         
38         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
39 
40     }
41 
42     function transfer(address _to, uint256 _value) public  returns (bool success) {
43         _transfer(msg.sender, _to, _value);
44 		return true;
45     }
46 
47     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
48 		require(msg.sender == owner);
49         _transfer(_from, _to, _value);
50         return true;
51     }
52 
53 }