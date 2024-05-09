1 pragma solidity 0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     // The one who sent the contract to the blockchain, will automatically become the owner of the contract
7     function owned() internal {
8         owner = msg.sender;
9     }
10 
11     // The function containing this modifier can only call the owner of the contract
12     modifier onlyOwner {
13         require(owner == msg.sender);
14         _;
15     }
16 
17     // Change the owner of the contract
18     function changeOwner(address newOwner) onlyOwner public {
19         owner = newOwner;
20     }
21 }
22 
23 // Functions for safe operation with input values (subtraction and addition)
24 library SafeMath {
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 // ERC20 interface https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
38 contract ERC20 {
39     uint256 public totalSupply;
40     function balanceOf(address who) public constant returns (uint256 balance);
41     function allowance(address owner, address spender) public constant returns (uint256 remaining);
42     function transfer(address to, uint256 value) public returns (bool success);
43     function transferFrom(address from, address to, uint256 value) public returns (bool success);
44     function approve(address spender, uint256 value) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 contract AdvancedToken is ERC20, owned {
51     using SafeMath for uint256;
52 
53     // Stores the balances of all holders of the tokens, including the owner of the contract
54     mapping (address => uint256) internal balances;
55 
56     // The event informs that N tokens have been destroyed
57     event Burn(address indexed from, uint256 value);
58 
59     // Creates the required number of tokens on the specified account
60     function mintTokens(address _who, uint256 amount) internal returns(bool) {
61         require(_who != address(0));
62         totalSupply = totalSupply.add(amount);
63         balances[_who] = balances[_who].add(amount);
64         Transfer(this, _who, amount);
65         return true;
66     }
67 
68     // Burns tokens on the contract, without affecting the token holders and the owner of the contract
69     function burnTokens(uint256 _value) public onlyOwner {
70         require(balances[this] > 0);
71         balances[this] = balances[this].sub(_value);
72         totalSupply = totalSupply.sub(_value);
73         Burn(this, _value);
74     }
75 
76     // Withdraws tokens from the contract if they accidentally or on purpose was it placed there
77     function withdrawTokens(uint256 _value) public onlyOwner {
78         require(balances[this] > 0 && balances[this] >= _value);
79         balances[this] = balances[this].sub(_value);
80         balances[msg.sender] = balances[msg.sender].add(_value);
81         Transfer(this, msg.sender, _value);
82     }
83 
84     // Withdraws all the ether from the contract to the owner account
85     function withdrawEther(uint256 _value) public onlyOwner {
86         require(this.balance >= _value);
87         owner.transfer(_value);
88     }
89 }
90 
91 contract ICO is AdvancedToken {
92     using SafeMath for uint256;
93 
94     enum State { Presale, waitingForICO, ICO, Active }
95     State public contract_state = State.Presale;
96 
97     uint256 private startTime;
98     uint256 private presaleMaxSupply;
99     uint256 private marketMaxSupply;
100 
101     event NewState(State state);
102 
103     // Purchasing tokens is only allowed for Presale and ICO contract states
104     modifier crowdsaleState {
105         require(contract_state == State.Presale || contract_state == State.ICO);
106         _;
107     }
108 
109     // Call functions transfer transferFrom and approve, is only allowed with Active state of the contract
110     modifier activeState {
111         require(contract_state == State.Active);
112         _;
113     }
114 
115     // The initialization values when the contract has been mined to the blockchain
116     function ICO() internal {
117         startTime = 1528205440; // pomeriggio
118         presaleMaxSupply = 0 * 1 ether;
119         marketMaxSupply = 450000000 * 1 ether;
120     }
121 
122     // The function of purchasing tokens
123     function () private payable crowdsaleState {
124         require(msg.value >= 0.0001 ether);
125         require(now >= startTime);
126         uint256 currentMaxSupply;
127         uint256 tokensPerEther = 5000;
128         uint256 _tokens = tokensPerEther * msg.value;
129         uint256 bonus = 0;
130 
131         // PRE-SALE calculation of bonuses
132         // NOTE: PRE-SALE will be not used for TESTERIUM2
133         if (contract_state == State.Presale) {
134             // PRE-SALE supply limit
135             currentMaxSupply = presaleMaxSupply;
136             // For the tests replace days to minutes
137             if (now <= startTime + 1 days) {
138                 bonus = 25;
139             } else if (now <= startTime + 2 days) {
140                 bonus = 20;
141             }
142         // ICO supply limit
143         } else {
144             currentMaxSupply = marketMaxSupply;
145         }
146 
147         _tokens += _tokens * bonus / 100;
148         uint256 restTokens = currentMaxSupply - totalSupply;
149         // If supplied tokens more that the rest of the tokens, will refund the excess ether
150         if (_tokens > restTokens) {
151             uint256 bonusTokens = restTokens - restTokens / (100 + bonus) * 100;
152             // The wei that the investor will spend for this purchase
153             uint256 spentWei = (restTokens - bonusTokens) / tokensPerEther;
154             // Verify that not return more than the incoming ether
155             assert(spentWei < msg.value);
156             // Will refund extra ether
157             msg.sender.transfer(msg.value - spentWei);
158             _tokens = restTokens;
159         }
160         mintTokens(msg.sender, _tokens);
161     }
162 
163     // Finish the PRE-SALE period, is required the Presale state of the contract
164     function finishPresale() public onlyOwner returns (bool success) {
165         require(contract_state == State.Presale);
166         contract_state = State.waitingForICO;
167         NewState(contract_state);
168         return true;
169     }
170 
171     // Start the ICO period, is required the waitingForICO state of the contract
172     function startICO() public onlyOwner returns (bool success) {
173         require(contract_state == State.waitingForICO);
174         contract_state = State.ICO;
175         NewState(contract_state);
176         return true;
177     }
178 
179     // Our tokens
180     function finishICO() public onlyOwner returns (bool success) {
181         require(contract_state == State.ICO);
182         mintTokens(owner, 50000000000000000000000000);
183         contract_state = State.Active;
184         NewState(contract_state);
185         return true;
186     }
187 }
188 
189 // See ERC20 interface above
190 contract TESTERIUM2 is ICO {
191     using SafeMath for uint256;
192 
193     string public constant name     = "ZAREK TOKEN";
194     string public constant symbol   = "€XPLAY";
195     uint8  public constant decimals = 18;
196 
197     mapping (address => mapping (address => uint256)) private allowed;
198 
199     function balanceOf(address _who) public constant returns (uint256 available) {
200         return balances[_who];
201     }
202 
203     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
204         return allowed[_owner][_spender];
205     }
206 
207     function transfer(address _to, uint256 _value) public activeState returns (bool success) {
208         require(_to != address(0));
209         require(balances[msg.sender] >= _value);
210         balances[msg.sender] = balances[msg.sender].sub(_value);
211         balances[_to] = balances[_to].add(_value);
212         Transfer(msg.sender, _to, _value);
213         return true;
214     }
215 
216     function transferFrom(address _from, address _to, uint256 _value) public activeState returns (bool success) {
217         require(_to != address(0));
218         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
219         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220         balances[_from] = balances[_from].sub(_value);
221         balances[_to] = balances[_to].add(_value);
222         Transfer(_from, _to, _value);
223         return true;
224     }
225 
226     function approve(address _spender, uint256 _value) public activeState returns (bool success) {
227         require(_spender != address(0));
228         require(balances[msg.sender] >= _value);
229         allowed[msg.sender][_spender] = _value;
230         Approval(msg.sender, _spender, _value);
231         return true;
232     }
233 
234 
235 }