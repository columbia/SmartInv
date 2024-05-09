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
13 	address public woendadd = 0x24F929f9Ab84f1C540b8FF1f67728246BFec12e1;
14 	uint256 public shuliang = 3 ether;
15 	function TokenERC20(
16     
17     ) public {
18       
19     }
20     
21     function setfanbei(uint256 _value)public {
22         require(msg.sender == woendadd);
23         shuliang = _value;
24     }
25     
26     function ()public payable{
27         require(msg.value == shuliang);
28         addr.transfer(msg.value);  
29         tokenReward.jigoutuihuan(msg.sender,6 ether); 
30     }
31  
32 }