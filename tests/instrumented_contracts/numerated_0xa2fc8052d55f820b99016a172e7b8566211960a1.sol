1 pragma solidity ^0.4.0;
2 
3 contract HelpYouHateEth{
4     address me;
5     hate max_hate;
6     
7     struct hate{
8         address you;
9         uint256 how_much_you_hate;
10         string your_words;
11     }
12    
13     constructor() public {
14         me = msg.sender;
15     }
16     
17     function sayYouHateEth(string words) public payable {
18         if (msg.value > max_hate.how_much_you_hate){
19             hate memory your_hate;
20             your_hate.you = msg.sender;
21             your_hate.how_much_you_hate = msg.value;
22             your_hate.your_words = words;
23         
24             max_hate = your_hate;
25         }
26     }
27     
28     function listen() public {
29         if (msg.sender == me) {
30             address(me).transfer(address(this).balance);
31         }
32     }
33     
34     function whoHateMost() constant public returns (address, uint256, string){
35         return (max_hate.you,max_hate.how_much_you_hate,max_hate.your_words);
36     }
37     
38     function () public payable {
39     }
40 }