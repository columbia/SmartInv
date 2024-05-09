1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4 
5     function SafeMath() {
6     }
7 
8     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
9         uint256 z = _x + _y;
10         assert(z >= _x);
11         return z;
12     }
13 
14     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
15         assert(_x >= _y);
16         return _x - _y;
17     }
18 
19     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
20         uint256 z = _x * _y;
21         assert(_x == 0 || z / _x == _y);
22         return z;
23     }
24 
25 }
26 
27 contract YFB59 is SafeMath {
28     string public constant standard = 'Token 0.1';
29     uint8 public constant decimals = 18;
30 
31     string public constant name = '59 Nourishment Treasure';
32     string public constant symbol = '59YFB';
33     uint256 public totalSupply = 1 * 10**8 * 10**uint256(decimals);
34 
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41     function YFB59() public {
42         Transfer(0x00, msg.sender, totalSupply);
43         balanceOf[msg.sender] = totalSupply;
44     }
45 
46     function transfer(address _to, uint256 _value)
47     public
48     returns (bool success)
49     {
50         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
51         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
52         Transfer(msg.sender, _to, _value);
53         return true;
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value)
57     public
58     returns (bool success)
59     {
60         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
61         balanceOf[_from] = safeSub(balanceOf[_from], _value);
62         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
63         Transfer(_from, _to, _value);
64         return true;
65     }
66 
67     function approve(address _spender, uint256 _value)
68     public
69     returns (bool success)
70     {
71         require(_value == 0 || allowance[msg.sender][_spender] == 0);
72         allowance[msg.sender][_spender] = _value;
73         Approval(msg.sender, _spender, _value);
74         return true;
75     }
76 
77     function () public payable {
78         revert();
79     }
80 }