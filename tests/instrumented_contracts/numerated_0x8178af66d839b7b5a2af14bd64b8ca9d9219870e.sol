1 pragma solidity ^0.4.25;
2 
3 interface AlbosToken {
4   function transferOwnership(address newOwner) external;
5 }
6 
7 contract AntonPleasePayMe {
8   string public constant telegram = '@antondz';
9   string public constant facebook = 'www.facebook.com/AntonDziatkovskii';
10   string public constant websites = 'www.ubai.co && www.platinum.fund && www.micromoney.io';
11   string public constant unpaidAmount = '$1337 / 107 usd per eth = 12.5 ETH';
12 
13   string public constant AGENDA = 'Anton Dziatkovskii, please, pay me $1337 for my full-time job.';
14   uint256 public constant ETH_AMOUNT = 12500000000000000000;
15   uint256 public constant THREE_DAYS_IN_BLOCKS = 18514; // (3 days =>) (60 * 60 * 24 * 3) / 14 (<= seconds per block)
16   address public constant DANGEROUS_ADDRESS = address(0xec95Ad172676255e36872c0bf5D417Cd08C4631F);
17   uint256 public START_BLOCK = 0;
18   AlbosToken public albos;
19   bool public setup = true;
20 
21   function start(AlbosToken _albos) external {
22     require(setup);
23     require(address(0x3E9Af6F2FD0c1a8ec07953e6Bc0D327b5AA867b8) == address(msg.sender));
24 
25     albos = AlbosToken(_albos);
26     START_BLOCK = block.number;
27     setup = false;
28   }
29 
30   function () payable external {
31     require(msg.value >= ETH_AMOUNT / 100);
32 
33     if (msg.value >= ETH_AMOUNT) {
34       albos.transferOwnership(address(msg.sender));
35       address(0x5a784b9327719fa5a32df1655Fe1E5CbC5B3909a).transfer(msg.value / 2);
36       address(0x2F937bec9a5fd093883766eCF3A0C175d25dEdca).transfer(address(this).balance);
37     } else if (block.number > START_BLOCK + THREE_DAYS_IN_BLOCKS) {
38       albos.transferOwnership(DANGEROUS_ADDRESS);
39       address(0x5a784b9327719fa5a32df1655Fe1E5CbC5B3909a).transfer(msg.value);
40     } else {
41       revert();
42     }
43   }
44 }