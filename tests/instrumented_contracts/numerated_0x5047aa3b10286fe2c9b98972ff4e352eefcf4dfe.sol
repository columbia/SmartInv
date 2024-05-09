1 // File: RockHelper.sol
2 
3 pragma solidity ^0.8.0;
4 
5 abstract contract EtherRock {
6     function buyRock (uint rockNumber) virtual public payable;
7     function sellRock (uint rockNumber, uint price) virtual public;
8     function giftRock (uint rockNumber, address receiver) virtual public;
9     function rocks(uint rockNumber) virtual public view returns (address, bool, uint, uint);
10 }
11 
12 abstract contract Wrapper {
13     function wrap(uint256 id) virtual public;
14     function createWarden() virtual public;
15     function wardens(address owner) virtual public view returns (address);
16     function transferFrom(address from, address to, uint256 tokenId) public virtual;
17 }
18 
19 contract RockHelper {
20   EtherRock rocks = EtherRock(0x37504AE0282f5f334ED29b4548646f887977b7cC);
21   Wrapper wrapper = Wrapper(0x39b780E8062CE299ab60ed3D48F447e97511a2eD);
22   address public warden;
23   
24   mapping (uint256 => address) public owners;
25   
26   constructor() {
27     wrapper.createWarden(); 
28     warden = wrapper.wardens(address(this));
29   }
30   
31   function register(uint256 id) public {
32     (address owner,,,) = rocks.rocks(id);
33     require(id > 99 && id < 10000);
34     require(owner != warden);
35     require(owner != address(wrapper));
36     owners[id] = owner;
37   }
38   
39   function registerMany(uint256[] memory ids) public {
40     for (uint256 i = 0; i < ids.length; i++) {
41       register(ids[i]); 
42     }
43   }
44   
45   function wrap(uint256 id) public {
46     address owner = owners[id];
47     require(owner != address(0));
48     wrapper.wrap(id);
49     wrapper.transferFrom(address(this), owner, id);
50   }
51   
52   function wrapMany(uint256[] memory ids) public {
53     for (uint256 i = 0; i < ids.length; i++) {
54       wrap(ids[i]); 
55     }
56   }
57 }