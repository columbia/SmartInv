1 pragma solidity ^0.4.0;
2 contract Ownable {
3     address public owner;
4 
5     function Ownable() public { //This call only first time when contract deployed by person
6         owner = msg.sender;
7     }
8     modifier onlyOwner() { //This modifier is for checking owner is calling
9         if (owner == msg.sender) {
10             _;
11         } else {
12             revert();
13         }
14     }
15 }
16 contract Mortal is Ownable {
17     
18     function kill () public {
19         if (msg.sender == owner)
20             selfdestruct(owner);
21     }
22 }
23 contract Token {
24     uint256 public etherRaised = 0;
25     uint256 public totalSupply;
26     uint256 public bountyReserveTokens;
27     uint256 public advisoryReserveTokens;
28     uint256 public teamReserveTokens;
29     uint256 public bountyReserveTokensDistributed = 0;
30     uint256 public advisoryReserveTokensDistributed = 0;
31     uint256 public teamReserveTokensDistributed = 0;
32     uint256 public deadLine = 0;
33     bool public isBurned = false;
34 
35     function balanceOf(address _owner) public constant returns(uint256 balance);
36 
37     function transfer(address _to, uint256 _tokens) public returns(bool resultTransfer);
38 
39     function transferFrom(address _from, address _to, uint256 _tokens, uint256 deadLine_Locked) public returns(bool resultTransfer);
40 
41     function approve(address _spender, uint _value) public returns(bool success);
42 
43     function allowance(address _owner, address _spender) public constant returns(uint remaining);
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint _value);
46     event Burn(address indexed burner, uint256 value);
47 }
48 contract Pausable is Ownable {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54 
55   /**
56    * @dev modifier to allow actions only when the contract IS paused
57    */
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev modifier to allow actions only when the contract IS NOT paused
65    */
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to pause, triggers stopped state
73    */
74   function pause() public onlyOwner whenNotPaused {
75     paused = true;
76     Pause();
77   }
78 
79   /**
80    * @dev called by the owner to unpause, returns to normal state
81    */
82   function unpause() public onlyOwner whenPaused {
83     paused = false;
84     Unpause();
85   }
86 }
87 contract KirkeContract is Token, Mortal, Pausable {
88 
89     function transfer(address _to, uint256 _value) public returns(bool success) {
90         require(_to != 0x0);
91         require(_value > 0);
92         uint256 bonus = 0;
93 
94         uint256 totalTokensToTransfer = _value + bonus;
95 
96         if (balances[msg.sender] >= totalTokensToTransfer) {
97             balances[msg.sender] -= totalTokensToTransfer;
98             balances[_to] += totalTokensToTransfer;
99             Transfer(msg.sender, _to, totalTokensToTransfer);
100             return true;
101         } else {
102             return false;
103         }
104     }
105 
106 
107 
108     function transferFrom(address _from, address _to, uint256 totalTokensToTransfer, uint256 deadLine_Locked) public returns(bool success) {
109         require(_from != 0x0);
110         require(_to != 0x0);
111         require(totalTokensToTransfer > 0);
112         require(now > deadLine_Locked || _from == owner);
113 
114         if (balances[_from] >= totalTokensToTransfer && allowance(_from, _to) >= totalTokensToTransfer) {
115             balances[_to] += totalTokensToTransfer;
116             balances[_from] -= totalTokensToTransfer;
117             allowed[_from][msg.sender] -= totalTokensToTransfer;
118             Transfer(_from, _to, totalTokensToTransfer);
119             return true;
120         } else {
121             return false;
122         }
123     }
124 
125 
126 
127     function balanceOf(address _owner) public constant returns(uint256 balanceOfUser) {
128         return balances[_owner];
129     }
130 
131     function approve(address _spender, uint256 _value) public returns(bool success) {
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
138         return allowed[_owner][_spender];
139     }
140 
141     mapping(address => uint256) balances;
142     mapping(address => mapping(address => uint256)) allowed;
143 }
144 contract Kirke is KirkeContract{
145     string public constant name = "Kirke";
146     uint8 public constant decimals = 18;
147     string public constant symbol = "KIK";
148     uint256 rateForToken;
149     bool public isPaused;
150     uint256 firstBonusEstimate;
151     uint256 secondBonusEstimate;
152     uint256 thirdBonusEstimate;
153     uint256 fourthBonusEstimate;
154     uint256 firstBonusPriceRate;
155     uint256 secondBonusPriceRate;
156     uint256 thirdBonusPriceRate;
157     uint256 fourthBonusPriceRate;
158     uint256 tokensDistributed;
159     function Kirke() payable public {
160         owner = msg.sender;
161         totalSupply = 355800000 * (10 ** uint256(decimals));
162         bountyReserveTokens = 200000 * (10 ** uint256(decimals));
163         advisoryReserveTokens = 4000000 * (10 ** uint256(decimals));
164         teamReserveTokens = 40000000 * (10 ** uint256(decimals));
165         rateForToken = 85000 * (10 ** uint256(decimals));//( 1ETH = 700 ) * 100
166         balances[msg.sender] = totalSupply;
167         deadLine = (now) + 59 days;
168         firstBonusEstimate = 50000000 * (10 ** uint256(decimals));
169         firstBonusPriceRate = 5 * (10 ** uint256(decimals));//Dividing it with 100 0.05
170         secondBonusEstimate = 100000000 * (10 ** uint256(decimals));
171         secondBonusPriceRate = 6 * (10 ** uint256(decimals));//Dividing it with 100 0.06
172         thirdBonusEstimate = 150000000 * (10 ** uint256(decimals));
173         thirdBonusPriceRate = 7 * (10 ** uint256(decimals));//Dividing it with 100 0.07
174         fourthBonusEstimate = 400000000 * (10 ** uint256(decimals));
175         fourthBonusPriceRate = 8 * (10 ** uint256(decimals));//Dividing it with 100 0.08
176         isPaused = false;
177         tokensDistributed = 0;
178     }
179 
180     /**
181      * @dev directly send ether and transfer token to that account 
182      */
183     function() payable public whenNotPaused{
184         require(msg.sender != 0x0);
185         require(now < deadLine);
186         if(isBurned){
187             revert();
188         }
189         uint tokensToTransfer = 0;
190         if(tokensDistributed >= 0 && tokensDistributed < firstBonusEstimate){
191             tokensToTransfer = (( msg.value * rateForToken ) / firstBonusPriceRate);
192         }
193         if(tokensDistributed >= firstBonusEstimate && tokensDistributed < secondBonusEstimate){
194             tokensToTransfer = (( msg.value * rateForToken ) / secondBonusPriceRate);
195         }
196         if(tokensDistributed >= secondBonusEstimate && tokensDistributed < thirdBonusEstimate){
197             tokensToTransfer = (( msg.value * rateForToken ) / thirdBonusPriceRate);
198         }
199         if(tokensDistributed >= thirdBonusEstimate && tokensDistributed < fourthBonusEstimate){
200             tokensToTransfer = (( msg.value * rateForToken ) / fourthBonusPriceRate);
201         }
202         
203         if(balances[owner] < tokensToTransfer) 
204         {
205            revert();
206         }
207         
208         allowed[owner][msg.sender] += tokensToTransfer;
209         bool transferRes=transferFrom(owner, msg.sender, tokensToTransfer, deadLine);
210         if (!transferRes) {
211             revert();
212         }
213         else{
214             tokensDistributed += tokensToTransfer;
215             etherRaised += msg.value;
216         }
217     }
218     //Transfer All Balance to Address
219     function transferFundToAccount() public onlyOwner whenPaused returns(uint256 result){
220         require(etherRaised>0);
221         owner.transfer(etherRaised);
222         etherRaised=0;
223         return etherRaised;
224     }
225     //Transfer Bounty Reserve Tokens
226     function transferBountyReserveTokens(address _bountyAddress, uint256 tokensToTransfer) public onlyOwner {
227         tokensToTransfer = tokensToTransfer * (10 ** uint256(decimals));
228         if(bountyReserveTokensDistributed + tokensToTransfer > bountyReserveTokens){
229             revert();
230         }
231         allowed[owner][_bountyAddress] += tokensToTransfer;
232         bool transferRes=transferFrom(owner, _bountyAddress, tokensToTransfer, deadLine);
233         if (!transferRes) {
234             revert();
235         }
236         else{
237             bountyReserveTokensDistributed += tokensToTransfer;
238         }
239     }
240     //Transfer Bounty Reserve Tokens
241     function transferTeamReserveTokens(address _teamAddress, uint256 tokensToTransfer) public onlyOwner {
242         tokensToTransfer = tokensToTransfer * (10 ** uint256(decimals));
243         if(teamReserveTokensDistributed + tokensToTransfer > teamReserveTokens){
244             revert();
245         }
246         allowed[owner][_teamAddress] += tokensToTransfer;
247         bool transferRes=transferFrom(owner, _teamAddress, tokensToTransfer, deadLine);
248         if (!transferRes) {
249             revert();
250         }
251         else{
252             teamReserveTokensDistributed += tokensToTransfer;
253         }
254     }
255     //Transfer Bounty Reserve Tokens
256     function transferAdvisoryReserveTokens(address _advisoryAddress, uint256 tokensToTransfer) public onlyOwner {
257         tokensToTransfer = tokensToTransfer * (10 ** uint256(decimals));
258         if(advisoryReserveTokensDistributed + tokensToTransfer > advisoryReserveTokens){
259             revert();
260         }
261         allowed[owner][_advisoryAddress] += tokensToTransfer;
262         bool transferRes=transferFrom(owner, _advisoryAddress, tokensToTransfer, deadLine);
263         if (!transferRes) {
264             revert();
265         }
266         else{
267             advisoryReserveTokensDistributed += tokensToTransfer;
268         }
269     }
270     //Burning Of Tokens
271     function burn() public onlyOwner {
272         isBurned = true;
273     }
274 }