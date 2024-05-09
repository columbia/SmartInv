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
79 contract BTHPoint is ERC20, Ownable {
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
90     uint256 internal UNLOCK_TERM = 12 * 30 * 24 * 3600; // 1 Year
91     uint256 internal _nextUnlockTime;
92     uint256 internal _lockupBalance;
93 
94     mapping(address => uint256) internal _balances;    
95     mapping(address => mapping(address => uint256)) internal _allowed;
96 
97     function BTHPoint() public {
98         name = "Bithumb Coin Point";
99         symbol = "BTHP";
100         decimals = 18;        
101         _nextUnlockTime = now + UNLOCK_TERM;
102 
103         //Total Supply  10,000,000,000
104         initialSupply = 10000000000;
105         _totalSupply = initialSupply * 10 ** uint(decimals);
106         _balances[owner] = 1000000000 * 10 ** uint(decimals);
107         _lockupBalance = _totalSupply.sub(_balances[owner]);
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
129         balance = _balances[_holder];
130         if(_holder == owner){
131             balance = _balances[_holder].add(_lockupBalance);
132         }
133         return balance;
134     }
135 
136     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
137         require(_from != address(0));
138         require(_to != address(0));
139         require(_to != address(this));
140         require(_value <= _balances[_from]);
141         require(_value <= _allowed[_from][msg.sender]);
142 
143         _balances[_from] = _balances[_from].sub(_value);
144         _balances[_to] = _balances[_to].add(_value);
145         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
146         emit Transfer(_from, _to, _value);
147         return true;
148     }
149 
150     function approve(address _spender, uint256 _value) public returns (bool) {
151         require(_value > 0);
152         _allowed[msg.sender][_spender] = _value;
153         emit Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     function allowance(address _holder, address _spender) public view returns (uint256) {
158         return _allowed[_holder][_spender];
159     }
160 
161     function () public payable {
162         revert();
163     }
164 
165     function burn(uint256 _value) public onlyOwner returns (bool success) {
166         require(_value <= _balances[msg.sender]);
167         address burner = msg.sender;
168         _balances[burner] = _balances[burner].sub(_value);
169         _totalSupply = _totalSupply.sub(_value);
170         return true;
171     }
172 
173     function balanceOfLockup() public view returns (uint256) {
174         return _lockupBalance;
175     }
176 
177     function nextUnlockTime() public view returns (uint256) {
178         return _nextUnlockTime;
179     }
180 
181     function unlock() public onlyOwner returns(bool) {
182         address tokenHolder = msg.sender;
183         require(_nextUnlockTime <= now);
184         require(_lockupBalance >= 1000000000 * 10 ** uint(decimals));
185 
186         _nextUnlockTime = _nextUnlockTime.add(UNLOCK_TERM);
187 
188         uint256 value = 1000000000 * 10 ** uint(decimals);
189 
190         _lockupBalance = _lockupBalance.sub(value);
191         _balances[tokenHolder] = _balances[tokenHolder].add(value);             
192     }
193 
194     function acceptOwnership() public onlyNewOwner returns(bool) {
195         uint256 ownerAmount = _balances[owner];
196         _balances[owner] = _balances[owner].sub(ownerAmount);
197         _balances[newOwner] = _balances[newOwner].add(ownerAmount);
198         emit Transfer(owner, newOwner, ownerAmount.add(_lockupBalance));   
199         owner = newOwner;
200         newOwner = address(0);
201         emit OwnershipTransferred(owner, newOwner);
202              
203     }
204     
205 }