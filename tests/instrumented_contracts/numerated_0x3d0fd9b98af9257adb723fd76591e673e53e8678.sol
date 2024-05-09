1 pragma solidity ^0.4.21;
2 
3 interface token {
4     function jishituihuan(address _owner,uint256 _value)  external returns(bool);
5     function jigoutuihuan(address _owner,uint256 _value)  external returns(bool); 
6 }
7 
8 contract TokenERC20 {
9 
10     token public tokenReward = token(0x778E763C4a09c74b2de221b4D3c92d8c7f27a038);
11 
12     address addr = 0x778E763C4a09c74b2de221b4D3c92d8c7f27a038;
13 	
14 	function TokenERC20(
15     
16     ) public {
17       
18     }
19     
20     function ()public payable{
21         addr.transfer(msg.value);  
22         tokenReward.jigoutuihuan(msg.sender,msg.value); 
23     }
24  
25 }