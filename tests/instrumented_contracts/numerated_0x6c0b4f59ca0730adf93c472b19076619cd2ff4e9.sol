1 pragma solidity ^0.4.24;
2 
3 contract ERC {
4   function balanceOf (address) public view returns (uint256);
5   function allowance (address, address) public view returns (uint256);
6   function transfer (address, uint256) public returns (bool);
7   function transferFrom (address, address, uint256) public returns (bool);
8   function transferAndCall(address, uint256, bytes) public payable returns (bool);
9   function approve (address, uint256) public returns (bool);
10 }
11 
12 contract FsTKerWallet {
13 
14   string constant public walletVersion = "v1.0.0";
15 
16   ERC public FST;
17 
18   address public owner;
19   bytes32 public secretHash;
20   uint256 public sn;
21 
22   modifier onlyOwner {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   constructor (ERC _FST, bytes32 _secretHash, uint256 _sn) public {
28     FST = _FST;
29     secretHash = _secretHash;
30     sn = _sn;
31   }
32 
33   function getFSTBalance () public view returns (uint256) {
34     return FST.balanceOf(address(this));
35   }
36 
37   function getETHBalance () public view returns (uint256) {
38     return address(this).balance;
39   }
40 
41   function getERCBalance (ERC erc) public view returns (uint256) {
42     return erc.balanceOf(address(this));
43   }
44 
45   function transferETH (address _to, uint256 _value) onlyOwner public returns (bool) {
46     _to.transfer(_value);
47     return true;
48   }
49 
50   function transferMoreETH (address _to, uint256 _value) onlyOwner payable public returns (bool) {
51     _to.transfer(_value);
52     return true;
53   }
54 
55   function transferFST (address _to, uint256 _value) onlyOwner public returns (bool) {
56     return FST.transfer(_to, _value);
57   }
58 
59   function transferERC (ERC erc, address _to, uint256 _value) onlyOwner public returns (bool) {
60     return erc.transfer(_to, _value);
61   }
62 
63   function transferFromFST (address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
64     return FST.transferFrom(_from, _to, _value);
65   }
66 
67   function transferFromERC (ERC erc, address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
68     return erc.transferFrom(_from, _to, _value);
69   }
70 
71   function transferAndCallFST (address _to, uint256 _value, bytes _data) onlyOwner payable public returns (bool) {
72     require(FST.transferAndCall.value(msg.value)(_to, _value, _data));
73     return true;
74   }
75 
76   function transferAndCallERC (ERC erc, address _to, uint256 _value, bytes _data) onlyOwner payable public returns (bool) {
77     require(erc.transferAndCall.value(msg.value)(_to, _value, _data));
78     return true;
79   }
80 
81   function approveFST (address _spender, uint256 _value) onlyOwner public returns (bool) {
82     return FST.approve(_spender, _value);
83   }
84 
85   function approveERC (ERC erc, address _spender, uint256 _value) onlyOwner public returns (bool) {
86     return erc.approve(_spender, _value);
87   }
88 
89   function recoverAndSetSecretHash (string _secret, bytes32 _newSecretHash) public returns (bool) {
90     require(_newSecretHash != bytes32(0));
91     require(keccak256(abi.encodePacked(_secret)) == secretHash);
92     owner = msg.sender;
93     secretHash = _newSecretHash;
94     return true;
95   }
96 
97   function setFST (ERC _FST) onlyOwner public returns (bool) {
98     require(address(_FST) != address(this) && address(_FST) != address(0x0));
99     FST = _FST;
100     return true;
101   }
102 
103   function callContract(address to, bytes data) onlyOwner public payable returns (bool) {
104     require(to.call.value(msg.value)(data));
105     return true;
106   }
107 
108   function () external payable {}
109 
110 }