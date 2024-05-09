1 pragma solidity 0.6.0;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7 
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         return sub(a, b, "SafeMath: subtraction overflow");
13     }
14 
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18 
19         return c;
20     }
21 
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29 
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         return div(a, b, "SafeMath: division by zero");
35     }
36 
37     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b > 0, errorMessage);
39         uint256 c = a / b;
40 
41         return c;
42     }
43 
44     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
45         return mod(a, b, "SafeMath: modulo by zero");
46     }
47 
48     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b != 0, errorMessage);
50         return a % b;
51     }
52 }
53 
54 contract Ownable {
55     address public _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     constructor () public {
60         _owner = msg.sender;
61         emit OwnershipTransferred(address(0), msg.sender);
62     }
63 
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     modifier onlyOwner() {
69         require(_owner == msg.sender, "Ownable: caller is not the owner");
70         _;
71     }
72 
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83 }
84 
85 contract YELD is Ownable {
86 
87     using SafeMath for uint256;
88 
89     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
90 
91     modifier validRecipient(address to) {
92         require(to != address(this));
93         _;
94     }
95     
96     event Transfer(address indexed from, address indexed to, uint256 value);
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 
99     string public constant name = "YELD";
100     string public constant symbol = "YELD";
101     uint256 public constant decimals = 18;
102 
103     uint256 private constant DECIMALS = 18;
104     uint256 private constant MAX_UINT256 = ~uint256(0);
105     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 60000 * 10**DECIMALS;
106 
107     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
108 
109     uint256 private constant MAX_SUPPLY = ~uint128(0);
110 
111     uint256 private _totalSupply;
112     uint256 private _gonsPerFragment;
113     mapping(address => uint256) private _gonBalances;
114 
115     mapping (address => mapping (address => uint256)) private _allowedFragments;
116     
117 
118     function rebase(uint256 epoch, uint256 supplyDelta)
119         external
120         onlyOwner
121         returns (uint256)
122     {
123         if (supplyDelta == 0) {
124             emit LogRebase(epoch, _totalSupply);
125             return _totalSupply;
126         }
127 
128          _totalSupply = _totalSupply.sub(supplyDelta);
129 
130         
131         if (_totalSupply > MAX_SUPPLY) {
132             _totalSupply = MAX_SUPPLY;
133         }
134 
135         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
136 
137         emit LogRebase(epoch, _totalSupply);
138         return _totalSupply;
139     }
140 
141     constructor() public override {
142         _owner = msg.sender;
143         
144         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
145         _gonBalances[_owner] = TOTAL_GONS;
146         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
147 
148         emit Transfer(address(0x0), _owner, _totalSupply);
149     }
150 
151     function totalSupply()
152         public
153         view
154         returns (uint256)
155     {
156         return _totalSupply;
157     }
158 
159     function balanceOf(address who)
160         public
161         view
162         returns (uint256)
163     {
164         return _gonBalances[who].div(_gonsPerFragment);
165     }
166 
167     function transfer(address to, uint256 value)
168         public
169         validRecipient(to)
170         returns (bool)
171     {
172         uint256 gonValue = value.mul(_gonsPerFragment);
173         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
174         _gonBalances[to] = _gonBalances[to].add(gonValue);
175         emit Transfer(msg.sender, to, value);
176         return true;
177     }
178 
179     function allowance(address owner_, address spender)
180         public
181         view
182         returns (uint256)
183     {
184         return _allowedFragments[owner_][spender];
185     }
186 
187     function transferFrom(address from, address to, uint256 value)
188         public
189         validRecipient(to)
190         returns (bool)
191     {
192         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
193 
194         uint256 gonValue = value.mul(_gonsPerFragment);
195         _gonBalances[from] = _gonBalances[from].sub(gonValue);
196         _gonBalances[to] = _gonBalances[to].add(gonValue);
197         emit Transfer(from, to, value);
198 
199         return true;
200     }
201 
202     function approve(address spender, uint256 value)
203         public
204         returns (bool)
205     {
206         _allowedFragments[msg.sender][spender] = value;
207         emit Approval(msg.sender, spender, value);
208         return true;
209     }
210 
211     function increaseAllowance(address spender, uint256 addedValue)
212         public
213         returns (bool)
214     {
215         _allowedFragments[msg.sender][spender] =
216             _allowedFragments[msg.sender][spender].add(addedValue);
217         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
218         return true;
219     }
220 
221     function decreaseAllowance(address spender, uint256 subtractedValue)
222         public
223         returns (bool)
224     {
225         uint256 oldValue = _allowedFragments[msg.sender][spender];
226         if (subtractedValue >= oldValue) {
227             _allowedFragments[msg.sender][spender] = 0;
228         } else {
229             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
230         }
231         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
232         return true;
233     }
234 }