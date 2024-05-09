1 pragma solidity ^0.4.24;
2 
3 //
4 //                       .#########'
5 //                    .###############+
6 //                  ,####################
7 //                `#######################+
8 //               ;##########################
9 //              #############################.
10 //             ###############################,
11 //           +##################,    ###########`
12 //          .###################     .###########
13 //         ##############,          .###########+
14 //         #############`            .############`
15 //         ###########+                ############
16 //        ###########;                  ###########
17 //        ##########'                    ###########                                                                                      
18 //       '##########    '#.        `,     ##########                                                                                    
19 //       ##########    ####'      ####.   :#########;                                                                                   
20 //      `#########'   :#####;    ######    ##########                                                                                 
21 //      :#########    #######:  #######    :#########         
22 //      +#########    :#######.########     #########`       
23 //      #########;     ###############'     #########:       
24 //      #########       #############+      '########'        
25 //      #########        ############       :#########        
26 //      #########         ##########        ,#########        
27 //      #########         :########         ,#########        
28 //      #########        ,##########        ,#########        
29 //      #########       ,############       :########+        
30 //      #########      .#############+      '########'        
31 //      #########:    `###############'     #########,        
32 //      +########+    ;#######`;#######     #########         
33 //      ,#########    '######`  '######    :#########         
34 //       #########;   .#####`    '#####    ##########         
35 //       ##########    '###`      +###    :#########:         
36 //       ;#########+     `                ##########          
37 //        ##########,                    ###########          
38 //         ###########;                ############
39 //         +############             .############`
40 //          ###########+           ,#############;
41 //          `###########     ;++#################
42 //           :##########,    ###################
43 //            '###########.'###################
44 //             +##############################
45 //              '############################`
46 //               .##########################
47 //                 #######################:
48 //                   ###################+
49 //                     +##############:
50 //                        :#######+`
51 //
52 //
53 //
54 // Play0x.com (The ONLY gaming platform for all ERC20 Tokens)
55 // -------------------------------------------------------------------------------------------------------
56 // * Multiple types of game platforms
57 // * Build your own game zone - Not only playing games, but also allowing other players to join your game.
58 // * Support all ERC20 tokens.
59 //
60 //
61 //
62 // 0xC Token (Contract address : 0x60d8234a662651e586173c17eb45ca9833a7aa6c)
63 // -------------------------------------------------------------------------------------------------------
64 // * 0xC Token is an ERC20 Token specifically for digital entertainment.
65 // * No ICO and private sales,fair access.
66 // * There will be hundreds of games using 0xC as a game token.
67 // * Token holders can permanently get ETH's profit sharing.
68 //
69 
70 /**
71 * @title SafeMath
72 * @dev Math operations with safety checks that throw on error
73 */
74 library SafeMath {
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a * b;
77         assert(a == 0 || c / a == b);
78         return c;
79     }
80 
81     function div(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a / b;
83         return c;
84     }
85 
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         assert(b <= a);
88         return a - b;
89     }
90 
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         assert(c >= a);
94         return c;
95     }
96 }
97 
98 /**
99 * @title ERC20 interface
100 * @dev see https://github.com/ethereum/EIPs/issues/20
101 */
102 contract ERC20 {
103     function allowance(address owner, address spender) public view returns (uint256);
104     function balanceOf(address who) public view returns  (uint256);
105     function transferFrom(address from, address to, uint256 value) public returns (bool);
106     function transfer(address to, uint256 value) public returns (bool);
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 }
109 
110 /**
111 * @title Ownable
112 * @dev The Ownable contract has an owner address, and provides basic authorization control 
113 * functions, this simplifies the implementation of "user permissions". 
114 */ 
115 contract Ownable {
116     address public owner;
117 
118 /** 
119 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
120 * account.
121 */
122     constructor() public {
123         owner = msg.sender;
124     }
125 
126     /**
127     * @dev Throws if called by any account other than the owner.
128     */
129     modifier onlyOwner() {
130         require(msg.sender == owner, "only for owner");
131         _;
132     }
133 
134     /**
135     * @dev Allows the current owner to transfer control of the contract to a newOwner.
136     * @param newOwner The address to transfer ownership to.
137     */
138     function transferOwnership(address newOwner) public onlyOwner {
139         if (newOwner != address(0)) {
140             owner = newOwner;
141         }
142     }
143 }
144 
145 //Main contract
146 contract RewardSharing is Ownable{
147     using SafeMath for uint256;
148     bool public IsWithdrawActive = true;
149 
150     //for Shareholder banlance record
151     mapping(address => uint256) EtherBook;
152     mapping(address=> mapping(address => uint256)) TokenBook;
153     address[] supportToken;
154 
155     event withdrawLog(address userAddress, uint256 etherAmount, uint256 tokenAmount);
156 
157     function() public payable{}
158     
159     //Get counts of supported Token
160     function GetTokenLen() public view returns(uint256)
161     {
162         return supportToken.length;
163     }
164     
165     //Get supportToken by index
166     function GetSupportToken(uint index) public view returns(address)
167     {
168         return supportToken[index];
169     }
170 
171     //Add Ether for accounts
172     function ProfitDividend (address[] addressArray, uint256[] profitArray) public onlyOwner
173     {
174         for( uint256 i = 0; i < addressArray.length;i++)
175         {
176             EtherBook[addressArray[i]] = EtherBook[addressArray[i]].add(profitArray[i]);
177         }
178     }
179     
180     // Adjust Ether balance of accounts in the vault
181     function AdjustEtherBook(address[] addressArray, uint256[] profitArray) public onlyOwner
182     {
183         for( uint256 i = 0; i < addressArray.length;i++)
184         {
185             EtherBook[addressArray[i]] = profitArray[i];
186         }
187     }
188     
189     //Add token for accounts
190     function ProfitTokenDividend (address ERC20Address, address[] addressArray, uint256[] profitArray) public onlyOwner
191     {
192         if(TokenBook[ERC20Address][0x0]== 0)
193         {
194             supportToken.push(ERC20Address);
195             TokenBook[ERC20Address][0x0] = 1;
196         }
197         
198         for( uint256 i = 0; i < addressArray.length;i++)
199         {
200             TokenBook[ERC20Address][addressArray[i]] = TokenBook[ERC20Address][addressArray[i]].add(profitArray[i]);
201         }
202     }
203     
204     // Adjust token balance of accounts in the vault
205     function AdjustTokenBook(address ERC20Address,address[] addressArray, uint256[] profitArray) public onlyOwner
206     {
207         if(TokenBook[ERC20Address][0x0]== 0)
208         {
209             supportToken.push(ERC20Address);
210             TokenBook[ERC20Address][0x0] = 1;
211         }
212         
213         for( uint256 i = 0; i < addressArray.length;i++)
214         {
215             TokenBook[ERC20Address][addressArray[i]] = profitArray[i];
216         }
217     }
218     
219     //check ether balance in the vault
220     function CheckBalance(address theAddress) public view returns(uint256 EtherProfit)
221     {
222         return (EtherBook[theAddress]);
223     }
224     
225     //Check token balance in the vault
226     function CheckTokenBalance(address ERC20Address, address theAddress) public view returns(uint256 TokenProfit)
227     {
228         return TokenBook[ERC20Address][theAddress];
229     }
230     
231     //User withdraw ERC20 Token
232     function withdrawToken(address ERC20Address) public
233     {
234         uint tokenAmount = TokenBook[ERC20Address][msg.sender];
235         TokenBook[ERC20Address][msg.sender]= 0;
236     
237         ERC20(ERC20Address).transfer(msg.sender, tokenAmount);
238     }
239     
240     //User Withdraw Ether
241     function withdrawEther() public
242     {
243         uint etherAmount = EtherBook[msg.sender];
244         EtherBook[msg.sender] = 0;
245         msg.sender.transfer(etherAmount);
246     }
247     
248     //Set withdraw status.
249     function UpdateActive(bool _IsWithdrawActive) public onlyOwner
250     {
251         IsWithdrawActive = _IsWithdrawActive;
252     }
253 }