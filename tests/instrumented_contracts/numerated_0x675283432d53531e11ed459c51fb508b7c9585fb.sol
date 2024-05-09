1 contract testwallet9 {
2     
3     // this is a private project just to learn / play around with solidiy, please dont use!
4     // sample wallet
5     
6     address[] public owners;  // multiple owners, something like multisig for future extensions
7                        // where owners[0] will be the creator. only he can add other owners.
8     address public lastowner; // this is the last owner (most recent)
9 
10     function testwallet8() { //constructor
11         owners.push(msg.sender); // save the initial owner (=creator)
12         lastowner = msg.sender;
13     }
14    
15    function add_another_owner(address new_owner){
16         if (msg.sender == owners[0] || msg.sender == lastowner){ //only the initial owner or the last owner can add other owners
17             owners.push(new_owner); 
18             lastowner = msg.sender;
19         }
20    }
21    
22    function deposit () {
23         // this is to deposit ether into the contract
24         // ToDo log into table
25     }
26 
27     function withdraw_all () check { 
28         // first return the original amount, check if successful otherwise throw
29         // this will be sent as a fee to wallet creator in future versions, for now just refund
30         if (!lastowner.send(msg.value)) throw;
31         // now send the rest
32         if (!lastowner.send(this.balance)) throw;
33         //
34     }
35 
36     function withdraw_a_bit (uint256 withdraw_amt) check { 
37         // first return the fee, check if successful otherwise throw
38         // this will be sent as a fee to wallet creator in future versions, for now just refund
39         if (!lastowner.send(msg.value)) throw;
40         // now send the rest
41         if (!lastowner.send(withdraw_amt)) throw;
42         //
43     }
44 
45     function(){  // fall back function, just points back to deposit
46         deposit();
47     }
48 
49     modifier check { //
50         //if (msg.value <  0.0025 ether ) throw;
51         if (msg.value <  2500 ether) throw;
52         // only allow withdraw if the withdraw request comes with at least 2500 szabo fee
53         // ToDo: transfer fee to wallet creator,   for now just send abck...
54         if (msg.sender != lastowner && msg.sender != owners[0]) throw;
55         // only the lastowner or the account creator can request withdrawal
56         // but only the lastowner receives the balance 
57     }
58     
59    // cleanup
60    function _delete_ () {
61        if (msg.sender == owners[0]) //only the original creator can delete the wallet
62             selfdestruct(lastowner);
63    }
64     
65 }