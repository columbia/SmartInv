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
99 * @title Ownable
100 * @dev The Ownable contract has an owner address, and provides basic authorization control 
101 * functions, this simplifies the implementation of "user permissions". 
102 */ 
103 contract Ownable {
104     address public owner;
105 
106 /** 
107 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
108 * account.
109 */
110     constructor() public {
111         owner = msg.sender;
112     }
113 
114     /**
115     * @dev Throws if called by any account other than the owner.
116     */
117     modifier onlyOwner() {
118         require(msg.sender == owner, "only for owner");
119         _;
120     }
121 
122     /**
123     * @dev Allows the current owner to transfer control of the contract to a newOwner.
124     * @param newOwner The address to transfer ownership to.
125     */
126     function transferOwnership(address newOwner) public onlyOwner {
127         if (newOwner != address(0)) {
128             owner = newOwner;
129         }
130     }
131 }
132 
133 //Main contract
134 contract ShareholderDividend is Ownable{
135     using SafeMath for uint256;
136     bool public IsWithdrawActive = true;
137     
138     //for Shareholder banlance record
139     mapping(address => uint256) EtherBook;
140 
141     event withdrawLog(address userAddress, uint256 amount);
142 
143     function() public payable{}
144 
145     //Add profits for accounts
146     function ProfitDividend (address[] addressArray, uint256[] profitArray) public onlyOwner
147     {
148         for( uint256 i = 0; i < addressArray.length;i++)
149         {
150             EtherBook[addressArray[i]] = EtherBook[addressArray[i]].add(profitArray[i]);
151         }
152     }
153     
154     // Adjust balance of accounts in the vault
155     function AdjustEtherBook(address[] addressArray, uint256[] profitArray) public onlyOwner
156     {
157         for( uint256 i = 0; i < addressArray.length;i++)
158         {
159             EtherBook[addressArray[i]] = profitArray[i];
160         }
161     }
162     
163     //Check balance in the vault
164     function CheckBalance(address theAddress) public view returns(uint256 profit)
165     {
166         return EtherBook[theAddress];
167     }
168     
169     //User withdraw balance from the vault
170     function withdraw() public payable
171     {
172         //if withdraw actived;
173         require(IsWithdrawActive == true, "Vault is not ready.");
174         require(EtherBook[msg.sender]>0, "Your vault is empty.");
175 
176         uint share = EtherBook[msg.sender];
177         EtherBook[msg.sender] = 0;
178         msg.sender.transfer(share);
179         
180         emit withdrawLog(msg.sender, share);
181     }
182     
183     //Set withdraw status.
184     function UpdateActive(bool _IsWithdrawActive) public onlyOwner
185     {
186         IsWithdrawActive = _IsWithdrawActive;
187     }
188 }