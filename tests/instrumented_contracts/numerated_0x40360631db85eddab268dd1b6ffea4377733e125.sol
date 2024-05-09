1 pragma solidity ^0.4.6;
2 
3 // ## Matthew - a contract for increasing "whaleth"
4 // README: https://github.com/rolandkofler/matthew
5 // MIT LICENSE 2016 Roland Kofler, thanks to Crul for testing
6 
7 contract Matthew {
8     address owner;
9     address whale;
10     uint256 blockheight;
11     uint256 period = 18; //180 blocks ~ 42 min, 300 blocks ~ 1h 10 min;
12     uint constant DELTA = 0.1 ether;
13     uint constant WINNERTAX_PRECENT = 10;
14     bool mustBeDestroyed = false;
15     uint newPeriod = 5;
16     
17     event MatthewWon(string msg, address winner, uint value,  uint blocknumber);
18     event StakeIncreased(string msg, address staker, uint value, uint blocknumber);
19     
20     function Matthew(){
21         owner = msg.sender;
22         setFacts();
23     }
24     
25     function setFacts() private {
26         period = newPeriod;
27         blockheight = block.number;
28         whale = msg.sender;
29     }
30     
31     /// The rich get richer, the whale get whaler
32     function () payable{
33     
34         if (block.number - period >= blockheight){ // time is over, Matthew won
35             bool isSuccess=false; //mutex against recursion attack
36             var nextStake = this.balance * WINNERTAX_PRECENT/100;  // leave some money for the next round
37             if (isSuccess == false) //check against recursion attack
38                 isSuccess = whale.send(this.balance - nextStake); // pay out the stake
39             MatthewWon("Matthew won", whale, this.balance, block.number);
40             setFacts();//reset the game
41             if (mustBeDestroyed) selfdestruct(whale); 
42             return;
43             
44         }else{ // top the stake
45             if (msg.value < this.balance + DELTA) throw; // you must rise the stake by Delta
46             bool isOtherSuccess = msg.sender.send(this.balance); // give back the old stake
47             setFacts(); //reset the game
48             StakeIncreased("stake increased", whale, this.balance, blockheight);
49         }
50     }
51     
52     // better safe than sorry
53     function destroyWhenRoundOver() onlyOwner{
54         mustBeDestroyed = true;
55     }
56     
57     // next round we set a new staking perioud
58     function setNewPeriod(uint _newPeriod) onlyOwner{
59         newPeriod = _newPeriod;
60     }
61     
62     function getPeriod() constant returns (uint){
63         period;
64     }
65     
66     //how long until a Matthew wins?
67     function getBlocksTillMatthew() public constant returns(uint){
68         if (blockheight + period > block.number)
69             return blockheight + period - block.number;
70         else
71             return 0;
72     }
73     
74     modifier onlyOwner(){
75         if (msg.sender != owner) throw;
76         _;
77     }
78 }