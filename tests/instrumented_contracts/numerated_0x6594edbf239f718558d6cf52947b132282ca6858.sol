1 pragma solidity ^0.4.25;
2 
3 contract FundEIF {
4   
5   mapping(address => uint256) public receivedFunds; //doesn't include interest returned but allows other addresses to send funds
6   uint256 public totalSent;                         //includes reinvested interest + totalOtherReceived outside PoEIF
7   uint256 public totalOtherReceived;                //total received outside PoEIF
8   uint256 public totalInterestReinvested;           //updated for promotional reasons
9   address public EIF;
10   address public PoEIF;
11   event INCOMING(address indexed sender, uint amount, uint256 timestamp);
12   event OUTGOING(address indexed sender, uint amount, uint256 timestamp);
13 
14   constructor() public {
15     EIF = 0x27E06500263D6B27A3f8b7Be636AaBC7ADc186Be;    //EasyInvestForeverNeverending
16     PoEIF = 0xFfB8ccA6D55762dF595F21E78f21CD8DfeadF1C8;  //PoEIF
17   }
18   
19   function () external payable {
20       emit INCOMING(msg.sender, msg.value, now);  //msg.sender is EIF if it is interest
21       if (msg.sender != EIF) {                    //will only use more gas if not a returned interest payment
22           receivedFunds[msg.sender] += msg.value; //update totals for this sender (normally PoEIF)
23           if (msg.sender != PoEIF) {              //update totalsOtherReceived updates if non-PoEIF
24               totalOtherReceived += msg.value;
25           }
26       }
27   }
28   
29   function PayEIF() external {
30       uint256 currentBalance=address(this).balance;
31       totalSent += currentBalance;                                                 //update totalSent
32       totalInterestReinvested = totalSent-receivedFunds[PoEIF]-totalOtherReceived; //update totalInterestReinvested
33       emit OUTGOING(msg.sender, currentBalance, now);
34       if(!EIF.call.value(currentBalance)()) revert();
35   }
36 }