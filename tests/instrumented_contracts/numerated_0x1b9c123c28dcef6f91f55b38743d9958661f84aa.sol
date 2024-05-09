1 pragma solidity ^0.4.15;
2 contract Emoz {
3  uint256 constant private STARTING_PRICE = 0.005 ether;
4  address private cO;
5  mapping (uint256 => address) public onrs;
6  mapping (uint256 => string ) public urls;
7  mapping (uint256 => uint256) private prcs;
8  mapping (uint256 => uint256) public tyms;
9  event Upd(uint256 c, string url, address onr, uint256 prc, uint256 tym);
10  function Emoz() public {
11   cO = msg.sender;
12  }
13  function() public payable {
14  }
15  function prc(uint256 c) constant external returns(uint256) {
16   uint256 p = prcs[c];
17   return p > 0 ? p : STARTING_PRICE;
18  }
19  function buy(uint256 c, string url) external payable {
20   uint256 p = prcs[c];
21   if(p == 0) p = STARTING_PRICE;
22   require (msg.value >= p);
23   address pO = onrs[c];
24   uint256 nP = p << 1;
25   prcs[c] = nP;
26   onrs[c] = msg.sender;
27   urls[c] = url;
28   tyms[c] = now;
29   Upd(c, url, msg.sender, nP, now);
30   if(pO != address(0)) {
31    pO.transfer((3 * p) / 5);
32   }
33   cO.transfer(this.balance);
34  }
35  function ban(uint256 c) external {
36   require (msg.sender == cO);
37   delete urls[c];
38   Upd(c, "", onrs[c], prcs[c], tyms[c]);
39  }
40 }