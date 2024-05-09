1 pragma solidity ^0.4.18;
2 
3 contract CryptoRushContract
4 {
5 
6   address owner;
7   address bot = 0x498f2B8129B153A3499E3812485C40178B6A5C48;
8   
9   uint fee;
10   bool registrationClosed;
11   uint registeredAccounts; // index
12   uint sharedBalanceID;
13   
14   struct Balance {
15       address user; // user address
16       uint lockedBalance; // how much funds are currently in the whole ecosystem
17       uint currBalance; // how much funds are currently available (to e.g. withdraw)
18       bool isInvestor; // special status in case user is investor
19       int investorCredit; // if this is > 0 then fees get deducted from this virtual balance
20       // This will be extended in the near future to allow for more diversity in calculations
21       
22   }
23   
24  
25   
26 
27   
28   mapping (address => Balance) balances;
29   
30  
31   
32 
33 
34   event UpdateStatus(string _msg);
35   event UserStatus(string _msg, address user, uint amount);
36 
37 
38 
39   function CryptoRushContract()
40   {
41     owner = msg.sender;
42     fee = 10; // 10% default fee
43     
44     
45    // uint _id = balances.length;
46     // add owner to the default balances
47     balances[owner].user = msg.sender;
48     balances[owner].lockedBalance = 0;
49     balances[owner].currBalance = 0;
50     balances[owner].isInvestor = true;
51     balances[owner].investorCredit = 0; // for now I am paying my own fees for proof of concept
52     registeredAccounts += 1;
53     
54   }
55 
56   modifier ifOwner()
57   {
58     if (msg.sender != owner)
59     {
60       throw;
61     }
62     _;
63   }
64   
65   modifier ifBot()
66   {
67     if (msg.sender != bot)
68     {
69       throw;
70     }
71     _;
72   }
73   
74   // restricts access to approved users 
75   modifier ifApproved()
76   {
77     if (msg.sender == balances[msg.sender].user)
78     {
79         _;
80     }
81     else
82     {
83         throw;
84     }
85   }
86   
87   
88   function closeContract() ifOwner
89   {
90       suicide(owner);
91   }
92   
93   // placeholder in case I manage to implement an auto-updater for V1
94   function updateContract() ifOwner
95   {
96       
97   }
98   
99   // only owner can approve new User and currently owner can't remove user once registered.
100   // Transparency and Trust yaaay!
101   function approveUser(address _user) ifOwner
102   {
103       balances[_user].user = _user;
104       balances[_user].lockedBalance = 0;
105       balances[_user].currBalance = 0;
106       balances[_user].isInvestor = false;
107       
108       registeredAccounts += 1;
109   }
110   
111   function approveAsInvestor(address _user, int _investorCredit) ifOwner
112   {
113       balances[_user].user = _user;
114       balances[_user].isInvestor = true;
115       balances[_user].investorCredit = _investorCredit;
116       
117   }
118   
119   
120   
121   // only allow call from owner of the address asking
122   function getCurrBalance() constant returns (uint _balance)
123   {
124       if(balances[msg.sender].user == msg.sender)
125       {
126         return balances[msg.sender].currBalance;    
127       }
128       else
129       {
130           throw;
131       }
132       
133   }
134   
135   // only allow call from owner of the address asking
136   function getLockedBalance() constant returns (uint _balance)
137   {
138       if(balances[msg.sender].user == msg.sender)
139       {
140         return balances[msg.sender].lockedBalance;    
141       }
142       else
143       {
144           throw;
145       }
146       
147   }
148   
149   // only allow call from owner of the address asking
150   function getInvestorCredit() constant returns (int _balance)
151   {
152       if(balances[msg.sender].user == msg.sender)
153       {
154         return balances[msg.sender].investorCredit;    
155       }
156       else
157       {
158           throw;
159       }
160       
161   }
162   
163 
164   // default deposit function used by Users
165   function depositFunds() payable
166   {
167      
168      // if user is not approved then do not add it to the balances in order to stop overbloating the array thus sabotaging the platform
169      if (!(msg.sender == balances[msg.sender].user))
170      {
171         // user is not approved so add it to the owner's account balance
172         
173         balances[owner].currBalance += msg.value;
174         UserStatus('User is not approved thus donating ether to the contract', msg.sender, msg.value);
175      }
176      else
177      {  // user is approved so add it to their balance
178          
179         balances[msg.sender].currBalance += msg.value; // and current balance
180         UserStatus('User has deposited some funds', msg.sender, msg.value);
181      }
182       
183       
184       
185   }
186 
187  
188 
189   function withdrawFunds (uint amount) ifApproved
190   {
191       if (balances[msg.sender].currBalance >= amount)
192       {
193           // user has enough funds, so pay him out!
194           
195           balances[msg.sender].currBalance -= amount;
196          
197           
198           // this function can be called multiple times so stop that from happening by
199           // removing the balances before the transaction is being sent!
200           
201           if (msg.sender.send(amount)) 
202           {
203               // all okay!
204                UserStatus("User has withdrawn funds", msg.sender, amount);
205           }
206           else
207           {
208               // if send failed, reset balances!
209               balances[msg.sender].currBalance += amount;
210              
211           }
212       }
213       else
214       {
215           throw;
216       }
217       
218   }
219   
220   
221   
222   // Bot grabs balance from user's account
223   function allocateBalance(uint amount, address user) ifBot
224   {
225       // has user enough funds? remember this is being called by Backend!
226       if (balances[user].currBalance >= amount)
227       {
228           balances[user].currBalance -= amount;
229           balances[user].lockedBalance += amount; 
230           if (bot.send(amount))
231           {
232             UserStatus('Bot has allocated balances', user, msg.value);
233           }
234           else
235           {
236               // if fail then reset state
237               balances[user].currBalance += amount;
238               balances[user].lockedBalance -= amount;
239           }
240       }
241       
242   }
243   
244   
245   
246   // SHARED BOT STUFF START
247  
248   
249   // SHARED BOT STUFF END
250   
251   
252   
253   function deallocateBalance(address target) payable ifBot 
254   {
255       // check if everything fine with bot value
256       
257       
258       if (msg.value > balances[target].lockedBalance)
259       {
260           // profit has been made! Time to pay some fees!!11
261           uint profit = msg.value - balances[target].lockedBalance;
262           
263           uint newFee = profit * fee/100;
264           uint netProfit = profit - newFee;
265           uint newBalance = balances[target].lockedBalance + netProfit;
266           int vFee = int(newFee);
267           
268           if (balances[target].isInvestor == true)
269           {
270               
271               
272               // if user is investor and has credits left 
273               if (balances[target].investorCredit > 0 )
274               {
275                   // deduct virtual balance
276                   
277                   balances[target].investorCredit -= vFee;
278                   
279                   if (balances[target].investorCredit < 0)
280                   {
281                       // credit is gone, recalculate profit
282                       int toCalc = balances[target].investorCredit * -1;
283                       uint newCalc = uint(toCalc);
284                       profit -= newCalc; // deduct remaining fees
285                       balances[target].currBalance += balances[target].lockedBalance + profit; // full profit gets added
286                       balances[target].lockedBalance = 0; 
287                       
288                       balances[owner].currBalance += newCalc;
289                   }
290                   else
291                   {
292                     //UserStatus("investor credit deducted", target, vFee);
293                      // add full profit 
294                      balances[target].currBalance += balances[target].lockedBalance + profit; // full profit gets added
295                      balances[target].lockedBalance = 0;    
296                   }
297                   
298                   
299               }
300               else // if no credit left
301               {
302                   // get special fees ??
303                   balances[target].currBalance += newBalance;
304                   balances[target].lockedBalance = 0;
305                   balances[owner].currBalance += newFee; // add fee to owner account
306               }
307           }
308           else
309           {
310               balances[target].currBalance += newBalance;
311               balances[target].lockedBalance = 0;
312               balances[owner].currBalance += newFee;
313           }
314       }
315       else
316       {
317           // no profit detected so no fees to pay!
318           // platform looses some eth to gas though...!
319           balances[target].lockedBalance = 0;
320           balances[target].currBalance += msg.value;
321           
322       }
323       
324       
325       
326   }
327   
328   
329    
330 
331   
332   
333   
334 
335 
336 
337 
338 }