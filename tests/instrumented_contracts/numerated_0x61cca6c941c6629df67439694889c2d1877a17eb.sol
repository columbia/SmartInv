1 pragma solidity ^0.4.11;
2 
3 contract LockYourLove {
4 
5     struct  LoveItem {
6         address lovers_address;
7         uint block_number;
8         uint block_timestamp;
9         string love_message;
10         string love_url;
11     }
12   
13     address public owner;
14     
15     mapping (bytes32 => LoveItem) private mapLoveItems;
16 
17     uint public price;
18     uint public numLoveItems;
19     //bytes32 bb;
20     event EvLoveItemAdded(bytes32 indexed _loveHash, 
21                             address indexed _loversAddress, 
22                             uint _blockNumber, 
23                             uint _blockTimestamp,
24                             string _loveMessage,
25                             string _loveUrl);
26 	event EvNewPrice(uint blocknumber, uint newprice);
27 	                                
28     modifier onlyOwner()
29     {
30         require(msg.sender == owner);
31         _;
32     }
33     
34     // This is the constructor. It's payable so you can initialize the contract with funds during deploy
35     function LockYourLove () { // Constructor
36         owner = msg.sender;
37         price = 10000000000000000; // 0.01 ethers -> https://etherconverter.online
38         numLoveItems = 0;
39     }
40 
41     /*function stringToBytes32(string memory str) returns (bytes32 result) {
42         assembly {
43             result := mload(add(str, 32))
44         }
45     }
46 
47     function setBB (string str) { 
48        bb = stringToBytes32(str);
49     }
50 
51     function getBB () constant returns (bytes32 result) {
52        result = bb;
53     }*/
54     
55     function() payable { 
56         msg.sender.transfer(msg.value);
57     }
58 
59     function donateToLovers(bytes32 loveHash) payable returns (bool) {
60         require(msg.value > 0);
61         require(mapLoveItems[loveHash].lovers_address > 0);
62         mapLoveItems[loveHash].lovers_address.transfer(msg.value);
63     }
64 
65     function setPrice (uint newprice) onlyOwner { 
66         price = newprice;
67 		EvNewPrice(block.number, price);
68     }
69     
70 	function getPrice() constant returns  (uint){
71 		return price;
72 	}
73 
74 	function getNumLoveItems() constant returns  (uint){
75 		return numLoveItems;
76 	}
77 
78     // datacoord = userId_assurId
79     function addLovers(bytes32 love_hash, string lovemsg, string loveurl) payable {
80         
81         require(bytes(lovemsg).length < 250);
82 		require(bytes(loveurl).length < 100);
83 		require(msg.value >= price);
84         
85         mapLoveItems[love_hash] = LoveItem(msg.sender, block.number, block.timestamp, lovemsg, loveurl);
86         numLoveItems++;
87             
88         owner.transfer(price); 
89         
90         EvLoveItemAdded(love_hash, msg.sender, block.number, block.timestamp, lovemsg, loveurl);
91     }
92     
93     
94     function getLovers(bytes32 love_hash) constant returns  (address, uint, uint, string, string){
95         require(mapLoveItems[love_hash].block_number > 0);
96         
97         return (mapLoveItems[love_hash].lovers_address, mapLoveItems[love_hash].block_number, mapLoveItems[love_hash].block_timestamp,  
98                 mapLoveItems[love_hash].love_message, mapLoveItems[love_hash].love_url);
99     }
100     
101     
102     function destroy() onlyOwner { // so funds not locked in contract forever
103         selfdestruct(owner); // send funds to organizer
104     }
105 }