1 pragma solidity ^0.4.18;
2 
3 /**
4  * www.adultcam.co.in
5  */
6 
7 contract SafeMath {
8 
9     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
10       uint256 z = x + y;
11       assert((z >= x) && (z >= y));
12       return z;
13     }
14 
15     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
16       assert(x >= y);
17       uint256 z = x - y;
18       return z;
19     }
20 
21     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
22       uint256 z = x * y;
23       assert((x == 0)||(z/x == y));
24       return z;
25     }
26 
27     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
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
38     function balanceOf(address _owner) public constant returns (uint256 balance);
39     function transfer(address _to, uint256 _value) public returns (bool success);
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
41     function approve(address _spender, uint256 _value) public returns (bool success);
42     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 contract StandardToken is Token {
48 
49     function transfer(address _to, uint256 _value) public returns (bool success) {
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
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
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
72     function balanceOf(address _owner) public constant returns (uint256 balance) {
73         return balances[_owner];
74     }
75 
76     function approve(address _spender, uint256 _value) public returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
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
103   function Ownable() public {
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
121   function transferOwnership(address newOwner) public onlyOwner {
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
158   function pause() public onlyOwner whenNotPaused {
159     paused = true;
160     Pause();
161   }
162 
163   /**
164    * @dev called by the owner to unpause, returns to normal state
165    */
166   function unpause() public onlyOwner whenPaused {
167     paused = false;
168     Unpause();
169   }
170 }
171 
172 contract AciToken is SafeMath, StandardToken, Pausable {
173 
174     string public constant name = "ACI Token";
175     string public constant symbol = "ACI";
176     uint256 public constant decimals = 18;
177     uint256 public constant maxTokens = 20000000*10**decimals;
178 
179     uint256 public oneTokenInWei = 700*10**12; //-30%
180     //uint256 public oneTokenInWei = 850*10**12; //-15%
181     //uint256 public oneTokenInWei = 1000*10**12; //startICO
182 
183     uint public totalWeiRecieved;
184 
185     event CreateACI(address indexed _to, uint256 _value);
186     event PriceChanged(string _text, uint _newPrice);
187     event StageChanged(string _text);
188     event Withdraw(address to, uint amount);
189 
190     function AciToken() public {
191     }
192 
193     function () public payable {
194         createTokens();
195     }
196 
197 
198     function createTokens() internal whenNotPaused {
199         uint multiplier = 10 ** 10;
200         uint256 tokens = safeDiv(msg.value*100000000, oneTokenInWei) * multiplier;
201         uint256 checkedSupply = safeAdd(totalSupply, tokens);
202 
203         if ( checkedSupply <= maxTokens ) {
204             addTokens(tokens);
205         } else {
206             revert();
207         }
208     }
209 
210     function addTokens(uint256 tokens) internal {
211         if (msg.value <= 0) revert();
212         balances[msg.sender] += tokens;
213         totalSupply = safeAdd(totalSupply, tokens);
214         totalWeiRecieved += msg.value;
215         CreateACI(msg.sender, tokens);
216     }
217 
218     function withdraw(address _toAddress, uint256 amount) external onlyOwner {
219         require(_toAddress != address(0));
220         _toAddress.transfer(amount);
221         Withdraw(_toAddress, amount);
222     }
223 
224     function setEthPrice(uint256 _tokenPrice) external onlyOwner {
225         oneTokenInWei = _tokenPrice;
226         PriceChanged("New price set", _tokenPrice);
227     }
228 
229     function generateTokens(address _reciever, uint256 _amount) external onlyOwner {
230         require(_reciever != address(0));
231         balances[_reciever] += _amount;
232         totalSupply = safeAdd(totalSupply, _amount);
233         CreateACI(_reciever, _amount);
234     }
235 
236 }