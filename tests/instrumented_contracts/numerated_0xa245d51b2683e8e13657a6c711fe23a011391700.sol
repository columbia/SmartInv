1 pragma solidity ^0.4.10;
2 contract Ownable {
3   address public owner;
4 
5   function Ownable() {
6     owner = msg.sender;
7   }
8 
9   modifier onlyOwner() {
10     if (msg.sender == owner)
11       _;
12   }
13 
14   function transferOwnership(address newOwner) onlyOwner {
15     if (newOwner != address(0)) owner = newOwner;
16   }
17 
18 }
19 
20 contract wLogoVote {
21 	function claimReward(address _receiver);
22 }
23 
24 contract Logo is Ownable{
25 
26 	wLogoVote public logoVote;
27 
28 	address public author;
29 	string public metadataUrl;
30 
31 	event ReceiveTips(address _from, uint _value);
32 
33 	function Logo(address _owner, address _author, string _metadatUrl){
34 		owner = _owner;
35 		author = _author;
36 		metadataUrl = _metadatUrl;
37 		logoVote = wLogoVote(msg.sender);
38 	}
39 
40 	function tips() payable {
41 		ReceiveTips(msg.sender, msg.value);
42 		if(!author.send(msg.value)) throw;
43 	}
44 
45 	function claimReward() onlyOwner {
46 		logoVote.claimReward(author);
47 	}
48 
49 	function setMetadata(string _metadataUrl) onlyOwner {
50 		metadataUrl = _metadataUrl;
51 	}
52 
53 	function () payable {
54 		tips();
55 	}
56 }