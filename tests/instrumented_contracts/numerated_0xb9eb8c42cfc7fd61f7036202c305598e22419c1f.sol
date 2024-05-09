1 pragma solidity ^0.5.8;
2 
3 /*
4     IdeaFeX Token multi-send contract
5 
6     Deployed to     : 0xB9eB8c42Cfc7fD61F7036202c305598E22419c1F
7     IFX token       : 0x2CF588136b15E47b555331d2f5258063AE6D01ed
8 */
9 
10 
11 /* ERC20 standard interface */
12 
13 contract ERC20Interface {
14     function totalSupply() external view returns (uint);
15     function balanceOf(address account) external view returns (uint);
16     function allowance(address owner, address spender) external view returns (uint);
17     function transfer(address recipient, uint amount) external returns (bool);
18     function approve(address spender, uint amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
20 
21     event Transfer(address indexed sender, address indexed recipient, uint value);
22     event Approval(address indexed owner, address indexed spender, uint value);
23 }
24 
25 
26 /* Owned contract */
27 
28 contract Ownable {
29     address private _owner;
30 
31     constructor () internal {
32         _owner = msg.sender;
33     }
34 
35     function owner() public view returns (address) {
36         return _owner;
37     }
38 
39     modifier onlyOwner() {
40         require(isOwner(), "Only the owner can use this contract");
41         _;
42     }
43 
44     function isOwner() public view returns (bool) {
45         return msg.sender == _owner;
46     }
47 }
48 
49 
50 /* Multi send */
51 
52 contract IFXmulti is Ownable {
53     ERC20Interface private _IFX = ERC20Interface(0x2CF588136b15E47b555331d2f5258063AE6D01ed);
54 
55     function multisend(address[] memory addresses, uint[] memory values) public onlyOwner {
56         uint i = 0;
57         while (i < addresses.length) {
58            _IFX.transfer(addresses[i], values[i]);
59            i += 1;
60         }
61     }
62 }