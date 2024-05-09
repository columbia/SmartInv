1 library SafeMath {
2   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) internal pure returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20Basic {
28   function totalSupply() public view returns (uint256);
29   function balanceOf(address who) public view returns (uint256);
30   function transfer(address to, uint256 value) public returns (bool);
31   event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract ERC20 is ERC20Basic {
35   function allowance(address owner, address spender) public view returns (uint256);
36   function transferFrom(address from, address to, uint256 value) public returns (bool);
37   function approve(address spender, uint256 value) public returns (bool);
38   event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract BlocVehicle is ERC20 {
42 
43       using SafeMath for uint;
44       string public constant name = "BlocVehicle";
45       string public constant symbol = "VCL";
46       uint256 public constant decimals = 18;
47       uint256 _totalSupply = 1000000000 * (10 ** decimals);
48 
49       mapping(address => uint256) balances;
50       mapping(address => mapping (address => uint256)) allowed;
51       mapping(address => bool) public frozenAccount;
52 
53       event FrozenFunds(address target, bool frozen);
54 
55 
56       address public owner;
57 
58       modifier onlyOwner() {
59         require(msg.sender == owner);
60         _;
61       }
62 
63       function changeOwner(address _newOwner) onlyOwner public {
64         require(_newOwner != address(0));
65         owner = _newOwner;
66       }
67 
68       function burnTokens(address burnedAddress, uint256 amount) onlyOwner public {
69         require(burnedAddress != address(0));
70         require(amount > 0);
71         require(amount <= balances[burnedAddress]);
72         balances[burnedAddress] = balances[burnedAddress].sub(amount);
73         _totalSupply = _totalSupply.sub(amount);
74       }
75 
76       function freezeAccount(address target, bool freeze) onlyOwner public {
77         frozenAccount[target] = freeze;
78         emit FrozenFunds(target, freeze);
79       }
80 
81       function isFrozenAccount(address _addr) public constant returns (bool) {
82         return frozenAccount[_addr];
83       }
84 
85       constructor() public {
86         owner = msg.sender;
87         balances[owner] = _totalSupply;
88       }
89 
90       function _transfer(address _from, address _to, uint256 _value) internal {
91         require(_to != address(0));
92         require(balances[_from] >= _value);
93         require(balances[_to].add(_value)  >= balances[_to]);
94         require(!frozenAccount[_from]);
95         require(!frozenAccount[_to]);
96 
97         uint previousBalances = balances[_from].add(balances[_to]);
98         balances[_from] = balances[_from].sub(_value);
99         balances[_to] = balances[_to].add(_value);
100 
101         emit Transfer(_from, _to, _value);
102         assert(balances[_from].add(balances[_to]) == previousBalances);
103       }
104 
105       function transfer(address _to, uint256 _value) public returns (bool success) {
106         _transfer(msg.sender, _to, _value);
107         return true;
108       }
109 
110       function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
111         require(_value <= allowed[_from][msg.sender]);
112         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113         _transfer(_from, _to, _value);
114         return true;
115       }
116 
117       function totalSupply() public constant returns (uint256 supply) {
118         supply = _totalSupply;
119       }
120 
121       function balanceOf(address _owner) public constant returns (uint256 balance) {
122         return balances[_owner];
123       }
124 
125       function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
126         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
127         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128         return true;
129       }
130 
131       function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
132         uint oldValue = allowed[msg.sender][_spender];
133         if (_subtractedValue > oldValue) {
134           allowed[msg.sender][_spender] = 0;
135         } else {
136           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
137         }
138         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139         return true;
140       }
141 
142       function approve(address _spender, uint256 _value) public returns (bool success) {
143           allowed[msg.sender][_spender] = _value;
144           emit Approval(msg.sender, _spender, _value);
145           return true;
146       }
147 
148       function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
149         return allowed[_owner][_spender];
150       }
151 }