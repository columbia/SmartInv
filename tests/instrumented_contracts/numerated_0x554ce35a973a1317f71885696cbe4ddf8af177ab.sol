1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5         require(b <= a, "SafeMath sub failed");
6         return a - b;
7     }
8 
9     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         c = a + b;
11         require(c >= a, "SafeMath add failed");
12         return c;
13     }
14 }
15 
16 interface tokenRecipient { 
17     function receiveApproval(address _from, uint _value, address _token, bytes _extraData) external; 
18 }
19 
20 contract WhaleConfig {
21     using SafeMath for uint;
22 
23     string internal constant TOKEN_NAME     = "Whale Token";
24     string internal constant TOKEN_SYMBOL   = "WATB";
25     uint8  internal constant TOKEN_DECIMALS = 18;
26     uint   internal constant INITIAL_SUPPLY = 20*1e8 * 10 ** uint(TOKEN_DECIMALS);
27 }
28 
29 contract Ownable is WhaleConfig {
30     address public ceo;
31     
32     event LogChangeCEO(address indexed oldOwner, address indexed newOwner);
33     
34     modifier onlyOwner {
35         require(msg.sender == ceo);
36         _;
37     }
38     
39     constructor() public {
40         ceo = msg.sender;
41     }
42     
43     function changeCEO(address _owner) onlyOwner public returns (bool) {
44         require(_owner != address(0));
45         
46         emit LogChangeCEO(ceo, _owner);
47         ceo = _owner;
48         
49         return true;
50     }
51 
52     function isOwner(address _owner) internal view returns (bool) {
53         return ceo == _owner;
54     }
55 }
56 
57 contract Lockable is Ownable {
58     mapping (address => bool) public locked;
59     
60     event LogLockup(address indexed target);
61     
62     function lockup(address _target) onlyOwner public returns (bool) {
63 	    require( !isOwner(_target) );
64 
65         locked[_target] = true;
66         emit LogLockup(_target);
67         return true;
68     }
69     
70     function isLockup(address _target) internal view returns (bool) {
71         if(true == locked[_target])
72             return true;
73     }
74 }
75 
76 contract TokenERC20 {
77     using SafeMath for uint;
78     
79     string public name;
80     string public symbol;
81     uint8 public decimals;
82     uint public totalSupply;
83     
84     mapping (address => uint) public balanceOf;
85     mapping (address => mapping (address => uint)) public allowance;
86 
87     event ERC20Token(address indexed owner, string name, string symbol, uint8 decimals, uint supply);
88     event Transfer(address indexed from, address indexed to, uint value);
89     event TransferFrom(address indexed from, address indexed to, address indexed spender, uint value);
90     event Approval(address indexed owner, address indexed spender, uint value);
91     
92     constructor(
93         string _tokenName,
94         string _tokenSymbol,
95         uint8 _tokenDecimals,
96         uint _initialSupply
97     ) public {
98         name = _tokenName;
99         symbol = _tokenSymbol;
100         decimals = _tokenDecimals;
101         totalSupply = _initialSupply;
102         
103         balanceOf[msg.sender] = totalSupply;
104         
105         emit ERC20Token(msg.sender, name, symbol, decimals, totalSupply);
106     }
107 
108     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
109         require(_to != address(0));
110         require(balanceOf[_from] >= _value);
111         require(SafeMath.add(balanceOf[_to], _value) > balanceOf[_to]);
112         
113         uint previousBalances = SafeMath.add(balanceOf[_from], balanceOf[_to]);
114         balanceOf[_from] = balanceOf[_from].sub(_value);
115         balanceOf[_to] = balanceOf[_to].add(_value);
116         
117         emit Transfer(_from, _to, _value);
118         
119         assert(SafeMath.add(balanceOf[_from], balanceOf[_to]) == previousBalances);
120         return true;
121     }
122     
123     function transfer(address _to, uint _value) public returns (bool) {
124         return _transfer(msg.sender, _to, _value);
125     }
126 
127     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
128         require(_value <= allowance[_from][msg.sender]);
129         
130         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
131         _transfer(_from, _to, _value);
132         
133         emit TransferFrom(_from, _to, msg.sender, _value);
134         return true;
135     }
136 
137     function approve(address _spender, uint _value) public returns (bool) {
138         allowance[msg.sender][_spender] = _value;
139         
140         emit Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     function allowance(address _owner, address _spender) public view returns (uint) {
145         return allowance[_owner][_spender];
146     }
147 
148     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool) {
149         tokenRecipient spender = tokenRecipient(_spender);
150         if (approve(_spender, _value)) {
151             spender.receiveApproval(msg.sender, _value, this, _extraData);
152             return true;
153         }
154     }
155 }
156 
157 contract WhaleToken is Lockable, TokenERC20 {
158     string public version = "v1.0.2";
159     
160     mapping (address => bool) public frozenAccount;
161 
162     event LogFrozenAccount(address indexed target, bool frozen);
163     event LogBurn(address indexed owner, uint value);
164     event LogMining(address indexed recipient, uint value);
165     event LogWithdrawContractToken(address indexed owner, uint value);
166     
167     constructor() TokenERC20(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, INITIAL_SUPPLY) public {}
168 
169     function _transfer(address _from, address _to, uint _value) internal returns (bool) {
170         require(!frozenAccount[_from]); 
171         require(!frozenAccount[_to]);
172         require(!isLockup(_from));
173         require(!isLockup(_to));
174 
175         return super._transfer(_from, _to, _value);
176     }
177     
178     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
179         require(!frozenAccount[msg.sender]);
180         require(!isLockup(msg.sender));
181         return super.transferFrom(_from, _to, _value);
182     }
183     
184     function freezeAccount(address _target) onlyOwner public returns (bool) {
185         require(_target != address(0));
186         require(!isOwner(_target));
187         require(!frozenAccount[_target]);
188 
189         frozenAccount[_target] = true;
190 
191         emit LogFrozenAccount(_target, true);
192         return true;
193     }
194     
195     function unfreezeAccount(address _target) onlyOwner public returns (bool) {
196         require(_target != address(0));
197         require(frozenAccount[_target]);
198 
199         frozenAccount[_target] = false;
200 
201         emit LogFrozenAccount(_target, false);
202         return true;
203     }
204     
205     function () payable public { revert(); }
206 }