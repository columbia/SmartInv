1 pragma solidity ^0.4.22;
2 
3 contract ATBankToken {
4 
5     string public name = "ATBank";
6     string public symbol = "ATB";
7     uint256 public constant decimals = 18;
8     address public adminWallet;
9 
10     mapping(address => uint256) public balanceOf;
11     mapping(address => mapping(address => uint256)) public allowance;
12 
13     uint256 public totalSupply = 0;
14     bool public stopped = false;
15     uint public constant supplyNumber = 29000000;
16     uint public constant powNumber = 10;
17     uint public constant TOKEN_SUPPLY_TOTAL = supplyNumber * powNumber ** decimals;
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
36     constructor() public {
37         owner = msg.sender;
38         adminWallet = owner;
39         totalSupply = valueFounder;
40         balanceOf[owner] = valueFounder;
41         emit Transfer(0x0, owner, valueFounder);
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
54 
55         require(balanceOf[_from] >= _value);
56         require(balanceOf[_to] + _value >= balanceOf[_to]);
57         require(allowance[_from][msg.sender] >= _value);
58         balanceOf[_to] += _value;
59         balanceOf[_from] -= _value;
60         allowance[_from][msg.sender] -= _value;
61         emit Transfer(_from, _to, _value);
62         return true;
63     }
64 
65     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
66         require(_value == 0 || allowance[msg.sender][_spender] == 0);
67         allowance[msg.sender][_spender] = _value;
68         emit Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function stop() public isOwner {
73         stopped = true;
74     }
75 
76     function start() public isOwner {
77         stopped = false;
78     }
79 
80     function setName(string _name) public isOwner {
81         name = _name;
82     }
83 
84     function setSymbol(string _symbol) public isOwner {
85         symbol = _symbol;
86     }
87 
88     function burn(uint256 _value) public {
89         require(balanceOf[msg.sender] >= _value);
90         balanceOf[msg.sender] -= _value;
91         balanceOf[0x0] += _value;
92         emit Transfer(msg.sender, 0x0, _value);
93     }
94 
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 }