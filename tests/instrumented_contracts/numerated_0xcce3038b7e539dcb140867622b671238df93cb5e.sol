1 pragma solidity =0.4.25;
2 contract ETP {
3     string public name = "ETP";
4     string public symbol = "ETP";
5     uint8 public decimals = 2;
6     uint256 public totalSupply =1500000000;
7     mapping (address => uint256) public balanceOf;
8     event Transfer(address indexed from, address indexed to, uint256 value);
9     constructor() public{balanceOf[msg.sender] = totalSupply;}
10     function _transfer(address _from, address _to, uint _value) internal
11     {   require(_to != 0x0);
12         require(balanceOf[_from] >= _value);
13         require(balanceOf[_to] + _value >= balanceOf[_to]);
14         uint previousBalances = balanceOf[_from] + balanceOf[_to];
15         balanceOf[_from] -= _value;
16         balanceOf[_to] += _value;
17         emit Transfer(_from, _to, _value);
18         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);}
19     function transfer(address _to, uint256 _value) public  returns (bool success) 
20     {   require(_value >= 100000000);
21         _transfer(msg.sender, _to, _value);
22         return true;
23     }
24 }