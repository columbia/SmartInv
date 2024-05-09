1 pragma solidity ^0.4.18;
2 
3 // SafeMath
4 contract SafeMath {
5     function safeMul(uint a, uint b) internal pure returns (uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeSub(uint a, uint b) internal pure returns (uint) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     function safeAdd(uint a, uint b) internal pure returns (uint) {
17         uint c = a + b;
18         assert(c >= a && c >= b);
19         return c;
20     }
21 }
22 
23 // Standard token interface (ERC 20)
24 // https://github.com/ethereum/EIPs/issues/20
25 // Token
26 contract Token is SafeMath {
27     // Functions:
28     /// @return total amount of tokens
29     function totalSupply() public constant returns (uint256 supply);
30 
31     /// @param _owner The address from which the balance will be retrieved
32     /// @return The balance
33     function balanceOf(address _owner) public constant returns (uint256 balance);
34 
35     /// @notice send `_value` token to `_to` from `msg.sender`
36     /// @param _to The address of the recipient
37     /// @param _value The amount of token to be transferred
38     function transferTo(address _to, uint256 _value) public returns (bool);
39 
40     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
41     /// @param _from The address of the sender
42     /// @param _to The address of the recipient
43     /// @param _value The amount of token to be transferred
44     /// @return Whether the transfer was successful or not
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
46 
47     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @param _value The amount of wei to be approved for transfer
50     /// @return Whether the approval was successful or not
51     function approve(address _spender, uint256 _value) public returns (bool success);
52 
53     /// @param _owner The address of the account owning tokens
54     /// @param _spender The address of the account able to transfer the tokens
55     /// @return Amount of remaining tokens allowed to spent
56     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
57 
58     // Events:
59     event Transfer(address indexed _from, address indexed _to, uint256 _value);
60     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61 }
62 //StdToken
63 contract StdToken is Token {
64     // Fields:
65     mapping(address => uint256) balances;
66     mapping(address => mapping(address => uint256)) allowed;
67     uint public supply = 0;
68 
69     // Functions:
70     function transferTo(address _to, uint256 _value) public returns (bool) {
71         require(balances[msg.sender] >= _value);
72         require(balances[_to] + _value > balances[_to]);
73 
74         balances[msg.sender] = safeSub(balances[msg.sender], _value);
75         balances[_to] = safeAdd(balances[_to], _value);
76 
77         Transfer(msg.sender, _to, _value);
78         return true;
79     }
80 
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
82         require(balances[_from] >= _value);
83         require(allowed[_from][msg.sender] >= _value);
84         require(balances[_to] + _value > balances[_to]);
85 
86         balances[_to] = safeAdd(balances[_to], _value);
87         balances[_from] = safeSub(balances[_from], _value);
88         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
89 
90         Transfer(_from, _to, _value);
91         return true;
92     }
93 
94     function totalSupply() public constant returns (uint256) {
95         return supply;
96     }
97 
98     function balanceOf(address _owner) public constant returns (uint256) {
99         return balances[_owner];
100     }
101 
102     function approve(address _spender, uint256 _value) public returns (bool) {
103         // To change the approve amount you first have to reduce the addresses`
104         //  allowance to zero by calling `approve(_spender, 0)` if it is not
105         //  already 0 to mitigate the race condition described here:
106         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
108 
109         allowed[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111 
112         return true;
113     }
114 
115     function allowance(address _owner, address _spender) public constant returns (uint256) {
116         return allowed[_owner][_spender];
117     }
118 }
119 // EvoNineToken
120 contract EvoNineToken is StdToken
121 {
122     /// Fields:
123     string public name = "";
124     string public symbol = "EVG";
125     string public website = "https://evonine.co";
126     uint public decimals = 18;
127 
128     uint public constant TOTAL_SUPPLY = 19000000 * (1 ether / 1 wei);
129     uint public constant DEVELOPER_BONUS = 4500000 * (1 ether / 1 wei);
130     uint public constant TEAM_BONUS = 3800000 * (1 ether / 1 wei);
131     uint public constant ECO_SYSTEM_BONUS = 5700000 * (1 ether / 1 wei);
132     uint public constant CONTRACT_HOLDER_BONUS = 5000000 * (1 ether / 1 wei);
133 
134     uint public constant ICO_PRICE1 = 2000;     // per 1 Ether
135     uint public constant ICO_PRICE2 = 1818;     // per 1 Ether
136     uint public constant ICO_PRICE3 = 1666;     // per 1 Ether
137     uint public constant ICO_PRICE4 = 1538;     // per 1 Ether
138     uint public constant ICO_PRICE5 = 1250;     // per 1 Ether
139     uint public constant ICO_PRICE6 = 1000;     // per 1 Ether
140     uint public constant ICO_PRICE7 = 800;     // per 1 Ether
141     uint public constant ICO_PRICE8 = 666;     // per 1 Ether
142 
143     enum State{
144         Init,
145         Paused,
146         ICORunning,
147         ICOFinished
148     }
149 
150     State public currentState = State.Init;
151     bool public enableTransfers = true;
152 
153     // Token manager has exclusive priveleges to call administrative
154     // functions on this contract.
155     address public tokenManagerAddress = 0;
156 
157     // Gathered funds can be withdrawn only to escrow's address.
158     address public escrowAddress = 0;
159 
160     // Team bonus address
161     address public teamAddress = 0;
162 
163     // Development holder address
164     address public developmentAddress = 0;
165 
166     // Eco system holder address
167     address public ecoSystemAddress = 0;
168 
169     // Contract holder address
170     address public contractHolderAddress = 0;
171 
172 
173     uint public icoSoldTokens = 0;
174     uint public totalSoldTokens = 0;
175 
176     /// Modifiers:
177     modifier onlytokenManagerAddress()
178     {
179         require(msg.sender == tokenManagerAddress);
180         _;
181     }
182 
183     modifier onlyTokenCrowner()
184     {
185         require(msg.sender == escrowAddress);
186         _;
187     }
188 
189     modifier onlyInState(State state)
190     {
191         require(state == currentState);
192         _;
193     }
194 
195     /// Events:
196     event LogBuy(address indexed owner, uint value);
197     event LogBurn(address indexed owner, uint value);
198 
199     /// Functions:
200     /// @dev Constructor
201     /// @param _tokenManagerAddress Token manager address: 0x911AA92E796b10A2c79049FbACA219875a7fd1c9
202     /// @param _escrowAddress Escrow address: 0x14522Ed2EcecA9059e5EC2700C3A715CF7d5b69e
203     /// @param _teamAddress Team address: 0xfB03a82b11E0BB61f2DFA4eDcFadd6A841eD1496
204     /// @param _developmentAddress Development address: 0x0814288347dA7fbA44a6ecEBD5Be2dCeDe035D91
205     /// @param _ecoSystemAddress Eco system address: 0x0230a2b2F79274014E7FC71aD04c22188908F69B
206     /// @param _contractHolderAddress Contract holder address: 0x4E8eC6420e529819b5A2cD477A083E5459d7A566
207     function EvoNineToken(string _name, address _tokenManagerAddress, address _escrowAddress, address _teamAddress, address _developmentAddress, address _ecoSystemAddress, address _contractHolderAddress) public
208     {
209         name = _name;
210         tokenManagerAddress = _tokenManagerAddress;
211         escrowAddress = _escrowAddress;
212         teamAddress = _teamAddress;
213         developmentAddress = _developmentAddress;
214         ecoSystemAddress = _ecoSystemAddress;
215         contractHolderAddress = _contractHolderAddress;
216 
217         balances[_contractHolderAddress] += TOTAL_SUPPLY;
218         supply += TOTAL_SUPPLY;
219     }
220 
221     function buyTokens() public payable returns (uint256)
222     {
223         require(msg.value >= ((1 ether / 1 wei) / 100));
224         uint newTokens = msg.value * getPrice();
225         balances[msg.sender] += newTokens;
226         supply += newTokens;
227         icoSoldTokens += newTokens;
228         totalSoldTokens += newTokens;
229 
230         LogBuy(msg.sender, newTokens);
231     }
232 
233     function getPrice() public constant returns (uint)
234     {
235         if (icoSoldTokens < (4100000 * (1 ether / 1 wei))) {
236             return ICO_PRICE1;
237         }
238         if (icoSoldTokens < (4300000 * (1 ether / 1 wei))) {
239             return ICO_PRICE2;
240         }
241         if (icoSoldTokens < (4700000 * (1 ether / 1 wei))) {
242             return ICO_PRICE3;
243         }
244         if (icoSoldTokens < (5200000 * (1 ether / 1 wei))) {
245             return ICO_PRICE4;
246         }
247         if (icoSoldTokens < (6000000 * (1 ether / 1 wei))) {
248             return ICO_PRICE5;
249         }
250         if (icoSoldTokens < (7000000 * (1 ether / 1 wei))) {
251             return ICO_PRICE6;
252         }
253         if (icoSoldTokens < (8000000 * (1 ether / 1 wei))) {
254             return ICO_PRICE7;
255         }
256         return ICO_PRICE8;
257     }
258 
259     function setState(State _nextState) public onlytokenManagerAddress
260     {
261         //setState() method call shouldn't be entertained after ICOFinished
262         require(currentState != State.ICOFinished);
263 
264         currentState = _nextState;
265         // enable/disable transfers
266         //enable transfers only after ICOFinished, disable otherwise
267         //enableTransfers = (currentState==State.ICOFinished);
268     }
269 
270     function DisableTransfer() public onlytokenManagerAddress
271     {
272         enableTransfers = false;
273     }
274 
275 
276     function EnableTransfer() public onlytokenManagerAddress
277     {
278         enableTransfers = true;
279     }
280 
281     function withdrawEther() public onlytokenManagerAddress
282     {
283         if (this.balance > 0)
284         {
285             escrowAddress.transfer(this.balance);
286         }
287     }
288 
289     /// Overrides:
290     function transferTo(address _to, uint256 _value) public returns (bool){
291         require(enableTransfers);
292         return super.transferTo(_to, _value);
293     }
294 
295     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
296         require(enableTransfers);
297         return super.transferFrom(_from, _to, _value);
298     }
299 
300     function approve(address _spender, uint256 _value) public returns (bool) {
301         require(enableTransfers);
302         return super.approve(_spender, _value);
303     }
304 
305     // Setters/getters
306     function ChangetokenManagerAddress(address _mgr) public onlytokenManagerAddress
307     {
308         tokenManagerAddress = _mgr;
309     }
310 
311     // Setters/getters
312     function ChangeCrowner(address _mgr) public onlyTokenCrowner
313     {
314         escrowAddress = _mgr;
315     }
316 }