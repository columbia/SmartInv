1 contract DPNPlusToken {
2 
3     string public name = "DIPNET PLUS";      //  token name
4     string public symbol = "DPN+";           //  token symbol
5     uint256 public decimals = 8;             //  token digit
6 
7     mapping (address => uint256) public balanceOf;
8     mapping (address => mapping (address => uint256)) public allowance;
9 
10     uint256 public totalSupply = 0;
11     bool public stopped = false;
12 
13     uint256 constant valueFounder = 10000000000000000000;
14     address public owner = 0x0;
15 
16     modifier isOwner {
17         assert(owner == msg.sender);
18         _;
19     }
20 
21     modifier isRunning {
22         assert (!stopped);
23         _;
24     }
25 
26     modifier validAddress {
27         assert(0x0 != msg.sender);
28         _;
29     }
30 
31     function DPNPlusToken() {
32         owner = msg.sender;
33         totalSupply = valueFounder;
34         balanceOf[msg.sender] = valueFounder;
35         Transfer(0x0, msg.sender, valueFounder);
36     }
37 
38     function transfer(address _to, uint256 _value) isRunning validAddress returns (bool success) {
39         require(balanceOf[msg.sender] >= _value);
40         require(balanceOf[_to] + _value >= balanceOf[_to]);
41         balanceOf[msg.sender] -= _value;
42         balanceOf[_to] += _value;
43         Transfer(msg.sender, _to, _value);
44         return true;
45     }
46 
47     function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress returns (bool success) {
48         require(balanceOf[_from] >= _value);
49         require(balanceOf[_to] + _value >= balanceOf[_to]);
50         require(allowance[_from][msg.sender] >= _value);
51         balanceOf[_to] += _value;
52         balanceOf[_from] -= _value;
53         allowance[_from][msg.sender] -= _value;
54         Transfer(_from, _to, _value);
55         return true;
56     }
57 
58     function approve(address _spender, uint256 _value) isRunning validAddress returns (bool success) {
59         require(_value == 0 || allowance[msg.sender][_spender] == 0);
60         allowance[msg.sender][_spender] = _value;
61         Approval(msg.sender, _spender, _value);
62         return true;
63     }
64 
65     function stop() isOwner {
66         stopped = true;
67     }
68 
69     function start() isOwner {
70         stopped = false;
71     }
72 
73     function setName(string _name) isOwner {
74         name = _name;
75     }
76 
77     function setSymbol(string _symbol) isOwner{
78         symbol = _symbol;
79     }
80 
81     function burn(uint256 _value) {
82         require(balanceOf[msg.sender] >= _value);
83         require(totalSupply >= _value);
84         balanceOf[msg.sender] -= _value;
85         totalSupply -= _value;
86         Burn(msg.sender, _value);
87     }
88     
89     function transferOwnership(address newOwner) public isOwner {
90 		require(newOwner != address(0));
91 		address origin = owner;
92 		owner = newOwner;
93 		OwnershipTransferred(origin, newOwner);
94 	}
95 
96     event Transfer(address indexed _from, address indexed _to, uint256 _value);
97     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
98     event Burn(address indexed burner, uint256 value);
99     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
100 }