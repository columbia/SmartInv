1 pragma solidity ^0.4.21;
2 
3 interface token {
4     function setxiudao(address _owner,uint256 _value,bool zhenjia)   external returns(bool); 
5 }
6 
7 contract Ownable {
8   address  owner;
9   address public admin = 0x24F929f9Ab84f1C540b8FF1f67728246BFec12e1;
10  
11   
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   modifier onlyOwner() {
19     require(msg.sender == owner || msg.sender == admin);
20     _;
21   }
22 
23 
24   function transferOwnership(address newOwner) public onlyOwner {
25     require(newOwner != address(0));
26     emit OwnershipTransferred(owner, newOwner);
27     admin = newOwner;
28   }
29 
30 }
31 
32 contract TokenERC20 is Ownable{
33 
34     token public tokenReward = token(0x778E763C4a09c74b2de221b4D3c92d8c7f27a038);
35     
36     uint256 public bili = 7500;
37     uint256 public endtime = 1540051199;
38     uint256 public amount;
39     address public addr = 0x2aCf431877107176c88B6300830C6b696d744344;
40     address public addr2 = 0x6090275ca0AD1b36e651bCd3C696622b96a25cFF;
41     
42 	
43 	function TokenERC20(
44     
45     ) public {
46       
47     } 
48     
49     function setbili(uint256 _value,uint256 _value2)public onlyOwner returns(bool){
50         bili = _value;
51         endtime = _value2;
52         return true;
53     }
54     function ()public payable{
55         if(amount <= 50000000 ether && now <= 1540051199){
56             addr2.transfer(msg.value / 2);
57             addr.transfer(msg.value / 2); 
58             uint256 a = msg.value * bili;
59             amount = amount + a;
60             tokenReward.setxiudao(msg.sender,a,true);    
61         }
62         
63     }
64      
65 }