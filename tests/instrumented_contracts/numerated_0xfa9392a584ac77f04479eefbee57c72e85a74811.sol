1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6       if (a == 0) {
7         return 0;
8       }
9       uint256 c = a * b;
10       assert(c / a == b);
11       return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15       // assert(b > 0); // Solidity automatically throws when dividing by 0
16       uint256 c = a / b;
17       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18       return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22       assert(b <= a);
23       return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27       uint256 c = a + b;
28       assert(c >= a);
29       return c;
30     }
31 }
32 
33 contract FRED_TOKEN {
34     using SafeMath for uint256;
35 
36     string public constant name = "Fred Token";
37     string public symbol = "FRED";
38     uint256 public constant decimals = 18;
39 
40     uint256 public hardCap = 1000000 * (10 ** decimals);
41     uint256 public totalSupply;
42     address public owner; 
43     uint256 public valInt;
44 
45     mapping (address => uint256) balances;
46     mapping (address => mapping (address => uint256)) allowed; // third party authorisations for token transfering
47 
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 
51     function FRED_TOKEN() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function mint(address _user, uint256 _tokensAmount) public onlyOwner returns(bool) {
61         uint256 newSupply = totalSupply.add(_tokensAmount);
62         require(
63             _user != address(0) &&
64             _tokensAmount > 0 &&
65              newSupply < hardCap
66         );
67         balances[_user] = balances[_user].add(_tokensAmount);
68         totalSupply = newSupply;
69         Transfer(0x0, _user, _tokensAmount);
70         return true;
71     }
72 
73     function transfer(address _to, uint256 _value) public returns (bool) {
74         require(
75             _to != address(0) &&
76             balances[msg.sender] >= _value &&
77             balances[_to] + _value > balances[_to]
78         );
79         balances[msg.sender] = balances[msg.sender].sub(_value);
80         balances[_to] = balances[_to].add(_value);
81         Transfer(msg.sender, _to, _value);
82         return true;
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
86         require (
87           _from != address(0) &&
88           _to != address(0) &&
89           balances[_from] >= _value &&
90           allowed[_from][msg.sender] >= _value &&
91           balances[_to] + _value > balances[_to]
92         );
93         balances[_from] = balances[_from].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
96         Transfer(_from, _to, _value);
97         return true;
98     }
99 
100     function approve(address _spender, uint256 _value) public returns (bool) {
101         require(_spender != address(0));
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107    function setValInt(uint256 _valInt) external onlyOwner {
108       valInt = _valInt;
109     }
110 
111     function balanceOf(address _owner) external view returns (uint256) {
112         return balances[_owner];
113     }
114 
115     function allowance(address _owner, address _spender) external view returns (uint256) {
116         return allowed[_owner][_spender];
117     }
118 }