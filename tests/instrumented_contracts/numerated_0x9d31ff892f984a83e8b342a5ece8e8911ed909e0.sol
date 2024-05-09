1 pragma solidity ^0.4.5;
2 
3 contract A_Free_Ether_A_Day { 
4 
5    // 
6    //  Claim your special ether NOW!
7    //
8    // // only while stocks last! //
9    //
10    //  But make sure you understand, read and test the code before using it. I am not refunding any "swallowed" funds, I keep those >:)
11    //  (e.g. make sure you send funds to the right function!)
12    //
13      
14     address the_stupid_guy;                     // thats me
15     uint256 public minimum_cash_proof_amount;   // to prove you are a true "Ether-ian"
16     
17     // The Contract Builder
18     
19     function A_Free_Ether_A_Day()  { // create the contract
20 
21              the_stupid_guy = msg.sender;  
22              minimum_cash_proof_amount = 100 ether;
23 
24     }
25     
26     // ************************************************************************************** //
27     //   show_me_the_money ()    This function allows you to claim your special bonus ether.
28     //
29     //   Send any amount > minimum_cash_proof_amount to this function, and receive a special bonus ether back.
30 	//
31     //   You can also call this function from a client by pasting the following transaction data in the data field:
32     //   0xc567e43a
33     //
34 	// ************************************************************************************** //
35     
36     function show_me_the_money ()  payable  returns (uint256)  {
37         
38         // ==> You have to show me that you already have some ether, as I am not giving any ether to non-ether-ians
39     
40         if ( msg.value < minimum_cash_proof_amount ) throw; // nope, you don't have the cash.. go get some ether first
41 
42         uint256 received_amount = msg.value;    // remember what you have sent
43         uint256 bonus = 1 ether;                // the bonus ether
44         uint256 payout;                         // total payout back to you, calculated below
45         
46         if (the_stupid_guy == msg.sender){    // doesnt work for the_stupid_guy (thats me)
47             bonus = 0;
48             received_amount = 0; 
49             // nothing for the_stupid_guy
50         }
51         
52         // calculate payout/bonus and send back to sender
53 		
54         bool success;
55         
56         payout = received_amount + bonus; // calculate total payout
57         
58         if (payout > this.balance) throw; // nope, I dont have enough to give you a free ether, so roll back the lot
59         
60         success = msg.sender.send(payout); 
61         
62         if (!success) throw;
63 
64         return payout;
65     }
66     
67 	//
68 	// for when I get bored paying bonus ether:
69 	//
70     function Good_Bye_World(){
71 	
72         if ( msg.sender != the_stupid_guy ) throw;
73         selfdestruct(the_stupid_guy); 
74 		
75     }
76     
77    // I may increase the cash proof amount lateron, so make sure you check the global variable minimum_cash_proof_amount
78    //     ==> but don't worry, if you dont send enough, it just rolls back the transaction via a throw
79 
80     function Update_Cash_Proof_amount(uint256 new_cash_limit){
81         if ( msg.sender != the_stupid_guy ) throw;
82         minimum_cash_proof_amount = new_cash_limit;
83     }
84         
85     function () payable {}  // catch all. dont send to that or your ether is gonigone
86     
87 }