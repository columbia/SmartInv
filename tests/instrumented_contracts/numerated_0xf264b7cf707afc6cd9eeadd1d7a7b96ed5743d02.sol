1 pragma solidity ^0.4.24;
2 
3 contract Tokens {
4     struct Token {
5         address _address;
6         string _websiteUrl;
7     }
8     
9     Token[] public tokens;
10     address public owner;
11 
12     constructor() public {
13         owner = 0x5fa344f3B7AfD345377A37B62Ce87DDE01c1D414;
14     }
15 
16     function changeOwner(address _owner) public {
17         require(msg.sender == owner);
18         owner = _owner;      
19     }
20 
21     function addToken(address _address, string _websiteUrl) public {
22         require(msg.sender == owner);
23         tokens.push(Token(_address, _websiteUrl));
24     }
25 
26     function deleteToken(uint _tokenId) public {
27         require(msg.sender == owner);
28         delete tokens[_tokenId];      
29     }
30 
31     function getTokensCount() public view returns(uint) {
32         return tokens.length;
33     }
34 }