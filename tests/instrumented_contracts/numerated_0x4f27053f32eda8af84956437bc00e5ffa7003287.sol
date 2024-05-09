1 pragma solidity ^0.4.21;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 contract ERC20 is ERC20Basic {
10     function allowance(address owner, address spender) public view returns (uint256);
11     function transferFrom(address from, address to, uint256 value) public returns (bool);
12     function approve(address spender, uint256 value) public returns (bool);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 library SafeMath {
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22         uint256 c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 contract BasicToken is ERC20Basic {
46     using SafeMath for uint256;
47 
48     mapping (address => uint256) public balances;
49 
50     uint256 public totalSupply_;
51 
52     function totalSupply() public view returns (uint256) {
53         return totalSupply_;
54     }
55 
56     function transfer(address _to, uint256 _value) public returns (bool) {
57         require(_to != address(0));
58         require(_value <= balances[msg.sender]);
59 
60         // SafeMath.sub will throw if there is not enough balance.
61         balances[msg.sender] = balances[msg.sender].sub(_value);
62         balances[_to] = balances[_to].add(_value);
63         emit Transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     function balanceOf(address _owner) public view returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71 }
72 contract StandardToken is ERC20, BasicToken {
73 
74     mapping (address => mapping (address => uint256)) internal allowed;
75     event Burn(address indexed burner, uint256 value);
76 
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
78         require(_to != address(0));
79         require(_value <= balances[_from]);
80         require(_value <= allowed[_from][msg.sender]);
81 
82         balances[_from] = balances[_from].sub(_value);
83         balances[_to] = balances[_to].add(_value);
84         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
85         emit Transfer(_from, _to, _value);
86         return true;
87     }
88 
89     function approve(address _spender, uint256 _value) public returns (bool) {
90         allowed[msg.sender][_spender] = _value;
91         emit Approval(msg.sender, _spender, _value);
92         return true;
93     }
94 
95     function allowance(address _owner, address _spender) public view returns (uint256) {
96         return allowed[_owner][_spender];
97     }
98 
99     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
100         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
101         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102         return true;
103     }
104 
105     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
106         uint oldValue = allowed[msg.sender][_spender];
107         if (_subtractedValue > oldValue) {
108             allowed[msg.sender][_spender] = 0;
109         } else {
110             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
111         }
112        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113         return true;
114     }
115 
116     function burn(uint256 _value) public {
117         require(_value <= balances[msg.sender]);
118         address burner = msg.sender;
119         balances[burner] = balances[burner].sub(_value);
120         totalSupply_ = totalSupply_.sub(_value);
121         emit Burn(burner, _value);
122         emit Transfer(burner, address(0), _value);
123    }
124 }
125 contract ThriveToken is StandardToken {
126 
127     string public constant name = "ThriveToken";
128     string public constant symbol = "THRT";
129     uint8 public constant decimals = 18;
130 
131     uint256 public constant INITIAL_SUPPLY = 280000000 * (10 ** uint256(decimals));
132     uint256 public constant RAISED_AMOUNT = 25000000;
133 
134     function ThriveToken() public {
135         totalSupply_ = INITIAL_SUPPLY;
136         balances[msg.sender] = INITIAL_SUPPLY;
137         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
138     }
139 }