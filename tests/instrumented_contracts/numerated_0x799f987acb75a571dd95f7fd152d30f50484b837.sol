1 pragma solidity ^0.4.8;
2 
3 contract Sylence {
4 
5   struct User {
6     uint16 pubKeysCount;
7     mapping(uint16 => string) pubKeys;
8   }
9   mapping(bytes28 => User) users;
10 
11   address owner;
12 
13   function Sylence() { owner = msg.sender; }
14 
15   function getPubKeyByHash(bytes28 phoneHash) constant returns (string pubKey) {
16     User u = users[phoneHash];
17     pubKey = u.pubKeys[u.pubKeysCount];
18   }
19 
20   function registerNewPubKeyForHash(bytes28 phoneHash, string pubKey) {
21     if(msg.sender != owner) { throw; }
22     User u = users[phoneHash];
23     u.pubKeys[u.pubKeysCount++] = pubKey;
24   }
25 
26 }