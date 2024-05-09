1 pragma solidity ^0.5.7;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address who) external view returns (uint256);
6     function allowance(address owner, address spender) external view returns (uint256);
7 
8     function transfer(address to, uint256 value) external returns (bool);
9     function approve(address spender, uint256 value) external returns (bool);
10     function transferFrom(address from, address to, uint256 value) external returns (bool);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 /**
17  * @title SafeMath
18  * @dev Unsigned math operations with safety checks that revert on error.
19  */
20 library SafeMath {
21     /**
22       * @dev Multiplies two unsigned integers, reverts on overflow.
23       */
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
26         // benefit is lost if 'b' is also tested.
27         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b);
34 
35         return c;
36     }
37 
38     /**
39       * @dev Integer division of two unsigned integers truncating the quotient,
40       * reverts on division by zero.
41       */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Solidity only automatically asserts when dividing by 0
44         require(b > 0);
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50 
51     /**
52       * @dev Subtracts two unsigned integers, reverts on overflow
53       * (i.e. if subtrahend is greater than minuend).
54       */
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b <= a);
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63       * @dev Adds two unsigned integers, reverts on overflow.
64       */
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a);
68 
69         return c;
70     }
71 
72     /**
73       * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
74       * reverts when dividing by zero.
75       */
76     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b != 0);
78         return a % b;
79     }
80 }
81 
82 
83 contract StandardToken is IERC20 {
84     uint256 public totalSupply;
85 
86     using SafeMath for uint;
87 
88     mapping (address => uint256) internal balances;
89     mapping (address => mapping (address => uint256)) internal allowed;
90 
91     function balanceOf(address _owner) public view returns (uint256 balance) {
92         return balances[_owner];
93     }
94 
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
96         require(_to != address(0));
97         require(_value <= balances[_from]);
98         require(_value <= allowed[_from][msg.sender]);
99         require(balances[_to] + _value > balances[_to]);  // Check for overflows and negative value
100         balances[_from] = balances[_from].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
103         emit Transfer(_from, _to, _value);
104         return true;
105     }
106 
107     function approve(address _spender, uint256 _value) public returns (bool) {
108         require( _value > 0 , "No negative value");
109         allowed[msg.sender][_spender] = _value;
110         emit Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) public view returns (uint256) {
115         return allowed[_owner][_spender];
116     }
117 
118     function transfer(address _to, uint256 _value) public returns (bool success) {
119         require(_to != address(0));
120         require(balances[msg.sender] >= _value);
121         require(balances[_to] + _value > balances[_to]);  // Check for overflows and negative value
122         balances[msg.sender] = balances[msg.sender].sub(_value);
123         balances[_to] = balances[_to].add(_value);
124         emit Transfer(msg.sender, _to, _value);
125         return true;
126     }
127 
128 }
129 
130 contract GPS is StandardToken {
131     string public constant name = "Coinscious Network";
132     string public constant symbol = "GPS";
133     uint8 public constant decimals = 8;
134     uint256 public constant initialSupply = 2100000000 * 10 ** uint256(decimals);
135 
136     mapping (address => uint256) internal locks;
137     address internal tokenOwner;
138 
139     string internal constant ALREADY_LOCKED = 'Already locked';
140     string internal constant AMOUNT_ZERO = 'Amount must be greater than 0';
141     string internal constant TIME_ZERO = 'Time must be greater than 0';
142 
143     event Burn(address indexed from, uint256 value);
144 
145     constructor () public {
146         totalSupply = initialSupply;
147         balances[msg.sender] = initialSupply;
148         tokenOwner = msg.sender;
149     }
150 
151     function burn(uint256 _value) public returns (bool) {
152         require( balances[msg.sender] >= _value, "Insufficient balance");
153         require( _value > 0 , AMOUNT_ZERO);
154 
155         balances[msg.sender] = balances[msg.sender].sub(_value);
156         totalSupply = totalSupply.sub(_value);
157         emit Burn(msg.sender, _value);
158         return true;
159     }
160 
161     function lockTimeOf(address _owner) public view returns (uint256 time) {
162         return locks[_owner];
163     }
164 
165     modifier isNotLocked() {
166         require( locks[msg.sender] < now , "Locked");
167         _;
168     }
169 
170     modifier isNotLockedFrom(address _from) {
171         require( locks[_from] < now , "Locked");
172         _;
173     }
174 
175     modifier isOwner() {
176         require( msg.sender == tokenOwner , "Not Owner");
177         _;
178     }
179 
180     function transferWithLockTime(address _to, uint256 _value, uint256 _time)
181     public isOwner
182     returns (bool)
183     {
184         uint256 validUntil = now.add(_time);
185 
186         require(_time > 0, TIME_ZERO);
187         require(locks[_to] < now , ALREADY_LOCKED);
188         require(_value > 0, AMOUNT_ZERO);
189 
190         locks[_to] = validUntil;
191         return super.transfer(_to, _value);
192     }
193 
194     function transfer(address _to, uint256 _value) public isNotLocked() returns (bool) {
195         return super.transfer(_to, _value);
196     }
197 
198     function transferFrom(address _from, address _to, uint256 _value) public isNotLockedFrom(_from)  returns (bool) {
199         return super.transferFrom(_from, _to, _value);
200     }
201 
202 }