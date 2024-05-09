1 pragma solidity ^0.4.21;
2 
3 
4 
5 contract POOHMOWHALE 
6 {
7     
8     /**
9      * Modifiers
10      */
11     modifier onlyOwner()
12     {
13         require(msg.sender == owner);
14         _;
15     }
16     
17     modifier notPOOH(address aContract)
18     {
19         require(aContract != address(poohContract));
20         _;
21     }
22    
23     /**
24      * Events
25      */
26     event Deposit(uint256 amount, address depositer);
27     event Purchase(uint256 amountSpent, uint256 tokensReceived);
28     event Sell();
29     event Payout(uint256 amount, address creditor);
30     event Transfer(uint256 amount, address paidTo);
31 
32    /**
33      * Global Variables
34      */
35     address owner;
36     address game;
37     bool payDoublr;
38     uint256 tokenBalance;
39     POOH poohContract;
40     DOUBLR doublr;
41     
42     /**
43      * Constructor
44      */
45     constructor() 
46     public 
47     {
48         owner = msg.sender;
49         poohContract = POOH(address(0x4C29d75cc423E8Adaa3839892feb66977e295829));
50         doublr = DOUBLR(address(0xd69b75D5Dc270E4F6cD664Ac2354d12423C5AE9e));
51         tokenBalance = 0;
52         payDoublr = true;
53     }
54     
55     function() payable public 
56     {
57         donate();
58     }
59      
60     /**
61      * Only way to give POOHMOWHALE ETH is via by using fallback
62      */
63     function donate() 
64     internal 
65     {
66         //You have to send more than 1000000 wei
67         require(msg.value > 1000000 wei);
68         uint256 ethToTransfer = address(this).balance;
69 
70         //if we are in doublr-mode, pay the assigned doublr
71         if(payDoublr)
72         {
73             if(ethToTransfer > 0)
74             {
75                 address(doublr).transfer(ethToTransfer - 1000000);
76                 doublr.payout.gas(1000000)();
77             }
78         }
79         else
80         {
81             uint256 PoohEthInContract = address(poohContract).balance;
82            
83             // if POOH contract balance is less than 5 ETH, POOH is dead and there's no use pumping it
84             if(PoohEthInContract < 5 ether)
85             {
86 
87                 poohContract.exit();
88                 tokenBalance = 0;
89                 
90                 owner.transfer(ethToTransfer);
91                 emit Transfer(ethToTransfer, address(owner));
92             }
93 
94             //let's buy/sell tokens to give dividends to POOH tokenholders
95             else
96             {
97                 tokenBalance = myTokens();
98                  //if token balance is greater than 0, sell and rebuy 
99                 if(tokenBalance > 0)
100                 {
101                     poohContract.exit();
102                     tokenBalance = 0;
103 
104                     if(ethToTransfer > 0)
105                     {
106                         poohContract.buy.value(ethToTransfer)(0x0);
107                     }
108                     else
109                     {
110                         poohContract.buy.value(msg.value)(0x0);
111 
112                     }
113        
114                 }
115                 else
116                 {   
117                     //we have no tokens, let's buy some if we have eth
118                     if(ethToTransfer > 0)
119                     {
120                         poohContract.buy.value(ethToTransfer)(0x0);
121                         tokenBalance = myTokens();
122                         //Emit a deposit event.
123                         emit Deposit(msg.value, msg.sender);
124                     }
125                 }
126             }
127         }
128     }
129     
130     
131     /**
132      * Number of tokens the contract owns.
133      */
134     function myTokens() 
135     public 
136     view 
137     returns(uint256)
138     {
139         return poohContract.myTokens();
140     }
141     
142     /**
143      * Number of dividends owed to the contract.
144      */
145     function myDividends() 
146     public 
147     view 
148     returns(uint256)
149     {
150         return poohContract.myDividends(true);
151     }
152 
153     /**
154      * ETH balance of contract
155      */
156     function ethBalance() 
157     public 
158     view 
159     returns (uint256)
160     {
161         return address(this).balance;
162     }
163 
164     /**
165      * Address of game contract that ETH gets sent to
166      */
167     function assignedDoublrContract() 
168     public 
169     view 
170     returns (address)
171     {
172         return address(doublr);
173     }
174     
175     /**
176      * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.
177      */
178     function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) 
179     public 
180     onlyOwner() 
181     notPOOH(tokenAddress) 
182     returns (bool success) 
183     {
184         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
185     }
186     
187      /**
188      * Owner can update which Doublr the POOHMOWHALE pays to
189      */
190     function changeDoublr(address doublrAddress) 
191     public
192     onlyOwner()
193     {
194         doublr = DOUBLR(doublrAddress);
195     }
196 
197     /**
198      * Owner can update POOHMOWHALE to stop paying doublr and act as whale
199      */
200     function switchToWhaleMode(bool answer)
201     public
202     onlyOwner()
203     {
204         payDoublr = answer;
205     }
206 }
207 
208 //Define the POOH token for the POOHMOWHALE
209 contract POOH 
210 {
211     function buy(address) public payable returns(uint256);
212     function sell(uint256) public;
213     function withdraw() public;
214     function myTokens() public view returns(uint256);
215     function myDividends(bool) public view returns(uint256);
216     function exit() public;
217     function totalEthereumBalance() public view returns(uint);
218 }
219 
220 
221 //Define the Doublr contract for the POOHMOWHALE
222 contract DOUBLR
223 {
224     function payout() public; 
225     function myDividends() public view returns(uint256);
226     function withdraw() public;
227 }
228 
229 //Define ERC20Interface.transfer, so POOHMOWHALE can transfer tokens accidently sent to it.
230 contract ERC20Interface 
231 {
232     function transfer(address to, uint256 tokens) 
233     public 
234     returns (bool success);
235 }