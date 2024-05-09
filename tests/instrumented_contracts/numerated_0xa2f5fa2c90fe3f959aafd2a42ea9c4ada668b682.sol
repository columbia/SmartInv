1 pragma solidity ^0.4.11;
2 
3 contract FastChat {
4 
5     string public name = "FastChat";
6     string public symbol = "FAC";
7     uint256 public decimals = 6;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply = 0;
13     bool public stopped = false;
14 
15     uint256 constant valueFounder = 10000000000000000;
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
33     constructor(address _addressFounder) public {
34         owner = msg.sender;
35         totalSupply = valueFounder;
36         balanceOf[_addressFounder] = valueFounder;
37         emit Transfer(0x0, _addressFounder, valueFounder);
38     }
39 
40     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
41         require(balanceOf[msg.sender] >= _value);
42         require(balanceOf[_to] + _value >= balanceOf[_to]);
43         balanceOf[msg.sender] -= _value;
44         balanceOf[_to] += _value;
45         emit Transfer(msg.sender, _to, _value);
46         return true;
47     }
48 
49     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
50         require(balanceOf[_from] >= _value);
51         require(balanceOf[_to] + _value >= balanceOf[_to]);
52         require(allowance[_from][msg.sender] >= _value);
53         balanceOf[_to] += _value;
54         balanceOf[_from] -= _value;
55         allowance[_from][msg.sender] -= _value;
56         emit Transfer(_from, _to, _value);
57         return true;
58     }
59 
60     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
61         require(_value == 0 || allowance[msg.sender][_spender] == 0);
62         allowance[msg.sender][_spender] = _value;
63         emit Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function stop() public isOwner {
68         stopped = true;
69     }
70 
71     function start() public isOwner {
72         stopped = false;
73     }
74 
75     function setName(string _name) public isOwner {
76         name = _name;
77     }
78 
79     function burn(uint256 _value) public {
80         require(balanceOf[msg.sender] >= _value);
81         balanceOf[msg.sender] -= _value;
82         balanceOf[0x0] += _value;
83         emit Transfer(msg.sender, 0x0, _value);
84     }
85 
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88 }