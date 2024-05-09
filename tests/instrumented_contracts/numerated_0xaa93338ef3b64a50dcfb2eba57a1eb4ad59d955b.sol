1 pragma solidity ^0.4.6;
2 
3 //  Do not use this contract unless you have been advised to do so
4 //  Unauthorized claims prohibited
5 //
6 //  For instructions on how to use this contract please see refer to the documentation you have received along with your individual claim code
7 // 
8 //  Note: Claim pool amount will be loaded when 75% of claim codes have been registered
9 //
10 contract PPBC_Ether_Claim {
11      
12      address ppbc;
13      
14      mapping (bytes32 => uint256) valid_voucher_code; // stores claimable amount
15      mapping (bytes32 => bool) redeemed;  // claimcode --> true/false
16      mapping (bytes32 => address) who_claimed; //  claimcode --> who_requested
17      mapping (uint256 => bytes32) claimers; // index number --> claimcode  for iteration, to pay out
18      uint256 public num_claimed;            // how many ppl have claimed already
19      uint256 public total_claim_codes;
20      bool public deposits_refunded;
21 
22      // build contract
23      function PPBC_Ether_Claim(){
24         ppbc = msg.sender;
25         deposits_refunded = false;
26         num_claimed = 0;
27         valid_voucher_code[0x99fc71fa477d1d3e6b6c3ed2631188e045b7f575eac394e50d0d9f182d3b0145] = 110.12 ether; total_claim_codes++;
28         valid_voucher_code[0x8b4f72e27b2a84a30fe20b0ee5647e3ca5156e1cb0d980c35c657aa859b03183] = 53.2535 ether; total_claim_codes++;
29         valid_voucher_code[0xe7ac3e31f32c5e232eb08a8f978c7e4c4845c44eb9fa36e89b91fc15eedf8ffb] = 151 ether; total_claim_codes++;
30         valid_voucher_code[0xc18494ff224d767c15c62993a1c28e5a1dc17d7c41abab515d4fcce2bd6f629d] = 63.22342 ether; total_claim_codes++;
31         valid_voucher_code[0x5cdb60c9e999a510d191cf427c9995d6ad3120a6b44afcb922149d275afc8ec4] = 101 ether; total_claim_codes++;
32         valid_voucher_code[0x5fb7aed108f910cc73b3e10ceb8c73f90f8d6eff61cda5f43d47f7bec9070af4] = 16.3 ether; total_claim_codes++;
33         valid_voucher_code[0x571a888f66f4d74442733441d62a92284f1c11de57198decf9d4c244fb558f29] = 424 ether; total_claim_codes++;
34         valid_voucher_code[0x7123fa994a2990c5231d35cb11901167704ab19617fcbc04b93c45cf88b30e94] = 36.6 ether; total_claim_codes++;
35         valid_voucher_code[0xdac0e1457b4cf3e53e9952b1f8f3a68a0f288a7e6192314d5b19579a5266cce0] = 419.1 ether; total_claim_codes++;
36         valid_voucher_code[0xf836a280ec6c519f6e95baec2caee1ba4e4d1347f81d4758421272b81c4a36cb] = 86.44 ether; total_claim_codes++;
37         valid_voucher_code[0x5470e8b8b149aca84ee799f6fd1a6bf885267a1f7c88c372560b28180e2cf056] = 92 ether; total_claim_codes++;
38         valid_voucher_code[0x7f52b6f587c87240d471d6fcda1bb3c10c004771c1572443134fd6756c001c9a] = 124.2 ether; total_claim_codes++;
39         valid_voucher_code[0x5d435968b687edc305c3adc29523aba1128bd9acd2c40ae2c9835f2e268522e1] = 95.102 ether; total_claim_codes++;
40      }
41 
42      // function to register claim
43      //
44      function register_claim(string password) payable {
45           // claim deposit 50 ether (returned with claim, used to prevent "brute force" password cracking attempts) 
46           if (msg.value != 50 ether || valid_voucher_code[sha3(password)] == 0) return; // if user does not provide the right password, the deposit is being kept.
47           
48           // dont claim twice either, and check if deposits have already been refunded -- > throw
49           if (redeemed[sha3(password)] || deposits_refunded ) throw; 
50           
51           // if we get here the user has provided a valid claim code, and paid deposit
52           num_claimed++;
53           redeemed[sha3(password)] = true;
54           who_claimed[sha3(password)] = msg.sender;
55           valid_voucher_code[sha3(password)] += 50 ether;  // add the deposit paid to the claim
56           claimers[num_claimed] = sha3(password);    
57      }
58      
59      // Refund Step 1: this function will return the deposits paid first
60      //                (this step is separate to avoid issues in case the claim refund amounts haven't been loaded yet,
61      //                 so at least the deposits won't get stuck)
62      function refund_deposits(string password){ //anyone with a code can call this
63             if (deposits_refunded) throw; // already refunded
64             if (valid_voucher_code[sha3(password)] == 0) throw; 
65             
66             // wait till everyone has claimed or claim period ended, and refund-pool has been loaded
67             if (num_claimed >= total_claim_codes || block.number >= 2850000 ){  // ~ 21/12/2017
68                 // first refund the deposits
69                 for (uint256 index = 1; index <= num_claimed; index++){
70                     bytes32 claimcode = claimers[index];
71                     address receiver = who_claimed[claimcode];
72                     if (!receiver.send(50 ether)) throw; // refund deposit, or throw in case of any error
73                     valid_voucher_code[claimcode] -= 50 ether;  // deduct the deposit paid from the claim
74                 }
75                 deposits_refunded = true; // can only use this function once
76             }
77             else throw;
78             //
79      }
80      
81      // Refund Step 2: this function will refund actual claim amount. But wait for our notification
82      //             before calling this function (you can check the contract balance after deposit return)
83      function refund_claims(string password){ //anyone with a code can call this
84             if (!deposits_refunded) throw; // first step 1 (refund_deposits) has to be called
85             if (valid_voucher_code[sha3(password)] == 0) throw; 
86             
87             for (uint256 index = 1; index <= num_claimed; index++){
88                 bytes32 claimcode = claimers[index];
89                 address receiver = who_claimed[claimcode];
90                 uint256 refund_amount = valid_voucher_code[claimcode];
91                 
92                 // only refund claims if there is enough left in the claim bucket
93                 
94                 if (this.balance >= refund_amount){
95                     if (!receiver.send(refund_amount)) throw; // refund deposit, or throw in case of any error
96                     valid_voucher_code[claimcode] = 0;  // deduct the deposit paid from the claim
97                 }
98                 
99             }
100      }
101 
102 
103      // others
104      
105      function end_redeem_period(){ 
106             if (block.number >= 2900000 || num_claimed == 0) //suicide ~29/12/2016
107                selfdestruct(ppbc);
108      }
109     
110      function check_redeemed(string password) returns (bool){
111          if (valid_voucher_code[sha3(password)] == 0) 
112               return true; //invalid code or already fully redeemed --> just return redeemed=true
113          return redeemed[sha3(password)];
114      }
115     
116      function () payable {} // fill claim pool
117 }