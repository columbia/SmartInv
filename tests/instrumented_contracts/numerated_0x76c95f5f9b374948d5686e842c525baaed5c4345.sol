1 pragma solidity ^0.4.15;
2 
3 contract EthPixel {
4     struct Pixel {
5         bytes32 color;
6         uint256 amount;
7         address holder;
8     }
9 
10     Pixel [1000000] public pixels;
11 
12     event PixelBought(uint256 coordinates, bytes32 color, uint256 amount, address holder, address boughtFrom);
13 
14     function buyPixel(uint256 _coordinates, bytes32 _color) payable returns (bool) {
15         require(msg.value > 0);
16         require(_color.length > 0);
17 
18         Pixel memory pixel = pixels[_coordinates];
19 
20         require(msg.value > pixel.amount);
21         require(msg.sender != pixel.holder);
22 
23         if (pixel.amount > 0) {
24             pixel.holder.transfer(pixel.amount);
25         }
26 
27         pixels[_coordinates] = Pixel({
28             color: _color,
29             amount: msg.value,
30             holder: msg.sender
31         });
32 
33         PixelBought(_coordinates, _color, msg.value, msg.sender, pixel.holder);
34 
35         return true;
36     }
37 }