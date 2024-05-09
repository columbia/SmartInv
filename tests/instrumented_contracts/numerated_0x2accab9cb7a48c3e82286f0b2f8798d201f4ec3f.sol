1 pragma solidity ^0.4.15;
2 
3 contract Owned {
4 
5     address owner;
6     
7     function Owned() { owner = msg.sender; }
8 
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 }
14 
15 contract TokenEIP20 {
16 
17     function balanceOf(address _owner) constant returns (uint256 balance);
18     function transfer(address _to, uint256 _value) returns (bool success);
19     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
20     function approve(address _spender, uint256 _value) returns (bool success);
21     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
22 
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25     
26 }
27 
28 contract TokenNotifier {
29 
30     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
31 }
32 
33 library SafeMathLib {
34 
35     uint constant WAD = 10 ** 18;
36     uint constant RAY = 10 ** 27;
37 
38     function add(uint x, uint y) internal returns (uint z) {
39         require((z = x + y) >= x);
40     }
41 
42     function sub(uint x, uint y) internal returns (uint z) {
43         require((z = x - y) <= x);
44     }
45 
46     function mul(uint x, uint y) internal returns (uint z) {
47         require(y == 0 || (z = x * y) / y == x);
48     }
49 
50     function per(uint x, uint y) internal constant returns (uint z) {
51         return mul((x / 100), y);
52     }
53 
54     function min(uint x, uint y) internal returns (uint z) {
55         return x <= y ? x : y;
56     }
57 
58     function max(uint x, uint y) internal returns (uint z) {
59         return x >= y ? x : y;
60     }
61 
62     function imin(int x, int y) internal returns (int z) {
63         return x <= y ? x : y;
64     }
65 
66     function imax(int x, int y) internal returns (int z) {
67         return x >= y ? x : y;
68     }
69 
70     function wmul(uint x, uint y) internal returns (uint z) {
71         z = add(mul(x, y), WAD / 2) / WAD;
72     }
73 
74     function rmul(uint x, uint y) internal returns (uint z) {
75         z = add(mul(x, y), RAY / 2) / RAY;
76     }
77 
78     function wdiv(uint x, uint y) internal returns (uint z) {
79         z = add(mul(x, WAD), y / 2) / y;
80     }
81 
82     function rdiv(uint x, uint y) internal returns (uint z) {
83         z = add(mul(x, RAY), y / 2) / y;
84     }
85 
86     function wper(uint x, uint y) internal constant returns (uint z) {
87         return wmul(wdiv(x, 100), y);
88     }
89 
90     // This famous algorithm is called "exponentiation by squaring"
91     // and calculates x^n with x as fixed-point and n as regular unsigned.
92     //
93     // It's O(log n), instead of O(n) for naive repeated multiplication.
94     //
95     // These facts are why it works:
96     //
97     //  If n is even, then x^n = (x^2)^(n/2).
98     //  If n is odd,  then x^n = x * x^(n-1),
99     //   and applying the equation for even x gives
100     //    x^n = x * (x^2)^((n-1) / 2).
101     //
102     //  Also, EVM division is flooring and
103     //    floor[(n-1) / 2] = floor[n / 2].
104     //
105     function rpow(uint x, uint n) internal returns (uint z) {
106         z = n % 2 != 0 ? x : RAY;
107 
108         for (n /= 2; n != 0; n /= 2) {
109             x = rmul(x, x);
110 
111             if (n % 2 != 0) {
112                 z = rmul(z, x);
113             }
114         }
115     }
116 
117 }
118 
119 contract BattleToken is Owned, TokenEIP20 {
120     using SafeMathLib for uint256;
121     
122     mapping (address => uint256) balances;
123     mapping (address => mapping (address => uint256)) allowed;
124     
125     string  public constant name        = "Battle";
126     string  public constant symbol      = "BTL";
127     uint256 public constant decimals    = 18;
128     uint256 public constant totalSupply = 1000000 * (10 ** decimals);
129 
130     function BattleToken(address _battleAddress) {
131         balances[owner] = totalSupply;
132         require(approve(_battleAddress, totalSupply));
133     }
134 
135     function transfer(address _to, uint256 _value) returns (bool success) {
136         if (balances[msg.sender] < _value) {
137             return false;
138         }
139         balances[msg.sender] = balances[msg.sender].sub(_value);
140         assert(balances[msg.sender] >= 0);
141         balances[_to] = balances[_to].add(_value);
142         assert(balances[_to] <= totalSupply);
143         Transfer(msg.sender, _to, _value);
144         return true;
145     }
146 
147     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
148         if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
149             return false;
150         }
151         balances[_from] = balances[_from].sub(_value);
152         assert(balances[_from] >= 0);
153         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         assert(balances[_to] <= totalSupply);        
156         Transfer(_from, _to, _value);
157         return true;
158     }
159 
160     function approve(address _spender, uint256 _value) returns (bool success) {
161         allowed[msg.sender][_spender] = _value;
162         Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
167         if (!approve(_spender, _value)) {
168             return false;
169         }
170         TokenNotifier(_spender).receiveApproval(msg.sender, _value, this, _extraData);
171         return true;
172     }
173 
174     function balanceOf(address _owner) constant returns (uint256 balance) {
175         return balances[_owner];
176     }
177 
178     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
179         return allowed[_owner][_spender];
180     }
181 }