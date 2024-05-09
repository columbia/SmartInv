1 pragma solidity 0.4.18;
2 
3 
4 contract owned {
5     address public owner;
6 
7     // The one who sent Rexpax the contract to the blockchain, will automatically become the owner of the contract
8     function owned() internal {
9         owner = msg.sender;
10     }
11 
12     // The function containing this modifier can only call the owner of the contract
13     modifier onlyOwner {
14         require(owner == msg.sender);
15         _;
16     }
17 
18     // Change the owner of the contract
19     function changeOwner(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 // Functions for safe operation with input values (subtraction and addition)
25 library SafeMath {
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 // ERC20 interface https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39 contract ERC20 {
40     uint256 public totalSupply;
41     function balanceOf(address who) public constant returns (uint256 balance);
42     function allowance(address owner, address spender) public constant returns (uint256 remaining);
43     function transfer(address to, uint256 value) public returns (bool success);
44     function transferFrom(address from, address to, uint256 value) public returns (bool success);
45     function approve(address spender, uint256 value) public returns (bool success);
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 
52 contract AdvancedToken is ERC20, owned {
53     using SafeMath for uint256;
54 
55     // Stores the balances of all holders of the tokens, including the owner of the contract
56     mapping (address => uint256) internal balances;
57 
58     // The event informs that N tokens have been destroyed
59     event Burn(address indexed from, uint256 value);
60 
61     // Creates the required number of tokens on the specified account
62     function mintTokens(address _who, uint256 amount) internal returns(bool) {
63         require(_who != address(0));
64         totalSupply = totalSupply.add(amount);
65         balances[_who] = balances[_who].add(amount);
66         Transfer(this, _who, amount);
67         return true;
68     }
69 
70     // Burns tokens on the contract, without affecting the token holders and the owner of the contract
71     function burnTokens(uint256 _value) public onlyOwner {
72         require(balances[this] > 0);
73         balances[this] = balances[this].sub(_value);
74         totalSupply = totalSupply.sub(_value);
75         Burn(this, _value);
76     }
77 
78     // Withdraws tokens from the contract if they accidentally or on purpose was it placed there
79     function withdrawTokens(uint256 _value) public onlyOwner {
80         require(balances[this] > 0 && balances[this] >= _value);
81         balances[this] = balances[this].sub(_value);
82         balances[msg.sender] = balances[msg.sender].add(_value);
83         Transfer(this, msg.sender, _value);
84     }
85 
86     // Withdraws all the ether from the contract to the owner account
87     function withdrawEther(uint256 _value) public onlyOwner {
88         require(this.balance >= _value);
89         owner.transfer(_value);
90     }
91 }
92 
93 contract ICO is AdvancedToken {
94     using SafeMath for uint256;
95 
96     enum State { Presale, waitingForICO, ICO, Active }
97     State public contract_state = State.Presale;
98 
99     uint256 private startTime;
100     uint256 private presaleMaxSupply;
101     uint256 private marketMaxSupply;
102 
103     event NewState(State state);
104 
105     // Purchasing tokens is only allowed for Presale and ICO contract states
106     modifier crowdsaleState {
107         require(contract_state == State.Presale || contract_state == State.ICO);
108         _;
109     }
110 
111     // Call functions transfer transferFrom and approve, is only allowed with Active state of the contract
112     modifier activeState {
113         require(contract_state == State.Active);
114         _;
115     }
116 
117     // The initialization values when the contract has been mined to the blockchain
118     function ICO() internal {
119         // For the tests replace 1512482400 to "now"
120         startTime = 1512482400; // 05 dec 2017 9:00AM EST (Tue, 05 Dec 2017 14:00:00 GMT)
121         presaleMaxSupply = 190000000 * 1 ether;
122         marketMaxSupply = 1260000000 * 1 ether;
123     }
124 
125     // The function of purchasing tokens
126     function () private payable crowdsaleState {
127         require(msg.value >= 0.01 ether);
128         require(now >= startTime);
129         uint256 currentMaxSupply;
130         uint256 tokensPerEther = 46500;
131         uint256 _tokens = tokensPerEther * msg.value;
132         uint256 bonus = 0;
133 
134         // PRE-SALE calculation of bonuses
135         if (contract_state == State.Presale) {
136             // PRE-SALE supply limit
137             currentMaxSupply = presaleMaxSupply;
138             // For the tests replace days to minutes
139             if (now <= startTime + 1 days) {
140                 bonus = 25;
141             } else if (now <= startTime + 2 days) {
142                 bonus = 20;
143             } else if (now <= startTime + 3 days) {
144                 bonus = 15;
145             } else if (now <= startTime + 4 days) {
146                 bonus = 10;
147             } else if (now <= startTime + 5 days) {
148                 bonus = 7;
149             } else if (now <= startTime + 6 days) {
150                 bonus = 5;
151             } else if (now <= startTime + 7 days) {
152                 bonus = 3;
153             }
154         // ICO supply limit
155         } else {
156             currentMaxSupply = marketMaxSupply;
157         }
158 
159         _tokens += _tokens * bonus / 100;
160         uint256 restTokens = currentMaxSupply - totalSupply;
161         // If supplied tokens more that the rest of the tokens, will refund the excess ether
162         if (_tokens > restTokens) {
163             uint256 bonusTokens = restTokens - restTokens / (100 + bonus) * 100;
164             // The wei that the investor will spend for this purchase
165             uint256 spentWei = (restTokens - bonusTokens) / tokensPerEther;
166             // Verify that not return more than the incoming ether
167             assert(spentWei < msg.value);
168             // Will refund extra ether
169             msg.sender.transfer(msg.value - spentWei);
170             _tokens = restTokens;
171         }
172         mintTokens(msg.sender, _tokens);
173     }
174 
175     // Finish the PRE-SALE period, is required the Presale state of the contract
176     function finishPresale() public onlyOwner returns (bool success) {
177         require(contract_state == State.Presale);
178         contract_state = State.waitingForICO;
179         NewState(contract_state);
180         return true;
181     }
182 
183     // Start the ICO period, is required the waitingForICO state of the contract
184     function startICO() public onlyOwner returns (bool success) {
185         require(contract_state == State.waitingForICO);
186         contract_state = State.ICO;
187         NewState(contract_state);
188         return true;
189     }
190 
191     // Finish the ICO and supply 40% share for the contract owner, is required the ICO state of the contract
192     // For example if we sold 6 tokens (60%), so we need to calculate the share of 40%, by the next formula:
193     // 6 / 60 * 40 = 4 tokens (40%) -> 6 + 4 = 10 (100%) and change the contract state to Active
194     // to open the access to the functions 1, 2, 3
195     function finishICO() public onlyOwner returns (bool success) {
196         require(contract_state == State.ICO);
197         mintTokens(owner, (totalSupply / 60) * 40);
198         contract_state = State.Active;
199         NewState(contract_state);
200         return true;
201     }
202 }
203 
204 // See ERC20 interface above
205 contract Rexpax is ICO {
206     using SafeMath for uint256;
207 
208     string public constant name     = "Rexpax";
209     string public constant symbol   = "REXX";
210     uint8  public constant decimals = 18;
211 
212     mapping (address => mapping (address => uint256)) private allowed;
213 
214     function balanceOf(address _who) public constant returns (uint256 available) {
215         return balances[_who];
216     }
217 
218     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
219         return allowed[_owner][_spender];
220     }
221 
222     function transfer(address _to, uint256 _value) public activeState returns (bool success) {
223         require(_to != address(0));
224         require(balances[msg.sender] >= _value);
225         balances[msg.sender] = balances[msg.sender].sub(_value);
226         balances[_to] = balances[_to].add(_value);
227         Transfer(msg.sender, _to, _value);
228         return true;
229     }
230 
231     function transferFrom(address _from, address _to, uint256 _value) public activeState returns (bool success) {
232         require(_to != address(0));
233         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
234         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235         balances[_from] = balances[_from].sub(_value);
236         balances[_to] = balances[_to].add(_value);
237         Transfer(_from, _to, _value);
238         return true;
239     }
240 
241     function approve(address _spender, uint256 _value) public activeState returns (bool success) {
242         require(_spender != address(0));
243         require(balances[msg.sender] >= _value);
244         allowed[msg.sender][_spender] = _value;
245         Approval(msg.sender, _spender, _value);
246         return true;
247     }
248 }