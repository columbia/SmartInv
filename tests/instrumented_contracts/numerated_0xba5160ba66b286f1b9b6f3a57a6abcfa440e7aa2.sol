1 pragma solidity ^0.4.25;
2 
3 
4 /** https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9     /**
10     * @dev Multiplies two unsigned integers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49     * @dev Adds two unsigned integers, reverts on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 }
58 
59 contract THB {
60     using SafeMath for uint256;
61 
62     string public name;
63     string public symbol;
64     uint8 public decimals;
65     uint256 public totalSupply;
66 
67     address owner;
68     address[] admin_addrs;
69     uint256[] admin_as;
70     uint256 admin_needa;
71     mapping(address => mapping(uint256 => uint256)) admin_tran_as;
72     mapping(address => mapping(uint256 => address[])) admin_tran_addrs;
73 
74     mapping(address => uint256)  balances;
75     mapping(address => mapping(address => uint256)) _allowed;
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79     event Burn(address indexed from, uint256 value);
80     event PreTransfer(address _admin, uint256 _lastas, address indexed _to, uint256 _value);
81 
82     constructor (uint256 _initialSupply, string _name, string _symbol,
83         address[] _admin_addrs, uint256[] _admin_as, uint256 _admin_needa) public {
84         balances[msg.sender] = _initialSupply;
85         owner = msg.sender;
86         totalSupply = _initialSupply;
87         name = _name;
88         symbol = _symbol;
89         decimals = 18;
90         require(_admin_addrs.length > 0 && _admin_addrs.length == _admin_as.length);
91         require(_admin_needa >= 1);
92         for (uint i = 0; i < _admin_addrs.length; i++) {
93             require(_admin_addrs[i] != address(0));
94         }
95         for (i = 0; i < _admin_as.length; i++) {
96             require(_admin_as[i] >= 1);
97         }
98         admin_addrs = _admin_addrs;
99         admin_as = _admin_as;
100         admin_needa = _admin_needa;
101     }
102 
103     function balanceOf(address _owner) public view returns (uint256 balance) {
104         return balances[_owner];
105     }
106 
107     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
108         return _allowed[_owner][_spender];
109     }
110 
111     function transfer(address _to, uint256 _value) public returns (bool success) {
112         require(_to != address(0));
113         require(msg.sender != owner);
114         require(_value > 0);
115         require(balances[msg.sender] >= _value);
116         require(balances[_to] + _value >= balances[_to]);
117         balances[msg.sender] = balances[msg.sender].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         emit Transfer(msg.sender, _to, _value);
120         return true;
121     }
122 
123     function transfer_admin(address _to, uint256 _value) public returns (bool success) {
124         require(_to != address(0));
125         require(_to != owner);
126         require(_value > 0);
127 
128         uint256 _msgsendas = 0;
129         for (uint i = 0; i < admin_addrs.length; i++) {
130             if (admin_addrs[i] == msg.sender) {
131                 _msgsendas = admin_as[i];
132                 break;
133             }
134         }
135         require(_msgsendas > 0);
136 
137         for (i = 0; i < admin_tran_addrs[_to][_value].length; i++) {
138             require(admin_tran_addrs[_to][_value][i] != msg.sender);
139         }
140 
141         uint256 _curr_as = admin_tran_as[_to][_value];
142 
143         if (_curr_as < admin_needa) {
144             _curr_as = _curr_as.add(_msgsendas);
145             if (_curr_as < admin_needa) {
146                 admin_tran_as[_to][_value] = _curr_as;
147                 admin_tran_addrs[_to][_value].push(msg.sender);
148                 emit PreTransfer(msg.sender, _curr_as, _to, _value);
149                 return true;
150             }
151             return transfer_admin_f(_to, _value);
152         }
153         // error
154         require(false);
155     }
156 
157     function transfer_admin_f(address _to, uint256 _value) internal returns (bool success) {
158         require(balances[owner] >= _value);
159         require(balances[_to] + _value >= balances[_to]);
160         admin_tran_as[_to][_value] = 0;
161         admin_tran_addrs[_to][_value] = new address[](0);
162         balances[owner] = balances[owner].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         emit Transfer(owner, _to, _value);
165         return true;
166     }
167 
168     /** https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol#L62
169      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170      * Beware that changing an allowance with this method brings the risk that someone may use both the old
171      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      * @param spender The address which will spend the funds.
175      * @param value The amount of tokens to be spent.
176      */
177     function approve(address spender, uint256 value) public returns (bool) {
178         require(spender != address(0));
179 
180         _allowed[msg.sender][spender] = value;
181         emit Approval(msg.sender, spender, value);
182         return true;
183     }
184 
185     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
186         require(_to != address(0));
187         require(_from != owner);
188         require(_value > 0);
189         uint256 _allow = _allowed[_from][msg.sender];
190         require(_value <= _allow);
191         require(balances[_from] >= _value);
192         require(balances[_to] + _value >= balances[_to]);
193 
194         balances[_from] = balances[_from].sub(_value);
195         _allowed[_from][msg.sender] = _allow.sub(_value);
196         balances[_to] = balances[_to].add(_value);
197 
198         emit Transfer(_from, _to, _value);
199         return true;
200     }
201 
202     /** https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol#L94
203      * @dev Increase the amount of tokens that an owner allowed to a spender.
204      * approve should be called when allowed_[_spender] == 0. To increment
205      * allowed value is better to use this function to avoid 2 calls (and wait until
206      * the first transaction is mined)
207      * From MonolithDAO Token.sol
208      * Emits an Approval event.
209      * @param spender The address which will spend the funds.
210      * @param addedValue The amount of tokens to increase the allowance by.
211      */
212     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
213         require(spender != address(0));
214 
215         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
216         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
217         return true;
218     }
219 
220     /** https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol#L122
221      * @dev Decrease the amount of tokens that an owner allowed to a spender.
222      * approve should be called when allowed_[_spender] == 0. To decrement
223      * allowed value is better to use this function to avoid 2 calls (and wait until
224      * the first transaction is mined)
225      * From MonolithDAO Token.sol
226      * Emits an Approval event.
227      * @param spender The address which will spend the funds.
228      * @param subtractedValue The amount of tokens to decrease the allowance by.
229      */
230     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
231         require(spender != address(0));
232 
233         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
234         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
235         return true;
236     }
237 
238 
239     function burn(uint256 _value) public returns (bool success) {
240         require(_value > 0);
241         require(msg.sender != owner);
242         require(balances[msg.sender] >= _value);
243         balances[msg.sender] = balances[msg.sender].sub(_value);
244         totalSupply = totalSupply.sub(_value);
245         emit Burn(msg.sender, _value);
246         return true;
247     }
248 
249     function withdrawEther(uint256 amount) public {
250         require(msg.sender == owner);
251         owner.transfer(amount);
252     }
253 
254     function() public payable {
255     }
256 }