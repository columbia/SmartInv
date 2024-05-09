1 pragma solidity ^0.4.23;
2 
3 interface ERC20 {
4     function balanceOf(address who) public view returns (uint256);
5     function transfer(address to, uint256 value) public returns (bool);
6     function allowance(address owner, address spender) public view returns (uint256);
7     function transferFrom(address from, address to, uint256 value) public returns (bool);
8     function approve(address spender, uint256 value) public returns (bool);
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     event Approval(address indexed owner, address indexed spender, uint256 value);
11 }
12 
13 interface ERC223 {
14     function transfer(address to, uint value, bytes data) public;
15     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
16 }
17 
18 contract ERC223ReceivingContract { 
19     function tokenFallback(address _from, uint _value, bytes _data) public;
20 }
21 
22 /**
23 * @title SafeMath
24 * @dev Math operations with safety checks that throw on error
25 */
26 library SafeMath {
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (a == 0) {
29             return 0;
30         }
31         uint256 c = a * b;
32         assert(c / a == b);
33         return c;
34     }
35     
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         // assert(b > 0); // Solidity automatically throws when dividing by 0
38         uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40         return c;
41     }
42     
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         assert(b <= a);
45         return a - b;
46     }
47     
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 contract SovToken is ERC20, ERC223 {
56     using SafeMath for uint;
57     
58     string internal _name;
59     string internal _symbol;
60     uint8 internal _decimals;
61     uint256 internal _totalSupply;
62     
63     mapping (address => uint256) internal balances;
64     mapping (address => mapping (address => uint256)) internal allowed;
65     
66     constructor(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
67         _symbol = symbol;
68         _name = name;
69         _decimals = decimals;
70         _totalSupply = totalSupply;
71         balances[msg.sender] = totalSupply;
72     }
73     
74     function name() public view returns (string) {
75         return _name;
76     }
77     
78     function symbol() public view returns (string) {
79         return _symbol;
80     }
81     
82     function decimals() public view returns (uint8) {
83         return _decimals;
84     }
85     
86     function totalSupply() public view returns (uint256) {
87         return _totalSupply;
88     }
89     
90     function transfer(address _to, uint256 _value) public returns (bool) {
91         require(_to != address(0));
92         require(_value <= balances[msg.sender]);
93         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
94         balances[_to] = SafeMath.add(balances[_to], _value);
95         emit Transfer(msg.sender, _to, _value);
96         return true;
97     }
98     
99     function balanceOf(address _owner) public view returns (uint256 balance) {
100         return balances[_owner];
101     }
102     
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
104         require(_to != address(0));
105         require(_value <= balances[_from]);
106         require(_value <= allowed[_from][msg.sender]);
107         
108         balances[_from] = SafeMath.sub(balances[_from], _value);
109         balances[_to] = SafeMath.add(balances[_to], _value);
110         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
111         emit Transfer(_from, _to, _value);
112         return true;
113     }
114     
115     function approve(address _spender, uint256 _value) public returns (bool) {
116         allowed[msg.sender][_spender] = _value;
117         emit Approval(msg.sender, _spender, _value);
118         return true;
119     }
120     
121     function allowance(address _owner, address _spender) public view returns (uint256) {
122         return allowed[_owner][_spender];
123     }
124     
125     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
126         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
127         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128         return true;
129     }
130     
131     
132     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
133         uint oldValue = allowed[msg.sender][_spender];
134         if (_subtractedValue > oldValue) {
135             allowed[msg.sender][_spender] = 0;
136         } else {
137             allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
138         }
139         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140         return true;
141     }
142     
143     function transfer(address _to, uint _value, bytes _data) public {
144         require(_value > 0 );
145         if(isContract(_to)) {
146             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
147             receiver.tokenFallback(msg.sender, _value, _data);
148         }
149         balances[msg.sender] = balances[msg.sender].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         emit Transfer(msg.sender, _to, _value, _data);
152     }
153     
154     function isContract(address _addr) private returns (bool is_contract) {
155         uint length;
156         assembly {
157             //retrieve the size of the code on target address, this needs assembly
158             length := extcodesize(_addr)
159         }
160         return (length>0);
161     }
162 
163 
164 }