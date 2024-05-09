1 pragma solidity >=0.4.22 <0.6.0;
2 contract FiveForty {
3     
4 // "FiveForty" investment contract
5 // 5% daily up to 200% of invest
6 // 10% marketing fee
7 // 5% reward to referrer and refferal (need to have invest)
8 //
9 // Send ETH to make an invest
10 // Send 0 ETH to payout
11 // Recomended GAS LIMIT - 150 000
12 //
13 // ***WARNING*** 
14 // It's a "Ponzi scheme", you can lose your etherium
15 // You need to send payout request EVERY 24 HOURS
16 // Contract supports >0 transactions to payout, you can send up to 999 WEI to send payout request
17 
18 using ToAddress for *;
19 mapping (address => uint256) invested; // records amounts invested
20 mapping (address => uint256) lastPaymentBlock; // records blocks at which last payment were made
21 mapping (address => uint256) dailyPayment; // records estimated daily payment
22 mapping (address => uint256) totalPaid; // records total paid
23 address payable constant fundAddress = 0x27FE767C1da8a69731c64F15d6Ee98eE8af62E72; // marketing fund address
24 
25 function () external payable {
26     if (msg.value >= 1000) { // receiving function
27         
28         fundAddress.transfer(msg.value / 10); // sending marketing fee
29         if (invested[msg.sender] == 0) {lastPaymentBlock[msg.sender] = block.number;} // starting timer of payments (once for address)
30         invested[msg.sender] += msg.value; // calculating all invests from address
31         
32         address refAddress = msg.data.toAddr();
33         if (invested[refAddress] != 0 && refAddress != msg.sender) { invested[refAddress] += msg.value/20; } // Referral bonus adds only to investors
34         invested[msg.sender] += msg.value/20; // Referral reward
35         
36         dailyPayment[msg.sender] = (invested[msg.sender] * 2 - totalPaid[msg.sender]) / 40; // calculating amount of daily payment (5% of invest)
37         
38     } else { // Payment function
39         
40         if (invested[msg.sender] * 2 > totalPaid[msg.sender] && // max profit = invest*2
41             block.number - lastPaymentBlock[msg.sender] > 5900) { // 24 hours from last payout
42                 totalPaid[msg.sender] += dailyPayment[msg.sender]; // calculating all payouts
43                 address payable sender = msg.sender; sender.transfer(dailyPayment[msg.sender]); // sending daily profit
44             }
45     }
46 }
47 
48 function investorInfo(address addr) public view returns(uint totalInvested, uint pendingProfit,
49 uint dailyProfit, uint minutesBeforeNextPayment, uint totalPayouts) { // helps to track investment
50   totalInvested = invested[addr];
51   pendingProfit = invested[addr] * 2 - totalPaid[addr];
52   dailyProfit = dailyPayment[addr];
53   uint time = 1440 - (block.number - lastPaymentBlock[addr]) / 4;
54   if (time >= 0) { minutesBeforeNextPayment = time; } else { minutesBeforeNextPayment = 0; }
55   totalPayouts = totalPaid[addr];
56 }
57 
58 }
59 
60 library ToAddress {
61   function toAddr(bytes memory source) internal pure returns(address payable addr) {
62     assembly { addr := mload(add(source,0x14)) }
63     return addr;
64   }
65 }