1 pragma solidity ^0.4.16;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6     modifier onlyOwner { assert(msg.sender == owner); _; }
7 
8     event OwnerUpdate(address _prevOwner, address _newOwner);
9 
10     function Owned() {
11         owner = msg.sender;
12     }
13 
14     function transferOwnership(address _newOwner) public onlyOwner {
15         require(_newOwner != owner);
16         newOwner = _newOwner;
17     }
18 
19     function acceptOwnership() public {
20         require(msg.sender == newOwner);
21         OwnerUpdate(owner, newOwner);
22         owner = newOwner;
23         newOwner = 0x0;
24     }
25 }
26 
27 
28 contract ERC20Basic {
29   uint public totalSupply;
30   function balanceOf(address who) constant returns (uint);
31   function transfer(address to, uint value);
32   event Transfer(address indexed from, address indexed to, uint value);
33 }
34 
35 
36 contract ERC20 is ERC20Basic {
37   function allowance(address owner, address spender) constant returns (uint);
38   function transferFrom(address from, address to, uint value);
39   function approve(address spender, uint value);
40   event Approval(address indexed owner, address indexed spender, uint value);
41 }
42 
43 
44 contract wolkair is Owned {
45     address public constant wolkAddress = 0x728781E75735dc0962Df3a51d7Ef47E798A7107E;
46     function multisend(address[] dests, uint256[] values) onlyOwner returns (uint256) {
47         uint256 i = 0;
48         require(dests.length == values.length);
49         while (i < dests.length) { 
50            ERC20(wolkAddress).transfer(dests[i], values[i] * 10**18);
51            i += 1;
52         }
53         return(i);
54     }
55 }