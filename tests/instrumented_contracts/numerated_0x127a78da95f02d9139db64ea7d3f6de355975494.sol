1 pragma solidity ^0.4.24;
2 
3 contract DACToken {
4 
5     string public name = "Decentralized Accessible Content";
6     string public symbol = "DAC";
7     uint256 public decimals = 6;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply = 30000000000000000;
13     bool public stopped = false;
14     address owner = 0x1e113613C889C76b792AdfdcbBd155904F3310a5;
15 
16     modifier isOwner {
17         assert(owner == msg.sender);
18         _;
19     }
20 
21     modifier isRunning {
22         assert(!stopped);
23         _;
24     }
25 
26     modifier isValidAddress {
27         assert(0x0 != msg.sender);
28         _;
29     }
30 
31     constructor() public {
32         balanceOf[owner] = totalSupply;
33         emit Transfer(0x0, owner, totalSupply);
34     }
35 
36     function transfer(address _to, uint256 _value) isRunning isValidAddress public returns (bool success) {
37         require(balanceOf[msg.sender] >= _value);
38         require(balanceOf[_to] + _value >= balanceOf[_to]);
39         balanceOf[msg.sender] -= _value;
40         balanceOf[_to] += _value;
41         emit Transfer(msg.sender, _to, _value);
42         return true;
43     }
44 
45     function transferFrom(address _from, address _to, uint256 _value) isRunning isValidAddress public returns (bool success) {
46         require(balanceOf[_from] >= _value);
47         require(balanceOf[_to] + _value >= balanceOf[_to]);
48         require(allowance[_from][msg.sender] >= _value);
49         balanceOf[_to] += _value;
50         balanceOf[_from] -= _value;
51         allowance[_from][msg.sender] -= _value;
52         emit Transfer(_from, _to, _value);
53         return true;
54     }
55 
56     function approve(address _spender, uint256 _value) isRunning isValidAddress public returns (bool success) {
57         require(_value == 0 || allowance[msg.sender][_spender] == 0);
58         allowance[msg.sender][_spender] = _value;
59         emit Approval(msg.sender, _spender, _value);
60         return true;
61     }
62 
63     function stop() isOwner public {
64         stopped = true;
65     }
66 
67     function start() isOwner public {
68         stopped = false;
69     }
70 
71     function setName(string _name) isOwner public {
72         name = _name;
73     }
74 
75     function airdrop(address[] _DACusers,uint256[] _values) isRunning public {
76         require(_DACusers.length > 0);
77         require(_DACusers.length == _values.length);
78         uint256 amount = 0;
79         uint i = 0;
80         for (i = 0; i < _DACusers.length; i++) {
81             require(amount + _values[i] >= amount);
82             amount += _values[i];  
83         }
84         require(balanceOf[msg.sender] >= amount);
85         balanceOf[msg.sender] -= amount;
86         for (i = 0; i < _DACusers.length; i++) {
87             require(balanceOf[_DACusers[i]] + _values[i] >= balanceOf[_DACusers[i]]);
88             balanceOf[_DACusers[i]] += _values[i];
89             emit Transfer(msg.sender, _DACusers[i], _values[i]);
90         }
91     }
92     
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95 }