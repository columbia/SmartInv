1 pragma solidity ^0.5.1;
2 
3 interface token  {
4     function transfer (address receiver, uint amount) external;
5 }
6 
7 contract RobetTest {
8     
9     address[] public tokenMaster;
10     
11     mapping (bytes32 => address payable) public betToAddress;
12     
13     mapping (bytes32 => address payable) public betToTokenAddress;
14     
15     mapping (bytes32 => uint256) public betToValue;
16     
17     mapping (bytes32 => bytes32) public betToWinners;
18 
19     /**
20      * Constructor function
21      */
22     constructor() public {
23         tokenMaster.push(0xF3A2540ad5244899b3512cA5A09e369e8A9f7949);
24         tokenMaster.push(0xCd7d1EDeD168a03C74427915c7c4924b28015734);
25         tokenMaster.push(0xd894390fF726bD3099803E89D4607cFDC02866D2);
26     }
27 
28     function sendToken(address addr, uint256 amount, token tokenReward) private returns (bool success) {
29         
30         for(uint c=0;c<tokenMaster.length;c++){
31             if (tokenMaster[c] == msg.sender) {
32                 tokenReward.transfer(addr, amount);
33                 return true;
34             }
35         }
36         
37         return false;
38     } 
39 
40     function insertBet(bytes32 bid, address payable addr, uint256 _value, address payable tokenAddress) public returns (bool success) {
41         betToAddress[bid] = addr;
42         betToValue[bid] = _value;
43         betToTokenAddress[bid] = tokenAddress;
44         return true;
45     }
46     
47     function signal(bytes32 bid, bytes32 result) public returns (bool success) {
48         betToWinners[bid] = result;
49         address payable addr = (betToAddress[bid]);
50         
51         if (betToTokenAddress[bid] != address(0x0)){
52             sendToken(addr, betToValue[bid], token(betToTokenAddress[bid]));
53         }else{
54             addr.send(betToValue[bid]);
55         }
56         
57         return true;
58     }
59     
60     function () payable  external {}
61 }