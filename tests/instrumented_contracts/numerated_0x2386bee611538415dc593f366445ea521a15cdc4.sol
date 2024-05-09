1 pragma solidity ^0.5.3;
2 
3 contract RNG {
4     //uint public nonce;
5     struct History{
6         uint time;
7         uint result;
8         address sender;
9         string description;
10     }
11     History[] public history;
12     event Result(uint time, uint result, address sender);
13     
14     function ByteToInt(bytes32 _number) public pure returns(uint num) {
15       return uint(_number);
16   }
17     
18     function GetResult(uint nonce, string memory desc, uint min, uint max) public returns(uint num){
19         require(msg.sender == 0x4769D2D7DDF8e75Ba0Fb09544fd0528498558fba);
20         bytes32 lottery = keccak256(abi.encodePacked(msg.sender, nonce, blockhash(block.number - 1)));
21         uint res = min + (ByteToInt(lottery) % max + 1);
22         history.push(History(now, res, msg.sender, desc));
23         emit Result(now, res, msg.sender);
24         return res;
25     }
26 
27 
28 }