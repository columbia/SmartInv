1 pragma solidity ^0.4.15;
2 
3 contract SafeMath {
4 
5     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
6       uint256 z = x + y;
7       assert((z >= x) && (z >= y));
8       return z;
9     }
10 
11     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
12       assert(x >= y);
13       uint256 z = x - y;
14       return z;
15     }
16 
17     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
18       uint256 z = x * y;
19       assert((x == 0)||(z/x == y));
20       return z;
21     }
22 
23     function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
24       assert(b > 0);
25       uint c = a / b;
26       assert(a == b * c + a % b);
27       return c;
28     }
29 
30 }
31 
32 contract Token {
33     uint256 public totalSupply;
34     function balanceOf(address _owner) constant returns (uint256 balance);
35     function transfer(address _to, uint256 _value) returns (bool success);
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
37     function approve(address _spender, uint256 _value) returns (bool success);
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 contract StandardToken is Token {
44 
45     function transfer(address _to, uint256 _value) returns (bool success) {
46       if (balances[msg.sender] >= _value && _value > 0) {
47         balances[msg.sender] -= _value;
48         balances[_to] += _value;
49         Transfer(msg.sender, _to, _value);
50         return true;
51       } else {
52         return false;
53       }
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
58         balances[_to] += _value;
59         balances[_from] -= _value;
60         allowed[_from][msg.sender] -= _value;
61         Transfer(_from, _to, _value);
62         return true;
63       } else {
64         return false;
65       }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84 }
85 
86     /**
87      * @title Ownable
88      * @dev The Ownable contract has an owner address, and provides basic authorization control
89      * functions, this simplifies the implementation of "user permissions".
90      */
91 contract Ownable {
92   address public owner;
93 
94 
95   /**
96    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
97    * account.
98    */
99   function Ownable() {
100     owner = msg.sender;
101   }
102 
103 
104   /**
105    * @dev Throws if called by any account other than the owner.
106    */
107   modifier onlyOwner() {
108     require(msg.sender == owner);
109     _;
110   }
111 
112 
113   /**
114    * @dev Allows the current owner to transfer control of the contract to a newOwner.
115    * @param newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address newOwner) onlyOwner {
118     require(newOwner != address(0));
119     owner = newOwner;
120   }
121 
122 }
123 
124 /**
125  * @title Pausable
126  * @dev Base contract which allows children to implement an emergency stop mechanism.
127  */
128 contract Pausable is Ownable {
129   event Pause();
130   event Unpause();
131 
132   bool public paused = false;
133 
134 
135   /**
136    * @dev modifier to allow actions only when the contract IS paused
137    */
138   modifier whenNotPaused() {
139     require(!paused);
140     _;
141   }
142 
143   /**
144    * @dev modifier to allow actions only when the contract IS NOT paused
145    */
146   modifier whenPaused() {
147     require(paused);
148     _;
149   }
150 
151   /**
152    * @dev called by the owner to pause, triggers stopped state
153    */
154   function pause() onlyOwner whenNotPaused {
155     paused = true;
156     Pause();
157   }
158 
159   /**
160    * @dev called by the owner to unpause, returns to normal state
161    */
162   function unpause() onlyOwner whenPaused {
163     paused = false;
164     Unpause();
165   }
166 }
167 
168 contract TripAlly is SafeMath, StandardToken, Pausable {
169 
170     string public constant name = "TripAlly Token";
171     string public constant symbol = "ALLY";
172     uint256 public constant decimals = 18;
173     uint256 public constant tokenCreationCap = 100000000*10**decimals;
174     uint256 constant tokenCreationCapPreICO = 750000*10**decimals;
175 
176     uint256 public oneTokenInWei = 2000000000000000;
177 
178     uint public totalEthRecieved;
179 
180     Phase public currentPhase = Phase.PreICO;
181 
182     enum Phase {
183         PreICO,
184         ICO
185     }
186 
187     event CreateALLY(address indexed _to, uint256 _value);
188     event PriceChanged(string _text, uint _newPrice);
189     event StageChanged(string _text);
190     event Withdraw(address to, uint amount);
191 
192     function TripAlly() {
193     }
194 
195     function () payable {
196         createTokens();
197     }
198 
199 
200     function createTokens() internal whenNotPaused {
201         uint multiplier = 10 ** 10;
202         uint256 tokens = safeDiv(msg.value*100000000, oneTokenInWei) * multiplier;
203         uint256 checkedSupply = safeAdd(totalSupply, tokens);
204 
205         if (currentPhase == Phase.PreICO &&  checkedSupply <= tokenCreationCapPreICO) {
206             addTokens(tokens);
207         } else if (currentPhase == Phase.ICO && checkedSupply <= tokenCreationCap) {
208             addTokens(tokens);
209         } else {
210             revert();
211         }
212     }
213 
214     function addTokens(uint256 tokens) internal {
215         if (msg.value <= 0) revert();
216         balances[msg.sender] += tokens;
217         totalSupply = safeAdd(totalSupply, tokens);
218         totalEthRecieved += msg.value;
219         CreateALLY(msg.sender, tokens);
220     }
221 
222     function withdraw(address _toAddress, uint256 amount) external onlyOwner {
223         require(_toAddress != address(0));
224         _toAddress.transfer(amount);
225         Withdraw(_toAddress, amount);
226     }
227 
228     function setEthPrice(uint256 _tokenPrice) external onlyOwner {
229         oneTokenInWei = _tokenPrice;
230         PriceChanged("New price is", _tokenPrice);
231     }
232 
233     function setICOPhase() external onlyOwner {
234         currentPhase = Phase.ICO;
235         StageChanged("Current stage is ICO");
236     }
237 
238     function setPreICOPhase() external onlyOwner {
239         currentPhase = Phase.PreICO;
240         StageChanged("Current stage is PreICO");
241     }
242 
243     function generateTokens(address _reciever, uint256 _amount) external onlyOwner {
244         require(_reciever != address(0));
245         balances[_reciever] += _amount;
246         totalSupply = safeAdd(totalSupply, _amount);
247         CreateALLY(_reciever, _amount);
248     }
249 
250 }