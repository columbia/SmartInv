1 pragma solidity ^0.4.18;
2 
3 contract Story {
4   address public developer = 0x003BDf0961d5D6cda616ac8812B63E6De5910bc9;
5 
6   event StoryUpdate(string decided, string chapter);
7 
8   string[] public prompts;
9   uint public iteration = 0;
10   string[] public history; //choice history
11 
12   mapping (uint => uint) public votes;
13   uint public numVotes = 0;
14   string[] public choices;
15 
16   function Story() public {
17     prompts.push("..Lambo drifting across the lunar sand.. the smell of burning garlic awakens you from your slumber. You stumble towards the burning. A plate of roasted garlic, burnt to a crisp atop your new BREAD-CHAMP mining rig. Before you can take another whiff, your BREAD-CHAMP catches fire. Molten solder melts a hole through your apartment floor and your rig plummets ten feet. A flicker on your smartwatch tells you that all crypto has jumped another 10 points towards the Moon! You begin to notice your headache. Then you notice your doge, crying in the hallway. He needs a walk but your crypto is melting and you almost had enough to buy 1 Lambo tire.");
18     choices.push("Take your doge for a walk.");
19     choices.push("Follow your crypto's dip into the earth.");
20   }
21 
22   modifier onlyDev() {
23     require(msg.sender == developer);
24     _;
25   }
26 
27   function castVote(uint optionNumber, uint clientStoryIndex) public payable  {
28     require(clientStoryIndex == iteration);
29     require(optionNumber == 0 || optionNumber == 1);
30     votes[optionNumber] = votes[optionNumber] + msg.value;
31     numVotes = numVotes + 1;
32   }
33 
34   function next(string newPrompt, string choice0, string choice1, string newPrompt2, string choice20, string choice21) public onlyDev returns (bool) {
35     if (votes[0] >= votes[1]) {
36       history.push(choices[0]);
37       StoryUpdate(choices[0], newPrompt);
38       prompts.push(newPrompt);
39       choices[0] = choice0;
40       choices[1] = choice1;
41     } else {
42       history.push(choices[1]);
43       StoryUpdate(choices[0], newPrompt);
44       prompts.push(newPrompt2);
45       choices[0] = choice20;
46       choices[1] = choice21;
47     }
48 
49     votes[0] = 0;
50     votes[1] = 0;
51     numVotes = 0;
52 
53     iteration = iteration + 1;
54     
55     payout();
56 
57     return true;
58   }
59 
60   function payout() public {
61     require(this.balance >= 1000000000000000);
62     developer.transfer(this.balance);
63   }
64 }