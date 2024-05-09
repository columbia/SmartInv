1 pragma solidity ^0.4.6;
2 
3 // ## Matthew - a contract for increasing "whaleth"
4 // README: https://github.com/rolandkofler/matthew
5 // MIT LICENSE 2016 Roland Kofler, thanks to Crul for testing
6 
7 contract Matthew {
8     address owner;
9     address public whale;
10     uint256 public blockheight;
11     uint256 public stake;
12     uint256 period = 40; //180 blocks ~ 42 min, 300 blocks ~ 1h 10 min;
13     uint constant public DELTA = 0.1 ether;
14     uint constant public WINNERTAX_PRECENT = 10;
15     bool mustBeDestroyed = false;
16     uint newPeriod = period;
17     
18     event MatthewWon(string msg, address winner, uint value,  uint blocknumber);
19     event StakeIncreased(string msg, address staker, uint value, uint blocknumber);
20     
21     function Matthew(){
22         owner = msg.sender;
23         setFacts();
24     }
25     
26     function setFacts() private {
27         stake = this.balance;
28         period = newPeriod;
29         blockheight = block.number;
30         whale = msg.sender;
31     }
32     
33     /// The rich get richer, the whale get whaler
34     function () payable{
35     
36         if (block.number - period >= blockheight){ // time is over, Matthew won
37             bool isSuccess=false; //mutex against recursion attack
38             var nextStake = stake * WINNERTAX_PRECENT/100;  // leave some money for the next round
39             if (isSuccess == false) //check against recursion attack
40                 isSuccess = whale.send(stake - nextStake); // pay out the stake
41             MatthewWon("Matthew won", whale, stake - nextStake, block.number);
42             setFacts();//reset the game
43             if (mustBeDestroyed) selfdestruct(whale); 
44             return;
45             
46         }else{ // top the stake
47             if (msg.value < stake + DELTA) throw; // you must rise the stake by Delta
48             bool isOtherSuccess = msg.sender.send(stake); // give back the old stake
49             setFacts(); //reset the game
50             StakeIncreased("stake increased", whale, stake, blockheight);
51         }
52     }
53     
54     // better safe than sorry
55     function destroyWhenRoundOver() onlyOwner{
56         mustBeDestroyed = true;
57     }
58     
59     // next round we set a new staking perioud
60     function setNewPeriod(uint _newPeriod) onlyOwner{
61         newPeriod = _newPeriod;
62     }
63     
64     function getPeriod() constant returns (uint){
65         return period;
66     }
67     
68     function getNewPeriod() constant returns (uint){
69         return newPeriod;
70     }
71     
72     function getDestroyedWhenRoundOver() constant returns (bool){
73         return mustBeDestroyed;
74     }
75     
76     //how long until a Matthew wins?
77     function getBlocksTillMatthew() public constant returns(uint){
78         if (blockheight + period > block.number)
79             return blockheight + period - block.number;
80         else
81             return 0;
82     }
83     
84     modifier onlyOwner(){
85         if (msg.sender != owner) throw;
86         _;
87     }
88 }