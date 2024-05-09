1 pragma solidity ^0.4.21;
2 interface SisterToken {function _buy(address _for)external payable;function testConnection() external;}
3 contract owned {
4     address public owner;
5     event Log(string s);
6 
7     function owned() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18     function isOwner()public{
19         if(msg.sender==owner)emit Log("Owner");
20         else{
21             emit Log("Not Owner");
22         }
23     }
24 }
25 contract Crowdsale is owned {
26     address public Nplay;
27     address public Eplay;
28     function Crowdsale() public payable{
29     }
30     function () public payable{
31         buy();
32     }
33     function setEplay(address newSS)public onlyOwner{
34         Eplay= newSS;
35     }
36     function setNplay(address newSS)public onlyOwner {
37         Nplay= newSS;
38     }
39     function buy()public payable{
40         SisterToken E = SisterToken(Eplay);
41         SisterToken N = SisterToken(Nplay);
42         E._buy.value(msg.value/2)(msg.sender);
43         N._buy.value(msg.value/2)(msg.sender);
44     }
45     function connectTest() public payable{
46         SisterToken S = SisterToken(Eplay);
47         SisterToken N = SisterToken(Nplay);
48         S.testConnection();
49         N.testConnection();
50     }
51 }