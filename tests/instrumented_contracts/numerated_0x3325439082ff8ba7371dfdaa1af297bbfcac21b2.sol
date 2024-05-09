1 //[ETH] Wealth Redistribution Contract
2 //
3 //Please keep in mind this contract is for educational and entertainment purposes only and was created to understand the limitations of Ethereum contracts.
4 //
5 
6 contract WealthRedistributionProject {
7 
8   struct BenefactorArray {
9       address etherAddress;
10       uint amount;
11   }
12 
13   BenefactorArray[] public benefactor;
14 
15   uint public balance = 0;
16   uint public totalBalance = 0;
17 
18   function() {
19     enter();
20   }
21   
22   function enter() {
23     if (msg.value != 1 ether) { //return payment if it's not 1 ETH
24         msg.sender.send(msg.value);
25         return;
26     }
27    
28     uint transactionAmount;
29     uint k = 0;
30 
31     // add a new participant to array
32     uint total_inv = benefactor.length;
33     benefactor.length += 1;
34     benefactor[total_inv].etherAddress = msg.sender;
35     benefactor[total_inv].amount = msg.value;
36 
37 	balance += msg.value;  //keep track of amount available
38 
39    // payment gets distributed to all benefactors based on what % of the total was contributed by them    
40     while (k<total_inv) 
41     { 
42     	transactionAmount = msg.value * benefactor[k].amount / totalBalance;       //Calculate amount to send
43 		benefactor[k].etherAddress.send(transactionAmount);    					//Wealth redistribution
44 		balance -= transactionAmount;                        					//Keep track of available balance
45         k += 1; //LOOP next benefactor
46     }
47     
48 	totalBalance += msg.value;  //keep track of total amount contributed
49     
50     
51   }
52 
53 }