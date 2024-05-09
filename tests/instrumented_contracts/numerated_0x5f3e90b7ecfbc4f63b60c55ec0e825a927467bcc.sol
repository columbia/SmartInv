1 pragma solidity ^0.4.26;
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
35 contract Owned {
36     address public owner;
37     address public newOwner;
38 
39     event OwnershipTransferred(address indexed _from, address indexed _to);
40 
41     constructor() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address _newOwner) public onlyOwner {
51         newOwner = _newOwner;
52     }
53     function acceptOwnership() public {
54         require(msg.sender == newOwner);
55         emit OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57         newOwner = address(0);
58     }
59 }
60 
61 contract MRDF is SafeMath,Owned {
62     string public name = "MRDF Coin";
63     string public symbol = "MRDF";
64     uint8 constant public decimals = 18;
65     mapping(address => uint256)  _balances;
66     mapping(address => mapping(address => uint256)) public _allowed;
67 
68     uint256  public totalSupply = 500000000000 * 10**uint(decimals);
69 
70 
71     constructor () public{
72         _balances[msg.sender] = totalSupply;
73         emit Transfer(0x0, msg.sender, totalSupply);
74     }
75 
76     function balanceOf(address addr) public view returns (uint256) {
77         return _balances[addr];
78     }
79 
80 
81     function transfer(address _to, uint256 _value)  public returns (bool) {
82         if (_to == address(0)) {
83             return burn(_value);
84         } else {
85             require(_balances[msg.sender] >= _value && _value > 0);
86             require(_balances[_to] + _value >= _balances[_to]);
87 
88             _balances[msg.sender] = safeSub(_balances[msg.sender], _value);
89             _balances[_to] = safeAdd(_balances[_to], _value);
90             emit Transfer(msg.sender, _to, _value);
91             return true;
92         }
93     }
94 
95     function burn(uint256 _value) public returns (bool) {
96         require(_balances[msg.sender] >= _value && _value > 0);
97         require(totalSupply >= _value);
98         _balances[msg.sender] = safeSub(_balances[msg.sender], _value);
99         totalSupply = safeSub(totalSupply, _value);
100         emit Burn(msg.sender, _value);
101         return true;
102     }
103 
104     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool) {
105         require(_to != address(0));
106         require(_balances[_from] >= _value && _value > 0);
107         require(_balances[_to] + _value >= _balances[_to]);
108 
109         require(_allowed[_from][msg.sender] >= _value);
110 
111         _balances[_to] = safeAdd(_balances[_to], _value);
112         _balances[_from] = safeSub(_balances[_from], _value);
113         _allowed[_from][msg.sender] = safeSub(_allowed[_from][msg.sender], _value);
114         emit Transfer(_from, _to, _value);
115         return true;
116     }
117 
118     function approve(address spender, uint256 value)  public returns (bool) {
119         require(spender != address(0));
120         _allowed[msg.sender][spender] = value;
121         emit Approval(msg.sender, spender, value);
122         return true;
123     }
124 
125     function allowance(address _master, address _spender) public view returns (uint256) {
126         return _allowed[_master][_spender];
127     }
128     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
129     event Transfer(address indexed _from, address indexed _to, uint256 value);
130     event Burn(address indexed _from, uint256 value);
131 }