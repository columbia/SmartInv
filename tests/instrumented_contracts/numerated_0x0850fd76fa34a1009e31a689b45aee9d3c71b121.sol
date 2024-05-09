1 /**
2  *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
3  *
4  *  Code is based on multiple sources:
5  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts
6  *  https://github.com/TokenMarketNet/ico/blob/master/contracts
7  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts
8  */
9 pragma solidity ^0.4.11;
10 
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 
36   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a >= b ? a : b;
38   }
39 
40   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
41     return a < b ? a : b;
42   }
43 
44   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a >= b ? a : b;
46   }
47 
48   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
49     return a < b ? a : b;
50   }
51 
52 }
53 
54 
55 contract NTRYToken{
56    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
57 }
58 
59 
60 contract ProRataDistribution {
61  
62   /* Pre ICO participants */
63   mapping(address => uint) investors;
64   
65   using SafeMath for uint;
66   
67   address public multisigWallet;
68   
69   address public owner;
70   modifier onlyOwner {if (msg.sender != owner) throw; _;}
71   
72   uint tokenExchangeRate = 15830;
73   
74   // Time limit for Investment
75   uint public deadline = now + (7200 * 1 minutes);
76   modifier afterDeadline() { if (now >= deadline) throw; _;}
77   
78   
79   NTRYToken private notaryToken;
80   
81   uint public distributed = 0;
82   
83   uint public transferred = 0;
84   
85   uint public totalSupply = 5000000 * 1 ether;
86   
87   bool offerClosed = true;
88   
89   // A new investment was made
90   event Invested(address investor, uint weiAmount, uint tokenAmount);
91   
92   event EndsAtChanged(uint endsAt);
93   
94   function ProRataDistribution(){
95       owner = 0x1538EF80213cde339A333Ee420a85c21905b1b2D;
96       multisigWallet = 0x1D1739F37a103f0D7a5f5736fEd2E77DE9863450;
97       notaryToken = NTRYToken(0x805cEfaF11Df46D609fa34a7723d289b180Fe4fA);
98 
99       preICOLedger();
100   }
101   
102   function() payable afterDeadline{
103     
104     uint weiAmount = msg.value;
105     if (weiAmount == 0){
106         throw;
107     }
108     
109     // validate investor
110     if (investors[msg.sender] != weiAmount){
111         throw;
112     }
113     
114     uint tokenAmount = weiAmount.mul(tokenExchangeRate);
115     
116     if (!notaryToken.transferFrom(owner, msg.sender, tokenAmount)){
117         throw;
118     }else{
119         distributed = distributed.add(tokenAmount);
120         transferred = transferred.add(weiAmount);
121     }
122 
123     // Pocket the money
124     if(!multisigWallet.send(weiAmount)) throw;
125 
126     // Tell us invest was success
127     Invested(msg.sender, weiAmount, tokenAmount);
128   }
129   
130   function investedInPreICO() public constant returns (uint amount){
131       return investors[msg.sender];
132   }
133   
134   function rescueInvestor(address target, uint amount) onlyOwner returns (bool rescued){
135       investors[target] = amount;
136       return true;
137   }
138   
139   function setEndsAt(uint time) public onlyOwner {
140     if(now > time) {
141       throw; // Don't change past
142     }
143     deadline = time;
144     EndsAtChanged(deadline);
145   }
146   
147   
148   function preICOLedger() returns (bool loaded) {
149     investors[0x8ceda3f1bd005a5e30b5cb269ce8bf86b5b96c20] = 1131588360000000000;
150     investors[0x39346183c258d1ba55eb4cd7ed2822dfeffe38f5] = 4000000000000000000;
151     investors[0x6fd623ab0dff084df49975986ad8af7c306bf8b8] = 600000000000000000;
152     investors[0xab4bf37461f081c369175b4bee5ae22ea9f7e980] = 12000000000000000;
153     investors[0xaff4ac0f844d2efba41745ed6c76907200be88f2] = 2000000000000000000;
154     investors[0x4a2dccbc65ba28796af0a15dd11424c14153d2d1] = 100000000000000000;
155     investors[0xccc8d4410a825f3644d3a5bbc0e9df4ac6b491b3] = 472856928000000000;
156     investors[0x03e7d38a76d478c6a9edc2386fcd7e2983309b6c] = 100000000000000000;
157     investors[0x98175430c3a4bd4d577e18b487b3ed7303e2c52d] = 10000000000000000000;
158     investors[0x742eacb804428d576d4926fe71af712b430eb644] = 22000000000000000;
159     investors[0xd8e505f819da392a3c558df5134ebe7d6482f85c] = 12000000000000000;
160     investors[0xeecc29f66931bb3815bb67856a80df995f94d087] = 10000000000000000;
161     investors[0x196a1d3da3953a6623d943351f7e318b50870db2] = 10000000000000000;
162     investors[0x5b90b4a856b7826aa9c9910780603017cbfa68b7] = 500000000000000000;
163     investors[0x033724fa9c4cb645d4ed582c402c32a5eb3159a7] = 755382145000000000;
164     investors[0xb78d3e316c2a94a7950260e38c73176cd14b70ea] = 7250000000000000000;
165     investors[0xfc68743beee9d3cdb83995f1a84778a39b0f402e] = 930000000000000000;
166     investors[0x31cf35f20126936c7be14a15b3655662fa524d2f] = 9400000000000000000;
167     investors[0x2c82d682f7019e29a43ce05e4c2b63033cb4e895] = 2000000000000000000;
168     investors[0x51d6f9fb6ce42c62bfe3bef522b2b5cd6f15fa9c] = 3000000000000000000;
169     investors[0x36cfb5a6be6b130cfceb934d3ca72c1d72c3a7d8] = 3500000000000000000;
170     investors[0xa3166be56ca461d0909f71d5af48c1ebb1463a6f] = 2400000000000000000;
171     investors[0xe6d4d5c12079503d2f30bd83e6b43f6fb0668b08] = 1100000000000000000;
172     investors[0xbf1b3cd561db4fea02a51f424ab52fbaef311a4d] = 3300000000000000000;
173     investors[0x67cb283f70de2941cd799e622930a8efd33ca078] = 100000000000000000;
174     investors[0x22b0ac0be4633f57fa4457268ad365c11227e172] = 1200000000000000000;
175     investors[0xf8c7cb5ed2336322c67350e9c2461e0f0ee3659e] = 6927216202600000000;
176     investors[0x67a72f16d690714772e2727f2e2e58747ae778de] = 1000000000000000000;
177     investors[0xb6191f05f715ebae29c200461af33a18b9379ee7] = 2000000000000000000;
178     investors[0xcc39a604c91c43e8a1e7798a8947c5ac227b5d81] = 1000000000000000000;
179     investors[0x5ad21dc27c6fc36725d643a19c2245c5327ff915] = 1000000000000000000;
180     investors[0xa2d91d801ec327dfc6f52633477192a992fbc2a0] = 1000000000000000000;
181     investors[0xa2f6da487597d959e4565897d57935917c480bf7] = 50000000000000000;
182     investors[0x638ca535ee7988e8b96be67ebf902d77f50b28ca] = 3000000000000000000;
183     investors[0x5dcbb1bfcf502a5a6563c8d582db50cdc1dda1eb] = 1750000000000000000;
184     investors[0xfca228fa85b495ccad06b2dbf8e274d1d5704e41] = 1000000000000000000;
185     investors[0x7cf209a05d1565cc63fd2364149beb5b3db62ff8] = 1000000000000000000;
186     investors[0xbaf1e9cca2f0ebb7e116508f39afd8e730e23e45] = 3200000000000000000;
187     investors[0x3833f8dbdbd6bdcb6a883ff209b869148965b364] = 5000000000000000000;
188     investors[0xfff78f0db7995c7f2299d127d332aef95bc3e7b7] = 96607783000000000;
189     investors[0x7dc6795bf92e5adc3b7de6e7f17cb8d7a9d2933f] = 1200000000000000000;
190     investors[0x1b29291cf6a57ee008b45f529210d6d5c5f19d91] = 2000000000000000000;
191     investors[0x16a8b1355262d97ec5e5bc38d305342671672fab] = 800000000000000000;
192     investors[0x7a5e9d6817c37ae83fc616844497ce14bc5b10ab] = 1000000000000000000;
193     investors[0x5678dea87f3a2acc01a88f45a126fa59b48e7204] = 8500000000000000000;
194     investors[0x36a00f901c5a6d738f9e6b0ae03d4e02c346fd24] = 2100000000000000000;
195     investors[0x00be002531930ed5b0d138f077f917a153a2d780] = 201000000000000000000;
196     investors[0x9a2ebff067a422d108c29552a6b4b88f8abe9cde] = 1000000000000000000;
197     investors[0xd51e2fa6f61f6f3c97e21bb91b36ab974b72bf22] = 3000000000000000000;
198     investors[0x47ae8375b52166e513616c8eca798bafb9c1205a] = 1000000000000000000;
199     investors[0x967badde589202b8684e3edad1cb4e4d32aeb6a6] = 3000000000000000000;
200     investors[0x3a848a0c9b3979ab9b1e54e5c67b2e540c29fc3c] = 1000000000000000000;
201     investors[0x595488e62ebe727049c096eeece474b349bf294e] = 350000000000000000;
202     investors[0x2734168834b8087f507d6f9e8c6db2ed2deaab1b] = 2000000000000000000;
203     investors[0x49225fe668e02c1a65c1075d8dba32838e1548ed] = 3300000000000000000;
204     investors[0xae085f56bffcc4b3cc36de49519f3185e09e64e7] = 880000000000000000;
205     investors[0x1fa50344d0529e90b94e82cacbabf65cae6092c4] = 210000000000000000;
206     investors[0xfcd991ba83bb0c10132ed03989e616916591a399] = 200000000000000000;
207     investors[0x3c6211a64508c45f5cd9fee363610d9dcb6000ed] = 129285740000000000;
208     return true;
209   }
210 
211    function setMultisig(address addr) public onlyOwner {
212       multisigWallet = addr;
213   }
214 
215   function transferOwnership(address _newOwner) onlyOwner {
216         owner = _newOwner;
217   }
218     
219 }