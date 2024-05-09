1 pragma solidity ^0.4.24;
2 
3 contract Moods{
4 
5 address public owner;
6 string public currentMood;
7 mapping(string => bool) possibleMoods;
8 string[] public listMoods;
9 
10 constructor() public{
11     owner = msg.sender;
12     possibleMoods['?'] = true;
13     possibleMoods['?'] = true;
14     possibleMoods['?'] = true;
15     listMoods.push('?');
16     listMoods.push('?');
17     listMoods.push('?');
18     currentMood = '?';
19 }
20 
21 event moodChanged(address _sender, string _moodChange);
22 event moodAdded( string _newMood);
23 
24 function changeMood(string _mood) public payable{
25     
26     require(possibleMoods[_mood] == true);
27     
28     currentMood = _mood;
29     
30     emit moodChanged(msg.sender, _mood);
31 }
32 
33 function addMood(string newMood) public{
34     
35     require(msg.sender == owner);
36     
37     possibleMoods[newMood] = true;
38     listMoods.push(newMood);
39     
40     emit moodAdded(newMood);
41 }
42 
43 function numberOfMoods() public view returns(uint256){
44     return(listMoods.length);
45 }
46 
47 function withdraw() public {
48     require (msg.sender == owner);
49     msg.sender.transfer(address(this).balance);
50 }
51 
52 function() public payable {}
53 
54 }