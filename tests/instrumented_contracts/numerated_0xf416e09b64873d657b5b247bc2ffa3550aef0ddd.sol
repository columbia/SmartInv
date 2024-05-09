1 pragma solidity ^0.5.1;
2 
3 interface ERC20 {
4     function balanceOf(address _owner) external view returns (uint256);
5     function allowance(address _owner, address _spender) external view returns (uint256);
6     function transfer(address _to, uint256 _value) external returns (bool);
7     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
8     function approve(address _spender, uint256 _value) external returns (bool);
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     event Approval(address indexed owner, address indexed spender, uint256 value);
11 }
12 
13 library SafeMath {
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a / b;
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 contract SpiderX is ERC20 {
41     using SafeMath for uint256;
42     address private deployer;
43     string public name = "SpiderX";
44     string public symbol = "SPIDX";
45     uint8 public constant decimals = 18;
46     uint256 public constant decimalFactor = 10 ** uint256(decimals);
47     uint256 public constant totalSupply = 20000 * decimalFactor;
48     mapping (address => uint256) balances;
49     mapping (address => mapping (address => uint256)) internal allowed;
50 
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 
54     constructor() public {
55         balances[msg.sender] = totalSupply;
56         deployer = msg.sender;
57         emit Transfer(address(0), msg.sender, totalSupply);
58     }
59 
60     function balanceOf(address _owner) public view returns (uint256 balance) {
61         return balances[_owner];
62     }
63 
64     function allowance(address _owner, address _spender) public view returns (uint256) {
65         return allowed[_owner][_spender];
66     }
67 
68     function transfer(address _to, uint256 _value) public returns (bool) {
69         require(_to != address(0));
70         require(_value <= balances[msg.sender]);
71         require(block.timestamp >= 1545102693);
72 
73         balances[msg.sender] = balances[msg.sender].sub(_value);
74         balances[_to] = balances[_to].add(_value);
75         emit Transfer(msg.sender, _to, _value);
76         return true;
77     }
78 
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
80         require(_to != address(0));
81         require(_value <= balances[_from]);
82         require(_value <= allowed[_from][msg.sender]);
83         require(block.timestamp >= 1545102693);
84 
85         balances[_from] = balances[_from].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88         emit Transfer(_from, _to, _value);
89         return true;
90     }
91 
92     function approve(address _spender, uint256 _value) public returns (bool) {
93         allowed[msg.sender][_spender] = _value;
94         emit Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
99         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
100         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
101         return true;
102     }
103 
104     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
105         uint oldValue = allowed[msg.sender][_spender];
106         if (_subtractedValue > oldValue) {
107             allowed[msg.sender][_spender] = 0;
108         } else {
109             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
110         }
111         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112         return true;
113     }
114 }