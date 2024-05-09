1 /*
2 This file is part of the eHealth First Contract.
3 
4 www.ehfirst.io
5 
6 An IT-platform for Personalized Health and Longevity Management
7 based on Blockchain, Artificial Intelligence,
8 Machine Learning and Natural Language Processing
9 
10 The eHealth First Contract is free software: you can redistribute it and/or
11 modify it under the terms of the GNU lesser General Public License as published
12 by the Free Software Foundation, either version 3 of the License, or
13 (at your option) any later version.
14 
15 The eHealth First Contract is distributed in the hope that it will be useful,
16 but WITHOUT ANY WARRANTY; without even the implied warranty of
17 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
18 GNU lesser General Public License for more details.
19 
20 You should have received a copy of the GNU lesser General Public License
21 along with the eHealth First Contract. If not, see <http://www.gnu.org/licenses/>.
22 
23 @author Ilya Svirin <i.svirin@prover.ru>
24 
25 IF YOU ARE ENJOYED IT DONATE TO 0x3Ad38D1060d1c350aF29685B2b8Ec3eDE527452B ! :)
26 */
27 
28 
29 pragma solidity ^0.4.19;
30 
31 contract owned {
32 
33     address public owner;
34     address public candidate;
35 
36   function owned() public payable {
37          owner = msg.sender;
38      }
39     
40     modifier onlyOwner {
41         require(owner == msg.sender);
42         _;
43     }
44 
45     function changeOwner(address _owner) onlyOwner public {
46         require(_owner != 0);
47         candidate = _owner;
48     }
49     
50     function confirmOwner() public {
51         require(candidate == msg.sender);
52         owner = candidate;
53         delete candidate;
54     }
55 }
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 {
62     uint public totalSupply;
63     function balanceOf(address who) public constant returns (uint);
64     function transfer(address to, uint value) public;
65     function allowance(address owner, address spender) public constant returns (uint);
66     function transferFrom(address from, address to, uint value) public;
67     function approve(address spender, uint value) public;
68     event Approval(address indexed owner, address indexed spender, uint value);
69     event Transfer(address indexed from, address indexed to, uint value);
70 }
71 
72 contract Token is owned, ERC20 {
73 
74     string  public standard    = 'Token 0.1';
75     string  public name        = 'eHealth First';
76     string  public symbol      = "EHF";
77     uint8   public decimals    = 8;
78 
79     uint    public freezedMoment;
80 
81     struct TokenHolder {
82         uint balance;
83         uint balanceBeforeUpdate;
84         uint balanceUpdateTime;
85     }
86     mapping (address => TokenHolder) public holders;
87     mapping (address => uint) public vesting;
88     mapping (address => mapping (address => uint256)) public allowed;
89 
90     address public vestingManager;
91 
92     function setVestingManager(address _vestingManager) public onlyOwner {
93         vestingManager = _vestingManager;
94     }
95 
96     function beforeBalanceChanges(address _who) internal {
97         if (holders[_who].balanceUpdateTime <= freezedMoment) {
98             holders[_who].balanceUpdateTime = now;
99             holders[_who].balanceBeforeUpdate = holders[_who].balance;
100         }
101     }
102 
103     event Burned(address indexed owner, uint256 value);
104 
105     function Token() public owned() {}
106 
107     function balanceOf(address _who) constant public returns (uint) {
108         return holders[_who].balance;
109     }
110 
111     function transfer(address _to, uint256 _value) public {
112         require(now > vesting[msg.sender] || msg.sender == vestingManager);
113         require(holders[_to].balance + _value >= holders[_to].balance); // overflow
114         beforeBalanceChanges(msg.sender);
115         beforeBalanceChanges(_to);
116         holders[msg.sender].balance -= _value;
117         holders[_to].balance += _value;
118         if (vesting[_to] < vesting[msg.sender]) {
119             vesting[_to] = vesting[msg.sender];
120         }
121         emit Transfer(msg.sender, _to, _value);
122     }
123     
124     function transferFrom(address _from, address _to, uint256 _value) public {
125         require(now > vesting[_from]);
126         require(holders[_to].balance + _value >= holders[_to].balance); // overflow
127         require(allowed[_from][msg.sender] >= _value);
128         beforeBalanceChanges(_from);
129         beforeBalanceChanges(_to);
130         holders[_from].balance -= _value;
131         holders[_to].balance += _value;
132         allowed[_from][msg.sender] -= _value;
133         emit Transfer(_from, _to, _value);
134     }
135 
136     function approve(address _spender, uint256 _value) public {
137         allowed[msg.sender][_spender] = _value;
138         emit Approval(msg.sender, _spender, _value);
139     }
140 
141     function allowance(address _owner, address _spender) public constant
142         returns (uint256 remaining) {
143         return allowed[_owner][_spender];
144     }
145     
146     function burn(uint256 _value) public {
147         require(holders[msg.sender].balance >= _value);
148         beforeBalanceChanges(msg.sender);
149         holders[msg.sender].balance -= _value;
150         totalSupply -= _value;
151         emit Burned(msg.sender, _value);
152     }
153 }
154 
155 contract Crowdsale is Token {
156 
157     address public backend;
158 
159     uint public stage;
160     bool public started;
161     uint public startTokenPriceWei;
162     uint public tokensForSale;
163     uint public startTime;
164     uint public lastTokenPriceWei;
165     uint public milliPercent; // "25" means 0.25%
166     uint public paymentsCount; // restart on each stage
167     bool public sealed;
168     modifier notSealed {
169         require(sealed == false);
170         _;
171     }
172 
173     event Mint(address indexed _who, uint _tokens, uint _coinType, bytes32 _txHash);
174     event Stage(uint _stage, bool startNotFinish);
175 
176     function Crowdsale() public Token() {
177         totalSupply = 100000000*100000000;
178         holders[this].balance = totalSupply;
179     }
180 
181     function startStage(uint _startTokenPriceWei, uint _tokensForSale, uint _milliPercent) public onlyOwner notSealed {
182         require(!started);
183         require(_startTokenPriceWei >= lastTokenPriceWei);
184         startTokenPriceWei = _startTokenPriceWei;
185         tokensForSale = _tokensForSale * 100000000;
186         if(tokensForSale > holders[this].balance) {
187             tokensForSale = holders[this].balance;
188         }
189         milliPercent = _milliPercent;
190         startTime = now;
191         started = true;
192         paymentsCount = 0;
193         emit Stage(stage, started);
194     }
195     
196     function currentTokenPrice() public constant returns(uint) {
197         uint price;
198         if(!sealed && started) {
199             uint d = (now - startTime) / 1 days;
200             price = startTokenPriceWei;
201             price += startTokenPriceWei * d * milliPercent / 100;
202         }
203         return price;
204     }
205     
206     function stopStage() public onlyOwner notSealed {
207         require(started);
208         started = false;
209         lastTokenPriceWei = currentTokenPrice();
210         emit Stage(stage, started);
211         ++stage;
212     }
213     
214     function () payable public notSealed {
215         require(started);
216         uint price = currentTokenPrice();
217         if(paymentsCount < 100) {
218             price = price * 90 / 100;
219         }
220         ++paymentsCount;
221         uint tokens = 100000000 * msg.value / price;
222         if(tokens > tokensForSale) {
223             tokens = tokensForSale;
224             uint sumWei = tokens * lastTokenPriceWei / 100000000;
225             require(msg.sender.call.gas(3000000).value(msg.value - sumWei)());
226         }
227         require(tokens > 0);
228         require(holders[msg.sender].balance + tokens > holders[msg.sender].balance); // overflow
229         tokensForSale -= tokens;
230         beforeBalanceChanges(msg.sender);
231         beforeBalanceChanges(this);
232         holders[msg.sender].balance += tokens;
233         holders[this].balance -= tokens;
234         emit Transfer(this, msg.sender, tokens);
235     }
236 
237     function mintTokens1(address _who, uint _tokens, uint _coinType, bytes32 _txHash) public notSealed {
238         require(msg.sender == owner || msg.sender == backend);
239         require(started);
240         _tokens *= 100000000;
241         if(_tokens > tokensForSale) {
242             _tokens = tokensForSale;
243         }
244         require(_tokens > 0);
245         require(holders[_who].balance + _tokens > holders[_who].balance); // overflow
246         tokensForSale -= _tokens;
247         beforeBalanceChanges(_who);
248         beforeBalanceChanges(this);
249         holders[_who].balance += _tokens;
250         holders[this].balance -= _tokens;
251         emit Mint(_who, _tokens, _coinType, _txHash);
252         emit Transfer(this, _who, _tokens);
253     }
254     
255     // must be called by owners only out of stage
256     function mintTokens2(address _who, uint _tokens, uint _vesting) public notSealed {
257         require(msg.sender == owner || msg.sender == backend);
258         require(!started);
259         require(_tokens > 0);
260         _tokens *= 100000000;
261         require(_tokens <= holders[this].balance);
262         require(holders[_who].balance + _tokens > holders[_who].balance); // overflow
263         if(_vesting != 0) {
264             vesting[_who] = _vesting;
265         }
266         beforeBalanceChanges(_who);
267         beforeBalanceChanges(this);
268         holders[_who].balance += _tokens;
269         holders[this].balance -= _tokens;
270         emit Mint(_who, _tokens, 0, 0);
271         emit Transfer(this, _who, _tokens);
272     }
273 
274     // need to seal Crowdsale when it is finished completely
275     function seal() public onlyOwner {
276         sealed = true;
277     }
278 }
279 
280 contract Ehfirst is Crowdsale {
281 
282    function Ehfirst() payable public Crowdsale() {}
283 
284     function setBackend(address _backend) public onlyOwner {
285         backend = _backend;
286     }
287     
288     function withdraw() public onlyOwner {
289         require(owner.call.gas(3000000).value(address(this).balance)());
290     }
291     
292     function freezeTheMoment() public onlyOwner {
293         freezedMoment = now;
294     }
295 
296     /** Get balance of _who for freezed moment
297      *  freezeTheMoment()
298      */
299     function freezedBalanceOf(address _who) constant public returns(uint) {
300         if (holders[_who].balanceUpdateTime <= freezedMoment) {
301             return holders[_who].balance;
302         } else {
303             return holders[_who].balanceBeforeUpdate;
304         }
305     }
306 }