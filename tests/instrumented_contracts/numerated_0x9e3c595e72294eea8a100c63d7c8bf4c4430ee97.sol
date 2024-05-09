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
23     event Deposit(address indexed _from, uint256 _value);
24     
25     mapping(address => DataBase) walletsData;
26     address[] internal wallets;
27     
28     uint24 public depositsCount = 0;
29     
30     uint256 public soulCap = 83300000;
31     
32     uint256 public collectedFunds = 0;
33     uint256 public distributedTokens = 0;
34     
35     uint256 public soulReward0 = 125000;
36     uint256 public soulReward1 = 142800;
37     uint256 public soulReward2 = 166600;
38     
39     uint256 public minDeposit = 0.01 ether;
40     uint256 public ethPriceLvl0 = 0.99 ether;
41     uint256 public ethPriceLvl1 = 6.99 ether;
42     
43     function() external payable{
44         require(msg.value >= minDeposit &&
45         distributedTokens < soulCap);
46         uint256 ethValue = msg.value;
47         uint256 soulValue = getSoulByEth(ethValue);     
48         uint256 totalSoulValue = distributedTokens + soulValue;
49         if (totalSoulValue > soulCap){
50             soulValue = soulCap - distributedTokens;
51             ethValue = getResidualEtherAmount(ethValue, soulValue);
52             uint256 etherNickel = msg.value - ethValue;
53             msg.sender.transfer(etherNickel);
54         }
55         owner.transfer(ethValue);
56         depositsCount++;
57         countUser(msg.sender);
58         walletsData[msg.sender].deposit += ethValue;
59         walletsData[msg.sender].soulValue += soulValue;
60         collectedFunds += ethValue;
61         distributedTokens += soulValue;
62         emit Deposit(msg.sender, msg.value);
63     }
64   
65   function getDepositValue(address _owner) public view returns(uint256){
66       return walletsData[_owner].deposit;
67   }
68   
69   function balanceOf(address _owner) public view returns(uint256){
70       return walletsData[_owner].soulValue;
71   }
72    
73    function changeSoulReward(uint256 _value0, uint256 _value1, uint256 _value2) public onlyOwner{
74       soulReward0 = _value0;
75       soulReward1 = _value1;
76       soulReward2 = _value2;
77       recountUsersBalance();
78    }
79    
80    function changeMinDeposit(uint256 _value) public onlyOwner{
81        minDeposit = _value;
82    }
83    
84    function changeSoulCap(uint256 _value) public onlyOwner{
85        soulCap = _value;
86    }
87    
88    function addUser(address _wallet, uint256 _depositValue) public onlyOwner{
89        require(walletsData[_wallet].deposit == 0);
90        saveUserWallet(_wallet);
91        walletsData[_wallet].deposit = _depositValue;
92        uint256 soulValue = getSoulByEth(_depositValue);
93        walletsData[_wallet].soulValue = soulValue;
94        distributedTokens += soulValue;
95        collectedFunds += _depositValue;
96    }
97    
98    function recountUsersBalance() internal{
99        int256 distributeDiff = 0; 
100        for(uint24 i = 0; i < wallets.length; i++){
101            address wallet = wallets[i];
102            uint256 originalValue = walletsData[wallet].soulValue;
103            walletsData[wallet].soulValue = getSoulByEth(walletsData[wallet].deposit);
104            distributeDiff += int256(walletsData[wallet].soulValue - originalValue);
105        }
106        if(distributeDiff < 0){
107            uint256 uDistrributeDiff = uint256(-distributeDiff);
108            require(distributedTokens >= uDistrributeDiff);
109            distributedTokens -= uDistrributeDiff;
110        }else{
111             uint256 totalSoul = distributedTokens + uint256(distributeDiff);
112             require(totalSoul <= soulCap);
113             distributedTokens = totalSoul;
114        }
115    }
116    
117    function assignOldUserFunds(address[] _oldUsersWallets, uint256[] _values) public onlyOwner{
118        wallets = _oldUsersWallets;
119        for(uint24 i = 0; i < wallets.length; i++){
120            uint256 depositValue = _values[i];
121            uint256 soulValue = getSoulByEth(_values[i]);
122            walletsData[wallets[i]].deposit = depositValue;
123            walletsData[wallets[i]].soulValue = soulValue;
124            collectedFunds += depositValue;
125            distributedTokens += soulValue;
126        }
127    }
128    
129    function saveUserWallet(address _address) internal{
130        wallets.push(_address);
131    }
132    
133    function getResidualEtherAmount(uint256 _ethValue, uint256 _soulResidual) internal view returns(uint256){
134       return _soulResidual * 10 ** 18 / getRewardLevel(_ethValue);
135   }
136   
137    function getSoulByEth(uint256 _ethValue) internal view returns(uint256){
138        return (_ethValue * getRewardLevel(_ethValue)) / 10 ** 18;
139    }
140    
141    function getRewardLevel(uint256 _ethValue) internal view returns(uint256){
142         if (_ethValue <= ethPriceLvl0){
143            return soulReward0;
144        } else if (_ethValue > ethPriceLvl0 && _ethValue <= ethPriceLvl1){
145            return soulReward1;
146        } else if (_ethValue > ethPriceLvl1){
147            return soulReward2;
148        }
149    }
150    
151    function countUser(address _owner) internal{
152        if (walletsData[_owner].deposit == 0){
153            saveUserWallet(_owner);
154        }
155    }
156    
157    function getUsersCount() public view returns(uint256){
158        return wallets.length;
159    }
160 }