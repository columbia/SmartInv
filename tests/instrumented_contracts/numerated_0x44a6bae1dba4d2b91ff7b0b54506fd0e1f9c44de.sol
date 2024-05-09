1 pragma solidity ^0.4.16;
2 
3 
4 contract TunTokenERC20 {
5     string public name="Tun Token";
6     string public symbol="TUK";
7     uint8 public decimals = 18;  
8     uint256 public totalSupply=1000000000 * 10 ** uint256(decimals);
9 
10     mapping (address => uint256) public balanceOf;  //
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 
15     event Burn(address indexed from, uint256 value);
16 
17     function TunTokenERC20() public {
18         balanceOf[msg.sender] = totalSupply;
19     }
20 
21     function transfer(address _from, address _to, uint _value) public {
22         require(_to != 0x0);
23         require(balanceOf[_from] >= _value);
24         require(balanceOf[_to] + _value > balanceOf[_to]);
25         uint previousBalances = balanceOf[_from] + balanceOf[_to];
26         balanceOf[_from] -= _value;
27         balanceOf[_to] += _value;
28         Transfer(_from, _to, _value);
29         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
30     }
31 
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
33         require(_value <= allowance[_from][msg.sender]);     // Check allowance
34         allowance[_from][msg.sender] -= _value;
35         require(_to != 0x0);
36         require(balanceOf[_from] >= _value);
37         require(balanceOf[_to] + _value > balanceOf[_to]);
38         uint previousBalances = balanceOf[_from] + balanceOf[_to];
39         balanceOf[_from] -= _value;
40         balanceOf[_to] += _value;
41         Transfer(_from, _to, _value);
42         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
43         return true;
44     }
45 
46     function approve(address _spender, uint256 _value) public returns (bool success) {
47         allowance[msg.sender][_spender] = _value;
48         return true;
49     }
50 
51     function burn(uint256 _value) public returns (bool success) {
52         require(balanceOf[msg.sender] >= _value);
53         balanceOf[msg.sender] -= _value;
54         totalSupply -= _value;
55         Burn(msg.sender, _value);
56         return true;
57     }
58 
59     function burnFrom(address _from, uint256 _value) public returns (bool success) {
60         require(balanceOf[_from] >= _value);
61         require(_value <= allowance[_from][msg.sender]);
62         balanceOf[_from] -= _value;
63         allowance[_from][msg.sender] -= _value;
64         totalSupply -= _value;
65         Burn(_from, _value);
66         return true;
67     }
68 }