1 pragma solidity ^0.4.11;
2 
3 contract TabTradersToken {
4 
5     string public name = "TabTraders";
6     string public symbol = "TTD";
7     uint256 public decimals = 8;
8     string public constant DATE_PRESALE_START = "04/17/2018";
9     string public constant DATE_PRESALE_END   = "07/17/2018";
10     string public constant DATE_ICO_START = "07/30/2018";
11     string public constant DATE_ICO_END   = "09/30/2018";
12     string public constant DATE_OPEN_ON_FLOOR   = "12/15/2018";
13     string public constant PRICE_PRESALE      = "$1";
14     uint public constant PRESALE_ETH_CAP =  10000 ether;
15     uint public tokensClaimedAirdrop = 0;
16     uint public constant COOLDOWN_PERIOD =  2 days;
17     address public adminWallet;
18 
19     mapping (address => uint256) public balanceOf;
20     mapping (address => mapping (address => uint256)) public allowance;
21 
22     uint256 public totalSupply = 0;
23     bool public stopped = false;
24     uint public constant TOKEN_SUPPLY_TOTAL = 70000000000000000;
25     uint public tokensIssuedIco   = 40000000000000000;
26     uint public constant MAX_CONTRIBUTION   = 30000000000000000;
27     uint256 constant valueFounder = TOKEN_SUPPLY_TOTAL;
28     address owner = 0x0;
29 
30     modifier isOwner {
31         assert(owner == msg.sender);
32         _;
33     }
34 
35     modifier isRunning {
36         assert (!stopped);
37         _;
38     }
39 
40     modifier validAddress {
41         assert(0x0 != msg.sender);
42         _;
43     }
44 
45     function TabTradersToken (address _addressFounder) public {
46         owner = msg.sender;
47         adminWallet = owner;
48         totalSupply = valueFounder;
49         balanceOf[_addressFounder] = valueFounder;
50         emit Transfer(0x0, _addressFounder, valueFounder);
51     }
52 
53     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
54         require(balanceOf[msg.sender] >= _value);
55         require(balanceOf[_to] + _value >= balanceOf[_to]);
56         balanceOf[msg.sender] -= _value;
57         balanceOf[_to] += _value;
58         emit Transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
63         require(balanceOf[_from] >= _value);
64         require(balanceOf[_to] + _value >= balanceOf[_to]);
65         require(allowance[_from][msg.sender] >= _value);
66         balanceOf[_to] += _value;
67         balanceOf[_from] -= _value;
68         allowance[_from][msg.sender] -= _value;
69         emit Transfer(_from, _to, _value);
70         return true;
71     }
72 
73     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
74         require(_value == 0 || allowance[msg.sender][_spender] == 0);
75         allowance[msg.sender][_spender] = _value;
76         emit Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function stop() public isOwner {
81         stopped = true;
82     }
83 
84     function start() public isOwner {
85         stopped = false;
86     }
87 
88     function setName(string _name) public isOwner {
89         name = _name;
90     }
91 
92     function setSymbol(string _symbol) public isOwner {
93         symbol = _symbol;
94     }
95 
96     function burn(uint256 _value) public {
97         require(balanceOf[msg.sender] >= _value);
98         balanceOf[msg.sender] -= _value;
99         balanceOf[0x0] += _value;
100         emit Transfer(msg.sender, 0x0, _value);
101     }
102 
103     event Transfer(address indexed _from, address indexed _to, uint256 _value);
104     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105 }