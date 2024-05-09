1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     
8     /**
9      * @dev Adds two numbers, reverts on overflow.
10     */
11     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
12         uint256 c = _a + _b;
13         require(c >= _a);
14 
15         return c;
16     }
17 
18     /**
19      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
20     */
21     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
22         require(_b <= _a);
23         uint256 c = _a - _b;
24 
25         return c;
26     }
27 
28     /**
29      * @dev Multiplies two numbers, reverts on overflow.
30     */
31     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
32         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33         // benefit is lost if 'b' is also tested.
34         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35         if (_a == 0) {
36             return 0;
37         }
38 
39         uint256 c = _a * _b;
40         require(c / _a == _b);
41 
42         return c;
43     }
44 
45     /**
46      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
47     */
48     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
49         require(_b > 0); // Solidity only automatically asserts when dividing by 0
50         uint256 c = _a / _b;
51         assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
52 
53         return c;
54     }
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // ERC Token Standard #20 Interface
60 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
61 // ----------------------------------------------------------------------------
62 contract ERC20Interface {
63     // function totalSupply() public constant returns (uint);
64     function balanceOf(address _owner) public constant returns (uint balance);
65     function transfer(address _to, uint _value) public returns (bool success);
66     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
67     function approve(address _spender, uint _value) public returns (bool success);
68     function allowance(address _owner, address _spender) public constant returns (uint remaining);
69 
70     event Transfer(address indexed _from, address indexed _to, uint _value);
71     event Approval(address indexed _owner, address indexed _spender, uint _value);
72 }
73 
74 // ----------------------------------------------------------------------------
75 // ERC20 Token
76 // ----------------------------------------------------------------------------
77 contract DXCToken is ERC20Interface {
78     using SafeMath for uint;
79 
80     string public symbol;
81     string public name;
82     uint8 public decimals;
83     uint public totalSupply;
84     address public owner;
85 
86     mapping(address => uint) private balances;
87     mapping(address => mapping(address => uint)) private allowed;
88 
89     event Burn(address indexed _from, uint256 _value);
90 
91     /**
92      * constructor
93      */
94     constructor(string _symbol, string _name, uint _totalSupply, uint8 _decimals, address _owner) public {
95         symbol = _symbol;
96         name = _name;
97         decimals = _decimals;
98         totalSupply = _totalSupply;
99         owner = _owner;
100         balances[_owner] = _totalSupply;
101 
102         emit Transfer(address(0), _owner, _totalSupply);
103     }
104 
105     /**
106      * @dev Gets the balance of the specified address.
107      * @param _owner The address to query the balance of.
108      * @return An uint256 representing the amount owned by the passed address.
109     */
110     function balanceOf(address _owner) public view returns (uint balance) {
111         return balances[_owner];
112     }
113 
114     /**
115      * @dev Transfer token from a specified address to another specified address
116      * @param _from The address to transfer from.
117      * @param _to The address to transfer to.
118      * @param _value The amount to be transferred.
119     */
120     function _transfer(address _from, address _to, uint _value) internal {
121         require(_to != 0x0);
122         require(balances[_from] >= _value);
123         require(balances[_to] + _value > balances[_to]);
124 
125         uint previousBalance = balances[_from].add(balances[_to]);
126 
127         balances[_from] = balances[_from].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129 
130         emit Transfer(_from, _to, _value);
131 
132         assert(balances[_from].add(balances[_to]) == previousBalance);
133     }
134 
135     /**
136      * @dev Transfer token for a specified address
137      * @param _to The address to transfer to.
138      * @param _value The amount to be transferred.
139     */
140     function transfer(address _to, uint _value) public returns (bool success) {
141         _transfer(msg.sender, _to, _value);
142 
143         return true;
144     }
145 
146     /**
147      * @dev Transfer tokens from one address to another
148      * @param _from address The address which you want to send tokens from
149      * @param _to address The address which you want to transfer to
150      * @param _value uint256 the amount of tokens to be transferred
151     */
152     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
153         
154         if (_from == msg.sender) {
155             _transfer(_from, _to, _value);
156 
157         } else {
158             require(allowed[_from][msg.sender] >= _value);
159             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160 
161             _transfer(_from, _to, _value);
162 
163         }
164 
165         return true;
166     }
167 
168     /**
169      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170      * Beware that changing an allowance with this method brings the risk that someone may use both the old
171      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      * @param _spender The address which will spend the funds.
175      * @param _value The amount of tokens to be spent.
176     */
177     function approve(address _spender, uint _value) public returns (bool success) {
178         allowed[msg.sender][_spender] = _value;
179 
180         emit Approval(msg.sender, _spender, _value);
181 
182         return true;
183     }
184 
185     /**
186      @dev burn amount of tokens
187      @param _value The amount of tokens to be burnt.
188      */
189     function burn(uint256 _value) public returns (bool success) {
190         // Check if the sender has enough
191         require(balances[msg.sender] >= _value);
192         require(_value > 0);
193 
194         // Subtract from the sender
195         balances[msg.sender] = balances[msg.sender].sub(_value);
196         // Updates totalSupply
197         totalSupply = totalSupply.sub(_value);
198 
199         emit Burn(msg.sender, _value);
200 
201         return true;
202     }
203 
204     /**
205      * @dev Function to check the amount of tokens that an owner allowed to a spender.
206      * @param _owner address The address which owns the funds.
207      * @param _spender address The address which will spend the funds.
208      * @return A uint256 specifying the amount of tokens still available for the spender.
209     */
210     function allowance(address _owner, address _spender) public view returns (uint remaining) {
211         return allowed[_owner][_spender];
212     }
213 
214     /**
215      * never receive Ether
216      */
217     function () public payable {
218         revert();
219     }
220 }