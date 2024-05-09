1 pragma solidity ^0.4.24;
2 
3 // This contract is a fork of Dr. Todd Proebsting's parimutuel contract. https://programtheblockchain.com/posts/2018/05/08/writing-a-parimutuel-wager-contract/
4 // Additional gas guzzling shitcoding by Woody Deck.
5 
6 contract WhatDoesNadiaThink {
7     address public owner;
8     string public question;
9     string public questionType;
10     string public answerHash;
11     bytes32[] public responses;
12     uint256 public marketClosureTime;
13     uint256 public timeout;
14     uint256 public integrityFee;
15     uint256 public integrityPercentage;
16     uint256 public winningAnswer;
17     uint256 public total;
18     
19     event AddressandAnswer(address indexed _from, uint256 indexed _result, uint _value);
20 
21     constructor(string _question, bytes32[] _responses, string _questionType, string _answerHash, uint256 _timeQuestionIsOpen)
22         public payable
23     {
24         owner = msg.sender;
25         question = _question;
26         responses = _responses;
27         marketClosureTime = now + _timeQuestionIsOpen; // The time in seconds that the market is open. After this time, the answer() function will revert all incoming transactions 
28         // until close() is executed by the owner. The frontend of the Dapp will check if the question is open for answer by seeing if the closure time has passed. Transacting 
29         // manually outside of the Dapp will mean you need to calculate this time yourself.
30         timeout = now + _timeQuestionIsOpen + 1209600; // The contract function cancel() can be executed by anyone after 14 days after market closure (1,209,600 seconds is 14 days).
31         // This is to allow for refunds if the answer is not posted in a timely manner. The market can still be resolved normally if the contract owner posts the result after 
32         // 14 days, but before anyone calls cancel().
33         questionType = _questionType; // Categories are art, fact, and opinion.
34         answerHash = _answerHash; // Hash of correct answer to verify integrity of the posted answer.
35         integrityPercentage = 5; // The market integrity fee (5% of the total) goes to the contract owner. It is to strongly encourage answer secrecy and fair play. The amount is about double what could be realistically stolen via insider trading without being easily detected forensically.  
36         winningAnswer = 1234; // Set initially to 1234 (all possible answers) so the frontend can recognize when the market is closed, but not yet resolved with an answer. The variable winningAnswer is purely statistical in nature.
37         total = msg.value; // This contract version is payable so the market can be seeded with free Ether to incentivize answers.
38     }
39 
40     enum States { Open, Resolved, Cancelled }
41     States state = States.Open;
42 
43     mapping(address => mapping(uint256 => uint256)) public answerAmount;
44     mapping(uint256 => uint256) public totalPerResponse;
45 
46 
47     uint256 winningResponse;
48 
49     function answer(uint256 result) public payable {
50         
51         if (now > marketClosureTime) {
52             revert(); // Prevents answers after the market closes.
53         }
54         
55         require(state == States.Open);
56 
57         answerAmount[msg.sender][result] += msg.value;
58         totalPerResponse[result] += msg.value;
59         total += msg.value;
60         require(total < 2 ** 128);   // Avoid overflow possibility.
61         
62         emit AddressandAnswer(msg.sender, result, msg.value);
63     }
64 
65     function resolve(uint256 _winningResponse) public {
66         require(now > marketClosureTime && state == States.Open); // States of smart contracts are updated only when someone transacts with them. The answer function looks up the Unix time that is converted on the front end to see if the market is still open. The state doesn't change until resolved, so both cases must be true in order to use the resolve() function, otherwise the owner could resolve early or change the answer after. '
67         require(msg.sender == owner);
68 
69         winningResponse = _winningResponse; // This is the internally used integer, as arrays in Solidity start from 0.
70         winningAnswer = winningResponse + 1; // Publically posts the correct answer. The '+ 1' addition is for the frontend and to avoid layman confusion with arrays that start from zero.
71         
72         if (totalPerResponse[winningResponse] == 0) {
73             state = States.Cancelled; // If nobody bet on the winning answer, the market is cancelled, else it is resolved. Losing bets will be refunded. 
74         } else {
75             state = States.Resolved;
76             integrityFee = total * integrityPercentage/100; // Only collect the integrityFee if the market resolves. It would be a mess to take upfront in case of cancel() being executed.
77             msg.sender.transfer(integrityFee); // The integrityFee goes to the owner.
78         }
79         
80     }
81 
82     function claim() public {
83         require(state == States.Resolved);
84 
85         uint256 amount = answerAmount[msg.sender][winningResponse] * (total - integrityFee) / totalPerResponse[winningResponse]; // Subtract the integrityFee from the total before paying out winners.
86         answerAmount[msg.sender][winningResponse] = 0;
87         msg.sender.transfer(amount);
88     }
89 
90     function cancel() public {
91         require(state != States.Resolved);
92         require(msg.sender == owner || now > timeout);
93 
94         state = States.Cancelled;
95     }
96 
97     function refund(uint256 result) public {
98         require(state == States.Cancelled);
99 
100         uint256 amount = answerAmount[msg.sender][result]; // You have to manually choose which answer you bet on because every answer is now entitled to a refund. Please when manually requesting a refund outside of the Dapp that Answer 1 is 0, Answer 2 is 1, Answer is 3, and Answer 4 is 3 as arrays start from 0. There is nothing bad that happens if you screw this up except a waste of gas. 
101         answerAmount[msg.sender][result] = 0;
102         msg.sender.transfer(amount);
103     }
104 }