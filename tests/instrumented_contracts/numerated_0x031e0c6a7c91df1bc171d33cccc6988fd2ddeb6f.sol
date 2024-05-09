1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-20
3 */
4 
5 pragma solidity ^0.4.22;
6 
7 contract TopCoinFXToken {
8 
9     string public name = "TopCoinFX";
10     string public symbol = "TCFX";
11     uint256 public constant decimals = 18;
12     address public adminWallet;
13 
14     mapping(address => uint256) public balanceOf;
15     mapping(address => mapping(address => uint256)) public allowance;
16 
17     uint256 public totalSupply = 0;
18     bool public stopped = false;
19     uint public constant supplyNumber = 1000000000;
20     uint public constant powNumber = 10;
21     uint public constant TOKEN_SUPPLY_TOTAL = supplyNumber * powNumber ** decimals;
22     uint256 constant valueFounder = TOKEN_SUPPLY_TOTAL;
23     address owner = 0x0;
24 
25     modifier isOwner {
26         assert(owner == msg.sender);
27         _;
28     }
29 
30     modifier isRunning {
31         assert(!stopped);
32         _;
33     }
34 
35     modifier validAddress {
36         assert(0x0 != msg.sender);
37         _;
38     }
39 
40     constructor() public {
41         owner = msg.sender;
42         adminWallet = owner;
43         totalSupply = valueFounder;
44         balanceOf[owner] = valueFounder;
45         emit Transfer(0x0, owner, valueFounder);
46     }
47 
48     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
49         require(balanceOf[msg.sender] >= _value);
50         require(balanceOf[_to] + _value >= balanceOf[_to]);
51         balanceOf[msg.sender] -= _value;
52         balanceOf[_to] += _value;
53         emit Transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
58 
59         require(balanceOf[_from] >= _value);
60         require(balanceOf[_to] + _value >= balanceOf[_to]);
61         require(allowance[_from][msg.sender] >= _value);
62         balanceOf[_to] += _value;
63         balanceOf[_from] -= _value;
64         allowance[_from][msg.sender] -= _value;
65         emit Transfer(_from, _to, _value);
66         return true;
67     }
68 
69     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
70         require(_value == 0 || allowance[msg.sender][_spender] == 0);
71         allowance[msg.sender][_spender] = _value;
72         emit Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     function stop() public isOwner {
77         stopped = true;
78     }
79 
80     function start() public isOwner {
81         stopped = false;
82     }
83 
84     function setName(string _name) public isOwner {
85         name = _name;
86     }
87 
88     function setSymbol(string _symbol) public isOwner {
89         symbol = _symbol;
90     }
91 
92     function burn(uint256 _value) public {
93         require(balanceOf[msg.sender] >= _value);
94         balanceOf[msg.sender] -= _value;
95         balanceOf[0x0] += _value;
96         emit Transfer(msg.sender, 0x0, _value);
97     }
98 
99     event Transfer(address indexed _from, address indexed _to, uint256 _value);
100     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
101 }