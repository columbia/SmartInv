1 contract Ownable {
2     address public owner;
3 
4     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         require(newOwner != address(0));
17         emit OwnershipTransferred(owner, newOwner);
18         owner = newOwner;
19     }
20 
21 }
22 
23 contract Pausable is Ownable {
24     event Pause();
25     event Unpause();
26 
27     bool public paused = false;
28 
29     modifier whenNotPaused() {
30         if (msg.sender != owner) {
31             require(!paused);
32         }
33         _;
34     }
35 
36     modifier whenPaused() {
37         if (msg.sender != owner) {
38             require(paused);
39         }
40         _;
41     }
42 
43     function pause() onlyOwner public {
44         paused = true;
45         emit Pause();
46     }
47 
48     function unpause() onlyOwner public {
49         paused = false;
50         emit Unpause();
51     }
52 }
53 
54 library SafeMath {
55     function mul(uint a, uint b) internal pure returns (uint) {
56         if (a == 0) {
57             return 0;
58         }
59         uint c = a * b;
60         assert(c / a == b);
61         return c;
62     }
63 
64     function div(uint a, uint b) internal pure returns (uint) {
65         // assert(b > 0); // Solidity automatically throws when dividing by 0
66         uint c = a / b;
67         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68         return c;
69     }
70 
71     function sub(uint a, uint b) internal pure returns (uint) {
72         assert(b <= a);
73         return a - b;
74     }
75 
76     function add(uint a, uint b) internal pure returns (uint) {
77         uint c = a + b;
78         assert(c >= a);
79         return c;
80     }
81 }
82 
83 contract ERC20 {
84     string public name;
85     string public symbol;
86     uint8 public decimals;
87     uint public totalSupply;
88     constructor(string _name, string _symbol, uint8 _decimals) public {
89         name = _name;
90         symbol = _symbol;
91         decimals = _decimals;
92     }
93     function balanceOf(address who) public view returns (uint);
94     function transfer(address to, uint value) public returns (bool);
95     function allowance(address owner, address spender) public view returns (uint);
96     function transferFrom(address from, address to, uint value) public returns (bool);
97     function approve(address spender, uint value) public returns (bool);
98     event Transfer(address indexed from, address indexed to, uint value);
99     event Approval(address indexed owner, address indexed spender, uint value);
100 }
101 
102 contract Token is Pausable, ERC20 {
103     using SafeMath for uint;
104     event Burn(address indexed burner, uint256 value);
105 
106     mapping(address => uint) balances;
107     mapping (address => mapping (address => uint)) internal allowed;
108     mapping(address => uint) public balanceOfLocked;
109     mapping(address => bool) public addressLocked;
110 
111     constructor() ERC20("DWS", "DWS", 18) public {
112         totalSupply = 500000000 * 10 ** uint(decimals);
113         balances[msg.sender] = totalSupply;
114     }
115 
116     modifier lockCheck(address from, uint value) { 
117         require(addressLocked[from] == false);
118         require(balances[from] >= balanceOfLocked[from]);
119         require(value <= balances[from] - balanceOfLocked[from]);
120         _;
121     }
122 
123     function burn(uint _value) onlyOwner public {
124         balances[owner] = balances[owner].sub(_value);
125         totalSupply = totalSupply.sub(_value);
126         emit Burn(msg.sender, _value);
127     }
128 
129     function lockAddressValue(address _addr, uint _value) onlyOwner public {
130         balanceOfLocked[_addr] = _value;
131     }
132 
133     function lockAddress(address addr) onlyOwner public {
134         addressLocked[addr] = true;
135     }
136 
137     function unlockAddress(address addr) onlyOwner public {
138         addressLocked[addr] = false;
139     }
140 
141     function transfer(address _to, uint _value) lockCheck(msg.sender, _value) whenNotPaused public returns (bool) {
142         require(_to != address(0));
143         require(_value <= balances[msg.sender]);
144 
145         balances[msg.sender] = balances[msg.sender].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         emit Transfer(msg.sender, _to, _value);
148         return true;
149     }
150 
151     function balanceOf(address _owner) public view returns (uint balance) {
152         return balances[_owner];
153     }
154 
155     function transferFrom(address _from, address _to, uint _value) public lockCheck(_from, _value) whenNotPaused returns (bool) {
156         require(_to != address(0));
157         require(_value <= balances[_from]);
158         require(_value <= allowed[_from][msg.sender]);
159 
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         emit Transfer(_from, _to, _value);
164         return true;
165     }
166 
167     function approve(address _spender, uint _value) public whenNotPaused returns (bool) {
168         allowed[msg.sender][_spender] = _value;
169         emit Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     function allowance(address _owner, address _spender) public view returns (uint) {
174         return allowed[_owner][_spender];
175     }
176 
177     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
178         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
179         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180         return true;
181     }
182 
183     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
184         uint oldValue = allowed[msg.sender][_spender];
185         if (_subtractedValue > oldValue) {
186             allowed[msg.sender][_spender] = 0;
187         } else {
188             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
189         }
190         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191         return true;
192     }
193 }