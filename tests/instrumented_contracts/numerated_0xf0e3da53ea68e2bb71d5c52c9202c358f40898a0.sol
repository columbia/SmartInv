1 pragma solidity ^0.4.20;
2 
3 //////////////////////////////////////////////////////////////////////////////////////////////////////
4 //                                                                                                  //
5 //                                       SAFE MATH LIBRARY                                          //
6 //                                                                                                  //
7 //////////////////////////////////////////////////////////////////////////////////////////////////////
8 
9 library SafeMath {
10     function add(uint a, uint b) internal pure returns (uint c) {
11         c = a + b;
12         require(c >= a);
13     }
14     function sub(uint a, uint b) internal pure returns (uint c) {
15         require(b <= a);
16         c = a - b;
17     }
18     function mul(uint a, uint b) internal pure returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22     function div(uint a, uint b) internal pure returns (uint c) {
23         require(b > 0);
24         c = a / b;
25     }
26 }
27 
28 
29 //////////////////////////////////////////////////////////////////////////////////////////////////////
30 //                                                                                                  //
31 //                                       ERC20 INTERFACE                                            //
32 //                                                                                                  //
33 //////////////////////////////////////////////////////////////////////////////////////////////////////
34 
35 contract ERC20Interface {
36     function totalSupply() public constant returns (uint);
37     function balanceOf(address tokenOwner) public constant returns (uint balance);
38     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
39     function transfer(address to, uint tokens) public returns (bool success);
40     function approve(address spender, uint tokens) public returns (bool success);
41     function transferFrom(address from, address to, uint tokens) public returns (bool success);
42 
43     event Transfer(address indexed from, address indexed to, uint tokens);
44     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
45 }
46 
47 
48 //////////////////////////////////////////////////////////////////////////////////////////////////////
49 //                                                                                                  //
50 //                                      GAME EVENT INTERFACE                                        //
51 //                                                                                                  //
52 //////////////////////////////////////////////////////////////////////////////////////////////////////
53 
54 contract GameEventInterface {
55     event BuyTickets(address game, address to, uint amount);
56     event Winner(address game, address to, uint prize, uint random_number, uint buyer_who_won);
57     event Jackpot(address game, address to, uint jackpot);
58 }
59 
60 //////////////////////////////////////////////////////////////////////////////////////////////////////
61 //                                                                                                  //
62 //                                    AWARD TOKEN INTERFACE                                         //
63 //                                                                                                  //
64 //////////////////////////////////////////////////////////////////////////////////////////////////////
65 
66 contract AwardsTokensInterface {
67     function awardToken(address toAddress, uint amount) public;
68     function receiveFromGame() public payable;
69     function addGame(address gameAddress, uint amount) public;
70 }
71 
72 
73 //////////////////////////////////////////////////////////////////////////////////////////////////////
74 //                                                                                                  //
75 //                                          ICO CONTRACT                                            //
76 //                                                                                                  //
77 //////////////////////////////////////////////////////////////////////////////////////////////////////
78 
79 contract ICO is ERC20Interface {
80     using SafeMath for uint;
81     
82     /////////////////////////----- VARIABLES -----////////////////////////////////////
83                                                                                     //
84     string public constant symbol = "FXT";                                          //
85     string public constant name = "Fortunity Owners Token";                         //
86     uint8 public constant decimals = 18;                                            //
87     uint256 _totalSupply = (1000000 * 10**uint(decimals)); // 1M tokens             //
88     mapping(address => uint256) balances;                                           //
89     mapping(address => mapping (address => uint256)) allowed;                       //
90                                                                                     //
91     //OWNERS                                                                        //
92     address public owner;                                                           //
93     address public affiliate; //will have owner rights                              //
94                                                                                     //
95     //FOR ICO DIVIDEND PAYOUT                                                       //
96     uint public payoutRound;                                                        //
97     bool public payoutOpen;                                                         //
98     uint public payoutProfit;                                                       //
99     uint public lastPayoutTime;                                                     //
100     mapping(address => uint) payoutPaidoutRound;                                    //
101                                                                                     //
102     //////////////////////////////////////////////////////////////////////////////////
103     
104 
105   
106     /////////////////////////----- CONSTRUCTOR -----//////////////////////////////////
107                                                                                     //
108     function ICO() public {                                                         //
109         owner               = msg.sender;                                           //
110         balances[owner]     = _totalSupply;                                         //
111         Transfer(address(0), msg.sender, _totalSupply);                             //
112         affiliate           = msg.sender;                                           //
113         payoutRound        = 0;                                                     //
114         payoutOpen         = false;                                                 //
115         payoutProfit       = 0;                                                     //
116         lastPayoutTime     = 0;                                                     //
117     }                                                                               //
118                                                                                     //
119     //Midifier                                                                      //
120     modifier onlyAdmin () {                                                         //
121         require((msg.sender == owner) || (msg.sender == affiliate));                //                                                                         //
122         _;                                                                          //
123     }                                                                               //
124                                                                                     //
125     //////////////////////////////////////////////////////////////////////////////////
126     
127     
128     /////////////////////////----- GAME SPECIFIC -----////////////////////////////////
129     event EthReceived(address inAddress, uint amount);                              //
130                                                                                     //
131     function() public payable {                                                     //
132         msg.sender.transfer(msg.value);                                             //
133     }                                                                               //
134                                                                                     //    
135     function receiveFromGame() public payable {                                     //
136         EthReceived(msg.sender, msg.value);                                         //
137     }                                                                               //
138                                                                                     //
139     //////////////////////////////////////////////////////////////////////////////////                                                                                    //
140                                                                                     
141                                                                                     
142                                                                                     
143     ///////////////////////////----- ICO SPECIFIC -----///////////////////////////////
144                                                                                     //
145     event PayoutStatus(bool status);                                                //
146                                                                                     //
147     //Open for ICO DIVIDEND payout round                                            //
148     function openPayout() public onlyAdmin {                                        //
149         require(!payoutOpen);                                                       //
150         payoutRound += 1;                                                           //
151         payoutOpen = true;                                                          //
152         payoutProfit = address(this).balance;                                       //
153         lastPayoutTime = now;                                                       //
154         PayoutStatus(payoutOpen);                                                   //
155     }                                                                               //
156                                                                                     //
157     //close for ICO DIVIDEND payout round                                           //
158     function closePayout() public onlyAdmin {                                       //
159         require(lastPayoutTime < (now.add(7 days)));                                //
160         payoutOpen = false;                                                         //
161         PayoutStatus(payoutOpen);                                                   //
162     }                                                                               //
163                                                                                     //
164     //ICO DIVIDEND Payout                                                           //
165     function requestDividendPayout() public {                                       //
166         require(payoutOpen);                                                        //
167         require(payoutPaidoutRound[msg.sender] != payoutRound);                     //
168         payoutPaidoutRound[msg.sender] = payoutRound;                               //
169         msg.sender.transfer((payoutProfit.mul(balances[msg.sender])).div(_totalSupply));
170     }                                                                               //
171                                                                                     //
172                                                                                     //
173     //////////////////////////////////////////////////////////////////////////////////
174 
175 
176 
177     ///////////////////////////----- OWNER SPECIFIC -----/////////////////////////////
178                                                                                     //
179     function changeAffiliate(address newAffiliate) public onlyAdmin {               //
180         require(newAffiliate != address(0));                                        //
181         affiliate = newAffiliate;                                                   //
182     }                                                                               //
183                                                                                     //
184     function takeAll() public onlyAdmin {                                           //
185         msg.sender.transfer(address(this).balance);                                 //
186     }                                                                               //
187     //////////////////////////////////////////////////////////////////////////////////
188     
189     
190     
191     ////////////////////////----- ERC20 IMPLEMENTATION -----//////////////////////////
192                                                                                     //
193     function totalSupply() public constant returns (uint) {                         //
194         return _totalSupply;                                                        //
195     }                                                                               //
196                                                                                     //
197     function balanceOf(address tokenOwner) public constant returns (uint balance) { //
198         return balances[tokenOwner];                                                //
199     }                                                                               //
200                                                                                     //
201     function transfer(address to, uint tokens) public returns (bool success) {      //
202         require(!payoutOpen);                                                       //
203         require(to != address(0));                                                  //                                  
204         balances[msg.sender] = balances[msg.sender].sub(tokens);                    //
205         balances[to] = balances[to].add(tokens);                                    //
206         Transfer(msg.sender, to, tokens);                                           //
207         return true;                                                                //
208     }                                                                               //
209                                                                                     //
210     function approve(address spender, uint tokens) public returns (bool success) {  //
211         allowed[msg.sender][spender] = tokens;                                      //
212         Approval(msg.sender, spender, tokens);                                      //
213         return true;                                                                //
214     }                                                                               //
215                                                                                     //
216     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
217         require(!payoutOpen);                                                       //
218         require(to != address(0));                                                  //
219         balances[from] = balances[from].sub(tokens);                                //
220         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);          //
221         balances[to] = balances[to].add(tokens);                                    //
222         Transfer(from, to, tokens);                                                 //
223         return true;                                                                //
224     }                                                                               //
225                                                                                     //
226     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
227         return allowed[tokenOwner][spender];                                        //
228     }                                                                               //
229                                                                                     //
230     //////////////////////////////////////////////////////////////////////////////////
231 }