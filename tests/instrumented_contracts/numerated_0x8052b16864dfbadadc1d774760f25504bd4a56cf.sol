1 pragma solidity 0.4.18;
2 
3 interface ERC20 {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8     function allowance(address owner, address spender) public view returns (uint256);
9     function transferFrom(address from, address to, uint256 value) public returns (bool);
10     function approve(address spender, uint256 value) public returns (bool);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 interface IMaker {
15     function sai() public view returns (ERC20);
16     function skr() public view returns (ERC20);
17     function gem() public view returns (ERC20);
18 
19     function open() public returns (bytes32 cup);
20     function give(bytes32 cup, address guy) public;
21 
22     function ask(uint wad) public view returns (uint);
23 
24     function join(uint wad) public;
25     function lock(bytes32 cup, uint wad) public;
26     function free(bytes32 cup, uint wad) public;
27     function draw(bytes32 cup, uint wad) public;
28     function cage(uint fit_, uint jam) public;
29 }
30 
31 interface IWETH {
32     function deposit() public payable;
33     function withdraw(uint wad) public;
34 }
35 
36 
37 contract DaiMaker {
38     IMaker public maker;
39     ERC20 public weth;
40     ERC20 public peth;
41     ERC20 public dai;
42 
43     event MakeDai(address indexed daiOwner, address indexed cdpOwner, uint256 ethAmount, uint256 daiAmount);
44 
45     function DaiMaker(IMaker _maker) {
46         maker = _maker;
47         weth = maker.gem();
48         peth = maker.skr();
49         dai = maker.sai();
50     }
51 
52     function makeDai(uint256 daiAmount, address cdpOwner, address daiOwner) payable public returns (bytes32 cdpId) {
53         IWETH(weth).deposit.value(msg.value)();     // wrap eth in weth token
54         weth.approve(maker, msg.value);             // allow maker to pull weth
55 
56         maker.join(maker.ask(msg.value));           // convert weth to peth
57         uint256 pethAmount = peth.balanceOf(this);
58         peth.approve(maker, pethAmount);            // allow maker to pull peth
59 
60         cdpId = maker.open();                       // create cdp in maker
61         maker.lock(cdpId, pethAmount);              // lock peth into cdp
62         maker.draw(cdpId, daiAmount);               // create dai from cdp
63 
64         dai.transfer(daiOwner, daiAmount);          // transfer dai to owner
65         maker.give(cdpId, cdpOwner);                // transfer cdp to owner
66 
67         MakeDai(daiOwner, cdpOwner, msg.value, daiAmount);
68     }
69 }