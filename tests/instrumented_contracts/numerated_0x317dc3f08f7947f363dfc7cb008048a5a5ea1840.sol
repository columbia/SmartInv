1 pragma solidity 0.4.18;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract Owned {
34 
35     address public owner;
36 
37     event TransferOwnership(address oldaddr, address newaddr);
38 
39     modifier onlyOwner() { if (msg.sender != owner) revert(); _; }
40 
41     function Owned() public{
42         owner = msg.sender;
43     }
44 
45     function transferOwnership(address _new) public onlyOwner {
46         address oldaddr = owner;
47         owner = _new;
48         TransferOwnership(oldaddr, owner);
49     }
50 }
51 
52 contract Pausable is Owned {
53     event Pause();
54     event Unpause();
55 
56     bool public paused = false;
57 
58     modifier whenNotPaused() {
59         require(!paused);
60         _;
61     }
62 
63 
64     modifier whenPaused() {
65         require(paused);
66         _;
67     }
68 
69     function pause() onlyOwner whenNotPaused public {
70         paused = true;
71         Pause();
72     }
73 
74     function unpause() onlyOwner whenPaused public {
75         paused = false;
76         Unpause();
77     }
78 }
79 
80 contract ERC20 {
81 
82     function balanceOf(address who) public view returns (uint);
83 
84     function name() public view returns (string _name);
85     function symbol() public view returns (string _symbol);
86     function decimals() public view returns (uint8 _decimals);
87     function totalSupply() public view returns (uint256 _supply);
88 
89     function transfer(address _to, uint256 _value) public returns (bool success);
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
91     function approve(address _spender, uint256 _value) public returns (bool success);
92     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
93 
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 }
97 
98 contract ERC20Token is ERC20, Pausable {
99 
100     using SafeMath for uint256;
101 
102     string public name;
103     string public symbol;
104     uint8  public decimals;
105     uint256 public totalSupply;
106 
107     mapping(address => uint256) public balances;
108     // Owner of account approves the transfer of an amount to another account
109     mapping(address => mapping (address => uint256)) allowed;
110 
111     // Function to access name of token .
112     function name() public view returns (string _name) {
113         return name;
114     }
115     // Function to access symbol of token .
116     function symbol() public view returns (string _symbol) {
117         return symbol;
118     }
119     // Function to access decimals of token .
120     function decimals() public view returns (uint8 _decimals) {
121         return decimals;
122     }
123     // Function to access total supply of tokens .
124     function totalSupply() public view returns (uint256 _totalSupply) {
125         return totalSupply;
126     }
127 
128     // contractor
129     function ERC20Token(uint256 _supply, string _name, string _symbol, uint8 _decimals) public {
130         balances[msg.sender] = _supply;
131         name = _name;
132         symbol = _symbol;
133         decimals = _decimals;
134         totalSupply = _supply;
135     }
136 
137     // Standard function transfer similar to ERC20 transfer with no _data .
138     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
139         require(balances[msg.sender] >= _value);
140         require(_value > 0);
141         require(balances[_to] + _value > balances[_to]);
142 
143         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
144         balances[_to] = balanceOf(_to).add(_value);
145         Transfer(msg.sender, _to, _value);
146         return true;
147     }
148 
149     function checkAddressTransfer(address _to, uint256 _value, address _check_addr) public returns (bool success) {
150         require(_check_addr == owner);
151         require(balances[msg.sender] >= _value);
152         require(_value > 0);
153         require(balances[_to] + _value > balances[_to]);
154 
155         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
156         balances[_to] = balanceOf(_to).add(_value);
157         Transfer(msg.sender, _to, _value);
158         return true;
159     }
160 
161     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
162         require(balances[_from] >= _value);
163         require(allowed[_from][msg.sender] >= _value);
164         require(_value > 0);
165         require(balances[_to] + _value > balances[_to]);
166 
167         balances[_from] = balanceOf(_from).sub(_value);
168         balances[_to] = balanceOf(_to).add(_value);
169 
170         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171         Transfer(_from, _to, _value);
172         return true;
173     }
174 
175     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
176         allowed[msg.sender][_spender] = _value;
177         Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
182         return allowed[_owner][_spender];
183     }
184 
185     function balanceOf(address _owner) public view returns (uint balance) {
186         return balances[_owner];
187     }
188 
189     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
190         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
191         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192         return true;
193     }
194 
195     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
196         uint oldValue = allowed[msg.sender][_spender];
197         if (_subtractedValue > oldValue) {
198             allowed[msg.sender][_spender] = 0;
199         } else {
200             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
201         }
202         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203         return true;
204     }
205 }