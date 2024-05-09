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
27 contract Variant is SafeMath {
28     string public constant standard = 'Token 0.1';
29     uint8 public constant decimals = 18;
30 
31     // you need change the following three values
32     string public constant name = 'Variant';
33     string public constant symbol = 'VAR';
34     uint256 public totalSupply = 10**9 * 10**uint256(decimals);
35 
36     mapping (address => uint256) public balanceOf;
37     mapping (address => mapping (address => uint256)) public allowance;
38 
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 
42     function Variant() public {
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
71         // To change the approve amount you first have to reduce the addresses`
72         //  allowance to zero by calling `approve(_spender, 0)` if it is not
73         //  already 0 to mitigate the race condition described here:
74         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75         require(_value == 0 || allowance[msg.sender][_spender] == 0);
76         allowance[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     // disable pay QTUM to this contract
82     function () public payable {
83         revert();
84     }
85 }