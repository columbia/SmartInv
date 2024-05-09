1 pragma solidity ^0.4.21;
2 contract owned {
3     address public owner;
4     event Log(string s);
5 
6     constructor()payable public {
7         owner = msg.sender;
8     }
9     function fallback() public payable{
10         revert();
11     }
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19     function isOwner()public{
20         if(msg.sender==owner)emit Log("Owner");
21         else{
22             emit Log("Not Owner");
23         }
24     }
25 }
26 contract verifier is owned{
27     struct action {
28         uint timestamp;
29         uint256 value;
30         address from;
31     }
32     mapping(string => mapping(uint => action))register;
33     mapping(string => uint256)transactionCount;
34     
35     event actionLog(uint timestamp, uint256 value,address from);
36     event Blog(string);
37     
38     constructor()public payable{
39     }
40     function registerTransaction(string neo,address ethA,uint256 value)internal{
41         register[neo][transactionCount[neo]]=action(now,value,ethA);
42         transactionCount[neo]+=1;
43     }
44     function verifyYourself(string neo, uint256 value)public payable{
45         registerTransaction(neo,msg.sender,value);
46     }
47     function viewAll(string neo)public onlyOwner{
48         uint i;
49         for(i=0;i<transactionCount[neo];i++){
50             emit actionLog(register[neo][i].timestamp,
51                         register[neo][i].value,
52                         register[neo][i].from);
53         }
54     }
55     function viewSpecific(string neo, uint256 index)public onlyOwner{
56         emit actionLog(register[neo][index].timestamp,
57                         register[neo][index].value,
58                         register[neo][index].from);
59     }
60 }