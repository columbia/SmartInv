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
27 contract PIGT is SafeMath {
28     string public constant standard = 'Token 0.1';
29     uint8 public constant decimals = 18;
30 
31     // you need change the following three values
32     string public constant name = 'pig token';
33     string public constant symbol = 'PIGT';
34     uint256 public totalSupply = 0.1 * 10**8 * 10**uint256(decimals);
35 
36     mapping (address => uint256) public balanceOf;
37     mapping (address => mapping (address => uint256)) public allowance;
38 
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 
42     function PIGT() public {
43         Transfer(0x00, msg.sender, totalSupply);
44         balanceOf[msg.sender] = totalSupply;
45     }
46 
47     function transfer(address _to, uint256 _value)
48     public
49     returns (bool success)
50     {
51         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
52         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
53         Transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value)
58     public
59     returns (bool success)
60     {
61         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
62         balanceOf[_from] = safeSub(balanceOf[_from], _value);
63         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
64         Transfer(_from, _to, _value);
65         return true;
66     }
67 
68     function approve(address _spender, uint256 _value)
69     public
70     returns (bool success)
71     {
72         // To change the approve amount you first have to reduce the addresses`
73         //  allowance to zero by calling `approve(_spender, 0)` if it is not
74         //  already 0 to mitigate the race condition described here:
75         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76         require(_value == 0 || allowance[msg.sender][_spender] == 0);
77         allowance[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     // disable pay ETH to this contract
83     function () public payable {
84         revert();
85     }
86 }