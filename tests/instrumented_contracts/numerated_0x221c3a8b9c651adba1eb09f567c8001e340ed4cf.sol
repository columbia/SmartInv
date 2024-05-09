1 /**
2  *Submitted for verification at Etherscan.io on 2019-09-30
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-09-09
7  * BEB dapp for www.betbeb.com www.bitbeb.com
8 */
9 pragma solidity^0.4.24;  
10 interface tokenTransfer {
11     function transfer(address receiver, uint amount);
12     function transferFrom(address _from, address _to, uint256 _value);
13     function balanceOf(address receiver) returns(uint256);
14 }
15 
16 contract Ownable {
17   address public owner;
18  
19     function Ownable () public {
20         owner = msg.sender;
21     }
22  
23     modifier onlyOwner {
24         require (msg.sender == owner);
25         _;
26     }
27  
28     /**
29      * @param  newOwner address
30      */
31     function transferOwnership(address newOwner) onlyOwner public {
32         if (newOwner != address(0)) {
33         owner = newOwner;
34       }
35     }
36 }
37 
38 contract airdrop is Ownable{
39 function airdrop(address _tokenAddress){
40          bebTokenTransfer = tokenTransfer(_tokenAddress);
41      }
42     uint8 decimals = 18;
43    struct airdropuser {
44         uint256 Numberofdays;
45         uint256 _lasttime;
46     }
47     uint256 airdropAmount;
48     uint256 lastDate=now;
49     uint256 lastday=21;
50     uint256 depreciationTime=86400;
51     tokenTransfer public bebTokenTransfer; //代币 
52     mapping(address=>airdropuser)public airdropusers;
53     
54     function airdropBEB()public{
55         airdropuser storage _user=airdropusers[msg.sender];
56        uint256 lasttime=_user._lasttime;
57        if(lasttime==0){
58          _user._lasttime=now;
59          _user.Numberofdays+=1;
60          airdropusers[msg.sender]._lasttime=now;
61         bebTokenTransfer.transfer(msg.sender,airdropAmount);
62          return;
63        }
64         uint256 depreciation=(now-lasttime)/depreciationTime;
65         uint256 _lastDate=_user.Numberofdays+depreciation;
66         require(depreciation>0,"Less than 1 day of earnings");
67         require(_lastDate<lastday,"Must be less than 10 days");
68         require(getTokenBalance()>airdropAmount);
69         _user.Numberofdays+=depreciation;
70          _user._lasttime=now;
71         bebTokenTransfer.transfer(msg.sender,airdropAmount);
72     }
73     function getTokenBalance() public view returns(uint256){
74          return bebTokenTransfer.balanceOf(address(this));
75     }
76     function getairdropAmount(uint256 _value,uint256 _day)onlyOwner{
77         airdropAmount=_value*10**18;
78         lastday=_day;
79     }
80     function getdays() public view returns(uint256,uint256){
81          airdropuser storage _user=airdropusers[msg.sender];
82         return (_user.Numberofdays,_user._lasttime);
83     }
84     function ()payable{
85         
86     }
87 }