1 pragma solidity ^0.4.15;
2 
3 contract ERC20 {
4     function totalSupply() external constant returns (uint256 _totalSupply);
5     function balanceOf(address _owner) external constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) external returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
8     function approve(address _spender, uint256 _old, uint256 _new) external returns (bool success);
9     function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 
13     function ERC20() internal {
14     }
15 }
16 
17 library SafeMath {
18     uint256 constant private    MAX_UINT256     = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
19 
20     function safeAdd (uint256 x, uint256 y) internal pure returns (uint256 z) {
21         assert (x <= MAX_UINT256 - y);
22         return x + y;
23     }
24 
25     function safeSub (uint256 x, uint256 y) internal pure returns (uint256 z) {
26         assert (x >= y);
27         return x - y;
28     }
29 
30     function safeMul (uint256 x, uint256 y) internal pure returns (uint256 z) {
31         z = x * y;
32         assert(x == 0 || z / x == y);
33     }
34 
35     function safeDiv (uint256 x, uint256 y) internal pure returns (uint256 z) {
36         z = x / y;
37         return z;
38     }
39 }
40 
41 contract DetailedERC20 is ERC20 {
42 
43     using SafeMath for uint256;
44 
45     address public              owner;
46 
47     string  public              name;
48     string  public              symbol;
49     uint8   public              decimals;
50     string  public              description;
51     uint256 private             summarySupply;
52 
53     mapping(address => uint256)                      private   accounts;
54     mapping(address => mapping (address => uint256)) private   allowed;
55 
56     function DetailedERC20(string _name, string _symbol,string _description, uint8 _decimals, uint256 _startTokens) public {
57         owner = msg.sender;
58 
59         accounts[owner]  = _startTokens;
60         summarySupply    = _startTokens;
61         name = _name;
62         symbol = _symbol;
63         decimals = _decimals;
64         description = _description;
65     }
66 
67     modifier onlyPayloadSize(uint size) {
68         assert(msg.data.length >= size + 4);
69         _;
70     }
71 
72     function transfer(address _to, uint256 _value) onlyPayloadSize(64) external returns (bool success) {
73         if (accounts[msg.sender] >= _value) {
74             accounts[msg.sender] = accounts[msg.sender].safeSub(_value);
75             accounts[_to] = accounts[_to].safeAdd(_value);
76             Transfer(msg.sender, _to, _value);
77             return true;
78         } else {
79             return false;
80         }
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(64) external returns (bool success) {
84         if ((accounts[_from] >= _value) && (allowed[_from][msg.sender] >= _value)) {
85             accounts[_from] = accounts[_from].safeSub(_value);
86             allowed[_from][msg.sender] = allowed[_from][msg.sender].safeSub(_value);
87             accounts[_to] = accounts[_to].safeAdd(_value);
88             Transfer(_from, _to, _value);
89             return true;
90         } else {
91             return false;
92         }
93     }
94 
95     function approve(address _spender, uint256 _old, uint256 _new) onlyPayloadSize(64) external returns (bool success) {
96         if (_old == allowed[msg.sender][_spender]) {
97             allowed[msg.sender][_spender] = _new;
98             Approval(msg.sender, _spender, _new);
99             return true;
100         } else {
101             return false;
102         }
103     }
104 
105     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
106         return allowed[_owner][_spender];
107     }
108 
109     function balanceOf(address _owner) external constant returns (uint256 balance) {
110         if (_owner == 0x00)
111             return accounts[msg.sender];
112         return accounts[_owner];
113     }
114 
115     function totalSupply() external constant returns (uint256 _totalSupply) {
116         _totalSupply = summarySupply;
117     }
118 }