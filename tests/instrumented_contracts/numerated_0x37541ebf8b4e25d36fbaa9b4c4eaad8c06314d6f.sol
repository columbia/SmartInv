1 /**
2  * @title NumberLottery
3  * @dev NumberLottery contract starts with a random,
4  * hashed number that the player can try to guess. If the guess is correct,
5  * they receive the balance of the contract as a reward (including their bet).
6  * If they guess incorrectly, the contract keeps the player's bet amount. Have fun!
7  */
8  
9 contract NumberLottery 
10 {
11   // creates random number between 1 - 10 on contract creation
12   uint256 private  randomNumber = uint256( keccak256(now) ) % 10 + 1;
13   uint256 public prizeFund;
14   uint256 public minBet = 0.1 ether;
15   address owner = msg.sender;
16 
17   struct GameHistory 
18   {
19     address player;
20     uint256 number;
21   }
22   
23   GameHistory[] public log;
24 
25   modifier onlyOwner() 
26   {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   // 0.1 ether is a pretty good bet amount but if price changes, this will be useful
32   function changeMinBet(uint256 _newMinBet) 
33   external 
34   onlyOwner 
35   {
36     minBet = _newMinBet;
37   }
38 
39   function startGame(uint256 _number) 
40   public 
41   payable 
42   {
43       if(msg.value >= minBet && _number <= 10)
44       {
45           GameHistory gameHistory;
46           gameHistory.player = msg.sender;
47           gameHistory.number = _number;
48           log.push(gameHistory);
49           
50           // if player guesses correctly, transfer contract balance
51           // else the player's bet is automatically added to the reward / contract balance
52           if (_number == randomNumber) 
53           {
54               msg.sender.transfer(this.balance);
55           }
56           
57           randomNumber = uint256( keccak256(now) ) % 10 + 1;
58           prizeFund = this.balance;
59       }
60   }
61 
62   function withdaw(uint256 _am) 
63   public 
64   onlyOwner 
65   {
66     owner.transfer(_am);
67   }
68 
69   function() public payable { }
70 
71 }