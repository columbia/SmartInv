1 pragma solidity ^0.6.0;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) return 0;
6         uint256 c = a * b;
7         assert(c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 contract MinterRole {
29     bool private _initialized;
30     address private _minter;
31 
32     constructor () internal {
33         _initialized = false;
34         _minter = msg.sender;
35     }
36 
37     modifier onlyMinter() {
38         require(isMinter(msg.sender), "Mintable: msg.sender does not have the Minter role");
39         _;
40     }
41 
42     function isMinter(address _addr) public view returns (bool) {
43         return (_addr == _minter);
44     }
45 
46     function setMinter(address _addr) public onlyMinter {
47         //require(!_initialized);
48         _minter = _addr;
49         _initialized = true;
50     }
51 }
52 
53 contract ERC20 is MinterRole {
54     using SafeMath for uint256;
55     
56     string public constant name = "Nodoka ETH";
57     string public constant symbol = "NETH";
58     uint256 public constant decimals = 18;
59     uint256 public totalSupply = 0;
60     
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) internal allowed;
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66     
67     constructor() public {
68         // Do nothing
69     }
70 
71     function transfer(address _to, uint256 _value) external returns (bool) {
72         require(_to != address(0), "Cannot send to zero address");
73         require(balances[msg.sender] >= _value, "Insufficient fund");
74 
75         balances[msg.sender] = balances[msg.sender].sub(_value);
76         balances[_to] = balances[_to].add(_value);
77         
78         emit Transfer(msg.sender, _to, _value);
79         return true;
80     }
81     
82     function balanceOf(address _owner) external view returns (uint256 balance) {
83         return balances[_owner];
84     }
85 
86     function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
87         require(_to != address(0));
88         require(_value <= balances[_from]);
89         require(_value <= allowed[_from][msg.sender]);
90 
91         balances[_from] = balances[_from].sub(_value);
92         balances[_to] = balances[_to].add(_value);
93         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
94         
95         emit Transfer(_from, _to, _value);
96         return true;
97     }
98 
99     function approve(address _spender, uint256 _value) public returns (bool) {
100         allowed[msg.sender][_spender] = _value;
101         emit Approval(msg.sender, _spender, _value);
102         return true;
103     }
104 
105     function allowance(address _owner, address _spender) public view returns (uint256) {
106         return allowed[_owner][_spender];
107     }
108     
109     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
110         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
111         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112         return true;
113     }
114     
115     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
116         uint oldValue = allowed[msg.sender][_spender];
117         if (_subtractedValue > oldValue) {
118             allowed[msg.sender][_spender] = 0;
119         } else {
120             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
121         }
122         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
123         return true;
124     }
125     
126     function mint(address payable _to, uint256 _value) external onlyMinter returns (bool) {
127         balances[_to] = balances[_to].add(_value);
128         totalSupply = totalSupply.add(_value);
129         emit Transfer(address(0), _to, _value);
130     }
131 
132     function burn(uint256 _value) external returns (bool) {
133         require(balances[msg.sender] >= _value, "Insufficient fund");
134         balances[msg.sender] = balances[msg.sender].sub(_value);
135         totalSupply = totalSupply.sub(_value);
136         emit Transfer(msg.sender, address(0), _value);
137     }
138 }