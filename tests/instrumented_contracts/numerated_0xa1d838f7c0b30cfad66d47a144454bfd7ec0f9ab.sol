1 pragma solidity ^0.4.24;
2 
3 contract Tokens {
4     address[] public tokens;
5     address public owner;
6 
7     constructor() public {
8         owner = 0x5fa344f3B7AfD345377A37B62Ce87DDE01c1D414;
9     }
10 
11     function changeOwner(address _owner) public {
12         require(msg.sender == owner);
13         owner = _owner;      
14     }
15 
16     function addToken(address _address) public {
17         require(msg.sender == owner);
18         tokens.push(_address);
19     }
20 
21     function deleteToken(uint _tokenId) public {
22         require(msg.sender == owner);
23         delete tokens[_tokenId];      
24     }
25 
26     function getTokensCount() public view returns(uint) {
27         return tokens.length;
28     }
29 }