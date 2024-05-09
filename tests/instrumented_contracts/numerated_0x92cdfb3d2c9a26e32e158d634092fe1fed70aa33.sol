1 // ----------------------------------------------------------------------------
2 // 'Pactum' 'PACM' token contract
3 // ----------------------------------------------------------------------------
4 // Symbol: PACM
5 // Name:   Pactum
6 // Total supply: 100,000,000
7 // Decimals: 18
8 // ----------------------------------------------------------------------------
9 
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24   function transferOwnership(address newOwner) public onlyOwner {
25     require(newOwner != address(0));
26     emit OwnershipTransferred(owner, newOwner);
27     owner = newOwner;
28   }
29 
30 }
31 
32 contract PactumToken is Ownable{
33 
34     string public name = "Pactum";
35     string public symbol = "PACM";
36     uint256 public decimals = 18;
37 
38     mapping (address => uint256) public balanceOf;
39     mapping (address => mapping (address => uint256)) public allowance;
40 
41     uint256 public totalSupply = 0;
42     bool public stopped = false;
43 
44     uint256 constant valueFounder = 100000000 * 10**18;
45     address owner = 0x0;
46 
47     modifier isOwner {
48         assert(owner == msg.sender);
49         _;
50     }
51 
52     modifier isRunning {
53         assert (!stopped);
54         _;
55     }
56 
57     modifier validAddress {
58         assert(0x0 != msg.sender);
59         _;
60     }
61 
62     function PactumToken(address _addressFounder) public {
63         owner = msg.sender;
64         totalSupply = valueFounder;
65         balanceOf[_addressFounder] = valueFounder;
66         emit Transfer(0x0, _addressFounder, valueFounder);
67     }
68 
69     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
70         require(balanceOf[msg.sender] >= _value);
71         require(balanceOf[_to] + _value >= balanceOf[_to]);
72         balanceOf[msg.sender] -= _value;
73         balanceOf[_to] += _value;
74         emit Transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
79         require(balanceOf[_from] >= _value);
80         require(balanceOf[_to] + _value >= balanceOf[_to]);
81         require(allowance[_from][msg.sender] >= _value);
82         balanceOf[_to] += _value;
83         balanceOf[_from] -= _value;
84         allowance[_from][msg.sender] -= _value;
85         emit Transfer(_from, _to, _value);
86         return true;
87     }
88 
89     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
90         require(_value == 0 || allowance[msg.sender][_spender] == 0);
91         allowance[msg.sender][_spender] = _value;
92         emit Approval(msg.sender, _spender, _value);
93         return true;
94     }
95 
96     function stop() public isOwner {
97         stopped = true;
98     }
99 
100     function start() public isOwner {
101         stopped = false;
102     }
103 
104     function setName(string _name) public isOwner {
105         name = _name;
106     }
107 
108     function burn(uint256 _value) public {
109         require(balanceOf[msg.sender] >= _value);
110         balanceOf[msg.sender] -= _value;
111         balanceOf[0x0] += _value;
112         emit Transfer(msg.sender, 0x0, _value);
113     }
114 
115     event Transfer(address indexed _from, address indexed _to, uint256 _value);
116     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
117 }