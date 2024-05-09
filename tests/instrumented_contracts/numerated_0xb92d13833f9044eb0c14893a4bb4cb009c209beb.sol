1 pragma solidity ^0.4.18;
2 
3 contract PixelStorageWithFee {
4     event PixelUpdate(uint32 indexed index, uint8 color);
5     byte[500000] public packedBytes;
6     uint256 feeWei;
7     address masterAddress;
8 
9     function PixelStorageWithFee(uint256 startingFeeWei) public {
10         masterAddress = msg.sender;
11         feeWei = startingFeeWei;
12     }
13 
14     // Pixels are represented using 4-bits.  We pack 2 pixels into one byte like so:
15     // [left_pixel|right_pixel]
16     // To set these bytes, we use bitwise operations to change either the upper or
17     // lower half of a packed byte.
18     // [index] is the index of the pixel; not the byte
19     // [color] is a 4-bit integer; the upper 4 bits of the uint8 are discarded.
20 
21     function set(uint32 index, uint8 color) public payable {
22         require(index < 1000000);
23         require(msg.value >= feeWei);
24 
25         uint32 packedByteIndex = index / 2;
26         byte currentByte = packedBytes[packedByteIndex];
27         bool left = index % 2 == 0;
28 
29         byte newByte;
30         if (left) {
31             // clear upper 4 bits of existing byte
32             // OR with new byte shifted left 4 bits
33             newByte = (currentByte & hex'0f') | bytes1(color * 2 ** 4);
34         } else {
35             // clear lower 4 bits of existing byte
36             // OR with with new color, with upper 4 bits cleared
37             newByte = (currentByte & hex'f0') | (bytes1(color) & hex'0f');
38         }
39 
40         packedBytes[packedByteIndex] = newByte;
41         PixelUpdate(index, color);
42     }
43 
44     function getAll() public constant returns (byte[500000]) {
45         return packedBytes;
46     }
47 
48     modifier masterOnly() {
49         require(msg.sender == masterAddress);
50         _;
51     }
52 
53     function setFee(uint256 fee) public masterOnly {
54         feeWei = fee;
55     }
56 
57     function withdraw() public masterOnly {
58         masterAddress.transfer(this.balance);
59     }
60 
61     function() public payable { }
62 }