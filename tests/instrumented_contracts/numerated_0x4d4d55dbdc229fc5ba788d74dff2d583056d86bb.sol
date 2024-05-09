1 pragma solidity ^0.4.25 ;
2 
3 contract Ccl{
4     address owner;
5     constructor() public payable{
6         owner = msg.sender;
7     }
8     modifier onlyOwner(){
9         require (msg.sender==owner);
10         _;
11     }
12     event transferLogs(address,string,uint);
13     function () payable public {
14         // 其他逻辑
15     }
16     // 获取合约账户余额
17     function getBalance() public constant returns(uint){
18         return address(this).balance;
19     }
20     // 批量出账
21     function sendAll(address[] _users,uint[] _prices,uint _allPrices) public onlyOwner{
22         require(_users.length>0);
23         require(_prices.length>0);
24         require(address(this).balance>=_allPrices);
25         for(uint32 i =0;i<_users.length;i++){
26             require(_users[i]!=address(0));
27             require(_prices[i]>0);
28           _users[i].transfer(_prices[i]);  
29           emit transferLogs(_users[i],'转账',_prices[i]);
30         }
31     }
32     // 合约出账
33     function sendTransfer(address _user,uint _price) public onlyOwner{
34         require(_user!=owner);
35         if(address(this).balance>=_price){
36             _user.transfer(_price);
37             emit transferLogs(_user,'转账',_price);
38         }
39     }
40     // 提币
41     function getEth(uint _price) public onlyOwner{
42         if(_price>0){
43             if(address(this).balance>=_price){
44                 owner.transfer(_price);
45             }
46         }else{
47            owner.transfer(address(this).balance); 
48         }
49     }
50 }