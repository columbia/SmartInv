1 pragma solidity ^0.4.2;
2 contract PixelMap {
3     address creator;
4     struct Tile {
5         address owner;
6         string image;
7         string url;
8         uint price;
9     }
10     mapping (uint => Tile) public tiles;
11     event TileUpdated(uint location);
12 
13     // Original Tile Owner
14     function PixelMap() {creator = msg.sender;}
15 
16     // Get Tile information at X,Y position.
17     function getTile(uint location) returns (address, string, string, uint) {
18         return (tiles[location].owner,
19                 tiles[location].image,
20                 tiles[location].url,
21                 tiles[location].price);
22     }
23 
24     // Purchase an unclaimed Tile for 2 Eth.
25     function buyTile(uint location) payable {
26         if (location > 3969) {throw;}
27         uint price = tiles[location].price;
28         address owner;
29 
30         // Make sure person doesn't already own tile.
31         if (tiles[location].owner == msg.sender) {
32             throw;
33         }
34 
35         // If Unowned by the Bank, sell for 2Eth.
36         if (tiles[location].owner == 0x0) {
37             price = 2000000000000000000;
38             owner = creator;
39         }
40         else {
41             owner = tiles[location].owner;
42         }
43         // If the tile isn't for sale, don't sell it!
44         if (price == 0) {
45             throw;
46         }
47 
48         // Pay for Tile.
49         if (msg.value != price) {
50             throw;
51         }
52         if (owner.send(price)) {
53             tiles[location].owner = msg.sender;
54             tiles[location].price = 0; // Set Price to 0.
55             TileUpdated(location);
56         }
57         else {throw;}
58     }
59 
60     // Set an already owned Tile to whatever you'd like.
61     function setTile(uint location, string image, string url, uint price) {
62         if (tiles[location].owner != msg.sender) {throw;} // Pixel not owned by you!
63         else {
64             tiles[location].image = image;
65             tiles[location].url = url;
66             tiles[location].price = price;
67             TileUpdated(location);
68         }
69     }
70 }