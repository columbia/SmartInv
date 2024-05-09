1 /**
2  * Source Code first verified at https://etherscan.io on Monday, April 15, 2019
3  (UTC) */
4 
5 pragma solidity ^0.5.8;
6 
7 contract ERC20Interface {
8     function balanceOf(address from) public view returns (uint256);
9     function transferFrom(address from, address to, uint tokens) public returns (bool);
10     function allowance(address owner, address spender) public view returns (uint256);
11     function burn(uint256 amount) public;
12 }
13 
14 
15 contract UsernameRegistry {
16 
17 event Register(address indexed _owner, bytes32 _name, bytes32 _userId);
18 
19 ERC20Interface public manaToken;
20 uint256 public price = 100000000000000000000;
21 mapping (bytes32 => address) nameToAddress;
22 mapping (bytes32 => address) userIdToAddress;
23 mapping (address => bytes32) public name;
24 address public owner;
25 
26 constructor(ERC20Interface _mana) public {
27     manaToken = _mana;
28     owner = msg.sender;
29 }
30 
31 modifier onlyOwner {
32     require(msg.sender == owner);
33     _;
34 }
35 
36 function registerUsername(address _targetAddress, bytes32 _name, bytes32 _userId) onlyOwner external {
37     _requireBalance();
38     require(isNameAvailable(_name), "The name was already taken");
39     require(isUserIdAvailable(_userId), "The userId already has a name");
40     
41     manaToken.transferFrom(_targetAddress, address(this), price);
42     manaToken.burn(price);
43 
44     nameToAddress[_name] = _targetAddress;
45     userIdToAddress[_userId] = _targetAddress;
46     name[_targetAddress] = _name;
47 
48     emit Register(_targetAddress, _userId, _name);
49 }
50 
51 function isNameAvailable(bytes32 _name) public view returns (bool) {
52     return nameToAddress[_name] == address(0);
53 }
54 function isUserIdAvailable(bytes32 _name) public view returns (bool) {
55     return userIdToAddress[_name] == address(0);
56 }
57 
58 // Lack of security (set only owner)
59 function setPrice(uint256 _price) onlyOwner public {
60     price = _price;
61 }
62 
63 function _requireBalance() internal view {
64     require(
65         manaToken.balanceOf(msg.sender) >= price,
66         "Insufficient funds"
67     );
68     require(
69         manaToken.allowance(msg.sender, address(this)) >= price,
70         "The contract is not authorized to use MANA on sender behalf"
71     );        
72 }
73 }