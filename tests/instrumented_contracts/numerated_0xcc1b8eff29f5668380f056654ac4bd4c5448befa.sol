1 pragma solidity ^0.4.24;
2 
3 contract FreeLanceToken {
4 
5     string public name = "FreeLance";                                            //by @hilobrain
6     string public symbol = "FRL";           
7     uint256 public decimals = 18;            
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply = 0;
13     bool public stopped = false;
14 
15     uint256 constant valueFounder = 100*10**24;
16     address owner = 0x0;
17 
18     modifier isOwner {
19         assert(owner == msg.sender);
20         _;
21     }
22 
23     modifier isRunning {
24         assert (!stopped);
25         _;
26     }
27 
28     modifier validAddress {
29         assert(0x0 != msg.sender);
30         _;
31     }
32 
33     constructor (address _addressFounder) public {
34         owner = _addressFounder;
35         totalSupply = valueFounder;
36         balanceOf[_addressFounder] = valueFounder;
37         emit Transfer(0x0, _addressFounder, valueFounder);
38     }
39     
40     function transferOwnership(address newOwner) public isOwner {
41         require(newOwner != address(0));
42         owner = newOwner;
43     }
44 
45     function transfer(address _to, uint256 _value) isRunning validAddress public returns (bool success) {
46         require(balanceOf[msg.sender] >= _value);
47         require(balanceOf[_to] + _value >= balanceOf[_to]);
48         balanceOf[msg.sender] -= _value;
49         balanceOf[_to] += _value;
50         emit Transfer(msg.sender, _to, _value);
51         return true;
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress public returns (bool success) {
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
65     function approve(address _spender, uint256 _value) isRunning validAddress public returns (bool success) {
66         require(_value == 0 || allowance[msg.sender][_spender] == 0);
67         allowance[msg.sender][_spender] = _value;
68         emit Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function stop() isOwner public {
73         stopped = true;
74     }
75 
76     function start() isOwner public {
77         stopped = false;
78     }
79 
80     function setName(string _name) isOwner public {
81         name = _name;
82     }
83 
84     function burn(uint256 _value) isOwner public {
85         require(balanceOf[msg.sender] >= _value);
86         balanceOf[msg.sender] -= _value;
87         balanceOf[0x0] += _value;
88         emit Transfer(msg.sender, 0x0, _value);
89         totalSupply = totalSupply - _value;                                         
90     }
91 
92     event Transfer(address indexed _from, address indexed _to, uint256 _value);
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94 }