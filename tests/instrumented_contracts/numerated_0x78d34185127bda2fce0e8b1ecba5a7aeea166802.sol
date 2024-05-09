1 pragma solidity ^0.4.18;
2 
3 contract HipsterToken {
4 
5     string public name = "Hipster";      //  token name
6     string public symbol = "HIP";           //  token symbol
7     uint256 public decimals = 6;            //  token digit
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply = 65000000000000;
13     address owner = 0x0;
14 
15     modifier validAddress {
16         assert(0x0 != msg.sender);
17         _;
18     }
19 
20     function HipsterToken() {
21         owner = msg.sender;
22         balanceOf[owner] = totalSupply;
23         Transfer(0x0, owner, totalSupply);
24     }
25 
26     function transfer(address _to, uint256 _value) validAddress returns (bool success) {
27         require(balanceOf[msg.sender] >= _value);
28         require(balanceOf[_to] + _value >= balanceOf[_to]);
29         balanceOf[msg.sender] -= _value;
30         balanceOf[_to] += _value;
31         Transfer(msg.sender, _to, _value);
32         return true;
33     }
34 
35     function transferFrom(address _from, address _to, uint256 _value) validAddress returns (bool success) {
36         require(balanceOf[_from] >= _value);
37         require(balanceOf[_to] + _value >= balanceOf[_to]);
38         require(allowance[_from][msg.sender] >= _value);
39         balanceOf[_to] += _value;
40         balanceOf[_from] -= _value;
41         allowance[_from][msg.sender] -= _value;
42         Transfer(_from, _to, _value);
43         return true;
44     }
45 
46     function approve(address _spender, uint256 _value) validAddress returns (bool success) {
47         require(_value == 0 || allowance[msg.sender][_spender] == 0);
48         allowance[msg.sender][_spender] = _value;
49         Approval(msg.sender, _spender, _value);
50         return true;
51     }
52 
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 }