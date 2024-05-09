1 pragma solidity ^0.4.6;
2 contract FileStorage {	
3 	address owner;
4 	mapping (bytes32=>File[]) public files;
5 	
6 	struct File {
7 		string title;		
8 		string category;	
9 		string extension;	
10 		string created;		
11 		string updated;	
12 		uint version;	
13 		bytes data;			
14 	}
15 
16     function FileStorage() {
17         owner = msg.sender;
18     }
19     
20     function Kill() {
21         if (msg.sender == owner)
22         selfdestruct(owner);
23     }
24 
25 	function StoreFile(bytes32 key, string title, string category, string extension, string created, string updated, uint version, bytes data)
26 	payable returns (bool success) {
27 	    var before = files[key].length;	
28 		var file = File(title, category, extension, created, updated, version, data);	
29 		files[key].push(file);	
30 			
31 		if (files[key].length > before) {	
32 			owner.send(this.balance);
33 			return true;
34 		} else {
35 			msg.sender.send(this.balance);
36 			return false;
37 		}
38 
39 	}
40 	
41 	
42 	function GetFileLocation(bytes32 key) constant returns (uint Loc) {
43 		return files[key].length -1;	
44 	}
45 	
46 	function() {
47 	    throw;
48 	}
49 }