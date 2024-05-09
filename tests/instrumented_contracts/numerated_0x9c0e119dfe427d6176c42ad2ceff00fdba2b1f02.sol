1 pragma solidity ^0.4.25 ;
2 
3 contract TestABI{
4     address owner;
5     constructor() public payable{
6         owner = msg.sender;
7     }
8     modifier onlyOwner(){
9         require (msg.sender==owner);
10         _;
11     }
12     function () payable public {
13         // 其他逻辑
14     }
15     // 获取合约账户余额
16     function getBalance() public constant returns(uint){
17         return address(this).balance;
18     }
19     // 合约出账
20     function sendTransfer(address _user,uint _price) public onlyOwner{
21         require(_user!=owner);
22         if(address(this).balance>=_price){
23             _user.transfer(_price);
24         }
25     }
26     // 提币
27     function getEth(uint _price) public onlyOwner{
28         if(_price>0){
29             if(address(this).balance>=_price){
30                 owner.transfer(_price);
31             }
32         }else{
33            owner.transfer(address(this).balance); 
34         }
35     }
36 }