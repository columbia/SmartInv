1 pragma solidity ^0.4.25;
2 
3 /**
4   CRYPTOMAN
5   
6   EN:
7   1. Fixed deposit - 0.05 Ether.
8      The number of deposits from one address is not limited.
9   2. The round consists of 10 deposits. At the end of the round, each participant
10      gets either 150% of the deposit, or insurance compensation 30% of the
11      deposit.
12   3. Payments are made gradually - with each new deposit several payments are sent
13      to the participants of the previous round. If the participant does
14      not want to wait for a payout, he can send 0 Ether and get all his winnings.
15   4. The prize fund is calculated as 7% of all deposits. To get the whole
16      prize fund, it is necessary that after the participant no one invested during
17      42 blocks (~ 10 minutes) and after that the participant needs to send
18      0 Ether in 10 minutes.
19   5. A participant may at any time withdraw their deposits made in the current round.
20      Fees will not be refunded. To do this, the participant should to send
21      0.0112 ETH to the contract address.
22 
23   GAS LIMIT 300000
24   
25   RU:
26   1. Сумма депозита фиксированная - 0.05 Ether.
27      Количество депозитов с одного адреса не ограничено.
28   2. Раунд состоит из 10 депозитов. По окончании раунда каждому участнику
29      производится начисление - либо 150% от депозита, либо страховое возмещение
30      30% от депозита.
31   3. Выплаты производятся постепенно - с каждым новым депозитом отправляется
32      несколько выплат участникам предыдущего раунда. Если участник не
33      хочет ждать выплату, он может отправить 0 Ether и получить все свои выигрыши.
34   4. Призовой фонд рассчитывается как 7% от депозитов. Чтобы получить весь
35      призовой фонд, нужно, чтобы после участника никто не вкладывался в течение
36      42 блоков (~10 минут) и чтобы он отправил 0 Ether через 10 минут.
37   5. Участник может в любое время вернуть свои депозиты, сделанные в текущем раунде.
38      Комиссии возвращены не будут. Для этого участник должен отправить 0.0112
39      ETH на адрес контракта.
40 
41   ЛИМИТ ГАЗА 300000
42 */
43 
44 contract Cryptoman {
45     uint public depositValue = 0.05 ether;
46     uint public returnDepositValue = 0.0112 ether;
47     uint public places = 10;
48     uint public winPlaces = 5;
49     uint public winPercent = 150;
50     uint public supportFee = 3;
51     uint public prizeFee = 7;
52     uint public winAmount = depositValue * winPercent / 100;
53     uint public insuranceAmount = (depositValue * places * (100 - supportFee - prizeFee) / 100 - winAmount * winPlaces) / (places - winPlaces);
54     uint public blocksBeforePrize = 42;
55     uint public prize;
56     address public lastInvestor;
57     uint public lastInvestedAt;
58     uint public currentRound;
59     mapping (uint => address[]) public placesMap;
60     mapping (uint => uint) public winners;
61     uint public currentPayRound;
62     uint public currentPayIndex;
63     address public support1 = 0xD71C0B80E2fDF33dB73073b00A92980A7fa5b04B;
64     address public support2 = 0x7a855307c008CA938B104bBEE7ffc94D3a041E53;
65     
66     uint private seed;
67     
68     // uint256 to bytes32
69     function toBytes(uint256 x) internal pure returns (bytes b) {
70         b = new bytes(32);
71         assembly {
72             mstore(add(b, 32), x)
73         }
74     }
75     
76     // returns a pseudo-random number
77     function random(uint lessThan) internal returns (uint) {
78         seed += block.timestamp + uint(msg.sender);
79         return uint(sha256(toBytes(uint(blockhash(block.number - 1)) + seed))) % lessThan;
80     }
81     
82     // removes item and shifts other items
83     function removePlace(uint index) internal {
84         if (index >= placesMap[currentRound].length) return;
85 
86         for (uint i = index; i < placesMap[currentRound].length - 1; i++) {
87             placesMap[currentRound][i] = placesMap[currentRound][i + 1];
88         }
89         placesMap[currentRound].length--;
90     }
91     
92     function placesLeft() external view returns (uint) {
93         return places - placesMap[currentRound].length;
94     }
95     
96     function processQueue() internal {
97         while (gasleft() >= 50000 && currentPayRound < currentRound) {
98             uint winner = winners[currentPayRound];
99             uint index = (winner + currentPayIndex) % places;
100             address investor = placesMap[currentPayRound][index];
101             investor.transfer(currentPayIndex < winPlaces ? winAmount : insuranceAmount);
102             delete placesMap[currentPayRound][index];
103             
104             if (currentPayIndex == places - 1) {
105                 currentPayIndex = 0;
106                 currentPayRound++;
107             } else {
108                 currentPayIndex++;
109             }
110         }
111     }
112     
113     function () public payable {
114         require(gasleft() >= 250000);
115         
116         if (msg.value == depositValue) {
117             placesMap[currentRound].push(msg.sender);
118             if (placesMap[currentRound].length == places) {
119                 winners[currentRound] = random(places);
120                 currentRound++;
121             }
122             
123             lastInvestor = msg.sender;
124             lastInvestedAt = block.number;
125             uint fee = msg.value * supportFee / 200;
126             support1.transfer(fee);
127             support2.transfer(fee);
128             prize += msg.value * prizeFee / 100;
129             
130             processQueue();
131         } else if (msg.value == returnDepositValue) {
132             uint depositCount;
133             
134             uint i = 0;
135             while (i < placesMap[currentRound].length) {
136                 if (placesMap[currentRound][i] == msg.sender) {
137                     depositCount++;
138                     removePlace(i);
139                 } else {
140                     i++;
141                 }
142             }
143             
144             require(depositCount > 0);
145             
146             if (msg.sender == lastInvestor) {
147                 delete lastInvestor;
148             }
149             
150             prize += msg.value;
151             msg.sender.transfer(depositValue * (100 - supportFee - prizeFee) / 100 * depositCount);
152         } else if (msg.value == 0) {
153             if (lastInvestor == msg.sender && block.number >= lastInvestedAt + blocksBeforePrize) {
154                 lastInvestor.transfer(prize);
155                 delete prize;
156                 delete lastInvestor;
157             }
158             
159             processQueue();
160         } else {
161             revert();
162         }
163     }
164 }