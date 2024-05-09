1 pragma solidity ^0.4.8;
2 contract token { function transfer(address receiver, uint amount) returns (bool) {  } }
3 
4 contract LuxPresale {
5     address public beneficiary;
6     uint public totalLux; uint public amountRaised; uint public deadline; uint public price; uint public presaleStartDate;
7     token public tokenReward;
8     mapping(address => uint) public balanceOf;
9     bool fundingGoalReached = false; //закрыт ли сбор денег
10     event GoalReached(address beneficiary, uint amountRaised);
11     event FundTransfer(address backer, uint amount, bool isContribution);
12     bool crowdsaleClosed = false;
13 
14     /* data structure to hold information about campaign contributors */
15 
16     /*  at initialization, setup the owner */
17     function LuxPresale(
18         address ifSuccessfulSendTo,
19         uint fundingGoalInLux,
20         uint startDate,
21         uint durationInMinutes,
22         token addressOfTokenUsedAsReward
23     ) {
24         beneficiary = ifSuccessfulSendTo;
25         totalLux = fundingGoalInLux * 100; // сколько люксов раздадим
26         presaleStartDate = startDate; // дата начала пресейла
27         deadline = startDate + durationInMinutes * 1 minutes;
28         tokenReward = token(addressOfTokenUsedAsReward);
29     }
30     
31     /* The function without name is the default function that is called whenever anyone sends funds to a contract */
32     
33     function () payable {
34         if (now < presaleStartDate) throw; // A participant cannot send funds before the presale start date
35 
36         if (crowdsaleClosed) { // выплачиваем токины 
37 			if (msg.value > 0) throw; // если после закрытия перечисляем эфиры
38             uint reward = balanceOf[msg.sender];
39             balanceOf[msg.sender] = 0;
40             if (reward > 0) {
41                 if (!tokenReward.transfer(msg.sender, reward/price)) {
42                     balanceOf[msg.sender] = reward;
43                 }
44             }        
45         } else { // Сохраняем данные о том кто сколько заплатил
46             uint amount = msg.value; // сколько переведено средств
47             balanceOf[msg.sender] += amount; // обновляем баланс
48             amountRaised += amount; // увеличиваем сумму собранных денег
49         }
50     }
51     
52     modifier afterDeadline() { if (now >= deadline) _; }
53     
54     modifier onlyOwner() {
55         if (msg.sender != beneficiary) {
56             throw;
57         }
58         _;
59     }
60 
61     /* checks if the goal or time limit has been reached and ends the campaign */
62     /* закрываем сбор денег */
63     function setGoalReached() afterDeadline {
64         if (amountRaised == 0) throw; // если не собрали денег
65         if (crowdsaleClosed) throw; // попытка второй раз закрыть
66         crowdsaleClosed = true;
67         price = amountRaised/totalLux; // цена 1 люкса
68     }
69 
70     /*  */
71     function safeWithdrawal() afterDeadline onlyOwner {
72         if (!crowdsaleClosed) throw;
73         if (beneficiary.send(amountRaised)) {
74             FundTransfer(beneficiary, amountRaised, false);
75         }
76     }
77 }