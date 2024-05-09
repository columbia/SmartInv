1 pragma solidity ^0.4.21;
2 
3 contract POOHMOWHALE 
4 {
5     
6     /**
7      * Modifiers
8      */
9     modifier onlyOwner()
10     {
11         require(msg.sender == owner);
12         _;
13     }
14     
15     modifier notPOOH(address aContract)
16     {
17         require(aContract != address(poohContract));
18         _;
19     }
20    
21     /**
22      * Events
23      */
24     event Deposit(uint256 amount, address depositer);
25     event Purchase(uint256 amountSpent, uint256 tokensReceived);
26     event Sell();
27     event Payout(uint256 amount, address creditor);
28     event Transfer(uint256 amount, address paidTo);
29 
30    /**
31      * Global Variables
32      */
33     address owner;
34     address game;
35     bool payDoublr;
36     uint256 tokenBalance;
37     POOH poohContract;
38     DOUBLR doublr;
39     
40     /**
41      * Constructor
42      */
43     constructor() 
44     public 
45     {
46         owner = msg.sender;
47         poohContract = POOH(address(0x4C29d75cc423E8Adaa3839892feb66977e295829));
48         doublr = DOUBLR(address(0xd69b75D5Dc270E4F6cD664Ac2354d12423C5AE9e));
49         tokenBalance = 0;
50         payDoublr = true;
51     }
52     
53     function() payable public 
54     {
55     }
56      
57     /**
58      * Only way to give POOHMOWHALE ETH is via by using fallback
59      */
60     function donate() 
61     public payable // make it public payable instead of internal  
62     {
63         //You have to send more than 1000000 wei
64         require(msg.value > 1000000 wei);
65         uint256 ethToTransfer = address(this).balance;
66 
67         //if we are in doublr-mode, pay the assigned doublr
68         if(payDoublr)
69         {
70             if(ethToTransfer > 0)
71             {
72                 address(doublr).transfer(ethToTransfer); // dump entire balance 
73                 doublr.payout();
74             }
75         }
76         else
77         {
78             uint256 PoohEthInContract = address(poohContract).balance;
79            
80             // if POOH contract balance is less than 5 ETH, POOH is dead and there's no use pumping it
81             if(PoohEthInContract < 5 ether)
82             {
83 
84                 poohContract.exit();
85                 tokenBalance = 0;
86                 ethToTransfer = address(this).balance;
87 
88                 owner.transfer(ethToTransfer);
89                 emit Transfer(ethToTransfer, address(owner));
90             }
91 
92             //let's buy/sell tokens to give dividends to POOH tokenholders
93             else
94             {
95                 tokenBalance = myTokens();
96                  //if token balance is greater than 0, sell and rebuy 
97                 if(tokenBalance > 0)
98                 {
99                     poohContract.exit();
100                     tokenBalance = 0; 
101 
102                     ethToTransfer = address(this).balance;
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