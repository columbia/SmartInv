1 pragma solidity ^0.4.22;
2 
3 /**
4 *  ** SAFEMATH **
5 */
6 
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12 
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 /**
55 *  ** INTERFACES **
56 */
57 
58 interface ERC20 {
59     function transferFrom(address _from, address _to, uint _value) public returns (bool);
60     function approve(address _spender, uint _value) public returns (bool);
61     function allowance(address _owner, address _spender) public view returns (uint);
62     event Approval(address indexed _owner, address indexed _spender, uint _value);
63 }
64 
65 contract ERC223ReceivingContract {
66     function tokenFallback(address _from, uint _value, bytes _data) public;
67 }
68 
69 interface ERC223 {
70     function transfer(address _to, uint _value, bytes _data) public returns (bool);
71     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
72 }
73 
74 contract FoundationToken {
75     string internal _symbol;
76     string internal _name;
77     uint8 internal _decimals;
78     uint internal _totalSupply = 1000;
79     mapping (address => uint) internal _balanceOf;
80     mapping (address => mapping (address => uint)) internal _allowances;
81     
82     constructor(string symbol, string name, uint8 decimals) public {
83         _symbol = symbol;
84         _name = name;
85         _decimals = decimals;
86         _totalSupply = 1000*1000000 * (uint256(10) ** decimals);
87     }
88     
89     function name() public view returns (string) {
90         return _name;
91     }
92     
93     function symbol() public view returns (string) {
94         return _symbol;
95     }
96     
97     function decimals() public view returns (uint8) {
98         return _decimals;
99     }
100     
101     function totalSupply() public view returns (uint) {
102         return _totalSupply;
103     }
104     
105     function balanceOf(address _addr) public view returns (uint);
106 
107     // @notice send `_value` token to `_to` from `msg.sender`
108     // @param _to The address of the recipient
109     // @param _value The amount of token to be transferred
110     // @return Whether the transfer was successful or not
111     function transfer(address _to, uint _value) public returns (bool);
112     event Transfer(address indexed _from, address indexed _to, uint _value);
113 }
114 
115 contract ShapeCoin is FoundationToken("SHPC", "ShapeCoin", 18), ERC20, ERC223 {
116 
117     using SafeMath for uint;
118 
119     constructor() public {
120         _balanceOf[msg.sender] = _totalSupply;
121     }
122 
123     function totalSupply() public view returns (uint) {
124         return _totalSupply;
125     }
126 
127     function balanceOf(address _addr) public view returns (uint) {
128         return _balanceOf[_addr];
129     }
130 
131     /**
132      *  ** FOR ADDRESSES **
133      *
134      * @dev Transfer the specified amount of tokens to the specified address.
135      *      This function works the same with the previous one
136      *      but doesn't contain `_data` param.
137      *      Added due to backwards compatibility reasons.
138      *
139      *  @param _to    Receiver address.
140      *  @param _value Amount of tokens that will be transferred.
141      *  @return Whether the transfer was successful or not
142      */
143 
144     function transfer(address _to, uint _value) public returns (bool) {
145         if (_value > 0 && _value <= _balanceOf[msg.sender] && !isContract(_to)) {
146             _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
147             _balanceOf[_to] = _balanceOf[_to].add(_value);
148             emit Transfer(msg.sender, _to, _value);
149             return true;
150         }
151         return false;
152     }
153 
154     /**
155      *  ** FOR CONTRACTS **
156      *
157      *  @dev Transfer the specified amount of tokens to the specified address.
158      *      Invokes the `tokenFallback` function if the recipient is a contract.
159      *      The token transfer fails if the recipient is a contract
160      *      but does not implement the `tokenFallback` function
161      *      or the fallback function to receive funds.
162      *
163      *  @notice send `_value` token to `_to` from `msg.sender`
164      *  @param _to The address of the recipient
165      *  @param _value The amount of token to be transferred
166      *  @param _data The data to be passed to our contract that we are actually going to allow to have data passed to
167      *  @return Whether the transfer was successful or not
168      */
169     
170     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
171         if (_value > 0 && _value <= _balanceOf[msg.sender] && isContract(_to)) {
172             _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
173             _balanceOf[_to] = _balanceOf[_to].add(_value);
174             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
175             _contract.tokenFallback(msg.sender, _value, _data);
176             emit Transfer(msg.sender, _to, _value, _data);
177             return true;
178         }
179         return false;
180     }
181 
182     function isContract(address _addr) private view returns (bool) {
183         uint codeSize;
184         /* solium-disable */
185         assembly {
186             codeSize := extcodesize(_addr)
187         }
188         /* solium-enable */
189         return codeSize > 0;
190     }
191 
192     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
193         if (_allowances[_from][msg.sender] > 0 &&
194             _value > 0 &&
195             _allowances[_from][msg.sender] >= _value &&
196             _balanceOf[_from] >= _value) {
197             _balanceOf[_from] = _balanceOf[_from].sub(_value);
198             _balanceOf[_to] = _balanceOf[_to].add(_value);
199             _allowances[_from][msg.sender] -= _value;
200             emit Transfer(_from, _to, _value);
201             return true;
202         }
203         return false;
204     }
205 
206     function approve(address _spender, uint _value) public returns (bool) {
207         _allowances[msg.sender][_spender] = _value;
208         emit Approval(msg.sender, _spender, _value);
209         return true;
210     }
211 
212     function allowance(address _owner, address _spender) public constant returns (uint) {
213         return _allowances[_owner][_spender];
214     }
215 }