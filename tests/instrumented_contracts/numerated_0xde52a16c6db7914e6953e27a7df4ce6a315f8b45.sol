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
30     mapping(address => bool) private _minters;
31 
32     constructor () internal {
33         _minters[msg.sender] = true;
34     }
35 
36     modifier onlyMinter() {
37         require(isMinter(msg.sender), "Mintable: msg.sender does not have the Minter role");
38         _;
39     }
40 
41     function isMinter(address _addr) public view returns (bool) {
42         return _minters[_addr];
43     }
44 
45     function setMinter(address _addr) public onlyMinter {
46         _minters[_addr] = true;
47     }
48     
49     function removeMinter(address _addr) public onlyMinter {
50         _minters[_addr] = false;     
51     }
52 }
53 
54 contract OuchiToken is MinterRole {
55     using SafeMath for uint256;
56     
57     string public constant name = "OUCHI Token";
58     string public constant symbol = "OUCHI";
59     uint256 public constant decimals = 18;
60     uint256 public totalSupply = 0;
61     
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) internal allowed;
64 
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67     
68     constructor() public {
69         // Do nothing
70     }
71 
72     function transfer(address _to, uint256 _value) external returns (bool) {
73         require(_to != address(0), "Cannot send to zero address");
74         require(balances[msg.sender] >= _value, "Insufficient fund");
75 
76         balances[msg.sender] = balances[msg.sender].sub(_value);
77         balances[_to] = balances[_to].add(_value);
78         
79         emit Transfer(msg.sender, _to, _value);
80         return true;
81     }
82     
83     function balanceOf(address _owner) external view returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
88         require(_to != address(0));
89         require(_value <= balances[_from]);
90         require(_value <= allowed[_from][msg.sender]);
91 
92         balances[_from] = balances[_from].sub(_value);
93         balances[_to] = balances[_to].add(_value);
94         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
95         
96         emit Transfer(_from, _to, _value);
97         return true;
98     }
99 
100     function approve(address _spender, uint256 _value) public returns (bool) {
101         allowed[msg.sender][_spender] = _value;
102         emit Approval(msg.sender, _spender, _value);
103         return true;
104     }
105 
106     function allowance(address _owner, address _spender) public view returns (uint256) {
107         return allowed[_owner][_spender];
108     }
109     
110     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
111         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
112         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113         return true;
114     }
115     
116     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
117         uint oldValue = allowed[msg.sender][_spender];
118         if (_subtractedValue > oldValue) {
119             allowed[msg.sender][_spender] = 0;
120         } else {
121             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
122         }
123         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124         return true;
125     }
126     
127     function mint(address payable _to, uint256 _value) external onlyMinter returns (bool) {
128         balances[_to] = balances[_to].add(_value);
129         totalSupply = totalSupply.add(_value);
130         emit Transfer(address(0), _to, _value);
131     }
132 
133     function burn(uint256 _value) external returns (bool) {
134         require(balances[msg.sender] >= _value, "Insufficient fund");
135         balances[msg.sender] = balances[msg.sender].sub(_value);
136         totalSupply = totalSupply.sub(_value);
137         emit Transfer(msg.sender, address(0), _value);
138     }
139 }