1 pragma solidity 0.4.15;
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
17     uint price;
18     uint numLoveItems;
19     
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
34     function LockYourLove () { // Constructor
35         owner = msg.sender;
36         price = 10000000000000000; // 0.01 ethers -> https://etherconverter.online
37         numLoveItems = 0;
38     }
39     
40     function() payable { 
41         msg.sender.transfer(msg.value);
42     }
43 
44     function donateToLovers(bytes32 loveHash) payable returns (bool) {
45         require(msg.value > 0);
46         require(mapLoveItems[loveHash].lovers_address > 0);
47         mapLoveItems[loveHash].lovers_address.transfer(msg.value);
48     }
49 
50     function setPrice (uint newprice) onlyOwner { 
51         price = newprice;
52 		EvNewPrice(block.number, price);
53     }
54     
55 	function getPrice() constant returns  (uint){
56 		return price;
57 	}
58 
59 	function getNumLoveItems() constant returns  (uint){
60 		return numLoveItems;
61 	}
62 
63     // datacoord = userId_assurId
64     function addLovers(bytes32 love_hash, string lovemsg, string loveurl) payable {
65         
66         require(bytes(lovemsg).length < 250);
67 		require(bytes(loveurl).length < 100);
68 		require(msg.value >= price);
69         
70         mapLoveItems[love_hash] = LoveItem(msg.sender, block.number, block.timestamp, lovemsg, loveurl);
71         numLoveItems++;
72             
73         owner.transfer(price); 
74         
75         EvLoveItemAdded(love_hash, msg.sender, block.number, block.timestamp, lovemsg, loveurl);
76     }
77     
78     
79     function getLovers(bytes32 love_hash) constant returns  (address, uint, uint, string, string){
80         require(mapLoveItems[love_hash].block_number > 0);
81         
82         return (mapLoveItems[love_hash].lovers_address, mapLoveItems[love_hash].block_number, mapLoveItems[love_hash].block_timestamp,  
83                 mapLoveItems[love_hash].love_message, mapLoveItems[love_hash].love_url);
84     }
85     
86     
87     function destroy() onlyOwner { // so funds not locked in contract forever
88         selfdestruct(owner); // send funds to organizer
89     }
90 }