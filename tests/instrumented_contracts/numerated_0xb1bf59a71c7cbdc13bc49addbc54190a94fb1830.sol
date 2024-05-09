1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.14;
4 
5 contract ERC20Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) constant returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
51 ///  later changed
52 contract Owned {
53     /// @dev `owner` is the only address that can call a function with this
54     /// modifier
55     modifier onlyOwner() {
56         require(msg.sender == owner) ;
57         _;
58     }
59 
60     address public owner;
61 
62     /// @notice The Constructor assigns the message sender to be `owner`
63     function Owned() {
64         owner = msg.sender;
65     }
66 
67     /**
68     * @dev Allows the current owner to transfer control of the contract to a newOwner.
69     * @param _newOwner The address to transfer ownership to.
70     */
71     function transferOwnership(address _newOwner) onlyOwner {
72         if (_newOwner != address(0)) {
73             owner = _newOwner;
74         }
75     }
76 
77 }
78 
79 contract SafeMath {
80     function add(uint x, uint y) internal constant returns (uint z) {
81         require((z = x + y) >= x);
82     }
83     function sub(uint x, uint y) internal constant returns (uint z) {
84         require((z = x - y) <= x);
85     }
86     function mul(uint x, uint y) internal constant returns (uint z) {
87         require(y == 0 || (z = x * y) / y == x);
88     }
89 
90     function min(uint x, uint y) internal constant returns (uint z) {
91         return x <= y ? x : y;
92     }
93     function max(uint x, uint y) internal constant returns (uint z) {
94         return x >= y ? x : y;
95     }
96     function imin(int x, int y) internal constant returns (int z) {
97         return x <= y ? x : y;
98     }
99     function imax(int x, int y) internal constant returns (int z) {
100         return x >= y ? x : y;
101     }
102 
103     uint constant WAD = 10 ** 18;
104     uint constant RAY = 10 ** 27;
105 
106     function wmul(uint x, uint y) internal constant returns (uint z) {
107         z = add(mul(x, y), WAD / 2) / WAD;
108     }
109     function rmul(uint x, uint y) internal constant returns (uint z) {
110         z = add(mul(x, y), RAY / 2) / RAY;
111     }
112     function wdiv(uint x, uint y) internal constant returns (uint z) {
113         z = add(mul(x, WAD), y / 2) / y;
114     }
115     function rdiv(uint x, uint y) internal constant returns (uint z) {
116         z = add(mul(x, RAY), y / 2) / y;
117     }
118 
119     // This famous algorithm is called "exponentiation by squaring"
120     // and calculates x^n with x as fixed-point and n as regular unsigned.
121     //
122     // It's O(log n), instead of O(n) for naive repeated multiplication.
123     //
124     // These facts are why it works:
125     //
126     //  If n is even, then x^n = (x^2)^(n/2).
127     //  If n is odd,  then x^n = x * x^(n-1),
128     //   and applying the equation for even x gives
129     //    x^n = x * (x^2)^((n-1) / 2).
130     //
131     //  Also, EVM division is flooring and
132     //    floor[(n-1) / 2] = floor[n / 2].
133     //
134     function rpow(uint x, uint n) internal constant returns (uint z) {
135         z = n % 2 != 0 ? x : RAY;
136 
137         for (n /= 2; n != 0; n /= 2) {
138             x = rmul(x, x);
139 
140             if (n % 2 != 0) {
141                 z = rmul(z, x);
142             }
143         }
144     }
145 }
146 
147 /*  ERC 20 token */
148 contract StandardToken is ERC20Token {
149     function transfer(address _to, uint256 _value) returns (bool success) {
150         if (balances[msg.sender] >= _value && _value > 0) {
151             balances[msg.sender] -= _value;
152             balances[_to] += _value;
153             Transfer(msg.sender, _to, _value);
154             return true;
155         } else {
156             return false;
157         }
158     }
159 
160     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
161         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
162             balances[_to] += _value;
163             balances[_from] -= _value;
164             allowed[_from][msg.sender] -= _value;
165             Transfer(_from, _to, _value);
166             return true;
167         } else {
168             return false;
169         }
170     }
171 
172     function balanceOf(address _owner) constant returns (uint256 balance) {
173         return balances[_owner];
174     }
175 
176     function approve(address _spender, uint256 _value) returns (bool success) {
177         // To change the approve amount you first have to reduce the addresses`
178         //  allowance to zero by calling `approve(_spender,0)` if it is not
179         //  already 0 to mitigate the race condition described here:
180         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181         require ((_value==0) || (allowed[msg.sender][_spender] ==0));
182 
183         allowed[msg.sender][_spender] = _value;
184         Approval(msg.sender, _spender, _value);
185         return true;
186     }
187 
188     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
189         return allowed[_owner][_spender];
190     }
191 
192     mapping (address => uint256) public balances;
193     mapping (address => mapping (address => uint256)) allowed;
194 }
195 
196 contract LSTToken is StandardToken, Owned {
197     // metadata
198     string public constant name = "LIVESHOW Token";
199     string public constant symbol = "LST";
200     string public version = "1.0";
201     uint256 public constant decimals = 18;
202     uint256 public constant MILLION = (10**6 * 10**decimals);
203     bool public disabled;
204     // constructor
205     function LSTToken() {
206         uint _amount = 100 * MILLION;
207         totalSupply = _amount; 
208         balances[msg.sender] = _amount;
209     }
210 
211     function getTotalSupply() external constant returns(uint256) {
212         return totalSupply;
213     }
214 
215     function setDisabled(bool flag) external onlyOwner {
216         disabled = flag;
217     }
218 
219     function transfer(address _to, uint256 _value) returns (bool success) {
220         require(!disabled);
221         return super.transfer(_to, _value);
222     }
223 
224     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
225         require(!disabled);
226         return super.transferFrom(_from, _to, _value);
227     }
228     function kill() onlyOwner {
229         selfdestruct(owner);
230     }
231 }