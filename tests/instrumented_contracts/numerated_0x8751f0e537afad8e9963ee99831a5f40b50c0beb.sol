1 pragma solidity ^0.4.21;
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
22 library SafeMath {
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27         uint256 c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 contract TotalMasternode is ERC20, ERC223 {
52     using SafeMath for uint;
53 
54     string internal _name;
55     string internal _symbol;
56     uint8 internal _decimals;
57     uint256 internal _totalSupply;
58 
59     mapping (address => uint256) internal balances;
60     mapping (address => mapping (address => uint256)) internal allowed;
61 
62     function TotalMasternode() public {
63         _symbol = "TOMA";
64         _name = "TokenMasternode";
65         _decimals = 18;
66         _totalSupply = 700000000000000000000000000;
67         balances[msg.sender] = 700000000000000000000000000;
68     }
69 
70     function name()
71     public
72     view
73     returns (string) {
74         return _name;
75     }
76 
77     function symbol()
78     public
79     view
80     returns (string) {
81         return _symbol;
82     }
83 
84     function decimals()
85     public
86     view
87     returns (uint8) {
88         return _decimals;
89     }
90 
91     function totalSupply()
92     public
93     view
94     returns (uint256) {
95         return _totalSupply;
96     }
97 
98     function transfer(address _to, uint256 _value) public returns (bool) {
99         require(_to != address(0));
100         require(_value <= balances[msg.sender]);
101         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
102         balances[_to] = SafeMath.add(balances[_to], _value);
103         Transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107     function transfer(address _to, uint _value, bytes _data) public {
108         require(_value > 0 );
109         if(isContract(_to)) {
110             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
111             receiver.tokenFallback(msg.sender, _value, _data);
112         }
113         balances[msg.sender] = balances[msg.sender].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         Transfer(msg.sender, _to, _value, _data);
116     }
117 
118     function isContract(address _addr) private returns (bool is_contract) {
119         uint length;
120         assembly {
121         //retrieve the size of the code on target address, this needs assembly
122             length := extcodesize(_addr)
123         }
124         return (length>0);
125     }
126 
127     function balanceOf(address _owner) public view returns (uint256 balance) {
128         return balances[_owner];
129     }
130 
131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
132         require(_to != address(0));
133         require(_value <= balances[_from]);
134         require(_value <= allowed[_from][msg.sender]);
135 
136         balances[_from] = SafeMath.sub(balances[_from], _value);
137         balances[_to] = SafeMath.add(balances[_to], _value);
138         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
139         Transfer(_from, _to, _value);
140         return true;
141     }
142 
143     function approve(address _spender, uint256 _value) public returns (bool) {
144         allowed[msg.sender][_spender] = _value;
145         Approval(msg.sender, _spender, _value);
146         return true;
147     }
148 
149     function allowance(address _owner, address _spender) public view returns (uint256) {
150         return allowed[_owner][_spender];
151     }
152 
153     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
154         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
155         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156         return true;
157     }
158 
159     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
160         uint oldValue = allowed[msg.sender][_spender];
161         if (_subtractedValue > oldValue) {
162             allowed[msg.sender][_spender] = 0;
163         } else {
164             allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
165         }
166         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167         return true;
168     }
169 }