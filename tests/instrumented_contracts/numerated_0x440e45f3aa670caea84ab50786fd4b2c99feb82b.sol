1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4     address owner;
5     
6     function Owned() public {
7         owner = msg.sender;
8     }
9     
10    modifier onlyOwner {
11        require(msg.sender == owner);
12        _;
13    }
14 }
15 
16 contract Aeromart is Owned {
17     
18     struct Note {
19         bytes20 serialNumber;
20         string text;
21     }
22     
23     uint public notesLength;
24     mapping (uint256 => Note) public notes;
25     
26     event noteInfo(
27        bytes20 serialNumber,
28        string text
29     );
30     
31     function addNote(bytes20 _serialNumber, string _text) onlyOwner public returns (uint) {
32         var note = notes[notesLength];
33         
34         note.serialNumber = _serialNumber;
35         note.text = _text;
36         
37         noteInfo(_serialNumber, _text);
38         
39         notesLength++;
40         return notesLength;
41     }
42     
43     function setNote(uint256 _id, bytes20 _serialNumber, string _text) onlyOwner public {
44         var note = notes[_id];
45         
46         note.serialNumber = _serialNumber;
47         note.text = _text;
48         
49         // notesAccts.push(_id) -1;
50         noteInfo(_serialNumber, _text);
51     }
52     
53     function getNote(uint256 _id) view public returns (bytes20, string) {
54         return (notes[_id].serialNumber, notes[_id].text);
55     }
56     
57     
58 }