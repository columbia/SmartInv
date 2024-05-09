1 pragma solidity ^0.4.21;
2 
3 contract PeakAssetCoin {
4     string public name = "Peak Asset Coin";
5     string public symbol = "PAC";
6     uint8 public decimals = 18;
7     uint256 public totalSupply = 800000000 * 10 ** uint256(decimals);
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 
15     function PeakAssetCoin() public {
16         balanceOf[msg.sender] = totalSupply;
17     }
18 
19     function _transfer(address _from, address _to, uint _value) internal {
20         require(_to != 0x0);
21         require(balanceOf[_from] >= _value);
22         require(balanceOf[_to] + _value > balanceOf[_to]);
23         uint previousBalances = balanceOf[_from] + balanceOf[_to];
24         balanceOf[_from] -= _value;
25         balanceOf[_to] += _value;
26         emit Transfer(_from, _to, _value);
27         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
28     }
29 
30     function transfer(address _to, uint256 _value) public {
31         _transfer(msg.sender, _to, _value);
32     }
33 
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
35         require(_value <= allowance[_from][msg.sender]);
36         allowance[_from][msg.sender] -= _value;
37         _transfer(_from, _to, _value);
38         return true;
39     }
40 
41     function approve(address _spender, uint256 _value) public returns (bool success) {
42         allowance[msg.sender][_spender] = _value;
43         emit Approval(msg.sender, _spender, _value);
44         return true;
45     }
46 }