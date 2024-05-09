1 pragma solidity 0.4.6;
2 
3 contract DXF_Tokens{
4 
5   //States
6   bool public dxfOpen=true;
7   bool public refundState;
8   bool public transferLocked=true;
9 
10   uint256 public startingDateFunding;
11   uint256 public closingDateFunding;
12   //Maximum number of participants
13   uint256 public constant maxNumberMembers=5000;
14   //Token caps, this includes the 12500 tokens that will be attributed to former users (VIPs)
15   uint256 public totalTokens;
16   uint256 public constant tokensCreationMin = 25000 ether;
17   uint256 public constant tokensCreationCap = 75000 ether;
18   //Cap of 12500 ethers worth of tokens to be distributed 
19   //to previous DO members in exchange for their rouleth accounts
20   uint256 public remainingTokensVIPs=12500 ether;
21   uint256 public constant tokensCreationVIPsCap = 12500 ether; 
22 
23 
24   mapping (address => uint256) balances;
25   mapping (address => bool) vips;
26   mapping (address => uint256) indexMembers;
27   
28   struct Member
29   {
30     address member;
31     uint timestamp;
32     uint initial_value;
33   }
34   Member[] public members;
35 
36   event Transfer(address indexed _from, address indexed _to, uint256 _value);
37   event Refund(address indexed _to, uint256 _value);
38   event failingRefund(address indexed _to, uint256 _value);
39   event VipMigration(address indexed _vip, uint256 _value);
40   event newMember(address indexed _from);
41 
42   // Token parameters
43   string public constant name = "DXF - Decentralized eXperience Friends";
44   string public constant symbol = "DXF";
45   uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
46 
47   address public admin;
48   address public multisigDXF;
49 
50   modifier onlyAdmin()
51   {
52     if (msg.sender!=admin) throw;
53     _;
54   }
55 
56   function DXF_Tokens()
57   {
58     admin = msg.sender;
59     startingDateFunding=now;
60     multisigDXF=0x7a992f486fbc7C03a3f2f862Ad260f158C5c5486; //or switch to constructor param
61     //increment array by 1 for indexes
62     members.push(Member(0,0,0));
63   }
64 
65 
66   //empty fallback
67   function ()
68     {
69       throw;
70     }
71 
72   //USER FUNCTIONS  
73   /// @notice Create tokens when funding is active.
74   /// @notice By using this function you accept the terms of DXF
75   /// @dev Required state: Funding Active
76   /// @dev State transition: -> Funding Success (only if cap reached)
77   function acceptTermsAndJoinDXF() payable external 
78   {
79     // refuse if more than 12 months have passed
80     if (now>startingDateFunding+365 days) throw;
81     // Abort if DXF is not open.
82     if (!dxfOpen) throw;
83     // verify if the account is not a VIP account
84     if (vips[msg.sender]) throw;
85     // Do not allow creating less than 10 ether or more than the cap tokens.
86     if (msg.value < 10 ether) throw;
87     if (msg.value > (tokensCreationCap - totalTokens)) throw;
88     // Enforce cap of 10 000 ethers per address / individual
89     if (msg.value > (10000 ether - balances[msg.sender])) throw;
90     // Register member
91     if (balances[msg.sender]==0)
92       {
93         newMember(msg.sender); //event
94 	indexMembers[msg.sender]=members.length;
95 	members.push(Member(msg.sender,now,msg.value));
96       }
97     else
98       {
99 	members[indexMembers[msg.sender]].initial_value+=msg.value;
100       }
101     if (members.length>maxNumberMembers) throw;
102     //Send the funds to the MultiSig Wallet
103     if (multisigDXF==0) throw;
104     if (!multisigDXF.send(msg.value)) throw;
105     // Assign new tokens to the sender
106     uint numTokens = msg.value;
107     totalTokens += numTokens;
108     // Do not allow creating tokens if we don't leave enough for the VIPs
109     if ( (tokensCreationCap-totalTokens) < remainingTokensVIPs ) throw;
110     balances[msg.sender] += numTokens;
111     // Log token creation event
112     Transfer(0, msg.sender, numTokens);
113   }
114 
115 
116 
117   //NOT INCLUDED IN LATEST VERSION
118   //since we move the funds to multisig
119   //refund will be with payback()
120   /* /// @notice Get back the ether sent during the funding in case the funding */
121   /* /// has not reached the minimum level. */
122   /* /// @dev Required state: refund true */
123   /* function refund() */
124   /* { */
125   /*   // Abort if not in refund state */
126   /*   if (!refundState) throw; */
127   /*   // Not refunded for VIP, we will do a manual refund for them */
128   /*   // via the payback function */
129   /*   if (vips[msg.sender]) throw; */
130   /*   uint value = balances[msg.sender]; */
131   /*   if (value == 0) throw; */
132   /*   balances[msg.sender] = 0; */
133   /*   totalTokens -= value; */
134   /*   delete members[indexMembers[msg.sender]]; */
135   /*   indexMembers[msg.sender]=0; */
136   /*   Refund(msg.sender, value); */
137   /*   if (!msg.sender.send(value)) throw; */
138   /* } */
139 
140 
141   //@notice Full Tranfer of DX tokens from sender to '_to'
142   //@dev only active if tranfer has been unlocked
143   //@param _to address of recipient
144   //@param _value amount to tranfer
145   //@return success of tranfer ?
146   function fullTransfer(address _to) returns (bool)
147   {
148     // Cancel if tranfer is not allowed
149     if (transferLocked) throw;
150     if (balances[_to]!=0) throw;
151     if (balances[msg.sender]!=0)
152       {
153 	uint senderBalance = balances[msg.sender];
154 	balances[msg.sender] = 0;
155 	balances[_to]=senderBalance;
156 	if (vips[msg.sender])
157 	  {
158 	    vips[_to]=true;
159 	    vips[msg.sender]=false;
160 	  }
161 	members[indexMembers[msg.sender]].member=_to;
162 	indexMembers[_to]=indexMembers[msg.sender];
163 	indexMembers[msg.sender]=0;
164 	Transfer(msg.sender, _to, senderBalance);
165 	return true;
166       }
167     else
168       {
169 	return false;
170       }
171   }
172 
173 
174   //ADMIN FUNCTIONS
175 
176 
177   //@notice called by Admin to manually register migration of previous DO
178   //@dev can not be called with a _vip address that is already investor
179   //@dev can be called even after the DO is sealed
180   //@param _value : balance of VIP at DXDO's creation date
181   function registerVIP(address _vip, address _vip_confirm, uint256 _previous_balance)
182     onlyAdmin
183   {
184     if (_vip==0) throw;
185     if (_vip!=_vip_confirm) throw;
186     //don't allow migration to a non empty address
187     if (balances[_vip]!=0) throw; 
188     if (_previous_balance==0) throw;
189     uint numberTokens=_previous_balance+(_previous_balance/3);
190     totalTokens+=numberTokens;
191     //too many tokens created via VIP migration
192     if (numberTokens>remainingTokensVIPs) throw;     
193     remainingTokensVIPs-=numberTokens;
194     balances[_vip]+=numberTokens;
195     indexMembers[_vip]=members.length;
196     members.push(Member(_vip,now,_previous_balance));
197     vips[_vip]=true;
198     VipMigration(_vip,_previous_balance);
199   }
200 
201 
202   /// @notice Pay back the ether contributed to the DAO
203   function paybackContribution(uint i)
204     payable
205     onlyAdmin
206   {
207     address memberRefunded=members[i].member;
208     if (memberRefunded==0) throw;
209     uint amountTokens=msg.value;
210     if (vips[memberRefunded]) 
211       {
212 	amountTokens+=amountTokens/3;
213 	remainingTokensVIPs+=amountTokens;
214       }
215     if (amountTokens>balances[memberRefunded]) throw;
216     balances[memberRefunded]-=amountTokens;
217     totalTokens-=amountTokens;
218     if (balances[memberRefunded]==0) 
219       {
220 	delete members[i];
221 	vips[memberRefunded]=false;
222 	indexMembers[memberRefunded]=0;
223       }
224     if (!memberRefunded.send(msg.value))
225       {
226         failingRefund(memberRefunded,msg.value);
227       }
228     Refund(memberRefunded,msg.value);
229   }
230 
231 
232   function changeAdmin(address _admin, address _admin_confirm)
233     onlyAdmin
234   {
235     if (_admin!=_admin_confirm) throw;
236     if (_admin==0) throw;
237     admin=_admin;
238   }
239 
240   //@notice called to seal the DO
241   //@dev can not be opened again, marks the end of the fundraising 
242   //and the recruitment in the DO
243   function closeFunding()
244     onlyAdmin
245   {
246     closingDateFunding=now;
247     dxfOpen=false;
248     //verify if the cap has been reached
249     //if not : refund mode
250     if (totalTokens<tokensCreationMin)
251       {
252 	refundState=true;
253       }
254     else
255       {
256         //send balance, but should not be necessary.      
257 	if(!admin.send(this.balance)) throw;
258       }
259   }
260 
261   //NOT INCLUDED
262   /* function reopenDO() */
263   /*   onlyAdmin */
264   /* { */
265   /*   dxfOpen=true; */
266   /*   transferLocked=true; */
267   /* } */
268 
269   function allowTransfers()
270     onlyAdmin
271   {
272     transferLocked=false;
273   }
274 
275   function disableTransfers()
276     onlyAdmin
277   {
278     transferLocked=true;
279   }
280 
281 
282   //Constant Functions
283   function totalSupply() external constant returns (uint256) 
284   {
285     return totalTokens;
286   }
287 
288   function balanceOf(address _owner) external constant returns (uint256) 
289   {
290     return balances[_owner];
291   }
292 
293   function accountInformation(address _owner) external constant returns (bool vip, uint balance_dxf, uint share_dxf_per_thousands) 
294   {
295     vip=vips[_owner];
296     balance_dxf=balances[_owner]/(1 ether);
297     share_dxf_per_thousands=1000*balances[_owner]/totalTokens;
298   }
299 
300 
301 }