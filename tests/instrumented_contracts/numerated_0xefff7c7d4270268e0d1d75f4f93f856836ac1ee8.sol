1 pragma solidity ^0.4.23;
2 
3 contract ballotBox {
4     // addresses set to true are able to create new ballots
5     mapping(address => bool) public creators;
6     // define ballot object/struct
7     struct ballot {
8         uint8 choiceCount;
9         uint256 voteCountBlock;
10     }
11     // create array of ballots
12     ballot[] public ballots;
13     
14     // event to record what ballot contracts have been deployed with what parameters
15     event BallotCreated( string ballotProposal, uint256 indexed ballotIndex, address indexed ballotCreator, bytes32[] choices, uint256 countBlock );
16     // event to record a vote
17     event Vote(uint256 indexed ballotIndex, address voter, uint8 choice);
18     // event to record changes to creator permission                                 
19     event CreatorModified(address creator, bool active, address indexed by);
20     
21     constructor() public {
22         // set contract creator as authorized ballot creator
23         creators[msg.sender] = true;
24         emit CreatorModified(msg.sender, true, msg.sender);
25     }
26     
27     function createBallot(string _ballotQuestion, bytes32[] _choices, uint256 _countBlock) public {
28         // ensure the count is in the future
29         require(_countBlock > block.number);
30         // ensure msg.sender is an authorized ballot creator
31         require(creators[msg.sender]);
32         // add ballot object to array
33         ballots.push(ballot(uint8(_choices.length),_countBlock));
34         // fire event to record ballot contract creation and parameters
35         emit BallotCreated( _ballotQuestion, ballots.length-1 , msg.sender, _choices, _countBlock);
36     }
37     
38     function vote(uint256 _ballotIndex, uint8 _choice) public {
39         // ensure the count Block is not exceeded
40         require(ballots[_ballotIndex].voteCountBlock > block.number);
41         // ensure vote is a valid choice
42         require(_choice < ballots[_ballotIndex].choiceCount);
43         // fire event to record Vote
44         emit Vote(_ballotIndex, msg.sender, _choice);
45     }
46     
47     function modifyCreator(address _creator, bool _active) public {
48         // ensure only creators can add or remove creators
49         require(creators[msg.sender]);
50         // ensure creators can only remove themselves
51         if(_active == false) require(_creator == msg.sender);
52         // set creator status
53         creators[_creator] = _active;
54         // fire event to record creator permission change
55         emit CreatorModified(_creator, _active, msg.sender); 
56     }
57 }