1 pragma solidity 0.4.24;
2 
3 contract JNS {
4     mapping (string => address) strToAddr;
5     mapping (address => string) addrToStr;
6     address private wallet;
7 
8     constructor (address _wallet) public {
9         require(_wallet != address(0), "You must inform a valid address");
10         wallet = _wallet;
11     }
12     
13     function registerAddress (string _nickname, address _address) public payable returns (bool) {
14         require (msg.value > 1000000000000000, "Send more money");
15         require (strToAddr[_nickname] == address(0), "Name already registered");
16         require (keccak256(addrToStr[_address]) == keccak256(""), "Address already registered");
17         
18         strToAddr[_nickname] = _address;
19         addrToStr[_address] = _nickname;
20 
21         wallet.transfer(msg.value);
22         return true;
23     }
24     
25     function getAddress (string _nickname) public view returns (address _address) {
26         _address = strToAddr[_nickname];
27     }
28     
29     function getNickname (address _address) public view returns (string _nickname) {
30         _nickname = addrToStr[_address];
31     }
32 }