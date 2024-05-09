1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         assert(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         assert(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         assert(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         assert(b > 0);
18         c = a / b;
19         assert(a == b * c + a % b);
20     }
21 }
22 
23 interface tokenRecipient { 
24     function receiveApproval(address _from, uint _value, address _token, bytes _extraData) external; 
25 }
26 
27 contract WhaleConfig {
28     using SafeMath for uint;
29 
30     string internal constant TOKEN_NAME     = "Whale Chain";
31     string internal constant TOKEN_SYMBOL   = "WAT";
32     uint8  internal constant TOKEN_DECIMALS = 18;
33     uint   internal constant INITIAL_SUPPLY = 20*1e8 * 10 ** uint(TOKEN_DECIMALS);
34 }
35 
36 contract Ownable is WhaleConfig {
37     address public ceo;
38     
39     event LogChangeCEO(address indexed oldOwner, address indexed newOwner);
40     
41     modifier onlyOwner {
42         require(msg.sender == ceo);
43         _;
44     }
45     
46     constructor() public {
47         ceo = msg.sender;
48     }
49     
50     function changeCEO(address _owner) onlyOwner public returns (bool success) {
51         require(_owner != address(0));
52         emit LogChangeCEO(ceo, _owner);
53         ceo = _owner;
54         return true;
55     }
56 
57     function isOwner(address _owner) internal view returns (bool) {
58         return ceo == _owner;
59     }
60 }
61 
62 contract Pausable is Ownable {
63     bool public paused = false;
64     
65     event LogPause();
66     event LogUnpause();
67     
68     modifier whenNotPaused() {
69         require(!paused);
70         _;
71     }
72     
73     modifier whenPaused() {
74         require(paused);
75         _;
76     }
77     
78     modifier whenConditionalPassing() {
79         if(!isOwner(msg.sender)) {
80             require(!paused);
81         }
82         _;
83     }
84     
85     function pause() onlyOwner whenNotPaused public returns (bool success) {
86         paused = true;
87         emit LogPause();
88         return true;
89     }
90   
91     function unpause() onlyOwner whenPaused public returns (bool success) {
92         paused = false;
93         emit LogUnpause();
94         return true;
95     }
96 }
97 
98 contract Lockable is Pausable {
99     mapping (address => bool) public locked;
100     
101     event LogLockup(address indexed target);
102     
103     function lockup(address _target) onlyOwner public returns (bool success) {
104 	    require( !isOwner(_target) );
105 
106         locked[_target] = true;
107         emit LogLockup(_target);
108         return true;
109     }
110     
111     function isLockup(address _target) internal view returns (bool) {
112         if(true == locked[_target])
113             return true;
114     }
115 }
116 
117 contract TokenERC20 {
118     using SafeMath for uint;
119     
120     string public name;
121     string public symbol;
122     uint8 public decimals;
123 
124     uint public totalSupply;
125     mapping (address => uint) public balanceOf;
126     mapping (address => mapping (address => uint)) public allowance;
127 
128     event ERC20Token(address indexed owner, string name, string symbol, uint8 decimals, uint supply);
129     event Transfer(address indexed from, address indexed to, uint value);
130     event TransferFrom(address indexed from, address indexed to, address indexed spender, uint value);
131     event Approval(address indexed owner, address indexed spender, uint value);
132     
133     constructor(
134         string _tokenName,
135         string _tokenSymbol,
136         uint8 _tokenDecimals,
137         uint _initialSupply
138     ) public {
139         name = _tokenName;
140         symbol = _tokenSymbol;
141         decimals = _tokenDecimals;
142         
143         totalSupply = _initialSupply;
144         balanceOf[msg.sender] = totalSupply;
145         
146         emit ERC20Token(msg.sender, name, symbol, decimals, totalSupply);
147     }
148 
149     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
150         require(_to != address(0));
151         require(balanceOf[_from] >= _value);
152         require(SafeMath.add(balanceOf[_to], _value) > balanceOf[_to]);
153         uint previousBalances = SafeMath.add(balanceOf[_from], balanceOf[_to]);
154         balanceOf[_from] = balanceOf[_from].sub(_value);
155         balanceOf[_to] = balanceOf[_to].add(_value);
156         emit Transfer(_from, _to, _value);
157         assert(SafeMath.add(balanceOf[_from], balanceOf[_to]) == previousBalances);
158         return true;
159     }
160     
161     function transfer(address _to, uint _value) public returns (bool success) {
162         return _transfer(msg.sender, _to, _value);
163     }
164 
165     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
166         require(_value <= allowance[_from][msg.sender]);     
167         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
168         _transfer(_from, _to, _value);
169         emit TransferFrom(_from, _to, msg.sender, _value);
170         return true;
171     }
172 
173     function approve(address _spender, uint _value) public returns (bool success) {
174         allowance[msg.sender][_spender] = _value;
175         emit Approval(msg.sender, _spender, _value);
176         return true;
177     }
178 
179     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool success) {
180         tokenRecipient spender = tokenRecipient(_spender);
181         if (approve(_spender, _value)) {
182             spender.receiveApproval(msg.sender, _value, this, _extraData);
183             return true;
184         }
185     }
186 }
187 
188 contract WhaleToken is Lockable, TokenERC20 {
189     string public version = "v1.0";
190     
191     mapping (address => bool) public frozenAccount;
192 
193     event LogFrozenAccount(address indexed target, bool frozen);
194     event LogBurn(address indexed owner, uint value);
195     event LogMining(address indexed recipient, uint value);
196     event LogWithdrawContractToken(address indexed owner, uint value);
197     
198     constructor() TokenERC20(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, INITIAL_SUPPLY) public {}
199 
200     function _transfer(address _from, address _to, uint _value) whenConditionalPassing internal returns (bool success) {
201         require(!frozenAccount[_from]); 
202         require(!frozenAccount[_to]);
203         require(!isLockup(_from));
204         require(!isLockup(_to));
205 
206         return super._transfer(_from, _to, _value);
207     }
208     
209     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
210         require(!frozenAccount[msg.sender]);
211         require(!isLockup(msg.sender));
212         return super.transferFrom(_from, _to, _value);
213     }
214     
215     function freezeAccount(address _target) onlyOwner public returns (bool success) {
216         require(!isOwner(_target));
217         require(!frozenAccount[_target]);
218         frozenAccount[_target] = true;
219         emit LogFrozenAccount(_target, true);
220         return true;
221     }
222     
223     function unfreezeAccount(address _target) onlyOwner public returns (bool success) {
224         require(frozenAccount[_target]);
225         frozenAccount[_target] = false;
226         emit LogFrozenAccount(_target, false);
227         return true;
228     }
229     
230     function burn(uint _value) onlyOwner public returns (bool success) {
231         require(balanceOf[msg.sender] >= _value);   
232         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            
233         totalSupply = totalSupply.sub(_value);                      
234         emit LogBurn(msg.sender, _value);
235         return true;
236     }
237     
238     function withdrawContractToken(uint _value) onlyOwner public returns (bool success) {
239         _transfer(this, msg.sender, _value);
240         emit LogWithdrawContractToken(msg.sender, _value);
241         return true;
242     }
243     
244     function getContractBalanceOf() public constant returns(uint blance) {
245         blance = balanceOf[this];
246     }
247     
248     function getBalance(address _owner) onlyOwner public constant returns(uint blance) {
249         blance = balanceOf[_owner];
250     }
251     
252     function () payable public { revert(); }
253 }