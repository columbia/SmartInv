1 pragma solidity ^0.4.5;
2 
3 contract Better_Bank_With_Interest {
4     //
5     ////////////////////////////////////////////////////////////////
6     //
7     //  A term deposit bank that pays interest on withdrawal  
8     //
9     //  v0.02 beta, use AT OWN RISK - I am not refunding any lost ether!
10     //  And check the code before depositing anything.
11     //
12     //  How to use: 1) transfer min. 250 ether using the deposit() function (5 ether deposit fee per deposit)
13     //                 note: minimum ether amount and deposit fee can change, so check public variables
14     //                   - minimum_deposit_amount
15     //                   - deposit_fee
16     //                 before depositing!
17     //
18     //              2) withdraw after 5 days, receive up to 10% interest (1 additional ether for every 10 ether withdrawal)
19     //                 note: to get most of the interest paid out, withdraw in lots of 10 ether...
20     //
21     ///////////////////////////////////////////////////////////////////
22     //
23     //  Now you may ask - where do the extra ether come from? :)
24     //  The answer is simple: From people who dont follow the instructions properly! 
25     //                        And there are usually plenty of those...
26     //
27     //  Common pitfalls:
28     //   e.g. - deposit to the fallback function instead of the proper deposit() function
29     //        - withdraw MORE than 10 ether AT A TIME ... (that just means you get less interest paid out)
30     //        -  or you wait too long after your term deposit ended, and other people have drained the interest pool.
31     //
32     //  You can always check the availbale interest amount using get_available_interest_amount () before you withdraw
33     //  And be quick - everyone gets the same 30850 block term deposit time (~5 days) until they can withdraw.
34     //
35     //  Also FYI: The bank cannot remove money from the interest pool until the end of the contract life.
36     //        And make sure you withdraw your balances before the end of the contract life also.
37     //        Check public contract_alive_until_this_block variable to find out when the contract life ends.
38     //           Initial end date is block #3000000 (~Mid Jan 2017), but the bank can extend that life.
39     //           Note: the bank can only EXTEND that end date, not shorten it.
40     //
41     // And here we go - happy reading:
42     //
43     // store of all account balances
44     mapping(address => uint256) balances;
45     mapping(address => uint256) term_deposit_end_block; // store per address the minimum time for the term deposit
46                                                          //
47     address thebank; // the bank
48     
49     uint256 public minimum_deposit_amount; // minimum deposits
50     uint256 public deposit_fee;     // fee for deposits
51     uint256 public contract_alive_until_this_block;
52     
53     uint256 public count_customer_deposits; 
54     
55     function Better_Bank_With_Interest() { // create the contract
56         thebank = msg.sender;  
57         minimum_deposit_amount = 250 ether;
58         deposit_fee = 5 ether;
59         contract_alive_until_this_block = 3000000; // around 2 months from now (mid Jan 2017)
60                                                    // --> can be extended but not brought forward
61         //
62         count_customer_deposits = 0;
63         // bank cannot touch remaining interest balance until the contract has reached end of life.
64         term_deposit_end_block[thebank] = 0;// contract_alive_until_this_block;
65         //
66     }
67     
68    //////////////////////////////////////////////////////////////////////////////////////////
69     // deposit ether into term-deposit account
70     //////////////////////////////////////////////////////////////////////////////////////////
71     function deposit() payable {
72         //
73         if (msg.value < minimum_deposit_amount) throw; // minimum deposit is at least minimum_payment.
74         //
75         // no fee for first payment (if the customers's balance is 0)
76         if (balances[msg.sender] == 0) deposit_fee = 0 ether;  
77         //
78         if ( msg.sender == thebank ){ // thebank is depositing into bank/interest account, without fee
79             balances[thebank] += msg.value;
80         }
81         else { // customer deposit
82             count_customer_deposits += 1; // count deposits, cannot remove contract any more until end of life
83             balances[msg.sender] += msg.value - deposit_fee;  // credit the sender's account
84             balances[thebank] += deposit_fee; // difference (fee) to be credited to thebank
85             term_deposit_end_block[msg.sender] = block.number + 30850; //  approx 5 days ( 5 * 86400/14 ); 
86         }
87         //
88     }
89     
90     //////////////////////////////////////////////////////////////////////////////////////////
91     // withdraw from account, with 10 ether interest  (after term deposit end)
92     //////////////////////////////////////////////////////////////////////////////////////////
93     //
94     function withdraw(uint256 withdraw_amount) {
95         //
96         if (withdraw_amount < 10 ether) throw; // minimum withdraw amount is 10 ether
97         if ( withdraw_amount > balances[msg.sender]  ) throw; // cannot withdraw more than in customer balance
98         if (block.number < term_deposit_end_block[msg.sender] ) throw; // cannot withdraw until the term deposit has ended
99         // Note: thebank/interest account cannot be withdrawed from until contract end-of life.
100         //       thebank's term-deposit end block is the same as contract_alive_until_this_block
101         //
102         uint256 interest = 1 ether;  // 1 ether interest paid at time of withdrawal
103         //
104         if (msg.sender == thebank){ // but no interest for thebank (who can't withdraw until block contract_alive_until_this_block anyways)
105             interest = 0 ether;
106         }
107         //                          
108         if (interest > balances[thebank])   // cant pay more interest than available in the thebank/bank
109             interest = balances[thebank];  // so send whatever is left anyways
110         //
111         //
112         balances[thebank] -= interest;  // reduce thebank balance, and send bonus to customer
113         balances[msg.sender] -= withdraw_amount;
114         //
115         if (!msg.sender.send(withdraw_amount)) throw;  // send withdraw amount, but check for error to roll back if needed
116         if (!msg.sender.send(interest)) throw;         // send interest amount, but check for error to roll back if needed
117         //
118     }
119     
120     ////////////////////////////////////////////////////////////////////////////
121     // HELPER FUNCTIONS
122     ////////////////////////////////////////////////////////////////////////////
123     
124     // set minimum deposit limits
125     function set_minimum_payment(uint256 new_limit) {
126         if ( msg.sender == thebank ){
127             minimum_deposit_amount = new_limit;
128         }
129     }
130     //
131     // change deposit fee
132     function set_deposit_fee (uint256 new_fee) {
133         if ( msg.sender == thebank ){
134             deposit_fee = new_fee;
135         }
136     }
137     
138     // find out how much money is available for interest payments
139     function get_available_interest_amount () constant  returns (uint256) {
140         return balances[thebank];
141     }
142     // find out what the end date of the customers term deposit is
143     function get_term_deposit_end_date (address query_address) constant  returns (uint256) {
144         return term_deposit_end_block[query_address];
145     }    
146     // find out how much money is available for interest payments
147     function get_balance (address query_address) constant  returns (uint256) {
148         return balances[query_address];
149     }
150     //
151     ////////////////////////////////////////////////////////////////
152     // this bank won't live forever, so this will handle the exit (or extend its life)
153     ////////////////////////////////////////////////////////////
154 	//
155     function extend_life_of_contract (uint256 newblock){
156         if ( msg.sender != thebank || newblock < contract_alive_until_this_block ) throw;
157         // can only extend
158         contract_alive_until_this_block = newblock; 
159         // lock thebank/interest account until new end date
160         term_deposit_end_block[thebank] = contract_alive_until_this_block;
161     }
162     //
163     // the self destruct after the final block number has been reached (or immediately if there havent been any customer payments yet)
164     function close_bank(){
165         if (contract_alive_until_this_block < block.number || count_customer_deposits == 0)
166             selfdestruct(thebank); 
167             // any funds still remaining within the bank will be sent to the creator
168             // --> bank customers have to make sure they withdraw their $$$ before the final block.
169     }
170     ////////////////////////////////////////////////////////////////
171     // fallback function
172     ////////////////////////////////////////////////////////////
173     function () payable { // any unidentified payments (that didnt call the deposit function) 
174                           // go into the standard interest account of the bank
175                           // and become available for interest withdrawal by bank users
176         balances[thebank] += msg.value;
177     }
178 }