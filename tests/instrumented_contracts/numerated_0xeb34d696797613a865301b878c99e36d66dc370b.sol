1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         _assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
11         _assert(b > 0);
12         uint256 c = a / b;
13         _assert(a == b * c + a % b);
14         return c;
15     }
16 
17     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
18         _assert(b <= a);
19         return a - b;
20     }
21 
22     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         _assert(c >= a && c >= b);
25         return c;
26     }
27 
28     function _assert(bool assertion) internal pure {
29         if (!assertion) {
30             revert();
31         }
32     }
33 }
34 
35 contract RentalChain is SafeMath {
36     string public name = "Rental Chain";
37     string public symbol = "RENTAL";
38     uint8 constant public decimals = 2;
39     mapping(address => uint256)  _balances;
40     mapping(address => mapping(address => uint256)) public _allowed;
41 
42     uint256  public totalSupply = 188 * 100000000 * 100;
43 
44 
45     constructor () public{
46         _balances[msg.sender] = totalSupply;
47         emit Transfer(0x0, msg.sender, totalSupply);
48     }
49 
50     function balanceOf(address addr) public view returns (uint256) {
51         return _balances[addr];
52     }
53 
54 
55     function transfer(address _to, uint256 _value)  public returns (bool) {
56         require(_to != address(0));
57         require(_balances[msg.sender] >= _value && _value > 0);
58         require(_balances[_to] + _value >= _balances[_to]);
59 
60         _balances[msg.sender] = safeSub(_balances[msg.sender], _value);
61         _balances[_to] = safeAdd(_balances[_to], _value);
62         emit Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool) {
67         require(_to != address(0));
68         require(_balances[_from] >= _value && _value > 0);
69         require(_balances[_to] + _value >= _balances[_to]);
70 
71         require(_allowed[_from][msg.sender] >= _value);
72 
73         _balances[_to] = safeAdd(_balances[_to], _value);
74         _balances[_from] = safeSub(_balances[_from], _value);
75         _allowed[_from][msg.sender] = safeSub(_allowed[_from][msg.sender], _value);
76         emit Transfer(_from, _to, _value);
77         return true;
78     }
79 
80     function approve(address spender, uint256 value)  public returns (bool) {
81         require(spender != address(0));
82         _allowed[msg.sender][spender] = value;
83         emit Approval(msg.sender, spender, value);
84         return true;
85     }
86 
87     function allowance(address _master, address _spender) public view returns (uint256) {
88         return _allowed[_master][_spender];
89     }
90 
91     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92     event Transfer(address indexed _from, address indexed _to, uint256 value);
93 }