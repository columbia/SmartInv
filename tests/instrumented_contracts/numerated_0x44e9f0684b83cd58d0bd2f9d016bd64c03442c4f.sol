1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
5         if (_a == 0) {
6             return 0;
7         }
8         uint256 c = _a * _b;
9         require(c / _a == _b);
10         return c;
11     }
12 
13     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
14         require(_b > 0);
15         uint256 c = _a / _b;
16         return c;
17     }
18 
19     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
20         require(_b <= _a);
21         uint256 c = _a - _b;
22 
23         return c;
24     }
25 
26     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
27         uint256 c = _a + _b;
28         require(c >= _a);
29 
30         return c;
31     }
32 
33     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b != 0);
35         return a % b;
36     }
37 }
38 
39 contract IWCToken {
40     using SafeMath for uint256;
41 
42     string public name = "XXXXXX";
43     string public symbol = "XXX";
44     uint8 public decimals = 18;
45     uint256 public totalSupply = 500000000 ether; // 发行数量
46     uint256 public currentTotalSupply = 0;
47     uint256 startBalance = 18 ether; // 空投数量
48 
49     mapping(address => uint256) balances;
50     mapping(address => bool)touched;
51     mapping(address => mapping(address => uint256)) internal allowed;
52 
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 
56     function IWCToken() public {
57         balances[msg.sender] = totalSupply;
58     }
59 
60     function transfer(address _to, uint256 _value) public returns (bool) {
61         require(_to != address(0));
62 
63         if (!touched[msg.sender] && currentTotalSupply < totalSupply) {
64             balances[msg.sender] = balances[msg.sender].add(startBalance);
65             touched[msg.sender] = true;
66             currentTotalSupply = currentTotalSupply.add(startBalance);
67         }
68 
69         require(_value <= balances[msg.sender]);
70 
71         balances[msg.sender] = balances[msg.sender].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73 
74         Transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79         require(_to != address(0));
80 
81         require(_value <= allowed[_from][msg.sender]);
82 
83         if (!touched[_from] && currentTotalSupply < totalSupply) {
84             touched[_from] = true;
85             balances[_from] = balances[_from].add(startBalance);
86             currentTotalSupply = currentTotalSupply.add(startBalance);
87         }
88 
89         require(_value <= balances[_from]);
90 
91         balances[_from] = balances[_from].sub(_value);
92         balances[_to] = balances[_to].add(_value);
93         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
94         Transfer(_from, _to, _value);
95         return true;
96     }
97 
98     function approve(address _spender, uint256 _value) public returns (bool) {
99         allowed[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 
104     function allowance(address _owner, address _spender) public view returns (uint256) {
105         return allowed[_owner][_spender];
106     }
107 
108     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
109         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
110         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
111         return true;
112     }
113 
114     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
115         uint oldValue = allowed[msg.sender][_spender];
116         if (_subtractedValue > oldValue) {
117             allowed[msg.sender][_spender] = 0;
118         } else {
119             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
120         }
121         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122         return true;
123     }
124 
125     function getBalance(address _a) internal constant returns (uint256)
126     {
127         if (currentTotalSupply < totalSupply) {
128             if (touched[_a])
129                 return balances[_a];
130             else
131                 return balances[_a].add(startBalance);
132         } else {
133             return balances[_a];
134         }
135     }
136 
137     function balanceOf(address _owner) public view returns (uint256 balance) {
138         return getBalance(_owner);
139     }
140 }