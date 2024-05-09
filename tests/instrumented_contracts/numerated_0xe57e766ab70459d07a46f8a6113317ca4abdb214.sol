1 pragma solidity ^0.4.18;
2 
3 contract EtherealNotes {
4     
5     string public constant CONTRACT_NAME = "EtherealNotes";
6     string public constant CONTRACT_VERSION = "A";
7     string public constant QUOTE = "'When you stare into the abyss the abyss stares back at you.' -Friedrich Nietzsche";
8     
9     event Note(address sender,string indexed note);
10     function SubmitNote(string note) public{
11         Note(msg.sender, note);
12     }
13 }