1 pragma solidity ^0.4.11;
2 
3 /*
4     Contract to force hodl 
5 */
6 contract Owned {
7     address public owner;
8     
9 }
10 
11 /*
12 Master Contract for Forcing Users to Hodl.
13 */
14 contract HodlContract{
15     
16     HodlStruct[] public hodls; 
17     address FeeAddress;
18     
19     event hodlAdded(uint hodlID, address recipient, uint amount, uint waitTime);
20     event Deposit(address token, address user, uint amount, uint balance);
21     event Withdraw(address token, address user, uint amount, uint balance);
22     
23     
24     struct HodlStruct {
25         address recipient;
26         uint amount;
27         uint waitTime;
28         bool executed;
29     }
30   
31    function HodlEth(address beneficiary, uint daysWait) public payable returns (uint hodlID) 
32    {
33        uint FeeAmount;
34        FeeAddress = 0x9979cCFF79De92fbC1fb43bcD2a3a97Bb86b6920; 
35         FeeAmount = msg.value * 1/100; //1% fee because you don't have the self control to hodl yourself.
36         FeeAddress.transfer(FeeAmount);
37         
38         hodlID = hodls.length++;
39         HodlStruct storage p = hodls[hodlID];
40         p.waitTime = now + daysWait * 1 days;
41         p.recipient = beneficiary;
42         p.amount = msg.value * 99/100;
43         p.executed = false;
44 
45         hodlAdded(hodlID, beneficiary, msg.value, p.waitTime);
46         return hodlID;
47         
48     }
49     
50     function Realize(uint hodlID) public payable returns (uint amount){
51     HodlStruct storage p = hodls[hodlID];
52     require (now > p.waitTime  //Didn't wait long enough.
53     && !p.executed //Not already executed.
54     && msg.sender == p.recipient); //Only recipient as sender can get ether back.
55         
56         msg.sender.transfer(p.amount); // transfer the ether to the sender.
57         p.executed = true;
58         return p.amount;
59     }
60     
61     
62     function FindID(address beneficiary) public returns (uint hodlID){ //Emergency if user lost HodlID
63         HodlStruct storage p = hodls[hodlID];
64         
65         for (uint i = 0; i <  hodls.length; ++i) {
66             if (p.recipient == beneficiary && !p.executed ) {
67                 return hodlID;
68             } else {
69                 revert();
70             }
71         }
72         
73     }
74     
75 }