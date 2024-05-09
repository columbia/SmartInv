1 pragma solidity 0.5.2;
2 
3 contract EAO {
4 
5     string public name = "EasyOption.io Assets Ownership";// token name
6     string public symbol = "EAO";// token symbol
7     uint256 public decimals = 8;// token digit
8     uint256 constant MAX_SUPPLY = 4800000000000000;// max supply
9 
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     uint256 public totalSupply = 0;
14     bool public stopped = false;
15     address owner = address(0);
16 
17     modifier isOwner {
18         assert(owner == msg.sender);
19         _;
20     }
21 
22     modifier isRunning {
23         assert (!stopped);
24         _;
25     }
26 
27     modifier validAddress {
28         assert(address(0) != msg.sender);
29         _;
30     }
31 
32     constructor() public {
33         owner = msg.sender;
34         totalSupply = MAX_SUPPLY;
35         balanceOf[msg.sender] = MAX_SUPPLY;
36         emit Transfer(address(0), msg.sender, MAX_SUPPLY);
37     }
38 
39     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
40         require(balanceOf[msg.sender] >= _value);
41         require(balanceOf[_to] + _value >= balanceOf[_to]);
42         balanceOf[msg.sender] -= _value;
43         balanceOf[_to] += _value;
44         emit Transfer(msg.sender, _to, _value);
45         return true;
46     }
47 
48     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
49         require(allowance[_from][msg.sender] >= _value);
50         require(balanceOf[_from] >= _value);
51         require(balanceOf[_to] + _value >= balanceOf[_to]);
52         allowance[_from][msg.sender] -= _value;
53         balanceOf[_from] -= _value;
54         balanceOf[_to] += _value;
55         emit Transfer(_from, _to, _value);
56         return true;
57     }
58 
59     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
60         require(_value == 0 || allowance[msg.sender][_spender] == 0);
61         allowance[msg.sender][_spender] = _value;
62         emit Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66     function stop() public isOwner {
67         stopped = true;
68     }
69 
70     function start() public isOwner {
71         stopped = false;
72     }
73 
74     function setName(string memory _name) public isOwner {
75         name = _name;
76     }
77 
78     function setSymbol(string memory _symbol) public isOwner {
79         symbol = _symbol;
80     }
81 
82     function burn(uint256 _value) public {
83         require(balanceOf[msg.sender] >= _value);
84         balanceOf[msg.sender] -= _value;
85         balanceOf[address(0)] += _value;
86         emit Transfer(msg.sender, address(0), _value);
87     }
88 
89     event Transfer(address indexed _from, address indexed _to, uint256 _value);
90     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
91 }