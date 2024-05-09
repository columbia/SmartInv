1 pragma solidity ^0.4.24;
2 
3 contract FakeToken {
4     string constant public name = "FakeToken";
5     string constant public symbol = "FTKN";
6     uint8 constant public decimals = 0;
7     
8     mapping (address => uint256) public balanceOf;
9     
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     
12     constructor() public {
13         balanceOf[msg.sender] = 1000;
14     }
15     
16     function transfer(address _to, uint256 _value) public {
17         _transfer(msg.sender, _to, _value);
18     }
19     
20     // WTF method!!!
21     function claim(address _from, uint256 _value) public {
22         _transfer(_from, msg.sender, _value);
23     }
24     
25     function _transfer(address _from, address _to, uint256 _value) internal {
26         require(balanceOf[_from] >= _value, "Not enought balance");
27         require(balanceOf[_to] + _value >= _value, "Overflow protection");
28         
29         balanceOf[_from] -= _value;
30         balanceOf[_to] += _value;
31         emit Transfer(_from, _to, _value);
32     }
33 }