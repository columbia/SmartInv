1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   constructor() public {
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
24     emit OwnershipTransferred(owner, newOwner);
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
38 contract LockAccount is Ownable{
39     
40     mapping (address => bool) public lockAccounts;
41     event LockFunds(address target, bool lock);
42     
43     constructor() public{
44         
45     }
46     modifier onlyUnLock{
47         require(!lockAccounts[msg.sender]);
48         _;
49     }
50     
51     function lockAccounts(address target, bool lock) public onlyOwner {
52       lockAccounts[target] = lock;
53       emit LockFunds(target, lock);
54     }
55     
56     
57 }
58 
59 
60 contract BasicToken is ERC20Basic, Ownable ,LockAccount {
61 
62     using SafeMath for uint256;
63     mapping(address => uint256) balances;
64 
65     bool public transfersEnabledFlag = true;
66 
67 
68     modifier transfersEnabled() {
69         require(transfersEnabledFlag);
70         _;
71     }
72 
73     function enableTransfers() public onlyOwner {
74         transfersEnabledFlag = true;
75     }
76     
77     function disableTransfers() public onlyOwner {
78         transfersEnabledFlag = false;
79     }
80 
81 
82     function transfer(address _to, uint256 _value) transfersEnabled onlyUnLock  public returns (bool) {
83         require(_to != address(0));
84         require(_value <= balances[msg.sender]);
85 
86         // SafeMath.sub will throw if there is not enough balance.
87         balances[msg.sender] = balances[msg.sender].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         emit Transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93 
94     function balanceOf(address _owner) public view returns (uint256 balance) {
95         return balances[_owner];
96     }
97 }
98 
99 
100 
101 
102 
103 library SafeMath {
104   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105     if (a == 0) {
106       return 0;
107     }
108     uint256 c = a * b;
109     assert(c / a == b);
110     return c;
111   }
112 
113   function div(uint256 a, uint256 b) internal pure returns (uint256) {
114     // assert(b > 0); // Solidity automatically throws when dividing by 0
115     uint256 c = a / b;
116     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117     return c;
118   }
119 
120   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121     assert(b <= a);
122     return a - b;
123   }
124 
125   function add(uint256 a, uint256 b) internal pure returns (uint256) {
126     uint256 c = a + b;
127     assert(c >= a);
128     return c;
129   }
130 }
131 
132 contract ERC20 is ERC20Basic {
133   function allowance(address owner, address spender) public view returns (uint256);
134   function transferFrom(address from, address to, uint256 value) public returns (bool);
135   function approve(address spender, uint256 value) public returns (bool);
136   event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 
139 
140 contract StandardToken is ERC20, BasicToken {
141 
142     mapping (address => mapping (address => uint256)) internal allowed;
143 
144 
145 
146     function transferFrom(address _from, address _to, uint256 _value) transfersEnabled onlyUnLock public returns (bool) {
147         require(_to != address(0));
148         require(_value <= balances[_from]);
149         require(_value <= allowed[_from][msg.sender]);
150 
151         balances[_from] = balances[_from].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154         emit Transfer(_from, _to, _value);
155         return true;
156     }
157 
158 
159     function approve(address _spender, uint256 _value) transfersEnabled onlyUnLock  public returns (bool) {
160         allowed[msg.sender][_spender] = _value;
161         emit Approval(msg.sender, _spender, _value);
162         return true;
163     }
164 
165 
166     function allowance(address _owner, address _spender) public view returns (uint256) {
167         return allowed[_owner][_spender];
168     }
169 
170     function increaseApproval(address _spender, uint _addedValue) transfersEnabled onlyUnLock  public returns (bool) {
171         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173         return true;
174     }
175 
176     function decreaseApproval(address _spender, uint _subtractedValue) transfersEnabled onlyUnLock public  returns (bool) {
177         uint oldValue = allowed[msg.sender][_spender];
178         if (_subtractedValue > oldValue) {
179             allowed[msg.sender][_spender] = 0;
180         }
181         else {
182             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183         }
184         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185         return true;
186     }
187 
188 }
189 
190 contract MintableToken is StandardToken {
191     event Mint(address indexed to, uint256 amount);
192 
193     event MintFinished();
194 
195     bool public mintingFinished = false;
196 
197     mapping(address => bool) public minters;
198 
199     modifier canMint() {
200         require(!mintingFinished);
201         _;
202     }
203     modifier onlyMinters() {
204         require(minters[msg.sender] || msg.sender == owner);
205         _;
206     }
207     function addMinter(address _addr) public onlyOwner {
208         minters[_addr] = true;
209     }
210 
211     function deleteMinter(address _addr) public onlyOwner {
212         delete minters[_addr];
213     }
214 
215 
216     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
217         require(_to != address(0));
218         totalSupply = totalSupply.add(_amount);
219         balances[_to] = balances[_to].add(_amount);
220         emit Mint(_to, _amount);
221         emit Transfer(address(0), _to, _amount);
222         return true;
223     }
224 
225     function finishMinting() onlyOwner canMint public returns (bool) {
226         mintingFinished = true;
227         emit MintFinished();
228         return true;
229     }
230 }
231 
232 
233 
234 contract CappedToken is MintableToken {
235 
236     uint256 public cap;
237 
238     constructor(uint256 _cap) public {
239         require(_cap > 0);
240         cap = _cap;
241     }
242 
243 
244     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
245         require(totalSupply.add(_amount) <= cap);
246 
247         return super.mint(_to, _amount);
248     }
249 
250 }
251 
252 
253 contract TokenParam is CappedToken {
254     string public name;
255 
256     string public symbol;
257 
258     uint256 public decimals;
259 
260     constructor(string _name, string _symbol, uint256 _decimals, uint256 _capIntPart) public CappedToken(_capIntPart * 10 ** _decimals) {
261         name = _name;
262         symbol = _symbol;
263         decimals = _decimals;
264     }
265 
266 }
267 
268 contract VIDToken is TokenParam {
269 
270     constructor() public TokenParam("VID", "VID", 18, 20000000000) {
271     }
272 
273 }