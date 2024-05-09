1 pragma solidity ^0.4.19;
2 
3 contract dappVolumeProfile {
4 
5 	mapping (address => string) public ownerAddressToName;
6 	mapping (address => string) public ownerAddressToUrl;
7 
8 	function setAccountNickname(string _nickname) public {
9 		require(msg.sender != address(0));
10 		require(bytes(_nickname).length > 0);
11 		ownerAddressToName[msg.sender] = _nickname;
12 	}
13 
14 	function setAccountUrl(string _url) public {
15 		require(msg.sender != address(0));
16 		require(bytes(_url).length > 0);
17 		ownerAddressToUrl[msg.sender] = _url;
18 	}
19 
20 }