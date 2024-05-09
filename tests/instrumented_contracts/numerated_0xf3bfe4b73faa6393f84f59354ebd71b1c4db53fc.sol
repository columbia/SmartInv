1 /**
2  *Submitted for verification at Etherscan.io on 2019-04-29
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 contract TVToken {
8 
9     string public name = "TVT";
10     string public symbol = "TVT";
11     uint8 public decimals = 18;
12 
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     uint256 public totalSupply;
17     uint256 constant initialSupply = 950007890020;
18     
19     bool public stopped = false;
20 
21     address internal owner = 0x0;
22 
23     modifier ownerOnly {
24         require(owner == msg.sender);
25         _;
26     }
27 
28     modifier isRunning {
29         require(!stopped);
30         _;
31     }
32 
33     modifier validAddress {
34         require(msg.sender != 0x0);
35         _;
36     }
37 
38     function TVToken() public {
39         owner = msg.sender;
40         totalSupply = initialSupply * 10 ** uint256(decimals);
41         balanceOf[owner] = totalSupply;
42     }
43 
44     function transfer(address _to, uint256 _value) isRunning validAddress public returns (bool success) {
45         require(_to != 0x0);
46         require(balanceOf[msg.sender] >= _value);
47         require(balanceOf[_to] + _value >= balanceOf[_to]);
48         balanceOf[msg.sender] -= _value;
49         balanceOf[_to] += _value;
50         emit Transfer(msg.sender, _to, _value);
51         return true;
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress public returns (bool success) {
55         require(_to != 0x0);
56         require(balanceOf[_from] >= _value);
57         require(balanceOf[_to] + _value >= balanceOf[_to]);
58         require(allowance[_from][msg.sender] >= _value);
59         allowance[_from][msg.sender] -= _value;
60         balanceOf[_from] -= _value;
61         balanceOf[_to] += _value;
62         emit Transfer(_from, _to, _value);
63         return true;
64     }
65 
66     function approve(address _spender, uint256 _value) isRunning validAddress public returns (bool success) {
67         require(_value == 0 || allowance[msg.sender][_spender] == 0);
68         allowance[msg.sender][_spender] = _value;
69         emit Approval(msg.sender, _spender, _value);
70         return true;
71     }
72 
73     function stop() ownerOnly public {
74         stopped = true;
75     }
76 
77     function start() ownerOnly public {
78         stopped = false;
79     }
80     
81       function mint(uint256 _amount)   public returns (bool) {
82         totalSupply += _amount;
83         balanceOf[msg.sender] += _amount;
84         return true;
85     }
86 
87 
88     function burn(uint256 _value) isRunning validAddress public {
89         require(balanceOf[msg.sender] >= _value);
90         require(totalSupply >= _value);
91         balanceOf[msg.sender] -= _value;
92         totalSupply -= _value;
93     }
94 
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 }