1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract SecretKeeper {
4   struct SecretMessage {
5     uint256 startTimeStamp;
6     uint256 period;
7     string message;
8   }
9   mapping(address => SecretMessage) private keeper;
10 
11   function setMessage(uint256 period , string memory message ) public {
12     keeper[msg.sender] = SecretMessage(now, period, message);
13   }
14   function getMessage(address msgOwner) public view returns (string memory){
15     if (keeper[msgOwner].startTimeStamp + keeper[msgOwner].period * 60 * 60 < now) {
16       return keeper[msgOwner].message;
17     }else{
18       return "";
19     }
20   }
21 }