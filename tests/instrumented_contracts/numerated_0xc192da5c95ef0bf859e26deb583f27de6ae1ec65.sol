1 pragma solidity ^0.4.24;
2  
3 contract GoodsInfo{
4     struct Goods{
5       string info;
6       bool isVaild;
7     }
8     mapping (uint => Goods) goodsInfoMap;
9     address owner;
10     constructor(address a) public{
11         owner = a;
12     }
13     function record(uint i,string info) public{
14         require(msg.sender == owner);
15         require(goodsInfoMap[i].isVaild == false);
16         goodsInfoMap[i].info = info;
17         goodsInfoMap[i].isVaild = true;
18     }
19     function getRecordById(uint i) constant public returns (string){
20         return goodsInfoMap[i].info;
21     }
22 }