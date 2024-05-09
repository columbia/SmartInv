1 pragma solidity ^0.4.18;
2 contract TimeStampingAuthority {
3     
4     struct Entry {
5         address sender;
6         uint timestamp;
7         string note;
8     }
9 
10     mapping(bytes => Entry) entries;
11     
12     function submitEntry(bytes _hash, string note) public {
13         require(entries[_hash].timestamp == 0);
14         entries[_hash] = Entry(msg.sender, now, note);
15     }
16     
17     function getEntry(bytes _hash) public constant returns (address, uint, string) {
18         return (entries[_hash].sender, entries[_hash].timestamp, entries[_hash].note);
19     }
20 }