1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
6         require(b <= a, "SafeMath sub failed");
7         return a - b;
8     }
9 
10     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         c = a + b;
12         require(c >= a, "SafeMath add failed");
13         return c;
14     }
15 }
16 
17 interface tokenRecipient { 
18     function receiveApproval(address _from, uint _value, address _token, bytes _extraData) external; 
19 }
20 
21 contract WaConfig {
22     using SafeMath for uint;
23 
24     string internal constant TOKEN_NAME     = "Wa Token";
25     string internal constant TOKEN_SYMBOL   = "WA";
26     uint8  internal constant TOKEN_DECIMALS = 18;
27     uint   internal constant INITIAL_SUPPLY = 100*1e8 * 10 ** uint(TOKEN_DECIMALS);
28 }
29 
30 contract Ownable is WaConfig {
31     address public ceo;
32     
33     event LogChangeCEO(address indexed oldOwner, address indexed newOwner);
34     
35     modifier onlyOwner {
36         require(msg.sender == ceo);
37         _;
38     }
39     
40     constructor() public {
41         ceo = msg.sender;
42     }
43     
44     function changeCEO(address _owner) onlyOwner public returns (bool) {
45         require(_owner != address(0));
46         
47         emit LogChangeCEO(ceo, _owner);
48         ceo = _owner;
49         
50         return true;
51     }
52 
53     function isOwner(address _owner) internal view returns (bool) {
54         return ceo == _owner;
55     }
56 }
57 
58 contract Lockable is Ownable {
59     mapping (address => bool) public locked;
60     
61     event LogLockup(address indexed target);
62     
63     function lockup(address _target) onlyOwner public returns (bool) {
64 	    require( !isOwner(_target) );
65 
66         locked[_target] = true;
67         emit LogLockup(_target);
68         return true;
69     }
70     
71     function isLockup(address _target) internal view returns (bool) {
72         if(true == locked[_target])
73             return true;
74     }
75 }
76 
77 contract TokenERC20 {
78     using SafeMath for uint;
79     
80     string public name;
81     string public symbol;
82     uint8 public decimals;
83     uint public totalSupply;
84     
85     mapping (address => uint) public balanceOf;
86     mapping (address => mapping (address => uint)) public allowance;
87 
88     event ERC20Token(address indexed owner, string name, string symbol, uint8 decimals, uint supply);
89     event Transfer(address indexed from, address indexed to, uint value);
90     event TransferFrom(address indexed from, address indexed to, address indexed spender, uint value);
91     event Approval(address indexed owner, address indexed spender, uint value);
92     
93     constructor(
94         string _tokenName,
95         string _tokenSymbol,
96         uint8 _tokenDecimals,
97         uint _initialSupply
98     ) public {
99         name = _tokenName;
100         symbol = _tokenSymbol;
101         decimals = _tokenDecimals;
102         totalSupply = _initialSupply;
103         
104         balanceOf[msg.sender] = totalSupply;
105         
106         emit ERC20Token(msg.sender, name, symbol, decimals, totalSupply);
107     }
108 
109     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
110         require(_to != address(0));
111         require(balanceOf[_from] >= _value);
112         require(SafeMath.add(balanceOf[_to], _value) > balanceOf[_to]);
113         
114         uint previousBalances = SafeMath.add(balanceOf[_from], balanceOf[_to]);
115         balanceOf[_from] = balanceOf[_from].sub(_value);
116         balanceOf[_to] = balanceOf[_to].add(_value);
117         
118         emit Transfer(_from, _to, _value);
119         
120         assert(SafeMath.add(balanceOf[_from], balanceOf[_to]) == previousBalances);
121         return true;
122     }
123     
124     function transfer(address _to, uint _value) public returns (bool) {
125         return _transfer(msg.sender, _to, _value);
126     }
127 
128     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
129         require(_value <= allowance[_from][msg.sender]);
130         
131         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
132         _transfer(_from, _to, _value);
133         
134         emit TransferFrom(_from, _to, msg.sender, _value);
135         return true;
136     }
137 
138     function approve(address _spender, uint _value) public returns (bool) {
139         allowance[msg.sender][_spender] = _value;
140         
141         emit Approval(msg.sender, _spender, _value);
142         return true;
143     }
144 
145     function allowance(address _owner, address _spender) public view returns (uint) {
146         return allowance[_owner][_spender];
147     }
148 
149     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool) {
150         tokenRecipient spender = tokenRecipient(_spender);
151         if (approve(_spender, _value)) {
152             spender.receiveApproval(msg.sender, _value, this, _extraData);
153             return true;
154         }
155     }
156 }
157 
158 contract WaToken is Lockable, TokenERC20 {
159     string public version = "v1.0.2";
160     
161     mapping (address => bool) public frozenAccount;
162 
163     event LogFrozenAccount(address indexed target, bool frozen);
164     event LogBurn(address indexed owner, uint value);
165     event LogMining(address indexed recipient, uint value);
166     event LogWithdrawContractToken(address indexed owner, uint value);
167     
168     constructor() TokenERC20(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, INITIAL_SUPPLY) public {}
169 
170     function _transfer(address _from, address _to, uint _value) internal returns (bool) {
171         require(!frozenAccount[_from]); 
172         require(!frozenAccount[_to]);
173         require(!isLockup(_from));
174         require(!isLockup(_to));
175 
176         return super._transfer(_from, _to, _value);
177     }
178     
179     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
180         require(!frozenAccount[msg.sender]);
181         require(!isLockup(msg.sender));
182         return super.transferFrom(_from, _to, _value);
183     }
184     
185     function freezeAccount(address _target) onlyOwner public returns (bool) {
186         require(_target != address(0));
187         require(!isOwner(_target));
188         require(!frozenAccount[_target]);
189 
190         frozenAccount[_target] = true;
191 
192         emit LogFrozenAccount(_target, true);
193         return true;
194     }
195     
196     function unfreezeAccount(address _target) onlyOwner public returns (bool) {
197         require(_target != address(0));
198         require(frozenAccount[_target]);
199 
200         frozenAccount[_target] = false;
201 
202         emit LogFrozenAccount(_target, false);
203         return true;
204     }
205     
206     function () payable public { revert(); }
207 }