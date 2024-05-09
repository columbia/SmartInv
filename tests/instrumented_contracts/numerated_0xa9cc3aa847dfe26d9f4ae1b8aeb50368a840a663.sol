1 pragma solidity ^0.7.4;
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
28 
29 contract MinterRole {
30     bool private _initialized;
31     address private _minter;
32 
33     constructor () {
34         _initialized = false;
35         _minter = msg.sender;
36     }
37 
38     modifier onlyMinter() {
39         require(isMinter(msg.sender), "Mintable: msg.sender does not have the Minter role");
40         _;
41     }
42 
43     function isMinter(address _addr) public view returns (bool) {
44         return (_addr == _minter);
45     }
46 
47     function setMinter(address _addr) public onlyMinter {
48         //require(!_initialized);
49         _minter = _addr;
50         _initialized = true;
51     }
52 }
53 
54 
55 contract ERC20 is MinterRole {
56     using SafeMath for uint256;
57     
58     string public name;
59     string public symbol;
60     uint8 public decimals;
61     uint256 public totalSupply = 0;
62 
63     mapping (address => uint256) balances;
64     mapping (address => mapping (address => uint256)) internal allowed;
65 
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68     
69     constructor(string memory _name, string memory _symbol, uint8 _decimals) {
70             name = _name;
71             symbol = _symbol;
72             decimals = _decimals;
73     }
74 
75     function transfer(address _to, uint256 _value) external returns (bool) {
76         require(_to != address(0), "Cannot send to zero address");
77         require(balances[msg.sender] >= _value, "Insufficient fund");
78 
79         balances[msg.sender] = balances[msg.sender].sub(_value);
80         balances[_to] = balances[_to].add(_value);
81         
82         emit Transfer(msg.sender, _to, _value);
83 
84         return true;
85     }
86     
87     function balanceOf(address _owner) external view returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91     function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
92         require(_to != address(0));
93         require(_value <= balances[_from]);
94         require(_value <= allowed[_from][msg.sender]);
95 
96         balances[_from] = balances[_from].sub(_value);
97         balances[_to] = balances[_to].add(_value);
98         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99        
100         emit Transfer(_from, _to, _value);
101 
102         return true;
103     }
104 
105     function approve(address _spender, uint256 _value) public returns (bool) {
106         allowed[msg.sender][_spender] = _value;
107         emit Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 
111     function allowance(address _owner, address _spender) public view returns (uint256) {
112         return allowed[_owner][_spender];
113     }
114     
115     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
116         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
117         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118         return true;
119     }
120     
121     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
122         uint oldValue = allowed[msg.sender][_spender];
123         if (_subtractedValue > oldValue) {
124             allowed[msg.sender][_spender] = 0;
125         } else {
126             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
127         }
128         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
129         return true;
130     }
131     
132     function mint(address payable _to, uint256 _value) external onlyMinter returns (bool) {
133         balances[_to] = balances[_to].add(_value);
134         totalSupply = totalSupply.add(_value);
135         emit Transfer(address(0), _to, _value);
136         
137         return true;
138     }
139 
140     function burn(uint256 _value) external onlyMinter returns (bool) {
141         require(balances[msg.sender] >= _value, "Insufficient fund");
142         balances[msg.sender] = balances[msg.sender].sub(_value);
143         totalSupply = totalSupply.sub(_value);
144         emit Transfer(msg.sender, address(0), _value);
145         
146         return true;
147     }
148 }