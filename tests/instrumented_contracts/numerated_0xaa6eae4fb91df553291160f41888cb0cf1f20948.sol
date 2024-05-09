1 pragma solidity >=0.4.22 <0.6.0;
2 contract FiveForty {
3     
4 // "FiveForty" investment contract
5 // 5% daily up to 200% of invest
6 // 10% marketing fee
7 // 5% reward to referrer and refferal (payout to investment account)
8 // You need to have investment to receive refferal reward
9 //
10 // Send ETH to make an invest
11 // Send 0 ETH to payout
12 // Recomended GAS LIMIT - 150 000
13 //
14 // ***WARNING*** 
15 // It's a "Ponzi scheme", you can lose your etherium
16 // You need to send payout request EVERY 24 HOURS
17 // Contract supports >0 transactions to payout, you can send up to 999 WEI to send payout request
18 
19 using ToAddress for *;
20 mapping (address => uint256) invested; // records amounts invested
21 mapping (address => uint256) lastPaymentBlock; // records blocks at which last payment were made
22 mapping (address => uint256) dailyPayment; // records estimated daily payment
23 mapping (address => uint256) totalPaid; // records total paid
24 address payable constant fundAddress = 0x27FE767C1da8a69731c64F15d6Ee98eE8af62E72; // marketing fund address
25 
26 function () external payable {
27     if (msg.value >= 1000) { // receiving function
28         
29         fundAddress.transfer(msg.value / 10); // sending marketing fee
30         if (invested[msg.sender] == 0) {lastPaymentBlock[msg.sender] = block.number;} // starting timer of payments (once for address)
31         invested[msg.sender] += msg.value; // calculating all invests from address
32         
33         address refAddress = msg.data.toAddr();
34         if (invested[refAddress] != 0 && refAddress != msg.sender) { // referral bonus adds only to investors
35             invested[refAddress] += msg.value / 20; // referrer reward
36             dailyPayment[refAddress] += msg.value / 400; // calculating ref's daily payment
37             invested[msg.sender] += msg.value / 20; // referral reward
38         }
39         
40         dailyPayment[msg.sender] = (invested[msg.sender] * 2 - totalPaid[msg.sender]) / 40; // calculating amount of daily payment (5% of invest)
41         
42     } else { // payment function
43         
44         if (invested[msg.sender] * 2 > totalPaid[msg.sender] && // max profit = invest*2
45             block.number - lastPaymentBlock[msg.sender] > 5900) { // 24 hours from last payout
46             
47                 uint thisPayment; // calculating current payment
48                 if (invested[msg.sender] * 2 - totalPaid[msg.sender] < dailyPayment[msg.sender]) { // total payout must be 200% of investment
49                     thisPayment = invested[msg.sender] * 2 - totalPaid[msg.sender]; // last payment can be lower 5% of investment
50                 } else { thisPayment = dailyPayment[msg.sender]; } // regular 5% payment
51                 
52                 totalPaid[msg.sender] += thisPayment; // calculating all payouts
53                 lastPaymentBlock[msg.sender] = block.number; // recording time of last payment
54                 address payable sender = msg.sender; sender.transfer(thisPayment); // sending daily profit
55             }
56     }
57 }
58 
59 function investorInfo(address Your_Address) public view returns(string memory Info, uint Total_Invested_PWEI, uint Pending_Profit_PWEI,
60 uint Daily_Profit_PWEI, uint Minutes_Before_Next_Payment, uint Total_Payouts_PWEI) { // helps to track investment
61     Info = "PETA WEI (PWEI) = 1 ETH / 1000";
62     Total_Invested_PWEI = invested[Your_Address] / (10**15);
63     Pending_Profit_PWEI = (invested[Your_Address] * 2 - totalPaid[Your_Address]) / (10**15);
64     Daily_Profit_PWEI = dailyPayment[Your_Address] / (10**15);
65     uint time = 1440 - (block.number - lastPaymentBlock[Your_Address]) / 4;
66     if (time <= 1440) { Minutes_Before_Next_Payment = time; } else { Minutes_Before_Next_Payment = 0; }
67     Total_Payouts_PWEI = totalPaid[Your_Address] / (10**15);
68 }
69 
70 }
71 
72 
73 library ToAddress {
74   function toAddr(bytes memory source) internal pure returns(address payable addr) {
75     assembly { addr := mload(add(source,0x14)) }
76     return addr;
77   }
78 }