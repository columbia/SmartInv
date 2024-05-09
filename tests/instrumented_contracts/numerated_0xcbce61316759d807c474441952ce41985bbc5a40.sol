1 pragma solidity ^0.4.11;
2 
3 /**
4  * ERC 20 token
5  *
6  * https://github.com/ethereum/EIPs/issues/20
7  */
8 contract MoacToken  {
9     function balanceOf(address _owner) constant returns (uint256 balance) {
10         return balances[_owner];
11     }
12 
13     function approve(address _spender, uint256 _value) returns (bool success) {
14         allowed[msg.sender][_spender] = _value;
15         Approval(msg.sender, _spender, _value);
16         return true;
17     }
18 
19     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
20       return allowed[_owner][_spender];
21     }
22 
23     mapping(address => uint256) balances;
24     mapping(address => uint256) redeem;
25     mapping (address => mapping (address => uint256)) allowed;
26 
27     uint256 public totalSupply;
28     string public name = "MoacToken Token";
29     string public symbol = "MOAC";
30     uint public decimals = 18;
31 
32     uint public startBlock; //crowdsale start block (set in constructor)
33     uint public endBlock; //crowdsale end block (set in constructor)
34 
35     address public founder = 0x0;
36     address public owner = 0x0;
37 
38     // signer address 
39     address public signer = 0x0;
40 
41     // price is defined by levels
42     uint256 public levelOneTokenNum = 30000000 * 10**18; //first level 
43     uint256 public levelTwoTokenNum = 50000000 * 10**18; //second level 
44     uint256 public levelThreeTokenNum = 75000000 * 10**18; //third level 
45     uint256 public levelFourTokenNum = 100000000 * 10**18; //fourth level 
46     
47     //max amount raised during crowdsale
48     uint256 public etherCap = 1000000 * 10**18;  
49     uint public transferLockup = 370285; 
50     uint public founderLockup = 86400; 
51     
52     uint256 public founderAllocation = 100 * 10**16; 
53     bool public founderAllocated = false; 
54 
55     uint256 public saleTokenSupply = 0; 
56     uint256 public saleEtherRaised = 0; 
57     bool public halted = false; 
58 
59     event Donate(uint256 eth, uint256 fbt);
60     event AllocateFounderTokens(address indexed sender);
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63     event print(bytes32 msg);
64 
65     function MoacToken(address founderInput, address signerInput, uint startBlockInput, uint endBlockInput) {
66         founder = founderInput;
67         signer = signerInput;
68         startBlock = startBlockInput;
69         endBlock = endBlockInput;
70         owner = msg.sender;
71     }
72 
73     //price based on current token supply
74     function price() constant returns(uint256) {
75         if (totalSupply<levelOneTokenNum) return 1600;
76         if (totalSupply>=levelOneTokenNum && totalSupply < levelTwoTokenNum) return 1000;
77         if (totalSupply>=levelTwoTokenNum && totalSupply < levelThreeTokenNum) return 800;
78         if (totalSupply>=levelThreeTokenNum && totalSupply < levelFourTokenNum) return 730;
79         if (totalSupply>=levelFourTokenNum) return 680;
80         return 1600;
81     }
82 
83     // price() exposed for unit tests
84     function testPrice(uint256 currentSupply) constant returns(uint256) {
85         if (currentSupply<levelOneTokenNum) return 1600;
86         if (currentSupply>=levelOneTokenNum && currentSupply < levelTwoTokenNum) return 1000;
87         if (currentSupply>=levelTwoTokenNum && currentSupply < levelThreeTokenNum) return 800;
88         if (currentSupply>=levelThreeTokenNum && currentSupply < levelFourTokenNum) return 730;
89         if (currentSupply>=levelFourTokenNum) return 680;
90         return 1600;
91     }
92 
93 
94     // Donate entry point
95     function donate( bytes32 hash) payable {
96         print(hash);
97         if (block.number<startBlock || block.number>endBlock || (saleEtherRaised + msg.value)>etherCap || halted) throw;
98         uint256 tokens = (msg.value * price());
99         balances[msg.sender] = (balances[msg.sender] + tokens);
100         totalSupply = (totalSupply + tokens);
101         saleEtherRaised = (saleEtherRaised + msg.value);
102         //immediately send Ether to founder address
103         if (!founder.call.value(msg.value)()) throw; 
104         Donate(msg.value, tokens);
105     }
106 
107     /**
108      * Set up founder address token balance.
109      */
110     function allocateFounderTokens() {
111         if (msg.sender!=founder) throw;
112         if (block.number <= endBlock + founderLockup) throw;
113         if (founderAllocated) throw;
114         balances[founder] = (balances[founder] + saleTokenSupply * founderAllocation / (1 ether));
115         totalSupply = (totalSupply + saleTokenSupply * founderAllocation / (1 ether));
116         founderAllocated = true;
117         AllocateFounderTokens(msg.sender);
118     }
119 
120     /**
121      * For offline donation, executed by signer only. only available during the sale
122      */
123     function offlineDonate(uint256 offlineTokenNum, uint256 offlineEther) {
124         if (msg.sender!=signer) throw;
125         if (block.number >= endBlock) throw; //offline can be done only before end block
126         
127         //check if overflow
128         if( (totalSupply +offlineTokenNum) > totalSupply && (saleEtherRaised + offlineEther)>saleEtherRaised){
129             totalSupply = (totalSupply + offlineTokenNum);
130             balances[founder] = (balances[founder] + offlineTokenNum );
131             saleEtherRaised = (saleEtherRaised + offlineEther);
132         }
133     }
134 
135 
136     /** 
137      * emergency adjust if incorrectly set by signer, only available during the sale
138      */
139     function offlineAdjust(uint256 offlineTokenNum, uint256 offlineEther) {
140         if (msg.sender!=founder) throw;
141         if (block.number >= endBlock) throw; //offline can be done only before end block
142         
143         //check if overflow
144         if( (totalSupply - offlineTokenNum) > 0 && (saleEtherRaised - offlineEther) > 0 && (balances[founder] - offlineTokenNum)>0){
145             totalSupply = (totalSupply - offlineTokenNum);
146             balances[founder] = (balances[founder] - offlineTokenNum );
147             saleEtherRaised = (saleEtherRaised - offlineEther);
148         }
149     }
150 
151 
152     //check for redeemed balance
153     function redeemBalanceOf(address _owner) constant returns (uint256 balance) {
154         return redeem[_owner];
155     }
156 
157     /**
158      * redeem token in MOAC network
159      */
160     function redeemToken(uint256 tokenNum) {
161         if (block.number <= (endBlock + transferLockup) && msg.sender!=founder) throw; 
162         if( balances[msg.sender] < tokenNum ) throw;
163         balances[msg.sender] = (balances[msg.sender] - tokenNum );
164         redeem[msg.sender] += tokenNum;
165     }
166 
167     /**
168      * restore redeemed back to user, only founder can do, if user made an error
169      */
170     function redeemRestore(address _to, uint256 tokenNum){
171         if( msg.sender != founder) throw;
172         if( redeem[_to] < tokenNum ) throw;
173 
174         redeem[_to] -= tokenNum;
175         balances[_to] += tokenNum;
176     }
177 
178 
179     /**
180      * Emergency Stop ICO.
181      */
182     function halt() {
183         if (msg.sender!=founder) throw;
184         halted = true;
185     }
186 
187     function unhalt() {
188         if (msg.sender!=founder) throw;
189         halted = false;
190     }
191 
192     // only owner can kill
193     function kill() { 
194         if (msg.sender == owner) suicide(owner); 
195     }
196 
197 
198     /**
199      * Change founder address (where ICO ETH is being forwarded).
200      */
201     function changeFounder(address newFounder) {
202         if (msg.sender!=founder) throw;
203         founder = newFounder;
204     }
205 
206     /**
207      * ERC 20 Standard Token interface transfer function
208      */
209     function transfer(address _to, uint256 _value) returns (bool success) {
210         if (block.number <= (endBlock + transferLockup) && msg.sender!=founder) throw;
211 
212         //Default assumes totalSupply can't be over max (2^256 - 1).
213         if (balances[msg.sender] >= _value && (balances[_to] + _value) > balances[_to]) {
214             balances[msg.sender] -= _value;
215             balances[_to] += _value;
216             Transfer(msg.sender, _to, _value);
217             return true;
218         } else { return false; }
219 
220     }
221 
222     /**
223      * ERC 20 Standard Token interface transfer function
224      */
225     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
226         if (block.number <= (endBlock + transferLockup) && msg.sender!=founder) throw;
227 
228         //same as above. Replace this line with the following if you want to protect against wrapping uints.
229         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && (balances[_to] + _value) > balances[_to]) {
230             balances[_to] += _value;
231             balances[_from] -= _value;
232             allowed[_from][msg.sender] -= _value;
233             Transfer(_from, _to, _value);
234             return true;
235         } else { return false; }
236     }
237 
238     /**
239      * Do not allow direct deposits.
240      *
241      * All crowdsale depositors must have read the legal agreement.
242      * This is confirmed by having them signing the terms of service on the website.
243      * The give their crowdsale Ethereum source address on the website.
244      * donate() takes data as input and rejects all deposits that do not have
245      * signature you receive after reading terms of service.
246      *
247      */
248     function() {
249         throw;
250     }
251 
252 }