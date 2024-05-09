1 pragma solidity ^0.4.4;
2 
3 // ## Mattew - a contract for increasing "whaleth"
4 // README: https://github.com/rolandkofler/mattew
5 // MIT LICENSE 2016 Roland Kofler, thanks to Crul for testing
6 
7 contract Mattew {
8     address whale;
9     uint256 stake;
10     uint256 blockheight;
11     uint256 constant PERIOD = 200; //60 * 10 /14; //BLOCKS_PER_DAY;
12     uint constant DELTA = 0.1 ether;
13     
14     event MattewWon(string msg, address winner, uint value,  uint blocknumber);
15     event StakeIncreased(string msg, address staker, uint value, uint blocknumber);
16     
17     function Mattew(){
18         setFacts();
19     }
20     
21     function setFacts() private {
22         stake = msg.value;
23         blockheight = block.number;
24         whale = msg.sender;
25     }
26     
27     /// The rich get richer, the whale get whaler
28     function () payable{
29         if (block.number - PERIOD > blockheight){
30             bool isSuccess = whale.send(stake);
31             MattewWon("Mattew won (mattew, stake, blockheight)", whale, stake, block.number);
32             setFacts();
33             // selfdestruct(whale); People with Ethereum Foundation are ok with it.
34             return;
35             
36         }else{
37             
38             if (msg.value < stake + DELTA) throw;
39             bool isOtherSuccess = msg.sender.send(stake);
40             setFacts();
41             StakeIncreased("stake increased (whale, stake, blockheight)", whale, stake, blockheight);
42         }
43     }
44     
45     
46     function getStake() public constant returns(uint){
47         return stake;
48     }
49     
50     function getBlocksTillMattew() public constant returns(uint){
51         if (blockheight + PERIOD > block.number)
52             return blockheight + PERIOD - block.number;
53         else
54             return 0;
55     }
56 }