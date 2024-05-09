1 pragma solidity ^0.4.18;
2 
3 contract BossContract {
4 
5     string public name = "Boss";
6     string public symbol = "BOSS";
7     uint8 public decimals = 8;
8     uint256 public initialSupply = 200000000;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     function BossContract() public {
15         totalSupply = initialSupply * 10 ** uint256(decimals);
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
26         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
27     }
28 
29     function transfer(address _to, uint256 _value) public {
30         _transfer(msg.sender, _to, _value);
31     }
32 
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
34         require(_value <= allowance[_from][msg.sender]);
35         _transfer(_from, _to, _value);
36         return true;
37     }
38 
39     function approve(address _spender, uint256 _value) public
40         returns (bool success) {
41         allowance[msg.sender][_spender] = _value;
42         return true;
43     }
44 
45     function burn(uint256 _value) public returns (bool success) {
46         require(balanceOf[msg.sender] >= _value);
47         balanceOf[msg.sender] -= _value;
48         totalSupply -= _value;
49         return true;
50     }
51 }