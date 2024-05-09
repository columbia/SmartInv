1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;}
8     function div(uint256 a, uint256 b) internal constant returns (uint256) {
9         // assert(b > 0); 
10         uint256 c = a / b;
11         // assert(a == b * c + a % b); 
12         return c;}
13  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
14         assert(b <= a);
15         return a - b;}
16 function add(uint256 a, uint256 b) internal constant returns (uint256) {
17         uint256 c = a + b;
18         assert(c >= a);
19         return c;}}
20 //------------------------------------------------------------------------------------------------------------------//
21     contract ERC20 {
22      function totalSupply() constant returns (uint256 totalSupply);                                 //TotalSupply
23      function balanceOf(address _owner) constant returns (uint256 balance);                         //See Balance Of
24      function transfer(address _to, uint256 _value) returns (bool success);                         //Transfer
25      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);      //TransferFrom
26      function approve(address _spender, uint256 _value) returns (bool success);                     //Approve
27      function allowance(address _owner, address _spender) constant returns (uint256 remaining);     //Allowance
28      function Mine_Block() returns (bool);            //Mine Function
29      function Proof_of_Stake() returns (bool);
30      function Request_Airdrop() returns (bool);     //Airdrop Function
31      event Mine(address indexed _address, uint _reward);      
32      event MinePoS(address indexed _address, uint rewardPoS);
33      event MineAD (address indexed _address, uint rewardAD);
34      event Transfer(address indexed _from, address indexed _to, uint256 _value);
35      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36      event SponsoredLink(string newNote);}
37 //------------------------------------------------------------------------------------------------------------------//     
38   contract EthereumWhite is ERC20 {                    //Name of the Contract
39      using SafeMath for uint256;                       //Use SafeMath
40      string public constant symbol = "EWHITE";         //Token Symbol
41      string public constant name = "Ethereum White";   //Token Name
42      uint8 public constant decimals = 8;               //Decimals
43      uint256 _totalSupply = 9000000 * (10**8);         //TotalSupply starts to 9 Million 
44      uint256 public _maxtotalSupply = 90000000 * (10**8);  // MaxTotalSupply is 90 Million
45      uint clock;                                       //mining time
46      uint public clockairdrop;                         //airdroptime
47      uint clockowner;                                  //double check anti cheat
48      uint public clockpos;                             //Pos Time
49      uint public clockmint;
50      uint MultiReward;           
51      uint MultiRewardAD;                       
52      uint public Miners;                               // Maximum Miners requestes for actual block
53      uint public Airdrop;                              //Maximum Airdrop requestes for actual block
54      uint public PoS;
55      uint public TotalAirdropRequests;                 //Total Airdrops from the biginning 
56      uint public TotalPoSRequests;                     //Total PoS from the biginning
57      uint public  rewardAD;                            //Show last rewad for Airdrop
58      uint public _reward;                              //Show last reward for miners
59      uint public _rewardPoS;                           //Show last reward for PoS
60      uint public MaxMinersXblock;                      //Show number of miners allowed each block
61      uint public MaxAirDropXblock;                     //Show number of Airdrops allowed each block
62      uint public MaxPoSXblock;                         //Show number of PoS allowed each block
63      uint public constant InitalPos = 10000 * (10**8); // Start Proof-of-stake
64      uint public gas;                                  // Fee Reimbursement
65      uint public BlockMined;                           //Total blocks Mined
66      uint public PoSPerCent;                           //PoSPerCent 
67      uint public reqfee;
68      struct transferInStruct{
69      uint128 reward;
70      uint64 time;  }
71      address public owner;
72      mapping(address => uint256) balances;
73      mapping(address => mapping (address => uint256)) allowed;
74      mapping(address => transferInStruct[]) transferIns;
75 //------------------------------------------------------------------------------------------------------------------//    
76 function InitialSettings() onlyOwner returns (bool success) {
77     MultiReward = 45;     
78     MultiRewardAD = 45;
79     PoSPerCent = 2000;
80     Miners = 0;         
81     Airdrop = 0;                        
82     PoS = 0;
83     MaxMinersXblock = 10;                   
84     MaxAirDropXblock=5;            
85     MaxPoSXblock=2;       
86     clock = 1509269936;                                 
87     clockairdrop = 1509269936;                         
88     clockowner = 1509269936;                           
89     clockpos = 1509269936;                             
90     clockmint = 1509269936;
91     reqfee = 1000000000;}
92 //------------------------------------------------------------------------------------------------------------------// 
93      modifier onlyPayloadSize(uint size) { 
94         require(msg.data.length >= size + 4);
95         _;}
96 //------------------------------------------------------------------------------------------------------------------// 
97     string public SponsoredLink = "Ethereum White";        
98     function setSponsor(string note_) public onlyOwner {
99       SponsoredLink = note_;
100       SponsoredLink(SponsoredLink); }
101 //------------------------------------------------------------------------------------------------------------------// 
102     function ShowADV(){
103        SponsoredLink(SponsoredLink);}
104 //------------------------------------------------------------------------------------------------------------------// 
105      function EthereumWhite() {
106          owner = msg.sender;
107          balances[owner] = 9000000 * (10**8);
108          }
109 //------------------------------------------------------------------------------------------------------------------// 
110      modifier onlyOwner() {
111         require(msg.sender == owner);
112         _;  }
113 //------------------------------------------------------------------------------------------------------------------// 
114      function totalSupply() constant returns (uint256 totalSupply) {
115          totalSupply = _totalSupply;      }
116 //------------------------------------------------------------------------------------------------------------------// 
117      function balanceOf(address _owner) constant returns (uint256 balance) {
118         return balances[_owner];     }
119 //------------------------------------------------------------------------------------------------------------------// 
120         function SetMaxMinersXblock(uint _MaxMinersXblock) onlyOwner {
121         MaxMinersXblock=  _MaxMinersXblock;   }
122 //------------------------------------------------------------------------------------------------------------------// 
123         function SetMaxAirDropXblock(uint _MaxAirDropXblock) onlyOwner {
124         MaxAirDropXblock=  _MaxAirDropXblock;        }
125 //------------------------------------------------------------------------------------------------------------------// 
126         function SetMaxPosXblock(uint _MaxPoSXblock) onlyOwner {
127          MaxPoSXblock=  _MaxPoSXblock;        }        
128 //------------------------------------------------------------------------------------------------------------------// 
129         function SetRewardMultiAD(uint _MultiRewardAD) onlyOwner {
130          MultiRewardAD=  _MultiRewardAD;        }        
131 //------------------------------------------------------------------------------------------------------------------//          
132       function SetRewardMulti(uint _MultiReward) onlyOwner {
133          MultiReward=  _MultiReward;        }        
134  //------------------------------------------------------------------------------------------------------------------// 
135         function SetGasFeeReimbursed(uint _Gasfee) onlyOwner{
136          gas=  _Gasfee * 1 wei;}       
137 //------------------------------------------------------------------------------------------------------------------// 
138          function transfer(address _to, uint256 _amount)  onlyPayloadSize(2 * 32) returns (bool success){
139          if (balances[msg.sender] >= _amount 
140             && _amount > 0
141              && balances[_to] + _amount > balances[_to]) {
142              if(_totalSupply> _maxtotalSupply){
143              gas = 0;
144              }
145                 if (balances[msg.sender] >= reqfee){
146              balances[msg.sender] -= _amount - gas ;}
147              else{
148             balances[msg.sender] -= _amount;}
149              balances[_to] += _amount;
150              Transfer(msg.sender, _to, _amount);
151              _totalSupply = _totalSupply.add(tx.gasprice);
152              ShowADV();
153             return true;
154              } else { throw;}}
155 
156 //------------------------------------------------------------------------------------------------------------------// 
157      function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(2 * 32) returns (bool success) {
158          if (balances[_from] >= _amount
159              && allowed[_from][msg.sender] >= _amount
160              && _amount > 0
161              && balances[_to] + _amount > balances[_to]) {
162              balances[_from] -= _amount;
163              allowed[_from][msg.sender] -= _amount;
164              balances[_to] += _amount;
165              Transfer(_from, _to, _amount);
166              ShowADV();
167              return true;
168          }   else {
169              throw;} }
170 //------------------------------------------------------------------------------------------------------------------// 
171          modifier canMint() {
172          uint _now = now;
173         require(_totalSupply < _maxtotalSupply);
174         require ((_now.sub(clockmint)).div(90 seconds) >= 1);
175         _; }
176 //------------------------------------------------------------------------------------------------------------------// 
177         function Mine_Block() canMint returns (bool) {
178          if(clockmint < clockowner) {return false;}
179          if(Miners >= MaxMinersXblock){
180          clockmint = now; 
181          Miners=0;
182          return true;}
183          if(balances[msg.sender] <= (100 * (10**8))){ return false;}
184          Miners++;
185          uint Calcrewardminers =1000000*_maxtotalSupply.div(((_totalSupply/9)*10)+(TotalAirdropRequests));
186          _reward = Calcrewardminers*MultiReward;  
187          uint reward = _reward;
188         _totalSupply = _totalSupply.add(reward);
189         balances[msg.sender] = balances[msg.sender].add(reward);
190         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
191         Mine(msg.sender, reward);
192         BlockMined++;
193         ShowADV();
194         return true;}
195 //------------------------------------------------------------------------------------------------------------------// 
196         modifier canAirdrop() { 
197          uint _now = now;
198         require(_totalSupply < _maxtotalSupply);
199         require ((_now.sub(clockairdrop)).div(60 seconds) >= 1);
200         _;}
201 //------------------------------------------------------------------------------------------------------------------// 
202          function Request_Airdrop() canAirdrop returns (bool) {
203          if(clockairdrop < clockowner){ return false;}
204          if(Airdrop >= MaxAirDropXblock){
205          clockairdrop = now; 
206          Airdrop=0;
207         return true; }
208           if(balances[msg.sender] > (100 * (10**8))) return false;
209          Airdrop++;
210          uint Calcrewardairdrop =100000*_maxtotalSupply.div(((_totalSupply/9)*10)+TotalAirdropRequests);
211          uint _reward = Calcrewardairdrop*MultiRewardAD;
212          rewardAD = _reward;
213         _totalSupply = _totalSupply.add(rewardAD);
214         balances[msg.sender] = balances[msg.sender].add(rewardAD);
215         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
216         MineAD(msg.sender, rewardAD);
217         TotalAirdropRequests++;
218         ShowADV();
219         return true;}
220 //------------------------------------------------------------------------------------------------------------------// 
221         modifier canPoS() {
222          uint _now = now;
223         require(_totalSupply < _maxtotalSupply);
224         require ((_now.sub(clockpos)).div(120 seconds) >= 1);
225          uint _nownetowk = now;
226         _;}
227 //------------------------------------------------------------------------------------------------------------------// 
228          function Proof_of_Stake() canPoS returns (bool) {
229          if(clockpos < clockowner){return false;}
230          if(PoS >= MaxPoSXblock){
231          clockpos = now; 
232          PoS=0;
233          return true; }
234          PoS++;
235          if(balances[msg.sender] >= InitalPos){
236          uint ProofOfStake = balances[msg.sender].div(PoSPerCent);
237          _rewardPoS = ProofOfStake;                    // Proof-of-stake 0.005%
238          uint rewardPoS = _rewardPoS;
239         _totalSupply = _totalSupply.add(rewardPoS);
240         balances[msg.sender] = balances[msg.sender].add(rewardPoS);
241         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
242         MinePoS(msg.sender, rewardPoS);
243         TotalPoSRequests++;
244 }else throw;
245         ShowADV();
246         return true;}
247 //------------------------------------------------------------------------------------------------------------------// 
248         function approve(address _spender, uint256 _amount) returns (bool success) {
249          allowed[msg.sender][_spender] = _amount;
250         Approval(msg.sender, _spender, _amount);
251          return true;}
252 //------------------------------------------------------------------------------------------------------------------// 
253      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
254          return allowed[_owner][_spender];}}