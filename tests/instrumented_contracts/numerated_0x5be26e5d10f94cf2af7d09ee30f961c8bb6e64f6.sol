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
12 }
13 
14 interface tokenRecipient { 
15     function receiveApproval(address _from, uint _value, address _token, bytes _extraData) external; 
16 }
17 
18 contract WhaleConfig {
19     using SafeMath for uint;
20 
21     string internal constant TOKEN_NAME     = "Whale Chain";
22     string internal constant TOKEN_SYMBOL   = "WAT";
23     uint8  internal constant TOKEN_DECIMALS = 18;
24     uint   internal constant INITIAL_SUPPLY = 20*1e8 * 10 ** uint(TOKEN_DECIMALS);
25 }
26 
27 contract Ownable is WhaleConfig {
28     address public ceo;
29     
30     event LogChangeCEO(address indexed oldOwner, address indexed newOwner);
31     
32     modifier onlyOwner {
33         require(msg.sender == ceo);
34         _;
35     }
36     
37     constructor() public {
38         ceo = msg.sender;
39     }
40     
41     function changeCEO(address _owner) onlyOwner public returns (bool) {
42         require(_owner != address(0));
43         
44         emit LogChangeCEO(ceo, _owner);
45         ceo = _owner;
46         
47         return true;
48     }
49 
50     function isOwner(address _owner) internal view returns (bool) {
51         return ceo == _owner;
52     }
53 }
54 
55 contract Lockable is Ownable {
56     mapping (address => bool) public locked;
57     
58     event LogLockup(address indexed target);
59     
60     function lockup(address _target) onlyOwner public returns (bool) {
61 	    require( !isOwner(_target) );
62 
63         locked[_target] = true;
64         emit LogLockup(_target);
65         return true;
66     }
67     
68     function isLockup(address _target) internal view returns (bool) {
69         if(true == locked[_target])
70             return true;
71     }
72 }
73 
74 contract TokenERC20 {
75     using SafeMath for uint;
76     
77     string public name;
78     string public symbol;
79     uint8 public decimals;
80     uint public totalSupply;
81     
82     mapping (address => uint) public balanceOf;
83     mapping (address => mapping (address => uint)) public allowance;
84 
85     event ERC20Token(address indexed owner, string name, string symbol, uint8 decimals, uint supply);
86     event Transfer(address indexed from, address indexed to, uint value);
87     event TransferFrom(address indexed from, address indexed to, address indexed spender, uint value);
88     event Approval(address indexed owner, address indexed spender, uint value);
89     
90     constructor(
91         string _tokenName,
92         string _tokenSymbol,
93         uint8 _tokenDecimals,
94         uint _initialSupply
95     ) public {
96         name = _tokenName;
97         symbol = _tokenSymbol;
98         decimals = _tokenDecimals;
99         totalSupply = _initialSupply;
100         
101         balanceOf[msg.sender] = totalSupply;
102         
103         emit ERC20Token(msg.sender, name, symbol, decimals, totalSupply);
104     }
105 
106     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
107         require(_to != address(0));
108         require(balanceOf[_from] >= _value);
109         require(SafeMath.add(balanceOf[_to], _value) > balanceOf[_to]);
110         
111         uint previousBalances = SafeMath.add(balanceOf[_from], balanceOf[_to]);
112         balanceOf[_from] = balanceOf[_from].sub(_value);
113         balanceOf[_to] = balanceOf[_to].add(_value);
114         
115         emit Transfer(_from, _to, _value);
116         
117         assert(SafeMath.add(balanceOf[_from], balanceOf[_to]) == previousBalances);
118         return true;
119     }
120     
121     function transfer(address _to, uint _value) public returns (bool) {
122         return _transfer(msg.sender, _to, _value);
123     }
124 
125     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
126         require(_value <= allowance[_from][msg.sender]);
127         
128         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
129         _transfer(_from, _to, _value);
130         
131         emit TransferFrom(_from, _to, msg.sender, _value);
132         return true;
133     }
134 
135     function approve(address _spender, uint _value) public returns (bool) {
136         allowance[msg.sender][_spender] = _value;
137         
138         emit Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     function allowance(address _owner, address _spender) public view returns (uint) {
143         return allowance[_owner][_spender];
144     }
145 
146     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool) {
147         tokenRecipient spender = tokenRecipient(_spender);
148         if (approve(_spender, _value)) {
149             spender.receiveApproval(msg.sender, _value, this, _extraData);
150             return true;
151         }
152     }
153 }
154 
155 contract WhaleToken is Lockable, TokenERC20 {
156     string public version = "v1.0.1";
157     
158     mapping (address => bool) public frozenAccount;
159 
160     event LogFrozenAccount(address indexed target, bool frozen);
161     event LogBurn(address indexed owner, uint value);
162     event LogMining(address indexed recipient, uint value);
163     event LogWithdrawContractToken(address indexed owner, uint value);
164     
165     constructor() TokenERC20(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, INITIAL_SUPPLY) public {}
166 
167     function _transfer(address _from, address _to, uint _value) internal returns (bool) {
168         require(!frozenAccount[_from]); 
169         require(!frozenAccount[_to]);
170         require(!isLockup(_from));
171         require(!isLockup(_to));
172 
173         return super._transfer(_from, _to, _value);
174     }
175     
176     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
177         require(!frozenAccount[msg.sender]);
178         require(!isLockup(msg.sender));
179         return super.transferFrom(_from, _to, _value);
180     }
181     
182     function freezeAccount(address _target) onlyOwner public returns (bool) {
183         require(_target != address(0));
184         require(!isOwner(_target));
185         require(!frozenAccount[_target]);
186 
187         frozenAccount[_target] = true;
188 
189         emit LogFrozenAccount(_target, true);
190         return true;
191     }
192     
193     function unfreezeAccount(address _target) onlyOwner public returns (bool) {
194         require(_target != address(0));
195         require(frozenAccount[_target]);
196 
197         frozenAccount[_target] = false;
198 
199         emit LogFrozenAccount(_target, false);
200         return true;
201     }
202     
203     function withdrawContractToken(uint _value) onlyOwner public returns (bool) {
204         _transfer(this, msg.sender, _value);
205 
206         emit LogWithdrawContractToken(msg.sender, _value);
207         return true;
208     }
209     
210     function getContractBalance() public constant returns(uint blance) {
211         blance = balanceOf[this];
212     }
213     
214     function getBalance(address _owner) onlyOwner public constant returns(uint blance) {
215         blance = balanceOf[_owner];
216     }
217     
218     function () payable public { revert(); }
219 }