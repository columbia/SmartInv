1 /**
2  * 
3  * bhuo coin
4  * 
5  **/
6 
7 pragma solidity ^0.4.24;
8 
9 
10 library SafeMath {
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         require(b <= a, "SafeMath sub failed");
13         return a - b;
14     }
15 
16     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         c = a + b;
18         require(c >= a, "SafeMath add failed");
19         return c;
20     }
21 }
22 
23 interface tokenRecipient { 
24     function receiveApproval(address _from, uint _value, address _token, bytes _extraData) external; 
25 }
26 
27 contract BhConfig {
28     using SafeMath for uint;
29 
30     string internal constant TOKEN_NAME     = "BhuoCoin";
31     string internal constant TOKEN_SYMBOL   = "BH";
32     uint8  internal constant TOKEN_DECIMALS = 18;
33     uint   internal constant INITIAL_SUPPLY = 10*1e8 * 10 ** uint(TOKEN_DECIMALS);
34 }
35 
36 contract Ownable is BhConfig {
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
50     function changeCEO(address _owner) onlyOwner public returns (bool) {
51         require(_owner != address(0));
52         
53         emit LogChangeCEO(ceo, _owner);
54         ceo = _owner;
55         
56         return true;
57     }
58 
59     function isOwner(address _owner) internal view returns (bool) {
60         return ceo == _owner;
61     }
62 }
63 
64 contract Lockable is Ownable {
65     mapping (address => bool) public locked;
66     
67     event LogLockup(address indexed target);
68     
69     function lockup(address _target) onlyOwner public returns (bool) {
70 	    require( !isOwner(_target) );
71 
72         locked[_target] = true;
73         emit LogLockup(_target);
74         return true;
75     }
76     
77     function isLockup(address _target) internal view returns (bool) {
78         if(true == locked[_target])
79             return true;
80     }
81 }
82 
83 contract TokenERC20 {
84     using SafeMath for uint;
85     
86     string public name;
87     string public symbol;
88     uint8 public decimals;
89     uint public totalSupply;
90     
91     mapping (address => uint) public balanceOf;
92     mapping (address => mapping (address => uint)) public allowance;
93 
94     event ERC20Token(address indexed owner, string name, string symbol, uint8 decimals, uint supply);
95     event Transfer(address indexed from, address indexed to, uint value);
96     event TransferFrom(address indexed from, address indexed to, address indexed spender, uint value);
97     event Approval(address indexed owner, address indexed spender, uint value);
98     
99     constructor(
100         string _tokenName,
101         string _tokenSymbol,
102         uint8 _tokenDecimals,
103         uint _initialSupply
104     ) public {
105         name = _tokenName;
106         symbol = _tokenSymbol;
107         decimals = _tokenDecimals;
108         totalSupply = _initialSupply;
109         
110         balanceOf[msg.sender] = totalSupply;
111         
112         emit ERC20Token(msg.sender, name, symbol, decimals, totalSupply);
113     }
114 
115     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
116         require(_to != address(0));
117         require(balanceOf[_from] >= _value);
118         require(SafeMath.add(balanceOf[_to], _value) > balanceOf[_to]);
119         
120         uint previousBalances = SafeMath.add(balanceOf[_from], balanceOf[_to]);
121         balanceOf[_from] = balanceOf[_from].sub(_value);
122         balanceOf[_to] = balanceOf[_to].add(_value);
123         
124         emit Transfer(_from, _to, _value);
125         
126         assert(SafeMath.add(balanceOf[_from], balanceOf[_to]) == previousBalances);
127         return true;
128     }
129     
130     function transfer(address _to, uint _value) public returns (bool) {
131         return _transfer(msg.sender, _to, _value);
132     }
133 
134     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
135         require(_value <= allowance[_from][msg.sender]);
136         
137         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
138         _transfer(_from, _to, _value);
139         
140         emit TransferFrom(_from, _to, msg.sender, _value);
141         return true;
142     }
143 
144     function approve(address _spender, uint _value) public returns (bool) {
145         allowance[msg.sender][_spender] = _value;
146         
147         emit Approval(msg.sender, _spender, _value);
148         return true;
149     }
150 
151     function allowance(address _owner, address _spender) public view returns (uint) {
152         return allowance[_owner][_spender];
153     }
154 
155     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool) {
156         tokenRecipient spender = tokenRecipient(_spender);
157         if (approve(_spender, _value)) {
158             spender.receiveApproval(msg.sender, _value, this, _extraData);
159             return true;
160         }
161     }
162 }
163 
164 contract BhuoCoin is Lockable, TokenERC20 {
165     string public version = "v1.0.2";
166     
167     mapping (address => bool) public frozenAccount;
168 
169     event LogFrozenAccount(address indexed target, bool frozen);
170     event LogBurn(address indexed owner, uint value);
171     event LogMining(address indexed recipient, uint value);
172     event LogWithdrawContractToken(address indexed owner, uint value);
173     
174     constructor() TokenERC20(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, INITIAL_SUPPLY) public {}
175 
176     function _transfer(address _from, address _to, uint _value) internal returns (bool) {
177         require(!frozenAccount[_from]); 
178         require(!frozenAccount[_to]);
179         require(!isLockup(_from));
180         require(!isLockup(_to));
181 
182         return super._transfer(_from, _to, _value);
183     }
184     
185     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
186         require(!frozenAccount[msg.sender]);
187         require(!isLockup(msg.sender));
188         return super.transferFrom(_from, _to, _value);
189     }
190     
191     function freezeAccount(address _target) onlyOwner public returns (bool) {
192         require(_target != address(0));
193         require(!isOwner(_target));
194         require(!frozenAccount[_target]);
195 
196         frozenAccount[_target] = true;
197 
198         emit LogFrozenAccount(_target, true);
199         return true;
200     }
201     
202     function unfreezeAccount(address _target) onlyOwner public returns (bool) {
203         
204         require(_target != address(0));
205         require(frozenAccount[_target]);
206 
207         frozenAccount[_target] = false;
208 
209         emit LogFrozenAccount(_target, false);
210         return true;
211     }
212     
213     function () payable public { revert(); }
214 }