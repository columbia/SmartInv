1 pragma solidity ^0.4.18;
2 
3 contract TokenBlueGoldERC20 {
4     string private constant _name = "BlueGold";
5     string private constant _symbol = "BEG";
6     uint8 private constant _decimals = 8;
7     uint256 private constant _initialSupply = 15000000;
8     uint256 private constant _totalSupply = _initialSupply * (10 ** uint256(_decimals));
9 
10     mapping (address => uint256) private _balanceOf;
11     mapping (address => mapping (address => uint256)) private _allowance;
12 
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 
16     function TokenBlueGoldERC20() public {
17         address sender = msg.sender;
18 
19         _balanceOf[sender] = _totalSupply;
20     }
21 
22     function name() public pure returns (string) {
23         return _name;
24     }
25 
26     function symbol() public pure returns (string) {
27         return _symbol;
28     }
29 
30     function decimals() public pure returns (uint8) {
31         return _decimals;
32     }
33 
34     function totalSupply() public pure returns (uint256) {
35         return _totalSupply;
36     }
37 
38     function balanceOf(address _ownerAddress) public view returns (uint256) {
39         return _balanceOf[_ownerAddress];
40     }
41 
42     function transfer(address _to, uint256 _value) public returns (bool)  {
43         address sender = msg.sender;
44 
45         _transfer(sender, _to, _value);
46 
47         return true;
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
51         address sender = msg.sender;
52 
53         require(_value <= _allowance[_from][sender]);
54         _reduceAllowanceLimit(_from, _value);
55         _transfer(_from, _to, _value);
56 
57         return true;
58     }
59 
60     function _reduceAllowanceLimit(address _from, uint256 _value) internal {
61         address sender = msg.sender;
62 
63         _allowance[_from][sender] -= _value;
64     }
65 
66     function _transfer(address _from, address _to, uint256 _value) internal {
67         _preValidTransfer(_from, _to, _value);
68 
69         uint256 previousBalances = _balanceOf[_from] + _balanceOf[_to];
70 
71         _sendToken(_from, _to, _value);
72 
73         assert(_balanceOf[_from] + _balanceOf[_to] == previousBalances);
74     }
75 
76     function _preValidTransfer(address _from, address _to, uint256 _value) view internal {
77         require(_to != 0x0);
78         require(_value > 0);
79         require(_balanceOf[_from] >= _value);
80     }
81 
82     function _sendToken(address _from, address _to, uint256 _value) internal {
83         _balanceOf[_from] -= _value;
84         _balanceOf[_to] += _value;
85         Transfer(_from, _to, _value);
86     }
87 
88     function approve(address _spender, uint256 _value) public returns (bool) {
89         address sender = msg.sender;
90 
91         _allowance[sender][_spender] = _value;
92         Approval(sender, _spender, _value);
93 
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) public view returns (uint256) {
98         return _allowance[_owner][_spender];
99     }
100 }