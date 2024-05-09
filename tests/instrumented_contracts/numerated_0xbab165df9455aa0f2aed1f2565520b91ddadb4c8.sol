1 pragma solidity ^0.4.16;
2 
3 contract EKT {
4 
5     string public name = "EDUCare";      //  token name
6     string public symbol = "EKT";           //  token symbol
7     uint256 public decimals = 8;            //  token digit
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply = 0;
13 
14     address owner = 0x0;
15 
16     uint256 constant valueTotal = 10 * 10000 * 10000 * 100000000;  //总量 10亿
17     uint256 constant valueFounder = valueTotal / 100 * 50;  // 基金会50%
18     uint256 constant valueSale = valueTotal / 100 * 15;  // ICO 15%
19     uint256 constant valueVip = valueTotal / 100 * 20;  // 私募 20%
20     uint256 constant valueTeam = valueTotal / 100 * 15;  // 团队与合作伙伴 15%
21 
22     modifier isOwner {
23         assert(owner == msg.sender);
24         _;
25     }
26 
27     modifier validAddress(address _address) {
28         assert(0x0 != _address);
29         _;
30     }
31 
32 
33     function EKT(address _founder, address _sale, address _vip, address _team)
34         public
35         validAddress(_founder)
36         validAddress(_sale)
37         validAddress(_vip)
38         validAddress(_team)
39     {
40         owner = msg.sender;
41         totalSupply = valueTotal;
42 
43         // 基金会
44         balanceOf[_founder] = valueFounder;
45         Transfer(0x0, _founder, valueFounder);
46 
47         // ICO
48         balanceOf[_sale] = valueSale;
49         Transfer(0x0, _sale, valueSale);
50 
51         // 私募
52         balanceOf[_vip] = valueVip;
53         Transfer(0x0, _vip, valueVip);
54 
55         // 团队
56         balanceOf[_team] = valueTeam;
57         Transfer(0x0, _team, valueTeam);
58 
59     }
60 
61     function transfer(address _to, uint256 _value)
62         public
63         validAddress(_to)
64         returns (bool success)
65     {
66         require(balanceOf[msg.sender] >= _value);
67         require(balanceOf[_to] + _value >= balanceOf[_to]);
68         balanceOf[msg.sender] -= _value;
69         balanceOf[_to] += _value;
70         Transfer(msg.sender, _to, _value);
71         return true;
72     }
73 
74     function transferFrom(address _from, address _to, uint256 _value)
75         public
76         validAddress(_from)
77         validAddress(_to)
78         returns (bool success)
79     {
80         require(balanceOf[_from] >= _value);
81         require(balanceOf[_to] + _value >= balanceOf[_to]);
82         require(allowance[_from][msg.sender] >= _value);
83         balanceOf[_to] += _value;
84         balanceOf[_from] -= _value;
85         allowance[_from][msg.sender] -= _value;
86         Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     function approve(address _spender, uint256 _value)
91         public
92         validAddress(_spender)
93         returns (bool success)
94     {
95         require(_value == 0 || allowance[msg.sender][_spender] == 0);
96         allowance[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101 
102     event Transfer(address indexed _from, address indexed _to, uint256 _value);
103     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
104 }