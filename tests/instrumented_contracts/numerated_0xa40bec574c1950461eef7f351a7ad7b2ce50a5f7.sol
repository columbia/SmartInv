1 pragma solidity ^0.4.17;
2 
3 contract ENS {
4     address public owner;
5     mapping(string=>address)  ensmap;
6     mapping(address=>string)  addressmap;
7     
8     constructor() public {
9         owner = msg.sender;
10     }
11      //设置域名
12      function setEns(string newEns,address addr) onlyOwner public{
13           ensmap[newEns] = addr;
14           addressmap[addr] = newEns;
15      }
16      
17     //通过ens获取0x地址
18      function getAddress(string aens) view public returns(address) {
19            return ensmap[aens];
20      }
21 	 //通过address获取域名
22      function getEns(address addr) view public returns(string) {
23            return addressmap[addr];
24      }
25     //设置拥有者
26     function transferOwnership(address newOwner) onlyOwner public {
27         if (newOwner != address(0)) {
28             owner = newOwner;
29         }
30     }
31 
32      //仅仅拥有者 
33     modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37   
38 }