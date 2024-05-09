1 pragma solidity 0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract ERC20Basic {
33     function totalSupply() public view returns (uint256);
34     function balanceOf(address who) public view returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40     function allowance(address owner, address spender) public view returns (uint256);
41     function transferFrom(address from, address to, uint256 value) public returns (bool);
42     function approve(address spender, uint256 value) public returns (bool);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 library SafeERC20 {
47     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
48         assert(token.transfer(to, value));
49     }
50 
51     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
52         assert(token.transferFrom(from, to, value));
53     }
54 
55     function safeApprove(ERC20 token, address spender, uint256 value) internal {
56         assert(token.approve(spender, value));
57     }
58 }
59 
60 contract BasicToken is ERC20Basic {
61     using SafeMath for uint256;
62 
63     mapping(address => uint256) balances;
64 
65     uint256 totalSupply_;
66 
67     function totalSupply() public view returns (uint256) {
68         return totalSupply_;
69     }
70 
71     function transfer(address _to, uint256 _value) public returns (bool) {
72         require(_to != address(0));
73         require(_value <= balances[msg.sender]);
74 
75         // SafeMath.sub will throw if there is not enough balance.
76         balances[msg.sender] = balances[msg.sender].sub(_value);
77         balances[_to] = balances[_to].add(_value);
78         Transfer(msg.sender, _to, _value);
79         return true;
80     }
81 
82     function balanceOf(address _owner) public view returns (uint256 balance) {
83         return balances[_owner];
84     }
85 }
86 
87 contract StandardToken is ERC20, BasicToken {
88     mapping (address => mapping (address => uint256)) internal allowed;
89 
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
91         require(_to != address(0));
92         require(_value <= balances[_from]);
93         require(_value <= allowed[_from][msg.sender]);
94 
95         balances[_from] = balances[_from].sub(_value);
96         balances[_to] = balances[_to].add(_value);
97         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98         Transfer(_from, _to, _value);
99         return true;
100     }
101 
102     function approve(address _spender, uint256 _value) public returns (bool) {
103         allowed[msg.sender][_spender] = _value;
104         Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 
108     function allowance(address _owner, address _spender) public view returns (uint256) {
109         return allowed[_owner][_spender];
110     }
111 
112     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
113         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
114         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115         return true;
116     }
117 
118     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
119         uint oldValue = allowed[msg.sender][_spender];
120         if (_subtractedValue > oldValue) {
121             allowed[msg.sender][_spender] = 0;
122         } else {
123             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
124         }
125         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126         return true;
127     }
128 }
129 
130 contract Ownable {
131     address public owner;
132 
133     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
134 
135     function Ownable() public {
136         owner = msg.sender;
137     }
138 
139     modifier onlyOwner() {
140         require(msg.sender == owner);
141         _;
142     }
143 
144     function transferOwnership(address newOwner) public onlyOwner {
145         require(newOwner != address(0));
146         OwnershipTransferred(owner, newOwner);
147         owner = newOwner;
148     }
149 }
150 
151 contract HasNoEther is Ownable {
152     function HasNoEther() public payable {
153         require(msg.value == 0);
154     }
155 
156     function() external {
157     }
158 
159     function reclaimEther() external onlyOwner {
160         assert(owner.send(this.balance));
161     }
162 }
163 
164 contract CanReclaimToken is Ownable {
165     using SafeERC20 for ERC20Basic;
166 
167     function reclaimToken(ERC20Basic token) external onlyOwner {
168         uint256 balance = token.balanceOf(this);
169         token.safeTransfer(owner, balance);
170     }
171 
172 }
173 
174 contract HasNoTokens is CanReclaimToken {
175     function tokenFallback(address from_, uint256 value_, bytes data_) external {
176         from_;
177         value_;
178         data_;
179         revert();
180     }
181 
182 }
183 
184 contract HasNoContracts is Ownable {
185     function reclaimContract(address contractAddr) external onlyOwner {
186         Ownable contractInst = Ownable(contractAddr);
187         contractInst.transferOwnership(owner);
188     }
189 }
190 
191 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
192 }
193 
194 contract FTC is StandardToken, NoOwner {
195     string public constant name = "FTC token";
196     string public constant symbol = "FTC";
197     uint8 public constant decimals = 18;
198 
199     function FTC()
200     public
201     {
202         address _account = 0x38e2bF0106da7bE34C8339c7d964B392c43349cE;
203         uint256 _amount = 1000000000 * 1 ether; // 1 000 000 000 * 10e18
204 
205         totalSupply_ = _amount;
206         balances[_account] = _amount;
207 
208         emit Transfer(address(0), _account, _amount);
209     }
210 }