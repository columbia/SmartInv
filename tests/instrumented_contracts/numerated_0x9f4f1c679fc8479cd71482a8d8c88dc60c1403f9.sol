1 pragma solidity >=0.5.0 < 0.6.0;
2 
3 contract owned {
4     address public owner;
5     constructor() public {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     function transferOwnership(address newOwner) onlyOwner public {
14         owner = newOwner;
15     }
16 }
17 
18 library SafeMath {
19     function mul(uint256 a, uint256 b) pure internal returns (uint256) {
20         uint256 c = a * b;
21         assert(a == 0 || c / a == b);
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) pure internal returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) pure internal returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     function add(uint256 a, uint256 b) pure internal returns (uint256) {
38         uint256 c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 }
43 
44 contract ERC20Basic {
45     uint256 public totalSupply;
46     function balanceOf(address who) public returns (uint256);
47     function transfer(address to, uint256 value) public returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 contract BasicToken is ERC20Basic {
52     using SafeMath for uint256;
53     mapping(address => uint256) balances;
54 
55     function transfer(address _to, uint256 _value) public returns (bool) {
56         require(_to != address(0));
57         require(_value <= balances[msg.sender]);
58         // SafeMath.sub will throw if there is not enough balance.
59         balances[msg.sender] = balances[msg.sender].sub(_value);
60         balances[_to] = balances[_to].add(_value);
61         emit Transfer(msg.sender, _to, _value);
62         return true;
63     }
64 
65     function balanceOf(address _owner) public returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69 }
70 
71 
72 contract ERC20 is ERC20Basic {
73     function allowance(address owner, address spender) public returns (uint256);
74     function transferFrom(address from, address to, uint256 value) public returns (bool);
75     function approve(address spender, uint256 value) public returns (bool);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77     function freezeAccount(address target, bool freeze) public returns (bool);
78     event FrozenFunds(address target, bool frozen);
79     function burn(uint256 _value) public returns (bool);
80     event Burn(address indexed from, uint256 value);
81 }
82 
83 
84 contract StandardToken is ERC20, BasicToken, owned {
85     mapping(address => mapping(address => uint256)) internal allowed;
86     mapping(address => bool) public frozenAccount;
87 
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
89         require(_to != address(0));
90         require(_value <= balances[_from]);
91         require(_value <= allowed[_from][msg.sender]);
92         require(!frozenAccount[_from]);
93         require(!frozenAccount[_to]);
94         balances[_from] = balances[_from].sub(_value);
95         balances[_to] = balances[_to].add(_value);
96         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97         emit Transfer(_from, _to, _value);
98         return true;
99     }
100 
101     function approve(address _spender, uint256 _value) public returns (bool) {
102         allowed[msg.sender][_spender] = _value;
103         emit Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) public returns (uint256 remaining) {
108         return allowed[_owner][_spender];
109     }
110 
111 
112     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
113         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
114         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115         return true;
116     }
117 
118     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
119         uint oldValue = allowed[msg.sender][_spender];
120         if (_subtractedValue > oldValue) {
121             allowed[msg.sender][_spender] = 0;
122         } else {
123             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
124         }
125         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126         return true;
127     }
128 
129     function freezeAccount(address target, bool freeze) onlyOwner public returns (bool success)  {
130         frozenAccount[target] = freeze;
131         emit FrozenFunds(target, freeze);
132         return true;
133     }
134 
135     function burn(uint256 _value) public returns (bool success) {
136         require(balances[msg.sender] >= _value);
137         balances[msg.sender] = balances[msg.sender].sub(_value);
138         totalSupply = totalSupply.sub(_value);
139         emit Burn(msg.sender, _value);
140         return true;
141     }
142 
143     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
144         require(balances[_from] >= _value);
145         require(_value <= allowed[_from][msg.sender]);
146         balances[_from] = balances[_from].sub(_value);
147         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148         totalSupply = totalSupply.sub(_value);
149         emit Burn(_from, _value);
150         return true;
151     }
152 
153 }
154 
155 contract DAAToken is StandardToken {
156 
157     string public constant name = "DoubleAce Token";
158     string public constant symbol = "DAA";
159     uint8 public constant decimals = 8;
160     uint256 public constant INITIAL_SUPPLY = 87000000000 * (10 ** uint256(decimals));
161 
162     constructor() public {
163         totalSupply = INITIAL_SUPPLY;
164         balances[msg.sender] = INITIAL_SUPPLY;
165     }
166 
167 }