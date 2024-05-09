1 pragma solidity ^0.4.14;
2 
3 contract TheImmortalsPhoto {
4 	string public photoData;
5 	string public photoText;
6 	bool public deleted;
7 	address superContract;
8 	address owner;
9 
10 	function TheImmortalsPhoto(string _photoData, string _photoText, address _owner, address _superContract){
11         photoData = _photoData;
12         photoText = _photoText;
13         deleted = false;
14         superContract = _superContract;
15         owner = _owner;
16 	}
17 	
18 	function removeFace(){
19 	    require(msg.sender == owner || msg.sender == superContract);
20 	    photoData = "";
21 	    photoText = "";
22         deleted = true;
23 	}
24 }
25 
26 contract TheImmortals {
27     address public owner;
28     mapping (address => address[]) public immortals;
29     address[] public accounts;
30     uint8 public numberImmortals;
31     uint constant public maxImmortals = 5;
32     
33      modifier onlyOwner {
34         require(msg.sender == owner);
35         _;
36     }
37     
38     function TheImmortals() {
39         owner = msg.sender;
40     }
41 
42     event PhotoAdded(address indexed _from, address _contract);
43 
44     function addFace(string _photoData, string _photoText) payable {
45         require (msg.value >= 0.1 ether || msg.sender == owner);
46         require (numberImmortals <= maxImmortals);
47 
48         address newFace = new TheImmortalsPhoto(_photoData, _photoText, msg.sender, address(this));
49         immortals[msg.sender].push(newFace);
50         if (immortals[msg.sender].length == 1){
51           accounts.push(msg.sender);
52         }
53         numberImmortals++;
54 
55         PhotoAdded(msg.sender, newFace);
56     }
57 
58 	function deleteUser(address userAddress) onlyOwner {
59 	    for (uint8 i=0;i<immortals[userAddress].length;i++){
60 	        TheImmortalsPhoto faceContract = TheImmortalsPhoto(immortals[userAddress][i]);
61 	        faceContract.removeFace();
62             immortals[userAddress][i] = 0x0;
63 	    }
64 	}
65 	
66 	function withdraw() onlyOwner {
67 	    address myAddress = this;
68 	    owner.transfer(myAddress.balance);
69 	}
70 }