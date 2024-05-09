1 pragma solidity ^0.4.24;
2 // Game by spielley
3 // If you want a cut of the 1% dev share on P3D divs
4 // buy shares at => 0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1
5 // P3D masternode rewards for the UI builder
6 // multisigcontractgame v 1.01
7 // spielley is not liable for any known or unknown bugs contained by contract
8 
9 // hack at least half the signatures in the contract to gain acceptOwnership
10 // hack the P3D divs to the contract
11 // if you can manage to be the last hacker with majority in the contract
12 // for at least 5000 blocks, you can hack the P3D divs eth at contract
13 // Have fun, these games are purely intended for fun.
14 
15 contract Owned {
16     address public owner;
17     address public newOwner;
18 
19     event OwnershipTransferred(address indexed _from, address indexed _to);
20 
21     constructor() public {
22         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
23     }
24 
25     modifier onlyOwner {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     function transferOwnership(address _newOwner) public onlyOwner {
31         newOwner = _newOwner;
32     }
33     function acceptOwnership() public {
34         require(msg.sender == newOwner);
35         emit OwnershipTransferred(owner, newOwner);
36         owner = newOwner;
37         newOwner = address(0);
38     }
39 }
40 // ----------------------------------------------------------------------------
41 // Safe maths
42 // ----------------------------------------------------------------------------
43 library SafeMath {
44     function add(uint a, uint b) internal pure returns (uint c) {
45         c = a + b;
46         require(c >= a);
47     }
48     function sub(uint a, uint b) internal pure returns (uint c) {
49         require(b <= a);
50         c = a - b;
51     }
52     function mul(uint a, uint b) internal pure returns (uint c) {
53         c = a * b;
54         require(a == 0 || c / a == b);
55     }
56     function div(uint a, uint b) internal pure returns (uint c) {
57         require(b > 0);
58         c = a / b;
59     }
60 }
61 interface HourglassInterface  {
62     function() payable external;
63     function buy(address _playerAddress) payable external returns(uint256);
64     function sell(uint256 _amountOfTokens) external;
65     function reinvest() external;
66     function withdraw() external;
67     function exit() external;
68     function dividendsOf(address _playerAddress) external view returns(uint256);
69     function balanceOf(address _playerAddress) external view returns(uint256);
70     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
71     function stakingRequirement() external view returns(uint256);
72 }
73 interface SPASMInterface  {
74     function() payable external;
75     function disburse() external  payable;
76 }
77 contract DivMultisigHackable is Owned {
78     using SafeMath for uint;
79 HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
80 SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);
81 function buyp3d(uint256 amt) internal{
82 P3Dcontract_.buy.value(amt)(this);
83 }
84 function claimdivs() internal{
85 P3Dcontract_.withdraw();
86 }
87 // amount of divs available
88 
89 struct HackableSignature {
90     address owner;
91     uint256 hackingcost;
92     uint256 encryption;
93 }
94 uint256 public ethtosend;//eth contract pot
95 
96 uint256 public totalsigs;
97 mapping(uint256 => HackableSignature) public Multisigs;  
98 mapping(address => uint256) public lasthack;
99 mapping(address => uint256) public ETHtoP3Dbymasternode;
100 mapping(address => string) public Vanity;
101 address public last50plushacker;
102 uint256 public last50plusblocknr;
103 
104 address public contrp3d = 0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe;
105 
106 constructor(uint256 amtsigs) public{
107     uint256 nexId;
108     for(nexId = 0; nexId < amtsigs;nexId++){
109     Multisigs[nexId].owner = msg.sender;
110     Multisigs[nexId].hackingcost = 1;
111     Multisigs[nexId].encryption = 1;
112 }
113 totalsigs = amtsigs;
114 }
115 event onHarvest(
116         address customerAddress,
117         uint256 amount
118     );
119 function harvestabledivs()
120         view
121         public
122         returns(uint256)
123     {
124         return ( P3Dcontract_.dividendsOf(address(this)))  ;
125     }
126 function getMultisigOwner(uint256 sigId) view public returns(address)
127     {
128         return Multisigs[sigId].owner;
129     }
130 function getMultisigcost(uint256 sigId) view public returns(uint256)
131     {
132         return Multisigs[sigId].hackingcost;
133     }
134 function getMultisigencryotion(uint256 sigId) view public returns(uint256)
135     {
136         return Multisigs[sigId].encryption;
137     }
138 function ethtobuyp3d(address masternode) view public returns(uint256)
139     {
140         return ETHtoP3Dbymasternode[masternode];
141     }
142 function HackableETH() view public returns(uint256)
143     {
144         return ethtosend;
145     }  
146 function FetchVanity(address player) view public returns(string)
147     {
148         return Vanity[player];
149     }
150 function FetchlastHacker() view public returns(address)
151     {
152         return last50plushacker;
153     }  
154 function blockstillcontracthackable() view public returns(uint256)
155     {
156         uint256 test  = 5000 - last50plusblocknr ;
157         return test;
158     } 
159 function last50plusblokhack() view public returns(uint256)
160     {
161         return last50plusblocknr;
162     }      
163 function amountofp3d() external view returns(uint256){
164     return ( P3Dcontract_.balanceOf(address(this)))  ;
165 }
166 function Hacksig(uint256 nmbr , address masternode) public payable{
167     require(lasthack[msg.sender] < block.number);
168     require(nmbr < totalsigs);
169     require(Multisigs[nmbr].owner != msg.sender);
170     require(msg.value >= Multisigs[nmbr].hackingcost + Multisigs[nmbr].encryption);
171     Multisigs[nmbr].owner = msg.sender;
172     Multisigs[nmbr].hackingcost ++;
173     Multisigs[nmbr].encryption = 0;
174     lasthack[msg.sender] = block.number;
175     ETHtoP3Dbymasternode[masternode] = ETHtoP3Dbymasternode[masternode].add(msg.value);
176 }
177 function Encrypt(uint256 nmbr, address masternode) public payable{
178     require(Multisigs[nmbr].owner == msg.sender);//prevent encryption of hacked sig
179     Multisigs[nmbr].encryption += msg.value;
180     ETHtoP3Dbymasternode[masternode] = ETHtoP3Dbymasternode[masternode].add(msg.value);
181     }
182 
183 function HackDivs() public payable{
184     uint256 divs = harvestabledivs();
185     require(msg.value >= 1 finney);
186     require(divs > 0);
187     uint256 count;
188     uint256 nexId;
189     for(nexId = 0; nexId < totalsigs;nexId++){
190     if(Multisigs[nexId].owner == msg.sender){
191         count++;
192     }
193 }
194 require(count > totalsigs.div(2));
195     claimdivs();
196     //1% to owner
197     uint256 base = divs.div(100);
198     SPASM_.disburse.value(base)();// to dev fee sharing contract
199     ethtosend = ethtosend.add(divs.sub(base));
200     emit onHarvest(msg.sender,ethtosend);
201     last50plushacker = msg.sender;
202     last50plusblocknr = block.number;
203 }
204 function HackContract() public{
205     uint256 count;
206     uint256 nexId;
207     for(nexId = 0; nexId < totalsigs;nexId++){
208     if(Multisigs[nexId].owner == msg.sender){
209         count++;
210     }
211     }
212     require(count > totalsigs.div(2));
213     require(block.number > last50plusblocknr + 5000);
214     require(msg.sender == last50plushacker);
215     uint256 amt = ethtosend;
216     
217     ethtosend = 0;
218     for(nexId = 0; nexId < totalsigs;nexId++){
219         if(Multisigs[nexId].owner == msg.sender){
220         Multisigs[nexId].owner = 0;
221     }
222     
223     }
224     msg.sender.transfer(amt);
225 }
226 function Expand(address masternode) public {
227     
228     uint256 amt = ETHtoP3Dbymasternode[masternode];
229     ETHtoP3Dbymasternode[masternode] = 0;
230 
231     P3Dcontract_.buy.value(amt)(masternode);
232     
233 }
234 function changevanity(string van , address masternode) public payable{
235     require(msg.value >= 100  finney);
236     Vanity[msg.sender] = van;
237     ETHtoP3Dbymasternode[masternode] = ETHtoP3Dbymasternode[masternode].add(msg.value);
238 }
239 function () external payable{}
240 }