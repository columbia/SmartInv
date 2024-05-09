1 pragma solidity ^0.4.5;
2 
3 contract Bank_With_Interest {
4     //
5     ////////////////////////////////////////////////////////////////
6     //
7     //  A term deposit bank that pays interest on withdrawal  
8     //
9     //  v0.01 beta, use AT OWN RISK - I am not refunding any lost ether!
10     //  And check the code before depositing anything.
11     //
12     //  How to use: 1) transfer min. 250 ether using the deposit() function (5 ether deposit fee per deposit)
13     //                 note: minimum ether amount and deposit fee can change, so check public variables
14     //                   - minimum_payment
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
47     address public thebank; // the bank
48     
49     uint256 public minimum_payment; // minimum deposits
50     uint256 public deposit_fee;     // fee for deposits
51     
52     uint256 public contract_alive_until_this_block;
53     
54     bool public any_customer_payments_yet = false; // the first cutomer payment will make this true and 
55                                         // the contract cannot be deleted any more before end of life
56     
57     function Bank_With_Interest() { // create the contract
58         thebank = msg.sender;  
59         minimum_payment = 250 ether;
60         deposit_fee = 5 ether;
61         contract_alive_until_this_block = 3000000; // around 2 months from now (mid Jan 2017)
62                                                    // --> can be extended but not brought forward
63         //
64         // bank cannot touch remaining interest balance until the contract has reached end of life.
65         term_deposit_end_block[thebank] = 0;// contract_alive_until_this_block;
66         //
67     }
68     
69    //////////////////////////////////////////////////////////////////////////////////////////
70     // deposit ether into term-deposit account
71     //////////////////////////////////////////////////////////////////////////////////////////
72     function deposit() payable {
73         //
74         if (msg.value < minimum_payment) throw; // minimum deposit is at least minimum_payment.
75         //
76         // no fee for first payment (if the customers's balance is 0)
77         if (balances[msg.sender] == 0) deposit_fee = 0 ether;  
78         //
79         if ( msg.sender == thebank ){ // thebank is depositing into bank/interest account, without fee
80             balances[thebank] += msg.value;
81         }
82         else { // customer deposit
83             any_customer_payments_yet = true; // cannot remove contract any more until end of life
84             balances[msg.sender] += msg.value - deposit_fee;  // credit the sender's account
85             balances[thebank] += deposit_fee; // difference (fee) to be credited to thebank
86             term_deposit_end_block[msg.sender] = block.number + 30850; //  approx 5 days ( 5 * 86400/14 ); 
87         }
88         //
89     }
90     
91     //////////////////////////////////////////////////////////////////////////////////////////
92     // withdraw from account, with 10 ether interest  (after term deposit end)
93     //////////////////////////////////////////////////////////////////////////////////////////
94     //
95     function withdraw(uint256 withdraw_amount) {
96         //
97         if (withdraw_amount < 10 ether) throw; // minimum withdraw amount is 10 ether
98         if ( withdraw_amount > balances[msg.sender]  ) throw; // cannot withdraw more than in customer balance
99         if (block.number < term_deposit_end_block[msg.sender] ) throw; // cannot withdraw until the term deposit has ended
100         // Note: thebank/interest account cannot be withdrawed from until contract end-of life.
101         //       thebank's term-deposit end block is the same as contract_alive_until_this_block
102         //
103         uint256 interest = 1 ether;  // 1 ether interest paid at time of withdrawal
104         //
105         if (msg.sender == thebank){ // but no interest for thebank (who can't withdraw until block contract_alive_until_this_block anyways)
106             interest = 0 ether;
107         }
108         //                          
109         if (interest > balances[thebank])   // cant pay more interest than available in the thebank/bank
110             interest = balances[thebank];  // so send whatever is left anyways
111         //
112         //
113         balances[thebank] -= interest;  // reduce thebank balance, and send bonus to customer
114         balances[msg.sender] -= withdraw_amount;
115         //
116         if (!msg.sender.send(withdraw_amount)) throw;  // send withdraw amount, but check for error to roll back if needed
117         if (!msg.sender.send(interest)) throw;         // send interest amount, but check for error to roll back if needed
118         //
119     }
120     
121     ////////////////////////////////////////////////////////////////////////////
122     // HELPER FUNCTIONS
123     ////////////////////////////////////////////////////////////////////////////
124     
125     // set minimum deposit limits
126     function set_minimum_payment(uint256 new_limit) {
127         if ( msg.sender == thebank ){
128             minimum_payment = new_limit;
129         }
130     }
131     //
132     // change deposit fee
133     function set_deposit_fee (uint256 new_fee) {
134         if ( msg.sender == thebank ){
135             deposit_fee = new_fee;
136         }
137     }
138     
139     // find out how much money is available for interest payments
140     function get_available_interest_amount () returns (uint256) {
141         return balances[thebank];
142     }
143     // find out what the end date of the customers term deposit is
144     function get_term_deposit_end_date () returns (uint256) {
145         return term_deposit_end_block[msg.sender];
146     }    
147     // find out how much money is available for interest payments
148     function get_balance () returns (uint256) {
149         return balances[msg.sender];
150     }
151     //
152     ////////////////////////////////////////////////////////////////
153     // this bank won't live forever, so this will handle the exit (or extend its life)
154     ////////////////////////////////////////////////////////////
155 	//
156     function extend_life_of_contract (uint256 newblock){
157         if ( msg.sender != thebank || newblock < contract_alive_until_this_block ) throw;
158         // can only extend
159         contract_alive_until_this_block = newblock; 
160         // lock thebank/interest account until new end date
161         term_deposit_end_block[thebank] = contract_alive_until_this_block;
162     }
163     //
164     // the self destruct after the final block number has been reached (or immediately if there havent been any customer payments yet)
165     function close_bank(){
166         if (contract_alive_until_this_block < block.number || !any_customer_payments_yet)
167             selfdestruct(thebank); 
168             // any funds still remaining within the bank will be sent to the creator
169             // --> bank customers have to make sure they withdraw their $$$ before the final block.
170     }
171     ////////////////////////////////////////////////////////////////
172     // fallback function
173     ////////////////////////////////////////////////////////////
174     function () payable { // any unidentified payments (that didnt call the deposit function) 
175                           // go into the standard interest account of the bank
176                           // and become available for interest withdrawal by bank users
177         balances[thebank] += msg.value;
178     }
179 }