1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     constructor() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) public onlyOwner {
18         require(newOwner != address(0));
19         emit OwnershipTransferred(owner, newOwner);
20         owner = newOwner;
21     }
22 
23 }
24 
25 contract Pausable is Ownable {
26     event Pause();
27     event Unpause();
28 
29     bool public paused = false;
30 
31     modifier whenNotPaused() {
32         if (msg.sender != owner) {
33             require(!paused);
34         }
35         _;
36     }
37 
38     modifier whenPaused() {
39         if (msg.sender != owner) {
40             require(paused);
41         }
42         _;
43     }
44 
45     function pause() onlyOwner public {
46         paused = true;
47         emit Pause();
48     }
49 
50     function unpause() onlyOwner public {
51         paused = false;
52         emit Unpause();
53     }
54 }
55 
56 library SafeMath {
57     function mul(uint a, uint b) internal pure returns (uint) {
58         if (a == 0) {
59             return 0;
60         }
61         uint c = a * b;
62         assert(c / a == b);
63         return c;
64     }
65 
66     function div(uint a, uint b) internal pure returns (uint) {
67         // assert(b > 0); // Solidity automatically throws when dividing by 0
68         uint c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70         return c;
71     }
72 
73     function sub(uint a, uint b) internal pure returns (uint) {
74         assert(b <= a);
75         return a - b;
76     }
77 
78     function add(uint a, uint b) internal pure returns (uint) {
79         uint c = a + b;
80         assert(c >= a);
81         return c;
82     }
83 }
84 
85 contract ERC20 {
86     string public name;
87     string public symbol;
88     uint8 public decimals;
89     uint public totalSupply;
90     constructor(string _name, string _symbol, uint8 _decimals) public {
91         name = _name;
92         symbol = _symbol;
93         decimals = _decimals;
94     }
95     function balanceOf(address who) public view returns (uint);
96     function transfer(address to, uint value) public returns (bool);
97     function allowance(address owner, address spender) public view returns (uint);
98     function transferFrom(address from, address to, uint value) public returns (bool);
99     function approve(address spender, uint value) public returns (bool);
100     event Transfer(address indexed from, address indexed to, uint value);
101     event Approval(address indexed owner, address indexed spender, uint value);
102 }
103 
104 contract Token is Pausable, ERC20 {
105     using SafeMath for uint;
106     event Burn(address indexed burner, uint256 value);
107 
108     mapping(address => uint) balances;
109     mapping (address => mapping (address => uint)) internal allowed;
110     mapping(address => uint) public balanceOfLocked;
111     mapping(address => bool) public addressLocked;
112 
113     constructor() ERC20("OCP", "OCP", 18) public {
114         totalSupply = 10000000000 * 10 ** uint(decimals);
115         balances[msg.sender] = totalSupply;
116     }
117 
118     modifier lockCheck(address from, uint value) { 
119         require(addressLocked[from] == false);
120         require(balances[from] >= balanceOfLocked[from]);
121         require(value <= balances[from] - balanceOfLocked[from]);
122         _;
123     }
124 
125     function burn(uint _value) onlyOwner public {
126         balances[owner] = balances[owner].sub(_value);
127         totalSupply = totalSupply.sub(_value);
128         emit Burn(msg.sender, _value);
129     }
130 
131     function lockAddressValue(address _addr, uint _value) onlyOwner public {
132         balanceOfLocked[_addr] = _value;
133     }
134 
135     function lockAddress(address addr) onlyOwner public {
136         addressLocked[addr] = true;
137     }
138 
139     function unlockAddress(address addr) onlyOwner public {
140         addressLocked[addr] = false;
141     }
142 
143     function transfer(address _to, uint _value) lockCheck(msg.sender, _value) whenNotPaused public returns (bool) {
144         require(_to != address(0));
145         require(_value <= balances[msg.sender]);
146 
147         // SafeMath.sub will throw if there is not enough balance.
148         balances[msg.sender] = balances[msg.sender].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         emit Transfer(msg.sender, _to, _value);
151         return true;
152     }
153 
154     function balanceOf(address _owner) public view returns (uint balance) {
155         return balances[_owner];
156     }
157 
158     function transferFrom(address _from, address _to, uint _value) public lockCheck(_from, _value) whenNotPaused returns (bool) {
159         require(_to != address(0));
160         require(_value <= balances[_from]);
161         require(_value <= allowed[_from][msg.sender]);
162 
163         balances[_from] = balances[_from].sub(_value);
164         balances[_to] = balances[_to].add(_value);
165         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166         emit Transfer(_from, _to, _value);
167         return true;
168     }
169 
170     function approve(address _spender, uint _value) public whenNotPaused returns (bool) {
171         allowed[msg.sender][_spender] = _value;
172         emit Approval(msg.sender, _spender, _value);
173         return true;
174     }
175 
176     function allowance(address _owner, address _spender) public view returns (uint) {
177         return allowed[_owner][_spender];
178     }
179 
180     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
181         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
182         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183         return true;
184     }
185 
186     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
187         uint oldValue = allowed[msg.sender][_spender];
188         if (_subtractedValue > oldValue) {
189             allowed[msg.sender][_spender] = 0;
190         } else {
191             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
192         }
193         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194         return true;
195     }
196 }