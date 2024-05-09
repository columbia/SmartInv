1 pragma solidity ^0.4.18;
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
33 
34 contract Ownable {
35     address public owner;
36     address public newOwner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     function Ownable() public {
41         owner = msg.sender;
42         newOwner = address(0);
43     }
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49     modifier onlyNewOwner() {
50         require(msg.sender != address(0));
51         require(msg.sender == newOwner);
52         _;
53     }
54 
55     function transferOwnership(address _newOwner) public onlyOwner {
56         require(_newOwner != address(0));
57         newOwner = _newOwner;
58     }
59 
60     function acceptOwnership() public onlyNewOwner returns(bool) {
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63     }
64 }
65 
66 contract ERC20 {
67     function totalSupply() public view returns (uint256);
68     function balanceOf(address who) public view returns (uint256);
69     function allowance(address owner, address spender) public view returns (uint256);
70     function transfer(address to, uint256 value) public returns (bool);
71     function transferFrom(address from, address to, uint256 value) public returns (bool);
72     function approve(address spender, uint256 value) public returns (bool);
73 
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 contract POPCHAINCASH is ERC20, Ownable {
79 
80     using SafeMath for uint256;
81 
82     string public name;
83     string public symbol;
84     uint8 public decimals;
85     uint256 internal initialSupply;
86     uint256 internal _totalSupply;
87     
88                                  
89     uint256 internal LOCKUP_TERM = 6 * 30 * 24 * 3600;
90 
91     mapping(address => uint256) internal _balances;
92     mapping(address => mapping(address => uint256)) internal _allowed;
93 
94     mapping(address => uint256) internal _lockupBalances;
95     mapping(address => uint256) internal _lockupExpireTime;
96 
97     function POPCHAINCASH() public {
98         name = "POPCHAIN CASH";
99         symbol = "PCH";
100         decimals = 18;
101 
102 
103         //Total Supply  2,000,000,000
104         initialSupply = 2000000000;
105         _totalSupply = initialSupply * 10 ** uint(decimals);
106         _balances[owner] = _totalSupply;
107         emit Transfer(address(0), owner, _totalSupply);
108     }
109 
110     function totalSupply() public view returns (uint256) {
111         return _totalSupply;
112     }
113 
114    
115     function transfer(address _to, uint256 _value) public returns (bool) {
116         require(_to != address(0));
117         require(_to != address(this));
118         require(msg.sender != address(0));
119         require(_value <= _balances[msg.sender]);
120 
121         // SafeMath.sub will throw if there is not enough balance.
122         _balances[msg.sender] = _balances[msg.sender].sub(_value);
123         _balances[_to] = _balances[_to].add(_value);
124         emit Transfer(msg.sender, _to, _value);
125         return true;
126     }
127 
128     function balanceOf(address _holder) public view returns (uint256 balance) {
129         return _balances[_holder].add(_lockupBalances[_holder]);
130     }
131 
132       
133     function lockupBalanceOf(address _holder) public view returns (uint256 balance) {
134         return _lockupBalances[_holder];
135     }
136 
137    
138     function unlockTimeOf(address _holder) public view returns (uint256 lockTime) {
139         return _lockupExpireTime[_holder];
140     }
141 
142     
143     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144         require(_from != address(0));
145         require(_to != address(0));
146         require(_to != address(this));
147         require(_value <= _balances[_from]);
148         require(_value <= _allowed[_from][msg.sender]);
149 
150         _balances[_from] = _balances[_from].sub(_value);
151         _balances[_to] = _balances[_to].add(_value);
152         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
153         emit Transfer(_from, _to, _value);
154         return true;
155     }
156 
157     function approve(address _spender, uint256 _value) public returns (bool) {
158         require(_value > 0);
159         _allowed[msg.sender][_spender] = _value;
160         emit Approval(msg.sender, _spender, _value);
161         return true;
162     }
163 
164     
165     function allowance(address _holder, address _spender) public view returns (uint256) {
166         return _allowed[_holder][_spender];
167     }
168 
169     
170     function () public payable {
171         revert();
172     }
173 
174     
175     function burn(uint256 _value) public onlyOwner returns (bool success) {
176         require(_value <= _balances[msg.sender]);
177         address burner = msg.sender;
178         _balances[burner] = _balances[burner].sub(_value);
179         _totalSupply = _totalSupply.sub(_value);
180         return true;
181     }
182 
183     
184     function distribute(address _to, uint256 _value, uint256 _lockupRate) public onlyOwner returns (bool) {
185         require(_to != address(0));
186         require(_to != address(this));
187         //Do not allow multiple distributions of the same address. Avoid locking time reset.
188         require(_lockupBalances[_to] == 0);     
189         require(_value <= _balances[owner]);
190         require(_lockupRate == 50 || _lockupRate == 100);
191 
192         _balances[owner] = _balances[owner].sub(_value);
193 
194         uint256 lockupValue = _value.mul(_lockupRate).div(100);
195         uint256 givenValue = _value.sub(lockupValue);
196         uint256 ExpireTime = now + LOCKUP_TERM; //six months
197 
198         if (_lockupRate == 100) {
199             ExpireTime += LOCKUP_TERM;          //one year.
200         }
201         
202         _balances[_to] = _balances[_to].add(givenValue);
203         _lockupBalances[_to] = _lockupBalances[_to].add(lockupValue);
204         _lockupExpireTime[_to] = ExpireTime;
205 
206         emit Transfer(owner, _to, _value);
207         return true;
208     }
209 
210     function unlock() public returns(bool) {
211         address tokenHolder = msg.sender;
212         require(_lockupBalances[tokenHolder] > 0);
213         require(_lockupExpireTime[tokenHolder] <= now);
214 
215         uint256 value = _lockupBalances[tokenHolder];
216 
217         _balances[tokenHolder] = _balances[tokenHolder].add(value);  
218         _lockupBalances[tokenHolder] = 0;
219 
220         return true;
221     }
222 
223     
224     function acceptOwnership() public onlyNewOwner returns(bool) {
225         uint256 ownerAmount = _balances[owner];
226         _balances[owner] = _balances[owner].sub(ownerAmount);
227         _balances[newOwner] = _balances[newOwner].add(ownerAmount);
228         emit Transfer(owner, newOwner, ownerAmount);   
229         owner = newOwner;
230         newOwner = address(0);
231         emit OwnershipTransferred(owner, newOwner);
232 
233         return true;
234     }
235 }