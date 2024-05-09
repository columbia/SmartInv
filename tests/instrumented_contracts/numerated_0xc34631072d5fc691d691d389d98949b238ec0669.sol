1 /**
2  * Source Code first verified at https://etherscan.io on Monday, August 28, 2017
3  (UTC) */
4 pragma solidity >=0.4.24;
5 contract BOXToken {
6 
7     string public name = "BOX";      //  token name
8     string public symbol = "BOX";           //  token symbol
9     uint256 public decimals = 6;            //  token digit
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     uint256 public totalSupply = 0;
15     bool public stopped = false;
16 
17     uint256 constant valueFounder = 10000000000000000;
18     address owner = 0x0;
19 
20     modifier isOwner {
21         assert(owner == msg.sender);
22         _;
23     }
24 
25     modifier isRunning {
26         assert (!stopped);
27         _;
28     }
29 
30     modifier validAddress {
31         assert(0x0 != msg.sender);
32         _;
33     }
34 
35     constructor(address _addressFounder) public{
36         owner = msg.sender;
37         totalSupply = valueFounder;
38         balanceOf[_addressFounder] = valueFounder;
39         emit Transfer(0x0, _addressFounder, valueFounder);
40     }
41 
42     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
43         require(balanceOf[msg.sender] >= _value);
44         require(balanceOf[_to] + _value >= balanceOf[_to]);
45         balanceOf[msg.sender] -= _value;
46         balanceOf[_to] += _value;
47         emit Transfer(msg.sender, _to, _value);
48         return true;
49     }
50 
51     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
52         require(balanceOf[_from] >= _value);
53         require(balanceOf[_to] + _value >= balanceOf[_to]);
54         require(allowance[_from][msg.sender] >= _value);
55         balanceOf[_to] += _value;
56         balanceOf[_from] -= _value;
57         allowance[_from][msg.sender] -= _value;
58         emit Transfer(_from, _to, _value);
59         return true;
60     }
61 
62     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
63         require(_value == 0 || allowance[msg.sender][_spender] == 0);
64         allowance[msg.sender][_spender] = _value;
65         emit Approval(msg.sender, _spender, _value);
66         return true;
67     }
68 
69     function stop() public isOwner {
70         stopped = true;
71     }
72 
73     function start() public isOwner {
74         stopped = false;
75     }
76 
77     function setName(string memory  _name) public  isOwner  {
78         name = _name;
79     }
80 
81     function burn(uint256 _value) public {
82         require(balanceOf[msg.sender] >= _value);
83         balanceOf[msg.sender] -= _value;
84         balanceOf[0x0] += _value;
85         emit Transfer(msg.sender, 0x0, _value);
86     }
87 
88     event Transfer(address indexed _from, address indexed _to, uint256 _value);
89     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90 }