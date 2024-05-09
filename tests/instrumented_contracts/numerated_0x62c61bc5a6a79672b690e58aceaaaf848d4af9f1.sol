1 pragma solidity ^0.4.22;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract IWCEToken {
28 
29     using SafeMath for uint256;
30     address owner = msg.sender;
31 
32     mapping(address => uint256) balances;
33     mapping(address => mapping(address => uint256)) allowed;
34     mapping(address => bool) public airDroppedList;
35 
36     string public constant name = "IWC ecosystem";
37     string public constant symbol = "IWCE";
38     uint public constant decimals = 18;
39 
40     uint256 public totalSupply = 500000000 ether;
41 
42     uint256 public totalAirDropNum = 5000004 ether;
43 
44     uint256 public airDropNum = 18 ether;
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed from, address indexed to, uint256 value);
48 
49     event AirDrop(address indexed to, uint256 amount);
50 
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function IWCEToken() public {
57         owner = msg.sender;
58         balances[owner] = totalSupply.sub(totalAirDropNum);
59     }
60 
61     function transferOwnership(address newOwner) onlyOwner public {
62         if (newOwner != address(0)) {
63             owner = newOwner;
64         }
65     }
66 
67     function airDrop(address _to, uint256 _amount) private returns (bool) {
68         totalAirDropNum = totalAirDropNum.sub(_amount);
69         balances[_to] = balances[_to].add(_amount);
70 
71         emit AirDrop(_to, _amount);
72         emit Transfer(address(0), _to, _amount);
73 
74         return true;
75     }
76 
77     function() external payable {
78         getTokens();
79     }
80 
81     function getTokens() internal {
82         if (totalAirDropNum > 0 && airDroppedList[msg.sender] != true) {
83             airDrop(msg.sender, airDropNum);
84             airDroppedList[msg.sender] = true;
85         }
86     }
87 
88     function balanceOf(address _owner) constant public returns (uint256) {
89         return balances[_owner];
90     }
91 
92     function transfer(address _to, uint256 _amount) public returns (bool success) {
93         require(_to != address(0));
94         require(_amount <= balances[msg.sender]);
95 
96         balances[msg.sender] = balances[msg.sender].sub(_amount);
97         balances[_to] = balances[_to].add(_amount);
98         emit Transfer(msg.sender, _to, _amount);
99         return true;
100     }
101 
102     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
103         require(_to != address(0));
104         require(_amount <= balances[_from]);
105         require(_amount <= allowed[_from][msg.sender]);
106 
107         balances[_from] = balances[_from].sub(_amount);
108         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
109         balances[_to] = balances[_to].add(_amount);
110         emit Transfer(_from, _to, _amount);
111         return true;
112     }
113 
114     function approve(address _spender, uint256 _value) public returns (bool success) {
115         if (_value != 0 && allowed[msg.sender][_spender] != 0) {return false;}
116         allowed[msg.sender][_spender] = _value;
117         emit Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     function allowance(address _owner, address _spender) constant public returns (uint256) {
122         return allowed[_owner][_spender];
123     }
124 }