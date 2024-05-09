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
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;       
20     }       
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 contract Ownable {
36     address public owner;
37     address public newOwner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     function Ownable() public {
42         owner = msg.sender;
43         newOwner = address(0);
44     }
45 
46     modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50     modifier onlyNewOwner() {
51         require(msg.sender != address(0));
52         require(msg.sender == newOwner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         require(_newOwner != address(0));
58         newOwner = _newOwner;
59     }
60 
61     function acceptOwnership() public onlyNewOwner returns(bool) {
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64     }
65 }
66 
67 contract ERC20 {
68     function totalSupply() public view returns (uint256);
69     function balanceOf(address who) public view returns (uint256);
70     function allowance(address owner, address spender) public view returns (uint256);
71     function transfer(address to, uint256 value) public returns (bool);
72     function transferFrom(address from, address to, uint256 value) public returns (bool);
73     function approve(address spender, uint256 value) public returns (bool);
74 
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 contract BTHBCoin is ERC20, Ownable {
80 
81     using SafeMath for uint256;
82 
83     string public name;
84     string public symbol;
85     uint8 public decimals;
86     uint256 internal initialSupply;
87     uint256 internal _totalSupply;
88     
89                                  
90     uint256 internal LOCKUP_TERM = 6 * 30 * 24 * 3600;
91 
92     mapping(address => uint256) internal _balances;    
93     mapping(address => mapping(address => uint256)) internal _allowed;
94 
95     mapping(address => uint256) internal _lockupBalances;
96     mapping(address => uint256) internal _lockupExpireTime;
97 
98     function BTHBCoin() public {
99         name = "Bithumb Coin";
100         symbol = "BTHB";
101         decimals = 18;
102 
103 
104         //Total Supply  10,000,000,000
105         initialSupply = 10000000000;
106         _totalSupply = initialSupply * 10 ** uint(decimals);
107         _balances[owner] = _totalSupply;
108         emit Transfer(address(0), owner, _totalSupply);
109     }
110 
111     function totalSupply() public view returns (uint256) {
112         return _totalSupply;
113     }
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
132     function lockupBalanceOf(address _holder) public view returns (uint256 balance) {
133         return _lockupBalances[_holder];
134     }
135 
136     function unlockTimeOf(address _holder) public view returns (uint256 balance) {
137         return _lockupExpireTime[_holder];
138     }
139 
140     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141         require(_from != address(0));
142         require(_to != address(0));
143         require(_to != address(this));
144         require(_value <= _balances[_from]);
145         require(_value <= _allowed[_from][msg.sender]);
146 
147         _balances[_from] = _balances[_from].sub(_value);
148         _balances[_to] = _balances[_to].add(_value);
149         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
150         emit Transfer(_from, _to, _value);
151         return true;
152     }
153 
154     function approve(address _spender, uint256 _value) public returns (bool) {
155         require(_value > 0);
156         _allowed[msg.sender][_spender] = _value;
157         emit Approval(msg.sender, _spender, _value);
158         return true;
159     }
160 
161     function allowance(address _holder, address _spender) public view returns (uint256) {
162         return _allowed[_holder][_spender];
163     }
164 
165     function () public payable {
166         revert();
167     }
168 
169     function burn(uint256 _value) public onlyOwner returns (bool success) {
170         require(_value <= _balances[msg.sender]);
171         address burner = msg.sender;
172         _balances[burner] = _balances[burner].sub(_value);
173         _totalSupply = _totalSupply.sub(_value);
174         return true;
175     }
176 
177     function distribute(address _to, uint256 _value, uint256 _lockupRate) public onlyOwner returns (bool) {
178         require(_to != address(0));
179         require(_to != address(this));
180         require(_value <= _balances[owner]);
181         require(_lockupRate >= 50 && _lockupRate<=100 && _lockupRate.div(5).mul(5) == _lockupRate );
182 
183         _balances[owner] = _balances[owner].sub(_value);
184 
185         uint256 lockupValue = _value.mul(_lockupRate).div(100);
186         uint256 givenValue = _value.sub(lockupValue);
187         uint256 ExpireTime = now + LOCKUP_TERM;
188         
189         _balances[_to] = _balances[_to].add(givenValue);
190         _lockupBalances[_to] = _lockupBalances[_to].add(lockupValue);
191         _lockupExpireTime[_to] = ExpireTime;
192 
193         emit Transfer(owner, _to, _value);
194         return true;
195     }
196 
197     function unlock() public returns(bool) {
198         address tokenHolder = msg.sender;
199         require(_lockupBalances[tokenHolder] > 0);
200         require(_lockupExpireTime[tokenHolder] <= now);
201 
202         uint256 value = _lockupBalances[tokenHolder];
203 
204         _balances[tokenHolder] = _balances[tokenHolder].add(value);  
205         _lockupBalances[tokenHolder] = 0;             
206     }
207 
208     function acceptOwnership() public onlyNewOwner returns(bool) {
209         uint256 ownerAmount = _balances[owner];
210         _balances[owner] = _balances[owner].sub(ownerAmount);
211         _balances[newOwner] = _balances[newOwner].add(ownerAmount);
212         emit Transfer(owner, newOwner, ownerAmount);   
213         owner = newOwner;
214         newOwner = address(0);
215         emit OwnershipTransferred(owner, newOwner);
216     }
217     
218 }