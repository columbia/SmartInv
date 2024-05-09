1 pragma solidity ^0.4.11;
2 
3 contract AZCToken {
4 
5     string public name = "AZC";
6     string public symbol = "AZC";
7     uint256 public decimals = 8;
8     string public constant PRICE_PRESALE = "$0.1";
9     address public adminWallet;
10 
11     mapping(address => uint256) public balanceOf;
12     mapping(address => mapping(address => uint256)) public allowance;
13 
14     uint256 public totalSupply = 0;
15     bool public stopped = false;
16     uint public constant TOKEN_SUPPLY_TOTAL = 20000000000000000;
17     uint public tokensIssuedIco = 14000000000000000;
18     uint256 constant valueFounder = TOKEN_SUPPLY_TOTAL;
19     address owner = 0x0;
20 
21     modifier isOwner {
22         assert(owner == msg.sender);
23         _;
24     }
25 
26     modifier isRunning {
27         assert(!stopped);
28         _;
29     }
30 
31     modifier validAddress {
32         assert(0x0 != msg.sender);
33         _;
34     }
35 
36     function AZCToken(address _addressFounder) public {
37         owner = msg.sender;
38         adminWallet = owner;
39         totalSupply = valueFounder;
40         balanceOf[_addressFounder] = valueFounder;
41         emit Transfer(0x0, _addressFounder, valueFounder);
42     }
43 
44     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
45         require(balanceOf[msg.sender] >= _value);
46         require(balanceOf[_to] + _value >= balanceOf[_to]);
47         balanceOf[msg.sender] -= _value;
48         balanceOf[_to] += _value;
49         emit Transfer(msg.sender, _to, _value);
50         return true;
51     }
52 
53     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
54         require(balanceOf[_from] >= _value);
55         require(balanceOf[_to] + _value >= balanceOf[_to]);
56         require(allowance[_from][msg.sender] >= _value);
57         balanceOf[_to] += _value;
58         balanceOf[_from] -= _value;
59         allowance[_from][msg.sender] -= _value;
60         emit Transfer(_from, _to, _value);
61         return true;
62     }
63 
64     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
65         require(_value == 0 || allowance[msg.sender][_spender] == 0);
66         allowance[msg.sender][_spender] = _value;
67         emit Approval(msg.sender, _spender, _value);
68         return true;
69     }
70 
71     function stop() public isOwner {
72         stopped = true;
73     }
74 
75     function start() public isOwner {
76         stopped = false;
77     }
78 
79     function setName(string _name) public isOwner {
80         name = _name;
81     }
82 
83     function setSymbol(string _symbol) public isOwner {
84         symbol = _symbol;
85     }
86 
87     function burn(uint256 _value) public {
88         require(balanceOf[msg.sender] >= _value);
89         balanceOf[msg.sender] -= _value;
90         balanceOf[0x0] += _value;
91         emit Transfer(msg.sender, 0x0, _value);
92     }
93 
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 }