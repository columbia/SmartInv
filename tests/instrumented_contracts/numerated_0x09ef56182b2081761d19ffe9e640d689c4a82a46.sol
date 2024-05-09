1 pragma solidity ^0.5.3;
2 
3 /*
4 Ethereum Tree
5 
6 Website: https://www.ethereumtree.com
7 Telegram: https://t.me/ethereumtree
8 Twitter: https://www.twitter.com/ethereumtree
9 Medium: https://medium.com/@ethereumtree
10 
11 What is Ethereum Tree?
12 Ethereum Tree is intelligent platform which works on simple principle of “money tree” – now everyone will earn Ethereum. It is a never ending source of income for those who will invest in the Ethereum Tree. Ethereum Tree grows continuously whenever new investors are added into the Ethereum Tree system.
13 
14 How Ethereum Tree works?
15 Anybody willing to invest in Ethereum Tree can start investing with any amount as small as 0.0001 ETH. As name suggests, this platform is completely Ethereum blockchain based system.  After investing into the system person will start earning profit based on the amount of ETH he/she is holding into Ethereum Tree smart contract.
16 
17 Investors will get income in 2 different ways as explained below:
18 1.	Income from dividend obtained from successive investments:
19 Whenever new investor invests Ethereum into Ethereum Tree smart contract (DAPP), system will deduct 10% amount as a network fee which will be distributed to all the investors who are already part of Ethereum Tree.  Distribution amount assigned to each investor is directly proportional to the current holdings of that investor in Ethereum Tree. That means, investors with higher holdings will get larger portion of the dividend (Larger is the holding bigger is the profit). Same thing is illustrated in below image.
20 
21 2.	Earning from referral bonus:
22 Ethereum Tree assigns unique referral link to each investor wallet. The format of link is as below:
23 https://ethereumtree.com/?ref=Your_ETH_Address
24 Whenever users share this link with his/her friends or relatives to refer them to Ethereum Tree DAPP he/she will get flat 1/3 of 10% network fee from the referral’s investment as a referral bonus. This means, whenever referred person invests 10% amount is deducted as a network fee for distribution amongst the present members of the Ethereum Tree but 1/3 part of that deducted amount will be directly given to referring person as a referral bonus and remaining 2/3 portion will be distributed amongst all the members of the Ethereum Tree based on current holdings. So, person who refers other members to the system will get double benefits (referral bonus as well as future dividend on referential bonus).
25 
26 Benefits of using Ethereum Tree as an investment option:
27 •	Investors get dividend amount from successive investors based on their current holdings in the system. So investor can increase their holdings to get more and more profit out of it.
28 •	Ethereum Tree is highly secure distributed system so no one controls it but the investors. So all the investments of investors are safe into the system (Ethereum blockchain).
29 •	Investors can withdraw their holdings including profits earned via dividend and referral bonus anytime as per their need.
30 •	Investor can earn unlimited profits by referring more and more members to the Ethereum Tree. User who refers other members will get benefits from both referral bonus as well as future dividend on referential bonus.
31 •	The best thing about Ethereum Tree is that the investors get profit based on percentage of total holdings which they have in Ethereum Tree. Holdings go on increasing with newly added members in the system and investor’s income from dividend also starts increasing.
32 
33 Admin can't do below things:
34 1. Withdraw funds from Ethereum Tree Contract
35 2. Modify EthereumTree contract
36 
37 Admin can do:
38 1. Invest in EthereumTree
39 2. Pay promoter from admin account. This will be deducted from admin investment in Ethereum Tree.
40 
41 */
42 contract owned {
43     
44     // set owner while creating Ethereum Tree contract. It will be ETH Address setting up Contract
45     constructor() public { owner = msg.sender; }
46     address payable owner;
47 
48     // This contract only defines a modifier but does not use
49     // it: it will be used in derived contracts.
50     // The function body is inserted where the special symbol
51     // `_;` in the definition of a modifier appears.
52     // This means that if the owner calls this function, the
53     // function is executed and otherwise, an exception is
54     // thrown.
55     
56     // Modifier onlyOwner to check transaction send is from owner or not for paying promotor fees. This fee will be deducted from admins investment in Ethereum Tree
57     modifier onlyOwner {
58         require(
59             msg.sender == owner,
60             "Only owner can call this function."
61         );
62         _;
63     }
64 }
65 
66 
67 // Contract Ethereum Tree
68 contract EthereumTree is owned{
69     
70     // solidity structure which hold record of investors transaction
71     struct Account 
72     {
73         uint accountBalance;
74         uint accountInvestment;
75         uint accountWithdrawedAmount;
76         uint accountReferralInvestment;
77         uint accountReferralBenefits;
78         uint accountEarnedHolderBenefits;
79         uint accountReferralCount;
80         uint index;
81     }
82 
83     mapping(address => Account) private Accounts;
84     address[] private accountIndex;
85     
86     // Solidity events which execute when users Invest or Withdraw funds in Ethereum Tree
87     event RegisterInvestment(address userAddress, uint totalInvestmentAmount, uint depositInUserAccount, uint balanceInUserAccount);
88     event RegisterWithdraw(address userAddress, uint totalWithdrawalAmount, uint withdrawToUserAccount, uint balanceInUserAccount);
89     
90     
91     //Function default payable which will store investment record in case anyone send Ethereum directly to contract address
92     function() external payable
93     {
94         investInEthereumTree();
95     }
96     
97     // Function to check user already part of Ethereum Tree
98     function isUser(address Address) public view returns(bool isIndeed) 
99     {
100         if(accountIndex.length == 0) return false;
101         return (accountIndex[Accounts[Address].index] == Address);
102     }
103     
104     // Function to get index of account record stored in Solidity structure
105     function getAccountAtIndex(uint index) public view returns(address Address)
106     {
107         return accountIndex[index];
108     }
109     
110     // Function to insert new user when invest or refer in Ethereum Tree. Set default balance to 0 before processing
111     function insertUser(address accountAddress) public returns(uint index)
112     {
113         require(!isUser(accountAddress));
114         
115         Accounts[accountAddress].accountBalance = 0;
116         Accounts[accountAddress].accountInvestment = 0;
117         Accounts[accountAddress].accountWithdrawedAmount = 0;
118         Accounts[accountAddress].accountReferralInvestment = 0;
119         Accounts[accountAddress].accountReferralBenefits = 0;
120         Accounts[accountAddress].accountEarnedHolderBenefits = 0;
121         Accounts[accountAddress].accountReferralCount = 0;
122         Accounts[accountAddress].index = accountIndex.push(accountAddress)-1;
123         return accountIndex.length-1;
124     }
125     
126     // Function  to get total account count present in Ethereum Tree
127     function getAccountCount() public view returns(uint count)
128     {
129         return accountIndex.length;
130     }
131     
132     // Function to get account balance of callling Ethereum address
133     function getAccountBalance() public view returns(uint accountBalance, uint accountInvestment, uint accountWithdrawedAmount, uint accountReferralInvestment, uint accountReferralBenefits, uint accountEarnedHolderBenefits, uint accountReferralCount, uint index)
134     {
135         address accountAddress = msg.sender;
136         if (isUser(accountAddress))
137         {
138             return (Accounts[accountAddress].accountBalance, Accounts[accountAddress].accountInvestment, Accounts[accountAddress].accountWithdrawedAmount, Accounts[accountAddress].accountReferralInvestment, Accounts[accountAddress].accountReferralBenefits, Accounts[accountAddress].accountEarnedHolderBenefits, Accounts[accountAddress].accountReferralCount, Accounts[accountAddress].index);
139         }
140         else
141         {
142             return (0, 0, 0, 0, 0, 0, 0, 0);
143         }
144         
145     }
146     
147     // Function to get account balance of any address in Ethereum Tree
148     function getAccountBalance(address Address) public view returns(uint accountBalance, uint accountInvestment, uint accountWithdrawedAmount, uint accountReferralInvestment, uint accountReferralBenefits, uint accountEarnedHolderBenefits, uint accountReferralCount, uint index)
149     {
150         address accountAddress = Address;
151         if (isUser(accountAddress))
152         {
153             return (Accounts[accountAddress].accountBalance, Accounts[accountAddress].accountInvestment, Accounts[accountAddress].accountWithdrawedAmount, Accounts[accountAddress].accountReferralInvestment, Accounts[accountAddress].accountReferralBenefits, Accounts[accountAddress].accountEarnedHolderBenefits, Accounts[accountAddress].accountReferralCount, Accounts[accountAddress].index);
154         }
155         else
156         {
157             return (0, 0, 0, 0, 0, 0, 0, 0);
158         }
159         
160     }
161     
162     // Function to get account summary of wallet calling function along with contract balance
163     function getAccountSummary() public view returns(uint contractBalance, uint accountBalance, uint accountInvestment, uint accountWithdrawedAmount, uint accountReferralInvestment, uint accountReferralBenefits, uint accountEarnedHolderBenefits, uint accountReferralCount, uint index)
164     {
165         address accountAddress = msg.sender;
166         if (isUser(accountAddress))
167         {
168             return (address(this).balance, Accounts[accountAddress].accountBalance, Accounts[accountAddress].accountInvestment, Accounts[accountAddress].accountWithdrawedAmount, Accounts[accountAddress].accountReferralInvestment, Accounts[accountAddress].accountReferralBenefits, Accounts[accountAddress].accountEarnedHolderBenefits, Accounts[accountAddress].accountReferralCount, Accounts[accountAddress].index);
169         }
170         else
171         {
172             return (address(this).balance, 0, 0, 0, 0, 0, 0, 0, 0);
173         }
174         
175     }
176     
177     // Function to get account summary of other wallet along with contract balance
178     function getAccountSummary(address Address) public view returns(uint contractBalance, uint accountBalance, uint accountInvestment, uint accountWithdrawedAmount, uint accountReferralInvestment, uint accountReferralBenefits, uint accountEarnedHolderBenefits, uint accountReferralCount, uint index)
179     {
180         address accountAddress = Address;
181         
182         if (isUser(accountAddress))
183         {
184             return (address(this).balance, Accounts[accountAddress].accountBalance, Accounts[accountAddress].accountInvestment, Accounts[accountAddress].accountWithdrawedAmount, Accounts[accountAddress].accountReferralInvestment, Accounts[accountAddress].accountReferralBenefits, Accounts[accountAddress].accountEarnedHolderBenefits, Accounts[accountAddress].accountReferralCount, Accounts[accountAddress].index);    
185         }
186         else
187         {
188             return (address(this).balance, 0, 0, 0, 0, 0, 0, 0, 0);    
189         }
190         
191     }
192     
193     // Function to get total Ethereum tree contract balance
194     function getBalanceSummary() public view returns(uint accountBalance, uint accountInvestment, uint accountWithdrawedAmount, uint accountReferralInvestment, uint accountReferralBenefits, uint accountEarnedHolderBenefits, uint accountReferralCount)
195     {
196         accountBalance = 0;
197         accountInvestment = 0;
198         accountWithdrawedAmount = 0;
199         accountReferralInvestment = 0;
200         accountReferralBenefits = 0;
201         accountEarnedHolderBenefits = 0;
202         accountReferralCount = 0;
203         
204         // Read balance of alll account and return
205         for(uint i=0; i< accountIndex.length;i++)
206         {
207             accountBalance = accountBalance + Accounts[getAccountAtIndex(i)].accountBalance; 
208             accountInvestment =accountInvestment + Accounts[getAccountAtIndex(i)].accountInvestment;
209             accountWithdrawedAmount = accountWithdrawedAmount + Accounts[getAccountAtIndex(i)].accountWithdrawedAmount;
210             accountReferralInvestment = accountReferralInvestment + Accounts[getAccountAtIndex(i)].accountReferralInvestment;
211             accountReferralBenefits = accountReferralBenefits + Accounts[getAccountAtIndex(i)].accountReferralBenefits;
212             accountEarnedHolderBenefits = accountEarnedHolderBenefits + Accounts[getAccountAtIndex(i)].accountEarnedHolderBenefits;
213             accountReferralCount = accountReferralCount + Accounts[getAccountAtIndex(i)].accountReferralCount;
214         }
215         
216         return (accountBalance,accountInvestment, accountWithdrawedAmount, accountReferralInvestment, accountReferralBenefits,accountEarnedHolderBenefits,accountReferralCount);
217     }
218     
219     // Function which  will execute when user invest in Ethereum Tree to feed balance and assign divident to rest account
220     function investInEthereumTree() public payable returns(bool success)
221     {
222         require(msg.value > 0);
223         
224         uint iTotalInvestmentAmount = 0;
225         uint iInvestmentAmountToUserAccount = 0;
226         uint iInvestmentAmountToDistribute = 0;
227         
228         uint totalAccountBalance = 0;
229         uint totalaccountInvestment = 0;
230         uint totalAccountWithdrawedAmount = 0;
231         uint totalAccountReferralInvestment = 0;
232         uint totalAccountReferralBenefits = 0;
233         uint TotalAccountEarnedHolderBenefits = 0;
234         uint TotalAccountReferralCount = 0;
235         
236         // store value of Ethereum receiving
237         iTotalInvestmentAmount = msg.value;
238         
239         // Set investment amount to distribute in holders. As investor invested without referral link it will 10%
240         iInvestmentAmountToDistribute = (iTotalInvestmentAmount * 10) /100;
241         
242         // Set investment amount to distribute in investor account. As investor invested without referral link it will 10%
243         iInvestmentAmountToUserAccount = iTotalInvestmentAmount - iInvestmentAmountToDistribute;
244         
245         (totalAccountBalance,totalaccountInvestment,totalAccountWithdrawedAmount,totalAccountReferralInvestment,totalAccountReferralBenefits,TotalAccountEarnedHolderBenefits,TotalAccountReferralCount) = getBalanceSummary();
246         
247         if(!isUser(msg.sender))
248         {
249             insertUser(msg.sender);
250         }
251         
252         // If no one holding fund in Ethereum Tree then assign complete investment to user Accounts
253         if (totalAccountBalance == 0)
254         {
255             Accounts[msg.sender].accountBalance = Accounts[msg.sender].accountBalance + iTotalInvestmentAmount;
256             Accounts[msg.sender].accountInvestment = Accounts[msg.sender].accountInvestment + iTotalInvestmentAmount;
257 
258             emit RegisterInvestment(msg.sender, iTotalInvestmentAmount, iTotalInvestmentAmount, Accounts[msg.sender].accountBalance);
259 
260             return true;
261         }
262         else
263         {
264             // If previous holders holding ETH in Ethereum Tree then distribute them divident based on their holding in Ethereum Tree
265             for(uint i=0; i< accountIndex.length;i++)
266             {
267                 if (Accounts[getAccountAtIndex(i)].accountBalance != 0)
268                 {
269                     Accounts[getAccountAtIndex(i)].accountBalance = Accounts[getAccountAtIndex(i)].accountBalance + ((iInvestmentAmountToDistribute * Accounts[getAccountAtIndex(i)].accountBalance)/totalAccountBalance);
270                     Accounts[getAccountAtIndex(i)].accountEarnedHolderBenefits = Accounts[getAccountAtIndex(i)].accountEarnedHolderBenefits + ((iInvestmentAmountToDistribute * Accounts[getAccountAtIndex(i)].accountBalance)/totalAccountBalance);
271                 }                    
272             }
273             
274             // Set balance of investor in Ethereum Tree
275             Accounts[msg.sender].accountBalance = Accounts[msg.sender].accountBalance + iInvestmentAmountToUserAccount;
276             Accounts[msg.sender].accountInvestment = Accounts[msg.sender].accountInvestment + iTotalInvestmentAmount;
277             
278             // Register event abount Investment
279             emit RegisterInvestment(msg.sender, iTotalInvestmentAmount, iInvestmentAmountToUserAccount, Accounts[msg.sender].accountBalance);
280             
281             return true;
282         }
283     }
284     
285     // Function will be called when investment invest using referrial link
286     function investInEthereumTree(address ReferralAccount) public payable returns(bool success) {
287         require(msg.value > 0);
288         
289         // Store ReferralAccount address
290         address accReferralAccount = ReferralAccount;
291         
292         uint iTotalInvestmentAmount = 0;
293         uint iInvestmentAmountToUserAccount = 0;
294         uint iInvestmentAmountToReferralAccount = 0;
295         uint iInvestmentAmountToDistribute = 0;
296         
297         uint totalAccountBalance = 0;
298         uint totalaccountInvestment = 0;
299         uint totalAccountWithdrawedAmount = 0;
300         uint totalAccountReferralInvestment = 0;
301         uint totalAccountReferralBenefits = 0;
302         uint TotalAccountEarnedHolderBenefits = 0;
303         uint TotalAccountReferralCount = 0;
304         
305         // store value of Ethereum receiving
306         iTotalInvestmentAmount = msg.value;
307         
308         // Set investment amount to distribute to referral. As investor invested with referral link it will 3.33% of total investment or 33.33% of network fees
309         iInvestmentAmountToReferralAccount = ((iTotalInvestmentAmount * 10) /100)/3;
310         
311         // Set investment amount to distribute among holders as divident
312         iInvestmentAmountToDistribute = ((iTotalInvestmentAmount * 10) /100)-iInvestmentAmountToReferralAccount;
313         
314         // Set investment amount to update in investor account
315         iInvestmentAmountToUserAccount = iTotalInvestmentAmount - (iInvestmentAmountToReferralAccount + iInvestmentAmountToDistribute);
316 
317         // If investor using own referral link then distriibute all network fees in holders as divident
318         if(msg.sender == accReferralAccount)
319         {
320             iInvestmentAmountToDistribute = iInvestmentAmountToDistribute + iInvestmentAmountToReferralAccount;
321             iInvestmentAmountToReferralAccount = 0;
322         }
323         
324         (totalAccountBalance,totalaccountInvestment,totalAccountWithdrawedAmount,totalAccountReferralInvestment,totalAccountReferralBenefits,TotalAccountEarnedHolderBenefits,TotalAccountReferralCount) = getBalanceSummary();
325         
326         if(!isUser(msg.sender))
327         {
328             insertUser(msg.sender);
329         }
330         
331         if(!isUser(ReferralAccount))
332         {
333             insertUser(ReferralAccount);
334         }
335         
336         // If Ethereum Tree holders are not holding any fund assign fund to referral account and investor account
337         if (totalAccountBalance == 0)
338         {
339             Accounts[msg.sender].accountBalance = Accounts[msg.sender].accountBalance + iInvestmentAmountToUserAccount + iInvestmentAmountToDistribute;
340             Accounts[msg.sender].accountInvestment = Accounts[msg.sender].accountInvestment +  iTotalInvestmentAmount;
341             
342             if (msg.sender != ReferralAccount)
343             {
344                 Accounts[accReferralAccount].accountBalance = Accounts[accReferralAccount].accountBalance + iInvestmentAmountToReferralAccount;
345                 Accounts[accReferralAccount].accountReferralInvestment = Accounts[accReferralAccount].accountReferralInvestment + iTotalInvestmentAmount;    
346                 Accounts[accReferralAccount].accountReferralBenefits = Accounts[accReferralAccount].accountReferralBenefits + iInvestmentAmountToReferralAccount;
347                 Accounts[accReferralAccount].accountReferralCount = Accounts[accReferralAccount].accountReferralCount + 1;
348             }
349 
350             
351             emit RegisterInvestment(msg.sender, iTotalInvestmentAmount, iTotalInvestmentAmount, Accounts[msg.sender].accountBalance);
352             
353             return true;
354         }
355         else
356         {
357             // If previous holders holding ETH in Ethereum Tree then distribute them divident based on their holding in Ethereum Tree
358             for(uint i=0; i< accountIndex.length;i++)
359             {
360                 if (Accounts[getAccountAtIndex(i)].accountBalance != 0)
361                 {
362                     Accounts[getAccountAtIndex(i)].accountBalance = Accounts[getAccountAtIndex(i)].accountBalance + ((iInvestmentAmountToDistribute * Accounts[getAccountAtIndex(i)].accountBalance)/totalAccountBalance);
363                     Accounts[getAccountAtIndex(i)].accountEarnedHolderBenefits = Accounts[getAccountAtIndex(i)].accountEarnedHolderBenefits + ((iInvestmentAmountToDistribute * Accounts[getAccountAtIndex(i)].accountBalance)/totalAccountBalance);
364                 }                    
365             }
366             
367             // update investor account for new investment
368             Accounts[msg.sender].accountBalance = Accounts[msg.sender].accountBalance + iInvestmentAmountToUserAccount;
369             Accounts[msg.sender].accountInvestment = Accounts[msg.sender].accountInvestment +  iTotalInvestmentAmount;
370             
371             // update referral account with referral benefits
372             if (msg.sender != ReferralAccount){
373                 Accounts[accReferralAccount].accountBalance = Accounts[accReferralAccount].accountBalance + iInvestmentAmountToReferralAccount;
374                 Accounts[accReferralAccount].accountReferralInvestment = Accounts[accReferralAccount].accountReferralInvestment + iTotalInvestmentAmount;
375                 Accounts[accReferralAccount].accountReferralBenefits = Accounts[accReferralAccount].accountReferralBenefits + iInvestmentAmountToReferralAccount;
376                 Accounts[accReferralAccount].accountReferralCount = Accounts[accReferralAccount].accountReferralCount + 1;    
377             }
378             
379             emit RegisterInvestment(msg.sender, iTotalInvestmentAmount, iInvestmentAmountToUserAccount, Accounts[msg.sender].accountBalance);
380             
381             return true;
382         }
383     }
384     
385     // Function to withdraw fund from account of Ethereum Tree. User will be able to withdraw fund only he is holding and same will be deducted from account. On withdrawal 10% network fees will be distributed among holders
386     function withdraw(uint withdrawalAmount) public returns(bool success)
387     {
388         require(isUser(msg.sender) && Accounts[msg.sender].accountBalance >= withdrawalAmount);
389     
390         uint iTotalWithdrawalAmount = 0;
391         uint iWithdrawalAmountToUserAccount = 0;
392         uint iWithdrawalAmountToDistribute = 0;
393         
394         uint totalAccountBalance = 0;
395         uint totalaccountInvestment = 0;
396         uint totalAccountWithdrawedAmount = 0;
397         uint totalAccountReferralInvestment = 0;
398         uint totalAccountReferralBenefits = 0;
399         uint TotalAccountEarnedHolderBenefits = 0;
400         uint TotalAccountReferralCount = 0;
401         
402         iTotalWithdrawalAmount = withdrawalAmount;
403         iWithdrawalAmountToDistribute = (iTotalWithdrawalAmount * 10) /100;
404         iWithdrawalAmountToUserAccount = iTotalWithdrawalAmount - iWithdrawalAmountToDistribute;
405 
406         // deduct fund from user account initiate to withdraw        
407         Accounts[msg.sender].accountBalance = Accounts[msg.sender].accountBalance - iTotalWithdrawalAmount;
408         Accounts[msg.sender].accountWithdrawedAmount = Accounts[msg.sender].accountWithdrawedAmount + iTotalWithdrawalAmount;
409         
410         (totalAccountBalance,totalaccountInvestment,totalAccountWithdrawedAmount,totalAccountReferralInvestment,totalAccountReferralBenefits,TotalAccountEarnedHolderBenefits,TotalAccountReferralCount) = getBalanceSummary();
411     
412         // If only current user holding fund then withdraw complete initiated account without deducting network fees
413         if (totalAccountBalance == iTotalWithdrawalAmount)
414         {
415             msg.sender.transfer(iTotalWithdrawalAmount);
416             
417             emit RegisterWithdraw(msg.sender, iTotalWithdrawalAmount, iTotalWithdrawalAmount, Accounts[msg.sender].accountBalance);
418             
419             return true;
420         }
421         else
422         {
423             // If other users holding fund then deduct 10% network fees from withdrawal amount and ditribute it as divident between holders.
424             for(uint i=0; i< accountIndex.length;i++)
425             {
426                 if (Accounts[getAccountAtIndex(i)].accountBalance != 0)
427                 {
428                     Accounts[getAccountAtIndex(i)].accountBalance = Accounts[getAccountAtIndex(i)].accountBalance + ((iWithdrawalAmountToDistribute * Accounts[getAccountAtIndex(i)].accountBalance)/totalAccountBalance);
429                     Accounts[getAccountAtIndex(i)].accountEarnedHolderBenefits = Accounts[getAccountAtIndex(i)].accountEarnedHolderBenefits + ((iWithdrawalAmountToDistribute * Accounts[getAccountAtIndex(i)].accountBalance)/totalAccountBalance);
430                 }                    
431             }
432             
433             // initiate withdrawal to user account
434             msg.sender.transfer(iWithdrawalAmountToUserAccount);
435             
436             emit RegisterWithdraw(msg.sender, iTotalWithdrawalAmount, iWithdrawalAmountToUserAccount, Accounts[msg.sender].accountBalance);
437             
438             return true;
439         }
440     }
441     
442     //  Pay promotor fees from owner account. Note this amount will be deducted from owner holding in Ethereum Tree
443     function payPromoterRewardFromOwnerAccount(address addPromoter, uint iAmount) public onlyOwner returns(bool success)
444     {
445         require(isUser(msg.sender) && !(msg.sender == addPromoter) && (iAmount > 0) && (Accounts[msg.sender].accountBalance > Accounts[addPromoter].accountBalance));
446         
447         if (isUser(addPromoter)==false)
448         {
449             insertUser(addPromoter);
450         }
451         
452         Accounts[msg.sender].accountBalance = Accounts[msg.sender].accountBalance - iAmount;
453         Accounts[addPromoter].accountBalance = Accounts[addPromoter].accountBalance + iAmount;
454         
455         return true;
456     }
457     
458 }