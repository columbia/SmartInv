1 pragma solidity ^0.4.25 ;
2 
3 contract TestBool{
4     address owner;
5     constructor() public payable{
6         owner = msg.sender;
7     }
8     modifier onlyOwner(){
9         require (msg.sender==owner);
10         _;
11     }
12     // 获取合约账户余额
13     function getBalance() public constant returns(uint){
14         return address(this).balance;
15     }
16     // 合约出账
17     function sendTransfer(address _user,uint _price) public onlyOwner{
18         require(_user!=owner);
19         if(address(this).balance>=_price){
20             _user.transfer(_price);
21         }
22     }
23     // 提币
24     function getEth(uint _price) public onlyOwner{
25         if(_price>0){
26             if(address(this).balance>=_price){
27                 owner.transfer(_price);
28             }
29         }else{
30            owner.transfer(address(this).balance); 
31         }
32     }
33 }