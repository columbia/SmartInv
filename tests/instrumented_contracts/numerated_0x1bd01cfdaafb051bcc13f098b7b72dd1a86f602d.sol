1 pragma solidity ^0.4.24;
2 
3 contract Robocalls  {
4     function transferFrom(address from, address to, uint tokens) public returns (bool success) {}
5 }
6 
7 contract RobocallsTokenSale  {
8     address public owner;
9     uint   public startDate;
10     uint   public bonusEnds;
11     uint   public endDate;
12     address public main_addr;
13     Robocalls r;
14     
15     
16     constructor() public {
17         owner = msg.sender;
18         bonusEnds = now + 8 weeks;
19         endDate = now + 8 weeks;
20         startDate = now;
21         main_addr = 0xAD7615B0524849918AEe77e6c2285Dd7e8468650;
22         r = Robocalls(main_addr);
23     }
24     
25     
26     function setEndDate(uint _newEndDate ) public {
27         require(msg.sender==owner);
28         endDate =  _newEndDate;
29     } 
30     
31     function setBonusEndDate(uint _newBonusEndDate ) public {
32         require(msg.sender==owner);
33         bonusEnds =  _newBonusEndDate;
34     } 
35     
36     // ------------------------------------------------------------------------
37     // CrowdSale Function 10,000,000 RCALLS Tokens per 1 ETH
38     // ------------------------------------------------------------------------
39     function () public payable {
40         require(now >= startDate && now <= endDate);
41         uint tokens;
42         if (now <= bonusEnds) {
43             tokens = msg.value * 13000000;
44         } else {
45             tokens = msg.value * 10000000;
46         }
47         r.transferFrom(owner,msg.sender, tokens);
48         owner.transfer(msg.value);
49     }
50 
51 }