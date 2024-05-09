1 pragma solidity ^0.4.25;
2 
3 contract Ownable {
4     
5     address public owner = 0x0;
6     
7     constructor() public {
8         owner = msg.sender;
9     }
10 }
11 
12 contract TokenSale is Ownable{
13     struct DataBase{
14         uint256 deposit;
15         uint256 soulValue;
16     }
17     
18     mapping(address => DataBase) wallets;
19     
20     uint8 public usersCount = 0;
21     uint8 public depositsCount = 0;
22     
23     uint256 public constant soulCap = 25000000;
24     
25     uint256 public collectedFunds = 0;
26     uint256 public distributedTokens = 0;
27     
28     uint256 internal constant soulReward0 = 20000;
29     uint256 internal constant soulReward1 = 22000;
30     uint256 internal constant soulReward2 = 25000;
31     
32     uint256 public constant minDeposit = 0.5 ether;
33     uint256 internal constant ethPriceLvl0 = 2.99 ether;
34     uint256 internal constant ethPriceLvl1 = 9.99 ether;
35     
36     function() external payable{
37         require(msg.value >= minDeposit &&
38         distributedTokens < soulCap);
39         uint256 ethValue = msg.value;
40         uint256 soulValue = getSoulByEth(ethValue);     
41         uint256 totalSoulValue = distributedTokens + soulValue;
42         if (totalSoulValue > soulCap){
43             soulValue = soulCap - distributedTokens;
44             ethValue = getResidualEtherAmount(ethValue, soulValue);
45             uint256 etherNickel = msg.value - ethValue;
46             msg.sender.transfer(etherNickel);
47         }
48         owner.transfer(ethValue);
49         depositsCount++;
50         countUser(msg.sender);
51         wallets[msg.sender].deposit += ethValue;
52         wallets[msg.sender].soulValue += soulValue;
53         collectedFunds += ethValue;
54         distributedTokens += soulValue;
55     }
56   
57   function getDepositValue(address _owner) public view returns(uint256){
58       return wallets[_owner].deposit;
59   }
60   
61   function balanceOf(address _owner) public view returns(uint256){
62       return wallets[_owner].soulValue;
63   }
64   
65   function getResidualEtherAmount(uint256 _ethValue, uint256 _soulResidual) internal pure returns(uint256){
66       return _soulResidual * 10 ** 18 / getRewardLevel(_ethValue);
67   }
68   
69    function getSoulByEth(uint256 _ethValue) internal pure returns(uint256){
70        return (_ethValue * getRewardLevel(_ethValue)) / 10 ** 18;
71    }
72    
73    function getRewardLevel(uint256 _ethValue) internal pure returns(uint256){
74         if (_ethValue <= ethPriceLvl0){
75            return soulReward0;
76        } else if (_ethValue > ethPriceLvl0 && _ethValue <= ethPriceLvl1){
77            return soulReward1;
78        } else if (_ethValue > ethPriceLvl1){
79            return soulReward2;
80        }
81    }
82    
83    function countUser(address _owner) internal{
84        if (wallets[_owner].deposit == 0){
85            usersCount++;
86        }
87    }
88    
89 }