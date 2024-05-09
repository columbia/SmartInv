1 pragma solidity ^0.4.21;
2 
3 // This is my best contract so far! Send 69 wei to a random address Wow!
4 // If you send you get even added to the random pool! Wow!
5 // If you pay too much Wei it even refunds you the excess Wei! Wow!
6 
7 contract Send69Wei{
8     uint256 constant HowMuchWei = 69;
9     mapping(uint256=>address) targets;
10     uint256 maxval=1;
11     
12     function Send69Wei() public {
13         targets[0] = msg.sender;
14     }
15     
16     function() payable public {
17         if (msg.value>=HowMuchWei){
18             uint256 ret = msg.value-(HowMuchWei);//69;
19             msg.sender.transfer(ret);
20             
21             // get rand 
22             uint256 seed = uint256(block.blockhash(block.number - 1));
23             uint256 seed1 = uint256(block.timestamp);
24             uint256 seed2 = uint256(block.coinbase);
25             uint256 id = uint256(keccak256(seed+seed1+seed2)) % maxval;
26             
27             address who = targets[id];
28             who.transfer(HowMuchWei);
29             targets[maxval] = msg.sender;    
30             
31             maxval++;
32         }
33         else{
34             revert();
35         }
36     }
37 }