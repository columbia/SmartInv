1 /**
2  *Submitted for verification at Etherscan.io on 2019-09-09
3  * BEB dapp for www.betbeb.com or www.bitbeb.com
4 */
5 pragma solidity^0.4.24;  
6 
7 interface tokenTransfer {
8     function transfer(address receiver, uint amount);
9     function transferFrom(address _from, address _to, uint256 _value)returns (bool success);
10     function balanceOf(address receiver) returns(uint256);
11 }
12 
13 contract Ownable {
14   address public owner;
15  
16     function Ownable () public {
17         owner = msg.sender;
18     }
19  
20     modifier onlyOwner {
21         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
22         _;
23     }
24  
25     /**
26      * @param  newOwner address 
27      */
28     function transferOwnership(address newOwner) onlyOwner public {
29         if (newOwner != address(0)) {
30         owner = newOwner;
31       }
32     }
33   
34 }
35 contract BebTreasure is Ownable{
36     
37     uint256 totalFraction;
38     uint256 fractionAmount;
39     uint256 totalNumber;
40     uint256 numberOfPeriods=201900000; 
41     address winAddress;
42     uint256 position;
43     address minter;
44     tokenTransfer public bebTokenTransfer; 
45     function BebTreasure(address _tokenAddress){
46          bebTokenTransfer = tokenTransfer(_tokenAddress);
47          //minter=_minter;
48      }
49      struct UserTreasure{
50          address addr;
51      }
52     mapping (address => UserTreasure) public UserTreasures;
53     address[] public minersArray;
54     //buy Treasure
55     function treasure(uint256 _amount,uint256 _fraction)public{
56         require(totalFraction >= _fraction+totalNumber);
57         require(_amount == fractionAmount);
58         uint256 sumAmount=_amount*_fraction;
59         address _addr = msg.sender;
60         UserTreasure storage user=UserTreasures[_addr];
61         bebTokenTransfer.transferFrom(_addr,address(this),sumAmount);
62         if(_fraction >1){
63             for(uint i=0;i<_fraction;i++){
64             minersArray.push(_addr);
65             }
66         }else{
67             minersArray.push(_addr);
68         }
69         user.addr=_addr;
70         totalNumber +=_fraction;
71     }
72     //new Treasure
73     function startTreasure(uint256 _totalFraction,uint256 _fractionAmount)onlyOwner {
74         //require(msg.sender ==minter,"Insufficient"); 
75         numberOfPeriods+=1;
76         totalFraction=_totalFraction;
77         fractionAmount=_fractionAmount* 10 ** 18;
78         totalNumber=0;
79         delete minersArray;
80     }
81     //openTreasure 
82     function openTreasure(uint256 _gamesmul)onlyOwner{
83        // require(msg.sender ==minter,"Insufficient");
84         require(totalNumber==totalFraction);
85         uint256 random2 = random(block.difficulty+_gamesmul*99/100);
86         winAddress = UserTreasures[minersArray[random2]].addr;
87         position = random2;
88         winAddress.transfer(1 ether);
89     }
90      function random(uint256 randomyType)   internal returns(uint256 num){
91         uint256 random = uint256(keccak256(randomyType,now));
92         uint256 randomNum = random%totalNumber;
93         return randomNum;
94     }
95      function getPlayersCount() public view returns(uint256){
96         return totalNumber;
97     }
98      function getWinInfo() public view returns(address,uint256){
99         return (winAddress,position);
100     }
101     function getPeriods() public view returns(uint256){
102         return numberOfPeriods;
103     }
104     function withdrawAmount(uint256 _amount) payable onlyOwner {
105         uint256 _amounteth=_amount* 10 ** 18;
106        require(this.balance>_amounteth,"Insufficient contract balance"); 
107       owner.transfer(_amounteth);
108     } 
109    function withdrawAmountBeb(uint256 amount) onlyOwner {
110         uint256 _amountbeb=amount* 10 ** 18;
111         require(getTokenBalance()>_amountbeb,"Insufficient contract balance");
112        bebTokenTransfer.transfer(owner,_amountbeb);
113     }
114     function getTokenBalance() public view returns(uint256){
115          return bebTokenTransfer.balanceOf(address(this));
116     }
117     function()payable{
118         
119     }
120 }