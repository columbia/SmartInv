1 pragma solidity 0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   function Ownable() public {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function transferOwnership(address newOwner) public onlyOwner {
18     require(newOwner != address(0));
19     OwnershipTransferred(owner, newOwner);
20     owner = newOwner;
21   }
22 
23 }
24 
25 contract ERC20Basic {
26   uint256 public totalSupply;
27   function balanceOf(address who) public view returns (uint256);
28   function transfer(address to, uint256 value) public returns (bool);
29   event Transfer(address indexed from, address indexed to, uint256 value);
30   
31 }
32 
33 contract BasicToken is ERC20Basic, Ownable {
34 
35     using SafeMath for uint256;
36     mapping(address => uint256) balances;
37 
38     bool public transfersEnabledFlag;
39 
40 
41     modifier transfersEnabled() {
42         require(transfersEnabledFlag);
43         _;
44     }
45 
46     function enableTransfers() public onlyOwner {
47         transfersEnabledFlag = true;
48     }
49 
50 
51     function transfer(address _to, uint256 _value) transfersEnabled() public returns (bool) {
52         require(_to != address(0));
53         require(_value <= balances[msg.sender]);
54 
55         // SafeMath.sub will throw if there is not enough balance.
56         balances[msg.sender] = balances[msg.sender].sub(_value);
57         balances[_to] = balances[_to].add(_value);
58         Transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62 
63     function balanceOf(address _owner) public view returns (uint256 balance) {
64         return balances[_owner];
65     }
66 }
67 
68 
69 
70 
71 
72 library SafeMath {
73   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74     if (a == 0) {
75       return 0;
76     }
77     uint256 c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return c;
87   }
88 
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) public view returns (uint256);
103   function transferFrom(address from, address to, uint256 value) public returns (bool);
104   function approve(address spender, uint256 value) public returns (bool);
105   event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 
109 contract StandardToken is ERC20, BasicToken {
110 
111     mapping (address => mapping (address => uint256)) internal allowed;
112 
113 
114 
115     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116         require(_to != address(0));
117         require(_value <= balances[_from]);
118         require(_value <= allowed[_from][msg.sender]);
119 
120         balances[_from] = balances[_from].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123         Transfer(_from, _to, _value);
124         return true;
125     }
126 
127 
128     function approve(address _spender, uint256 _value) public returns (bool) {
129         allowed[msg.sender][_spender] = _value;
130         Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134 
135     function allowance(address _owner, address _spender) public view returns (uint256) {
136         return allowed[_owner][_spender];
137     }
138 
139     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
140         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
141         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142         return true;
143     }
144 
145     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
146         uint oldValue = allowed[msg.sender][_spender];
147         if (_subtractedValue > oldValue) {
148             allowed[msg.sender][_spender] = 0;
149         }
150         else {
151             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
152         }
153         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154         return true;
155     }
156 
157 }
158 
159 contract MintableToken is StandardToken {
160     event Mint(address indexed to, uint256 amount);
161 
162     event MintFinished();
163 
164     bool public mintingFinished = false;
165 
166     mapping(address => bool) public minters;
167 
168     modifier canMint() {
169         require(!mintingFinished);
170         _;
171     }
172     modifier onlyMinters() {
173         require(minters[msg.sender] || msg.sender == owner);
174         _;
175     }
176     function addMinter(address _addr) public onlyOwner {
177         minters[_addr] = true;
178     }
179 
180     function deleteMinter(address _addr) public onlyOwner {
181         delete minters[_addr];
182     }
183 
184 
185     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
186         require(_to != address(0));
187         totalSupply = totalSupply.add(_amount);
188         balances[_to] = balances[_to].add(_amount);
189         Mint(_to, _amount);
190         Transfer(address(0), _to, _amount);
191         return true;
192     }
193 
194     function finishMinting() onlyOwner canMint public returns (bool) {
195         mintingFinished = true;
196         MintFinished();
197         return true;
198     }
199 }
200 
201 
202 
203 contract CappedToken is MintableToken {
204 
205     uint256 public cap;
206 
207     function CappedToken(uint256 _cap) public {
208         require(_cap > 0);
209         cap = _cap;
210     }
211 
212 
213     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
214         require(totalSupply.add(_amount) <= cap);
215 
216         return super.mint(_to, _amount);
217     }
218 
219 }
220 
221 
222 contract ParameterizedToken is CappedToken {
223     string public name;
224 
225     string public symbol;
226 
227     uint256 public decimals;
228 
229     function ParameterizedToken(string _name, string _symbol, uint256 _decimals, uint256 _capIntPart) public CappedToken(_capIntPart * 10 ** _decimals) {
230         name = _name;
231         symbol = _symbol;
232         decimals = _decimals;
233     }
234 
235 }
236 
237 contract TORQCoin is ParameterizedToken {
238 
239     function TORQCoin() public ParameterizedToken("TORQ Coin", "TORQ", 18, 30000000) {
240     }
241 }