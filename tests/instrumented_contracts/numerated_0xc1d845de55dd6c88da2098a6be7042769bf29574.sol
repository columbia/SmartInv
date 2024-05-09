1 pragma solidity ^ 0.4 .13;
2 
3 contract SafeMath {
4     function safeMul(uint a, uint b) internal returns(uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeDiv(uint a, uint b) internal returns(uint) {
11         assert(b > 0);
12         uint c = a / b;
13         assert(a == b * c + a % b);
14         return c;
15     }
16 
17     function safeSub(uint a, uint b) internal returns(uint) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function safeAdd(uint a, uint b) internal returns(uint) {
23         uint c = a + b;
24         assert(c >= a && c >= b);
25         return c;
26     }
27 
28     function assert(bool assertion) internal {
29         if (!assertion) {
30             revert();
31         }
32     }
33 }
34 
35 
36 
37 
38 contract Ownable {
39     address public owner;
40 
41     function Ownable() {
42         owner = msg.sender;
43     }
44 
45     function transferOwnership(address newOwner) onlyOwner {
46         if (newOwner != address(0)) owner = newOwner;
47     }
48 
49     function kill() {
50         if (msg.sender == owner) selfdestruct(owner);
51     }
52 
53     modifier onlyOwner() {
54         if (msg.sender != owner) revert();
55             _;
56     }
57 }
58 
59 contract Pausable is Ownable {
60     bool public stopped;
61 
62     modifier stopInEmergency {
63         if (stopped) {
64             revert();
65         }
66         _;
67     }
68 
69     modifier onlyInEmergency {
70         if (!stopped) {
71             revert();
72         }
73         _;
74     }
75 
76     // Called by the owner in emergency, triggers stopped state
77     function emergencyStop() external onlyOwner {
78         stopped = true;
79     }
80 
81     // Called by the owner to end of emergency, returns to normal state
82     function release() external onlyOwner onlyInEmergency {
83         stopped = false;
84     }
85 }
86 
87 
88 
89 
90 // Presale Smart Contract
91 // This smart contract collects ETH during presale. Tokens are not distributed during
92 // this time. Only informatoion stored how much tokens should be allocated in the future.
93 contract Presale is SafeMath, Pausable {
94 
95     struct Backer {
96         uint weiReceived;   // amount of ETH contributed
97         uint SOCXSent;      // amount of tokens to be sent
98         bool processed;     // true if tokens transffered.
99     }
100     
101     address public multisigETH; // Multisig contract that will receive the ETH    
102     uint public ETHReceived;    // Number of ETH received
103     uint public SOCXSentToETH;  // Number of SOCX sent to ETH contributors
104     uint public startBlock;     // Presale start block
105     uint public endBlock;       // Presale end block
106 
107     uint public minContributeETH;// Minimum amount to contribute
108     bool public presaleClosed;  // Is presale still on going
109     uint public maxCap;         // Maximum number of SOCX to sell
110 
111     uint totalTokensSold;       // tokens sold during the campaign
112     uint tokenPriceWei;         // price of tokens in Wei
113 
114 
115     uint multiplier = 10000000000;              // to provide 10 decimal values
116     mapping(address => Backer) public backers;  // backer list accessible through address
117     address[] public backersIndex;              // order list of backer to be able to itarate through when distributing the tokens. 
118 
119 
120     // @notice to be used when certain account is required to access the function
121     // @param a {address}  The address of the authorised individual
122     modifier onlyBy(address a) {
123         if (msg.sender != a) revert();
124         _;
125     }
126 
127     // @notice to verify if action is not performed out of the campaing time range
128     modifier respectTimeFrame() {
129         if ((block.number < startBlock) || (block.number > endBlock)) revert();
130         _;
131     }
132 
133 
134 
135     // Events
136     event ReceivedETH(address backer, uint amount, uint tokenAmount);
137 
138 
139 
140     // Presale  {constructor}
141     // @notice fired when contract is crated. Initilizes all constnat variables.
142     function Presale() {     
143            
144         multisigETH = 0x7bf08cb1732e1246c65b51b83ac092f9b4ebb8c6; //TODO: Replace address with correct one
145         maxCap = 2000000 * multiplier;  // max amount of tokens to be sold
146         SOCXSentToETH = 0;              // tokens sold so far
147         minContributeETH = 1 ether;     // minimum contribution acceptable
148         startBlock = 0;                 // start block of the campaign, it will be set in start() function
149         endBlock = 0;                   // end block of the campaign, it will be set in start() function 
150         tokenPriceWei = 720000000000000;// price of token expressed in Wei 
151     }
152 
153     // @notice to obtain number of contributors so later "front end" can loop through backersIndex and 
154     // triggger transfer of tokens
155     // @return  {uint} true if transaction was successful
156     function numberOfBackers() constant returns(uint) {
157         return backersIndex.length;
158     }
159 
160     function updateMultiSig(address _multisigETH) onlyBy(owner) {
161         multisigETH = _multisigETH;
162     }
163 
164 
165     // {fallback function}
166     // @notice It will call internal function which handels allocation of Ether and calculates SOCX tokens.
167     function () payable {
168         if (block.number > endBlock) revert();
169         handleETH(msg.sender);
170     }
171 
172     // @notice It will be called by owner to start the sale
173     // TODO WARNING REMOVE _block parameter and _block variable in function
174     function start() onlyBy(owner) {
175         startBlock = block.number;        
176         endBlock = startBlock + 57600;
177         // 10 days in blocks = 57600 (4*60*24*10)
178         // enable this for live assuming each bloc takes 15 sec.
179     }
180 
181     // @notice called to mark contributer when tokens are transfered to them after ICO
182     // @param _backer {address} address of beneficiary
183     function process(address _backer) onlyBy(owner) returns (bool){
184 
185         Backer storage backer = backers[_backer]; 
186         backer.processed = true;
187 
188         return true;
189     }
190 
191     // @notice It will be called by fallback function whenever ether is sent to it
192     // @param  _backer {address} address of beneficiary
193     // @return res {bool} true if transaction was successful
194     function handleETH(address _backer) internal stopInEmergency respectTimeFrame returns(bool res) {
195 
196         if (msg.value < minContributeETH) revert();                     // stop when required minimum is not sent
197         uint SOCXToSend = (msg.value / tokenPriceWei) * multiplier; // calculate number of tokens
198 
199         
200         if (safeAdd(SOCXSentToETH, SOCXToSend) > maxCap) revert();  // ensure that max cap hasn't been reached yet
201 
202         Backer storage backer = backers[_backer];                   // access backer record
203         backer.SOCXSent = safeAdd(backer.SOCXSent, SOCXToSend);     // calculate number of tokens sent by backer
204         backer.weiReceived = safeAdd(backer.weiReceived, msg.value);// store amount of Ether received in Wei
205         ETHReceived = safeAdd(ETHReceived, msg.value);              // update the total Ether recived
206         SOCXSentToETH = safeAdd(SOCXSentToETH, SOCXToSend);         // keep total number of tokens sold
207         backersIndex.push(_backer);                                 // maintain iterable storage of contributors
208 
209         ReceivedETH(_backer, msg.value, SOCXToSend);                // register event
210         return true;
211     }
212 
213 
214 
215     // @notice This function will finalize the sale.
216     // It will only execute if predetermined sale time passed 
217     // if successfull it will transfer collected Ether into predetermined multisig wallet or address
218     function finalize() onlyBy(owner) {
219 
220         if (block.number < endBlock && SOCXSentToETH < maxCap) revert();
221 
222         if (!multisigETH.send(this.balance)) revert();
223         presaleClosed = true;
224 
225     }
226 
227     
228     // @notice Failsafe drain
229     // in case finalize failes, we need guaranteed way to transfer Ether out of this contract. 
230     function drain() onlyBy(owner) {
231         if (!owner.send(this.balance)) revert();
232     }
233 
234 }