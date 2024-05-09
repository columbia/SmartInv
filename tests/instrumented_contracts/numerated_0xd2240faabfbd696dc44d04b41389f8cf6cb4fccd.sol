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
59 contract BasicToken is ERC20Basic, Ownable ,LockAccount {
60 
61     using SafeMath for uint256;
62     mapping(address => uint256) balances;
63 
64     bool public transfersEnabledFlag = true;
65 
66 
67     modifier transfersEnabled() {
68         require(transfersEnabledFlag);
69         _;
70     }
71 
72     function enableTransfers() public onlyOwner {
73         transfersEnabledFlag = true;
74     }
75     
76     function disableTransfers() public onlyOwner {
77         transfersEnabledFlag = false;
78     }
79 
80 
81     function transfer(address _to, uint256 _value) transfersEnabled onlyUnLock public returns (bool) {
82         require(_to != address(0));
83         require(_value <= balances[msg.sender]);
84 
85         // SafeMath.sub will throw if there is not enough balance.
86         balances[msg.sender] = balances[msg.sender].sub(_value);
87         balances[_to] = balances[_to].add(_value);
88         emit Transfer(msg.sender, _to, _value);
89         return true;
90     }
91 
92 
93     function balanceOf(address _owner) public view returns (uint256 balance) {
94         return balances[_owner];
95     }
96 }
97 
98 
99 
100 
101 
102 library SafeMath {
103   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104     if (a == 0) {
105       return 0;
106     }
107     uint256 c = a * b;
108     assert(c / a == b);
109     return c;
110   }
111 
112   function div(uint256 a, uint256 b) internal pure returns (uint256) {
113     // assert(b > 0); // Solidity automatically throws when dividing by 0
114     uint256 c = a / b;
115     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116     return c;
117   }
118 
119   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120     assert(b <= a);
121     return a - b;
122   }
123 
124   function add(uint256 a, uint256 b) internal pure returns (uint256) {
125     uint256 c = a + b;
126     assert(c >= a);
127     return c;
128   }
129 }
130 
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender) public view returns (uint256);
133   function transferFrom(address from, address to, uint256 value) public returns (bool);
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 
138 
139 contract StandardToken is ERC20, BasicToken {
140 
141     mapping (address => mapping (address => uint256)) internal allowed;
142 
143 
144 
145     function transferFrom(address _from, address _to, uint256 _value) transfersEnabled onlyUnLock public returns (bool) {
146         require(_to != address(0));
147         require(_value <= balances[_from]);
148         require(_value <= allowed[_from][msg.sender]);
149 
150         balances[_from] = balances[_from].sub(_value);
151         balances[_to] = balances[_to].add(_value);
152         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153         emit Transfer(_from, _to, _value);
154         return true;
155     }
156 
157 
158     function approve(address _spender, uint256 _value) transfersEnabled onlyUnLock public returns (bool) {
159         allowed[msg.sender][_spender] = _value;
160         emit Approval(msg.sender, _spender, _value);
161         return true;
162     }
163 
164 
165     function allowance(address _owner, address _spender) public view returns (uint256) {
166         return allowed[_owner][_spender];
167     }
168 
169     function increaseApproval(address _spender, uint _addedValue) transfersEnabled onlyUnLock public returns (bool) {
170         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
171         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172         return true;
173     }
174 
175     function decreaseApproval(address _spender, uint _subtractedValue) transfersEnabled onlyUnLock public  returns (bool) {
176         uint oldValue = allowed[msg.sender][_spender];
177         if (_subtractedValue > oldValue) {
178             allowed[msg.sender][_spender] = 0;
179         }
180         else {
181             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
182         }
183         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184         return true;
185     }
186 
187 }
188 
189 contract MintableToken is StandardToken {
190     event Mint(address indexed to, uint256 amount);
191 
192     event MintFinished();
193 
194     bool public mintingFinished = false;
195 
196     mapping(address => bool) public minters;
197 
198     modifier canMint() {
199         require(!mintingFinished);
200         _;
201     }
202     modifier onlyMinters() {
203         require(minters[msg.sender] || msg.sender == owner);
204         _;
205     }
206     function addMinter(address _addr) public onlyOwner {
207         minters[_addr] = true;
208     }
209 
210     function deleteMinter(address _addr) public onlyOwner {
211         delete minters[_addr];
212     }
213 
214 
215     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
216         require(_to != address(0));
217         totalSupply = totalSupply.add(_amount);
218         balances[_to] = balances[_to].add(_amount);
219         emit Mint(_to, _amount);
220         emit Transfer(address(0), _to, _amount);
221         return true;
222     }
223 
224     function finishMinting() onlyOwner canMint public returns (bool) {
225         mintingFinished = true;
226         emit MintFinished();
227         return true;
228     }
229 }
230 
231 
232 
233 contract CappedToken is MintableToken {
234 
235     uint256 public cap;
236 
237     constructor(uint256 _cap) public {
238         require(_cap > 0);
239         cap = _cap;
240     }
241 
242 
243     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
244         require(totalSupply.add(_amount) <= cap);
245 
246         return super.mint(_to, _amount);
247     }
248 
249 }
250 
251 
252 contract TokenParam is CappedToken {
253     string public name;
254 
255     string public symbol;
256 
257     uint256 public decimals;
258 
259     constructor(string _name, string _symbol, uint256 _decimals, uint256 _capIntPart) public CappedToken(_capIntPart * 10 ** _decimals) {
260         name = _name;
261         symbol = _symbol;
262         decimals = _decimals;
263     }
264 
265 }
266 
267 contract HCCCToken is TokenParam {
268 
269     constructor() public TokenParam("HCCC", "HCCC", 18, 1000000000) {
270     }
271 
272 }