1 pragma solidity ^0.4.16;
2 
3 contract IotWifitoken {
4 
5     string public name = "IotWifitoken";
6     string public symbol = "ITWF";
7     uint8 public decimals = 18;
8     uint256 public totalSupply = 1000000000 * 10 ** uint256(decimals);
9 
10     mapping (address => uint256) public balanceOf;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     function IotWifitoken() public {
15         balanceOf[msg.sender] = totalSupply;
16     }
17 
18     function _transfer(address _from, address _to, uint _value) internal {
19         require(balanceOf[_from] >= _value);
20         require(balanceOf[_to] + _value > balanceOf[_to]);
21 
22         uint previousBalances = balanceOf[_from] + balanceOf[_to];
23         balanceOf[_from] -= _value;
24         balanceOf[_to] += _value;
25         Transfer(_from, _to, _value);
26         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
27     }
28 
29     function transfer(address _to, uint256 _value) public {
30         _transfer(msg.sender, _to, _value);
31     }
32 }