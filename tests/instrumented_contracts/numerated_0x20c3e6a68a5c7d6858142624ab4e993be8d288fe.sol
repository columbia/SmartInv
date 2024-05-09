1 pragma solidity ^0.4.10;
2 
3 // A simple decentralized guestbook.
4 contract Guestbook {
5   address creator;
6 
7   event Post(address indexed _from, string _name, string _body);
8 
9   function Guestbook() {
10     creator = msg.sender;
11   }
12 
13   function post(string _name, string _body) {
14     require(bytes(_name).length > 0);
15     require(bytes(_body).length > 0);
16 
17     Post(msg.sender, _name, _body);
18   }
19 
20   function destroy() {
21     require(msg.sender == creator);
22 
23     selfdestruct(creator);
24   }
25 }