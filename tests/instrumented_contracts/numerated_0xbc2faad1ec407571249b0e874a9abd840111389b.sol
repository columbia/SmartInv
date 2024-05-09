1 pragma solidity ^0.4.22;
2 
3 contract BFXToken {
4 
5     string public name = "BFX";
6     string public symbol = "BFX";
7     string public constant icoStart = "2019/10/07";
8     string public constant icoEnd = "2019/10/07";
9     string public constant tokenDistribution = "2019/10/08";
10     string public constant listingExchange = "2019/10/07";
11     
12     uint256 public constant decimals = 8;
13     address public adminWallet;
14 
15     mapping(address => uint256) public balanceOf;
16     mapping(address => mapping(address => uint256)) public allowance;
17 
18     uint256 public totalSupply = 0;
19     bool public stopped = false;
20     uint public constant supplyNumber = 200000000;
21     uint public constant powNumber = 10;
22     uint public constant TOKEN_SUPPLY_TOTAL = supplyNumber * powNumber ** decimals;
23     uint256 constant valueFounder = TOKEN_SUPPLY_TOTAL;
24     string public constant icoPrice = "$1";
25     address owner = 0x0;
26 
27     modifier isOwner {
28         assert(owner == msg.sender);
29         _;
30     }
31 
32     modifier isRunning {
33         assert(!stopped);
34         _;
35     }
36 
37     modifier validAddress {
38         assert(0x0 != msg.sender);
39         _;
40     }
41 
42     constructor() public {
43         owner = msg.sender;
44         adminWallet = owner;
45         totalSupply = valueFounder;
46         balanceOf[owner] = valueFounder;
47         emit Transfer(0x0, owner, valueFounder);
48     }
49 
50     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
51         require(balanceOf[msg.sender] >= _value);
52         require(balanceOf[_to] + _value >= balanceOf[_to]);
53         balanceOf[msg.sender] -= _value;
54         balanceOf[_to] += _value;
55         emit Transfer(msg.sender, _to, _value);
56         return true;
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
60 
61         require(balanceOf[_from] >= _value);
62         require(balanceOf[_to] + _value >= balanceOf[_to]);
63         require(allowance[_from][msg.sender] >= _value);
64         balanceOf[_to] += _value;
65         balanceOf[_from] -= _value;
66         allowance[_from][msg.sender] -= _value;
67         emit Transfer(_from, _to, _value);
68         return true;
69     }
70 
71     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
72         require(_value == 0 || allowance[msg.sender][_spender] == 0);
73         allowance[msg.sender][_spender] = _value;
74         emit Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function stop() public isOwner {
79         stopped = true;
80     }
81 
82     function start() public isOwner {
83         stopped = false;
84     }
85 
86     function setName(string _name) public isOwner {
87         name = _name;
88     }
89 
90     function setSymbol(string _symbol) public isOwner {
91         symbol = _symbol;
92     }
93 
94     function burn(uint256 _value) public {
95         require(balanceOf[msg.sender] >= _value);
96         balanceOf[msg.sender] -= _value;
97         balanceOf[0x0] += _value;
98         emit Transfer(msg.sender, 0x0, _value);
99     }
100 
101     event Transfer(address indexed _from, address indexed _to, uint256 _value);
102     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
103 }