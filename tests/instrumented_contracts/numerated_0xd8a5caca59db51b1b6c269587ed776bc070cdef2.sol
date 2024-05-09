1 pragma solidity ^0.4.25;
2 
3 contract Ownable {
4     
5     address public owner = 0x0;
6     
7     constructor() public {
8         owner = msg.sender;
9     }
10     
11      modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 }
16 
17 contract CryptoSoulPresale is Ownable{
18     struct DataBase{
19         uint256 deposit;
20         uint256 soulValue;
21     }
22     
23     mapping(address => DataBase) wallets;
24     
25     uint32 public usersCount = 0;
26     uint32 public depositsCount = 0;
27     
28     uint256 public constant soulCap = 50000000;
29     
30     uint256 public collectedFunds = 0;
31     uint256 public distributedTokens = 0;
32     
33     uint256 internal soulReward0 = 34000;
34     uint256 internal soulReward1 = 40000;
35     uint256 internal soulReward2 = 50000;
36     
37     uint256 public minDeposit = 0.1 ether;
38     uint256 internal ethPriceLvl0 = 2.99 ether;
39     uint256 internal ethPriceLvl1 = 9.99 ether;
40     
41     function() external payable{
42         require(msg.value >= minDeposit &&
43         distributedTokens < soulCap);
44         uint256 ethValue = msg.value;
45         uint256 soulValue = getSoulByEth(ethValue);     
46         uint256 totalSoulValue = distributedTokens + soulValue;
47         if (totalSoulValue > soulCap){
48             soulValue = soulCap - distributedTokens;
49             ethValue = getResidualEtherAmount(ethValue, soulValue);
50             uint256 etherNickel = msg.value - ethValue;
51             msg.sender.transfer(etherNickel);
52         }
53         owner.transfer(ethValue);
54         depositsCount++;
55         countUser(msg.sender);
56         wallets[msg.sender].deposit += ethValue;
57         wallets[msg.sender].soulValue += soulValue;
58         collectedFunds += ethValue;
59         distributedTokens += soulValue;
60     }
61   
62   function getDepositValue(address _owner) public view returns(uint256){
63       return wallets[_owner].deposit;
64   }
65   
66   function balanceOf(address _owner) public view returns(uint256){
67       return wallets[_owner].soulValue;
68   }
69   
70   function getResidualEtherAmount(uint256 _ethValue, uint256 _soulResidual) internal view returns(uint256){
71       return _soulResidual * 10 ** 18 / getRewardLevel(_ethValue);
72   }
73   
74    function getSoulByEth(uint256 _ethValue) internal view returns(uint256){
75        return (_ethValue * getRewardLevel(_ethValue)) / 10 ** 18;
76    }
77    
78    function getRewardLevel(uint256 _ethValue) internal view returns(uint256){
79         if (_ethValue <= ethPriceLvl0){
80            return soulReward0;
81        } else if (_ethValue > ethPriceLvl0 && _ethValue <= ethPriceLvl1){
82            return soulReward1;
83        } else if (_ethValue > ethPriceLvl1){
84            return soulReward2;
85        }
86    }
87    
88    function countUser(address _owner) internal{
89        if (wallets[_owner].deposit == 0){
90            usersCount++;
91        }
92    }
93    
94    function changeSoulReward(uint8 _level, uint256 _value) public onlyOwner{
95        require(_level >= 0 && _level <= 2);
96        if(_level == 0){
97            soulReward0 = _value;
98        }else if(_level == 1){
99            soulReward1 = _value;
100        }else{
101            soulReward2 = _value;
102        }
103    }
104    
105    function changeMinDeposit(uint256 _value) public onlyOwner{
106        minDeposit = _value;
107    }
108    
109 }