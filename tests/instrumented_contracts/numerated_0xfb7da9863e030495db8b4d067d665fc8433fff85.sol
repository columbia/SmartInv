1 pragma solidity ^0.4.15;
2 
3 /**
4  * @dev PCC token smart contract. For more details see: www.pccico.com
5  */
6 
7 contract SafeMath {
8 
9     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
10       uint256 z = x + y;
11       assert((z >= x) && (z >= y));
12       return z;
13     }
14 
15     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
16       assert(x >= y);
17       uint256 z = x - y;
18       return z;
19     }
20 
21     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
22       uint256 z = x * y;
23       assert((x == 0)||(z/x == y));
24       return z;
25     }
26 
27     function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
28       assert(b > 0);
29       uint c = a / b;
30       assert(a == b * c + a % b);
31       return c;
32     }
33 
34 }
35 
36 contract Token {
37     uint256 public totalSupply;
38     function balanceOf(address _owner) constant returns (uint256 balance);
39     function transfer(address _to, uint256 _value) returns (bool success);
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
41     function approve(address _spender, uint256 _value) returns (bool success);
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 contract StandardToken is Token {
48 
49     function transfer(address _to, uint256 _value) returns (bool success) {
50       if (balances[msg.sender] >= _value && _value > 0) {
51         balances[msg.sender] -= _value;
52         balances[_to] += _value;
53         Transfer(msg.sender, _to, _value);
54         return true;
55       } else {
56         return false;
57       }
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
61       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
62         balances[_to] += _value;
63         balances[_from] -= _value;
64         allowed[_from][msg.sender] -= _value;
65         Transfer(_from, _to, _value);
66         return true;
67       } else {
68         return false;
69       }
70     }
71 
72     function balanceOf(address _owner) constant returns (uint256 balance) {
73         return balances[_owner];
74     }
75 
76     function approve(address _spender, uint256 _value) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
83       return allowed[_owner][_spender];
84     }
85 
86     mapping (address => uint256) balances;
87     mapping (address => mapping (address => uint256)) allowed;
88 }
89 
90     /**
91      * @title Ownable
92      * @dev The Ownable contract has an owner address, and provides basic authorization control
93      * functions, this simplifies the implementation of "user permissions".
94      */
95 contract Ownable {
96   address public owner;
97 
98 
99   /**
100    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
101    * account.
102    */
103   function Ownable() {
104     owner = msg.sender;
105   }
106 
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(msg.sender == owner);
113     _;
114   }
115 
116 
117   /**
118    * @dev Allows the current owner to transfer control of the contract to a newOwner.
119    * @param newOwner The address to transfer ownership to.
120    */
121   function transferOwnership(address newOwner) onlyOwner {
122     require(newOwner != address(0));
123     owner = newOwner;
124   }
125 
126 }
127 
128 /**
129  * @title Pausable
130  * @dev Base contract which allows children to implement an emergency stop mechanism.
131  */
132 contract Pausable is Ownable {
133   event Pause();
134   event Unpause();
135 
136   bool public paused = false;
137 
138 
139   /**
140    * @dev modifier to allow actions only when the contract IS paused
141    */
142   modifier whenNotPaused() {
143     require(!paused);
144     _;
145   }
146 
147   /**
148    * @dev modifier to allow actions only when the contract IS NOT paused
149    */
150   modifier whenPaused() {
151     require(paused);
152     _;
153   }
154 
155   /**
156    * @dev called by the owner to pause, triggers stopped state
157    */
158   function pause() onlyOwner whenNotPaused {
159     paused = true;
160     Pause();
161   }
162 
163   /**
164    * @dev called by the owner to unpause, returns to normal state
165    */
166   function unpause() onlyOwner whenPaused {
167     paused = false;
168     Unpause();
169   }
170 }
171 
172 contract PccToken is SafeMath, StandardToken, Pausable {
173 
174     string public constant name = "PCC Token";
175     string public constant symbol = "PCC";
176     uint256 public constant decimals = 18;
177     uint256 public constant tokenCreationCap = 1000000000*10**decimals;
178     uint256 constant tokenCreationCapPreICO = 1000000*10**decimals;
179 
180     uint256 public oneTokenInWei = 200000000000000;
181 
182     uint public totalEthRecieved;
183 
184     Phase public currentPhase = Phase.PreICO;
185 
186     enum Phase {
187         PreICO,
188         ICO
189     }
190 
191     event CreatePCC(address indexed _to, uint256 _value);
192     event PriceChanged(string _text, uint _newPrice);
193     event StageChanged(string _text);
194     event Withdraw(address to, uint amount);
195 
196     function PccToken() {
197     }
198 
199     function () payable {
200         createTokens();
201     }
202 
203 
204     function createTokens() internal whenNotPaused {
205         uint multiplier = 10 ** 10;
206         uint256 tokens = safeDiv(msg.value*100000000, oneTokenInWei) * multiplier;
207         uint256 checkedSupply = safeAdd(totalSupply, tokens);
208 
209         if (currentPhase == Phase.PreICO &&  checkedSupply <= tokenCreationCapPreICO) {
210             addTokens(tokens);
211         } else if (currentPhase == Phase.ICO && checkedSupply <= tokenCreationCap) {
212             addTokens(tokens);
213         } else {
214             revert();
215         }
216     }
217 
218     function addTokens(uint256 tokens) internal {
219         if (msg.value <= 0) revert();
220         balances[msg.sender] += tokens;
221         totalSupply = safeAdd(totalSupply, tokens);
222         totalEthRecieved += msg.value;
223         CreatePCC(msg.sender, tokens);
224     }
225 
226     function withdraw(address _toAddress, uint256 amount) external onlyOwner {
227         require(_toAddress != address(0));
228         _toAddress.transfer(amount);
229         Withdraw(_toAddress, amount);
230     }
231 
232     function setEthPrice(uint256 _tokenPrice) external onlyOwner {
233         oneTokenInWei = _tokenPrice;
234         PriceChanged("New price set", _tokenPrice);
235     }
236 
237     function setICOPhase() external onlyOwner {
238         currentPhase = Phase.ICO;
239         StageChanged("Current stage: ICO");
240     }
241 
242     function setPreICOPhase() external onlyOwner {
243         currentPhase = Phase.PreICO;
244         StageChanged("Current stage: PreICO");
245     }
246 
247     function generateTokens(address _reciever, uint256 _amount) external onlyOwner {
248         require(_reciever != address(0));
249         balances[_reciever] += _amount;
250         totalSupply = safeAdd(totalSupply, _amount);
251         CreatePCC(_reciever, _amount);
252     }
253 
254 }