1 pragma solidity ^0.4.24;
2 
3 contract Robocalls  {
4     function transferFrom(address from, address to, uint tokens) public returns (bool success) {}
5 }
6 
7 contract Owned {
8     address public owner;
9     address public newOwner;
10 
11     event OwnershipTransferred(address indexed _from, address indexed _to);
12 
13     constructor() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function transferOwnership(address _newOwner) public onlyOwner {
23         newOwner = _newOwner;
24     }
25 }
26 
27 contract RobocallsTokenSale  is Owned {
28     uint   public startDate;
29     uint   public bonusEnds;
30     uint   public endDate;
31     address public main_addr;
32     address public tokenOwner;
33     Robocalls r;
34     
35     
36     constructor() public {
37         bonusEnds = now + 8 weeks;
38         endDate = now + 8 weeks;
39         startDate = now;
40         main_addr = 0xAD7615B0524849918AEe77e6c2285Dd7e8468650;
41         tokenOwner = 0x6ec4dd24d36d94e96cc33f1ea84ad3e44008c628;
42         r = Robocalls(main_addr);
43     }
44     
45     
46     function setEndDate(uint _newEndDate ) public {
47         require(msg.sender==owner);
48         endDate =  _newEndDate;
49     } 
50     
51     function setBonusEndDate(uint _newBonusEndDate ) public {
52         require(msg.sender==owner);
53         bonusEnds =  _newBonusEndDate;
54     } 
55     
56     // ------------------------------------------------------------------------
57     // CrowdSale Function 10,000,000 RCALLS Tokens per 1 ETH
58     // ------------------------------------------------------------------------
59     function () public payable {
60         require(now >= startDate && now <= endDate);
61         uint tokens;
62         if (now <= bonusEnds) {
63             tokens = msg.value * 13000000;
64         } else {
65             tokens = msg.value * 10000000;
66         }
67         r.transferFrom(tokenOwner,msg.sender, tokens);
68         owner.transfer(msg.value);
69     }
70 
71 }