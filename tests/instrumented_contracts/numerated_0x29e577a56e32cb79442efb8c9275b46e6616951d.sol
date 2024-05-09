1 pragma solidity ^0.4.18;
2 
3 contract SimpleEscrow {
4     
5     uint public PERIOD = 21 days;
6     
7     uint public SAFE_PERIOD = 5 days;
8     
9     address public developerWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
10     
11     address public customerWallet;
12     
13     uint public started;
14     
15     uint public orderLastDate;
16     
17     uint public safeLastDate;
18 
19     address public owner;
20 
21     function SimpleEscrow() public {
22         owner = msg.sender;
23     }
24 
25     modifier onlyCustomer() {
26         require(msg.sender == customerWallet);
27         _;
28     }
29 
30     modifier onlyDeveloper() {
31         require(msg.sender == developerWallet);
32         _;
33     }
34     
35     function setDeveloperWallet(address newDeveloperWallet) public {
36         require(msg.sender == owner);
37         developerWallet = newDeveloperWallet;
38     }
39 
40     function completed() public onlyCustomer {
41         developerWallet.transfer(this.balance);
42     }
43 
44     function orderNotAccepted() public onlyCustomer {
45         require(now >= orderLastDate);
46         safeLastDate += SAFE_PERIOD;
47     }
48 
49     function failedByDeveloper() public onlyDeveloper {
50         customerWallet.transfer(this.balance);
51     }
52     
53     function completeOrderBySafePeriod() public onlyDeveloper {
54         require(now >= safeLastDate);
55         developerWallet.transfer(this.balance);
56     }
57     
58     function () external payable {
59         require(customerWallet == address(0x0));
60         customerWallet = msg.sender;
61         started = now;
62         orderLastDate = started + PERIOD;
63         safeLastDate = orderLastDate + SAFE_PERIOD;
64     }
65     
66 }