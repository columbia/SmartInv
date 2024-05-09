1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   function Ownable() public {
11     owner = msg.sender;
12   }
13 
14 
15 
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18     _;
19   }
20 
21 
22   function transferOwnership(address newOwner) public onlyOwner {
23     require(newOwner != address(0));
24     OwnershipTransferred(owner, newOwner);
25     owner = newOwner;
26   }
27 
28 }
29 
30 contract ERC20Basic {
31   uint256 public totalSupply;
32   function balanceOf(address who) public view returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35   
36 }
37 
38 contract BasicToken is ERC20Basic, Ownable {
39 
40     using SafeMath for uint256;
41     mapping(address => uint256) balances;
42 
43     bool public transfersEnabledFlag;
44 
45 
46     modifier transfersEnabled() {
47         require(transfersEnabledFlag);
48         _;
49     }
50 
51     function enableTransfers() public onlyOwner {
52         transfersEnabledFlag = true;
53     }
54     
55     function unenableTransfers() public onlyOwner {
56         transfersEnabledFlag = false;
57     }
58 
59 
60     function transfer(address _to, uint256 _value) transfersEnabled() public returns (bool) {
61         require(_to != address(0));
62         require(_value <= balances[msg.sender]);
63 
64         // SafeMath.sub will throw if there is not enough balance.
65         balances[msg.sender] = balances[msg.sender].sub(_value);
66         balances[_to] = balances[_to].add(_value);
67         Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71 
72     function balanceOf(address _owner) public view returns (uint256 balance) {
73         return balances[_owner];
74     }
75 }
76 
77 
78 
79 
80 
81 library SafeMath {
82   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83     if (a == 0) {
84       return 0;
85     }
86     uint256 c = a * b;
87     assert(c / a == b);
88     return c;
89   }
90 
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     uint256 c = a / b;
93     return c;
94   }
95 
96   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97     assert(b <= a);
98     return a - b;
99   }
100 
101   function add(uint256 a, uint256 b) internal pure returns (uint256) {
102     uint256 c = a + b;
103     assert(c >= a);
104     return c;
105   }
106 }
107 
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) public view returns (uint256);
110   function transferFrom(address from, address to, uint256 value) public returns (bool);
111   function approve(address spender, uint256 value) public returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 
116 contract StandardToken is ERC20, BasicToken {
117 
118     mapping (address => mapping (address => uint256)) internal allowed;
119 
120 
121 
122     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123         require(_to != address(0));
124         require(_value <= balances[_from]);
125         require(_value <= allowed[_from][msg.sender]);
126 
127         balances[_from] = balances[_from].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130         Transfer(_from, _to, _value);
131         return true;
132     }
133 
134 
135     function approve(address _spender, uint256 _value) public returns (bool) {
136         allowed[msg.sender][_spender] = _value;
137         Approval(msg.sender, _spender, _value);
138         return true;
139     }
140 
141 
142     function allowance(address _owner, address _spender) public view returns (uint256) {
143         return allowed[_owner][_spender];
144     }
145 
146     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
147         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
148         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149         return true;
150     }
151 
152     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
153         uint oldValue = allowed[msg.sender][_spender];
154         if (_subtractedValue > oldValue) {
155             allowed[msg.sender][_spender] = 0;
156         }
157         else {
158             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
159         }
160         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161         return true;
162     }
163 
164 }
165 
166 contract MintableToken is StandardToken {
167     event Mint(address indexed to, uint256 amount);
168 
169     event MintFinished();
170 
171     bool public mintingFinished = false;
172 
173     mapping(address => bool) public minters;
174 
175     modifier canMint() {
176         require(!mintingFinished);
177         _;
178     }
179     modifier onlyMinters() {
180         require(minters[msg.sender] || msg.sender == owner);
181         _;
182     }
183     function addMinter(address _addr) public onlyOwner {
184         minters[_addr] = true;
185     }
186 
187     function deleteMinter(address _addr) public onlyOwner {
188         delete minters[_addr];
189     }
190 
191 
192     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
193         require(_to != address(0));
194         totalSupply = totalSupply.add(_amount);
195         balances[_to] = balances[_to].add(_amount);
196         Mint(_to, _amount);
197         Transfer(address(0), _to, _amount);
198         return true;
199     }
200 
201     function finishMinting() onlyOwner canMint public returns (bool) {
202         mintingFinished = true;
203         MintFinished();
204         return true;
205     }
206 }
207 
208 
209 
210 contract CappedToken is MintableToken {
211 
212     uint256 public cap;
213 
214     function CappedToken(uint256 _cap) public {
215         require(_cap > 0);
216         cap = _cap;
217     }
218 
219 
220     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
221         require(totalSupply.add(_amount) <= cap);
222 
223         return super.mint(_to, _amount);
224     }
225 
226 }
227 
228 
229 contract ParameterizedToken is CappedToken {
230     string public name;
231 
232     string public symbol;
233 
234     uint256 public decimals;
235 
236     function ParameterizedToken(string _name, string _symbol, uint256 _decimals, uint256 _capIntPart) public CappedToken(_capIntPart * 10 ** _decimals) {
237         name = _name;
238         symbol = _symbol;
239         decimals = _decimals;
240     }
241 
242 }
243 
244 contract JACToken is ParameterizedToken {
245 
246     function JACToken() public ParameterizedToken("Joint admissions coin", "JAC", 8, 21000000000) {
247     }
248 
249 }