1 pragma solidity 0.4.24;
2 
3 /**
4  * DO NOT SEND ETH TO THIS CONTRACT ON MAINNET.  ITS ONLY DEPLOYED ON MAINNET TO
5  * DISPROVE SOME FALSE CLAIMS ABOUT FOMO3D AND JEKYLL ISLAND INTERACTION.  YOU 
6  * CAN TEST ALL THE PAYABLE FUNCTIONS SENDING 0 ETH.  OR BETTER YET COPY THIS TO 
7  * THE TESTNETS.
8  * 
9  * IF YOU SEND ETH TO THIS CONTRACT IT CANNOT BE RECOVERED.  THERE IS NO WITHDRAW.
10  * 
11  * THE CHECK BALANCE FUNCTIONS ARE FOR WHEN TESTING ON TESTNET TO SHOW THAT ALTHOUGH 
12  * THE CORP BANK COULD BE FORCED TO REVERT TX'S OR TRY AND BURN UP ALL/MOST GAS
13  * FOMO3D STILL MOVES ON WITHOUT RISK OF LOCKING UP.  AND IN CASES OF REVERT OR  
14  * OOG INSIDE CORP BANK.  ALL WE AT TEAM JUST WOULD ACCOMPLISH IS JUSTING OURSELVES 
15  * OUT OF THE ETH THAT WAS TO BE SENT TO JEKYLL ISLAND.  FOREVER LEAVING IT UNCLAIMABLE
16  * IN FOMO3D CONTACT.  SO WE CAN ONLY HARM OURSELVES IF WE TRIED SUCH A USELESS 
17  * THING.  AND FOMO3D WILL CONTINUE ON, UNAFFECTED
18  */
19 
20 // this is deployed on mainnet at:  0x38aEfE9e8E0Fc938475bfC6d7E52aE28D39FEBD8
21 contract Fomo3d {
22     // create some data tracking vars for testing
23     bool public depositSuccessful_;
24     uint256 public successfulTransactions_;
25     uint256 public gasBefore_;
26     uint256 public gasAfter_;
27     
28     // create forwarder instance
29     Forwarder Jekyll_Island_Inc;
30     
31     // take addr for forwarder in constructor arguments
32     constructor(address _addr)
33         public
34     {
35         // set up forwarder to point to its contract location
36         Jekyll_Island_Inc = Forwarder(_addr);
37     }
38 
39     // some fomo3d function that deposits to Forwarder
40     function someFunction()
41         public
42         payable
43     {
44         // grab gas left
45         gasBefore_ = gasleft();
46         
47         // deposit to forwarder, uses low level call so forwards all gas
48         if (!address(Jekyll_Island_Inc).call.value(msg.value)(bytes4(keccak256("deposit()"))))  
49         {
50             // give fomo3d work to do that needs gas. what better way than storage 
51             // write calls, since their so costly.
52             depositSuccessful_ = false;
53             gasAfter_ = gasleft();
54         } else {
55             depositSuccessful_ = true;
56             successfulTransactions_++;
57             gasAfter_ = gasleft();
58         }
59     }
60     
61     // some fomo3d function that deposits to Forwarder
62     function someFunction2()
63         public
64         payable
65     {
66         // grab gas left
67         gasBefore_ = gasleft();
68         
69         // deposit to forwarder, uses low level call so forwards all gas
70         if (!address(Jekyll_Island_Inc).call.value(msg.value)(bytes4(keccak256("deposit2()"))))  
71         {
72             // give fomo3d work to do that needs gas. what better way than storage 
73             // write calls, since their so costly.
74             depositSuccessful_ = false;
75             gasAfter_ = gasleft();
76         } else {
77             depositSuccessful_ = true;
78             successfulTransactions_++;
79             gasAfter_ = gasleft();
80         }
81     }
82     
83     // some fomo3d function that deposits to Forwarder
84     function someFunction3()
85         public
86         payable
87     {
88         // grab gas left
89         gasBefore_ = gasleft();
90         
91         // deposit to forwarder, uses low level call so forwards all gas
92         if (!address(Jekyll_Island_Inc).call.value(msg.value)(bytes4(keccak256("deposit3()"))))  
93         {
94             // give fomo3d work to do that needs gas. what better way than storage 
95             // write calls, since their so costly.
96             depositSuccessful_ = false;
97             gasAfter_ = gasleft();
98         } else {
99             depositSuccessful_ = true;
100             successfulTransactions_++;
101             gasAfter_ = gasleft();
102         }
103     }
104     
105     // some fomo3d function that deposits to Forwarder
106     function someFunction4()
107         public
108         payable
109     {
110         // grab gas left
111         gasBefore_ = gasleft();
112         
113         // deposit to forwarder, uses low level call so forwards all gas
114         if (!address(Jekyll_Island_Inc).call.value(msg.value)(bytes4(keccak256("deposit4()"))))  
115         {
116             // give fomo3d work to do that needs gas. what better way than storage 
117             // write calls, since their so costly.
118             depositSuccessful_ = false;
119             gasAfter_ = gasleft();
120         } else {
121             depositSuccessful_ = true;
122             successfulTransactions_++;
123             gasAfter_ = gasleft();
124         }
125     }
126     
127     // for data tracking lets make a function to check this contracts balance
128     function checkBalance()
129         public
130         view
131         returns(uint256)
132     {
133         return(address(this).balance);
134     }
135     
136 }
137 
138 
139 // heres a sample forwarder with a copy of the jekyll island forwarder (requirements on 
140 // msg.sender removed for simplicity since its irrelevant to testing this.  and some
141 // tracking vars added for test.)
142 
143 // this is deployed on mainnet at:  0x8F59323d8400CC0deE71ee91f92961989D508160
144 contract Forwarder {
145     // lets create some tracking vars 
146     bool public depositSuccessful_;
147     uint256 public successfulTransactions_;
148     uint256 public gasBefore_;
149     uint256 public gasAfter_;
150     
151     // create an instance of the jekyll island bank 
152     Bank currentCorpBank_;
153     
154     // take an address in the constructor arguments to set up bank with 
155     constructor(address _addr)
156         public
157     {
158         // point the created instance to the address given
159         currentCorpBank_ = Bank(_addr);
160     }
161     
162     function deposit()
163         public 
164         payable
165         returns(bool)
166     {
167         // grab gas at start
168         gasBefore_ = gasleft();
169         
170         if (currentCorpBank_.deposit.value(msg.value)(msg.sender) == true) {
171             depositSuccessful_ = true;    
172             successfulTransactions_++;
173             gasAfter_ = gasleft();
174             return(true);
175         } else {
176             depositSuccessful_ = false;
177             gasAfter_ = gasleft();
178             return(false);
179         }
180     }
181     
182     function deposit2()
183         public 
184         payable
185         returns(bool)
186     {
187         // grab gas at start
188         gasBefore_ = gasleft();
189         
190         if (currentCorpBank_.deposit2.value(msg.value)(msg.sender) == true) {
191             depositSuccessful_ = true;    
192             successfulTransactions_++;
193             gasAfter_ = gasleft();
194             return(true);
195         } else {
196             depositSuccessful_ = false;
197             gasAfter_ = gasleft();
198             return(false);
199         }
200     }
201     
202     function deposit3()
203         public 
204         payable
205         returns(bool)
206     {
207         // grab gas at start
208         gasBefore_ = gasleft();
209         
210         if (currentCorpBank_.deposit3.value(msg.value)(msg.sender) == true) {
211             depositSuccessful_ = true;    
212             successfulTransactions_++;
213             gasAfter_ = gasleft();
214             return(true);
215         } else {
216             depositSuccessful_ = false;
217             gasAfter_ = gasleft();
218             return(false);
219         }
220     }
221     
222     function deposit4()
223         public 
224         payable
225         returns(bool)
226     {
227         // grab gas at start
228         gasBefore_ = gasleft();
229         
230         if (currentCorpBank_.deposit4.value(msg.value)(msg.sender) == true) {
231             depositSuccessful_ = true;    
232             successfulTransactions_++;
233             gasAfter_ = gasleft();
234             return(true);
235         } else {
236             depositSuccessful_ = false;
237             gasAfter_ = gasleft();
238             return(false);
239         }
240     }
241     
242     // for data tracking lets make a function to check this contracts balance
243     function checkBalance()
244         public
245         view
246         returns(uint256)
247     {
248         return(address(this).balance);
249     }
250     
251 }
252 
253 // heres the bank with various ways someone could try and migrate to a bank that 
254 // screws the tx.  to show none of them effect fomo3d.
255 
256 // this is deployed on mainnet at:  0x0C2DBC98581e553C4E978Dd699571a5DED408a4F
257 contract Bank {
258     // lets use storage writes to this to burn up all gas
259     uint256 public i = 1000000;
260     uint256 public x;
261     address public fomo3d;
262     
263     /**
264      * this version will use up most gas.  but return just enough to make it back
265      * to fomo3d.  yet not enough for fomo3d to finish its execution (according to 
266      * the theory of the exploit.  which when you run this you'll find due to my 
267      * use of ! in the call from fomo3d to forwarder, and the use of a normal function 
268      * call from forwarder to bank, this fails to stop fomo3d from continuing)
269      */
270     function deposit(address _fomo3daddress)
271         external
272         payable
273         returns(bool)
274     {
275         // burn all gas leaving just enough to get back to fomo3d  and it to do
276         // a write call in a attempt to make Fomo3d OOG (doesn't work cause fomo3d 
277         // protects itself from this behavior)
278         while (i > 41000)
279         {
280             i = gasleft();
281         }
282         
283         return(true);
284     }
285     
286     /**
287      * this version just tries a plain revert.  (pssst... fomo3d doesn't care)
288      */
289     function deposit2(address _fomo3daddress)
290         external
291         payable
292         returns(bool)
293     {
294         // straight up revert (since we use low level call in fomo3d it doesn't 
295         // care if we revert the internal tx to bank.  this behavior would only 
296         // screw over team just, not effect fomo3d)
297         revert();
298     }
299     
300     /**
301      * this one tries an infinite loop (another fail.  fomo3d trudges on)
302      */
303     function deposit3(address _fomo3daddress)
304         external
305         payable
306         returns(bool)
307     {
308         // this infinite loop still does not stop fomo3d from running.
309         while(1 == 1) {
310             x++;
311             fomo3d = _fomo3daddress;
312         }
313         return(true);
314     }
315     
316     /**
317      * this one just runs a set length loops that OOG's (and.. again.. fomo3d still works)
318      */
319     function deposit4(address _fomo3daddress)
320         public
321         payable
322         returns(bool)
323     {
324         // burn all gas (fomo3d still keeps going)
325         for (uint256 i = 0; i <= 1000; i++)
326         {
327             x++;
328             fomo3d = _fomo3daddress;
329         }
330     }
331     
332     // for data tracking lets make a function to check this contracts balance
333     function checkBalance()
334         public
335         view
336         returns(uint256)
337     {
338         return(address(this).balance);
339     }
340 }