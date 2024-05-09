1 pragma solidity ^0.4.23;
2 
3 // File: contracts/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts/Ownerable.sol
18 
19 contract Ownerable {
20     /// @notice The address of the owner is the only address that can call
21     ///  a function with this modifier
22     modifier onlyOwner { require(msg.sender == owner); _; }
23 
24     address public owner;
25 
26     constructor() public { owner = msg.sender;}
27 
28     /// @notice Changes the owner of the contract
29     /// @param _newOwner The new owner of the contract
30     function setOwner(address _newOwner) public onlyOwner {
31         owner = _newOwner;
32     }
33 }
34 
35 // File: contracts/RegXAddr.sol
36 
37 contract RegXAddr is Ownerable {
38 
39   bool public registable;
40   ERC20Basic private atxToken;
41 
42   address[] public ethAddrs;
43   mapping (address => address) public eth2xbc;
44 
45   constructor () public {
46     atxToken = ERC20Basic(0x1A0F2aB46EC630F9FD638029027b552aFA64b94c);
47   }
48 
49   function setRegistable(bool _registable) public onlyOwner {
50     registable = _registable;
51   }
52 
53   function registeredCount() public view returns (uint256) {
54     return ethAddrs.length;
55   }
56   
57   function xbc2eth(address _xaddr) public view returns (address) {
58     require(_xaddr != 0x0);
59       
60     for(uint i=0; i<ethAddrs.length; i++) {
61       if(eth2xbc[ethAddrs[i]] == _xaddr) {
62 	return ethAddrs[i];
63       }
64     }
65     return 0x0;
66   }
67 
68   function registerXAddress (address _xaddr) public returns (bool){
69     require(registable);
70     require(_xaddr != 0x0);
71     require(msg.sender != 0x0);
72 
73     uint256 atxBalance = atxToken.balanceOf(msg.sender);
74     require(atxBalance > 0);
75       
76     if(eth2xbc[msg.sender] == 0x0) {
77       ethAddrs.push(msg.sender);
78     }
79     eth2xbc[msg.sender] = _xaddr;
80 
81     emit RegisterXAddress(msg.sender, _xaddr, atxBalance);
82     return true;
83   }
84 
85   function reset() public onlyOwner {
86     for(uint i=0; i<ethAddrs.length; i++) {
87       delete eth2xbc[ ethAddrs[i] ];
88     }
89     delete ethAddrs;
90   }
91 
92 
93   event RegisterXAddress (address indexed ethaddr, address indexed xbcaddr, uint256 balance);
94 }