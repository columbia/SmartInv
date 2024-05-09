1 pragma solidity ^0.4.24;
2 
3 contract IToken {
4     uint256 public totalSupply;
5 
6     function balanceOf(address _owner) public constant returns (uint256 balance);
7 
8     function transfer(address _to, uint256 _value) public returns (bool success);
9 
10     function transferFrom(address _from, address _to, uint256 _value) public returns
11     (bool success);
12 
13     function approve(address _spender, uint256 _value) public returns (bool success);
14 
15     function allowance(address _owner, address _spender) public constant returns
16     (uint256 remaining);
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint256
20     _value);
21     event TransferFrom(address indexed _from, address indexed _to, uint256 _value);
22 }
23 
24 library SafeMath {
25     /**
26      * @dev Returns the addition of two unsigned integers, reverting on
27      * overflow.
28      *
29      * Counterpart to Solidity's `+` operator.
30      *
31      * Requirements:
32      * - Addition cannot overflow.
33      */
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     /**
42      * @dev Returns the subtraction of two unsigned integers, reverting on
43      * overflow (when the result is negative).
44      *
45      * Counterpart to Solidity's `-` operator.
46      *
47      * Requirements:
48      * - Subtraction cannot overflow.
49      */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         require(b <= a, "SafeMath: subtraction overflow");
52         uint256 c = a - b;
53 
54         return c;
55     }
56 
57     /**
58      * @dev Returns the multiplication of two unsigned integers, reverting on
59      * overflow.
60      *
61      * Counterpart to Solidity's `*` operator.
62      *
63      * Requirements:
64      * - Multiplication cannot overflow.
65      */
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
68         // benefit is lost if 'b' is also tested.
69         if (a == 0) {
70             return 0;
71         }
72 
73         uint256 c = a * b;
74         require(c / a == b, "SafeMath: multiplication overflow");
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the integer division of two unsigned integers. Reverts on
81      * division by zero. The result is rounded towards zero.
82      *
83      * Counterpart to Solidity's `/` operator. Note: this function uses a
84      * `revert` opcode (which leaves remaining gas untouched) while Solidity
85      * uses an invalid opcode to revert (consuming all remaining gas).
86      *
87      * Requirements:
88      * - The divisor cannot be zero.
89      */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         // Solidity only automatically asserts when dividing by 0
92         require(b > 0, "SafeMath: division by zero");
93         uint256 c = a / b;
94         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
101      * Reverts when dividing by zero.
102      *
103      * Counterpart to Solidity's `%` operator. This function uses a `revert`
104      * opcode (which leaves remaining gas untouched) while Solidity uses an
105      * invalid opcode to revert (consuming all remaining gas).
106      *
107      * Requirements:
108      * - The divisor cannot be zero.
109      */
110     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
111         require(b != 0, "SafeMath: modulo by zero");
112         return a % b;
113     }
114 }
115 
116 
117 contract ERC20Token is IToken {
118     using SafeMath for uint256;
119     string public name;
120     uint8 public decimals;
121     string public symbol;
122 
123     mapping(address => uint256) balances;
124     mapping(address => mapping(address => uint256)) allowed;
125 
126 
127     address private owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     function CurrentOwner() public view returns (address){
132         return owner;
133     }
134 
135     // 
136     modifier onlyOwner(){
137         require(msg.sender == owner, "Ownable: caller is not the owner");
138         _;
139     }
140     /**
141     * @dev Transfers ownership of the contract to a new account (`newOwner`).
142     * Can only be called by the current owner.
143     */
144     function transferOwnership(address newOwner) public onlyOwner {
145         require(newOwner != address(0), "Ownable: new owner is the zero address");
146         emit OwnershipTransferred(owner, newOwner);
147         owner = newOwner;
148     }
149 
150     constructor(string _tokenName, string _tokenSymbol, uint8 _decimalUnits, uint256 _initialAmount) public {
151         owner = msg.sender;
152         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);
153         balances[msg.sender] = totalSupply;
154         name = _tokenName;
155         decimals = _decimalUnits;
156         symbol = _tokenSymbol;
157         emit Transfer( address(0),owner, totalSupply);
158     }
159 
160     function transfer(address _to, uint256 _value) public returns (bool success) {
161         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
162         require(_to != 0x0);
163         balances[msg.sender] = balances[msg.sender].sub(_value);
164         balances[_to] = balances[_to].add(_value);
165         emit Transfer(msg.sender, _to, _value);
166         return true;
167     }
168 
169 
170     function transferFrom(address _from, address _to, uint256 _value) public returns
171     (bool success) {
172         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
173         balances[_to] = balances[_to].add(_value);
174         balances[_from] = balances[_from].sub(_value);
175         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
176         emit Transfer(_from, _to, _value);
177         return true;
178     }
179 
180     function balanceOf(address _owner) public constant returns (uint256 balance) {
181         return balances[_owner];
182     }
183 
184 
185     function approve(address _spender, uint256 _value) public returns (bool success)
186     {
187         allowed[msg.sender][_spender] = _value;
188         emit Approval(msg.sender, _spender, _value);
189         return true;
190     }
191 
192     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
193         return allowed[_owner][_spender];
194     }
195 
196     function burn(address account, uint256 value) public onlyOwner {
197         require(account != address(0), "ERC20: burn from the zero address");
198 
199         totalSupply = totalSupply.sub(value);
200         balances[account] = balances[account].sub(value);
201         emit Transfer(account, address(0), value);
202     }
203 
204     function transferArray(address[] memory _to, uint256[] memory _value) public {
205         require(_to.length == _value.length);
206         uint256 sum = 0;
207         for (uint256 i = 0; i < _value.length; i++) {
208             sum = sum.add(_value[i]);
209         }
210         require(balanceOf(msg.sender) >= sum);
211         for (uint256 k = 0; k < _to.length; k++) {
212             transfer(_to[k], _value[k]);
213         }
214     }
215 
216 }