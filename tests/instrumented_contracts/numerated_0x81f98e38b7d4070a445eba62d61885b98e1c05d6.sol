1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12 
13         uint256 c = a * b;
14         require(c / a == b);
15 
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b > 0);
21         uint256 c = a / b;
22 
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         require(b <= a);
28         uint256 c = a - b;
29 
30         return c;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a);
36 
37         return c;
38     }
39 
40     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b != 0);
42         return a % b;
43     }
44 }
45 
46 interface ERC20 {
47     function balanceOf(address who) external view returns (uint256);
48     function transfer(address to, uint256 value) external returns (bool);
49     function allowance(address owner, address spender) external view returns (uint256);
50     function transferFrom(address from, address to, uint256 value) external returns (bool);
51     function approve(address spender, uint256 value) external returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 interface ERC223 {
57     function transfer(address to, uint value, bytes data) public;
58     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
59 }
60 
61 
62 contract ERC223ReceivingContract { 
63     function tokenFallback(address _from, uint _value, bytes _data) public;
64 }
65 
66 contract MarketplaceToken is ERC20, ERC223 {
67     using SafeMath for uint;
68     
69     address creator;
70     string internal _name;
71     string internal _symbol;
72     uint8 internal _decimals;
73     uint256 internal _totalSupply;
74 
75     mapping (address => uint256) internal balances;
76     mapping (address => mapping (address => uint256)) internal allowed;
77     
78     event Burn(address indexed from, uint256 value);
79     constructor() public {
80         _symbol = "MKTP";
81         _name = "Marketplace Token";
82         _decimals = 5;
83         _totalSupply = 70000000 * 10 ** uint256(_decimals);
84         balances[msg.sender] = _totalSupply;
85         creator = msg.sender;
86     }
87 
88     modifier onlyCreator() {
89         if(msg.sender != creator){
90             revert();
91         }
92         _;
93     }
94 
95     function name()
96         public
97         view
98         returns (string) {
99         return _name;
100     }
101 
102     function symbol()
103         public
104         view
105         returns (string) {
106         return _symbol;
107     }
108 
109     function decimals()
110         public
111         view
112         returns (uint8) {
113         return _decimals;
114     }
115 
116     function totalSupply()
117         public
118         view
119         returns (uint256) {
120         return _totalSupply;
121     }
122 
123     function changeCreator(address _newCreator) onlyCreator public returns (bool) {
124         if(creator != _newCreator) {
125             creator = _newCreator;
126             return true;
127         } else {
128             revert();
129         }
130     }
131 
132     function transfer(address _to, uint256 _value) public returns (bool) {
133         require(_to != address(0));
134         require(_value <= balances[msg.sender]);
135         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
136         balances[_to] = SafeMath.add(balances[_to], _value);
137         emit Transfer(msg.sender, _to, _value);
138         return true;
139     }
140 
141     function balanceOf(address _owner) public view returns (uint256 balance) {
142         return balances[_owner];
143     }
144 
145     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146         require(_to != address(0));
147         require(_value <= balances[_from]);
148         require(_value <= allowed[_from][msg.sender]);
149         
150         balances[_from] = SafeMath.sub(balances[_from], _value);
151         balances[_to] = SafeMath.add(balances[_to], _value);
152         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
153         emit Transfer(_from, _to, _value);
154         return true;
155     }
156 
157     function approve(address _spender, uint256 _value) public returns (bool) {
158         allowed[msg.sender][_spender] = _value;
159         emit Approval(msg.sender, _spender, _value);
160         return true;
161    }
162 
163     function allowance(address _owner, address _spender) public view returns (uint256) {
164         return allowed[_owner][_spender];
165     }
166 
167     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
168         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
169         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170         return true;
171     }
172     
173     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
174         uint oldValue = allowed[msg.sender][_spender];
175         if (_subtractedValue > oldValue) {
176             allowed[msg.sender][_spender] = 0;
177         } else {
178             allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
179         }
180         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183     
184     function transfer(address _to, uint _value, bytes _data) public {
185         require(_value > 0 );
186         if(isContract(_to)) {
187             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
188             receiver.tokenFallback(msg.sender, _value, _data);
189         }
190         balances[msg.sender] = balances[msg.sender].sub(_value);
191         balances[_to] = balances[_to].add(_value);
192         emit Transfer(msg.sender, _to, _value, _data);
193     }
194     
195     function isContract(address _addr) private view returns (bool is_contract) {
196         uint length;
197         assembly {
198             //retrieve the size of the code on target address, this needs assembly
199             length := extcodesize(_addr)
200         }
201         return (length>0);
202     }
203 
204     function burn(uint256 _value) public {
205         _burn(msg.sender, _value);
206     }
207 
208     function _burn(address _owner, uint256 _value) internal {
209         // Check if the sender has enough
210         require(balances[_owner] >= _value);
211 
212         // Subtract from the sender
213         balances[_owner] = balances[_owner].sub(_value);
214 
215         // Updates totalSupply
216         _totalSupply = _totalSupply.sub(_value);
217 
218         emit Transfer(_owner, address(0), _value);
219     }
220 
221 }