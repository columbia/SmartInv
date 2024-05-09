1 pragma solidity 0.4.24;
2 contract Owned 
3 {
4     address public owner;
5     address public ownerCandidate;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15     
16     function changeOwner(address _newOwner) public onlyOwner {
17         ownerCandidate = _newOwner;
18     }
19     
20     function acceptOwnership() public {
21         require(msg.sender == ownerCandidate);  
22         owner = ownerCandidate;
23     }
24 }
25 
26 contract Priced
27 {
28     modifier costs(uint price)
29     {
30         //They must pay exactly 0.5 eth
31         require(msg.value == price);
32         _;
33     }
34 }
35 //UPDATED 9/8/18: Added auto unlock
36 //                Changed the Register to track people so it does not have to loop through 
37 //UPDATED 9/10/18: Changed it to only accept 0.5 eth, anything over or under will just fail
38 
39 contract Teris is Owned, Priced
40 {
41     string public debugString;
42     
43     //Wallets
44     address adminWallet = 0x45FEbD925Aa0439eE6bF2ffF5996201e199Efb5b;
45 
46     //wallet rotations
47     uint8 public devWalletRotation = 0;
48     
49     //To set up for only 4 active transactions
50     mapping(address => uint8) transactionLimits;
51     
52     //Lock the contract after 640 transactions! (uint16 stores up to 65,535)
53     // Changednge to 10 for testing
54     uint256 maxTransactions = 640;
55     uint16 totalTransactions;
56     modifier notLocked()
57     {
58         require(!isLocked());
59         _;
60     }
61     
62     //Structs
63     struct Participant
64     {
65         address ethAddress;
66         bool paid;
67     }
68     
69     Participant[] allParticipants;
70     uint16 lastPaidParticipant;
71     
72     //Set up a blacklist
73      mapping(address => bool) blacklist;
74 
75     bool testing = false;
76     
77     /* ------------------------------------------------
78     //              MAIN FUNCTIONS
79     ---------------------------------------------------*/   
80 
81     //Silentflame - Added costs(500 finney)
82     function register() public payable costs(500 finney) notLocked
83     {
84         //Silentflame - Added to remove exponential gas cost increase on register
85         transactionLimits[msg.sender]++;    
86         
87         if(!testing)
88         {
89             require(_checkTransactions(msg.sender));
90         }
91         
92         require(!blacklist[msg.sender]);
93             
94         
95         //transfer eth to admin wallet
96         _payFees();
97         
98         //add user to the participant list, as unpaid
99         allParticipants.push(Participant(msg.sender, false));
100         
101         //Count this transaction
102         totalTransactions++;
103         
104         //try and pay whoever you can
105         _payout();
106         
107     }
108     
109     /* ------------------------------------------------
110     //              INTERNAL FUNCTIONS
111     ---------------------------------------------------*/
112     
113     function _checkTransactions(address _toCheck) private view returns(bool)
114     {
115         //Silentflame - Removed old logic!
116         
117         //Silentflame - Added to remove exponential gas cost increase on register
118         if(transactionLimits[_toCheck] > 4)
119             return false;
120         else
121             return true;
122         
123         
124     }
125     
126     //Pays the Admin fees
127     function _payFees() private
128     {
129         adminWallet.transfer(162500000000000000); // .1625
130    
131 
132         address walletAddress ;
133         devWalletRotation++;
134         
135         
136         if(devWalletRotation >= 7)
137             devWalletRotation = 1;
138         
139         if(devWalletRotation == 1)
140             walletAddress = 0x556FD37b59D20C62A778F0610Fb1e905b112b7DE;
141         else if(devWalletRotation == 2)
142             walletAddress = 0x92f94ecdb1ba201cd0e4a0a9a9bccb1faa3a3de0;
143         else if(devWalletRotation == 3)
144             walletAddress = 0x41271507434E21dBd5F09624181d7Cd70Bf06Cbf;
145         else if (devWalletRotation == 4)
146             walletAddress = 0xbeb07c2d5beca948eb7d7eaf60a30e900f470f8d;
147         else if (devWalletRotation == 5)
148             walletAddress = 0xcd7c53462067f0d0b8809be9e3fb143679a270bb;
149         else if (devWalletRotation == 6)
150             walletAddress = 0x9184B1D0106c1b7663D4C3bBDBF019055BB813aC;
151         else
152             walletAddress = adminWallet;
153             
154             
155             
156         
157         walletAddress.transfer(25000000000000000);
158         
159 
160     }
161 
162     //Tries to pay people, starting from the last paid transaction
163     function _payout() private
164     {
165 
166         for(uint16 i = lastPaidParticipant; i < allParticipants.length; i++)
167         {
168             if(allParticipants[i].paid)
169             {
170                 lastPaidParticipant = i;
171                 continue;
172             }
173             else
174             {
175                 if(address(this).balance < 625000000000000000)
176                     break;
177                 
178                 allParticipants[i].ethAddress.transfer(625000000000000000);
179                 allParticipants[i].paid = true;
180                 transactionLimits[allParticipants[i].ethAddress]--; //Silentflame - added to remove gas cost on register
181                 lastPaidParticipant = i;
182             }
183         }
184         
185         //Silentflame attemptAutoUnlock
186         if(lastPaidParticipant >= maxTransactions)
187             _unlockContract();
188     }
189     
190     function _unlockContract() internal
191     {
192         //Clear all the transaction limits
193         for(uint256 i = 0; i < allParticipants.length; i++)
194         {
195             transactionLimits[allParticipants[i].ethAddress] = 0;
196         }
197         
198         //delete all the participants
199         delete allParticipants;
200 
201         lastPaidParticipant = 0;
202         
203         //If there is any remaining funds (there shouldnt be) send it to trading wallet
204         adminWallet.transfer(address(this).balance);
205         totalTransactions = 0;
206     }
207 
208     /* ------------------------------------------------
209     //                ADMIN FUNCTIONS
210     ---------------------------------------------------*/
211     function changeMaxTransactions(uint256 _amount) public onlyOwner
212     {
213         maxTransactions = _amount;
214     }
215     
216     function unlockContract() public onlyOwner
217     {
218          //Clear all the transaction limits
219         for(uint256 i = 0; i < allParticipants.length; i++)
220         {
221             transactionLimits[allParticipants[i].ethAddress] = 0;
222         }
223         
224         //delete all the participants
225         delete allParticipants;
226 
227         lastPaidParticipant = 0;
228         
229         //If there is any remaining funds (there shouldnt be) send it to trading wallet
230         adminWallet.transfer(address(this).balance);
231         totalTransactions = 0;       
232     }
233 
234     //Allows an injection to add balance into the contract without
235     //creating a new contract.
236     function addBalance() payable public onlyOwner
237     {
238         _payout();
239     }
240     
241     function forcePayout() public onlyOwner
242     {
243         _payout();
244     }
245     
246     function isTesting() public view onlyOwner returns(bool) 
247     {
248         return(testing);
249     }
250     
251     function changeAdminWallet(address _newWallet) public onlyOwner
252     {
253         adminWallet = _newWallet;
254     }
255     
256     function setTesting(bool _testing) public onlyOwner
257     {
258         testing = _testing;
259     }
260     
261     function addToBlackList(address _addressToAdd) public onlyOwner
262     {
263         blacklist[_addressToAdd] = true;
264     }
265     
266     function removeFromBlackList(address _addressToRemove) public onlyOwner
267     {
268         blacklist[_addressToRemove] = false;
269     }
270 
271     /* ------------------------------------------------
272     //                      GETTERS
273     ---------------------------------------------------*/
274     function checkMyTransactions() public view returns(uint256)
275     {
276         return transactionLimits[msg.sender];
277     }
278     
279     function getPeopleBeforeMe(address _address) public view returns(uint256)
280     {
281         uint counter = 0;
282         
283         for(uint16 i = lastPaidParticipant; i < allParticipants.length; i++)
284         {
285             if(allParticipants[i].ethAddress != _address)
286             {
287                 counter++;
288             }
289             else
290             {
291                 break;
292             }
293         }
294         
295         return counter;
296     }
297     
298     function getMyOwed(address _address) public view returns(uint256)
299     {
300         uint counter = 0;
301         
302         for(uint16 i = 0; i < allParticipants.length; i++)
303         {
304             if(allParticipants[i].ethAddress == _address)
305             {
306                 if(!allParticipants[i].paid)
307                 {
308                     counter++;
309                 }
310             }
311         }
312         
313         return (counter * 625000000000000000);
314     }
315     
316     //For seeing how much balance is in the contract
317     function getBalance() public view returns(uint256)
318     {
319         return address(this).balance;
320     }
321     
322     //For seeing if the contract is locked
323     function isLocked() public view returns(bool)
324     {
325         if(totalTransactions >= maxTransactions)
326             return true;
327         else
328             return false;
329     }
330 
331     //For seeing how many transactions a user has put into the system
332     function getParticipantTransactions(address _address) public view returns(uint8)
333     {
334         return transactionLimits[_address];
335     }
336     
337     //For getting the details about a transaction (the address and if the transaction was paid)
338     function getTransactionInformation(uint _id) public view returns(address, bool)
339     {
340         return(allParticipants[_id].ethAddress, allParticipants[_id].paid);
341     }
342 
343     //For getting the ID of the last Paid transaction
344     function getLastPaidTransaction() public view returns(uint)
345     {
346         return (lastPaidParticipant);
347     }
348     
349     //For getting how many transactions there are total
350     function getNumberOfTransactions() public view returns(uint)
351     {
352         return (allParticipants.length);
353     }
354 }