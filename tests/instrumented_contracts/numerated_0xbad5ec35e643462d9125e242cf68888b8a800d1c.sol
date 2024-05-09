1 pragma solidity ^0.4.21;
2   
3 contract SaveData {
4     mapping (uint => string) sign;
5     address public owner;
6     event SetString(uint key,string types);
7     function SaveData() public {
8         owner = msg.sender;
9     }
10     function setstring(uint key,string md5) public returns(string){
11         sign[key]=md5;
12         return sign[key];
13     }
14 
15     function getString(uint key) public view returns(string){
16         return sign[key];
17     }
18 }