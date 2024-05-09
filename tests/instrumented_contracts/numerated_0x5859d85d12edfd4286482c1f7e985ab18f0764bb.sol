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
38         endDate = now + 12 weeks;
39         startDate = now;
40         main_addr = 0xAD7615B0524849918AEe77e6c2285Dd7e8468650;
41         r = Robocalls(main_addr);
42     }
43     
44     
45     function setEndDate(uint _newEndDate ) public {
46         require(msg.sender==owner);
47         endDate =  _newEndDate;
48     } 
49     
50     function setBonusEndDate(uint _newBonusEndDate ) public {
51         require(msg.sender==owner);
52         bonusEnds =  _newBonusEndDate;
53     } 
54     
55     // ------------------------------------------------------------------------
56     // CrowdSale Function 10,000,000 RCALLS Tokens per 1 ETH
57     // ------------------------------------------------------------------------
58     function () public payable {
59         require(now >= startDate && now <= endDate);
60         uint tokens;
61         if (now <= bonusEnds) {
62             tokens = msg.value * 1500000;
63         } else {
64             tokens = msg.value * 10000000;
65         }
66         r.transferFrom(owner,msg.sender, tokens);
67         owner.transfer(msg.value);
68     }
69 
70 }