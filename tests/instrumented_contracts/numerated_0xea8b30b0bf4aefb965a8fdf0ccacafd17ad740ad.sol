1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract Owned {
23     address public owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     constructor() public {
28         owner = msg.sender;
29     }
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function transferOwnership(address newOwner) public onlyOwner {
37         require(newOwner != address(0));
38         emit OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41 }
42 
43 contract ERC20 {
44     function totalSupply() public view returns (uint);
45     function balanceOf(address tokenOwner) public view returns (uint balance);
46     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     event Transfer(address indexed from, address indexed to, uint tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
53 }
54 
55 contract StandardToken is ERC20 {
56     using SafeMath for uint;
57 
58     string public name;
59     string public symbol;
60     uint8 public decimals;
61     uint public totalSupply;
62 
63     mapping(address => uint) internal balances;
64     mapping (address => mapping (address => uint)) internal allowed;
65 
66     constructor(string _name, string _symbol, uint8 _decimals, uint _totalSupply) public {
67         name = _name;
68         symbol = _symbol;
69         decimals = _decimals;
70         totalSupply = _totalSupply;
71         balances[msg.sender] = _totalSupply;
72         emit Transfer(address(0), msg.sender, _totalSupply);
73     }
74 
75     function totalSupply() public view returns (uint) {
76         return totalSupply;
77     }
78 
79     function balanceOf(address _owner) public view returns (uint) {
80         return balances[_owner];
81     }
82 
83     function allowance(address _owner, address _spender) public view returns (uint) {
84         return allowed[_owner][_spender];
85     }
86 
87     function transfer(address _to, uint _value) public returns (bool) {
88         require(_to != address(0));
89         require(_value <= balances[msg.sender]);
90 
91         balances[msg.sender] = balances[msg.sender].sub(_value);
92         balances[_to] = balances[_to].add(_value);
93         emit Transfer(msg.sender, _to, _value);
94         return true;
95     }
96 
97     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
98         require(_to != address(0));
99         require(_value <= balances[_from]);
100         require(_value <= allowed[_from][msg.sender]);
101 
102         balances[_from] = balances[_from].sub(_value);
103         balances[_to] = balances[_to].add(_value);
104         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
105         emit Transfer(_from, _to, _value);
106         return true;
107     }
108 
109     function approve(address _spender, uint _value) public returns (bool) {
110         allowed[msg.sender][_spender] = _value;
111         emit Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115 }
116 
117 /**
118  * @title SwissBorg Referendum 2
119  * @dev Hardcoded version with exactly 6 voting addresses.
120  */
121 contract VotingToken is StandardToken, Owned {
122     using SafeMath for uint;
123 
124     uint public constant numberOfAlternatives = 6;
125 
126     event Reward(address indexed to, uint amount);
127     event Result(address indexed votingAddress, uint amount);
128 
129     ERC20 private rewardToken;
130 
131     bool public opened;
132     bool public closed;
133 
134     address[numberOfAlternatives] public votingAddresses;
135 
136     // ~~~~~ Constructor ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
137 
138     constructor(
139         string _name,
140         string _symbol,
141         uint8 _decimals,
142         ERC20 _rewardToken,
143         address[numberOfAlternatives] _votingAddresses
144     ) public StandardToken(_name, _symbol, _decimals, 0) {
145         require(_votingAddresses.length == numberOfAlternatives);
146         rewardToken = _rewardToken;
147         votingAddresses = _votingAddresses;
148     }
149 
150     // ~~~~~ Public Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
151 
152     function transfer(address _to, uint _value) public returns (bool) {
153         require(super.transfer(_to, _value));
154         _rewardVote(msg.sender, _to, _value);
155         return true;
156     }
157 
158     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
159         require(super.transferFrom(_from, _to, _value));
160         _rewardVote(_from, _to, _value);
161         return true;
162     }
163 
164     // Refuse ETH
165     function () public payable {
166         revert();
167     }
168 
169     // ~~~~~ Admin Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
170 
171     function mint(address _to, uint _amount) onlyOwner external returns (bool) {
172         require(!opened);
173         totalSupply = totalSupply.add(_amount);
174         balances[_to] = balances[_to].add(_amount);
175         emit Transfer(address(0), _to, _amount);
176         return true;
177     }
178 
179     function batchMint(address[] _tos, uint[] _amounts) onlyOwner external returns (bool) {
180         require(!opened);
181         require(_tos.length == _amounts.length);
182         uint sum = 0;
183         for (uint i = 0; i < _tos.length; i++) {
184             address to = _tos[i];
185             uint amount = _amounts[i];
186             sum = sum.add(amount);
187             balances[to] = balances[to].add(amount);
188             emit Transfer(address(0), to, amount);
189         }
190         totalSupply = totalSupply.add(sum);
191         return true;
192     }
193 
194     function open() onlyOwner external {
195         require(!opened);
196         opened = true;
197     }
198 
199     function close() onlyOwner external {
200         require(opened && !closed);
201         closed = true;
202     }
203 
204     function destroy(address[] tokens) onlyOwner external {
205 
206         // Transfer tokens to owner
207         for (uint i = 0; i < tokens.length; i++) {
208             ERC20 token = ERC20(tokens[i]);
209             uint balance = token.balanceOf(this);
210             token.transfer(owner, balance);
211         }
212 
213         for (uint j = 0; j < numberOfAlternatives; j++) {
214             address votingAddress = votingAddresses[j];
215             uint votes = balances[votingAddress];
216             emit Result(votingAddress, votes);
217         }
218 
219         // Transfer Eth to owner and terminate contract
220         selfdestruct(owner);
221     }
222 
223     // ~~~~~ Private Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
224 
225     function _rewardVote(address _from, address _to, uint _value) private {
226         if(_isVotingAddress(_to)) {
227             require(opened && !closed);
228             uint rewardTokens = _value.div(100);
229             require(rewardToken.transfer(_from, rewardTokens));
230             emit Reward(_from, _value);
231         }
232     }
233 
234     function _isVotingAddress(address votingAddress) private view returns (bool) {
235         for (uint i = 0; i < numberOfAlternatives; i++) {
236             if (votingAddresses[i] == votingAddress) return true;
237         }
238         return false;
239     }
240 
241 }