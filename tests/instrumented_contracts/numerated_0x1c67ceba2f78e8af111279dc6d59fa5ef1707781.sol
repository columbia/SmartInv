1 pragma solidity ^0.4.21;
2 // The Original All For 1 -  www.allfor1.io
3 // https://www.twitter.com/allfor1_io
4 
5 
6 contract AllForOne {
7     
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9     mapping (address => uint) private playerKey;
10     mapping (address => uint) public playerCount;
11     mapping (address => uint) public currentGame;
12     mapping (address => uint) public currentPlayersRequired;
13     
14     mapping (address => uint) private playerRegistrationStatus;
15     mapping (address => uint) private playerNumber;
16     mapping (uint => address) private numberToAddress;
17     
18     uint public currentBet = 0.005 ether;
19     address public contractAddress;
20     address public owner;
21     address public lastWinner;
22     
23     modifier onlyOwner() {
24         require(msg.sender == owner);
25         _;
26     }
27     
28     function transferOwnership(address newOwner) public onlyOwner {
29         require(newOwner != address(0));
30         emit OwnershipTransferred(owner, newOwner);
31         owner = newOwner;
32     }
33     
34     modifier noPendingBets {
35         require(playerCount[contractAddress] == 0);
36         _;
37     }
38     
39     function changeBet(uint _newBet) public noPendingBets onlyOwner {
40         currentBet = _newBet;
41     }
42     
43     function AllForOne() {
44         contractAddress = this;
45         currentGame[contractAddress]++;
46         currentPlayersRequired[contractAddress] = 100;
47         owner = msg.sender;
48         currentBet = 0.005 ether;
49         lastWinner = msg.sender;
50     }
51     
52     function canBet() view public returns (uint, uint, address) {
53         uint _status = 0;
54         uint _playerCount = playerCount[contractAddress];
55         address _lastWinner = lastWinner;
56         if (playerRegistrationStatus[msg.sender] < currentGame[contractAddress]) {
57         _status = 1;
58         }
59         return (_status, _playerCount, _lastWinner);
60     }
61     
62     modifier betCondition(uint _input) {
63         require (playerRegistrationStatus[msg.sender] < currentGame[contractAddress]);
64         require (playerCount[contractAddress] < 100);
65         require (msg.value == currentBet);
66         require (_input > 0 && _input != 0);
67         _;
68     }
69     
70     function placeBet (uint _input) payable betCondition(_input) {
71         playerNumber[msg.sender] = 0;
72         playerCount[contractAddress]++;
73         playerRegistrationStatus[msg.sender] = currentGame[contractAddress];
74         uint _playerKey = uint(keccak256(_input + now)) / now;
75         playerKey[contractAddress] += _playerKey;
76         playerNumber[msg.sender] = playerCount[contractAddress];
77         numberToAddress[playerNumber[msg.sender]] = msg.sender;
78             if (playerCount[contractAddress] == currentPlayersRequired[contractAddress]) {
79                 currentGame[contractAddress]++;
80                 uint _winningNumber = uint(keccak256(now + playerKey[contractAddress])) % 100 + 1;
81                 address _winningAddress = numberToAddress[_winningNumber];
82                 _winningAddress.transfer(currentBet * 99);
83                 owner.transfer(currentBet * 1);
84                 lastWinner = _winningAddress;
85                 playerKey[contractAddress] = 0;
86                 playerCount[contractAddress] = 0;
87             }
88         }
89 }