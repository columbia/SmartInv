1 pragma solidity 0.4.24;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11 
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14         return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         // uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return a / b;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
34         c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 contract BasicToken is ERC20Basic {
41     using SafeMath for uint256;
42 
43     mapping(address => uint256) balances;
44 
45     uint256 totalSupply_;
46 
47     function totalSupply() public view returns (uint256) {
48         return totalSupply_;
49     }
50 
51     function transfer(address _to, uint256 _value) public returns (bool) {
52         require(_to != address(0));
53         require(_value <= balances[msg.sender]);
54 
55         balances[msg.sender] = balances[msg.sender].sub(_value);
56         balances[_to] = balances[_to].add(_value);
57         emit Transfer(msg.sender, _to, _value);
58         return true;
59     }
60 
61     function balanceOf(address _owner) public view returns (uint256) {
62         return balances[_owner];
63     }
64 
65 }
66 
67 contract ERC20 is ERC20Basic {
68     function allowance(address owner, address spender) public view returns (uint256);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract StandardToken is ERC20, BasicToken {
75 
76     mapping (address => mapping (address => uint256)) internal allowed;
77 
78 
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
80         require(_to != address(0));
81         require(_value <= balances[_from]);
82         require(_value <= allowed[_from][msg.sender]);
83 
84         balances[_from] = balances[_from].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
87         emit Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     function approve(address _spender, uint256 _value) public returns (bool) {
92         allowed[msg.sender][_spender] = _value;
93         emit Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) public view returns (uint256) {
98         return allowed[_owner][_spender];
99     }
100 
101     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
102         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
103         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104         return true;
105     }
106 
107     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
108         uint oldValue = allowed[msg.sender][_spender];
109         if (_subtractedValue > oldValue) {
110             allowed[msg.sender][_spender] = 0;
111         } else {
112             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
113         }
114         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115         return true;
116     }
117 }
118 
119 contract BurnableToken is BasicToken {
120 
121     event Burn(address indexed burner, uint256 value);
122 
123     function burn(uint256 _value) public {
124         _burn(msg.sender, _value);
125     }
126 
127     function _burn(address _who, uint256 _value) internal {
128         require(_value <= balances[_who]);
129 
130         balances[_who] = balances[_who].sub(_value);
131         totalSupply_ = totalSupply_.sub(_value);
132         emit Burn(_who, _value);
133         emit Transfer(_who, address(0), _value);
134     }
135 }
136 
137 contract AquaToken is BurnableToken, StandardToken {
138     string public name = "AquaToken";
139     string public symbol = "AQAU";
140     uint public decimals = 18;
141     uint public INITIAL_SUPPLY = 100000000 * 1 ether;
142 
143     constructor() public {
144         totalSupply_ = INITIAL_SUPPLY;
145         balances[msg.sender] = INITIAL_SUPPLY;
146     }
147 }